
obj/user/dummy_process:     file format elf32-i386


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
  800031:	e8 97 00 00 00       	call   8000cd <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void high_complexity_function();

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	high_complexity_function() ;
  80003e:	e8 03 00 00 00       	call   800046 <high_complexity_function>
	return;
  800043:	90                   	nop
}
  800044:	c9                   	leave  
  800045:	c3                   	ret    

00800046 <high_complexity_function>:

void high_complexity_function()
{
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	83 ec 40             	sub    $0x40,%esp

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80004c:	0f 31                	rdtsc  
  80004e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800051:	89 55 d8             	mov    %edx,-0x28(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  800054:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800057:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80005a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80005d:	89 55 e0             	mov    %edx,-0x20(%ebp)
	uint32 end1 = RANDU(0, 5000);
  800060:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800063:	b9 88 13 00 00       	mov    $0x1388,%ecx
  800068:	ba 00 00 00 00       	mov    $0x0,%edx
  80006d:	f7 f1                	div    %ecx
  80006f:	89 55 f0             	mov    %edx,-0x10(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  800072:	0f 31                	rdtsc  
  800074:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800077:	89 55 d0             	mov    %edx,-0x30(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80007a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80007d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800083:	89 55 e8             	mov    %edx,-0x18(%ebp)
	uint32 end2 = RANDU(0, 5000);
  800086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800089:	b9 88 13 00 00       	mov    $0x1388,%ecx
  80008e:	ba 00 00 00 00       	mov    $0x0,%edx
  800093:	f7 f1                	div    %ecx
  800095:	89 55 ec             	mov    %edx,-0x14(%ebp)
	int x = 10;
  800098:	c7 45 fc 0a 00 00 00 	movl   $0xa,-0x4(%ebp)
	for(int i = 0; i <= end1; i++)
  80009f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8000a6:	eb 1a                	jmp    8000c2 <high_complexity_function+0x7c>
	{
		for(int i = 0; i <= end2; i++)
  8000a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000af:	eb 06                	jmp    8000b7 <high_complexity_function+0x71>
		{
			{
				 x++;
  8000b1:	ff 45 fc             	incl   -0x4(%ebp)
	uint32 end1 = RANDU(0, 5000);
	uint32 end2 = RANDU(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
	{
		for(int i = 0; i <= end2; i++)
  8000b4:	ff 45 f4             	incl   -0xc(%ebp)
  8000b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8000bd:	76 f2                	jbe    8000b1 <high_complexity_function+0x6b>
void high_complexity_function()
{
	uint32 end1 = RANDU(0, 5000);
	uint32 end2 = RANDU(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
  8000bf:	ff 45 f8             	incl   -0x8(%ebp)
  8000c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8000c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000c8:	76 de                	jbe    8000a8 <high_complexity_function+0x62>
			{
				 x++;
			}
		}
	}
}
  8000ca:	90                   	nop
  8000cb:	c9                   	leave  
  8000cc:	c3                   	ret    

008000cd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	57                   	push   %edi
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000d6:	e8 64 14 00 00       	call   80153f <sys_getenvindex>
  8000db:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000e1:	89 d0                	mov    %edx,%eax
  8000e3:	c1 e0 06             	shl    $0x6,%eax
  8000e6:	29 d0                	sub    %edx,%eax
  8000e8:	c1 e0 02             	shl    $0x2,%eax
  8000eb:	01 d0                	add    %edx,%eax
  8000ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000f4:	01 c8                	add    %ecx,%eax
  8000f6:	c1 e0 03             	shl    $0x3,%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800102:	29 c2                	sub    %eax,%edx
  800104:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800113:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800118:	a1 20 30 80 00       	mov    0x803020,%eax
  80011d:	8a 40 20             	mov    0x20(%eax),%al
  800120:	84 c0                	test   %al,%al
  800122:	74 0d                	je     800131 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800124:	a1 20 30 80 00       	mov    0x803020,%eax
  800129:	83 c0 20             	add    $0x20,%eax
  80012c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800135:	7e 0a                	jle    800141 <libmain+0x74>
		binaryname = argv[0];
  800137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013a:	8b 00                	mov    (%eax),%eax
  80013c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	ff 75 0c             	pushl  0xc(%ebp)
  800147:	ff 75 08             	pushl  0x8(%ebp)
  80014a:	e8 e9 fe ff ff       	call   800038 <_main>
  80014f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800152:	a1 00 30 80 00       	mov    0x803000,%eax
  800157:	85 c0                	test   %eax,%eax
  800159:	0f 84 01 01 00 00    	je     800260 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80015f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800165:	bb 58 1d 80 00       	mov    $0x801d58,%ebx
  80016a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80016f:	89 c7                	mov    %eax,%edi
  800171:	89 de                	mov    %ebx,%esi
  800173:	89 d1                	mov    %edx,%ecx
  800175:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800177:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80017a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80017f:	b0 00                	mov    $0x0,%al
  800181:	89 d7                	mov    %edx,%edi
  800183:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800185:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80018c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	50                   	push   %eax
  800193:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800199:	50                   	push   %eax
  80019a:	e8 d6 15 00 00       	call   801775 <sys_utilities>
  80019f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001a2:	e8 1f 11 00 00       	call   8012c6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 78 1c 80 00       	push   $0x801c78
  8001af:	e8 be 01 00 00       	call   800372 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	74 18                	je     8001d6 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001be:	e8 d0 15 00 00       	call   801793 <sys_get_optimal_num_faults>
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	50                   	push   %eax
  8001c7:	68 a0 1c 80 00       	push   $0x801ca0
  8001cc:	e8 a1 01 00 00       	call   800372 <cprintf>
  8001d1:	83 c4 10             	add    $0x10,%esp
  8001d4:	eb 59                	jmp    80022f <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001db:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e6:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	52                   	push   %edx
  8001f0:	50                   	push   %eax
  8001f1:	68 c4 1c 80 00       	push   $0x801cc4
  8001f6:	e8 77 01 00 00       	call   800372 <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800203:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800209:	a1 20 30 80 00       	mov    0x803020,%eax
  80020e:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800214:	a1 20 30 80 00       	mov    0x803020,%eax
  800219:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80021f:	51                   	push   %ecx
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 ec 1c 80 00       	push   $0x801cec
  800227:	e8 46 01 00 00       	call   800372 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022f:	a1 20 30 80 00       	mov    0x803020,%eax
  800234:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	50                   	push   %eax
  80023e:	68 44 1d 80 00       	push   $0x801d44
  800243:	e8 2a 01 00 00       	call   800372 <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 78 1c 80 00       	push   $0x801c78
  800253:	e8 1a 01 00 00       	call   800372 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80025b:	e8 80 10 00 00       	call   8012e0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800260:	e8 1f 00 00 00       	call   800284 <exit>
}
  800265:	90                   	nop
  800266:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800269:	5b                   	pop    %ebx
  80026a:	5e                   	pop    %esi
  80026b:	5f                   	pop    %edi
  80026c:	5d                   	pop    %ebp
  80026d:	c3                   	ret    

0080026e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	6a 00                	push   $0x0
  800279:	e8 8d 12 00 00       	call   80150b <sys_destroy_env>
  80027e:	83 c4 10             	add    $0x10,%esp
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <exit>:

void
exit(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80028a:	e8 e2 12 00 00       	call   801571 <sys_exit_env>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	53                   	push   %ebx
  800296:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029c:	8b 00                	mov    (%eax),%eax
  80029e:	8d 48 01             	lea    0x1(%eax),%ecx
  8002a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a4:	89 0a                	mov    %ecx,(%edx)
  8002a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a9:	88 d1                	mov    %dl,%cl
  8002ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002bc:	75 30                	jne    8002ee <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002be:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002c4:	a0 44 30 80 00       	mov    0x803044,%al
  8002c9:	0f b6 c0             	movzbl %al,%eax
  8002cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cf:	8b 09                	mov    (%ecx),%ecx
  8002d1:	89 cb                	mov    %ecx,%ebx
  8002d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d6:	83 c1 08             	add    $0x8,%ecx
  8002d9:	52                   	push   %edx
  8002da:	50                   	push   %eax
  8002db:	53                   	push   %ebx
  8002dc:	51                   	push   %ecx
  8002dd:	e8 a0 0f 00 00       	call   801282 <sys_cputs>
  8002e2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f1:	8b 40 04             	mov    0x4(%eax),%eax
  8002f4:	8d 50 01             	lea    0x1(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002fd:	90                   	nop
  8002fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80030c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800313:	00 00 00 
	b.cnt = 0;
  800316:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80031d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032c:	50                   	push   %eax
  80032d:	68 92 02 80 00       	push   $0x800292
  800332:	e8 5a 02 00 00       	call   800591 <vprintfmt>
  800337:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80033a:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800340:	a0 44 30 80 00       	mov    0x803044,%al
  800345:	0f b6 c0             	movzbl %al,%eax
  800348:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80034e:	52                   	push   %edx
  80034f:	50                   	push   %eax
  800350:	51                   	push   %ecx
  800351:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800357:	83 c0 08             	add    $0x8,%eax
  80035a:	50                   	push   %eax
  80035b:	e8 22 0f 00 00       	call   801282 <sys_cputs>
  800360:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800363:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80036a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800378:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80037f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800382:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800385:	8b 45 08             	mov    0x8(%ebp),%eax
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	ff 75 f4             	pushl  -0xc(%ebp)
  80038e:	50                   	push   %eax
  80038f:	e8 6f ff ff ff       	call   800303 <vcprintf>
  800394:	83 c4 10             	add    $0x10,%esp
  800397:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003a5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	c1 e0 08             	shl    $0x8,%eax
  8003b2:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003b7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003ba:	83 c0 04             	add    $0x4,%eax
  8003bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	e8 34 ff ff ff       	call   800303 <vcprintf>
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003d5:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003dc:	07 00 00 

	return cnt;
  8003df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003ea:	e8 d7 0e 00 00       	call   8012c6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003ef:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	83 ec 08             	sub    $0x8,%esp
  8003fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003fe:	50                   	push   %eax
  8003ff:	e8 ff fe ff ff       	call   800303 <vcprintf>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80040a:	e8 d1 0e 00 00       	call   8012e0 <sys_unlock_cons>
	return cnt;
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800412:	c9                   	leave  
  800413:	c3                   	ret    

00800414 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	53                   	push   %ebx
  800418:	83 ec 14             	sub    $0x14,%esp
  80041b:	8b 45 10             	mov    0x10(%ebp),%eax
  80041e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800427:	8b 45 18             	mov    0x18(%ebp),%eax
  80042a:	ba 00 00 00 00       	mov    $0x0,%edx
  80042f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800432:	77 55                	ja     800489 <printnum+0x75>
  800434:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800437:	72 05                	jb     80043e <printnum+0x2a>
  800439:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80043c:	77 4b                	ja     800489 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800441:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800444:	8b 45 18             	mov    0x18(%ebp),%eax
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	52                   	push   %edx
  80044d:	50                   	push   %eax
  80044e:	ff 75 f4             	pushl  -0xc(%ebp)
  800451:	ff 75 f0             	pushl  -0x10(%ebp)
  800454:	e8 97 15 00 00       	call   8019f0 <__udivdi3>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	ff 75 20             	pushl  0x20(%ebp)
  800462:	53                   	push   %ebx
  800463:	ff 75 18             	pushl  0x18(%ebp)
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	ff 75 0c             	pushl  0xc(%ebp)
  80046b:	ff 75 08             	pushl  0x8(%ebp)
  80046e:	e8 a1 ff ff ff       	call   800414 <printnum>
  800473:	83 c4 20             	add    $0x20,%esp
  800476:	eb 1a                	jmp    800492 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	ff 75 0c             	pushl  0xc(%ebp)
  80047e:	ff 75 20             	pushl  0x20(%ebp)
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800489:	ff 4d 1c             	decl   0x1c(%ebp)
  80048c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800490:	7f e6                	jg     800478 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800492:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800495:	bb 00 00 00 00       	mov    $0x0,%ebx
  80049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004a0:	53                   	push   %ebx
  8004a1:	51                   	push   %ecx
  8004a2:	52                   	push   %edx
  8004a3:	50                   	push   %eax
  8004a4:	e8 57 16 00 00       	call   801b00 <__umoddi3>
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	05 d4 1f 80 00       	add    $0x801fd4,%eax
  8004b1:	8a 00                	mov    (%eax),%al
  8004b3:	0f be c0             	movsbl %al,%eax
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	ff 75 0c             	pushl  0xc(%ebp)
  8004bc:	50                   	push   %eax
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	ff d0                	call   *%eax
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ce:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d2:	7e 1c                	jle    8004f0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	8d 50 08             	lea    0x8(%eax),%edx
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	89 10                	mov    %edx,(%eax)
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	83 e8 08             	sub    $0x8,%eax
  8004e9:	8b 50 04             	mov    0x4(%eax),%edx
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	eb 40                	jmp    800530 <getuint+0x65>
	else if (lflag)
  8004f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f4:	74 1e                	je     800514 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	8d 50 04             	lea    0x4(%eax),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	89 10                	mov    %edx,(%eax)
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 e8 04             	sub    $0x4,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	ba 00 00 00 00       	mov    $0x0,%edx
  800512:	eb 1c                	jmp    800530 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800514:	8b 45 08             	mov    0x8(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	8d 50 04             	lea    0x4(%eax),%edx
  80051c:	8b 45 08             	mov    0x8(%ebp),%eax
  80051f:	89 10                	mov    %edx,(%eax)
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	83 e8 04             	sub    $0x4,%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800530:	5d                   	pop    %ebp
  800531:	c3                   	ret    

00800532 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800535:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800539:	7e 1c                	jle    800557 <getint+0x25>
		return va_arg(*ap, long long);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 08             	lea    0x8(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 08             	sub    $0x8,%eax
  800550:	8b 50 04             	mov    0x4(%eax),%edx
  800553:	8b 00                	mov    (%eax),%eax
  800555:	eb 38                	jmp    80058f <getint+0x5d>
	else if (lflag)
  800557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80055b:	74 1a                	je     800577 <getint+0x45>
		return va_arg(*ap, long);
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	8d 50 04             	lea    0x4(%eax),%edx
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	89 10                	mov    %edx,(%eax)
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	83 e8 04             	sub    $0x4,%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	99                   	cltd   
  800575:	eb 18                	jmp    80058f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 04             	lea    0x4(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 04             	sub    $0x4,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	99                   	cltd   
}
  80058f:	5d                   	pop    %ebp
  800590:	c3                   	ret    

00800591 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800591:	55                   	push   %ebp
  800592:	89 e5                	mov    %esp,%ebp
  800594:	56                   	push   %esi
  800595:	53                   	push   %ebx
  800596:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800599:	eb 17                	jmp    8005b2 <vprintfmt+0x21>
			if (ch == '\0')
  80059b:	85 db                	test   %ebx,%ebx
  80059d:	0f 84 c1 03 00 00    	je     800964 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	ff 75 0c             	pushl  0xc(%ebp)
  8005a9:	53                   	push   %ebx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	ff d0                	call   *%eax
  8005af:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b5:	8d 50 01             	lea    0x1(%eax),%edx
  8005b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bb:	8a 00                	mov    (%eax),%al
  8005bd:	0f b6 d8             	movzbl %al,%ebx
  8005c0:	83 fb 25             	cmp    $0x25,%ebx
  8005c3:	75 d6                	jne    80059b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005c5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005c9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005de:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e8:	8d 50 01             	lea    0x1(%eax),%edx
  8005eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8005ee:	8a 00                	mov    (%eax),%al
  8005f0:	0f b6 d8             	movzbl %al,%ebx
  8005f3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005f6:	83 f8 5b             	cmp    $0x5b,%eax
  8005f9:	0f 87 3d 03 00 00    	ja     80093c <vprintfmt+0x3ab>
  8005ff:	8b 04 85 f8 1f 80 00 	mov    0x801ff8(,%eax,4),%eax
  800606:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800608:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80060c:	eb d7                	jmp    8005e5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80060e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800612:	eb d1                	jmp    8005e5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800614:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80061b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061e:	89 d0                	mov    %edx,%eax
  800620:	c1 e0 02             	shl    $0x2,%eax
  800623:	01 d0                	add    %edx,%eax
  800625:	01 c0                	add    %eax,%eax
  800627:	01 d8                	add    %ebx,%eax
  800629:	83 e8 30             	sub    $0x30,%eax
  80062c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80062f:	8b 45 10             	mov    0x10(%ebp),%eax
  800632:	8a 00                	mov    (%eax),%al
  800634:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800637:	83 fb 2f             	cmp    $0x2f,%ebx
  80063a:	7e 3e                	jle    80067a <vprintfmt+0xe9>
  80063c:	83 fb 39             	cmp    $0x39,%ebx
  80063f:	7f 39                	jg     80067a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800641:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800644:	eb d5                	jmp    80061b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	83 c0 04             	add    $0x4,%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	83 e8 04             	sub    $0x4,%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80065a:	eb 1f                	jmp    80067b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80065c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800660:	79 83                	jns    8005e5 <vprintfmt+0x54>
				width = 0;
  800662:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800669:	e9 77 ff ff ff       	jmp    8005e5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80066e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800675:	e9 6b ff ff ff       	jmp    8005e5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80067a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80067b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067f:	0f 89 60 ff ff ff    	jns    8005e5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800692:	e9 4e ff ff ff       	jmp    8005e5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800697:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80069a:	e9 46 ff ff ff       	jmp    8005e5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	83 c0 04             	add    $0x4,%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	83 e8 04             	sub    $0x4,%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	50                   	push   %eax
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	ff d0                	call   *%eax
  8006bc:	83 c4 10             	add    $0x10,%esp
			break;
  8006bf:	e9 9b 02 00 00       	jmp    80095f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	83 c0 04             	add    $0x4,%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	83 e8 04             	sub    $0x4,%eax
  8006d3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006d5:	85 db                	test   %ebx,%ebx
  8006d7:	79 02                	jns    8006db <vprintfmt+0x14a>
				err = -err;
  8006d9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006db:	83 fb 64             	cmp    $0x64,%ebx
  8006de:	7f 0b                	jg     8006eb <vprintfmt+0x15a>
  8006e0:	8b 34 9d 40 1e 80 00 	mov    0x801e40(,%ebx,4),%esi
  8006e7:	85 f6                	test   %esi,%esi
  8006e9:	75 19                	jne    800704 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006eb:	53                   	push   %ebx
  8006ec:	68 e5 1f 80 00       	push   $0x801fe5
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	ff 75 08             	pushl  0x8(%ebp)
  8006f7:	e8 70 02 00 00       	call   80096c <printfmt>
  8006fc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006ff:	e9 5b 02 00 00       	jmp    80095f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800704:	56                   	push   %esi
  800705:	68 ee 1f 80 00       	push   $0x801fee
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	ff 75 08             	pushl  0x8(%ebp)
  800710:	e8 57 02 00 00       	call   80096c <printfmt>
  800715:	83 c4 10             	add    $0x10,%esp
			break;
  800718:	e9 42 02 00 00       	jmp    80095f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	83 c0 04             	add    $0x4,%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 30                	mov    (%eax),%esi
  80072e:	85 f6                	test   %esi,%esi
  800730:	75 05                	jne    800737 <vprintfmt+0x1a6>
				p = "(null)";
  800732:	be f1 1f 80 00       	mov    $0x801ff1,%esi
			if (width > 0 && padc != '-')
  800737:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073b:	7e 6d                	jle    8007aa <vprintfmt+0x219>
  80073d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800741:	74 67                	je     8007aa <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800743:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	50                   	push   %eax
  80074a:	56                   	push   %esi
  80074b:	e8 1e 03 00 00       	call   800a6e <strnlen>
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800756:	eb 16                	jmp    80076e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800758:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	50                   	push   %eax
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800772:	7f e4                	jg     800758 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800774:	eb 34                	jmp    8007aa <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800776:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80077a:	74 1c                	je     800798 <vprintfmt+0x207>
  80077c:	83 fb 1f             	cmp    $0x1f,%ebx
  80077f:	7e 05                	jle    800786 <vprintfmt+0x1f5>
  800781:	83 fb 7e             	cmp    $0x7e,%ebx
  800784:	7e 12                	jle    800798 <vprintfmt+0x207>
					putch('?', putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	ff 75 0c             	pushl  0xc(%ebp)
  80078c:	6a 3f                	push   $0x3f
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	ff d0                	call   *%eax
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	eb 0f                	jmp    8007a7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	53                   	push   %ebx
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8007aa:	89 f0                	mov    %esi,%eax
  8007ac:	8d 70 01             	lea    0x1(%eax),%esi
  8007af:	8a 00                	mov    (%eax),%al
  8007b1:	0f be d8             	movsbl %al,%ebx
  8007b4:	85 db                	test   %ebx,%ebx
  8007b6:	74 24                	je     8007dc <vprintfmt+0x24b>
  8007b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007bc:	78 b8                	js     800776 <vprintfmt+0x1e5>
  8007be:	ff 4d e0             	decl   -0x20(%ebp)
  8007c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c5:	79 af                	jns    800776 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c7:	eb 13                	jmp    8007dc <vprintfmt+0x24b>
				putch(' ', putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	6a 20                	push   $0x20
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	ff d0                	call   *%eax
  8007d6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8007dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e0:	7f e7                	jg     8007c9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007e2:	e9 78 01 00 00       	jmp    80095f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f0:	50                   	push   %eax
  8007f1:	e8 3c fd ff ff       	call   800532 <getint>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800805:	85 d2                	test   %edx,%edx
  800807:	79 23                	jns    80082c <vprintfmt+0x29b>
				putch('-', putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	6a 2d                	push   $0x2d
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80081f:	f7 d8                	neg    %eax
  800821:	83 d2 00             	adc    $0x0,%edx
  800824:	f7 da                	neg    %edx
  800826:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800829:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80082c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800833:	e9 bc 00 00 00       	jmp    8008f4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 e8             	pushl  -0x18(%ebp)
  80083e:	8d 45 14             	lea    0x14(%ebp),%eax
  800841:	50                   	push   %eax
  800842:	e8 84 fc ff ff       	call   8004cb <getuint>
  800847:	83 c4 10             	add    $0x10,%esp
  80084a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800850:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800857:	e9 98 00 00 00       	jmp    8008f4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	6a 58                	push   $0x58
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	ff d0                	call   *%eax
  800869:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 58                	push   $0x58
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	6a 58                	push   $0x58
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	ff d0                	call   *%eax
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 ce 00 00 00       	jmp    80095f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	6a 30                	push   $0x30
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	ff d0                	call   *%eax
  80089e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	6a 78                	push   $0x78
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	ff d0                	call   *%eax
  8008ae:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008cc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008d3:	eb 1f                	jmp    8008f4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8008db:	8d 45 14             	lea    0x14(%ebp),%eax
  8008de:	50                   	push   %eax
  8008df:	e8 e7 fb ff ff       	call   8004cb <getuint>
  8008e4:	83 c4 10             	add    $0x10,%esp
  8008e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ed:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008f4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fb:	83 ec 04             	sub    $0x4,%esp
  8008fe:	52                   	push   %edx
  8008ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800902:	50                   	push   %eax
  800903:	ff 75 f4             	pushl  -0xc(%ebp)
  800906:	ff 75 f0             	pushl  -0x10(%ebp)
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	ff 75 08             	pushl  0x8(%ebp)
  80090f:	e8 00 fb ff ff       	call   800414 <printnum>
  800914:	83 c4 20             	add    $0x20,%esp
			break;
  800917:	eb 46                	jmp    80095f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	53                   	push   %ebx
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
			break;
  800928:	eb 35                	jmp    80095f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80092a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800931:	eb 2c                	jmp    80095f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800933:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  80093a:	eb 23                	jmp    80095f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	6a 25                	push   $0x25
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80094c:	ff 4d 10             	decl   0x10(%ebp)
  80094f:	eb 03                	jmp    800954 <vprintfmt+0x3c3>
  800951:	ff 4d 10             	decl   0x10(%ebp)
  800954:	8b 45 10             	mov    0x10(%ebp),%eax
  800957:	48                   	dec    %eax
  800958:	8a 00                	mov    (%eax),%al
  80095a:	3c 25                	cmp    $0x25,%al
  80095c:	75 f3                	jne    800951 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80095e:	90                   	nop
		}
	}
  80095f:	e9 35 fc ff ff       	jmp    800599 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800964:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800965:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800968:	5b                   	pop    %ebx
  800969:	5e                   	pop    %esi
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800972:	8d 45 10             	lea    0x10(%ebp),%eax
  800975:	83 c0 04             	add    $0x4,%eax
  800978:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80097b:	8b 45 10             	mov    0x10(%ebp),%eax
  80097e:	ff 75 f4             	pushl  -0xc(%ebp)
  800981:	50                   	push   %eax
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	ff 75 08             	pushl  0x8(%ebp)
  800988:	e8 04 fc ff ff       	call   800591 <vprintfmt>
  80098d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800990:	90                   	nop
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	8b 40 08             	mov    0x8(%eax),%eax
  80099c:	8d 50 01             	lea    0x1(%eax),%edx
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	8b 10                	mov    (%eax),%edx
  8009aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ad:	8b 40 04             	mov    0x4(%eax),%eax
  8009b0:	39 c2                	cmp    %eax,%edx
  8009b2:	73 12                	jae    8009c6 <sprintputch+0x33>
		*b->buf++ = ch;
  8009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8009bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bf:	89 0a                	mov    %ecx,(%edx)
  8009c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c4:	88 10                	mov    %dl,(%eax)
}
  8009c6:	90                   	nop
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	01 d0                	add    %edx,%eax
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009ee:	74 06                	je     8009f6 <vsnprintf+0x2d>
  8009f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f4:	7f 07                	jg     8009fd <vsnprintf+0x34>
		return -E_INVAL;
  8009f6:	b8 03 00 00 00       	mov    $0x3,%eax
  8009fb:	eb 20                	jmp    800a1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009fd:	ff 75 14             	pushl  0x14(%ebp)
  800a00:	ff 75 10             	pushl  0x10(%ebp)
  800a03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a06:	50                   	push   %eax
  800a07:	68 93 09 80 00       	push   $0x800993
  800a0c:	e8 80 fb ff ff       	call   800591 <vprintfmt>
  800a11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a25:	8d 45 10             	lea    0x10(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a31:	ff 75 f4             	pushl  -0xc(%ebp)
  800a34:	50                   	push   %eax
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	ff 75 08             	pushl  0x8(%ebp)
  800a3b:	e8 89 ff ff ff       	call   8009c9 <vsnprintf>
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a49:	c9                   	leave  
  800a4a:	c3                   	ret    

00800a4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a58:	eb 06                	jmp    800a60 <strlen+0x15>
		n++;
  800a5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5d:	ff 45 08             	incl   0x8(%ebp)
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	8a 00                	mov    (%eax),%al
  800a65:	84 c0                	test   %al,%al
  800a67:	75 f1                	jne    800a5a <strlen+0xf>
		n++;
	return n;
  800a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a7b:	eb 09                	jmp    800a86 <strnlen+0x18>
		n++;
  800a7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a80:	ff 45 08             	incl   0x8(%ebp)
  800a83:	ff 4d 0c             	decl   0xc(%ebp)
  800a86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8a:	74 09                	je     800a95 <strnlen+0x27>
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	84 c0                	test   %al,%al
  800a93:	75 e8                	jne    800a7d <strnlen+0xf>
		n++;
	return n;
  800a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800aa6:	90                   	nop
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	8d 50 01             	lea    0x1(%eax),%edx
  800aad:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ab9:	8a 12                	mov    (%edx),%dl
  800abb:	88 10                	mov    %dl,(%eax)
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	84 c0                	test   %al,%al
  800ac1:	75 e4                	jne    800aa7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ad4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800adb:	eb 1f                	jmp    800afc <strncpy+0x34>
		*dst++ = *src;
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	8d 50 01             	lea    0x1(%eax),%edx
  800ae3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae9:	8a 12                	mov    (%edx),%dl
  800aeb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	8a 00                	mov    (%eax),%al
  800af2:	84 c0                	test   %al,%al
  800af4:	74 03                	je     800af9 <strncpy+0x31>
			src++;
  800af6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af9:	ff 45 fc             	incl   -0x4(%ebp)
  800afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b02:	72 d9                	jb     800add <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b19:	74 30                	je     800b4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b1b:	eb 16                	jmp    800b33 <strlcpy+0x2a>
			*dst++ = *src++;
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8d 50 01             	lea    0x1(%eax),%edx
  800b23:	89 55 08             	mov    %edx,0x8(%ebp)
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b2f:	8a 12                	mov    (%edx),%dl
  800b31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b33:	ff 4d 10             	decl   0x10(%ebp)
  800b36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3a:	74 09                	je     800b45 <strlcpy+0x3c>
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	84 c0                	test   %al,%al
  800b43:	75 d8                	jne    800b1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b51:	29 c2                	sub    %eax,%edx
  800b53:	89 d0                	mov    %edx,%eax
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b5a:	eb 06                	jmp    800b62 <strcmp+0xb>
		p++, q++;
  800b5c:	ff 45 08             	incl   0x8(%ebp)
  800b5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8a 00                	mov    (%eax),%al
  800b67:	84 c0                	test   %al,%al
  800b69:	74 0e                	je     800b79 <strcmp+0x22>
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8a 10                	mov    (%eax),%dl
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8a 00                	mov    (%eax),%al
  800b75:	38 c2                	cmp    %al,%dl
  800b77:	74 e3                	je     800b5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b92:	eb 09                	jmp    800b9d <strncmp+0xe>
		n--, p++, q++;
  800b94:	ff 4d 10             	decl   0x10(%ebp)
  800b97:	ff 45 08             	incl   0x8(%ebp)
  800b9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba1:	74 17                	je     800bba <strncmp+0x2b>
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8a 00                	mov    (%eax),%al
  800ba8:	84 c0                	test   %al,%al
  800baa:	74 0e                	je     800bba <strncmp+0x2b>
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8a 10                	mov    (%eax),%dl
  800bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb4:	8a 00                	mov    (%eax),%al
  800bb6:	38 c2                	cmp    %al,%dl
  800bb8:	74 da                	je     800b94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800bba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbe:	75 07                	jne    800bc7 <strncmp+0x38>
		return 0;
  800bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc5:	eb 14                	jmp    800bdb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8a 00                	mov    (%eax),%al
  800bcc:	0f b6 d0             	movzbl %al,%edx
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	0f b6 c0             	movzbl %al,%eax
  800bd7:	29 c2                	sub    %eax,%edx
  800bd9:	89 d0                	mov    %edx,%eax
}
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 04             	sub    $0x4,%esp
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800be9:	eb 12                	jmp    800bfd <strchr+0x20>
		if (*s == c)
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8a 00                	mov    (%eax),%al
  800bf0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bf3:	75 05                	jne    800bfa <strchr+0x1d>
			return (char *) s;
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	eb 11                	jmp    800c0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 e5                	jne    800beb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 04             	sub    $0x4,%esp
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c19:	eb 0d                	jmp    800c28 <strfind+0x1b>
		if (*s == c)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c23:	74 0e                	je     800c33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c25:	ff 45 08             	incl   0x8(%ebp)
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8a 00                	mov    (%eax),%al
  800c2d:	84 c0                	test   %al,%al
  800c2f:	75 ea                	jne    800c1b <strfind+0xe>
  800c31:	eb 01                	jmp    800c34 <strfind+0x27>
		if (*s == c)
			break;
  800c33:	90                   	nop
	return (char *) s;
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c45:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c49:	76 63                	jbe    800cae <memset+0x75>
		uint64 data_block = c;
  800c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4e:	99                   	cltd   
  800c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c52:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c5f:	c1 e0 08             	shl    $0x8,%eax
  800c62:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c65:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c72:	c1 e0 10             	shl    $0x10,%eax
  800c75:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c78:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c81:	89 c2                	mov    %eax,%edx
  800c83:	b8 00 00 00 00       	mov    $0x0,%eax
  800c88:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c8b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c8e:	eb 18                	jmp    800ca8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c90:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c93:	8d 41 08             	lea    0x8(%ecx),%eax
  800c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9f:	89 01                	mov    %eax,(%ecx)
  800ca1:	89 51 04             	mov    %edx,0x4(%ecx)
  800ca4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ca8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cac:	77 e2                	ja     800c90 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800cae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb2:	74 23                	je     800cd7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cba:	eb 0e                	jmp    800cca <memset+0x91>
			*p8++ = (uint8)c;
  800cbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbf:	8d 50 01             	lea    0x1(%eax),%edx
  800cc2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	75 e5                	jne    800cbc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800cee:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cf2:	76 24                	jbe    800d18 <memcpy+0x3c>
		while(n >= 8){
  800cf4:	eb 1c                	jmp    800d12 <memcpy+0x36>
			*d64 = *s64;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8b 50 04             	mov    0x4(%eax),%edx
  800cfc:	8b 00                	mov    (%eax),%eax
  800cfe:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d01:	89 01                	mov    %eax,(%ecx)
  800d03:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d06:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d0a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d0e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d12:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d16:	77 de                	ja     800cf6 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 31                	je     800d4f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d27:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d2a:	eb 16                	jmp    800d42 <memcpy+0x66>
			*d8++ = *s8++;
  800d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d2f:	8d 50 01             	lea    0x1(%eax),%edx
  800d32:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d38:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d42:	8b 45 10             	mov    0x10(%ebp),%eax
  800d45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d48:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	75 dd                	jne    800d2c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d69:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d6c:	73 50                	jae    800dbe <memmove+0x6a>
  800d6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d79:	76 43                	jbe    800dbe <memmove+0x6a>
		s += n;
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d81:	8b 45 10             	mov    0x10(%ebp),%eax
  800d84:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d87:	eb 10                	jmp    800d99 <memmove+0x45>
			*--d = *--s;
  800d89:	ff 4d f8             	decl   -0x8(%ebp)
  800d8c:	ff 4d fc             	decl   -0x4(%ebp)
  800d8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d92:	8a 10                	mov    (%eax),%dl
  800d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d97:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d99:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9f:	89 55 10             	mov    %edx,0x10(%ebp)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	75 e3                	jne    800d89 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da6:	eb 23                	jmp    800dcb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800da8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dab:	8d 50 01             	lea    0x1(%eax),%edx
  800dae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dba:	8a 12                	mov    (%edx),%dl
  800dbc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc4:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	75 dd                	jne    800da8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de2:	eb 2a                	jmp    800e0e <memcmp+0x3e>
		if (*s1 != *s2)
  800de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de7:	8a 10                	mov    (%eax),%dl
  800de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	38 c2                	cmp    %al,%dl
  800df0:	74 16                	je     800e08 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	0f b6 d0             	movzbl %al,%edx
  800dfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	0f b6 c0             	movzbl %al,%eax
  800e02:	29 c2                	sub    %eax,%edx
  800e04:	89 d0                	mov    %edx,%eax
  800e06:	eb 18                	jmp    800e20 <memcmp+0x50>
		s1++, s2++;
  800e08:	ff 45 fc             	incl   -0x4(%ebp)
  800e0b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 c9                	jne    800de4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	01 d0                	add    %edx,%eax
  800e30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e33:	eb 15                	jmp    800e4a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	0f b6 d0             	movzbl %al,%edx
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	39 c2                	cmp    %eax,%edx
  800e45:	74 0d                	je     800e54 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e47:	ff 45 08             	incl   0x8(%ebp)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e50:	72 e3                	jb     800e35 <memfind+0x13>
  800e52:	eb 01                	jmp    800e55 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e54:	90                   	nop
	return (void *) s;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6e:	eb 03                	jmp    800e73 <strtol+0x19>
		s++;
  800e70:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3c 20                	cmp    $0x20,%al
  800e7a:	74 f4                	je     800e70 <strtol+0x16>
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	3c 09                	cmp    $0x9,%al
  800e83:	74 eb                	je     800e70 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	3c 2b                	cmp    $0x2b,%al
  800e8c:	75 05                	jne    800e93 <strtol+0x39>
		s++;
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	eb 13                	jmp    800ea6 <strtol+0x4c>
	else if (*s == '-')
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	3c 2d                	cmp    $0x2d,%al
  800e9a:	75 0a                	jne    800ea6 <strtol+0x4c>
		s++, neg = 1;
  800e9c:	ff 45 08             	incl   0x8(%ebp)
  800e9f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eaa:	74 06                	je     800eb2 <strtol+0x58>
  800eac:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb0:	75 20                	jne    800ed2 <strtol+0x78>
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	3c 30                	cmp    $0x30,%al
  800eb9:	75 17                	jne    800ed2 <strtol+0x78>
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	40                   	inc    %eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	3c 78                	cmp    $0x78,%al
  800ec3:	75 0d                	jne    800ed2 <strtol+0x78>
		s += 2, base = 16;
  800ec5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ec9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed0:	eb 28                	jmp    800efa <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed6:	75 15                	jne    800eed <strtol+0x93>
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	3c 30                	cmp    $0x30,%al
  800edf:	75 0c                	jne    800eed <strtol+0x93>
		s++, base = 8;
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eeb:	eb 0d                	jmp    800efa <strtol+0xa0>
	else if (base == 0)
  800eed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef1:	75 07                	jne    800efa <strtol+0xa0>
		base = 10;
  800ef3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3c 2f                	cmp    $0x2f,%al
  800f01:	7e 19                	jle    800f1c <strtol+0xc2>
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	3c 39                	cmp    $0x39,%al
  800f0a:	7f 10                	jg     800f1c <strtol+0xc2>
			dig = *s - '0';
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	0f be c0             	movsbl %al,%eax
  800f14:	83 e8 30             	sub    $0x30,%eax
  800f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1a:	eb 42                	jmp    800f5e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 60                	cmp    $0x60,%al
  800f23:	7e 19                	jle    800f3e <strtol+0xe4>
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	3c 7a                	cmp    $0x7a,%al
  800f2c:	7f 10                	jg     800f3e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f be c0             	movsbl %al,%eax
  800f36:	83 e8 57             	sub    $0x57,%eax
  800f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f3c:	eb 20                	jmp    800f5e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 40                	cmp    $0x40,%al
  800f45:	7e 39                	jle    800f80 <strtol+0x126>
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	3c 5a                	cmp    $0x5a,%al
  800f4e:	7f 30                	jg     800f80 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	0f be c0             	movsbl %al,%eax
  800f58:	83 e8 37             	sub    $0x37,%eax
  800f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f64:	7d 19                	jge    800f7f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f66:	ff 45 08             	incl   0x8(%ebp)
  800f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f70:	89 c2                	mov    %eax,%edx
  800f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f75:	01 d0                	add    %edx,%eax
  800f77:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f7a:	e9 7b ff ff ff       	jmp    800efa <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f7f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f84:	74 08                	je     800f8e <strtol+0x134>
		*endptr = (char *) s;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f92:	74 07                	je     800f9b <strtol+0x141>
  800f94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f97:	f7 d8                	neg    %eax
  800f99:	eb 03                	jmp    800f9e <strtol+0x144>
  800f9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

00800fa0 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fb8:	79 13                	jns    800fcd <ltostr+0x2d>
	{
		neg = 1;
  800fba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fc7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fca:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fd5:	99                   	cltd   
  800fd6:	f7 f9                	idiv   %ecx
  800fd8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fde:	8d 50 01             	lea    0x1(%eax),%edx
  800fe1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe4:	89 c2                	mov    %eax,%edx
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	01 d0                	add    %edx,%eax
  800feb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fee:	83 c2 30             	add    $0x30,%edx
  800ff1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ffb:	f7 e9                	imul   %ecx
  800ffd:	c1 fa 02             	sar    $0x2,%edx
  801000:	89 c8                	mov    %ecx,%eax
  801002:	c1 f8 1f             	sar    $0x1f,%eax
  801005:	29 c2                	sub    %eax,%edx
  801007:	89 d0                	mov    %edx,%eax
  801009:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80100c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801010:	75 bb                	jne    800fcd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	48                   	dec    %eax
  80101d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801020:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801024:	74 3d                	je     801063 <ltostr+0xc3>
		start = 1 ;
  801026:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102d:	eb 34                	jmp    801063 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80102f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	01 d0                	add    %edx,%eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	01 c8                	add    %ecx,%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801050:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	01 c2                	add    %eax,%edx
  801058:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105b:	88 02                	mov    %al,(%edx)
		start++ ;
  80105d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801060:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801066:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801069:	7c c4                	jl     80102f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	01 d0                	add    %edx,%eax
  801073:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801076:	90                   	nop
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80107f:	ff 75 08             	pushl  0x8(%ebp)
  801082:	e8 c4 f9 ff ff       	call   800a4b <strlen>
  801087:	83 c4 04             	add    $0x4,%esp
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	e8 b6 f9 ff ff       	call   800a4b <strlen>
  801095:	83 c4 04             	add    $0x4,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a9:	eb 17                	jmp    8010c2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	01 c2                	add    %eax,%edx
  8010b3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	01 c8                	add    %ecx,%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010bf:	ff 45 fc             	incl   -0x4(%ebp)
  8010c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c8:	7c e1                	jl     8010ab <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d8:	eb 1f                	jmp    8010f9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dd:	8d 50 01             	lea    0x1(%eax),%edx
  8010e0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e8:	01 c2                	add    %eax,%edx
  8010ea:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	01 c8                	add    %ecx,%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f6:	ff 45 f8             	incl   -0x8(%ebp)
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010ff:	7c d9                	jl     8010da <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801101:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	c6 00 00             	movb   $0x0,(%eax)
}
  80110c:	90                   	nop
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    

0080110f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801112:	8b 45 14             	mov    0x14(%ebp),%eax
  801115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111b:	8b 45 14             	mov    0x14(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801127:	8b 45 10             	mov    0x10(%ebp),%eax
  80112a:	01 d0                	add    %edx,%eax
  80112c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801132:	eb 0c                	jmp    801140 <strsplit+0x31>
			*string++ = 0;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8d 50 01             	lea    0x1(%eax),%edx
  80113a:	89 55 08             	mov    %edx,0x8(%ebp)
  80113d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	74 18                	je     801161 <strsplit+0x52>
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	0f be c0             	movsbl %al,%eax
  801151:	50                   	push   %eax
  801152:	ff 75 0c             	pushl  0xc(%ebp)
  801155:	e8 83 fa ff ff       	call   800bdd <strchr>
  80115a:	83 c4 08             	add    $0x8,%esp
  80115d:	85 c0                	test   %eax,%eax
  80115f:	75 d3                	jne    801134 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	84 c0                	test   %al,%al
  801168:	74 5a                	je     8011c4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116a:	8b 45 14             	mov    0x14(%ebp),%eax
  80116d:	8b 00                	mov    (%eax),%eax
  80116f:	83 f8 0f             	cmp    $0xf,%eax
  801172:	75 07                	jne    80117b <strsplit+0x6c>
		{
			return 0;
  801174:	b8 00 00 00 00       	mov    $0x0,%eax
  801179:	eb 66                	jmp    8011e1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117b:	8b 45 14             	mov    0x14(%ebp),%eax
  80117e:	8b 00                	mov    (%eax),%eax
  801180:	8d 48 01             	lea    0x1(%eax),%ecx
  801183:	8b 55 14             	mov    0x14(%ebp),%edx
  801186:	89 0a                	mov    %ecx,(%edx)
  801188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80118f:	8b 45 10             	mov    0x10(%ebp),%eax
  801192:	01 c2                	add    %eax,%edx
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801199:	eb 03                	jmp    80119e <strsplit+0x8f>
			string++;
  80119b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	84 c0                	test   %al,%al
  8011a5:	74 8b                	je     801132 <strsplit+0x23>
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	0f be c0             	movsbl %al,%eax
  8011af:	50                   	push   %eax
  8011b0:	ff 75 0c             	pushl  0xc(%ebp)
  8011b3:	e8 25 fa ff ff       	call   800bdd <strchr>
  8011b8:	83 c4 08             	add    $0x8,%esp
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	74 dc                	je     80119b <strsplit+0x8c>
			string++;
	}
  8011bf:	e9 6e ff ff ff       	jmp    801132 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c8:	8b 00                	mov    (%eax),%eax
  8011ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d4:	01 d0                	add    %edx,%eax
  8011d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8011ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f6:	eb 4a                	jmp    801242 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8011f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	01 c2                	add    %eax,%edx
  801200:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801203:	8b 45 0c             	mov    0xc(%ebp),%eax
  801206:	01 c8                	add    %ecx,%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80120c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	3c 40                	cmp    $0x40,%al
  801218:	7e 25                	jle    80123f <str2lower+0x5c>
  80121a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 5a                	cmp    $0x5a,%al
  801226:	7f 17                	jg     80123f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801228:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	01 d0                	add    %edx,%eax
  801230:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
  801236:	01 ca                	add    %ecx,%edx
  801238:	8a 12                	mov    (%edx),%dl
  80123a:	83 c2 20             	add    $0x20,%edx
  80123d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80123f:	ff 45 fc             	incl   -0x4(%ebp)
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	e8 01 f8 ff ff       	call   800a4b <strlen>
  80124a:	83 c4 04             	add    $0x4,%esp
  80124d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801250:	7f a6                	jg     8011f8 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801252:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	57                   	push   %edi
  80125b:	56                   	push   %esi
  80125c:	53                   	push   %ebx
  80125d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8b 55 0c             	mov    0xc(%ebp),%edx
  801266:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801269:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80126c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80126f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801272:	cd 30                	int    $0x30
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801277:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    

00801282 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80128e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801291:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	6a 00                	push   $0x0
  80129a:	51                   	push   %ecx
  80129b:	52                   	push   %edx
  80129c:	ff 75 0c             	pushl  0xc(%ebp)
  80129f:	50                   	push   %eax
  8012a0:	6a 00                	push   $0x0
  8012a2:	e8 b0 ff ff ff       	call   801257 <syscall>
  8012a7:	83 c4 18             	add    $0x18,%esp
}
  8012aa:	90                   	nop
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <sys_cgetc>:

int
sys_cgetc(void)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 00                	push   $0x0
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 02                	push   $0x2
  8012bc:	e8 96 ff ff ff       	call   801257 <syscall>
  8012c1:	83 c4 18             	add    $0x18,%esp
}
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 03                	push   $0x3
  8012d5:	e8 7d ff ff ff       	call   801257 <syscall>
  8012da:	83 c4 18             	add    $0x18,%esp
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 04                	push   $0x4
  8012ef:	e8 63 ff ff ff       	call   801257 <syscall>
  8012f4:	83 c4 18             	add    $0x18,%esp
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	52                   	push   %edx
  80130a:	50                   	push   %eax
  80130b:	6a 08                	push   $0x8
  80130d:	e8 45 ff ff ff       	call   801257 <syscall>
  801312:	83 c4 18             	add    $0x18,%esp
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80131c:	8b 75 18             	mov    0x18(%ebp),%esi
  80131f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801322:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801325:	8b 55 0c             	mov    0xc(%ebp),%edx
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	56                   	push   %esi
  80132c:	53                   	push   %ebx
  80132d:	51                   	push   %ecx
  80132e:	52                   	push   %edx
  80132f:	50                   	push   %eax
  801330:	6a 09                	push   $0x9
  801332:	e8 20 ff ff ff       	call   801257 <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80133d:	5b                   	pop    %ebx
  80133e:	5e                   	pop    %esi
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    

00801341 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	ff 75 08             	pushl  0x8(%ebp)
  80134f:	6a 0a                	push   $0xa
  801351:	e8 01 ff ff ff       	call   801257 <syscall>
  801356:	83 c4 18             	add    $0x18,%esp
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	ff 75 0c             	pushl  0xc(%ebp)
  801367:	ff 75 08             	pushl  0x8(%ebp)
  80136a:	6a 0b                	push   $0xb
  80136c:	e8 e6 fe ff ff       	call   801257 <syscall>
  801371:	83 c4 18             	add    $0x18,%esp
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 0c                	push   $0xc
  801385:	e8 cd fe ff ff       	call   801257 <syscall>
  80138a:	83 c4 18             	add    $0x18,%esp
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 0d                	push   $0xd
  80139e:	e8 b4 fe ff ff       	call   801257 <syscall>
  8013a3:	83 c4 18             	add    $0x18,%esp
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 0e                	push   $0xe
  8013b7:	e8 9b fe ff ff       	call   801257 <syscall>
  8013bc:	83 c4 18             	add    $0x18,%esp
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 0f                	push   $0xf
  8013d0:	e8 82 fe ff ff       	call   801257 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	ff 75 08             	pushl  0x8(%ebp)
  8013e8:	6a 10                	push   $0x10
  8013ea:	e8 68 fe ff ff       	call   801257 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 11                	push   $0x11
  801403:	e8 4f fe ff ff       	call   801257 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	90                   	nop
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <sys_cputc>:

void
sys_cputc(const char c)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80141a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	50                   	push   %eax
  801427:	6a 01                	push   $0x1
  801429:	e8 29 fe ff ff       	call   801257 <syscall>
  80142e:	83 c4 18             	add    $0x18,%esp
}
  801431:	90                   	nop
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 14                	push   $0x14
  801443:	e8 0f fe ff ff       	call   801257 <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	90                   	nop
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 10             	mov    0x10(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80145a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80145d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	6a 00                	push   $0x0
  801466:	51                   	push   %ecx
  801467:	52                   	push   %edx
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	50                   	push   %eax
  80146c:	6a 15                	push   $0x15
  80146e:	e8 e4 fd ff ff       	call   801257 <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
}
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80147b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	52                   	push   %edx
  801488:	50                   	push   %eax
  801489:	6a 16                	push   $0x16
  80148b:	e8 c7 fd ff ff       	call   801257 <syscall>
  801490:	83 c4 18             	add    $0x18,%esp
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801498:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	51                   	push   %ecx
  8014a6:	52                   	push   %edx
  8014a7:	50                   	push   %eax
  8014a8:	6a 17                	push   $0x17
  8014aa:	e8 a8 fd ff ff       	call   801257 <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	52                   	push   %edx
  8014c4:	50                   	push   %eax
  8014c5:	6a 18                	push   $0x18
  8014c7:	e8 8b fd ff ff       	call   801257 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	6a 00                	push   $0x0
  8014d9:	ff 75 14             	pushl  0x14(%ebp)
  8014dc:	ff 75 10             	pushl  0x10(%ebp)
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	50                   	push   %eax
  8014e3:	6a 19                	push   $0x19
  8014e5:	e8 6d fd ff ff       	call   801257 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	50                   	push   %eax
  8014fe:	6a 1a                	push   $0x1a
  801500:	e8 52 fd ff ff       	call   801257 <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
}
  801508:	90                   	nop
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	50                   	push   %eax
  80151a:	6a 1b                	push   $0x1b
  80151c:	e8 36 fd ff ff       	call   801257 <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 05                	push   $0x5
  801535:	e8 1d fd ff ff       	call   801257 <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 06                	push   $0x6
  80154e:	e8 04 fd ff ff       	call   801257 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 07                	push   $0x7
  801567:	e8 eb fc ff ff       	call   801257 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_exit_env>:


void sys_exit_env(void)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 1c                	push   $0x1c
  801580:	e8 d2 fc ff ff       	call   801257 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	90                   	nop
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801591:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801594:	8d 50 04             	lea    0x4(%eax),%edx
  801597:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	52                   	push   %edx
  8015a1:	50                   	push   %eax
  8015a2:	6a 1d                	push   $0x1d
  8015a4:	e8 ae fc ff ff       	call   801257 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
	return result;
  8015ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b5:	89 01                	mov    %eax,(%ecx)
  8015b7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	c9                   	leave  
  8015be:	c2 04 00             	ret    $0x4

008015c1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	ff 75 10             	pushl  0x10(%ebp)
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	ff 75 08             	pushl  0x8(%ebp)
  8015d1:	6a 13                	push   $0x13
  8015d3:	e8 7f fc ff ff       	call   801257 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015db:	90                   	nop
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_rcr2>:
uint32 sys_rcr2()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 1e                	push   $0x1e
  8015ed:	e8 65 fc ff ff       	call   801257 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801603:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	50                   	push   %eax
  801610:	6a 1f                	push   $0x1f
  801612:	e8 40 fc ff ff       	call   801257 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
	return ;
  80161a:	90                   	nop
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <rsttst>:
void rsttst()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 21                	push   $0x21
  80162c:	e8 26 fc ff ff       	call   801257 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
	return ;
  801634:	90                   	nop
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	8b 45 14             	mov    0x14(%ebp),%eax
  801640:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801643:	8b 55 18             	mov    0x18(%ebp),%edx
  801646:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80164a:	52                   	push   %edx
  80164b:	50                   	push   %eax
  80164c:	ff 75 10             	pushl  0x10(%ebp)
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	ff 75 08             	pushl  0x8(%ebp)
  801655:	6a 20                	push   $0x20
  801657:	e8 fb fb ff ff       	call   801257 <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
	return ;
  80165f:	90                   	nop
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <chktst>:
void chktst(uint32 n)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	ff 75 08             	pushl  0x8(%ebp)
  801670:	6a 22                	push   $0x22
  801672:	e8 e0 fb ff ff       	call   801257 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
	return ;
  80167a:	90                   	nop
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <inctst>:

void inctst()
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 23                	push   $0x23
  80168c:	e8 c6 fb ff ff       	call   801257 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
	return ;
  801694:	90                   	nop
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <gettst>:
uint32 gettst()
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 24                	push   $0x24
  8016a6:	e8 ac fb ff ff       	call   801257 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 25                	push   $0x25
  8016bf:	e8 93 fb ff ff       	call   801257 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
  8016c7:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8016cc:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	ff 75 08             	pushl  0x8(%ebp)
  8016e9:	6a 26                	push   $0x26
  8016eb:	e8 67 fb ff ff       	call   801257 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f3:	90                   	nop
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	53                   	push   %ebx
  801709:	51                   	push   %ecx
  80170a:	52                   	push   %edx
  80170b:	50                   	push   %eax
  80170c:	6a 27                	push   $0x27
  80170e:	e8 44 fb ff ff       	call   801257 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80171e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	52                   	push   %edx
  80172b:	50                   	push   %eax
  80172c:	6a 28                	push   $0x28
  80172e:	e8 24 fb ff ff       	call   801257 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80173b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80173e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	6a 00                	push   $0x0
  801746:	51                   	push   %ecx
  801747:	ff 75 10             	pushl  0x10(%ebp)
  80174a:	52                   	push   %edx
  80174b:	50                   	push   %eax
  80174c:	6a 29                	push   $0x29
  80174e:	e8 04 fb ff ff       	call   801257 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 10             	pushl  0x10(%ebp)
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	ff 75 08             	pushl  0x8(%ebp)
  801768:	6a 12                	push   $0x12
  80176a:	e8 e8 fa ff ff       	call   801257 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
	return ;
  801772:	90                   	nop
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	52                   	push   %edx
  801785:	50                   	push   %eax
  801786:	6a 2a                	push   $0x2a
  801788:	e8 ca fa ff ff       	call   801257 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
	return;
  801790:	90                   	nop
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 2b                	push   $0x2b
  8017a2:	e8 b0 fa ff ff       	call   801257 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	6a 2d                	push   $0x2d
  8017bd:	e8 95 fa ff ff       	call   801257 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
	return;
  8017c5:	90                   	nop
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	6a 2c                	push   $0x2c
  8017d9:	e8 79 fa ff ff       	call   801257 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e1:	90                   	nop
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	68 68 21 80 00       	push   $0x802168
  8017f2:	68 25 01 00 00       	push   $0x125
  8017f7:	68 9b 21 80 00       	push   $0x80219b
  8017fc:	e8 00 00 00 00       	call   801801 <_panic>

00801801 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801807:	8d 45 10             	lea    0x10(%ebp),%eax
  80180a:	83 c0 04             	add    $0x4,%eax
  80180d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801810:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801815:	85 c0                	test   %eax,%eax
  801817:	74 16                	je     80182f <_panic+0x2e>
		cprintf("%s: ", argv0);
  801819:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80181e:	83 ec 08             	sub    $0x8,%esp
  801821:	50                   	push   %eax
  801822:	68 ac 21 80 00       	push   $0x8021ac
  801827:	e8 46 eb ff ff       	call   800372 <cprintf>
  80182c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80182f:	a1 04 30 80 00       	mov    0x803004,%eax
  801834:	83 ec 0c             	sub    $0xc,%esp
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	50                   	push   %eax
  80183e:	68 b4 21 80 00       	push   $0x8021b4
  801843:	6a 74                	push   $0x74
  801845:	e8 55 eb ff ff       	call   80039f <cprintf_colored>
  80184a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80184d:	8b 45 10             	mov    0x10(%ebp),%eax
  801850:	83 ec 08             	sub    $0x8,%esp
  801853:	ff 75 f4             	pushl  -0xc(%ebp)
  801856:	50                   	push   %eax
  801857:	e8 a7 ea ff ff       	call   800303 <vcprintf>
  80185c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	6a 00                	push   $0x0
  801864:	68 dc 21 80 00       	push   $0x8021dc
  801869:	e8 95 ea ff ff       	call   800303 <vcprintf>
  80186e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801871:	e8 0e ea ff ff       	call   800284 <exit>

	// should not return here
	while (1) ;
  801876:	eb fe                	jmp    801876 <_panic+0x75>

00801878 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80187e:	a1 20 30 80 00       	mov    0x803020,%eax
  801883:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188c:	39 c2                	cmp    %eax,%edx
  80188e:	74 14                	je     8018a4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	68 e0 21 80 00       	push   $0x8021e0
  801898:	6a 26                	push   $0x26
  80189a:	68 2c 22 80 00       	push   $0x80222c
  80189f:	e8 5d ff ff ff       	call   801801 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8018a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8018ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018b2:	e9 c5 00 00 00       	jmp    80197c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	01 d0                	add    %edx,%eax
  8018c6:	8b 00                	mov    (%eax),%eax
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	75 08                	jne    8018d4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018cc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018cf:	e9 a5 00 00 00       	jmp    801979 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018e2:	eb 69                	jmp    80194d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8018e9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018f2:	89 d0                	mov    %edx,%eax
  8018f4:	01 c0                	add    %eax,%eax
  8018f6:	01 d0                	add    %edx,%eax
  8018f8:	c1 e0 03             	shl    $0x3,%eax
  8018fb:	01 c8                	add    %ecx,%eax
  8018fd:	8a 40 04             	mov    0x4(%eax),%al
  801900:	84 c0                	test   %al,%al
  801902:	75 46                	jne    80194a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801904:	a1 20 30 80 00       	mov    0x803020,%eax
  801909:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80190f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801912:	89 d0                	mov    %edx,%eax
  801914:	01 c0                	add    %eax,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	c1 e0 03             	shl    $0x3,%eax
  80191b:	01 c8                	add    %ecx,%eax
  80191d:	8b 00                	mov    (%eax),%eax
  80191f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801922:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801925:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80192a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	01 c8                	add    %ecx,%eax
  80193b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80193d:	39 c2                	cmp    %eax,%edx
  80193f:	75 09                	jne    80194a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801941:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801948:	eb 15                	jmp    80195f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80194a:	ff 45 e8             	incl   -0x18(%ebp)
  80194d:	a1 20 30 80 00       	mov    0x803020,%eax
  801952:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195b:	39 c2                	cmp    %eax,%edx
  80195d:	77 85                	ja     8018e4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80195f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801963:	75 14                	jne    801979 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	68 38 22 80 00       	push   $0x802238
  80196d:	6a 3a                	push   $0x3a
  80196f:	68 2c 22 80 00       	push   $0x80222c
  801974:	e8 88 fe ff ff       	call   801801 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801979:	ff 45 f0             	incl   -0x10(%ebp)
  80197c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801982:	0f 8c 2f ff ff ff    	jl     8018b7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80198f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801996:	eb 26                	jmp    8019be <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801998:	a1 20 30 80 00       	mov    0x803020,%eax
  80199d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8019a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019a6:	89 d0                	mov    %edx,%eax
  8019a8:	01 c0                	add    %eax,%eax
  8019aa:	01 d0                	add    %edx,%eax
  8019ac:	c1 e0 03             	shl    $0x3,%eax
  8019af:	01 c8                	add    %ecx,%eax
  8019b1:	8a 40 04             	mov    0x4(%eax),%al
  8019b4:	3c 01                	cmp    $0x1,%al
  8019b6:	75 03                	jne    8019bb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019b8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019bb:	ff 45 e0             	incl   -0x20(%ebp)
  8019be:	a1 20 30 80 00       	mov    0x803020,%eax
  8019c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019cc:	39 c2                	cmp    %eax,%edx
  8019ce:	77 c8                	ja     801998 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019d6:	74 14                	je     8019ec <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019d8:	83 ec 04             	sub    $0x4,%esp
  8019db:	68 8c 22 80 00       	push   $0x80228c
  8019e0:	6a 44                	push   $0x44
  8019e2:	68 2c 22 80 00       	push   $0x80222c
  8019e7:	e8 15 fe ff ff       	call   801801 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    
  8019ef:	90                   	nop

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
