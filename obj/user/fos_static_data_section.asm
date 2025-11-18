
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 e0 1b 80 00       	push   $0x801be0
  800046:	e8 1d 03 00 00       	call   800368 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	57                   	push   %edi
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005a:	e8 64 14 00 00       	call   8014c3 <sys_getenvindex>
  80005f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800062:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	c1 e0 06             	shl    $0x6,%eax
  80006a:	29 d0                	sub    %edx,%eax
  80006c:	c1 e0 02             	shl    $0x2,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800078:	01 c8                	add    %ecx,%eax
  80007a:	c1 e0 03             	shl    $0x3,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800086:	29 c2                	sub    %eax,%edx
  800088:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80008f:	89 c2                	mov    %eax,%edx
  800091:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800097:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009c:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a1:	8a 40 20             	mov    0x20(%eax),%al
  8000a4:	84 c0                	test   %al,%al
  8000a6:	74 0d                	je     8000b5 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8000a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ad:	83 c0 20             	add    $0x20,%eax
  8000b0:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b9:	7e 0a                	jle    8000c5 <libmain+0x74>
		binaryname = argv[0];
  8000bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000be:	8b 00                	mov    (%eax),%eax
  8000c0:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c5:	83 ec 08             	sub    $0x8,%esp
  8000c8:	ff 75 0c             	pushl  0xc(%ebp)
  8000cb:	ff 75 08             	pushl  0x8(%ebp)
  8000ce:	e8 65 ff ff ff       	call   800038 <_main>
  8000d3:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d6:	a1 00 30 80 00       	mov    0x803000,%eax
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	0f 84 01 01 00 00    	je     8001e4 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000e3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000e9:	bb 04 1d 80 00       	mov    $0x801d04,%ebx
  8000ee:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	89 de                	mov    %ebx,%esi
  8000f7:	89 d1                	mov    %edx,%ecx
  8000f9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000fb:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000fe:	b9 56 00 00 00       	mov    $0x56,%ecx
  800103:	b0 00                	mov    $0x0,%al
  800105:	89 d7                	mov    %edx,%edi
  800107:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800109:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800110:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800113:	83 ec 08             	sub    $0x8,%esp
  800116:	50                   	push   %eax
  800117:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80011d:	50                   	push   %eax
  80011e:	e8 d6 15 00 00       	call   8016f9 <sys_utilities>
  800123:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800126:	e8 1f 11 00 00       	call   80124a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	68 24 1c 80 00       	push   $0x801c24
  800133:	e8 be 01 00 00       	call   8002f6 <cprintf>
  800138:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80013b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013e:	85 c0                	test   %eax,%eax
  800140:	74 18                	je     80015a <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800142:	e8 d0 15 00 00       	call   801717 <sys_get_optimal_num_faults>
  800147:	83 ec 08             	sub    $0x8,%esp
  80014a:	50                   	push   %eax
  80014b:	68 4c 1c 80 00       	push   $0x801c4c
  800150:	e8 a1 01 00 00       	call   8002f6 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	eb 59                	jmp    8001b3 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015a:	a1 20 30 80 00       	mov    0x803020,%eax
  80015f:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800165:	a1 20 30 80 00       	mov    0x803020,%eax
  80016a:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800170:	83 ec 04             	sub    $0x4,%esp
  800173:	52                   	push   %edx
  800174:	50                   	push   %eax
  800175:	68 70 1c 80 00       	push   $0x801c70
  80017a:	e8 77 01 00 00       	call   8002f6 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80018d:	a1 20 30 80 00       	mov    0x803020,%eax
  800192:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800198:	a1 20 30 80 00       	mov    0x803020,%eax
  80019d:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001a3:	51                   	push   %ecx
  8001a4:	52                   	push   %edx
  8001a5:	50                   	push   %eax
  8001a6:	68 98 1c 80 00       	push   $0x801c98
  8001ab:	e8 46 01 00 00       	call   8002f6 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b8:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 f0 1c 80 00       	push   $0x801cf0
  8001c7:	e8 2a 01 00 00       	call   8002f6 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 24 1c 80 00       	push   $0x801c24
  8001d7:	e8 1a 01 00 00       	call   8002f6 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001df:	e8 80 10 00 00       	call   801264 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001e4:	e8 1f 00 00 00       	call   800208 <exit>
}
  8001e9:	90                   	nop
  8001ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ed:	5b                   	pop    %ebx
  8001ee:	5e                   	pop    %esi
  8001ef:	5f                   	pop    %edi
  8001f0:	5d                   	pop    %ebp
  8001f1:	c3                   	ret    

008001f2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	e8 8d 12 00 00       	call   80148f <sys_destroy_env>
  800202:	83 c4 10             	add    $0x10,%esp
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <exit>:

void
exit(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020e:	e8 e2 12 00 00       	call   8014f5 <sys_exit_env>
}
  800213:	90                   	nop
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	53                   	push   %ebx
  80021a:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80021d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 48 01             	lea    0x1(%eax),%ecx
  800225:	8b 55 0c             	mov    0xc(%ebp),%edx
  800228:	89 0a                	mov    %ecx,(%edx)
  80022a:	8b 55 08             	mov    0x8(%ebp),%edx
  80022d:	88 d1                	mov    %dl,%cl
  80022f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800232:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800236:	8b 45 0c             	mov    0xc(%ebp),%eax
  800239:	8b 00                	mov    (%eax),%eax
  80023b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800240:	75 30                	jne    800272 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800242:	8b 15 b8 e9 82 00    	mov    0x82e9b8,%edx
  800248:	a0 e0 68 81 00       	mov    0x8168e0,%al
  80024d:	0f b6 c0             	movzbl %al,%eax
  800250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800253:	8b 09                	mov    (%ecx),%ecx
  800255:	89 cb                	mov    %ecx,%ebx
  800257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025a:	83 c1 08             	add    $0x8,%ecx
  80025d:	52                   	push   %edx
  80025e:	50                   	push   %eax
  80025f:	53                   	push   %ebx
  800260:	51                   	push   %ecx
  800261:	e8 a0 0f 00 00       	call   801206 <sys_cputs>
  800266:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	8b 40 04             	mov    0x4(%eax),%eax
  800278:	8d 50 01             	lea    0x1(%eax),%edx
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800281:	90                   	nop
  800282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800290:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800297:	00 00 00 
	b.cnt = 0;
  80029a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b0:	50                   	push   %eax
  8002b1:	68 16 02 80 00       	push   $0x800216
  8002b6:	e8 5a 02 00 00       	call   800515 <vprintfmt>
  8002bb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002be:	8b 15 b8 e9 82 00    	mov    0x82e9b8,%edx
  8002c4:	a0 e0 68 81 00       	mov    0x8168e0,%al
  8002c9:	0f b6 c0             	movzbl %al,%eax
  8002cc:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002d2:	52                   	push   %edx
  8002d3:	50                   	push   %eax
  8002d4:	51                   	push   %ecx
  8002d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002db:	83 c0 08             	add    $0x8,%eax
  8002de:	50                   	push   %eax
  8002df:	e8 22 0f 00 00       	call   801206 <sys_cputs>
  8002e4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e7:	c6 05 e0 68 81 00 00 	movb   $0x0,0x8168e0
	return b.cnt;
  8002ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f4:	c9                   	leave  
  8002f5:	c3                   	ret    

008002f6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002fc:	c6 05 e0 68 81 00 01 	movb   $0x1,0x8168e0
	va_start(ap, fmt);
  800303:	8d 45 0c             	lea    0xc(%ebp),%eax
  800306:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	ff 75 f4             	pushl  -0xc(%ebp)
  800312:	50                   	push   %eax
  800313:	e8 6f ff ff ff       	call   800287 <vcprintf>
  800318:	83 c4 10             	add    $0x10,%esp
  80031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800329:	c6 05 e0 68 81 00 01 	movb   $0x1,0x8168e0
	curTextClr = (textClr << 8) ; //set text color by the given value
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	c1 e0 08             	shl    $0x8,%eax
  800336:	a3 b8 e9 82 00       	mov    %eax,0x82e9b8
	va_start(ap, fmt);
  80033b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80033e:	83 c0 04             	add    $0x4,%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	83 ec 08             	sub    $0x8,%esp
  80034a:	ff 75 f4             	pushl  -0xc(%ebp)
  80034d:	50                   	push   %eax
  80034e:	e8 34 ff ff ff       	call   800287 <vcprintf>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800359:	c7 05 b8 e9 82 00 00 	movl   $0x700,0x82e9b8
  800360:	07 00 00 

	return cnt;
  800363:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80036e:	e8 d7 0e 00 00       	call   80124a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800373:	8d 45 0c             	lea    0xc(%ebp),%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	ff 75 f4             	pushl  -0xc(%ebp)
  800382:	50                   	push   %eax
  800383:	e8 ff fe ff ff       	call   800287 <vcprintf>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80038e:	e8 d1 0e 00 00       	call   801264 <sys_unlock_cons>
	return cnt;
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	53                   	push   %ebx
  80039c:	83 ec 14             	sub    $0x14,%esp
  80039f:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b6:	77 55                	ja     80040d <printnum+0x75>
  8003b8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003bb:	72 05                	jb     8003c2 <printnum+0x2a>
  8003bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003c0:	77 4b                	ja     80040d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003c5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d0:	52                   	push   %edx
  8003d1:	50                   	push   %eax
  8003d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d8:	e8 97 15 00 00       	call   801974 <__udivdi3>
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	ff 75 20             	pushl  0x20(%ebp)
  8003e6:	53                   	push   %ebx
  8003e7:	ff 75 18             	pushl  0x18(%ebp)
  8003ea:	52                   	push   %edx
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 0c             	pushl  0xc(%ebp)
  8003ef:	ff 75 08             	pushl  0x8(%ebp)
  8003f2:	e8 a1 ff ff ff       	call   800398 <printnum>
  8003f7:	83 c4 20             	add    $0x20,%esp
  8003fa:	eb 1a                	jmp    800416 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 0c             	pushl  0xc(%ebp)
  800402:	ff 75 20             	pushl  0x20(%ebp)
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	ff d0                	call   *%eax
  80040a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80040d:	ff 4d 1c             	decl   0x1c(%ebp)
  800410:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800414:	7f e6                	jg     8003fc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800416:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800419:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800421:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800424:	53                   	push   %ebx
  800425:	51                   	push   %ecx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	e8 57 16 00 00       	call   801a84 <__umoddi3>
  80042d:	83 c4 10             	add    $0x10,%esp
  800430:	05 94 1f 80 00       	add    $0x801f94,%eax
  800435:	8a 00                	mov    (%eax),%al
  800437:	0f be c0             	movsbl %al,%eax
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	ff 75 0c             	pushl  0xc(%ebp)
  800440:	50                   	push   %eax
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	ff d0                	call   *%eax
  800446:	83 c4 10             	add    $0x10,%esp
}
  800449:	90                   	nop
  80044a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    

0080044f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800452:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800456:	7e 1c                	jle    800474 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	8d 50 08             	lea    0x8(%eax),%edx
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	89 10                	mov    %edx,(%eax)
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	83 e8 08             	sub    $0x8,%eax
  80046d:	8b 50 04             	mov    0x4(%eax),%edx
  800470:	8b 00                	mov    (%eax),%eax
  800472:	eb 40                	jmp    8004b4 <getuint+0x65>
	else if (lflag)
  800474:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800478:	74 1e                	je     800498 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	8d 50 04             	lea    0x4(%eax),%edx
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	89 10                	mov    %edx,(%eax)
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	83 e8 04             	sub    $0x4,%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	ba 00 00 00 00       	mov    $0x0,%edx
  800496:	eb 1c                	jmp    8004b4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 04             	lea    0x4(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 04             	sub    $0x4,%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b4:	5d                   	pop    %ebp
  8004b5:	c3                   	ret    

008004b6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004bd:	7e 1c                	jle    8004db <getint+0x25>
		return va_arg(*ap, long long);
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	8d 50 08             	lea    0x8(%eax),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	89 10                	mov    %edx,(%eax)
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	83 e8 08             	sub    $0x8,%eax
  8004d4:	8b 50 04             	mov    0x4(%eax),%edx
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	eb 38                	jmp    800513 <getint+0x5d>
	else if (lflag)
  8004db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004df:	74 1a                	je     8004fb <getint+0x45>
		return va_arg(*ap, long);
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 50 04             	lea    0x4(%eax),%edx
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	89 10                	mov    %edx,(%eax)
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	83 e8 04             	sub    $0x4,%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	99                   	cltd   
  8004f9:	eb 18                	jmp    800513 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 50 04             	lea    0x4(%eax),%edx
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	89 10                	mov    %edx,(%eax)
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	83 e8 04             	sub    $0x4,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	99                   	cltd   
}
  800513:	5d                   	pop    %ebp
  800514:	c3                   	ret    

00800515 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	56                   	push   %esi
  800519:	53                   	push   %ebx
  80051a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80051d:	eb 17                	jmp    800536 <vprintfmt+0x21>
			if (ch == '\0')
  80051f:	85 db                	test   %ebx,%ebx
  800521:	0f 84 c1 03 00 00    	je     8008e8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	ff 75 0c             	pushl  0xc(%ebp)
  80052d:	53                   	push   %ebx
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	ff d0                	call   *%eax
  800533:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800536:	8b 45 10             	mov    0x10(%ebp),%eax
  800539:	8d 50 01             	lea    0x1(%eax),%edx
  80053c:	89 55 10             	mov    %edx,0x10(%ebp)
  80053f:	8a 00                	mov    (%eax),%al
  800541:	0f b6 d8             	movzbl %al,%ebx
  800544:	83 fb 25             	cmp    $0x25,%ebx
  800547:	75 d6                	jne    80051f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800549:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80054d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800554:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800562:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800569:	8b 45 10             	mov    0x10(%ebp),%eax
  80056c:	8d 50 01             	lea    0x1(%eax),%edx
  80056f:	89 55 10             	mov    %edx,0x10(%ebp)
  800572:	8a 00                	mov    (%eax),%al
  800574:	0f b6 d8             	movzbl %al,%ebx
  800577:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80057a:	83 f8 5b             	cmp    $0x5b,%eax
  80057d:	0f 87 3d 03 00 00    	ja     8008c0 <vprintfmt+0x3ab>
  800583:	8b 04 85 b8 1f 80 00 	mov    0x801fb8(,%eax,4),%eax
  80058a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80058c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800590:	eb d7                	jmp    800569 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800592:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800596:	eb d1                	jmp    800569 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800598:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80059f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	c1 e0 02             	shl    $0x2,%eax
  8005a7:	01 d0                	add    %edx,%eax
  8005a9:	01 c0                	add    %eax,%eax
  8005ab:	01 d8                	add    %ebx,%eax
  8005ad:	83 e8 30             	sub    $0x30,%eax
  8005b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b6:	8a 00                	mov    (%eax),%al
  8005b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005be:	7e 3e                	jle    8005fe <vprintfmt+0xe9>
  8005c0:	83 fb 39             	cmp    $0x39,%ebx
  8005c3:	7f 39                	jg     8005fe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005c8:	eb d5                	jmp    80059f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	83 c0 04             	add    $0x4,%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 e8 04             	sub    $0x4,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005de:	eb 1f                	jmp    8005ff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e4:	79 83                	jns    800569 <vprintfmt+0x54>
				width = 0;
  8005e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005ed:	e9 77 ff ff ff       	jmp    800569 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005f2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005f9:	e9 6b ff ff ff       	jmp    800569 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005fe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800603:	0f 89 60 ff ff ff    	jns    800569 <vprintfmt+0x54>
				width = precision, precision = -1;
  800609:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80060f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800616:	e9 4e ff ff ff       	jmp    800569 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80061b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80061e:	e9 46 ff ff ff       	jmp    800569 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	83 c0 04             	add    $0x4,%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	83 e8 04             	sub    $0x4,%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 0c             	pushl  0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
			break;
  800643:	e9 9b 02 00 00       	jmp    8008e3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	83 c0 04             	add    $0x4,%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	83 e8 04             	sub    $0x4,%eax
  800657:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800659:	85 db                	test   %ebx,%ebx
  80065b:	79 02                	jns    80065f <vprintfmt+0x14a>
				err = -err;
  80065d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80065f:	83 fb 64             	cmp    $0x64,%ebx
  800662:	7f 0b                	jg     80066f <vprintfmt+0x15a>
  800664:	8b 34 9d 00 1e 80 00 	mov    0x801e00(,%ebx,4),%esi
  80066b:	85 f6                	test   %esi,%esi
  80066d:	75 19                	jne    800688 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80066f:	53                   	push   %ebx
  800670:	68 a5 1f 80 00       	push   $0x801fa5
  800675:	ff 75 0c             	pushl  0xc(%ebp)
  800678:	ff 75 08             	pushl  0x8(%ebp)
  80067b:	e8 70 02 00 00       	call   8008f0 <printfmt>
  800680:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800683:	e9 5b 02 00 00       	jmp    8008e3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800688:	56                   	push   %esi
  800689:	68 ae 1f 80 00       	push   $0x801fae
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	ff 75 08             	pushl  0x8(%ebp)
  800694:	e8 57 02 00 00       	call   8008f0 <printfmt>
  800699:	83 c4 10             	add    $0x10,%esp
			break;
  80069c:	e9 42 02 00 00       	jmp    8008e3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	83 c0 04             	add    $0x4,%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	83 e8 04             	sub    $0x4,%eax
  8006b0:	8b 30                	mov    (%eax),%esi
  8006b2:	85 f6                	test   %esi,%esi
  8006b4:	75 05                	jne    8006bb <vprintfmt+0x1a6>
				p = "(null)";
  8006b6:	be b1 1f 80 00       	mov    $0x801fb1,%esi
			if (width > 0 && padc != '-')
  8006bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bf:	7e 6d                	jle    80072e <vprintfmt+0x219>
  8006c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006c5:	74 67                	je     80072e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	50                   	push   %eax
  8006ce:	56                   	push   %esi
  8006cf:	e8 1e 03 00 00       	call   8009f2 <strnlen>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006da:	eb 16                	jmp    8006f2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	50                   	push   %eax
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	ff d0                	call   *%eax
  8006ec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f6:	7f e4                	jg     8006dc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f8:	eb 34                	jmp    80072e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006fe:	74 1c                	je     80071c <vprintfmt+0x207>
  800700:	83 fb 1f             	cmp    $0x1f,%ebx
  800703:	7e 05                	jle    80070a <vprintfmt+0x1f5>
  800705:	83 fb 7e             	cmp    $0x7e,%ebx
  800708:	7e 12                	jle    80071c <vprintfmt+0x207>
					putch('?', putdat);
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	6a 3f                	push   $0x3f
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	ff d0                	call   *%eax
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	eb 0f                	jmp    80072b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	53                   	push   %ebx
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	ff d0                	call   *%eax
  800728:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072b:	ff 4d e4             	decl   -0x1c(%ebp)
  80072e:	89 f0                	mov    %esi,%eax
  800730:	8d 70 01             	lea    0x1(%eax),%esi
  800733:	8a 00                	mov    (%eax),%al
  800735:	0f be d8             	movsbl %al,%ebx
  800738:	85 db                	test   %ebx,%ebx
  80073a:	74 24                	je     800760 <vprintfmt+0x24b>
  80073c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800740:	78 b8                	js     8006fa <vprintfmt+0x1e5>
  800742:	ff 4d e0             	decl   -0x20(%ebp)
  800745:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800749:	79 af                	jns    8006fa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074b:	eb 13                	jmp    800760 <vprintfmt+0x24b>
				putch(' ', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	6a 20                	push   $0x20
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	ff d0                	call   *%eax
  80075a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80075d:	ff 4d e4             	decl   -0x1c(%ebp)
  800760:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800764:	7f e7                	jg     80074d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800766:	e9 78 01 00 00       	jmp    8008e3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 e8             	pushl  -0x18(%ebp)
  800771:	8d 45 14             	lea    0x14(%ebp),%eax
  800774:	50                   	push   %eax
  800775:	e8 3c fd ff ff       	call   8004b6 <getint>
  80077a:	83 c4 10             	add    $0x10,%esp
  80077d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800780:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800789:	85 d2                	test   %edx,%edx
  80078b:	79 23                	jns    8007b0 <vprintfmt+0x29b>
				putch('-', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 2d                	push   $0x2d
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a3:	f7 d8                	neg    %eax
  8007a5:	83 d2 00             	adc    $0x0,%edx
  8007a8:	f7 da                	neg    %edx
  8007aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007b0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007b7:	e9 bc 00 00 00       	jmp    800878 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c5:	50                   	push   %eax
  8007c6:	e8 84 fc ff ff       	call   80044f <getuint>
  8007cb:	83 c4 10             	add    $0x10,%esp
  8007ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007db:	e9 98 00 00 00       	jmp    800878 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	6a 58                	push   $0x58
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	6a 58                	push   $0x58
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	6a 58                	push   $0x58
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
			break;
  800810:	e9 ce 00 00 00       	jmp    8008e3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	6a 30                	push   $0x30
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	ff d0                	call   *%eax
  800822:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	6a 78                	push   $0x78
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	ff d0                	call   *%eax
  800832:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 c0 04             	add    $0x4,%eax
  80083b:	89 45 14             	mov    %eax,0x14(%ebp)
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	83 e8 04             	sub    $0x4,%eax
  800844:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800846:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800850:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800857:	eb 1f                	jmp    800878 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 e8             	pushl  -0x18(%ebp)
  80085f:	8d 45 14             	lea    0x14(%ebp),%eax
  800862:	50                   	push   %eax
  800863:	e8 e7 fb ff ff       	call   80044f <getuint>
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800871:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800878:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80087c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	52                   	push   %edx
  800883:	ff 75 e4             	pushl  -0x1c(%ebp)
  800886:	50                   	push   %eax
  800887:	ff 75 f4             	pushl  -0xc(%ebp)
  80088a:	ff 75 f0             	pushl  -0x10(%ebp)
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	ff 75 08             	pushl  0x8(%ebp)
  800893:	e8 00 fb ff ff       	call   800398 <printnum>
  800898:	83 c4 20             	add    $0x20,%esp
			break;
  80089b:	eb 46                	jmp    8008e3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	53                   	push   %ebx
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	ff d0                	call   *%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ac:	eb 35                	jmp    8008e3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008ae:	c6 05 e0 68 81 00 00 	movb   $0x0,0x8168e0
			break;
  8008b5:	eb 2c                	jmp    8008e3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008b7:	c6 05 e0 68 81 00 01 	movb   $0x1,0x8168e0
			break;
  8008be:	eb 23                	jmp    8008e3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	6a 25                	push   $0x25
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d0:	ff 4d 10             	decl   0x10(%ebp)
  8008d3:	eb 03                	jmp    8008d8 <vprintfmt+0x3c3>
  8008d5:	ff 4d 10             	decl   0x10(%ebp)
  8008d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008db:	48                   	dec    %eax
  8008dc:	8a 00                	mov    (%eax),%al
  8008de:	3c 25                	cmp    $0x25,%al
  8008e0:	75 f3                	jne    8008d5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008e2:	90                   	nop
		}
	}
  8008e3:	e9 35 fc ff ff       	jmp    80051d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800902:	ff 75 f4             	pushl  -0xc(%ebp)
  800905:	50                   	push   %eax
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	ff 75 08             	pushl  0x8(%ebp)
  80090c:	e8 04 fc ff ff       	call   800515 <vprintfmt>
  800911:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800914:	90                   	nop
  800915:	c9                   	leave  
  800916:	c3                   	ret    

00800917 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091d:	8b 40 08             	mov    0x8(%eax),%eax
  800920:	8d 50 01             	lea    0x1(%eax),%edx
  800923:	8b 45 0c             	mov    0xc(%ebp),%eax
  800926:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 10                	mov    (%eax),%edx
  80092e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800931:	8b 40 04             	mov    0x4(%eax),%eax
  800934:	39 c2                	cmp    %eax,%edx
  800936:	73 12                	jae    80094a <sprintputch+0x33>
		*b->buf++ = ch;
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	8d 48 01             	lea    0x1(%eax),%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	89 0a                	mov    %ecx,(%edx)
  800945:	8b 55 08             	mov    0x8(%ebp),%edx
  800948:	88 10                	mov    %dl,(%eax)
}
  80094a:	90                   	nop
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	01 d0                	add    %edx,%eax
  800964:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800967:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80096e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800972:	74 06                	je     80097a <vsnprintf+0x2d>
  800974:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800978:	7f 07                	jg     800981 <vsnprintf+0x34>
		return -E_INVAL;
  80097a:	b8 03 00 00 00       	mov    $0x3,%eax
  80097f:	eb 20                	jmp    8009a1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800981:	ff 75 14             	pushl  0x14(%ebp)
  800984:	ff 75 10             	pushl  0x10(%ebp)
  800987:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	68 17 09 80 00       	push   $0x800917
  800990:	e8 80 fb ff ff       	call   800515 <vprintfmt>
  800995:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80099e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ac:	83 c0 04             	add    $0x4,%eax
  8009af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b8:	50                   	push   %eax
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	ff 75 08             	pushl  0x8(%ebp)
  8009bf:	e8 89 ff ff ff       	call   80094d <vsnprintf>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009cd:	c9                   	leave  
  8009ce:	c3                   	ret    

008009cf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009dc:	eb 06                	jmp    8009e4 <strlen+0x15>
		n++;
  8009de:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e1:	ff 45 08             	incl   0x8(%ebp)
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	84 c0                	test   %al,%al
  8009eb:	75 f1                	jne    8009de <strlen+0xf>
		n++;
	return n;
  8009ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ff:	eb 09                	jmp    800a0a <strnlen+0x18>
		n++;
  800a01:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a04:	ff 45 08             	incl   0x8(%ebp)
  800a07:	ff 4d 0c             	decl   0xc(%ebp)
  800a0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0e:	74 09                	je     800a19 <strnlen+0x27>
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8a 00                	mov    (%eax),%al
  800a15:	84 c0                	test   %al,%al
  800a17:	75 e8                	jne    800a01 <strnlen+0xf>
		n++;
	return n;
  800a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    

00800a1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a2a:	90                   	nop
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8d 50 01             	lea    0x1(%eax),%edx
  800a31:	89 55 08             	mov    %edx,0x8(%ebp)
  800a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a3d:	8a 12                	mov    (%edx),%dl
  800a3f:	88 10                	mov    %dl,(%eax)
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e4                	jne    800a2b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5f:	eb 1f                	jmp    800a80 <strncpy+0x34>
		*dst++ = *src;
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8d 50 01             	lea    0x1(%eax),%edx
  800a67:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6d:	8a 12                	mov    (%edx),%dl
  800a6f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a74:	8a 00                	mov    (%eax),%al
  800a76:	84 c0                	test   %al,%al
  800a78:	74 03                	je     800a7d <strncpy+0x31>
			src++;
  800a7a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7d:	ff 45 fc             	incl   -0x4(%ebp)
  800a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a86:	72 d9                	jb     800a61 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9d:	74 30                	je     800acf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a9f:	eb 16                	jmp    800ab7 <strlcpy+0x2a>
			*dst++ = *src++;
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8d 50 01             	lea    0x1(%eax),%edx
  800aa7:	89 55 08             	mov    %edx,0x8(%ebp)
  800aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aad:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ab3:	8a 12                	mov    (%edx),%dl
  800ab5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab7:	ff 4d 10             	decl   0x10(%ebp)
  800aba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800abe:	74 09                	je     800ac9 <strlcpy+0x3c>
  800ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	84 c0                	test   %al,%al
  800ac7:	75 d8                	jne    800aa1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800acf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad5:	29 c2                	sub    %eax,%edx
  800ad7:	89 d0                	mov    %edx,%eax
}
  800ad9:	c9                   	leave  
  800ada:	c3                   	ret    

00800adb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ade:	eb 06                	jmp    800ae6 <strcmp+0xb>
		p++, q++;
  800ae0:	ff 45 08             	incl   0x8(%ebp)
  800ae3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8a 00                	mov    (%eax),%al
  800aeb:	84 c0                	test   %al,%al
  800aed:	74 0e                	je     800afd <strcmp+0x22>
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8a 10                	mov    (%eax),%dl
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	38 c2                	cmp    %al,%dl
  800afb:	74 e3                	je     800ae0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	0f b6 d0             	movzbl %al,%edx
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	8a 00                	mov    (%eax),%al
  800b0a:	0f b6 c0             	movzbl %al,%eax
  800b0d:	29 c2                	sub    %eax,%edx
  800b0f:	89 d0                	mov    %edx,%eax
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b16:	eb 09                	jmp    800b21 <strncmp+0xe>
		n--, p++, q++;
  800b18:	ff 4d 10             	decl   0x10(%ebp)
  800b1b:	ff 45 08             	incl   0x8(%ebp)
  800b1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b25:	74 17                	je     800b3e <strncmp+0x2b>
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8a 00                	mov    (%eax),%al
  800b2c:	84 c0                	test   %al,%al
  800b2e:	74 0e                	je     800b3e <strncmp+0x2b>
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8a 10                	mov    (%eax),%dl
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	8a 00                	mov    (%eax),%al
  800b3a:	38 c2                	cmp    %al,%dl
  800b3c:	74 da                	je     800b18 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b42:	75 07                	jne    800b4b <strncmp+0x38>
		return 0;
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	eb 14                	jmp    800b5f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	0f b6 d0             	movzbl %al,%edx
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8a 00                	mov    (%eax),%al
  800b58:	0f b6 c0             	movzbl %al,%eax
  800b5b:	29 c2                	sub    %eax,%edx
  800b5d:	89 d0                	mov    %edx,%eax
}
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 04             	sub    $0x4,%esp
  800b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b6d:	eb 12                	jmp    800b81 <strchr+0x20>
		if (*s == c)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8a 00                	mov    (%eax),%al
  800b74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b77:	75 05                	jne    800b7e <strchr+0x1d>
			return (char *) s;
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	eb 11                	jmp    800b8f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b7e:	ff 45 08             	incl   0x8(%ebp)
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	84 c0                	test   %al,%al
  800b88:	75 e5                	jne    800b6f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 04             	sub    $0x4,%esp
  800b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9d:	eb 0d                	jmp    800bac <strfind+0x1b>
		if (*s == c)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba7:	74 0e                	je     800bb7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba9:	ff 45 08             	incl   0x8(%ebp)
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8a 00                	mov    (%eax),%al
  800bb1:	84 c0                	test   %al,%al
  800bb3:	75 ea                	jne    800b9f <strfind+0xe>
  800bb5:	eb 01                	jmp    800bb8 <strfind+0x27>
		if (*s == c)
			break;
  800bb7:	90                   	nop
	return (char *) s;
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bc9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bcd:	76 63                	jbe    800c32 <memset+0x75>
		uint64 data_block = c;
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	99                   	cltd   
  800bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdf:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800be3:	c1 e0 08             	shl    $0x8,%eax
  800be6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800be9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800bf6:	c1 e0 10             	shl    $0x10,%eax
  800bf9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bfc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c05:	89 c2                	mov    %eax,%edx
  800c07:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c0f:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c12:	eb 18                	jmp    800c2c <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c14:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c17:	8d 41 08             	lea    0x8(%ecx),%eax
  800c1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c23:	89 01                	mov    %eax,(%ecx)
  800c25:	89 51 04             	mov    %edx,0x4(%ecx)
  800c28:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c2c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c30:	77 e2                	ja     800c14 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c36:	74 23                	je     800c5b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c3e:	eb 0e                	jmp    800c4e <memset+0x91>
			*p8++ = (uint8)c;
  800c40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c54:	89 55 10             	mov    %edx,0x10(%ebp)
  800c57:	85 c0                	test   %eax,%eax
  800c59:	75 e5                	jne    800c40 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c72:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c76:	76 24                	jbe    800c9c <memcpy+0x3c>
		while(n >= 8){
  800c78:	eb 1c                	jmp    800c96 <memcpy+0x36>
			*d64 = *s64;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7d:	8b 50 04             	mov    0x4(%eax),%edx
  800c80:	8b 00                	mov    (%eax),%eax
  800c82:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c85:	89 01                	mov    %eax,(%ecx)
  800c87:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c8a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c8e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c92:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c96:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c9a:	77 de                	ja     800c7a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca0:	74 31                	je     800cd3 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ca2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ca8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800cae:	eb 16                	jmp    800cc6 <memcpy+0x66>
			*d8++ = *s8++;
  800cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb3:	8d 50 01             	lea    0x1(%eax),%edx
  800cb6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbf:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cc2:	8a 12                	mov    (%edx),%dl
  800cc4:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ccc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	75 dd                	jne    800cb0 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ced:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cf0:	73 50                	jae    800d42 <memmove+0x6a>
  800cf2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf8:	01 d0                	add    %edx,%eax
  800cfa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cfd:	76 43                	jbe    800d42 <memmove+0x6a>
		s += n;
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d05:	8b 45 10             	mov    0x10(%ebp),%eax
  800d08:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d0b:	eb 10                	jmp    800d1d <memmove+0x45>
			*--d = *--s;
  800d0d:	ff 4d f8             	decl   -0x8(%ebp)
  800d10:	ff 4d fc             	decl   -0x4(%ebp)
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d20:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d23:	89 55 10             	mov    %edx,0x10(%ebp)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	75 e3                	jne    800d0d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2a:	eb 23                	jmp    800d4f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2f:	8d 50 01             	lea    0x1(%eax),%edx
  800d32:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d38:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d42:	8b 45 10             	mov    0x10(%ebp),%eax
  800d45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d48:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	75 dd                	jne    800d2c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d66:	eb 2a                	jmp    800d92 <memcmp+0x3e>
		if (*s1 != *s2)
  800d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 16                	je     800d8c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	0f b6 d0             	movzbl %al,%edx
  800d7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	0f b6 c0             	movzbl %al,%eax
  800d86:	29 c2                	sub    %eax,%edx
  800d88:	89 d0                	mov    %edx,%eax
  800d8a:	eb 18                	jmp    800da4 <memcmp+0x50>
		s1++, s2++;
  800d8c:	ff 45 fc             	incl   -0x4(%ebp)
  800d8f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d98:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9b:	85 c0                	test   %eax,%eax
  800d9d:	75 c9                	jne    800d68 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dac:	8b 55 08             	mov    0x8(%ebp),%edx
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	01 d0                	add    %edx,%eax
  800db4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800db7:	eb 15                	jmp    800dce <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	0f b6 d0             	movzbl %al,%edx
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	0f b6 c0             	movzbl %al,%eax
  800dc7:	39 c2                	cmp    %eax,%edx
  800dc9:	74 0d                	je     800dd8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dcb:	ff 45 08             	incl   0x8(%ebp)
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dd4:	72 e3                	jb     800db9 <memfind+0x13>
  800dd6:	eb 01                	jmp    800dd9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dd8:	90                   	nop
	return (void *) s;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800de4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800deb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df2:	eb 03                	jmp    800df7 <strtol+0x19>
		s++;
  800df4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	3c 20                	cmp    $0x20,%al
  800dfe:	74 f4                	je     800df4 <strtol+0x16>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	3c 09                	cmp    $0x9,%al
  800e07:	74 eb                	je     800df4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3c 2b                	cmp    $0x2b,%al
  800e10:	75 05                	jne    800e17 <strtol+0x39>
		s++;
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	eb 13                	jmp    800e2a <strtol+0x4c>
	else if (*s == '-')
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 2d                	cmp    $0x2d,%al
  800e1e:	75 0a                	jne    800e2a <strtol+0x4c>
		s++, neg = 1;
  800e20:	ff 45 08             	incl   0x8(%ebp)
  800e23:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2e:	74 06                	je     800e36 <strtol+0x58>
  800e30:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e34:	75 20                	jne    800e56 <strtol+0x78>
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	3c 30                	cmp    $0x30,%al
  800e3d:	75 17                	jne    800e56 <strtol+0x78>
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	40                   	inc    %eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3c 78                	cmp    $0x78,%al
  800e47:	75 0d                	jne    800e56 <strtol+0x78>
		s += 2, base = 16;
  800e49:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e4d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e54:	eb 28                	jmp    800e7e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5a:	75 15                	jne    800e71 <strtol+0x93>
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	3c 30                	cmp    $0x30,%al
  800e63:	75 0c                	jne    800e71 <strtol+0x93>
		s++, base = 8;
  800e65:	ff 45 08             	incl   0x8(%ebp)
  800e68:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e6f:	eb 0d                	jmp    800e7e <strtol+0xa0>
	else if (base == 0)
  800e71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e75:	75 07                	jne    800e7e <strtol+0xa0>
		base = 10;
  800e77:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	3c 2f                	cmp    $0x2f,%al
  800e85:	7e 19                	jle    800ea0 <strtol+0xc2>
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	3c 39                	cmp    $0x39,%al
  800e8e:	7f 10                	jg     800ea0 <strtol+0xc2>
			dig = *s - '0';
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	0f be c0             	movsbl %al,%eax
  800e98:	83 e8 30             	sub    $0x30,%eax
  800e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e9e:	eb 42                	jmp    800ee2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3c 60                	cmp    $0x60,%al
  800ea7:	7e 19                	jle    800ec2 <strtol+0xe4>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	3c 7a                	cmp    $0x7a,%al
  800eb0:	7f 10                	jg     800ec2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	0f be c0             	movsbl %al,%eax
  800eba:	83 e8 57             	sub    $0x57,%eax
  800ebd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ec0:	eb 20                	jmp    800ee2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	3c 40                	cmp    $0x40,%al
  800ec9:	7e 39                	jle    800f04 <strtol+0x126>
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	3c 5a                	cmp    $0x5a,%al
  800ed2:	7f 30                	jg     800f04 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	0f be c0             	movsbl %al,%eax
  800edc:	83 e8 37             	sub    $0x37,%eax
  800edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee8:	7d 19                	jge    800f03 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800eea:	ff 45 08             	incl   0x8(%ebp)
  800eed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ef4:	89 c2                	mov    %eax,%edx
  800ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef9:	01 d0                	add    %edx,%eax
  800efb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800efe:	e9 7b ff ff ff       	jmp    800e7e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f03:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f08:	74 08                	je     800f12 <strtol+0x134>
		*endptr = (char *) s;
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f10:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f12:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f16:	74 07                	je     800f1f <strtol+0x141>
  800f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1b:	f7 d8                	neg    %eax
  800f1d:	eb 03                	jmp    800f22 <strtol+0x144>
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <ltostr>:

void
ltostr(long value, char *str)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f31:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f3c:	79 13                	jns    800f51 <ltostr+0x2d>
	{
		neg = 1;
  800f3e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f4b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f4e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f59:	99                   	cltd   
  800f5a:	f7 f9                	idiv   %ecx
  800f5c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f62:	8d 50 01             	lea    0x1(%eax),%edx
  800f65:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f68:	89 c2                	mov    %eax,%edx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 d0                	add    %edx,%eax
  800f6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f72:	83 c2 30             	add    $0x30,%edx
  800f75:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f7a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f7f:	f7 e9                	imul   %ecx
  800f81:	c1 fa 02             	sar    $0x2,%edx
  800f84:	89 c8                	mov    %ecx,%eax
  800f86:	c1 f8 1f             	sar    $0x1f,%eax
  800f89:	29 c2                	sub    %eax,%edx
  800f8b:	89 d0                	mov    %edx,%eax
  800f8d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f94:	75 bb                	jne    800f51 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa0:	48                   	dec    %eax
  800fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fa8:	74 3d                	je     800fe7 <ltostr+0xc3>
		start = 1 ;
  800faa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fb1:	eb 34                	jmp    800fe7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	01 d0                	add    %edx,%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	01 c2                	add    %eax,%edx
  800fc8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	01 c8                	add    %ecx,%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fda:	01 c2                	add    %eax,%edx
  800fdc:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fdf:	88 02                	mov    %al,(%edx)
		start++ ;
  800fe1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fe4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fed:	7c c4                	jl     800fb3 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	01 d0                	add    %edx,%eax
  800ff7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ffa:	90                   	nop
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    

00800ffd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801003:	ff 75 08             	pushl  0x8(%ebp)
  801006:	e8 c4 f9 ff ff       	call   8009cf <strlen>
  80100b:	83 c4 04             	add    $0x4,%esp
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	e8 b6 f9 ff ff       	call   8009cf <strlen>
  801019:	83 c4 04             	add    $0x4,%esp
  80101c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80101f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801026:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80102d:	eb 17                	jmp    801046 <strcconcat+0x49>
		final[s] = str1[s] ;
  80102f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801032:	8b 45 10             	mov    0x10(%ebp),%eax
  801035:	01 c2                	add    %eax,%edx
  801037:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	01 c8                	add    %ecx,%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801043:	ff 45 fc             	incl   -0x4(%ebp)
  801046:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801049:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104c:	7c e1                	jl     80102f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80104e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801055:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80105c:	eb 1f                	jmp    80107d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80105e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801061:	8d 50 01             	lea    0x1(%eax),%edx
  801064:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801067:	89 c2                	mov    %eax,%edx
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	01 c2                	add    %eax,%edx
  80106e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	01 c8                	add    %ecx,%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80107a:	ff 45 f8             	incl   -0x8(%ebp)
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801083:	7c d9                	jl     80105e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801085:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801088:	8b 45 10             	mov    0x10(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	c6 00 00             	movb   $0x0,(%eax)
}
  801090:	90                   	nop
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801096:	8b 45 14             	mov    0x14(%ebp),%eax
  801099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80109f:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a2:	8b 00                	mov    (%eax),%eax
  8010a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	01 d0                	add    %edx,%eax
  8010b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010b6:	eb 0c                	jmp    8010c4 <strsplit+0x31>
			*string++ = 0;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	84 c0                	test   %al,%al
  8010cb:	74 18                	je     8010e5 <strsplit+0x52>
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	0f be c0             	movsbl %al,%eax
  8010d5:	50                   	push   %eax
  8010d6:	ff 75 0c             	pushl  0xc(%ebp)
  8010d9:	e8 83 fa ff ff       	call   800b61 <strchr>
  8010de:	83 c4 08             	add    $0x8,%esp
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	75 d3                	jne    8010b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	84 c0                	test   %al,%al
  8010ec:	74 5a                	je     801148 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	83 f8 0f             	cmp    $0xf,%eax
  8010f6:	75 07                	jne    8010ff <strsplit+0x6c>
		{
			return 0;
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fd:	eb 66                	jmp    801165 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801102:	8b 00                	mov    (%eax),%eax
  801104:	8d 48 01             	lea    0x1(%eax),%ecx
  801107:	8b 55 14             	mov    0x14(%ebp),%edx
  80110a:	89 0a                	mov    %ecx,(%edx)
  80110c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	01 c2                	add    %eax,%edx
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80111d:	eb 03                	jmp    801122 <strsplit+0x8f>
			string++;
  80111f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	84 c0                	test   %al,%al
  801129:	74 8b                	je     8010b6 <strsplit+0x23>
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	0f be c0             	movsbl %al,%eax
  801133:	50                   	push   %eax
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	e8 25 fa ff ff       	call   800b61 <strchr>
  80113c:	83 c4 08             	add    $0x8,%esp
  80113f:	85 c0                	test   %eax,%eax
  801141:	74 dc                	je     80111f <strsplit+0x8c>
			string++;
	}
  801143:	e9 6e ff ff ff       	jmp    8010b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801148:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801149:	8b 45 14             	mov    0x14(%ebp),%eax
  80114c:	8b 00                	mov    (%eax),%eax
  80114e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 d0                	add    %edx,%eax
  80115a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801160:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    

00801167 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801173:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117a:	eb 4a                	jmp    8011c6 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80117c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	01 c8                	add    %ecx,%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801190:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 40                	cmp    $0x40,%al
  80119c:	7e 25                	jle    8011c3 <str2lower+0x5c>
  80119e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	01 d0                	add    %edx,%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	3c 5a                	cmp    $0x5a,%al
  8011aa:	7f 17                	jg     8011c3 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	01 d0                	add    %edx,%eax
  8011b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ba:	01 ca                	add    %ecx,%edx
  8011bc:	8a 12                	mov    (%edx),%dl
  8011be:	83 c2 20             	add    $0x20,%edx
  8011c1:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011c3:	ff 45 fc             	incl   -0x4(%ebp)
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	e8 01 f8 ff ff       	call   8009cf <strlen>
  8011ce:	83 c4 04             	add    $0x4,%esp
  8011d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d4:	7f a6                	jg     80117c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	57                   	push   %edi
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011f6:	cd 30                	int    $0x30
  8011f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011fe:	83 c4 10             	add    $0x10,%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    

00801206 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 04             	sub    $0x4,%esp
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801212:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801215:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	6a 00                	push   $0x0
  80121e:	51                   	push   %ecx
  80121f:	52                   	push   %edx
  801220:	ff 75 0c             	pushl  0xc(%ebp)
  801223:	50                   	push   %eax
  801224:	6a 00                	push   $0x0
  801226:	e8 b0 ff ff ff       	call   8011db <syscall>
  80122b:	83 c4 18             	add    $0x18,%esp
}
  80122e:	90                   	nop
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <sys_cgetc>:

int
sys_cgetc(void)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 02                	push   $0x2
  801240:	e8 96 ff ff ff       	call   8011db <syscall>
  801245:	83 c4 18             	add    $0x18,%esp
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 03                	push   $0x3
  801259:	e8 7d ff ff ff       	call   8011db <syscall>
  80125e:	83 c4 18             	add    $0x18,%esp
}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	6a 04                	push   $0x4
  801273:	e8 63 ff ff ff       	call   8011db <syscall>
  801278:	83 c4 18             	add    $0x18,%esp
}
  80127b:	90                   	nop
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801281:	8b 55 0c             	mov    0xc(%ebp),%edx
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	52                   	push   %edx
  80128e:	50                   	push   %eax
  80128f:	6a 08                	push   $0x8
  801291:	e8 45 ff ff ff       	call   8011db <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	56                   	push   %esi
  80129f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012a0:	8b 75 18             	mov    0x18(%ebp),%esi
  8012a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
  8012b1:	51                   	push   %ecx
  8012b2:	52                   	push   %edx
  8012b3:	50                   	push   %eax
  8012b4:	6a 09                	push   $0x9
  8012b6:	e8 20 ff ff ff       	call   8011db <syscall>
  8012bb:	83 c4 18             	add    $0x18,%esp
}
  8012be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c1:	5b                   	pop    %ebx
  8012c2:	5e                   	pop    %esi
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	6a 0a                	push   $0xa
  8012d5:	e8 01 ff ff ff       	call   8011db <syscall>
  8012da:	83 c4 18             	add    $0x18,%esp
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	ff 75 0c             	pushl  0xc(%ebp)
  8012eb:	ff 75 08             	pushl  0x8(%ebp)
  8012ee:	6a 0b                	push   $0xb
  8012f0:	e8 e6 fe ff ff       	call   8011db <syscall>
  8012f5:	83 c4 18             	add    $0x18,%esp
}
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 0c                	push   $0xc
  801309:	e8 cd fe ff ff       	call   8011db <syscall>
  80130e:	83 c4 18             	add    $0x18,%esp
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 0d                	push   $0xd
  801322:	e8 b4 fe ff ff       	call   8011db <syscall>
  801327:	83 c4 18             	add    $0x18,%esp
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 0e                	push   $0xe
  80133b:	e8 9b fe ff ff       	call   8011db <syscall>
  801340:	83 c4 18             	add    $0x18,%esp
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 0f                	push   $0xf
  801354:	e8 82 fe ff ff       	call   8011db <syscall>
  801359:	83 c4 18             	add    $0x18,%esp
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	ff 75 08             	pushl  0x8(%ebp)
  80136c:	6a 10                	push   $0x10
  80136e:	e8 68 fe ff ff       	call   8011db <syscall>
  801373:	83 c4 18             	add    $0x18,%esp
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 11                	push   $0x11
  801387:	e8 4f fe ff ff       	call   8011db <syscall>
  80138c:	83 c4 18             	add    $0x18,%esp
}
  80138f:	90                   	nop
  801390:	c9                   	leave  
  801391:	c3                   	ret    

00801392 <sys_cputc>:

void
sys_cputc(const char c)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	83 ec 04             	sub    $0x4,%esp
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80139e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	50                   	push   %eax
  8013ab:	6a 01                	push   $0x1
  8013ad:	e8 29 fe ff ff       	call   8011db <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	90                   	nop
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 14                	push   $0x14
  8013c7:	e8 0f fe ff ff       	call   8011db <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	90                   	nop
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	6a 00                	push   $0x0
  8013ea:	51                   	push   %ecx
  8013eb:	52                   	push   %edx
  8013ec:	ff 75 0c             	pushl  0xc(%ebp)
  8013ef:	50                   	push   %eax
  8013f0:	6a 15                	push   $0x15
  8013f2:	e8 e4 fd ff ff       	call   8011db <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	52                   	push   %edx
  80140c:	50                   	push   %eax
  80140d:	6a 16                	push   $0x16
  80140f:	e8 c7 fd ff ff       	call   8011db <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
}
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80141c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80141f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	51                   	push   %ecx
  80142a:	52                   	push   %edx
  80142b:	50                   	push   %eax
  80142c:	6a 17                	push   $0x17
  80142e:	e8 a8 fd ff ff       	call   8011db <syscall>
  801433:	83 c4 18             	add    $0x18,%esp
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80143b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	52                   	push   %edx
  801448:	50                   	push   %eax
  801449:	6a 18                	push   $0x18
  80144b:	e8 8b fd ff ff       	call   8011db <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	6a 00                	push   $0x0
  80145d:	ff 75 14             	pushl  0x14(%ebp)
  801460:	ff 75 10             	pushl  0x10(%ebp)
  801463:	ff 75 0c             	pushl  0xc(%ebp)
  801466:	50                   	push   %eax
  801467:	6a 19                	push   $0x19
  801469:	e8 6d fd ff ff       	call   8011db <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	50                   	push   %eax
  801482:	6a 1a                	push   $0x1a
  801484:	e8 52 fd ff ff       	call   8011db <syscall>
  801489:	83 c4 18             	add    $0x18,%esp
}
  80148c:	90                   	nop
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	50                   	push   %eax
  80149e:	6a 1b                	push   $0x1b
  8014a0:	e8 36 fd ff ff       	call   8011db <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 05                	push   $0x5
  8014b9:	e8 1d fd ff ff       	call   8011db <syscall>
  8014be:	83 c4 18             	add    $0x18,%esp
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 06                	push   $0x6
  8014d2:	e8 04 fd ff ff       	call   8011db <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 07                	push   $0x7
  8014eb:	e8 eb fc ff ff       	call   8011db <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_exit_env>:


void sys_exit_env(void)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 1c                	push   $0x1c
  801504:	e8 d2 fc ff ff       	call   8011db <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	90                   	nop
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801515:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801518:	8d 50 04             	lea    0x4(%eax),%edx
  80151b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	52                   	push   %edx
  801525:	50                   	push   %eax
  801526:	6a 1d                	push   $0x1d
  801528:	e8 ae fc ff ff       	call   8011db <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
	return result;
  801530:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801533:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801536:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801539:	89 01                	mov    %eax,(%ecx)
  80153b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	c9                   	leave  
  801542:	c2 04 00             	ret    $0x4

00801545 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	ff 75 10             	pushl  0x10(%ebp)
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	6a 13                	push   $0x13
  801557:	e8 7f fc ff ff       	call   8011db <syscall>
  80155c:	83 c4 18             	add    $0x18,%esp
	return ;
  80155f:	90                   	nop
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sys_rcr2>:
uint32 sys_rcr2()
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 1e                	push   $0x1e
  801571:	e8 65 fc ff ff       	call   8011db <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 04             	sub    $0x4,%esp
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801587:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	50                   	push   %eax
  801594:	6a 1f                	push   $0x1f
  801596:	e8 40 fc ff ff       	call   8011db <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
	return ;
  80159e:	90                   	nop
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <rsttst>:
void rsttst()
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 21                	push   $0x21
  8015b0:	e8 26 fc ff ff       	call   8011db <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b8:	90                   	nop
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015c7:	8b 55 18             	mov    0x18(%ebp),%edx
  8015ca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015ce:	52                   	push   %edx
  8015cf:	50                   	push   %eax
  8015d0:	ff 75 10             	pushl  0x10(%ebp)
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	6a 20                	push   $0x20
  8015db:	e8 fb fb ff ff       	call   8011db <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e3:	90                   	nop
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <chktst>:
void chktst(uint32 n)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	ff 75 08             	pushl  0x8(%ebp)
  8015f4:	6a 22                	push   $0x22
  8015f6:	e8 e0 fb ff ff       	call   8011db <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fe:	90                   	nop
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <inctst>:

void inctst()
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 23                	push   $0x23
  801610:	e8 c6 fb ff ff       	call   8011db <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
	return ;
  801618:	90                   	nop
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <gettst>:
uint32 gettst()
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 24                	push   $0x24
  80162a:	e8 ac fb ff ff       	call   8011db <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 25                	push   $0x25
  801643:	e8 93 fb ff ff       	call   8011db <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
  80164b:	a3 00 e9 82 00       	mov    %eax,0x82e900
	return uheapPlaceStrategy ;
  801650:	a1 00 e9 82 00       	mov    0x82e900,%eax
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	a3 00 e9 82 00       	mov    %eax,0x82e900
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	6a 26                	push   $0x26
  80166f:	e8 67 fb ff ff       	call   8011db <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
	return ;
  801677:	90                   	nop
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80167e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801681:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801684:	8b 55 0c             	mov    0xc(%ebp),%edx
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	6a 00                	push   $0x0
  80168c:	53                   	push   %ebx
  80168d:	51                   	push   %ecx
  80168e:	52                   	push   %edx
  80168f:	50                   	push   %eax
  801690:	6a 27                	push   $0x27
  801692:	e8 44 fb ff ff       	call   8011db <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	52                   	push   %edx
  8016af:	50                   	push   %eax
  8016b0:	6a 28                	push   $0x28
  8016b2:	e8 24 fb ff ff       	call   8011db <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016bf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	6a 00                	push   $0x0
  8016ca:	51                   	push   %ecx
  8016cb:	ff 75 10             	pushl  0x10(%ebp)
  8016ce:	52                   	push   %edx
  8016cf:	50                   	push   %eax
  8016d0:	6a 29                	push   $0x29
  8016d2:	e8 04 fb ff ff       	call   8011db <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	ff 75 10             	pushl  0x10(%ebp)
  8016e6:	ff 75 0c             	pushl  0xc(%ebp)
  8016e9:	ff 75 08             	pushl  0x8(%ebp)
  8016ec:	6a 12                	push   $0x12
  8016ee:	e8 e8 fa ff ff       	call   8011db <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f6:	90                   	nop
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	52                   	push   %edx
  801709:	50                   	push   %eax
  80170a:	6a 2a                	push   $0x2a
  80170c:	e8 ca fa ff ff       	call   8011db <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
	return;
  801714:	90                   	nop
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 2b                	push   $0x2b
  801726:	e8 b0 fa ff ff       	call   8011db <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	ff 75 0c             	pushl  0xc(%ebp)
  80173c:	ff 75 08             	pushl  0x8(%ebp)
  80173f:	6a 2d                	push   $0x2d
  801741:	e8 95 fa ff ff       	call   8011db <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
	return;
  801749:	90                   	nop
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	6a 2c                	push   $0x2c
  80175d:	e8 79 fa ff ff       	call   8011db <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
	return ;
  801765:	90                   	nop
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	68 28 21 80 00       	push   $0x802128
  801776:	68 25 01 00 00       	push   $0x125
  80177b:	68 5b 21 80 00       	push   $0x80215b
  801780:	e8 00 00 00 00       	call   801785 <_panic>

00801785 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80178b:	8d 45 10             	lea    0x10(%ebp),%eax
  80178e:	83 c0 04             	add    $0x4,%eax
  801791:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801794:	a1 bc e9 82 00       	mov    0x82e9bc,%eax
  801799:	85 c0                	test   %eax,%eax
  80179b:	74 16                	je     8017b3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80179d:	a1 bc e9 82 00       	mov    0x82e9bc,%eax
  8017a2:	83 ec 08             	sub    $0x8,%esp
  8017a5:	50                   	push   %eax
  8017a6:	68 6c 21 80 00       	push   $0x80216c
  8017ab:	e8 46 eb ff ff       	call   8002f6 <cprintf>
  8017b0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	ff 75 0c             	pushl  0xc(%ebp)
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	50                   	push   %eax
  8017c2:	68 74 21 80 00       	push   $0x802174
  8017c7:	6a 74                	push   $0x74
  8017c9:	e8 55 eb ff ff       	call   800323 <cprintf_colored>
  8017ce:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017da:	50                   	push   %eax
  8017db:	e8 a7 ea ff ff       	call   800287 <vcprintf>
  8017e0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017e3:	83 ec 08             	sub    $0x8,%esp
  8017e6:	6a 00                	push   $0x0
  8017e8:	68 9c 21 80 00       	push   $0x80219c
  8017ed:	e8 95 ea ff ff       	call   800287 <vcprintf>
  8017f2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017f5:	e8 0e ea ff ff       	call   800208 <exit>

	// should not return here
	while (1) ;
  8017fa:	eb fe                	jmp    8017fa <_panic+0x75>

008017fc <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801802:	a1 20 30 80 00       	mov    0x803020,%eax
  801807:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80180d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801810:	39 c2                	cmp    %eax,%edx
  801812:	74 14                	je     801828 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 a0 21 80 00       	push   $0x8021a0
  80181c:	6a 26                	push   $0x26
  80181e:	68 ec 21 80 00       	push   $0x8021ec
  801823:	e8 5d ff ff ff       	call   801785 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80182f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801836:	e9 c5 00 00 00       	jmp    801900 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80183b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	01 d0                	add    %edx,%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	85 c0                	test   %eax,%eax
  80184e:	75 08                	jne    801858 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801850:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801853:	e9 a5 00 00 00       	jmp    8018fd <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801858:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80185f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801866:	eb 69                	jmp    8018d1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801868:	a1 20 30 80 00       	mov    0x803020,%eax
  80186d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801873:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801876:	89 d0                	mov    %edx,%eax
  801878:	01 c0                	add    %eax,%eax
  80187a:	01 d0                	add    %edx,%eax
  80187c:	c1 e0 03             	shl    $0x3,%eax
  80187f:	01 c8                	add    %ecx,%eax
  801881:	8a 40 04             	mov    0x4(%eax),%al
  801884:	84 c0                	test   %al,%al
  801886:	75 46                	jne    8018ce <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801888:	a1 20 30 80 00       	mov    0x803020,%eax
  80188d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801893:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	01 c0                	add    %eax,%eax
  80189a:	01 d0                	add    %edx,%eax
  80189c:	c1 e0 03             	shl    $0x3,%eax
  80189f:	01 c8                	add    %ecx,%eax
  8018a1:	8b 00                	mov    (%eax),%eax
  8018a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018ae:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	01 c8                	add    %ecx,%eax
  8018bf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018c1:	39 c2                	cmp    %eax,%edx
  8018c3:	75 09                	jne    8018ce <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018c5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018cc:	eb 15                	jmp    8018e3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018ce:	ff 45 e8             	incl   -0x18(%ebp)
  8018d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8018d6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018df:	39 c2                	cmp    %eax,%edx
  8018e1:	77 85                	ja     801868 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018e7:	75 14                	jne    8018fd <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	68 f8 21 80 00       	push   $0x8021f8
  8018f1:	6a 3a                	push   $0x3a
  8018f3:	68 ec 21 80 00       	push   $0x8021ec
  8018f8:	e8 88 fe ff ff       	call   801785 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018fd:	ff 45 f0             	incl   -0x10(%ebp)
  801900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801903:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801906:	0f 8c 2f ff ff ff    	jl     80183b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80190c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801913:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80191a:	eb 26                	jmp    801942 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80191c:	a1 20 30 80 00       	mov    0x803020,%eax
  801921:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801927:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192a:	89 d0                	mov    %edx,%eax
  80192c:	01 c0                	add    %eax,%eax
  80192e:	01 d0                	add    %edx,%eax
  801930:	c1 e0 03             	shl    $0x3,%eax
  801933:	01 c8                	add    %ecx,%eax
  801935:	8a 40 04             	mov    0x4(%eax),%al
  801938:	3c 01                	cmp    $0x1,%al
  80193a:	75 03                	jne    80193f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80193c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80193f:	ff 45 e0             	incl   -0x20(%ebp)
  801942:	a1 20 30 80 00       	mov    0x803020,%eax
  801947:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80194d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801950:	39 c2                	cmp    %eax,%edx
  801952:	77 c8                	ja     80191c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801957:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80195a:	74 14                	je     801970 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	68 4c 22 80 00       	push   $0x80224c
  801964:	6a 44                	push   $0x44
  801966:	68 ec 21 80 00       	push   $0x8021ec
  80196b:	e8 15 fe ff ff       	call   801785 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801970:	90                   	nop
  801971:	c9                   	leave  
  801972:	c3                   	ret    
  801973:	90                   	nop

00801974 <__udivdi3>:
  801974:	55                   	push   %ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 1c             	sub    $0x1c,%esp
  80197b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80197f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801983:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801987:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198b:	89 ca                	mov    %ecx,%edx
  80198d:	89 f8                	mov    %edi,%eax
  80198f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801993:	85 f6                	test   %esi,%esi
  801995:	75 2d                	jne    8019c4 <__udivdi3+0x50>
  801997:	39 cf                	cmp    %ecx,%edi
  801999:	77 65                	ja     801a00 <__udivdi3+0x8c>
  80199b:	89 fd                	mov    %edi,%ebp
  80199d:	85 ff                	test   %edi,%edi
  80199f:	75 0b                	jne    8019ac <__udivdi3+0x38>
  8019a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a6:	31 d2                	xor    %edx,%edx
  8019a8:	f7 f7                	div    %edi
  8019aa:	89 c5                	mov    %eax,%ebp
  8019ac:	31 d2                	xor    %edx,%edx
  8019ae:	89 c8                	mov    %ecx,%eax
  8019b0:	f7 f5                	div    %ebp
  8019b2:	89 c1                	mov    %eax,%ecx
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	f7 f5                	div    %ebp
  8019b8:	89 cf                	mov    %ecx,%edi
  8019ba:	89 fa                	mov    %edi,%edx
  8019bc:	83 c4 1c             	add    $0x1c,%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5e                   	pop    %esi
  8019c1:	5f                   	pop    %edi
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    
  8019c4:	39 ce                	cmp    %ecx,%esi
  8019c6:	77 28                	ja     8019f0 <__udivdi3+0x7c>
  8019c8:	0f bd fe             	bsr    %esi,%edi
  8019cb:	83 f7 1f             	xor    $0x1f,%edi
  8019ce:	75 40                	jne    801a10 <__udivdi3+0x9c>
  8019d0:	39 ce                	cmp    %ecx,%esi
  8019d2:	72 0a                	jb     8019de <__udivdi3+0x6a>
  8019d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019d8:	0f 87 9e 00 00 00    	ja     801a7c <__udivdi3+0x108>
  8019de:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e3:	89 fa                	mov    %edi,%edx
  8019e5:	83 c4 1c             	add    $0x1c,%esp
  8019e8:	5b                   	pop    %ebx
  8019e9:	5e                   	pop    %esi
  8019ea:	5f                   	pop    %edi
  8019eb:	5d                   	pop    %ebp
  8019ec:	c3                   	ret    
  8019ed:	8d 76 00             	lea    0x0(%esi),%esi
  8019f0:	31 ff                	xor    %edi,%edi
  8019f2:	31 c0                	xor    %eax,%eax
  8019f4:	89 fa                	mov    %edi,%edx
  8019f6:	83 c4 1c             	add    $0x1c,%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5e                   	pop    %esi
  8019fb:	5f                   	pop    %edi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    
  8019fe:	66 90                	xchg   %ax,%ax
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	f7 f7                	div    %edi
  801a04:	31 ff                	xor    %edi,%edi
  801a06:	89 fa                	mov    %edi,%edx
  801a08:	83 c4 1c             	add    $0x1c,%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    
  801a10:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a15:	89 eb                	mov    %ebp,%ebx
  801a17:	29 fb                	sub    %edi,%ebx
  801a19:	89 f9                	mov    %edi,%ecx
  801a1b:	d3 e6                	shl    %cl,%esi
  801a1d:	89 c5                	mov    %eax,%ebp
  801a1f:	88 d9                	mov    %bl,%cl
  801a21:	d3 ed                	shr    %cl,%ebp
  801a23:	89 e9                	mov    %ebp,%ecx
  801a25:	09 f1                	or     %esi,%ecx
  801a27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a2b:	89 f9                	mov    %edi,%ecx
  801a2d:	d3 e0                	shl    %cl,%eax
  801a2f:	89 c5                	mov    %eax,%ebp
  801a31:	89 d6                	mov    %edx,%esi
  801a33:	88 d9                	mov    %bl,%cl
  801a35:	d3 ee                	shr    %cl,%esi
  801a37:	89 f9                	mov    %edi,%ecx
  801a39:	d3 e2                	shl    %cl,%edx
  801a3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 e8                	shr    %cl,%eax
  801a43:	09 c2                	or     %eax,%edx
  801a45:	89 d0                	mov    %edx,%eax
  801a47:	89 f2                	mov    %esi,%edx
  801a49:	f7 74 24 0c          	divl   0xc(%esp)
  801a4d:	89 d6                	mov    %edx,%esi
  801a4f:	89 c3                	mov    %eax,%ebx
  801a51:	f7 e5                	mul    %ebp
  801a53:	39 d6                	cmp    %edx,%esi
  801a55:	72 19                	jb     801a70 <__udivdi3+0xfc>
  801a57:	74 0b                	je     801a64 <__udivdi3+0xf0>
  801a59:	89 d8                	mov    %ebx,%eax
  801a5b:	31 ff                	xor    %edi,%edi
  801a5d:	e9 58 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a62:	66 90                	xchg   %ax,%ax
  801a64:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a68:	89 f9                	mov    %edi,%ecx
  801a6a:	d3 e2                	shl    %cl,%edx
  801a6c:	39 c2                	cmp    %eax,%edx
  801a6e:	73 e9                	jae    801a59 <__udivdi3+0xe5>
  801a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a73:	31 ff                	xor    %edi,%edi
  801a75:	e9 40 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	31 c0                	xor    %eax,%eax
  801a7e:	e9 37 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a83:	90                   	nop

00801a84 <__umoddi3>:
  801a84:	55                   	push   %ebp
  801a85:	57                   	push   %edi
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 1c             	sub    $0x1c,%esp
  801a8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aa3:	89 f3                	mov    %esi,%ebx
  801aa5:	89 fa                	mov    %edi,%edx
  801aa7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aab:	89 34 24             	mov    %esi,(%esp)
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	75 1a                	jne    801acc <__umoddi3+0x48>
  801ab2:	39 f7                	cmp    %esi,%edi
  801ab4:	0f 86 a2 00 00 00    	jbe    801b5c <__umoddi3+0xd8>
  801aba:	89 c8                	mov    %ecx,%eax
  801abc:	89 f2                	mov    %esi,%edx
  801abe:	f7 f7                	div    %edi
  801ac0:	89 d0                	mov    %edx,%eax
  801ac2:	31 d2                	xor    %edx,%edx
  801ac4:	83 c4 1c             	add    $0x1c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
  801acc:	39 f0                	cmp    %esi,%eax
  801ace:	0f 87 ac 00 00 00    	ja     801b80 <__umoddi3+0xfc>
  801ad4:	0f bd e8             	bsr    %eax,%ebp
  801ad7:	83 f5 1f             	xor    $0x1f,%ebp
  801ada:	0f 84 ac 00 00 00    	je     801b8c <__umoddi3+0x108>
  801ae0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ae5:	29 ef                	sub    %ebp,%edi
  801ae7:	89 fe                	mov    %edi,%esi
  801ae9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801aed:	89 e9                	mov    %ebp,%ecx
  801aef:	d3 e0                	shl    %cl,%eax
  801af1:	89 d7                	mov    %edx,%edi
  801af3:	89 f1                	mov    %esi,%ecx
  801af5:	d3 ef                	shr    %cl,%edi
  801af7:	09 c7                	or     %eax,%edi
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 e2                	shl    %cl,%edx
  801afd:	89 14 24             	mov    %edx,(%esp)
  801b00:	89 d8                	mov    %ebx,%eax
  801b02:	d3 e0                	shl    %cl,%eax
  801b04:	89 c2                	mov    %eax,%edx
  801b06:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0a:	d3 e0                	shl    %cl,%eax
  801b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b10:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b14:	89 f1                	mov    %esi,%ecx
  801b16:	d3 e8                	shr    %cl,%eax
  801b18:	09 d0                	or     %edx,%eax
  801b1a:	d3 eb                	shr    %cl,%ebx
  801b1c:	89 da                	mov    %ebx,%edx
  801b1e:	f7 f7                	div    %edi
  801b20:	89 d3                	mov    %edx,%ebx
  801b22:	f7 24 24             	mull   (%esp)
  801b25:	89 c6                	mov    %eax,%esi
  801b27:	89 d1                	mov    %edx,%ecx
  801b29:	39 d3                	cmp    %edx,%ebx
  801b2b:	0f 82 87 00 00 00    	jb     801bb8 <__umoddi3+0x134>
  801b31:	0f 84 91 00 00 00    	je     801bc8 <__umoddi3+0x144>
  801b37:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b3b:	29 f2                	sub    %esi,%edx
  801b3d:	19 cb                	sbb    %ecx,%ebx
  801b3f:	89 d8                	mov    %ebx,%eax
  801b41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b45:	d3 e0                	shl    %cl,%eax
  801b47:	89 e9                	mov    %ebp,%ecx
  801b49:	d3 ea                	shr    %cl,%edx
  801b4b:	09 d0                	or     %edx,%eax
  801b4d:	89 e9                	mov    %ebp,%ecx
  801b4f:	d3 eb                	shr    %cl,%ebx
  801b51:	89 da                	mov    %ebx,%edx
  801b53:	83 c4 1c             	add    $0x1c,%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5f                   	pop    %edi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    
  801b5b:	90                   	nop
  801b5c:	89 fd                	mov    %edi,%ebp
  801b5e:	85 ff                	test   %edi,%edi
  801b60:	75 0b                	jne    801b6d <__umoddi3+0xe9>
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	31 d2                	xor    %edx,%edx
  801b69:	f7 f7                	div    %edi
  801b6b:	89 c5                	mov    %eax,%ebp
  801b6d:	89 f0                	mov    %esi,%eax
  801b6f:	31 d2                	xor    %edx,%edx
  801b71:	f7 f5                	div    %ebp
  801b73:	89 c8                	mov    %ecx,%eax
  801b75:	f7 f5                	div    %ebp
  801b77:	89 d0                	mov    %edx,%eax
  801b79:	e9 44 ff ff ff       	jmp    801ac2 <__umoddi3+0x3e>
  801b7e:	66 90                	xchg   %ax,%ax
  801b80:	89 c8                	mov    %ecx,%eax
  801b82:	89 f2                	mov    %esi,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	3b 04 24             	cmp    (%esp),%eax
  801b8f:	72 06                	jb     801b97 <__umoddi3+0x113>
  801b91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b95:	77 0f                	ja     801ba6 <__umoddi3+0x122>
  801b97:	89 f2                	mov    %esi,%edx
  801b99:	29 f9                	sub    %edi,%ecx
  801b9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b9f:	89 14 24             	mov    %edx,(%esp)
  801ba2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801baa:	8b 14 24             	mov    (%esp),%edx
  801bad:	83 c4 1c             	add    $0x1c,%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5e                   	pop    %esi
  801bb2:	5f                   	pop    %edi
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    
  801bb5:	8d 76 00             	lea    0x0(%esi),%esi
  801bb8:	2b 04 24             	sub    (%esp),%eax
  801bbb:	19 fa                	sbb    %edi,%edx
  801bbd:	89 d1                	mov    %edx,%ecx
  801bbf:	89 c6                	mov    %eax,%esi
  801bc1:	e9 71 ff ff ff       	jmp    801b37 <__umoddi3+0xb3>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bcc:	72 ea                	jb     801bb8 <__umoddi3+0x134>
  801bce:	89 d9                	mov    %ebx,%ecx
  801bd0:	e9 62 ff ff ff       	jmp    801b37 <__umoddi3+0xb3>
