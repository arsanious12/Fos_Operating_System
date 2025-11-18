
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 08 00 00 00       	call   80003e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/,	//Stack
		0x81b000 /*for the text color variable*/} ;


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	}
	cprintf_colored(TEXT_light_green, "%~\nTest of KERNEL STACK & PAGE PLACEMENT completed. Eval = %d%\n\n", eval);

	return;
#endif
}
  80003b:	90                   	nop
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	57                   	push   %edi
  800042:	56                   	push   %esi
  800043:	53                   	push   %ebx
  800044:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800047:	e8 64 14 00 00       	call   8014b0 <sys_getenvindex>
  80004c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80004f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	c1 e0 06             	shl    $0x6,%eax
  800057:	29 d0                	sub    %edx,%eax
  800059:	c1 e0 02             	shl    $0x2,%eax
  80005c:	01 d0                	add    %edx,%eax
  80005e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800065:	01 c8                	add    %ecx,%eax
  800067:	c1 e0 03             	shl    $0x3,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800073:	29 c2                	sub    %eax,%edx
  800075:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80007c:	89 c2                	mov    %eax,%edx
  80007e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800084:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800089:	a1 60 30 80 00       	mov    0x803060,%eax
  80008e:	8a 40 20             	mov    0x20(%eax),%al
  800091:	84 c0                	test   %al,%al
  800093:	74 0d                	je     8000a2 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800095:	a1 60 30 80 00       	mov    0x803060,%eax
  80009a:	83 c0 20             	add    $0x20,%eax
  80009d:	a3 40 30 80 00       	mov    %eax,0x803040

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a6:	7e 0a                	jle    8000b2 <libmain+0x74>
		binaryname = argv[0];
  8000a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ab:	8b 00                	mov    (%eax),%eax
  8000ad:	a3 40 30 80 00       	mov    %eax,0x803040

	// call user main routine
	_main(argc, argv);
  8000b2:	83 ec 08             	sub    $0x8,%esp
  8000b5:	ff 75 0c             	pushl  0xc(%ebp)
  8000b8:	ff 75 08             	pushl  0x8(%ebp)
  8000bb:	e8 78 ff ff ff       	call   800038 <_main>
  8000c0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000c3:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8000c8:	85 c0                	test   %eax,%eax
  8000ca:	0f 84 01 01 00 00    	je     8001d1 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000d0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000d6:	bb d8 1c 80 00       	mov    $0x801cd8,%ebx
  8000db:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000e8:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000eb:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000f0:	b0 00                	mov    $0x0,%al
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8000f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8000fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80010a:	50                   	push   %eax
  80010b:	e8 d6 15 00 00       	call   8016e6 <sys_utilities>
  800110:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800113:	e8 1f 11 00 00       	call   801237 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	68 f8 1b 80 00       	push   $0x801bf8
  800120:	e8 be 01 00 00       	call   8002e3 <cprintf>
  800125:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800128:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012b:	85 c0                	test   %eax,%eax
  80012d:	74 18                	je     800147 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80012f:	e8 d0 15 00 00       	call   801704 <sys_get_optimal_num_faults>
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	50                   	push   %eax
  800138:	68 20 1c 80 00       	push   $0x801c20
  80013d:	e8 a1 01 00 00       	call   8002e3 <cprintf>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	eb 59                	jmp    8001a0 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800147:	a1 60 30 80 00       	mov    0x803060,%eax
  80014c:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800152:	a1 60 30 80 00       	mov    0x803060,%eax
  800157:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80015d:	83 ec 04             	sub    $0x4,%esp
  800160:	52                   	push   %edx
  800161:	50                   	push   %eax
  800162:	68 44 1c 80 00       	push   $0x801c44
  800167:	e8 77 01 00 00       	call   8002e3 <cprintf>
  80016c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016f:	a1 60 30 80 00       	mov    0x803060,%eax
  800174:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80017a:	a1 60 30 80 00       	mov    0x803060,%eax
  80017f:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800185:	a1 60 30 80 00       	mov    0x803060,%eax
  80018a:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800190:	51                   	push   %ecx
  800191:	52                   	push   %edx
  800192:	50                   	push   %eax
  800193:	68 6c 1c 80 00       	push   $0x801c6c
  800198:	e8 46 01 00 00       	call   8002e3 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a0:	a1 60 30 80 00       	mov    0x803060,%eax
  8001a5:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001ab:	83 ec 08             	sub    $0x8,%esp
  8001ae:	50                   	push   %eax
  8001af:	68 c4 1c 80 00       	push   $0x801cc4
  8001b4:	e8 2a 01 00 00       	call   8002e3 <cprintf>
  8001b9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 f8 1b 80 00       	push   $0x801bf8
  8001c4:	e8 1a 01 00 00       	call   8002e3 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001cc:	e8 80 10 00 00       	call   801251 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001d1:	e8 1f 00 00 00       	call   8001f5 <exit>
}
  8001d6:	90                   	nop
  8001d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001da:	5b                   	pop    %ebx
  8001db:	5e                   	pop    %esi
  8001dc:	5f                   	pop    %edi
  8001dd:	5d                   	pop    %ebp
  8001de:	c3                   	ret    

008001df <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	6a 00                	push   $0x0
  8001ea:	e8 8d 12 00 00       	call   80147c <sys_destroy_env>
  8001ef:	83 c4 10             	add    $0x10,%esp
}
  8001f2:	90                   	nop
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    

008001f5 <exit>:

void
exit(void)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fb:	e8 e2 12 00 00       	call   8014e2 <sys_exit_env>
}
  800200:	90                   	nop
  800201:	c9                   	leave  
  800202:	c3                   	ret    

00800203 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	53                   	push   %ebx
  800207:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	8b 00                	mov    (%eax),%eax
  80020f:	8d 48 01             	lea    0x1(%eax),%ecx
  800212:	8b 55 0c             	mov    0xc(%ebp),%edx
  800215:	89 0a                	mov    %ecx,(%edx)
  800217:	8b 55 08             	mov    0x8(%ebp),%edx
  80021a:	88 d1                	mov    %dl,%cl
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800223:	8b 45 0c             	mov    0xc(%ebp),%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022d:	75 30                	jne    80025f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80022f:	8b 15 58 b1 81 00    	mov    0x81b158,%edx
  800235:	a0 84 30 80 00       	mov    0x803084,%al
  80023a:	0f b6 c0             	movzbl %al,%eax
  80023d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800240:	8b 09                	mov    (%ecx),%ecx
  800242:	89 cb                	mov    %ecx,%ebx
  800244:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800247:	83 c1 08             	add    $0x8,%ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	53                   	push   %ebx
  80024d:	51                   	push   %ecx
  80024e:	e8 a0 0f 00 00       	call   8011f3 <sys_cputs>
  800253:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800256:	8b 45 0c             	mov    0xc(%ebp),%eax
  800259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800262:	8b 40 04             	mov    0x4(%eax),%eax
  800265:	8d 50 01             	lea    0x1(%eax),%edx
  800268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80026e:	90                   	nop
  80026f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80027d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800284:	00 00 00 
	b.cnt = 0;
  800287:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029d:	50                   	push   %eax
  80029e:	68 03 02 80 00       	push   $0x800203
  8002a3:	e8 5a 02 00 00       	call   800502 <vprintfmt>
  8002a8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002ab:	8b 15 58 b1 81 00    	mov    0x81b158,%edx
  8002b1:	a0 84 30 80 00       	mov    0x803084,%al
  8002b6:	0f b6 c0             	movzbl %al,%eax
  8002b9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002bf:	52                   	push   %edx
  8002c0:	50                   	push   %eax
  8002c1:	51                   	push   %ecx
  8002c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c8:	83 c0 08             	add    $0x8,%eax
  8002cb:	50                   	push   %eax
  8002cc:	e8 22 0f 00 00       	call   8011f3 <sys_cputs>
  8002d1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002d4:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  8002db:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002e9:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  8002f0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	83 ec 08             	sub    $0x8,%esp
  8002fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ff:	50                   	push   %eax
  800300:	e8 6f ff ff ff       	call   800274 <vcprintf>
  800305:	83 c4 10             	add    $0x10,%esp
  800308:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80030b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800316:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  80031d:	8b 45 08             	mov    0x8(%ebp),%eax
  800320:	c1 e0 08             	shl    $0x8,%eax
  800323:	a3 58 b1 81 00       	mov    %eax,0x81b158
	va_start(ap, fmt);
  800328:	8d 45 0c             	lea    0xc(%ebp),%eax
  80032b:	83 c0 04             	add    $0x4,%eax
  80032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800331:	8b 45 0c             	mov    0xc(%ebp),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	ff 75 f4             	pushl  -0xc(%ebp)
  80033a:	50                   	push   %eax
  80033b:	e8 34 ff ff ff       	call   800274 <vcprintf>
  800340:	83 c4 10             	add    $0x10,%esp
  800343:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800346:	c7 05 58 b1 81 00 00 	movl   $0x700,0x81b158
  80034d:	07 00 00 

	return cnt;
  800350:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80035b:	e8 d7 0e 00 00       	call   801237 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800360:	8d 45 0c             	lea    0xc(%ebp),%eax
  800363:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	ff 75 f4             	pushl  -0xc(%ebp)
  80036f:	50                   	push   %eax
  800370:	e8 ff fe ff ff       	call   800274 <vcprintf>
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80037b:	e8 d1 0e 00 00       	call   801251 <sys_unlock_cons>
	return cnt;
  800380:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	53                   	push   %ebx
  800389:	83 ec 14             	sub    $0x14,%esp
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800392:	8b 45 14             	mov    0x14(%ebp),%eax
  800395:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800398:	8b 45 18             	mov    0x18(%ebp),%eax
  80039b:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003a3:	77 55                	ja     8003fa <printnum+0x75>
  8003a5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003a8:	72 05                	jb     8003af <printnum+0x2a>
  8003aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003ad:	77 4b                	ja     8003fa <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003af:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003b2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bd:	52                   	push   %edx
  8003be:	50                   	push   %eax
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003c5:	e8 96 15 00 00       	call   801960 <__udivdi3>
  8003ca:	83 c4 10             	add    $0x10,%esp
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	ff 75 20             	pushl  0x20(%ebp)
  8003d3:	53                   	push   %ebx
  8003d4:	ff 75 18             	pushl  0x18(%ebp)
  8003d7:	52                   	push   %edx
  8003d8:	50                   	push   %eax
  8003d9:	ff 75 0c             	pushl  0xc(%ebp)
  8003dc:	ff 75 08             	pushl  0x8(%ebp)
  8003df:	e8 a1 ff ff ff       	call   800385 <printnum>
  8003e4:	83 c4 20             	add    $0x20,%esp
  8003e7:	eb 1a                	jmp    800403 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	ff 75 0c             	pushl  0xc(%ebp)
  8003ef:	ff 75 20             	pushl  0x20(%ebp)
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	ff d0                	call   *%eax
  8003f7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003fa:	ff 4d 1c             	decl   0x1c(%ebp)
  8003fd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800401:	7f e6                	jg     8003e9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800403:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800406:	bb 00 00 00 00       	mov    $0x0,%ebx
  80040b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800411:	53                   	push   %ebx
  800412:	51                   	push   %ecx
  800413:	52                   	push   %edx
  800414:	50                   	push   %eax
  800415:	e8 56 16 00 00       	call   801a70 <__umoddi3>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	05 54 1f 80 00       	add    $0x801f54,%eax
  800422:	8a 00                	mov    (%eax),%al
  800424:	0f be c0             	movsbl %al,%eax
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	ff 75 0c             	pushl  0xc(%ebp)
  80042d:	50                   	push   %eax
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	ff d0                	call   *%eax
  800433:	83 c4 10             	add    $0x10,%esp
}
  800436:	90                   	nop
  800437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80043a:	c9                   	leave  
  80043b:	c3                   	ret    

0080043c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80043c:	55                   	push   %ebp
  80043d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80043f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800443:	7e 1c                	jle    800461 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	8d 50 08             	lea    0x8(%eax),%edx
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	89 10                	mov    %edx,(%eax)
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	83 e8 08             	sub    $0x8,%eax
  80045a:	8b 50 04             	mov    0x4(%eax),%edx
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	eb 40                	jmp    8004a1 <getuint+0x65>
	else if (lflag)
  800461:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800465:	74 1e                	je     800485 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	8d 50 04             	lea    0x4(%eax),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	89 10                	mov    %edx,(%eax)
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	83 e8 04             	sub    $0x4,%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	ba 00 00 00 00       	mov    $0x0,%edx
  800483:	eb 1c                	jmp    8004a1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	8d 50 04             	lea    0x4(%eax),%edx
  80048d:	8b 45 08             	mov    0x8(%ebp),%eax
  800490:	89 10                	mov    %edx,(%eax)
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	8b 00                	mov    (%eax),%eax
  800497:	83 e8 04             	sub    $0x4,%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004a1:	5d                   	pop    %ebp
  8004a2:	c3                   	ret    

008004a3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004aa:	7e 1c                	jle    8004c8 <getint+0x25>
		return va_arg(*ap, long long);
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	8d 50 08             	lea    0x8(%eax),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	83 e8 08             	sub    $0x8,%eax
  8004c1:	8b 50 04             	mov    0x4(%eax),%edx
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	eb 38                	jmp    800500 <getint+0x5d>
	else if (lflag)
  8004c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004cc:	74 1a                	je     8004e8 <getint+0x45>
		return va_arg(*ap, long);
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	8d 50 04             	lea    0x4(%eax),%edx
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	89 10                	mov    %edx,(%eax)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	83 e8 04             	sub    $0x4,%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	99                   	cltd   
  8004e6:	eb 18                	jmp    800500 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	8d 50 04             	lea    0x4(%eax),%edx
  8004f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f3:	89 10                	mov    %edx,(%eax)
  8004f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	83 e8 04             	sub    $0x4,%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	99                   	cltd   
}
  800500:	5d                   	pop    %ebp
  800501:	c3                   	ret    

00800502 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	56                   	push   %esi
  800506:	53                   	push   %ebx
  800507:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80050a:	eb 17                	jmp    800523 <vprintfmt+0x21>
			if (ch == '\0')
  80050c:	85 db                	test   %ebx,%ebx
  80050e:	0f 84 c1 03 00 00    	je     8008d5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	ff 75 0c             	pushl  0xc(%ebp)
  80051a:	53                   	push   %ebx
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	ff d0                	call   *%eax
  800520:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	89 55 10             	mov    %edx,0x10(%ebp)
  80052c:	8a 00                	mov    (%eax),%al
  80052e:	0f b6 d8             	movzbl %al,%ebx
  800531:	83 fb 25             	cmp    $0x25,%ebx
  800534:	75 d6                	jne    80050c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800536:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80053a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800541:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800548:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80054f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800556:	8b 45 10             	mov    0x10(%ebp),%eax
  800559:	8d 50 01             	lea    0x1(%eax),%edx
  80055c:	89 55 10             	mov    %edx,0x10(%ebp)
  80055f:	8a 00                	mov    (%eax),%al
  800561:	0f b6 d8             	movzbl %al,%ebx
  800564:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800567:	83 f8 5b             	cmp    $0x5b,%eax
  80056a:	0f 87 3d 03 00 00    	ja     8008ad <vprintfmt+0x3ab>
  800570:	8b 04 85 78 1f 80 00 	mov    0x801f78(,%eax,4),%eax
  800577:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800579:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80057d:	eb d7                	jmp    800556 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80057f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800583:	eb d1                	jmp    800556 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800585:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80058c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058f:	89 d0                	mov    %edx,%eax
  800591:	c1 e0 02             	shl    $0x2,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	01 c0                	add    %eax,%eax
  800598:	01 d8                	add    %ebx,%eax
  80059a:	83 e8 30             	sub    $0x30,%eax
  80059d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a3:	8a 00                	mov    (%eax),%al
  8005a5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005a8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ab:	7e 3e                	jle    8005eb <vprintfmt+0xe9>
  8005ad:	83 fb 39             	cmp    $0x39,%ebx
  8005b0:	7f 39                	jg     8005eb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005b5:	eb d5                	jmp    80058c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	83 c0 04             	add    $0x4,%eax
  8005bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	83 e8 04             	sub    $0x4,%eax
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005cb:	eb 1f                	jmp    8005ec <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d1:	79 83                	jns    800556 <vprintfmt+0x54>
				width = 0;
  8005d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005da:	e9 77 ff ff ff       	jmp    800556 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005df:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005e6:	e9 6b ff ff ff       	jmp    800556 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005eb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f0:	0f 89 60 ff ff ff    	jns    800556 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005fc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800603:	e9 4e ff ff ff       	jmp    800556 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800608:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80060b:	e9 46 ff ff ff       	jmp    800556 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	83 c0 04             	add    $0x4,%eax
  800616:	89 45 14             	mov    %eax,0x14(%ebp)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	83 e8 04             	sub    $0x4,%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	ff 75 0c             	pushl  0xc(%ebp)
  800627:	50                   	push   %eax
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	ff d0                	call   *%eax
  80062d:	83 c4 10             	add    $0x10,%esp
			break;
  800630:	e9 9b 02 00 00       	jmp    8008d0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	83 c0 04             	add    $0x4,%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	83 e8 04             	sub    $0x4,%eax
  800644:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800646:	85 db                	test   %ebx,%ebx
  800648:	79 02                	jns    80064c <vprintfmt+0x14a>
				err = -err;
  80064a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80064c:	83 fb 64             	cmp    $0x64,%ebx
  80064f:	7f 0b                	jg     80065c <vprintfmt+0x15a>
  800651:	8b 34 9d c0 1d 80 00 	mov    0x801dc0(,%ebx,4),%esi
  800658:	85 f6                	test   %esi,%esi
  80065a:	75 19                	jne    800675 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80065c:	53                   	push   %ebx
  80065d:	68 65 1f 80 00       	push   $0x801f65
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	e8 70 02 00 00       	call   8008dd <printfmt>
  80066d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800670:	e9 5b 02 00 00       	jmp    8008d0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800675:	56                   	push   %esi
  800676:	68 6e 1f 80 00       	push   $0x801f6e
  80067b:	ff 75 0c             	pushl  0xc(%ebp)
  80067e:	ff 75 08             	pushl  0x8(%ebp)
  800681:	e8 57 02 00 00       	call   8008dd <printfmt>
  800686:	83 c4 10             	add    $0x10,%esp
			break;
  800689:	e9 42 02 00 00       	jmp    8008d0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	83 c0 04             	add    $0x4,%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 30                	mov    (%eax),%esi
  80069f:	85 f6                	test   %esi,%esi
  8006a1:	75 05                	jne    8006a8 <vprintfmt+0x1a6>
				p = "(null)";
  8006a3:	be 71 1f 80 00       	mov    $0x801f71,%esi
			if (width > 0 && padc != '-')
  8006a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ac:	7e 6d                	jle    80071b <vprintfmt+0x219>
  8006ae:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006b2:	74 67                	je     80071b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	50                   	push   %eax
  8006bb:	56                   	push   %esi
  8006bc:	e8 1e 03 00 00       	call   8009df <strnlen>
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006c7:	eb 16                	jmp    8006df <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006c9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 0c             	pushl  0xc(%ebp)
  8006d3:	50                   	push   %eax
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	ff d0                	call   *%eax
  8006d9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006dc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e3:	7f e4                	jg     8006c9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e5:	eb 34                	jmp    80071b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006eb:	74 1c                	je     800709 <vprintfmt+0x207>
  8006ed:	83 fb 1f             	cmp    $0x1f,%ebx
  8006f0:	7e 05                	jle    8006f7 <vprintfmt+0x1f5>
  8006f2:	83 fb 7e             	cmp    $0x7e,%ebx
  8006f5:	7e 12                	jle    800709 <vprintfmt+0x207>
					putch('?', putdat);
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	ff 75 0c             	pushl  0xc(%ebp)
  8006fd:	6a 3f                	push   $0x3f
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	ff d0                	call   *%eax
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	eb 0f                	jmp    800718 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	53                   	push   %ebx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	ff d0                	call   *%eax
  800715:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800718:	ff 4d e4             	decl   -0x1c(%ebp)
  80071b:	89 f0                	mov    %esi,%eax
  80071d:	8d 70 01             	lea    0x1(%eax),%esi
  800720:	8a 00                	mov    (%eax),%al
  800722:	0f be d8             	movsbl %al,%ebx
  800725:	85 db                	test   %ebx,%ebx
  800727:	74 24                	je     80074d <vprintfmt+0x24b>
  800729:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80072d:	78 b8                	js     8006e7 <vprintfmt+0x1e5>
  80072f:	ff 4d e0             	decl   -0x20(%ebp)
  800732:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800736:	79 af                	jns    8006e7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800738:	eb 13                	jmp    80074d <vprintfmt+0x24b>
				putch(' ', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	6a 20                	push   $0x20
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	ff d0                	call   *%eax
  800747:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074a:	ff 4d e4             	decl   -0x1c(%ebp)
  80074d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800751:	7f e7                	jg     80073a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800753:	e9 78 01 00 00       	jmp    8008d0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	ff 75 e8             	pushl  -0x18(%ebp)
  80075e:	8d 45 14             	lea    0x14(%ebp),%eax
  800761:	50                   	push   %eax
  800762:	e8 3c fd ff ff       	call   8004a3 <getint>
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800776:	85 d2                	test   %edx,%edx
  800778:	79 23                	jns    80079d <vprintfmt+0x29b>
				putch('-', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 0c             	pushl  0xc(%ebp)
  800780:	6a 2d                	push   $0x2d
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	ff d0                	call   *%eax
  800787:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80078a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800790:	f7 d8                	neg    %eax
  800792:	83 d2 00             	adc    $0x0,%edx
  800795:	f7 da                	neg    %edx
  800797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80079d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a4:	e9 bc 00 00 00       	jmp    800865 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8007af:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	e8 84 fc ff ff       	call   80043c <getuint>
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c8:	e9 98 00 00 00       	jmp    800865 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 58                	push   $0x58
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	6a 58                	push   $0x58
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	ff d0                	call   *%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	6a 58                	push   $0x58
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			break;
  8007fd:	e9 ce 00 00 00       	jmp    8008d0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	6a 30                	push   $0x30
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	ff d0                	call   *%eax
  80080f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	6a 78                	push   $0x78
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 e8 04             	sub    $0x4,%eax
  800831:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80083d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800844:	eb 1f                	jmp    800865 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 e8             	pushl  -0x18(%ebp)
  80084c:	8d 45 14             	lea    0x14(%ebp),%eax
  80084f:	50                   	push   %eax
  800850:	e8 e7 fb ff ff       	call   80043c <getuint>
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80085e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800865:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	52                   	push   %edx
  800870:	ff 75 e4             	pushl  -0x1c(%ebp)
  800873:	50                   	push   %eax
  800874:	ff 75 f4             	pushl  -0xc(%ebp)
  800877:	ff 75 f0             	pushl  -0x10(%ebp)
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	ff 75 08             	pushl  0x8(%ebp)
  800880:	e8 00 fb ff ff       	call   800385 <printnum>
  800885:	83 c4 20             	add    $0x20,%esp
			break;
  800888:	eb 46                	jmp    8008d0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	53                   	push   %ebx
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	ff d0                	call   *%eax
  800896:	83 c4 10             	add    $0x10,%esp
			break;
  800899:	eb 35                	jmp    8008d0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80089b:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  8008a2:	eb 2c                	jmp    8008d0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008a4:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  8008ab:	eb 23                	jmp    8008d0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	6a 25                	push   $0x25
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008bd:	ff 4d 10             	decl   0x10(%ebp)
  8008c0:	eb 03                	jmp    8008c5 <vprintfmt+0x3c3>
  8008c2:	ff 4d 10             	decl   0x10(%ebp)
  8008c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c8:	48                   	dec    %eax
  8008c9:	8a 00                	mov    (%eax),%al
  8008cb:	3c 25                	cmp    $0x25,%al
  8008cd:	75 f3                	jne    8008c2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008cf:	90                   	nop
		}
	}
  8008d0:	e9 35 fc ff ff       	jmp    80050a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008d5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d9:	5b                   	pop    %ebx
  8008da:	5e                   	pop    %esi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008e3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f2:	50                   	push   %eax
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	ff 75 08             	pushl  0x8(%ebp)
  8008f9:	e8 04 fc ff ff       	call   800502 <vprintfmt>
  8008fe:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800901:	90                   	nop
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090a:	8b 40 08             	mov    0x8(%eax),%eax
  80090d:	8d 50 01             	lea    0x1(%eax),%edx
  800910:	8b 45 0c             	mov    0xc(%ebp),%eax
  800913:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800916:	8b 45 0c             	mov    0xc(%ebp),%eax
  800919:	8b 10                	mov    (%eax),%edx
  80091b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091e:	8b 40 04             	mov    0x4(%eax),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	73 12                	jae    800937 <sprintputch+0x33>
		*b->buf++ = ch;
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	8d 48 01             	lea    0x1(%eax),%ecx
  80092d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800930:	89 0a                	mov    %ecx,(%edx)
  800932:	8b 55 08             	mov    0x8(%ebp),%edx
  800935:	88 10                	mov    %dl,(%eax)
}
  800937:	90                   	nop
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
  800949:	8d 50 ff             	lea    -0x1(%eax),%edx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	01 d0                	add    %edx,%eax
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80095b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80095f:	74 06                	je     800967 <vsnprintf+0x2d>
  800961:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800965:	7f 07                	jg     80096e <vsnprintf+0x34>
		return -E_INVAL;
  800967:	b8 03 00 00 00       	mov    $0x3,%eax
  80096c:	eb 20                	jmp    80098e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80096e:	ff 75 14             	pushl  0x14(%ebp)
  800971:	ff 75 10             	pushl  0x10(%ebp)
  800974:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800977:	50                   	push   %eax
  800978:	68 04 09 80 00       	push   $0x800904
  80097d:	e8 80 fb ff ff       	call   800502 <vprintfmt>
  800982:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800988:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80098b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800996:	8d 45 10             	lea    0x10(%ebp),%eax
  800999:	83 c0 04             	add    $0x4,%eax
  80099c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80099f:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 0c             	pushl  0xc(%ebp)
  8009a9:	ff 75 08             	pushl  0x8(%ebp)
  8009ac:	e8 89 ff ff ff       	call   80093a <vsnprintf>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c9:	eb 06                	jmp    8009d1 <strlen+0x15>
		n++;
  8009cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ce:	ff 45 08             	incl   0x8(%ebp)
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	8a 00                	mov    (%eax),%al
  8009d6:	84 c0                	test   %al,%al
  8009d8:	75 f1                	jne    8009cb <strlen+0xf>
		n++;
	return n;
  8009da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009dd:	c9                   	leave  
  8009de:	c3                   	ret    

008009df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ec:	eb 09                	jmp    8009f7 <strnlen+0x18>
		n++;
  8009ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f1:	ff 45 08             	incl   0x8(%ebp)
  8009f4:	ff 4d 0c             	decl   0xc(%ebp)
  8009f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009fb:	74 09                	je     800a06 <strnlen+0x27>
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	84 c0                	test   %al,%al
  800a04:	75 e8                	jne    8009ee <strnlen+0xf>
		n++;
	return n;
  800a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a17:	90                   	nop
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8d 50 01             	lea    0x1(%eax),%edx
  800a1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a27:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a2a:	8a 12                	mov    (%edx),%dl
  800a2c:	88 10                	mov    %dl,(%eax)
  800a2e:	8a 00                	mov    (%eax),%al
  800a30:	84 c0                	test   %al,%al
  800a32:	75 e4                	jne    800a18 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4c:	eb 1f                	jmp    800a6d <strncpy+0x34>
		*dst++ = *src;
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8d 50 01             	lea    0x1(%eax),%edx
  800a54:	89 55 08             	mov    %edx,0x8(%ebp)
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5a:	8a 12                	mov    (%edx),%dl
  800a5c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	84 c0                	test   %al,%al
  800a65:	74 03                	je     800a6a <strncpy+0x31>
			src++;
  800a67:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6a:	ff 45 fc             	incl   -0x4(%ebp)
  800a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a70:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a73:	72 d9                	jb     800a4e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a75:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a8a:	74 30                	je     800abc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a8c:	eb 16                	jmp    800aa4 <strlcpy+0x2a>
			*dst++ = *src++;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8d 50 01             	lea    0x1(%eax),%edx
  800a94:	89 55 08             	mov    %edx,0x8(%ebp)
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa0:	8a 12                	mov    (%edx),%dl
  800aa2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aa4:	ff 4d 10             	decl   0x10(%ebp)
  800aa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aab:	74 09                	je     800ab6 <strlcpy+0x3c>
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	84 c0                	test   %al,%al
  800ab4:	75 d8                	jne    800a8e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800abc:	8b 55 08             	mov    0x8(%ebp),%edx
  800abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ac2:	29 c2                	sub    %eax,%edx
  800ac4:	89 d0                	mov    %edx,%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800acb:	eb 06                	jmp    800ad3 <strcmp+0xb>
		p++, q++;
  800acd:	ff 45 08             	incl   0x8(%ebp)
  800ad0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	8a 00                	mov    (%eax),%al
  800ad8:	84 c0                	test   %al,%al
  800ada:	74 0e                	je     800aea <strcmp+0x22>
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8a 10                	mov    (%eax),%dl
  800ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	38 c2                	cmp    %al,%dl
  800ae8:	74 e3                	je     800acd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	0f b6 d0             	movzbl %al,%edx
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	0f b6 c0             	movzbl %al,%eax
  800afa:	29 c2                	sub    %eax,%edx
  800afc:	89 d0                	mov    %edx,%eax
}
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b03:	eb 09                	jmp    800b0e <strncmp+0xe>
		n--, p++, q++;
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	ff 45 08             	incl   0x8(%ebp)
  800b0b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b12:	74 17                	je     800b2b <strncmp+0x2b>
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strncmp+0x2b>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 da                	je     800b05 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b2f:	75 07                	jne    800b38 <strncmp+0x38>
		return 0;
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
  800b36:	eb 14                	jmp    800b4c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	0f b6 d0             	movzbl %al,%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	0f b6 c0             	movzbl %al,%eax
  800b48:	29 c2                	sub    %eax,%edx
  800b4a:	89 d0                	mov    %edx,%eax
}
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 04             	sub    $0x4,%esp
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b5a:	eb 12                	jmp    800b6e <strchr+0x20>
		if (*s == c)
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8a 00                	mov    (%eax),%al
  800b61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b64:	75 05                	jne    800b6b <strchr+0x1d>
			return (char *) s;
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	eb 11                	jmp    800b7c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b6b:	ff 45 08             	incl   0x8(%ebp)
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	84 c0                	test   %al,%al
  800b75:	75 e5                	jne    800b5c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b8a:	eb 0d                	jmp    800b99 <strfind+0x1b>
		if (*s == c)
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8a 00                	mov    (%eax),%al
  800b91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b94:	74 0e                	je     800ba4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b96:	ff 45 08             	incl   0x8(%ebp)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	84 c0                	test   %al,%al
  800ba0:	75 ea                	jne    800b8c <strfind+0xe>
  800ba2:	eb 01                	jmp    800ba5 <strfind+0x27>
		if (*s == c)
			break;
  800ba4:	90                   	nop
	return (char *) s;
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bb6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bba:	76 63                	jbe    800c1f <memset+0x75>
		uint64 data_block = c;
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	99                   	cltd   
  800bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcc:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800bd0:	c1 e0 08             	shl    $0x8,%eax
  800bd3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bd6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdf:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800be3:	c1 e0 10             	shl    $0x10,%eax
  800be6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800be9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	89 c2                	mov    %eax,%edx
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bfc:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800bff:	eb 18                	jmp    800c19 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c04:	8d 41 08             	lea    0x8(%ecx),%eax
  800c07:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c10:	89 01                	mov    %eax,(%ecx)
  800c12:	89 51 04             	mov    %edx,0x4(%ecx)
  800c15:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c19:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c1d:	77 e2                	ja     800c01 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c23:	74 23                	je     800c48 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c28:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c2b:	eb 0e                	jmp    800c3b <memset+0x91>
			*p8++ = (uint8)c;
  800c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c30:	8d 50 01             	lea    0x1(%eax),%edx
  800c33:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c39:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	85 c0                	test   %eax,%eax
  800c46:	75 e5                	jne    800c2d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c5f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c63:	76 24                	jbe    800c89 <memcpy+0x3c>
		while(n >= 8){
  800c65:	eb 1c                	jmp    800c83 <memcpy+0x36>
			*d64 = *s64;
  800c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6a:	8b 50 04             	mov    0x4(%eax),%edx
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c72:	89 01                	mov    %eax,(%ecx)
  800c74:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c77:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c7b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c7f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c83:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c87:	77 de                	ja     800c67 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8d:	74 31                	je     800cc0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800c95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800c9b:	eb 16                	jmp    800cb3 <memcpy+0x66>
			*d8++ = *s8++;
  800c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca0:	8d 50 01             	lea    0x1(%eax),%edx
  800ca3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cac:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800caf:	8a 12                	mov    (%edx),%dl
  800cb1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800cbc:	85 c0                	test   %eax,%eax
  800cbe:	75 dd                	jne    800c9d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cdd:	73 50                	jae    800d2f <memmove+0x6a>
  800cdf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ce2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce5:	01 d0                	add    %edx,%eax
  800ce7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cea:	76 43                	jbe    800d2f <memmove+0x6a>
		s += n;
  800cec:	8b 45 10             	mov    0x10(%ebp),%eax
  800cef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cf8:	eb 10                	jmp    800d0a <memmove+0x45>
			*--d = *--s;
  800cfa:	ff 4d f8             	decl   -0x8(%ebp)
  800cfd:	ff 4d fc             	decl   -0x4(%ebp)
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d03:	8a 10                	mov    (%eax),%dl
  800d05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d10:	89 55 10             	mov    %edx,0x10(%ebp)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	75 e3                	jne    800cfa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d17:	eb 23                	jmp    800d3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1c:	8d 50 01             	lea    0x1(%eax),%edx
  800d1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d2b:	8a 12                	mov    (%edx),%dl
  800d2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d35:	89 55 10             	mov    %edx,0x10(%ebp)
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	75 dd                	jne    800d19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3f:	c9                   	leave  
  800d40:	c3                   	ret    

00800d41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d53:	eb 2a                	jmp    800d7f <memcmp+0x3e>
		if (*s1 != *s2)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	8a 10                	mov    (%eax),%dl
  800d5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	38 c2                	cmp    %al,%dl
  800d61:	74 16                	je     800d79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	0f b6 d0             	movzbl %al,%edx
  800d6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	0f b6 c0             	movzbl %al,%eax
  800d73:	29 c2                	sub    %eax,%edx
  800d75:	89 d0                	mov    %edx,%eax
  800d77:	eb 18                	jmp    800d91 <memcmp+0x50>
		s1++, s2++;
  800d79:	ff 45 fc             	incl   -0x4(%ebp)
  800d7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	75 c9                	jne    800d55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800da4:	eb 15                	jmp    800dbb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	0f b6 d0             	movzbl %al,%edx
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	0f b6 c0             	movzbl %al,%eax
  800db4:	39 c2                	cmp    %eax,%edx
  800db6:	74 0d                	je     800dc5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800db8:	ff 45 08             	incl   0x8(%ebp)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dc1:	72 e3                	jb     800da6 <memfind+0x13>
  800dc3:	eb 01                	jmp    800dc6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dc5:	90                   	nop
	return (void *) s;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ddf:	eb 03                	jmp    800de4 <strtol+0x19>
		s++;
  800de1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	3c 20                	cmp    $0x20,%al
  800deb:	74 f4                	je     800de1 <strtol+0x16>
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	3c 09                	cmp    $0x9,%al
  800df4:	74 eb                	je     800de1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	3c 2b                	cmp    $0x2b,%al
  800dfd:	75 05                	jne    800e04 <strtol+0x39>
		s++;
  800dff:	ff 45 08             	incl   0x8(%ebp)
  800e02:	eb 13                	jmp    800e17 <strtol+0x4c>
	else if (*s == '-')
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	3c 2d                	cmp    $0x2d,%al
  800e0b:	75 0a                	jne    800e17 <strtol+0x4c>
		s++, neg = 1;
  800e0d:	ff 45 08             	incl   0x8(%ebp)
  800e10:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1b:	74 06                	je     800e23 <strtol+0x58>
  800e1d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e21:	75 20                	jne    800e43 <strtol+0x78>
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	3c 30                	cmp    $0x30,%al
  800e2a:	75 17                	jne    800e43 <strtol+0x78>
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	40                   	inc    %eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	3c 78                	cmp    $0x78,%al
  800e34:	75 0d                	jne    800e43 <strtol+0x78>
		s += 2, base = 16;
  800e36:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e3a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e41:	eb 28                	jmp    800e6b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e47:	75 15                	jne    800e5e <strtol+0x93>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	3c 30                	cmp    $0x30,%al
  800e50:	75 0c                	jne    800e5e <strtol+0x93>
		s++, base = 8;
  800e52:	ff 45 08             	incl   0x8(%ebp)
  800e55:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e5c:	eb 0d                	jmp    800e6b <strtol+0xa0>
	else if (base == 0)
  800e5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e62:	75 07                	jne    800e6b <strtol+0xa0>
		base = 10;
  800e64:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	3c 2f                	cmp    $0x2f,%al
  800e72:	7e 19                	jle    800e8d <strtol+0xc2>
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3c 39                	cmp    $0x39,%al
  800e7b:	7f 10                	jg     800e8d <strtol+0xc2>
			dig = *s - '0';
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	0f be c0             	movsbl %al,%eax
  800e85:	83 e8 30             	sub    $0x30,%eax
  800e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e8b:	eb 42                	jmp    800ecf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	3c 60                	cmp    $0x60,%al
  800e94:	7e 19                	jle    800eaf <strtol+0xe4>
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3c 7a                	cmp    $0x7a,%al
  800e9d:	7f 10                	jg     800eaf <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f be c0             	movsbl %al,%eax
  800ea7:	83 e8 57             	sub    $0x57,%eax
  800eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ead:	eb 20                	jmp    800ecf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	3c 40                	cmp    $0x40,%al
  800eb6:	7e 39                	jle    800ef1 <strtol+0x126>
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3c 5a                	cmp    $0x5a,%al
  800ebf:	7f 30                	jg     800ef1 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	0f be c0             	movsbl %al,%eax
  800ec9:	83 e8 37             	sub    $0x37,%eax
  800ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed5:	7d 19                	jge    800ef0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ed7:	ff 45 08             	incl   0x8(%ebp)
  800eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ee1:	89 c2                	mov    %eax,%edx
  800ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee6:	01 d0                	add    %edx,%eax
  800ee8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800eeb:	e9 7b ff ff ff       	jmp    800e6b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ef0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ef1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef5:	74 08                	je     800eff <strtol+0x134>
		*endptr = (char *) s;
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f03:	74 07                	je     800f0c <strtol+0x141>
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	f7 d8                	neg    %eax
  800f0a:	eb 03                	jmp    800f0f <strtol+0x144>
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <ltostr>:

void
ltostr(long value, char *str)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f1e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f29:	79 13                	jns    800f3e <ltostr+0x2d>
	{
		neg = 1;
  800f2b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f38:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f3b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f46:	99                   	cltd   
  800f47:	f7 f9                	idiv   %ecx
  800f49:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4f:	8d 50 01             	lea    0x1(%eax),%edx
  800f52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f55:	89 c2                	mov    %eax,%edx
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	01 d0                	add    %edx,%eax
  800f5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f5f:	83 c2 30             	add    $0x30,%edx
  800f62:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f67:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f6c:	f7 e9                	imul   %ecx
  800f6e:	c1 fa 02             	sar    $0x2,%edx
  800f71:	89 c8                	mov    %ecx,%eax
  800f73:	c1 f8 1f             	sar    $0x1f,%eax
  800f76:	29 c2                	sub    %eax,%edx
  800f78:	89 d0                	mov    %edx,%eax
  800f7a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f81:	75 bb                	jne    800f3e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8d:	48                   	dec    %eax
  800f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f95:	74 3d                	je     800fd4 <ltostr+0xc3>
		start = 1 ;
  800f97:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f9e:	eb 34                	jmp    800fd4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	01 d0                	add    %edx,%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbb:	01 c8                	add    %ecx,%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc7:	01 c2                	add    %eax,%edx
  800fc9:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fcc:	88 02                	mov    %al,(%edx)
		start++ ;
  800fce:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fd1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fda:	7c c4                	jl     800fa0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fdc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	01 d0                	add    %edx,%eax
  800fe4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fe7:	90                   	nop
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 c4 f9 ff ff       	call   8009bc <strlen>
  800ff8:	83 c4 04             	add    $0x4,%esp
  800ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	e8 b6 f9 ff ff       	call   8009bc <strlen>
  801006:	83 c4 04             	add    $0x4,%esp
  801009:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80100c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101a:	eb 17                	jmp    801033 <strcconcat+0x49>
		final[s] = str1[s] ;
  80101c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101f:	8b 45 10             	mov    0x10(%ebp),%eax
  801022:	01 c2                	add    %eax,%edx
  801024:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	01 c8                	add    %ecx,%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801030:	ff 45 fc             	incl   -0x4(%ebp)
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801036:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801039:	7c e1                	jl     80101c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80103b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801042:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801049:	eb 1f                	jmp    80106a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80104b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104e:	8d 50 01             	lea    0x1(%eax),%edx
  801051:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801054:	89 c2                	mov    %eax,%edx
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 c2                	add    %eax,%edx
  80105b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	01 c8                	add    %ecx,%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801067:	ff 45 f8             	incl   -0x8(%ebp)
  80106a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801070:	7c d9                	jl     80104b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801072:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801075:	8b 45 10             	mov    0x10(%ebp),%eax
  801078:	01 d0                	add    %edx,%eax
  80107a:	c6 00 00             	movb   $0x0,(%eax)
}
  80107d:	90                   	nop
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801083:	8b 45 14             	mov    0x14(%ebp),%eax
  801086:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801098:	8b 45 10             	mov    0x10(%ebp),%eax
  80109b:	01 d0                	add    %edx,%eax
  80109d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010a3:	eb 0c                	jmp    8010b1 <strsplit+0x31>
			*string++ = 0;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8d 50 01             	lea    0x1(%eax),%edx
  8010ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ae:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	84 c0                	test   %al,%al
  8010b8:	74 18                	je     8010d2 <strsplit+0x52>
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	0f be c0             	movsbl %al,%eax
  8010c2:	50                   	push   %eax
  8010c3:	ff 75 0c             	pushl  0xc(%ebp)
  8010c6:	e8 83 fa ff ff       	call   800b4e <strchr>
  8010cb:	83 c4 08             	add    $0x8,%esp
  8010ce:	85 c0                	test   %eax,%eax
  8010d0:	75 d3                	jne    8010a5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	84 c0                	test   %al,%al
  8010d9:	74 5a                	je     801135 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010db:	8b 45 14             	mov    0x14(%ebp),%eax
  8010de:	8b 00                	mov    (%eax),%eax
  8010e0:	83 f8 0f             	cmp    $0xf,%eax
  8010e3:	75 07                	jne    8010ec <strsplit+0x6c>
		{
			return 0;
  8010e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ea:	eb 66                	jmp    801152 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ef:	8b 00                	mov    (%eax),%eax
  8010f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8010f4:	8b 55 14             	mov    0x14(%ebp),%edx
  8010f7:	89 0a                	mov    %ecx,(%edx)
  8010f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 c2                	add    %eax,%edx
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80110a:	eb 03                	jmp    80110f <strsplit+0x8f>
			string++;
  80110c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	84 c0                	test   %al,%al
  801116:	74 8b                	je     8010a3 <strsplit+0x23>
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f be c0             	movsbl %al,%eax
  801120:	50                   	push   %eax
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	e8 25 fa ff ff       	call   800b4e <strchr>
  801129:	83 c4 08             	add    $0x8,%esp
  80112c:	85 c0                	test   %eax,%eax
  80112e:	74 dc                	je     80110c <strsplit+0x8c>
			string++;
	}
  801130:	e9 6e ff ff ff       	jmp    8010a3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801135:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801136:	8b 45 14             	mov    0x14(%ebp),%eax
  801139:	8b 00                	mov    (%eax),%eax
  80113b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801142:	8b 45 10             	mov    0x10(%ebp),%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80114d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    

00801154 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801167:	eb 4a                	jmp    8011b3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801169:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c2                	add    %eax,%edx
  801171:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	01 c8                	add    %ecx,%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	01 d0                	add    %edx,%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 40                	cmp    $0x40,%al
  801189:	7e 25                	jle    8011b0 <str2lower+0x5c>
  80118b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	01 d0                	add    %edx,%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	3c 5a                	cmp    $0x5a,%al
  801197:	7f 17                	jg     8011b0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801199:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	01 d0                	add    %edx,%eax
  8011a1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a7:	01 ca                	add    %ecx,%edx
  8011a9:	8a 12                	mov    (%edx),%dl
  8011ab:	83 c2 20             	add    $0x20,%edx
  8011ae:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011b0:	ff 45 fc             	incl   -0x4(%ebp)
  8011b3:	ff 75 0c             	pushl  0xc(%ebp)
  8011b6:	e8 01 f8 ff ff       	call   8009bc <strlen>
  8011bb:	83 c4 04             	add    $0x4,%esp
  8011be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011c1:	7f a6                	jg     801169 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	57                   	push   %edi
  8011cc:	56                   	push   %esi
  8011cd:	53                   	push   %ebx
  8011ce:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011dd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011e0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011e3:	cd 30                	int    $0x30
  8011e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5f                   	pop    %edi
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8011ff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801202:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	6a 00                	push   $0x0
  80120b:	51                   	push   %ecx
  80120c:	52                   	push   %edx
  80120d:	ff 75 0c             	pushl  0xc(%ebp)
  801210:	50                   	push   %eax
  801211:	6a 00                	push   $0x0
  801213:	e8 b0 ff ff ff       	call   8011c8 <syscall>
  801218:	83 c4 18             	add    $0x18,%esp
}
  80121b:	90                   	nop
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <sys_cgetc>:

int
sys_cgetc(void)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 00                	push   $0x0
  801227:	6a 00                	push   $0x0
  801229:	6a 00                	push   $0x0
  80122b:	6a 02                	push   $0x2
  80122d:	e8 96 ff ff ff       	call   8011c8 <syscall>
  801232:	83 c4 18             	add    $0x18,%esp
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	6a 03                	push   $0x3
  801246:	e8 7d ff ff ff       	call   8011c8 <syscall>
  80124b:	83 c4 18             	add    $0x18,%esp
}
  80124e:	90                   	nop
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 04                	push   $0x4
  801260:	e8 63 ff ff ff       	call   8011c8 <syscall>
  801265:	83 c4 18             	add    $0x18,%esp
}
  801268:	90                   	nop
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80126e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	52                   	push   %edx
  80127b:	50                   	push   %eax
  80127c:	6a 08                	push   $0x8
  80127e:	e8 45 ff ff ff       	call   8011c8 <syscall>
  801283:	83 c4 18             	add    $0x18,%esp
}
  801286:	c9                   	leave  
  801287:	c3                   	ret    

00801288 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	56                   	push   %esi
  80128c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80128d:	8b 75 18             	mov    0x18(%ebp),%esi
  801290:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801293:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801296:	8b 55 0c             	mov    0xc(%ebp),%edx
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	56                   	push   %esi
  80129d:	53                   	push   %ebx
  80129e:	51                   	push   %ecx
  80129f:	52                   	push   %edx
  8012a0:	50                   	push   %eax
  8012a1:	6a 09                	push   $0x9
  8012a3:	e8 20 ff ff ff       	call   8011c8 <syscall>
  8012a8:	83 c4 18             	add    $0x18,%esp
}
  8012ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ae:	5b                   	pop    %ebx
  8012af:	5e                   	pop    %esi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	ff 75 08             	pushl  0x8(%ebp)
  8012c0:	6a 0a                	push   $0xa
  8012c2:	e8 01 ff ff ff       	call   8011c8 <syscall>
  8012c7:	83 c4 18             	add    $0x18,%esp
}
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	ff 75 0c             	pushl  0xc(%ebp)
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	6a 0b                	push   $0xb
  8012dd:	e8 e6 fe ff ff       	call   8011c8 <syscall>
  8012e2:	83 c4 18             	add    $0x18,%esp
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 0c                	push   $0xc
  8012f6:	e8 cd fe ff ff       	call   8011c8 <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 0d                	push   $0xd
  80130f:	e8 b4 fe ff ff       	call   8011c8 <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 0e                	push   $0xe
  801328:	e8 9b fe ff ff       	call   8011c8 <syscall>
  80132d:	83 c4 18             	add    $0x18,%esp
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 0f                	push   $0xf
  801341:	e8 82 fe ff ff       	call   8011c8 <syscall>
  801346:	83 c4 18             	add    $0x18,%esp
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	ff 75 08             	pushl  0x8(%ebp)
  801359:	6a 10                	push   $0x10
  80135b:	e8 68 fe ff ff       	call   8011c8 <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 11                	push   $0x11
  801374:	e8 4f fe ff ff       	call   8011c8 <syscall>
  801379:	83 c4 18             	add    $0x18,%esp
}
  80137c:	90                   	nop
  80137d:	c9                   	leave  
  80137e:	c3                   	ret    

0080137f <sys_cputc>:

void
sys_cputc(const char c)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80138b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	50                   	push   %eax
  801398:	6a 01                	push   $0x1
  80139a:	e8 29 fe ff ff       	call   8011c8 <syscall>
  80139f:	83 c4 18             	add    $0x18,%esp
}
  8013a2:	90                   	nop
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 14                	push   $0x14
  8013b4:	e8 0f fe ff ff       	call   8011c8 <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
}
  8013bc:	90                   	nop
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013cb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013ce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	6a 00                	push   $0x0
  8013d7:	51                   	push   %ecx
  8013d8:	52                   	push   %edx
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	50                   	push   %eax
  8013dd:	6a 15                	push   $0x15
  8013df:	e8 e4 fd ff ff       	call   8011c8 <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	52                   	push   %edx
  8013f9:	50                   	push   %eax
  8013fa:	6a 16                	push   $0x16
  8013fc:	e8 c7 fd ff ff       	call   8011c8 <syscall>
  801401:	83 c4 18             	add    $0x18,%esp
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801409:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80140c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	51                   	push   %ecx
  801417:	52                   	push   %edx
  801418:	50                   	push   %eax
  801419:	6a 17                	push   $0x17
  80141b:	e8 a8 fd ff ff       	call   8011c8 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	52                   	push   %edx
  801435:	50                   	push   %eax
  801436:	6a 18                	push   $0x18
  801438:	e8 8b fd ff ff       	call   8011c8 <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	6a 00                	push   $0x0
  80144a:	ff 75 14             	pushl  0x14(%ebp)
  80144d:	ff 75 10             	pushl  0x10(%ebp)
  801450:	ff 75 0c             	pushl  0xc(%ebp)
  801453:	50                   	push   %eax
  801454:	6a 19                	push   $0x19
  801456:	e8 6d fd ff ff       	call   8011c8 <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	50                   	push   %eax
  80146f:	6a 1a                	push   $0x1a
  801471:	e8 52 fd ff ff       	call   8011c8 <syscall>
  801476:	83 c4 18             	add    $0x18,%esp
}
  801479:	90                   	nop
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	50                   	push   %eax
  80148b:	6a 1b                	push   $0x1b
  80148d:	e8 36 fd ff ff       	call   8011c8 <syscall>
  801492:	83 c4 18             	add    $0x18,%esp
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 05                	push   $0x5
  8014a6:	e8 1d fd ff ff       	call   8011c8 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 06                	push   $0x6
  8014bf:	e8 04 fd ff ff       	call   8011c8 <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 07                	push   $0x7
  8014d8:	e8 eb fc ff ff       	call   8011c8 <syscall>
  8014dd:	83 c4 18             	add    $0x18,%esp
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <sys_exit_env>:


void sys_exit_env(void)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 1c                	push   $0x1c
  8014f1:	e8 d2 fc ff ff       	call   8011c8 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
}
  8014f9:	90                   	nop
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801502:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801505:	8d 50 04             	lea    0x4(%eax),%edx
  801508:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	52                   	push   %edx
  801512:	50                   	push   %eax
  801513:	6a 1d                	push   $0x1d
  801515:	e8 ae fc ff ff       	call   8011c8 <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
	return result;
  80151d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801520:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801523:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801526:	89 01                	mov    %eax,(%ecx)
  801528:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	c9                   	leave  
  80152f:	c2 04 00             	ret    $0x4

00801532 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	ff 75 10             	pushl  0x10(%ebp)
  80153c:	ff 75 0c             	pushl  0xc(%ebp)
  80153f:	ff 75 08             	pushl  0x8(%ebp)
  801542:	6a 13                	push   $0x13
  801544:	e8 7f fc ff ff       	call   8011c8 <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
	return ;
  80154c:	90                   	nop
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_rcr2>:
uint32 sys_rcr2()
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 1e                	push   $0x1e
  80155e:	e8 65 fc ff ff       	call   8011c8 <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801574:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	50                   	push   %eax
  801581:	6a 1f                	push   $0x1f
  801583:	e8 40 fc ff ff       	call   8011c8 <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
	return ;
  80158b:	90                   	nop
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <rsttst>:
void rsttst()
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 21                	push   $0x21
  80159d:	e8 26 fc ff ff       	call   8011c8 <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a5:	90                   	nop
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 04             	sub    $0x4,%esp
  8015ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015b4:	8b 55 18             	mov    0x18(%ebp),%edx
  8015b7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015bb:	52                   	push   %edx
  8015bc:	50                   	push   %eax
  8015bd:	ff 75 10             	pushl  0x10(%ebp)
  8015c0:	ff 75 0c             	pushl  0xc(%ebp)
  8015c3:	ff 75 08             	pushl  0x8(%ebp)
  8015c6:	6a 20                	push   $0x20
  8015c8:	e8 fb fb ff ff       	call   8011c8 <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d0:	90                   	nop
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <chktst>:
void chktst(uint32 n)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	ff 75 08             	pushl  0x8(%ebp)
  8015e1:	6a 22                	push   $0x22
  8015e3:	e8 e0 fb ff ff       	call   8011c8 <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015eb:	90                   	nop
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <inctst>:

void inctst()
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 23                	push   $0x23
  8015fd:	e8 c6 fb ff ff       	call   8011c8 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
	return ;
  801605:	90                   	nop
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <gettst>:
uint32 gettst()
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 24                	push   $0x24
  801617:	e8 ac fb ff ff       	call   8011c8 <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 25                	push   $0x25
  801630:	e8 93 fb ff ff       	call   8011c8 <syscall>
  801635:	83 c4 18             	add    $0x18,%esp
  801638:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	return uheapPlaceStrategy ;
  80163d:	a1 a0 b0 81 00       	mov    0x81b0a0,%eax
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	ff 75 08             	pushl  0x8(%ebp)
  80165a:	6a 26                	push   $0x26
  80165c:	e8 67 fb ff ff       	call   8011c8 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
	return ;
  801664:	90                   	nop
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80166b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801671:	8b 55 0c             	mov    0xc(%ebp),%edx
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	6a 00                	push   $0x0
  801679:	53                   	push   %ebx
  80167a:	51                   	push   %ecx
  80167b:	52                   	push   %edx
  80167c:	50                   	push   %eax
  80167d:	6a 27                	push   $0x27
  80167f:	e8 44 fb ff ff       	call   8011c8 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80168f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	52                   	push   %edx
  80169c:	50                   	push   %eax
  80169d:	6a 28                	push   $0x28
  80169f:	e8 24 fb ff ff       	call   8011c8 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	51                   	push   %ecx
  8016b8:	ff 75 10             	pushl  0x10(%ebp)
  8016bb:	52                   	push   %edx
  8016bc:	50                   	push   %eax
  8016bd:	6a 29                	push   $0x29
  8016bf:	e8 04 fb ff ff       	call   8011c8 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	ff 75 10             	pushl  0x10(%ebp)
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	6a 12                	push   $0x12
  8016db:	e8 e8 fa ff ff       	call   8011c8 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e3:	90                   	nop
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	52                   	push   %edx
  8016f6:	50                   	push   %eax
  8016f7:	6a 2a                	push   $0x2a
  8016f9:	e8 ca fa ff ff       	call   8011c8 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
	return;
  801701:	90                   	nop
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 2b                	push   $0x2b
  801713:	e8 b0 fa ff ff       	call   8011c8 <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	6a 2d                	push   $0x2d
  80172e:	e8 95 fa ff ff       	call   8011c8 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
	return;
  801736:	90                   	nop
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	ff 75 0c             	pushl  0xc(%ebp)
  801745:	ff 75 08             	pushl  0x8(%ebp)
  801748:	6a 2c                	push   $0x2c
  80174a:	e8 79 fa ff ff       	call   8011c8 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
	return ;
  801752:	90                   	nop
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	68 e8 20 80 00       	push   $0x8020e8
  801763:	68 25 01 00 00       	push   $0x125
  801768:	68 1b 21 80 00       	push   $0x80211b
  80176d:	e8 00 00 00 00       	call   801772 <_panic>

00801772 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801778:	8d 45 10             	lea    0x10(%ebp),%eax
  80177b:	83 c0 04             	add    $0x4,%eax
  80177e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801781:	a1 5c b1 81 00       	mov    0x81b15c,%eax
  801786:	85 c0                	test   %eax,%eax
  801788:	74 16                	je     8017a0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80178a:	a1 5c b1 81 00       	mov    0x81b15c,%eax
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	50                   	push   %eax
  801793:	68 2c 21 80 00       	push   $0x80212c
  801798:	e8 46 eb ff ff       	call   8002e3 <cprintf>
  80179d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017a0:	a1 40 30 80 00       	mov    0x803040,%eax
  8017a5:	83 ec 0c             	sub    $0xc,%esp
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	ff 75 08             	pushl  0x8(%ebp)
  8017ae:	50                   	push   %eax
  8017af:	68 34 21 80 00       	push   $0x802134
  8017b4:	6a 74                	push   $0x74
  8017b6:	e8 55 eb ff ff       	call   800310 <cprintf_colored>
  8017bb:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017be:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c7:	50                   	push   %eax
  8017c8:	e8 a7 ea ff ff       	call   800274 <vcprintf>
  8017cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	6a 00                	push   $0x0
  8017d5:	68 5c 21 80 00       	push   $0x80215c
  8017da:	e8 95 ea ff ff       	call   800274 <vcprintf>
  8017df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017e2:	e8 0e ea ff ff       	call   8001f5 <exit>

	// should not return here
	while (1) ;
  8017e7:	eb fe                	jmp    8017e7 <_panic+0x75>

008017e9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017ef:	a1 60 30 80 00       	mov    0x803060,%eax
  8017f4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fd:	39 c2                	cmp    %eax,%edx
  8017ff:	74 14                	je     801815 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 60 21 80 00       	push   $0x802160
  801809:	6a 26                	push   $0x26
  80180b:	68 ac 21 80 00       	push   $0x8021ac
  801810:	e8 5d ff ff ff       	call   801772 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801815:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80181c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801823:	e9 c5 00 00 00       	jmp    8018ed <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	01 d0                	add    %edx,%eax
  801837:	8b 00                	mov    (%eax),%eax
  801839:	85 c0                	test   %eax,%eax
  80183b:	75 08                	jne    801845 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80183d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801840:	e9 a5 00 00 00       	jmp    8018ea <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801845:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80184c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801853:	eb 69                	jmp    8018be <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801855:	a1 60 30 80 00       	mov    0x803060,%eax
  80185a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801860:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801863:	89 d0                	mov    %edx,%eax
  801865:	01 c0                	add    %eax,%eax
  801867:	01 d0                	add    %edx,%eax
  801869:	c1 e0 03             	shl    $0x3,%eax
  80186c:	01 c8                	add    %ecx,%eax
  80186e:	8a 40 04             	mov    0x4(%eax),%al
  801871:	84 c0                	test   %al,%al
  801873:	75 46                	jne    8018bb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801875:	a1 60 30 80 00       	mov    0x803060,%eax
  80187a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801880:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	01 c0                	add    %eax,%eax
  801887:	01 d0                	add    %edx,%eax
  801889:	c1 e0 03             	shl    $0x3,%eax
  80188c:	01 c8                	add    %ecx,%eax
  80188e:	8b 00                	mov    (%eax),%eax
  801890:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801893:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801896:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80189b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80189d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	01 c8                	add    %ecx,%eax
  8018ac:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018ae:	39 c2                	cmp    %eax,%edx
  8018b0:	75 09                	jne    8018bb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018b2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018b9:	eb 15                	jmp    8018d0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018bb:	ff 45 e8             	incl   -0x18(%ebp)
  8018be:	a1 60 30 80 00       	mov    0x803060,%eax
  8018c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018cc:	39 c2                	cmp    %eax,%edx
  8018ce:	77 85                	ja     801855 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018d4:	75 14                	jne    8018ea <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	68 b8 21 80 00       	push   $0x8021b8
  8018de:	6a 3a                	push   $0x3a
  8018e0:	68 ac 21 80 00       	push   $0x8021ac
  8018e5:	e8 88 fe ff ff       	call   801772 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018ea:	ff 45 f0             	incl   -0x10(%ebp)
  8018ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018f3:	0f 8c 2f ff ff ff    	jl     801828 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801900:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801907:	eb 26                	jmp    80192f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801909:	a1 60 30 80 00       	mov    0x803060,%eax
  80190e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801917:	89 d0                	mov    %edx,%eax
  801919:	01 c0                	add    %eax,%eax
  80191b:	01 d0                	add    %edx,%eax
  80191d:	c1 e0 03             	shl    $0x3,%eax
  801920:	01 c8                	add    %ecx,%eax
  801922:	8a 40 04             	mov    0x4(%eax),%al
  801925:	3c 01                	cmp    $0x1,%al
  801927:	75 03                	jne    80192c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801929:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80192c:	ff 45 e0             	incl   -0x20(%ebp)
  80192f:	a1 60 30 80 00       	mov    0x803060,%eax
  801934:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80193a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193d:	39 c2                	cmp    %eax,%edx
  80193f:	77 c8                	ja     801909 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801944:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801947:	74 14                	je     80195d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	68 0c 22 80 00       	push   $0x80220c
  801951:	6a 44                	push   $0x44
  801953:	68 ac 21 80 00       	push   $0x8021ac
  801958:	e8 15 fe ff ff       	call   801772 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <__udivdi3>:
  801960:	55                   	push   %ebp
  801961:	57                   	push   %edi
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 1c             	sub    $0x1c,%esp
  801967:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80196b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80196f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801973:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801977:	89 ca                	mov    %ecx,%edx
  801979:	89 f8                	mov    %edi,%eax
  80197b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80197f:	85 f6                	test   %esi,%esi
  801981:	75 2d                	jne    8019b0 <__udivdi3+0x50>
  801983:	39 cf                	cmp    %ecx,%edi
  801985:	77 65                	ja     8019ec <__udivdi3+0x8c>
  801987:	89 fd                	mov    %edi,%ebp
  801989:	85 ff                	test   %edi,%edi
  80198b:	75 0b                	jne    801998 <__udivdi3+0x38>
  80198d:	b8 01 00 00 00       	mov    $0x1,%eax
  801992:	31 d2                	xor    %edx,%edx
  801994:	f7 f7                	div    %edi
  801996:	89 c5                	mov    %eax,%ebp
  801998:	31 d2                	xor    %edx,%edx
  80199a:	89 c8                	mov    %ecx,%eax
  80199c:	f7 f5                	div    %ebp
  80199e:	89 c1                	mov    %eax,%ecx
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	f7 f5                	div    %ebp
  8019a4:	89 cf                	mov    %ecx,%edi
  8019a6:	89 fa                	mov    %edi,%edx
  8019a8:	83 c4 1c             	add    $0x1c,%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5f                   	pop    %edi
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    
  8019b0:	39 ce                	cmp    %ecx,%esi
  8019b2:	77 28                	ja     8019dc <__udivdi3+0x7c>
  8019b4:	0f bd fe             	bsr    %esi,%edi
  8019b7:	83 f7 1f             	xor    $0x1f,%edi
  8019ba:	75 40                	jne    8019fc <__udivdi3+0x9c>
  8019bc:	39 ce                	cmp    %ecx,%esi
  8019be:	72 0a                	jb     8019ca <__udivdi3+0x6a>
  8019c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019c4:	0f 87 9e 00 00 00    	ja     801a68 <__udivdi3+0x108>
  8019ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cf:	89 fa                	mov    %edi,%edx
  8019d1:	83 c4 1c             	add    $0x1c,%esp
  8019d4:	5b                   	pop    %ebx
  8019d5:	5e                   	pop    %esi
  8019d6:	5f                   	pop    %edi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    
  8019d9:	8d 76 00             	lea    0x0(%esi),%esi
  8019dc:	31 ff                	xor    %edi,%edi
  8019de:	31 c0                	xor    %eax,%eax
  8019e0:	89 fa                	mov    %edi,%edx
  8019e2:	83 c4 1c             	add    $0x1c,%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5f                   	pop    %edi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    
  8019ea:	66 90                	xchg   %ax,%ax
  8019ec:	89 d8                	mov    %ebx,%eax
  8019ee:	f7 f7                	div    %edi
  8019f0:	31 ff                	xor    %edi,%edi
  8019f2:	89 fa                	mov    %edi,%edx
  8019f4:	83 c4 1c             	add    $0x1c,%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5f                   	pop    %edi
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    
  8019fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a01:	89 eb                	mov    %ebp,%ebx
  801a03:	29 fb                	sub    %edi,%ebx
  801a05:	89 f9                	mov    %edi,%ecx
  801a07:	d3 e6                	shl    %cl,%esi
  801a09:	89 c5                	mov    %eax,%ebp
  801a0b:	88 d9                	mov    %bl,%cl
  801a0d:	d3 ed                	shr    %cl,%ebp
  801a0f:	89 e9                	mov    %ebp,%ecx
  801a11:	09 f1                	or     %esi,%ecx
  801a13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a17:	89 f9                	mov    %edi,%ecx
  801a19:	d3 e0                	shl    %cl,%eax
  801a1b:	89 c5                	mov    %eax,%ebp
  801a1d:	89 d6                	mov    %edx,%esi
  801a1f:	88 d9                	mov    %bl,%cl
  801a21:	d3 ee                	shr    %cl,%esi
  801a23:	89 f9                	mov    %edi,%ecx
  801a25:	d3 e2                	shl    %cl,%edx
  801a27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 e8                	shr    %cl,%eax
  801a2f:	09 c2                	or     %eax,%edx
  801a31:	89 d0                	mov    %edx,%eax
  801a33:	89 f2                	mov    %esi,%edx
  801a35:	f7 74 24 0c          	divl   0xc(%esp)
  801a39:	89 d6                	mov    %edx,%esi
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	f7 e5                	mul    %ebp
  801a3f:	39 d6                	cmp    %edx,%esi
  801a41:	72 19                	jb     801a5c <__udivdi3+0xfc>
  801a43:	74 0b                	je     801a50 <__udivdi3+0xf0>
  801a45:	89 d8                	mov    %ebx,%eax
  801a47:	31 ff                	xor    %edi,%edi
  801a49:	e9 58 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a4e:	66 90                	xchg   %ax,%ax
  801a50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a54:	89 f9                	mov    %edi,%ecx
  801a56:	d3 e2                	shl    %cl,%edx
  801a58:	39 c2                	cmp    %eax,%edx
  801a5a:	73 e9                	jae    801a45 <__udivdi3+0xe5>
  801a5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a5f:	31 ff                	xor    %edi,%edi
  801a61:	e9 40 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	31 c0                	xor    %eax,%eax
  801a6a:	e9 37 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a6f:	90                   	nop

00801a70 <__umoddi3>:
  801a70:	55                   	push   %ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 1c             	sub    $0x1c,%esp
  801a77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a8f:	89 f3                	mov    %esi,%ebx
  801a91:	89 fa                	mov    %edi,%edx
  801a93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a97:	89 34 24             	mov    %esi,(%esp)
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	75 1a                	jne    801ab8 <__umoddi3+0x48>
  801a9e:	39 f7                	cmp    %esi,%edi
  801aa0:	0f 86 a2 00 00 00    	jbe    801b48 <__umoddi3+0xd8>
  801aa6:	89 c8                	mov    %ecx,%eax
  801aa8:	89 f2                	mov    %esi,%edx
  801aaa:	f7 f7                	div    %edi
  801aac:	89 d0                	mov    %edx,%eax
  801aae:	31 d2                	xor    %edx,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	39 f0                	cmp    %esi,%eax
  801aba:	0f 87 ac 00 00 00    	ja     801b6c <__umoddi3+0xfc>
  801ac0:	0f bd e8             	bsr    %eax,%ebp
  801ac3:	83 f5 1f             	xor    $0x1f,%ebp
  801ac6:	0f 84 ac 00 00 00    	je     801b78 <__umoddi3+0x108>
  801acc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ad1:	29 ef                	sub    %ebp,%edi
  801ad3:	89 fe                	mov    %edi,%esi
  801ad5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ad9:	89 e9                	mov    %ebp,%ecx
  801adb:	d3 e0                	shl    %cl,%eax
  801add:	89 d7                	mov    %edx,%edi
  801adf:	89 f1                	mov    %esi,%ecx
  801ae1:	d3 ef                	shr    %cl,%edi
  801ae3:	09 c7                	or     %eax,%edi
  801ae5:	89 e9                	mov    %ebp,%ecx
  801ae7:	d3 e2                	shl    %cl,%edx
  801ae9:	89 14 24             	mov    %edx,(%esp)
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	d3 e0                	shl    %cl,%eax
  801af0:	89 c2                	mov    %eax,%edx
  801af2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801af6:	d3 e0                	shl    %cl,%eax
  801af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b00:	89 f1                	mov    %esi,%ecx
  801b02:	d3 e8                	shr    %cl,%eax
  801b04:	09 d0                	or     %edx,%eax
  801b06:	d3 eb                	shr    %cl,%ebx
  801b08:	89 da                	mov    %ebx,%edx
  801b0a:	f7 f7                	div    %edi
  801b0c:	89 d3                	mov    %edx,%ebx
  801b0e:	f7 24 24             	mull   (%esp)
  801b11:	89 c6                	mov    %eax,%esi
  801b13:	89 d1                	mov    %edx,%ecx
  801b15:	39 d3                	cmp    %edx,%ebx
  801b17:	0f 82 87 00 00 00    	jb     801ba4 <__umoddi3+0x134>
  801b1d:	0f 84 91 00 00 00    	je     801bb4 <__umoddi3+0x144>
  801b23:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b27:	29 f2                	sub    %esi,%edx
  801b29:	19 cb                	sbb    %ecx,%ebx
  801b2b:	89 d8                	mov    %ebx,%eax
  801b2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b31:	d3 e0                	shl    %cl,%eax
  801b33:	89 e9                	mov    %ebp,%ecx
  801b35:	d3 ea                	shr    %cl,%edx
  801b37:	09 d0                	or     %edx,%eax
  801b39:	89 e9                	mov    %ebp,%ecx
  801b3b:	d3 eb                	shr    %cl,%ebx
  801b3d:	89 da                	mov    %ebx,%edx
  801b3f:	83 c4 1c             	add    $0x1c,%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5f                   	pop    %edi
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    
  801b47:	90                   	nop
  801b48:	89 fd                	mov    %edi,%ebp
  801b4a:	85 ff                	test   %edi,%edi
  801b4c:	75 0b                	jne    801b59 <__umoddi3+0xe9>
  801b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b53:	31 d2                	xor    %edx,%edx
  801b55:	f7 f7                	div    %edi
  801b57:	89 c5                	mov    %eax,%ebp
  801b59:	89 f0                	mov    %esi,%eax
  801b5b:	31 d2                	xor    %edx,%edx
  801b5d:	f7 f5                	div    %ebp
  801b5f:	89 c8                	mov    %ecx,%eax
  801b61:	f7 f5                	div    %ebp
  801b63:	89 d0                	mov    %edx,%eax
  801b65:	e9 44 ff ff ff       	jmp    801aae <__umoddi3+0x3e>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	89 c8                	mov    %ecx,%eax
  801b6e:	89 f2                	mov    %esi,%edx
  801b70:	83 c4 1c             	add    $0x1c,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5f                   	pop    %edi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    
  801b78:	3b 04 24             	cmp    (%esp),%eax
  801b7b:	72 06                	jb     801b83 <__umoddi3+0x113>
  801b7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b81:	77 0f                	ja     801b92 <__umoddi3+0x122>
  801b83:	89 f2                	mov    %esi,%edx
  801b85:	29 f9                	sub    %edi,%ecx
  801b87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b8b:	89 14 24             	mov    %edx,(%esp)
  801b8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b92:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b96:	8b 14 24             	mov    (%esp),%edx
  801b99:	83 c4 1c             	add    $0x1c,%esp
  801b9c:	5b                   	pop    %ebx
  801b9d:	5e                   	pop    %esi
  801b9e:	5f                   	pop    %edi
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    
  801ba1:	8d 76 00             	lea    0x0(%esi),%esi
  801ba4:	2b 04 24             	sub    (%esp),%eax
  801ba7:	19 fa                	sbb    %edi,%edx
  801ba9:	89 d1                	mov    %edx,%ecx
  801bab:	89 c6                	mov    %eax,%esi
  801bad:	e9 71 ff ff ff       	jmp    801b23 <__umoddi3+0xb3>
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bb8:	72 ea                	jb     801ba4 <__umoddi3+0x134>
  801bba:	89 d9                	mov    %ebx,%ecx
  801bbc:	e9 62 ff ff ff       	jmp    801b23 <__umoddi3+0xb3>
