
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 e0 1b 80 00       	push   $0x801be0
  800049:	e8 1d 03 00 00       	call   80036b <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	57                   	push   %edi
  800058:	56                   	push   %esi
  800059:	53                   	push   %ebx
  80005a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005d:	e8 64 14 00 00       	call   8014c6 <sys_getenvindex>
  800062:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800065:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	c1 e0 06             	shl    $0x6,%eax
  80006d:	29 d0                	sub    %edx,%eax
  80006f:	c1 e0 02             	shl    $0x2,%eax
  800072:	01 d0                	add    %edx,%eax
  800074:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80007b:	01 c8                	add    %ecx,%eax
  80007d:	c1 e0 03             	shl    $0x3,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800089:	29 c2                	sub    %eax,%edx
  80008b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800092:	89 c2                	mov    %eax,%edx
  800094:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80009a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009f:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a4:	8a 40 20             	mov    0x20(%eax),%al
  8000a7:	84 c0                	test   %al,%al
  8000a9:	74 0d                	je     8000b8 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8000ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b0:	83 c0 20             	add    $0x20,%eax
  8000b3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bc:	7e 0a                	jle    8000c8 <libmain+0x74>
		binaryname = argv[0];
  8000be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c1:	8b 00                	mov    (%eax),%eax
  8000c3:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	ff 75 0c             	pushl  0xc(%ebp)
  8000ce:	ff 75 08             	pushl  0x8(%ebp)
  8000d1:	e8 62 ff ff ff       	call   800038 <_main>
  8000d6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d9:	a1 00 30 80 00       	mov    0x803000,%eax
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 84 01 01 00 00    	je     8001e7 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000e6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000ec:	bb fc 1c 80 00       	mov    $0x801cfc,%ebx
  8000f1:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000f6:	89 c7                	mov    %eax,%edi
  8000f8:	89 de                	mov    %ebx,%esi
  8000fa:	89 d1                	mov    %edx,%ecx
  8000fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000fe:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800101:	b9 56 00 00 00       	mov    $0x56,%ecx
  800106:	b0 00                	mov    $0x0,%al
  800108:	89 d7                	mov    %edx,%edi
  80010a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80010c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800113:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	50                   	push   %eax
  80011a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800120:	50                   	push   %eax
  800121:	e8 d6 15 00 00       	call   8016fc <sys_utilities>
  800126:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800129:	e8 1f 11 00 00       	call   80124d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	68 1c 1c 80 00       	push   $0x801c1c
  800136:	e8 be 01 00 00       	call   8002f9 <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80013e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800141:	85 c0                	test   %eax,%eax
  800143:	74 18                	je     80015d <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800145:	e8 d0 15 00 00       	call   80171a <sys_get_optimal_num_faults>
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	50                   	push   %eax
  80014e:	68 44 1c 80 00       	push   $0x801c44
  800153:	e8 a1 01 00 00       	call   8002f9 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
  80015b:	eb 59                	jmp    8001b6 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015d:	a1 20 30 80 00       	mov    0x803020,%eax
  800162:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800168:	a1 20 30 80 00       	mov    0x803020,%eax
  80016d:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	52                   	push   %edx
  800177:	50                   	push   %eax
  800178:	68 68 1c 80 00       	push   $0x801c68
  80017d:	e8 77 01 00 00       	call   8002f9 <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800185:	a1 20 30 80 00       	mov    0x803020,%eax
  80018a:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800190:	a1 20 30 80 00       	mov    0x803020,%eax
  800195:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80019b:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a0:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001a6:	51                   	push   %ecx
  8001a7:	52                   	push   %edx
  8001a8:	50                   	push   %eax
  8001a9:	68 90 1c 80 00       	push   $0x801c90
  8001ae:	e8 46 01 00 00       	call   8002f9 <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bb:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	50                   	push   %eax
  8001c5:	68 e8 1c 80 00       	push   $0x801ce8
  8001ca:	e8 2a 01 00 00       	call   8002f9 <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 1c 1c 80 00       	push   $0x801c1c
  8001da:	e8 1a 01 00 00       	call   8002f9 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001e2:	e8 80 10 00 00       	call   801267 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001e7:	e8 1f 00 00 00       	call   80020b <exit>
}
  8001ec:	90                   	nop
  8001ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f0:	5b                   	pop    %ebx
  8001f1:	5e                   	pop    %esi
  8001f2:	5f                   	pop    %edi
  8001f3:	5d                   	pop    %ebp
  8001f4:	c3                   	ret    

008001f5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	6a 00                	push   $0x0
  800200:	e8 8d 12 00 00       	call   801492 <sys_destroy_env>
  800205:	83 c4 10             	add    $0x10,%esp
}
  800208:	90                   	nop
  800209:	c9                   	leave  
  80020a:	c3                   	ret    

0080020b <exit>:

void
exit(void)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800211:	e8 e2 12 00 00       	call   8014f8 <sys_exit_env>
}
  800216:	90                   	nop
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	53                   	push   %ebx
  80021d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800220:	8b 45 0c             	mov    0xc(%ebp),%eax
  800223:	8b 00                	mov    (%eax),%eax
  800225:	8d 48 01             	lea    0x1(%eax),%ecx
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	89 0a                	mov    %ecx,(%edx)
  80022d:	8b 55 08             	mov    0x8(%ebp),%edx
  800230:	88 d1                	mov    %dl,%cl
  800232:	8b 55 0c             	mov    0xc(%ebp),%edx
  800235:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023c:	8b 00                	mov    (%eax),%eax
  80023e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800243:	75 30                	jne    800275 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800245:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80024b:	a0 44 30 80 00       	mov    0x803044,%al
  800250:	0f b6 c0             	movzbl %al,%eax
  800253:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800256:	8b 09                	mov    (%ecx),%ecx
  800258:	89 cb                	mov    %ecx,%ebx
  80025a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025d:	83 c1 08             	add    $0x8,%ecx
  800260:	52                   	push   %edx
  800261:	50                   	push   %eax
  800262:	53                   	push   %ebx
  800263:	51                   	push   %ecx
  800264:	e8 a0 0f 00 00       	call   801209 <sys_cputs>
  800269:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80026c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800275:	8b 45 0c             	mov    0xc(%ebp),%eax
  800278:	8b 40 04             	mov    0x4(%eax),%eax
  80027b:	8d 50 01             	lea    0x1(%eax),%edx
  80027e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800281:	89 50 04             	mov    %edx,0x4(%eax)
}
  800284:	90                   	nop
  800285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800293:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80029a:	00 00 00 
	b.cnt = 0;
  80029d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b3:	50                   	push   %eax
  8002b4:	68 19 02 80 00       	push   $0x800219
  8002b9:	e8 5a 02 00 00       	call   800518 <vprintfmt>
  8002be:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002c1:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002c7:	a0 44 30 80 00       	mov    0x803044,%al
  8002cc:	0f b6 c0             	movzbl %al,%eax
  8002cf:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	51                   	push   %ecx
  8002d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002de:	83 c0 08             	add    $0x8,%eax
  8002e1:	50                   	push   %eax
  8002e2:	e8 22 0f 00 00       	call   801209 <sys_cputs>
  8002e7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002ea:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8002f1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002ff:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800306:	8d 45 0c             	lea    0xc(%ebp),%eax
  800309:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030c:	8b 45 08             	mov    0x8(%ebp),%eax
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	ff 75 f4             	pushl  -0xc(%ebp)
  800315:	50                   	push   %eax
  800316:	e8 6f ff ff ff       	call   80028a <vcprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800321:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80032c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800333:	8b 45 08             	mov    0x8(%ebp),%eax
  800336:	c1 e0 08             	shl    $0x8,%eax
  800339:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  80033e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800341:	83 c0 04             	add    $0x4,%eax
  800344:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	ff 75 f4             	pushl  -0xc(%ebp)
  800350:	50                   	push   %eax
  800351:	e8 34 ff ff ff       	call   80028a <vcprintf>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80035c:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800363:	07 00 00 

	return cnt;
  800366:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800371:	e8 d7 0e 00 00       	call   80124d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800376:	8d 45 0c             	lea    0xc(%ebp),%eax
  800379:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80037c:	8b 45 08             	mov    0x8(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 ff fe ff ff       	call   80028a <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800391:	e8 d1 0e 00 00       	call   801267 <sys_unlock_cons>
	return cnt;
  800396:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800399:	c9                   	leave  
  80039a:	c3                   	ret    

0080039b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	53                   	push   %ebx
  80039f:	83 ec 14             	sub    $0x14,%esp
  8003a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b9:	77 55                	ja     800410 <printnum+0x75>
  8003bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003be:	72 05                	jb     8003c5 <printnum+0x2a>
  8003c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003c3:	77 4b                	ja     800410 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d3:	52                   	push   %edx
  8003d4:	50                   	push   %eax
  8003d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8003db:	e8 98 15 00 00       	call   801978 <__udivdi3>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	ff 75 20             	pushl  0x20(%ebp)
  8003e9:	53                   	push   %ebx
  8003ea:	ff 75 18             	pushl  0x18(%ebp)
  8003ed:	52                   	push   %edx
  8003ee:	50                   	push   %eax
  8003ef:	ff 75 0c             	pushl  0xc(%ebp)
  8003f2:	ff 75 08             	pushl  0x8(%ebp)
  8003f5:	e8 a1 ff ff ff       	call   80039b <printnum>
  8003fa:	83 c4 20             	add    $0x20,%esp
  8003fd:	eb 1a                	jmp    800419 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ff:	83 ec 08             	sub    $0x8,%esp
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 20             	pushl  0x20(%ebp)
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	ff d0                	call   *%eax
  80040d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800410:	ff 4d 1c             	decl   0x1c(%ebp)
  800413:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800417:	7f e6                	jg     8003ff <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800419:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80041c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800427:	53                   	push   %ebx
  800428:	51                   	push   %ecx
  800429:	52                   	push   %edx
  80042a:	50                   	push   %eax
  80042b:	e8 58 16 00 00       	call   801a88 <__umoddi3>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	05 74 1f 80 00       	add    $0x801f74,%eax
  800438:	8a 00                	mov    (%eax),%al
  80043a:	0f be c0             	movsbl %al,%eax
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	50                   	push   %eax
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	ff d0                	call   *%eax
  800449:	83 c4 10             	add    $0x10,%esp
}
  80044c:	90                   	nop
  80044d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800450:	c9                   	leave  
  800451:	c3                   	ret    

00800452 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800455:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800459:	7e 1c                	jle    800477 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	8d 50 08             	lea    0x8(%eax),%edx
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	89 10                	mov    %edx,(%eax)
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	83 e8 08             	sub    $0x8,%eax
  800470:	8b 50 04             	mov    0x4(%eax),%edx
  800473:	8b 00                	mov    (%eax),%eax
  800475:	eb 40                	jmp    8004b7 <getuint+0x65>
	else if (lflag)
  800477:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80047b:	74 1e                	je     80049b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	8d 50 04             	lea    0x4(%eax),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	89 10                	mov    %edx,(%eax)
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	83 e8 04             	sub    $0x4,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	ba 00 00 00 00       	mov    $0x0,%edx
  800499:	eb 1c                	jmp    8004b7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	8d 50 04             	lea    0x4(%eax),%edx
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	89 10                	mov    %edx,(%eax)
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	83 e8 04             	sub    $0x4,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b7:	5d                   	pop    %ebp
  8004b8:	c3                   	ret    

008004b9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004c0:	7e 1c                	jle    8004de <getint+0x25>
		return va_arg(*ap, long long);
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	8d 50 08             	lea    0x8(%eax),%edx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	89 10                	mov    %edx,(%eax)
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	83 e8 08             	sub    $0x8,%eax
  8004d7:	8b 50 04             	mov    0x4(%eax),%edx
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	eb 38                	jmp    800516 <getint+0x5d>
	else if (lflag)
  8004de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e2:	74 1a                	je     8004fe <getint+0x45>
		return va_arg(*ap, long);
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	8d 50 04             	lea    0x4(%eax),%edx
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	89 10                	mov    %edx,(%eax)
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	83 e8 04             	sub    $0x4,%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	99                   	cltd   
  8004fc:	eb 18                	jmp    800516 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	8b 00                	mov    (%eax),%eax
  800503:	8d 50 04             	lea    0x4(%eax),%edx
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	89 10                	mov    %edx,(%eax)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	83 e8 04             	sub    $0x4,%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	99                   	cltd   
}
  800516:	5d                   	pop    %ebp
  800517:	c3                   	ret    

00800518 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800518:	55                   	push   %ebp
  800519:	89 e5                	mov    %esp,%ebp
  80051b:	56                   	push   %esi
  80051c:	53                   	push   %ebx
  80051d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800520:	eb 17                	jmp    800539 <vprintfmt+0x21>
			if (ch == '\0')
  800522:	85 db                	test   %ebx,%ebx
  800524:	0f 84 c1 03 00 00    	je     8008eb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	53                   	push   %ebx
  800531:	8b 45 08             	mov    0x8(%ebp),%eax
  800534:	ff d0                	call   *%eax
  800536:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	8d 50 01             	lea    0x1(%eax),%edx
  80053f:	89 55 10             	mov    %edx,0x10(%ebp)
  800542:	8a 00                	mov    (%eax),%al
  800544:	0f b6 d8             	movzbl %al,%ebx
  800547:	83 fb 25             	cmp    $0x25,%ebx
  80054a:	75 d6                	jne    800522 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80054c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800550:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800557:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800565:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8b 45 10             	mov    0x10(%ebp),%eax
  80056f:	8d 50 01             	lea    0x1(%eax),%edx
  800572:	89 55 10             	mov    %edx,0x10(%ebp)
  800575:	8a 00                	mov    (%eax),%al
  800577:	0f b6 d8             	movzbl %al,%ebx
  80057a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80057d:	83 f8 5b             	cmp    $0x5b,%eax
  800580:	0f 87 3d 03 00 00    	ja     8008c3 <vprintfmt+0x3ab>
  800586:	8b 04 85 98 1f 80 00 	mov    0x801f98(,%eax,4),%eax
  80058d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80058f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800593:	eb d7                	jmp    80056c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800595:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800599:	eb d1                	jmp    80056c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80059b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a5:	89 d0                	mov    %edx,%eax
  8005a7:	c1 e0 02             	shl    $0x2,%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	01 c0                	add    %eax,%eax
  8005ae:	01 d8                	add    %ebx,%eax
  8005b0:	83 e8 30             	sub    $0x30,%eax
  8005b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b9:	8a 00                	mov    (%eax),%al
  8005bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005be:	83 fb 2f             	cmp    $0x2f,%ebx
  8005c1:	7e 3e                	jle    800601 <vprintfmt+0xe9>
  8005c3:	83 fb 39             	cmp    $0x39,%ebx
  8005c6:	7f 39                	jg     800601 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005cb:	eb d5                	jmp    8005a2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	83 c0 04             	add    $0x4,%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	83 e8 04             	sub    $0x4,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005e1:	eb 1f                	jmp    800602 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e7:	79 83                	jns    80056c <vprintfmt+0x54>
				width = 0;
  8005e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005f0:	e9 77 ff ff ff       	jmp    80056c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005fc:	e9 6b ff ff ff       	jmp    80056c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800601:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800602:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800606:	0f 89 60 ff ff ff    	jns    80056c <vprintfmt+0x54>
				width = precision, precision = -1;
  80060c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800619:	e9 4e ff ff ff       	jmp    80056c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80061e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800621:	e9 46 ff ff ff       	jmp    80056c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	83 c0 04             	add    $0x4,%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	83 e8 04             	sub    $0x4,%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	ff 75 0c             	pushl  0xc(%ebp)
  80063d:	50                   	push   %eax
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	ff d0                	call   *%eax
  800643:	83 c4 10             	add    $0x10,%esp
			break;
  800646:	e9 9b 02 00 00       	jmp    8008e6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	83 c0 04             	add    $0x4,%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	83 e8 04             	sub    $0x4,%eax
  80065a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80065c:	85 db                	test   %ebx,%ebx
  80065e:	79 02                	jns    800662 <vprintfmt+0x14a>
				err = -err;
  800660:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800662:	83 fb 64             	cmp    $0x64,%ebx
  800665:	7f 0b                	jg     800672 <vprintfmt+0x15a>
  800667:	8b 34 9d e0 1d 80 00 	mov    0x801de0(,%ebx,4),%esi
  80066e:	85 f6                	test   %esi,%esi
  800670:	75 19                	jne    80068b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800672:	53                   	push   %ebx
  800673:	68 85 1f 80 00       	push   $0x801f85
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	ff 75 08             	pushl  0x8(%ebp)
  80067e:	e8 70 02 00 00       	call   8008f3 <printfmt>
  800683:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800686:	e9 5b 02 00 00       	jmp    8008e6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80068b:	56                   	push   %esi
  80068c:	68 8e 1f 80 00       	push   $0x801f8e
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	ff 75 08             	pushl  0x8(%ebp)
  800697:	e8 57 02 00 00       	call   8008f3 <printfmt>
  80069c:	83 c4 10             	add    $0x10,%esp
			break;
  80069f:	e9 42 02 00 00       	jmp    8008e6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	83 c0 04             	add    $0x4,%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	83 e8 04             	sub    $0x4,%eax
  8006b3:	8b 30                	mov    (%eax),%esi
  8006b5:	85 f6                	test   %esi,%esi
  8006b7:	75 05                	jne    8006be <vprintfmt+0x1a6>
				p = "(null)";
  8006b9:	be 91 1f 80 00       	mov    $0x801f91,%esi
			if (width > 0 && padc != '-')
  8006be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c2:	7e 6d                	jle    800731 <vprintfmt+0x219>
  8006c4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006c8:	74 67                	je     800731 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	50                   	push   %eax
  8006d1:	56                   	push   %esi
  8006d2:	e8 1e 03 00 00       	call   8009f5 <strnlen>
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006dd:	eb 16                	jmp    8006f5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006df:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	50                   	push   %eax
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	ff d0                	call   *%eax
  8006ef:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f9:	7f e4                	jg     8006df <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006fb:	eb 34                	jmp    800731 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800701:	74 1c                	je     80071f <vprintfmt+0x207>
  800703:	83 fb 1f             	cmp    $0x1f,%ebx
  800706:	7e 05                	jle    80070d <vprintfmt+0x1f5>
  800708:	83 fb 7e             	cmp    $0x7e,%ebx
  80070b:	7e 12                	jle    80071f <vprintfmt+0x207>
					putch('?', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	ff 75 0c             	pushl  0xc(%ebp)
  800713:	6a 3f                	push   $0x3f
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	ff d0                	call   *%eax
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	eb 0f                	jmp    80072e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072e:	ff 4d e4             	decl   -0x1c(%ebp)
  800731:	89 f0                	mov    %esi,%eax
  800733:	8d 70 01             	lea    0x1(%eax),%esi
  800736:	8a 00                	mov    (%eax),%al
  800738:	0f be d8             	movsbl %al,%ebx
  80073b:	85 db                	test   %ebx,%ebx
  80073d:	74 24                	je     800763 <vprintfmt+0x24b>
  80073f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800743:	78 b8                	js     8006fd <vprintfmt+0x1e5>
  800745:	ff 4d e0             	decl   -0x20(%ebp)
  800748:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074c:	79 af                	jns    8006fd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074e:	eb 13                	jmp    800763 <vprintfmt+0x24b>
				putch(' ', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	6a 20                	push   $0x20
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	ff d0                	call   *%eax
  80075d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800760:	ff 4d e4             	decl   -0x1c(%ebp)
  800763:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800767:	7f e7                	jg     800750 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800769:	e9 78 01 00 00       	jmp    8008e6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 e8             	pushl  -0x18(%ebp)
  800774:	8d 45 14             	lea    0x14(%ebp),%eax
  800777:	50                   	push   %eax
  800778:	e8 3c fd ff ff       	call   8004b9 <getint>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800783:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078c:	85 d2                	test   %edx,%edx
  80078e:	79 23                	jns    8007b3 <vprintfmt+0x29b>
				putch('-', putdat);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 0c             	pushl  0xc(%ebp)
  800796:	6a 2d                	push   $0x2d
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	ff d0                	call   *%eax
  80079d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a6:	f7 d8                	neg    %eax
  8007a8:	83 d2 00             	adc    $0x0,%edx
  8007ab:	f7 da                	neg    %edx
  8007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ba:	e9 bc 00 00 00       	jmp    80087b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c8:	50                   	push   %eax
  8007c9:	e8 84 fc ff ff       	call   800452 <getuint>
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007d7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007de:	e9 98 00 00 00       	jmp    80087b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 0c             	pushl  0xc(%ebp)
  8007e9:	6a 58                	push   $0x58
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	ff d0                	call   *%eax
  8007f0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	6a 58                	push   $0x58
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	ff d0                	call   *%eax
  800800:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	6a 58                	push   $0x58
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	ff d0                	call   *%eax
  800810:	83 c4 10             	add    $0x10,%esp
			break;
  800813:	e9 ce 00 00 00       	jmp    8008e6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 0c             	pushl  0xc(%ebp)
  80081e:	6a 30                	push   $0x30
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	ff d0                	call   *%eax
  800825:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	6a 78                	push   $0x78
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	ff d0                	call   *%eax
  800835:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800849:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800853:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80085a:	eb 1f                	jmp    80087b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 e8             	pushl  -0x18(%ebp)
  800862:	8d 45 14             	lea    0x14(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	e8 e7 fb ff ff       	call   800452 <getuint>
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800871:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800874:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80087b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800882:	83 ec 04             	sub    $0x4,%esp
  800885:	52                   	push   %edx
  800886:	ff 75 e4             	pushl  -0x1c(%ebp)
  800889:	50                   	push   %eax
  80088a:	ff 75 f4             	pushl  -0xc(%ebp)
  80088d:	ff 75 f0             	pushl  -0x10(%ebp)
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	ff 75 08             	pushl  0x8(%ebp)
  800896:	e8 00 fb ff ff       	call   80039b <printnum>
  80089b:	83 c4 20             	add    $0x20,%esp
			break;
  80089e:	eb 46                	jmp    8008e6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	53                   	push   %ebx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
			break;
  8008af:	eb 35                	jmp    8008e6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008b1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8008b8:	eb 2c                	jmp    8008e6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008ba:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8008c1:	eb 23                	jmp    8008e6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	ff 75 0c             	pushl  0xc(%ebp)
  8008c9:	6a 25                	push   $0x25
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	ff d0                	call   *%eax
  8008d0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d3:	ff 4d 10             	decl   0x10(%ebp)
  8008d6:	eb 03                	jmp    8008db <vprintfmt+0x3c3>
  8008d8:	ff 4d 10             	decl   0x10(%ebp)
  8008db:	8b 45 10             	mov    0x10(%ebp),%eax
  8008de:	48                   	dec    %eax
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	3c 25                	cmp    $0x25,%al
  8008e3:	75 f3                	jne    8008d8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008e5:	90                   	nop
		}
	}
  8008e6:	e9 35 fc ff ff       	jmp    800520 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008eb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ef:	5b                   	pop    %ebx
  8008f0:	5e                   	pop    %esi
  8008f1:	5d                   	pop    %ebp
  8008f2:	c3                   	ret    

008008f3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800902:	8b 45 10             	mov    0x10(%ebp),%eax
  800905:	ff 75 f4             	pushl  -0xc(%ebp)
  800908:	50                   	push   %eax
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	ff 75 08             	pushl  0x8(%ebp)
  80090f:	e8 04 fc ff ff       	call   800518 <vprintfmt>
  800914:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800917:	90                   	nop
  800918:	c9                   	leave  
  800919:	c3                   	ret    

0080091a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 40 08             	mov    0x8(%eax),%eax
  800923:	8d 50 01             	lea    0x1(%eax),%edx
  800926:	8b 45 0c             	mov    0xc(%ebp),%eax
  800929:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092f:	8b 10                	mov    (%eax),%edx
  800931:	8b 45 0c             	mov    0xc(%ebp),%eax
  800934:	8b 40 04             	mov    0x4(%eax),%eax
  800937:	39 c2                	cmp    %eax,%edx
  800939:	73 12                	jae    80094d <sprintputch+0x33>
		*b->buf++ = ch;
  80093b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	8d 48 01             	lea    0x1(%eax),%ecx
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
  800946:	89 0a                	mov    %ecx,(%edx)
  800948:	8b 55 08             	mov    0x8(%ebp),%edx
  80094b:	88 10                	mov    %dl,(%eax)
}
  80094d:	90                   	nop
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	01 d0                	add    %edx,%eax
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800971:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800975:	74 06                	je     80097d <vsnprintf+0x2d>
  800977:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097b:	7f 07                	jg     800984 <vsnprintf+0x34>
		return -E_INVAL;
  80097d:	b8 03 00 00 00       	mov    $0x3,%eax
  800982:	eb 20                	jmp    8009a4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800984:	ff 75 14             	pushl  0x14(%ebp)
  800987:	ff 75 10             	pushl  0x10(%ebp)
  80098a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098d:	50                   	push   %eax
  80098e:	68 1a 09 80 00       	push   $0x80091a
  800993:	e8 80 fb ff ff       	call   800518 <vprintfmt>
  800998:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    

008009a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8009af:	83 c0 04             	add    $0x4,%eax
  8009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	ff 75 0c             	pushl  0xc(%ebp)
  8009bf:	ff 75 08             	pushl  0x8(%ebp)
  8009c2:	e8 89 ff ff ff       	call   800950 <vsnprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
  8009ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009df:	eb 06                	jmp    8009e7 <strlen+0x15>
		n++;
  8009e1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e4:	ff 45 08             	incl   0x8(%ebp)
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	84 c0                	test   %al,%al
  8009ee:	75 f1                	jne    8009e1 <strlen+0xf>
		n++;
	return n;
  8009f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    

008009f5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a02:	eb 09                	jmp    800a0d <strnlen+0x18>
		n++;
  800a04:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a07:	ff 45 08             	incl   0x8(%ebp)
  800a0a:	ff 4d 0c             	decl   0xc(%ebp)
  800a0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a11:	74 09                	je     800a1c <strnlen+0x27>
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	84 c0                	test   %al,%al
  800a1a:	75 e8                	jne    800a04 <strnlen+0xf>
		n++;
	return n;
  800a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a2d:	90                   	nop
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8d 50 01             	lea    0x1(%eax),%edx
  800a34:	89 55 08             	mov    %edx,0x8(%ebp)
  800a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a40:	8a 12                	mov    (%edx),%dl
  800a42:	88 10                	mov    %dl,(%eax)
  800a44:	8a 00                	mov    (%eax),%al
  800a46:	84 c0                	test   %al,%al
  800a48:	75 e4                	jne    800a2e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a62:	eb 1f                	jmp    800a83 <strncpy+0x34>
		*dst++ = *src;
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	8d 50 01             	lea    0x1(%eax),%edx
  800a6a:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a70:	8a 12                	mov    (%edx),%dl
  800a72:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	8a 00                	mov    (%eax),%al
  800a79:	84 c0                	test   %al,%al
  800a7b:	74 03                	je     800a80 <strncpy+0x31>
			src++;
  800a7d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a80:	ff 45 fc             	incl   -0x4(%ebp)
  800a83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a86:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a89:	72 d9                	jb     800a64 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa0:	74 30                	je     800ad2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa2:	eb 16                	jmp    800aba <strlcpy+0x2a>
			*dst++ = *src++;
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	8d 50 01             	lea    0x1(%eax),%edx
  800aaa:	89 55 08             	mov    %edx,0x8(%ebp)
  800aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ab6:	8a 12                	mov    (%edx),%dl
  800ab8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aba:	ff 4d 10             	decl   0x10(%ebp)
  800abd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac1:	74 09                	je     800acc <strlcpy+0x3c>
  800ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac6:	8a 00                	mov    (%eax),%al
  800ac8:	84 c0                	test   %al,%al
  800aca:	75 d8                	jne    800aa4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad8:	29 c2                	sub    %eax,%edx
  800ada:	89 d0                	mov    %edx,%eax
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ae1:	eb 06                	jmp    800ae9 <strcmp+0xb>
		p++, q++;
  800ae3:	ff 45 08             	incl   0x8(%ebp)
  800ae6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8a 00                	mov    (%eax),%al
  800aee:	84 c0                	test   %al,%al
  800af0:	74 0e                	je     800b00 <strcmp+0x22>
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8a 10                	mov    (%eax),%dl
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	38 c2                	cmp    %al,%dl
  800afe:	74 e3                	je     800ae3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f b6 d0             	movzbl %al,%edx
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	8a 00                	mov    (%eax),%al
  800b0d:	0f b6 c0             	movzbl %al,%eax
  800b10:	29 c2                	sub    %eax,%edx
  800b12:	89 d0                	mov    %edx,%eax
}
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b19:	eb 09                	jmp    800b24 <strncmp+0xe>
		n--, p++, q++;
  800b1b:	ff 4d 10             	decl   0x10(%ebp)
  800b1e:	ff 45 08             	incl   0x8(%ebp)
  800b21:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b28:	74 17                	je     800b41 <strncmp+0x2b>
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8a 00                	mov    (%eax),%al
  800b2f:	84 c0                	test   %al,%al
  800b31:	74 0e                	je     800b41 <strncmp+0x2b>
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8a 10                	mov    (%eax),%dl
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	38 c2                	cmp    %al,%dl
  800b3f:	74 da                	je     800b1b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b45:	75 07                	jne    800b4e <strncmp+0x38>
		return 0;
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4c:	eb 14                	jmp    800b62 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f b6 d0             	movzbl %al,%edx
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	0f b6 c0             	movzbl %al,%eax
  800b5e:	29 c2                	sub    %eax,%edx
  800b60:	89 d0                	mov    %edx,%eax
}
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b70:	eb 12                	jmp    800b84 <strchr+0x20>
		if (*s == c)
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8a 00                	mov    (%eax),%al
  800b77:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b7a:	75 05                	jne    800b81 <strchr+0x1d>
			return (char *) s;
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	eb 11                	jmp    800b92 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b81:	ff 45 08             	incl   0x8(%ebp)
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	84 c0                	test   %al,%al
  800b8b:	75 e5                	jne    800b72 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 04             	sub    $0x4,%esp
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba0:	eb 0d                	jmp    800baf <strfind+0x1b>
		if (*s == c)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8a 00                	mov    (%eax),%al
  800ba7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800baa:	74 0e                	je     800bba <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 ea                	jne    800ba2 <strfind+0xe>
  800bb8:	eb 01                	jmp    800bbb <strfind+0x27>
		if (*s == c)
			break;
  800bba:	90                   	nop
	return (char *) s;
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bcc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bd0:	76 63                	jbe    800c35 <memset+0x75>
		uint64 data_block = c;
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	99                   	cltd   
  800bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be2:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800be6:	c1 e0 08             	shl    $0x8,%eax
  800be9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bec:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf5:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800bf9:	c1 e0 10             	shl    $0x10,%eax
  800bfc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c08:	89 c2                	mov    %eax,%edx
  800c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c12:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c15:	eb 18                	jmp    800c2f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c17:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c1a:	8d 41 08             	lea    0x8(%ecx),%eax
  800c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c26:	89 01                	mov    %eax,(%ecx)
  800c28:	89 51 04             	mov    %edx,0x4(%ecx)
  800c2b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c2f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c33:	77 e2                	ja     800c17 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c39:	74 23                	je     800c5e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c41:	eb 0e                	jmp    800c51 <memset+0x91>
			*p8++ = (uint8)c;
  800c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c46:	8d 50 01             	lea    0x1(%eax),%edx
  800c49:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c57:	89 55 10             	mov    %edx,0x10(%ebp)
  800c5a:	85 c0                	test   %eax,%eax
  800c5c:	75 e5                	jne    800c43 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c75:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c79:	76 24                	jbe    800c9f <memcpy+0x3c>
		while(n >= 8){
  800c7b:	eb 1c                	jmp    800c99 <memcpy+0x36>
			*d64 = *s64;
  800c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c80:	8b 50 04             	mov    0x4(%eax),%edx
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c88:	89 01                	mov    %eax,(%ecx)
  800c8a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c8d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c91:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c95:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c99:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c9d:	77 de                	ja     800c7d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca3:	74 31                	je     800cd6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800cb1:	eb 16                	jmp    800cc9 <memcpy+0x66>
			*d8++ = *s8++;
  800cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb6:	8d 50 01             	lea    0x1(%eax),%edx
  800cb9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cc5:	8a 12                	mov    (%edx),%dl
  800cc7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ccf:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	75 dd                	jne    800cb3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ced:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cf3:	73 50                	jae    800d45 <memmove+0x6a>
  800cf5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfb:	01 d0                	add    %edx,%eax
  800cfd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d00:	76 43                	jbe    800d45 <memmove+0x6a>
		s += n;
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d08:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d0e:	eb 10                	jmp    800d20 <memmove+0x45>
			*--d = *--s;
  800d10:	ff 4d f8             	decl   -0x8(%ebp)
  800d13:	ff 4d fc             	decl   -0x4(%ebp)
  800d16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d19:	8a 10                	mov    (%eax),%dl
  800d1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d26:	89 55 10             	mov    %edx,0x10(%ebp)
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	75 e3                	jne    800d10 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2d:	eb 23                	jmp    800d52 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d45:	8b 45 10             	mov    0x10(%ebp),%eax
  800d48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	75 dd                	jne    800d2f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d69:	eb 2a                	jmp    800d95 <memcmp+0x3e>
		if (*s1 != *s2)
  800d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	38 c2                	cmp    %al,%dl
  800d77:	74 16                	je     800d8f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
  800d8d:	eb 18                	jmp    800da7 <memcmp+0x50>
		s1++, s2++;
  800d8f:	ff 45 fc             	incl   -0x4(%ebp)
  800d92:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d95:	8b 45 10             	mov    0x10(%ebp),%eax
  800d98:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	75 c9                	jne    800d6b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	01 d0                	add    %edx,%eax
  800db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dba:	eb 15                	jmp    800dd1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	0f b6 d0             	movzbl %al,%edx
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	0f b6 c0             	movzbl %al,%eax
  800dca:	39 c2                	cmp    %eax,%edx
  800dcc:	74 0d                	je     800ddb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dd7:	72 e3                	jb     800dbc <memfind+0x13>
  800dd9:	eb 01                	jmp    800ddc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ddb:	90                   	nop
	return (void *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800de7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df5:	eb 03                	jmp    800dfa <strtol+0x19>
		s++;
  800df7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	3c 20                	cmp    $0x20,%al
  800e01:	74 f4                	je     800df7 <strtol+0x16>
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	3c 09                	cmp    $0x9,%al
  800e0a:	74 eb                	je     800df7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	3c 2b                	cmp    $0x2b,%al
  800e13:	75 05                	jne    800e1a <strtol+0x39>
		s++;
  800e15:	ff 45 08             	incl   0x8(%ebp)
  800e18:	eb 13                	jmp    800e2d <strtol+0x4c>
	else if (*s == '-')
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	3c 2d                	cmp    $0x2d,%al
  800e21:	75 0a                	jne    800e2d <strtol+0x4c>
		s++, neg = 1;
  800e23:	ff 45 08             	incl   0x8(%ebp)
  800e26:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e31:	74 06                	je     800e39 <strtol+0x58>
  800e33:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e37:	75 20                	jne    800e59 <strtol+0x78>
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	3c 30                	cmp    $0x30,%al
  800e40:	75 17                	jne    800e59 <strtol+0x78>
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	40                   	inc    %eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	3c 78                	cmp    $0x78,%al
  800e4a:	75 0d                	jne    800e59 <strtol+0x78>
		s += 2, base = 16;
  800e4c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e50:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e57:	eb 28                	jmp    800e81 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5d:	75 15                	jne    800e74 <strtol+0x93>
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3c 30                	cmp    $0x30,%al
  800e66:	75 0c                	jne    800e74 <strtol+0x93>
		s++, base = 8;
  800e68:	ff 45 08             	incl   0x8(%ebp)
  800e6b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e72:	eb 0d                	jmp    800e81 <strtol+0xa0>
	else if (base == 0)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	75 07                	jne    800e81 <strtol+0xa0>
		base = 10;
  800e7a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 2f                	cmp    $0x2f,%al
  800e88:	7e 19                	jle    800ea3 <strtol+0xc2>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 39                	cmp    $0x39,%al
  800e91:	7f 10                	jg     800ea3 <strtol+0xc2>
			dig = *s - '0';
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	0f be c0             	movsbl %al,%eax
  800e9b:	83 e8 30             	sub    $0x30,%eax
  800e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ea1:	eb 42                	jmp    800ee5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3c 60                	cmp    $0x60,%al
  800eaa:	7e 19                	jle    800ec5 <strtol+0xe4>
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	3c 7a                	cmp    $0x7a,%al
  800eb3:	7f 10                	jg     800ec5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f be c0             	movsbl %al,%eax
  800ebd:	83 e8 57             	sub    $0x57,%eax
  800ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ec3:	eb 20                	jmp    800ee5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	3c 40                	cmp    $0x40,%al
  800ecc:	7e 39                	jle    800f07 <strtol+0x126>
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	3c 5a                	cmp    $0x5a,%al
  800ed5:	7f 30                	jg     800f07 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f be c0             	movsbl %al,%eax
  800edf:	83 e8 37             	sub    $0x37,%eax
  800ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eeb:	7d 19                	jge    800f06 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800eed:	ff 45 08             	incl   0x8(%ebp)
  800ef0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ef7:	89 c2                	mov    %eax,%edx
  800ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efc:	01 d0                	add    %edx,%eax
  800efe:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f01:	e9 7b ff ff ff       	jmp    800e81 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f06:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0b:	74 08                	je     800f15 <strtol+0x134>
		*endptr = (char *) s;
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f19:	74 07                	je     800f22 <strtol+0x141>
  800f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1e:	f7 d8                	neg    %eax
  800f20:	eb 03                	jmp    800f25 <strtol+0x144>
  800f22:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    

00800f27 <ltostr>:

void
ltostr(long value, char *str)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f34:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f3f:	79 13                	jns    800f54 <ltostr+0x2d>
	{
		neg = 1;
  800f41:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f4e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f51:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f5c:	99                   	cltd   
  800f5d:	f7 f9                	idiv   %ecx
  800f5f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	89 c2                	mov    %eax,%edx
  800f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f70:	01 d0                	add    %edx,%eax
  800f72:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f75:	83 c2 30             	add    $0x30,%edx
  800f78:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f7d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f82:	f7 e9                	imul   %ecx
  800f84:	c1 fa 02             	sar    $0x2,%edx
  800f87:	89 c8                	mov    %ecx,%eax
  800f89:	c1 f8 1f             	sar    $0x1f,%eax
  800f8c:	29 c2                	sub    %eax,%edx
  800f8e:	89 d0                	mov    %edx,%eax
  800f90:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f97:	75 bb                	jne    800f54 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	48                   	dec    %eax
  800fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fab:	74 3d                	je     800fea <ltostr+0xc3>
		start = 1 ;
  800fad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fb4:	eb 34                	jmp    800fea <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	01 d0                	add    %edx,%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	01 c2                	add    %eax,%edx
  800fcb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	01 c8                	add    %ecx,%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fe2:	88 02                	mov    %al,(%edx)
		start++ ;
  800fe4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fe7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ff0:	7c c4                	jl     800fb6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ff2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff8:	01 d0                	add    %edx,%eax
  800ffa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ffd:	90                   	nop
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801006:	ff 75 08             	pushl  0x8(%ebp)
  801009:	e8 c4 f9 ff ff       	call   8009d2 <strlen>
  80100e:	83 c4 04             	add    $0x4,%esp
  801011:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801014:	ff 75 0c             	pushl  0xc(%ebp)
  801017:	e8 b6 f9 ff ff       	call   8009d2 <strlen>
  80101c:	83 c4 04             	add    $0x4,%esp
  80101f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801022:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801030:	eb 17                	jmp    801049 <strcconcat+0x49>
		final[s] = str1[s] ;
  801032:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801035:	8b 45 10             	mov    0x10(%ebp),%eax
  801038:	01 c2                	add    %eax,%edx
  80103a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	01 c8                	add    %ecx,%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801046:	ff 45 fc             	incl   -0x4(%ebp)
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104f:	7c e1                	jl     801032 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801051:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801058:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80105f:	eb 1f                	jmp    801080 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80106a:	89 c2                	mov    %eax,%edx
  80106c:	8b 45 10             	mov    0x10(%ebp),%eax
  80106f:	01 c2                	add    %eax,%edx
  801071:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	01 c8                	add    %ecx,%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80107d:	ff 45 f8             	incl   -0x8(%ebp)
  801080:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801083:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801086:	7c d9                	jl     801061 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801088:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	01 d0                	add    %edx,%eax
  801090:	c6 00 00             	movb   $0x0,(%eax)
}
  801093:	90                   	nop
  801094:	c9                   	leave  
  801095:	c3                   	ret    

00801096 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801099:	8b 45 14             	mov    0x14(%ebp),%eax
  80109c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a5:	8b 00                	mov    (%eax),%eax
  8010a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	01 d0                	add    %edx,%eax
  8010b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010b9:	eb 0c                	jmp    8010c7 <strsplit+0x31>
			*string++ = 0;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	84 c0                	test   %al,%al
  8010ce:	74 18                	je     8010e8 <strsplit+0x52>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f be c0             	movsbl %al,%eax
  8010d8:	50                   	push   %eax
  8010d9:	ff 75 0c             	pushl  0xc(%ebp)
  8010dc:	e8 83 fa ff ff       	call   800b64 <strchr>
  8010e1:	83 c4 08             	add    $0x8,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	75 d3                	jne    8010bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	84 c0                	test   %al,%al
  8010ef:	74 5a                	je     80114b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f4:	8b 00                	mov    (%eax),%eax
  8010f6:	83 f8 0f             	cmp    $0xf,%eax
  8010f9:	75 07                	jne    801102 <strsplit+0x6c>
		{
			return 0;
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801100:	eb 66                	jmp    801168 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801102:	8b 45 14             	mov    0x14(%ebp),%eax
  801105:	8b 00                	mov    (%eax),%eax
  801107:	8d 48 01             	lea    0x1(%eax),%ecx
  80110a:	8b 55 14             	mov    0x14(%ebp),%edx
  80110d:	89 0a                	mov    %ecx,(%edx)
  80110f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	01 c2                	add    %eax,%edx
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801120:	eb 03                	jmp    801125 <strsplit+0x8f>
			string++;
  801122:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	84 c0                	test   %al,%al
  80112c:	74 8b                	je     8010b9 <strsplit+0x23>
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	0f be c0             	movsbl %al,%eax
  801136:	50                   	push   %eax
  801137:	ff 75 0c             	pushl  0xc(%ebp)
  80113a:	e8 25 fa ff ff       	call   800b64 <strchr>
  80113f:	83 c4 08             	add    $0x8,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	74 dc                	je     801122 <strsplit+0x8c>
			string++;
	}
  801146:	e9 6e ff ff ff       	jmp    8010b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80114b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80114c:	8b 45 14             	mov    0x14(%ebp),%eax
  80114f:	8b 00                	mov    (%eax),%eax
  801151:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
  80115d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801163:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117d:	eb 4a                	jmp    8011c9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80117f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c2                	add    %eax,%edx
  801187:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	01 c8                	add    %ecx,%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801193:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	01 d0                	add    %edx,%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 40                	cmp    $0x40,%al
  80119f:	7e 25                	jle    8011c6 <str2lower+0x5c>
  8011a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	3c 5a                	cmp    $0x5a,%al
  8011ad:	7f 17                	jg     8011c6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	01 ca                	add    %ecx,%edx
  8011bf:	8a 12                	mov    (%edx),%dl
  8011c1:	83 c2 20             	add    $0x20,%edx
  8011c4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011c6:	ff 45 fc             	incl   -0x4(%ebp)
  8011c9:	ff 75 0c             	pushl  0xc(%ebp)
  8011cc:	e8 01 f8 ff ff       	call   8009d2 <strlen>
  8011d1:	83 c4 04             	add    $0x4,%esp
  8011d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d7:	7f a6                	jg     80117f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	57                   	push   %edi
  8011e2:	56                   	push   %esi
  8011e3:	53                   	push   %ebx
  8011e4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011f3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011f6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011f9:	cd 30                	int    $0x30
  8011fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	5b                   	pop    %ebx
  801205:	5e                   	pop    %esi
  801206:	5f                   	pop    %edi
  801207:	5d                   	pop    %ebp
  801208:	c3                   	ret    

00801209 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 04             	sub    $0x4,%esp
  80120f:	8b 45 10             	mov    0x10(%ebp),%eax
  801212:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801215:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801218:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	6a 00                	push   $0x0
  801221:	51                   	push   %ecx
  801222:	52                   	push   %edx
  801223:	ff 75 0c             	pushl  0xc(%ebp)
  801226:	50                   	push   %eax
  801227:	6a 00                	push   $0x0
  801229:	e8 b0 ff ff ff       	call   8011de <syscall>
  80122e:	83 c4 18             	add    $0x18,%esp
}
  801231:	90                   	nop
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <sys_cgetc>:

int
sys_cgetc(void)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 02                	push   $0x2
  801243:	e8 96 ff ff ff       	call   8011de <syscall>
  801248:	83 c4 18             	add    $0x18,%esp
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 03                	push   $0x3
  80125c:	e8 7d ff ff ff       	call   8011de <syscall>
  801261:	83 c4 18             	add    $0x18,%esp
}
  801264:	90                   	nop
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 04                	push   $0x4
  801276:	e8 63 ff ff ff       	call   8011de <syscall>
  80127b:	83 c4 18             	add    $0x18,%esp
}
  80127e:	90                   	nop
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801284:	8b 55 0c             	mov    0xc(%ebp),%edx
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	52                   	push   %edx
  801291:	50                   	push   %eax
  801292:	6a 08                	push   $0x8
  801294:	e8 45 ff ff ff       	call   8011de <syscall>
  801299:	83 c4 18             	add    $0x18,%esp
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	56                   	push   %esi
  8012a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8012a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	56                   	push   %esi
  8012b3:	53                   	push   %ebx
  8012b4:	51                   	push   %ecx
  8012b5:	52                   	push   %edx
  8012b6:	50                   	push   %eax
  8012b7:	6a 09                	push   $0x9
  8012b9:	e8 20 ff ff ff       	call   8011de <syscall>
  8012be:	83 c4 18             	add    $0x18,%esp
}
  8012c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c4:	5b                   	pop    %ebx
  8012c5:	5e                   	pop    %esi
  8012c6:	5d                   	pop    %ebp
  8012c7:	c3                   	ret    

008012c8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	ff 75 08             	pushl  0x8(%ebp)
  8012d6:	6a 0a                	push   $0xa
  8012d8:	e8 01 ff ff ff       	call   8011de <syscall>
  8012dd:	83 c4 18             	add    $0x18,%esp
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	ff 75 08             	pushl  0x8(%ebp)
  8012f1:	6a 0b                	push   $0xb
  8012f3:	e8 e6 fe ff ff       	call   8011de <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 0c                	push   $0xc
  80130c:	e8 cd fe ff ff       	call   8011de <syscall>
  801311:	83 c4 18             	add    $0x18,%esp
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 0d                	push   $0xd
  801325:	e8 b4 fe ff ff       	call   8011de <syscall>
  80132a:	83 c4 18             	add    $0x18,%esp
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 0e                	push   $0xe
  80133e:	e8 9b fe ff ff       	call   8011de <syscall>
  801343:	83 c4 18             	add    $0x18,%esp
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 0f                	push   $0xf
  801357:	e8 82 fe ff ff       	call   8011de <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	ff 75 08             	pushl  0x8(%ebp)
  80136f:	6a 10                	push   $0x10
  801371:	e8 68 fe ff ff       	call   8011de <syscall>
  801376:	83 c4 18             	add    $0x18,%esp
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 11                	push   $0x11
  80138a:	e8 4f fe ff ff       	call   8011de <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <sys_cputc>:

void
sys_cputc(const char c)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	50                   	push   %eax
  8013ae:	6a 01                	push   $0x1
  8013b0:	e8 29 fe ff ff       	call   8011de <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
}
  8013b8:	90                   	nop
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 14                	push   $0x14
  8013ca:	e8 0f fe ff ff       	call   8011de <syscall>
  8013cf:	83 c4 18             	add    $0x18,%esp
}
  8013d2:	90                   	nop
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	8b 45 10             	mov    0x10(%ebp),%eax
  8013de:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	6a 00                	push   $0x0
  8013ed:	51                   	push   %ecx
  8013ee:	52                   	push   %edx
  8013ef:	ff 75 0c             	pushl  0xc(%ebp)
  8013f2:	50                   	push   %eax
  8013f3:	6a 15                	push   $0x15
  8013f5:	e8 e4 fd ff ff       	call   8011de <syscall>
  8013fa:	83 c4 18             	add    $0x18,%esp
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801402:	8b 55 0c             	mov    0xc(%ebp),%edx
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	52                   	push   %edx
  80140f:	50                   	push   %eax
  801410:	6a 16                	push   $0x16
  801412:	e8 c7 fd ff ff       	call   8011de <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80141f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801422:	8b 55 0c             	mov    0xc(%ebp),%edx
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	51                   	push   %ecx
  80142d:	52                   	push   %edx
  80142e:	50                   	push   %eax
  80142f:	6a 17                	push   $0x17
  801431:	e8 a8 fd ff ff       	call   8011de <syscall>
  801436:	83 c4 18             	add    $0x18,%esp
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	52                   	push   %edx
  80144b:	50                   	push   %eax
  80144c:	6a 18                	push   $0x18
  80144e:	e8 8b fd ff ff       	call   8011de <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	6a 00                	push   $0x0
  801460:	ff 75 14             	pushl  0x14(%ebp)
  801463:	ff 75 10             	pushl  0x10(%ebp)
  801466:	ff 75 0c             	pushl  0xc(%ebp)
  801469:	50                   	push   %eax
  80146a:	6a 19                	push   $0x19
  80146c:	e8 6d fd ff ff       	call   8011de <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	50                   	push   %eax
  801485:	6a 1a                	push   $0x1a
  801487:	e8 52 fd ff ff       	call   8011de <syscall>
  80148c:	83 c4 18             	add    $0x18,%esp
}
  80148f:	90                   	nop
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	50                   	push   %eax
  8014a1:	6a 1b                	push   $0x1b
  8014a3:	e8 36 fd ff ff       	call   8011de <syscall>
  8014a8:	83 c4 18             	add    $0x18,%esp
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 05                	push   $0x5
  8014bc:	e8 1d fd ff ff       	call   8011de <syscall>
  8014c1:	83 c4 18             	add    $0x18,%esp
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 06                	push   $0x6
  8014d5:	e8 04 fd ff ff       	call   8011de <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 07                	push   $0x7
  8014ee:	e8 eb fc ff ff       	call   8011de <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <sys_exit_env>:


void sys_exit_env(void)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 1c                	push   $0x1c
  801507:	e8 d2 fc ff ff       	call   8011de <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	90                   	nop
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801518:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80151b:	8d 50 04             	lea    0x4(%eax),%edx
  80151e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	52                   	push   %edx
  801528:	50                   	push   %eax
  801529:	6a 1d                	push   $0x1d
  80152b:	e8 ae fc ff ff       	call   8011de <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
	return result;
  801533:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801536:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801539:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153c:	89 01                	mov    %eax,(%ecx)
  80153e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	c9                   	leave  
  801545:	c2 04 00             	ret    $0x4

00801548 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	ff 75 10             	pushl  0x10(%ebp)
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	ff 75 08             	pushl  0x8(%ebp)
  801558:	6a 13                	push   $0x13
  80155a:	e8 7f fc ff ff       	call   8011de <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
	return ;
  801562:	90                   	nop
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_rcr2>:
uint32 sys_rcr2()
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 1e                	push   $0x1e
  801574:	e8 65 fc ff ff       	call   8011de <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80158a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	50                   	push   %eax
  801597:	6a 1f                	push   $0x1f
  801599:	e8 40 fc ff ff       	call   8011de <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a1:	90                   	nop
}
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <rsttst>:
void rsttst()
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 21                	push   $0x21
  8015b3:	e8 26 fc ff ff       	call   8011de <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015bb:	90                   	nop
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015ca:	8b 55 18             	mov    0x18(%ebp),%edx
  8015cd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015d1:	52                   	push   %edx
  8015d2:	50                   	push   %eax
  8015d3:	ff 75 10             	pushl  0x10(%ebp)
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	6a 20                	push   $0x20
  8015de:	e8 fb fb ff ff       	call   8011de <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e6:	90                   	nop
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <chktst>:
void chktst(uint32 n)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	ff 75 08             	pushl  0x8(%ebp)
  8015f7:	6a 22                	push   $0x22
  8015f9:	e8 e0 fb ff ff       	call   8011de <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801601:	90                   	nop
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <inctst>:

void inctst()
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 23                	push   $0x23
  801613:	e8 c6 fb ff ff       	call   8011de <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
	return ;
  80161b:	90                   	nop
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <gettst>:
uint32 gettst()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 24                	push   $0x24
  80162d:	e8 ac fb ff ff       	call   8011de <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 25                	push   $0x25
  801646:	e8 93 fb ff ff       	call   8011de <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
  80164e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801653:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	ff 75 08             	pushl  0x8(%ebp)
  801670:	6a 26                	push   $0x26
  801672:	e8 67 fb ff ff       	call   8011de <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
	return ;
  80167a:	90                   	nop
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801681:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801684:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	6a 00                	push   $0x0
  80168f:	53                   	push   %ebx
  801690:	51                   	push   %ecx
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 27                	push   $0x27
  801695:	e8 44 fb ff ff       	call   8011de <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	6a 28                	push   $0x28
  8016b5:	e8 24 fb ff ff       	call   8011de <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	6a 00                	push   $0x0
  8016cd:	51                   	push   %ecx
  8016ce:	ff 75 10             	pushl  0x10(%ebp)
  8016d1:	52                   	push   %edx
  8016d2:	50                   	push   %eax
  8016d3:	6a 29                	push   $0x29
  8016d5:	e8 04 fb ff ff       	call   8011de <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	ff 75 10             	pushl  0x10(%ebp)
  8016e9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ec:	ff 75 08             	pushl  0x8(%ebp)
  8016ef:	6a 12                	push   $0x12
  8016f1:	e8 e8 fa ff ff       	call   8011de <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f9:	90                   	nop
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	52                   	push   %edx
  80170c:	50                   	push   %eax
  80170d:	6a 2a                	push   $0x2a
  80170f:	e8 ca fa ff ff       	call   8011de <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
	return;
  801717:	90                   	nop
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 2b                	push   $0x2b
  801729:	e8 b0 fa ff ff       	call   8011de <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	ff 75 08             	pushl  0x8(%ebp)
  801742:	6a 2d                	push   $0x2d
  801744:	e8 95 fa ff ff       	call   8011de <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
	return;
  80174c:	90                   	nop
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	ff 75 0c             	pushl  0xc(%ebp)
  80175b:	ff 75 08             	pushl  0x8(%ebp)
  80175e:	6a 2c                	push   $0x2c
  801760:	e8 79 fa ff ff       	call   8011de <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
	return ;
  801768:	90                   	nop
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801771:	83 ec 04             	sub    $0x4,%esp
  801774:	68 08 21 80 00       	push   $0x802108
  801779:	68 25 01 00 00       	push   $0x125
  80177e:	68 3b 21 80 00       	push   $0x80213b
  801783:	e8 00 00 00 00       	call   801788 <_panic>

00801788 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80178e:	8d 45 10             	lea    0x10(%ebp),%eax
  801791:	83 c0 04             	add    $0x4,%eax
  801794:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801797:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80179c:	85 c0                	test   %eax,%eax
  80179e:	74 16                	je     8017b6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017a0:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	50                   	push   %eax
  8017a9:	68 4c 21 80 00       	push   $0x80214c
  8017ae:	e8 46 eb ff ff       	call   8002f9 <cprintf>
  8017b3:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017b6:	a1 04 30 80 00       	mov    0x803004,%eax
  8017bb:	83 ec 0c             	sub    $0xc,%esp
  8017be:	ff 75 0c             	pushl  0xc(%ebp)
  8017c1:	ff 75 08             	pushl  0x8(%ebp)
  8017c4:	50                   	push   %eax
  8017c5:	68 54 21 80 00       	push   $0x802154
  8017ca:	6a 74                	push   $0x74
  8017cc:	e8 55 eb ff ff       	call   800326 <cprintf_colored>
  8017d1:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d7:	83 ec 08             	sub    $0x8,%esp
  8017da:	ff 75 f4             	pushl  -0xc(%ebp)
  8017dd:	50                   	push   %eax
  8017de:	e8 a7 ea ff ff       	call   80028a <vcprintf>
  8017e3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	6a 00                	push   $0x0
  8017eb:	68 7c 21 80 00       	push   $0x80217c
  8017f0:	e8 95 ea ff ff       	call   80028a <vcprintf>
  8017f5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017f8:	e8 0e ea ff ff       	call   80020b <exit>

	// should not return here
	while (1) ;
  8017fd:	eb fe                	jmp    8017fd <_panic+0x75>

008017ff <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801805:	a1 20 30 80 00       	mov    0x803020,%eax
  80180a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	39 c2                	cmp    %eax,%edx
  801815:	74 14                	je     80182b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	68 80 21 80 00       	push   $0x802180
  80181f:	6a 26                	push   $0x26
  801821:	68 cc 21 80 00       	push   $0x8021cc
  801826:	e8 5d ff ff ff       	call   801788 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80182b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801832:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801839:	e9 c5 00 00 00       	jmp    801903 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	01 d0                	add    %edx,%eax
  80184d:	8b 00                	mov    (%eax),%eax
  80184f:	85 c0                	test   %eax,%eax
  801851:	75 08                	jne    80185b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801853:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801856:	e9 a5 00 00 00       	jmp    801900 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80185b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801862:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801869:	eb 69                	jmp    8018d4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80186b:	a1 20 30 80 00       	mov    0x803020,%eax
  801870:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801876:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801879:	89 d0                	mov    %edx,%eax
  80187b:	01 c0                	add    %eax,%eax
  80187d:	01 d0                	add    %edx,%eax
  80187f:	c1 e0 03             	shl    $0x3,%eax
  801882:	01 c8                	add    %ecx,%eax
  801884:	8a 40 04             	mov    0x4(%eax),%al
  801887:	84 c0                	test   %al,%al
  801889:	75 46                	jne    8018d1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80188b:	a1 20 30 80 00       	mov    0x803020,%eax
  801890:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801896:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801899:	89 d0                	mov    %edx,%eax
  80189b:	01 c0                	add    %eax,%eax
  80189d:	01 d0                	add    %edx,%eax
  80189f:	c1 e0 03             	shl    $0x3,%eax
  8018a2:	01 c8                	add    %ecx,%eax
  8018a4:	8b 00                	mov    (%eax),%eax
  8018a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	01 c8                	add    %ecx,%eax
  8018c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018c4:	39 c2                	cmp    %eax,%edx
  8018c6:	75 09                	jne    8018d1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018cf:	eb 15                	jmp    8018e6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018d1:	ff 45 e8             	incl   -0x18(%ebp)
  8018d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8018d9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e2:	39 c2                	cmp    %eax,%edx
  8018e4:	77 85                	ja     80186b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018ea:	75 14                	jne    801900 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	68 d8 21 80 00       	push   $0x8021d8
  8018f4:	6a 3a                	push   $0x3a
  8018f6:	68 cc 21 80 00       	push   $0x8021cc
  8018fb:	e8 88 fe ff ff       	call   801788 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801900:	ff 45 f0             	incl   -0x10(%ebp)
  801903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801906:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801909:	0f 8c 2f ff ff ff    	jl     80183e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80190f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801916:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80191d:	eb 26                	jmp    801945 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80191f:	a1 20 30 80 00       	mov    0x803020,%eax
  801924:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80192a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192d:	89 d0                	mov    %edx,%eax
  80192f:	01 c0                	add    %eax,%eax
  801931:	01 d0                	add    %edx,%eax
  801933:	c1 e0 03             	shl    $0x3,%eax
  801936:	01 c8                	add    %ecx,%eax
  801938:	8a 40 04             	mov    0x4(%eax),%al
  80193b:	3c 01                	cmp    $0x1,%al
  80193d:	75 03                	jne    801942 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80193f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801942:	ff 45 e0             	incl   -0x20(%ebp)
  801945:	a1 20 30 80 00       	mov    0x803020,%eax
  80194a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801953:	39 c2                	cmp    %eax,%edx
  801955:	77 c8                	ja     80191f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80195d:	74 14                	je     801973 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80195f:	83 ec 04             	sub    $0x4,%esp
  801962:	68 2c 22 80 00       	push   $0x80222c
  801967:	6a 44                	push   $0x44
  801969:	68 cc 21 80 00       	push   $0x8021cc
  80196e:	e8 15 fe ff ff       	call   801788 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801973:	90                   	nop
  801974:	c9                   	leave  
  801975:	c3                   	ret    
  801976:	66 90                	xchg   %ax,%ax

00801978 <__udivdi3>:
  801978:	55                   	push   %ebp
  801979:	57                   	push   %edi
  80197a:	56                   	push   %esi
  80197b:	53                   	push   %ebx
  80197c:	83 ec 1c             	sub    $0x1c,%esp
  80197f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801983:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80198b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198f:	89 ca                	mov    %ecx,%edx
  801991:	89 f8                	mov    %edi,%eax
  801993:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801997:	85 f6                	test   %esi,%esi
  801999:	75 2d                	jne    8019c8 <__udivdi3+0x50>
  80199b:	39 cf                	cmp    %ecx,%edi
  80199d:	77 65                	ja     801a04 <__udivdi3+0x8c>
  80199f:	89 fd                	mov    %edi,%ebp
  8019a1:	85 ff                	test   %edi,%edi
  8019a3:	75 0b                	jne    8019b0 <__udivdi3+0x38>
  8019a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019aa:	31 d2                	xor    %edx,%edx
  8019ac:	f7 f7                	div    %edi
  8019ae:	89 c5                	mov    %eax,%ebp
  8019b0:	31 d2                	xor    %edx,%edx
  8019b2:	89 c8                	mov    %ecx,%eax
  8019b4:	f7 f5                	div    %ebp
  8019b6:	89 c1                	mov    %eax,%ecx
  8019b8:	89 d8                	mov    %ebx,%eax
  8019ba:	f7 f5                	div    %ebp
  8019bc:	89 cf                	mov    %ecx,%edi
  8019be:	89 fa                	mov    %edi,%edx
  8019c0:	83 c4 1c             	add    $0x1c,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5f                   	pop    %edi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    
  8019c8:	39 ce                	cmp    %ecx,%esi
  8019ca:	77 28                	ja     8019f4 <__udivdi3+0x7c>
  8019cc:	0f bd fe             	bsr    %esi,%edi
  8019cf:	83 f7 1f             	xor    $0x1f,%edi
  8019d2:	75 40                	jne    801a14 <__udivdi3+0x9c>
  8019d4:	39 ce                	cmp    %ecx,%esi
  8019d6:	72 0a                	jb     8019e2 <__udivdi3+0x6a>
  8019d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019dc:	0f 87 9e 00 00 00    	ja     801a80 <__udivdi3+0x108>
  8019e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e7:	89 fa                	mov    %edi,%edx
  8019e9:	83 c4 1c             	add    $0x1c,%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5e                   	pop    %esi
  8019ee:	5f                   	pop    %edi
  8019ef:	5d                   	pop    %ebp
  8019f0:	c3                   	ret    
  8019f1:	8d 76 00             	lea    0x0(%esi),%esi
  8019f4:	31 ff                	xor    %edi,%edi
  8019f6:	31 c0                	xor    %eax,%eax
  8019f8:	89 fa                	mov    %edi,%edx
  8019fa:	83 c4 1c             	add    $0x1c,%esp
  8019fd:	5b                   	pop    %ebx
  8019fe:	5e                   	pop    %esi
  8019ff:	5f                   	pop    %edi
  801a00:	5d                   	pop    %ebp
  801a01:	c3                   	ret    
  801a02:	66 90                	xchg   %ax,%ax
  801a04:	89 d8                	mov    %ebx,%eax
  801a06:	f7 f7                	div    %edi
  801a08:	31 ff                	xor    %edi,%edi
  801a0a:	89 fa                	mov    %edi,%edx
  801a0c:	83 c4 1c             	add    $0x1c,%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5e                   	pop    %esi
  801a11:	5f                   	pop    %edi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    
  801a14:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a19:	89 eb                	mov    %ebp,%ebx
  801a1b:	29 fb                	sub    %edi,%ebx
  801a1d:	89 f9                	mov    %edi,%ecx
  801a1f:	d3 e6                	shl    %cl,%esi
  801a21:	89 c5                	mov    %eax,%ebp
  801a23:	88 d9                	mov    %bl,%cl
  801a25:	d3 ed                	shr    %cl,%ebp
  801a27:	89 e9                	mov    %ebp,%ecx
  801a29:	09 f1                	or     %esi,%ecx
  801a2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a2f:	89 f9                	mov    %edi,%ecx
  801a31:	d3 e0                	shl    %cl,%eax
  801a33:	89 c5                	mov    %eax,%ebp
  801a35:	89 d6                	mov    %edx,%esi
  801a37:	88 d9                	mov    %bl,%cl
  801a39:	d3 ee                	shr    %cl,%esi
  801a3b:	89 f9                	mov    %edi,%ecx
  801a3d:	d3 e2                	shl    %cl,%edx
  801a3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a43:	88 d9                	mov    %bl,%cl
  801a45:	d3 e8                	shr    %cl,%eax
  801a47:	09 c2                	or     %eax,%edx
  801a49:	89 d0                	mov    %edx,%eax
  801a4b:	89 f2                	mov    %esi,%edx
  801a4d:	f7 74 24 0c          	divl   0xc(%esp)
  801a51:	89 d6                	mov    %edx,%esi
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	f7 e5                	mul    %ebp
  801a57:	39 d6                	cmp    %edx,%esi
  801a59:	72 19                	jb     801a74 <__udivdi3+0xfc>
  801a5b:	74 0b                	je     801a68 <__udivdi3+0xf0>
  801a5d:	89 d8                	mov    %ebx,%eax
  801a5f:	31 ff                	xor    %edi,%edi
  801a61:	e9 58 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a6c:	89 f9                	mov    %edi,%ecx
  801a6e:	d3 e2                	shl    %cl,%edx
  801a70:	39 c2                	cmp    %eax,%edx
  801a72:	73 e9                	jae    801a5d <__udivdi3+0xe5>
  801a74:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a77:	31 ff                	xor    %edi,%edi
  801a79:	e9 40 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a7e:	66 90                	xchg   %ax,%ax
  801a80:	31 c0                	xor    %eax,%eax
  801a82:	e9 37 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a87:	90                   	nop

00801a88 <__umoddi3>:
  801a88:	55                   	push   %ebp
  801a89:	57                   	push   %edi
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 1c             	sub    $0x1c,%esp
  801a8f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a93:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aa3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aa7:	89 f3                	mov    %esi,%ebx
  801aa9:	89 fa                	mov    %edi,%edx
  801aab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aaf:	89 34 24             	mov    %esi,(%esp)
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	75 1a                	jne    801ad0 <__umoddi3+0x48>
  801ab6:	39 f7                	cmp    %esi,%edi
  801ab8:	0f 86 a2 00 00 00    	jbe    801b60 <__umoddi3+0xd8>
  801abe:	89 c8                	mov    %ecx,%eax
  801ac0:	89 f2                	mov    %esi,%edx
  801ac2:	f7 f7                	div    %edi
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	31 d2                	xor    %edx,%edx
  801ac8:	83 c4 1c             	add    $0x1c,%esp
  801acb:	5b                   	pop    %ebx
  801acc:	5e                   	pop    %esi
  801acd:	5f                   	pop    %edi
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    
  801ad0:	39 f0                	cmp    %esi,%eax
  801ad2:	0f 87 ac 00 00 00    	ja     801b84 <__umoddi3+0xfc>
  801ad8:	0f bd e8             	bsr    %eax,%ebp
  801adb:	83 f5 1f             	xor    $0x1f,%ebp
  801ade:	0f 84 ac 00 00 00    	je     801b90 <__umoddi3+0x108>
  801ae4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ae9:	29 ef                	sub    %ebp,%edi
  801aeb:	89 fe                	mov    %edi,%esi
  801aed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801af1:	89 e9                	mov    %ebp,%ecx
  801af3:	d3 e0                	shl    %cl,%eax
  801af5:	89 d7                	mov    %edx,%edi
  801af7:	89 f1                	mov    %esi,%ecx
  801af9:	d3 ef                	shr    %cl,%edi
  801afb:	09 c7                	or     %eax,%edi
  801afd:	89 e9                	mov    %ebp,%ecx
  801aff:	d3 e2                	shl    %cl,%edx
  801b01:	89 14 24             	mov    %edx,(%esp)
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	d3 e0                	shl    %cl,%eax
  801b08:	89 c2                	mov    %eax,%edx
  801b0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0e:	d3 e0                	shl    %cl,%eax
  801b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b14:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b18:	89 f1                	mov    %esi,%ecx
  801b1a:	d3 e8                	shr    %cl,%eax
  801b1c:	09 d0                	or     %edx,%eax
  801b1e:	d3 eb                	shr    %cl,%ebx
  801b20:	89 da                	mov    %ebx,%edx
  801b22:	f7 f7                	div    %edi
  801b24:	89 d3                	mov    %edx,%ebx
  801b26:	f7 24 24             	mull   (%esp)
  801b29:	89 c6                	mov    %eax,%esi
  801b2b:	89 d1                	mov    %edx,%ecx
  801b2d:	39 d3                	cmp    %edx,%ebx
  801b2f:	0f 82 87 00 00 00    	jb     801bbc <__umoddi3+0x134>
  801b35:	0f 84 91 00 00 00    	je     801bcc <__umoddi3+0x144>
  801b3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b3f:	29 f2                	sub    %esi,%edx
  801b41:	19 cb                	sbb    %ecx,%ebx
  801b43:	89 d8                	mov    %ebx,%eax
  801b45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b49:	d3 e0                	shl    %cl,%eax
  801b4b:	89 e9                	mov    %ebp,%ecx
  801b4d:	d3 ea                	shr    %cl,%edx
  801b4f:	09 d0                	or     %edx,%eax
  801b51:	89 e9                	mov    %ebp,%ecx
  801b53:	d3 eb                	shr    %cl,%ebx
  801b55:	89 da                	mov    %ebx,%edx
  801b57:	83 c4 1c             	add    $0x1c,%esp
  801b5a:	5b                   	pop    %ebx
  801b5b:	5e                   	pop    %esi
  801b5c:	5f                   	pop    %edi
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    
  801b5f:	90                   	nop
  801b60:	89 fd                	mov    %edi,%ebp
  801b62:	85 ff                	test   %edi,%edi
  801b64:	75 0b                	jne    801b71 <__umoddi3+0xe9>
  801b66:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6b:	31 d2                	xor    %edx,%edx
  801b6d:	f7 f7                	div    %edi
  801b6f:	89 c5                	mov    %eax,%ebp
  801b71:	89 f0                	mov    %esi,%eax
  801b73:	31 d2                	xor    %edx,%edx
  801b75:	f7 f5                	div    %ebp
  801b77:	89 c8                	mov    %ecx,%eax
  801b79:	f7 f5                	div    %ebp
  801b7b:	89 d0                	mov    %edx,%eax
  801b7d:	e9 44 ff ff ff       	jmp    801ac6 <__umoddi3+0x3e>
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	89 c8                	mov    %ecx,%eax
  801b86:	89 f2                	mov    %esi,%edx
  801b88:	83 c4 1c             	add    $0x1c,%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5f                   	pop    %edi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    
  801b90:	3b 04 24             	cmp    (%esp),%eax
  801b93:	72 06                	jb     801b9b <__umoddi3+0x113>
  801b95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b99:	77 0f                	ja     801baa <__umoddi3+0x122>
  801b9b:	89 f2                	mov    %esi,%edx
  801b9d:	29 f9                	sub    %edi,%ecx
  801b9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ba3:	89 14 24             	mov    %edx,(%esp)
  801ba6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801baa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bae:	8b 14 24             	mov    (%esp),%edx
  801bb1:	83 c4 1c             	add    $0x1c,%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5e                   	pop    %esi
  801bb6:	5f                   	pop    %edi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    
  801bb9:	8d 76 00             	lea    0x0(%esi),%esi
  801bbc:	2b 04 24             	sub    (%esp),%eax
  801bbf:	19 fa                	sbb    %edi,%edx
  801bc1:	89 d1                	mov    %edx,%ecx
  801bc3:	89 c6                	mov    %eax,%esi
  801bc5:	e9 71 ff ff ff       	jmp    801b3b <__umoddi3+0xb3>
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bd0:	72 ea                	jb     801bbc <__umoddi3+0x134>
  801bd2:	89 d9                	mov    %ebx,%ecx
  801bd4:	e9 62 ff ff ff       	jmp    801b3b <__umoddi3+0xb3>
