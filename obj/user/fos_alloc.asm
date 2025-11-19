
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 3a 13 00 00       	call   80138a <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 20 29 80 00       	push   $0x802920
  800061:	e8 d4 03 00 00       	call   80043a <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 33 29 80 00       	push   $0x802933
  8000be:	e8 77 03 00 00       	call   80043a <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 dc 12 00 00       	call   8013b8 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 a0 12 00 00       	call   80138a <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 33 29 80 00       	push   $0x802933
  800114:	e8 21 03 00 00       	call   80043a <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 86 12 00 00       	call   8013b8 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800141:	e8 06 16 00 00       	call   80174c <sys_getenvindex>
  800146:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 02             	shl    $0x2,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c1 e0 03             	shl    $0x3,%eax
  800156:	01 d0                	add    %edx,%eax
  800158:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80015f:	01 d0                	add    %edx,%eax
  800161:	c1 e0 02             	shl    $0x2,%eax
  800164:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800169:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016e:	a1 20 40 80 00       	mov    0x804020,%eax
  800173:	8a 40 20             	mov    0x20(%eax),%al
  800176:	84 c0                	test   %al,%al
  800178:	74 0d                	je     800187 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80017a:	a1 20 40 80 00       	mov    0x804020,%eax
  80017f:	83 c0 20             	add    $0x20,%eax
  800182:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018b:	7e 0a                	jle    800197 <libmain+0x5f>
		binaryname = argv[0];
  80018d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800190:	8b 00                	mov    (%eax),%eax
  800192:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 0c             	pushl  0xc(%ebp)
  80019d:	ff 75 08             	pushl  0x8(%ebp)
  8001a0:	e8 93 fe ff ff       	call   800038 <_main>
  8001a5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001ad:	85 c0                	test   %eax,%eax
  8001af:	0f 84 01 01 00 00    	je     8002b6 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001bb:	bb 38 2a 80 00       	mov    $0x802a38,%ebx
  8001c0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001cd:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d5:	b0 00                	mov    $0x0,%al
  8001d7:	89 d7                	mov    %edx,%edi
  8001d9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	50                   	push   %eax
  8001e9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	e8 8d 17 00 00       	call   801982 <sys_utilities>
  8001f5:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f8:	e8 d6 12 00 00       	call   8014d3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 58 29 80 00       	push   $0x802958
  800205:	e8 be 01 00 00       	call   8003c8 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80020d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800210:	85 c0                	test   %eax,%eax
  800212:	74 18                	je     80022c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800214:	e8 87 17 00 00       	call   8019a0 <sys_get_optimal_num_faults>
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	50                   	push   %eax
  80021d:	68 80 29 80 00       	push   $0x802980
  800222:	e8 a1 01 00 00       	call   8003c8 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	eb 59                	jmp    800285 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80022c:	a1 20 40 80 00       	mov    0x804020,%eax
  800231:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800237:	a1 20 40 80 00       	mov    0x804020,%eax
  80023c:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 a4 29 80 00       	push   $0x8029a4
  80024c:	e8 77 01 00 00       	call   8003c8 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800254:	a1 20 40 80 00       	mov    0x804020,%eax
  800259:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80025f:	a1 20 40 80 00       	mov    0x804020,%eax
  800264:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80026a:	a1 20 40 80 00       	mov    0x804020,%eax
  80026f:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800275:	51                   	push   %ecx
  800276:	52                   	push   %edx
  800277:	50                   	push   %eax
  800278:	68 cc 29 80 00       	push   $0x8029cc
  80027d:	e8 46 01 00 00       	call   8003c8 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800285:	a1 20 40 80 00       	mov    0x804020,%eax
  80028a:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	50                   	push   %eax
  800294:	68 24 2a 80 00       	push   $0x802a24
  800299:	e8 2a 01 00 00       	call   8003c8 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 58 29 80 00       	push   $0x802958
  8002a9:	e8 1a 01 00 00       	call   8003c8 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b1:	e8 37 12 00 00       	call   8014ed <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002b6:	e8 1f 00 00 00       	call   8002da <exit>
}
  8002bb:	90                   	nop
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	e8 44 14 00 00       	call   801718 <sys_destroy_env>
  8002d4:	83 c4 10             	add    $0x10,%esp
}
  8002d7:	90                   	nop
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <exit>:

void
exit(void)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e0:	e8 99 14 00 00       	call   80177e <sys_exit_env>
}
  8002e5:	90                   	nop
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	53                   	push   %ebx
  8002ec:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8002f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fa:	89 0a                	mov    %ecx,(%edx)
  8002fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ff:	88 d1                	mov    %dl,%cl
  800301:	8b 55 0c             	mov    0xc(%ebp),%edx
  800304:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	8b 00                	mov    (%eax),%eax
  80030d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800312:	75 30                	jne    800344 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800314:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  80031a:	a0 44 40 80 00       	mov    0x804044,%al
  80031f:	0f b6 c0             	movzbl %al,%eax
  800322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800325:	8b 09                	mov    (%ecx),%ecx
  800327:	89 cb                	mov    %ecx,%ebx
  800329:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032c:	83 c1 08             	add    $0x8,%ecx
  80032f:	52                   	push   %edx
  800330:	50                   	push   %eax
  800331:	53                   	push   %ebx
  800332:	51                   	push   %ecx
  800333:	e8 57 11 00 00       	call   80148f <sys_cputs>
  800338:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80033b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	8b 40 04             	mov    0x4(%eax),%eax
  80034a:	8d 50 01             	lea    0x1(%eax),%edx
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800350:	89 50 04             	mov    %edx,0x4(%eax)
}
  800353:	90                   	nop
  800354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800362:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800369:	00 00 00 
	b.cnt = 0;
  80036c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800373:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800382:	50                   	push   %eax
  800383:	68 e8 02 80 00       	push   $0x8002e8
  800388:	e8 5a 02 00 00       	call   8005e7 <vprintfmt>
  80038d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800390:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800396:	a0 44 40 80 00       	mov    0x804044,%al
  80039b:	0f b6 c0             	movzbl %al,%eax
  80039e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003a4:	52                   	push   %edx
  8003a5:	50                   	push   %eax
  8003a6:	51                   	push   %ecx
  8003a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ad:	83 c0 08             	add    $0x8,%eax
  8003b0:	50                   	push   %eax
  8003b1:	e8 d9 10 00 00       	call   80148f <sys_cputs>
  8003b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003b9:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  8003c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

008003c8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003ce:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8003d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003db:	8b 45 08             	mov    0x8(%ebp),%eax
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e4:	50                   	push   %eax
  8003e5:	e8 6f ff ff ff       	call   800359 <vcprintf>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003fb:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	c1 e0 08             	shl    $0x8,%eax
  800408:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  80040d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800410:	83 c0 04             	add    $0x4,%eax
  800413:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800416:	8b 45 0c             	mov    0xc(%ebp),%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	ff 75 f4             	pushl  -0xc(%ebp)
  80041f:	50                   	push   %eax
  800420:	e8 34 ff ff ff       	call   800359 <vcprintf>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80042b:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  800432:	07 00 00 

	return cnt;
  800435:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800440:	e8 8e 10 00 00       	call   8014d3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800445:	8d 45 0c             	lea    0xc(%ebp),%eax
  800448:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	ff 75 f4             	pushl  -0xc(%ebp)
  800454:	50                   	push   %eax
  800455:	e8 ff fe ff ff       	call   800359 <vcprintf>
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800460:	e8 88 10 00 00       	call   8014ed <sys_unlock_cons>
	return cnt;
  800465:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	53                   	push   %ebx
  80046e:	83 ec 14             	sub    $0x14,%esp
  800471:	8b 45 10             	mov    0x10(%ebp),%eax
  800474:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80047d:	8b 45 18             	mov    0x18(%ebp),%eax
  800480:	ba 00 00 00 00       	mov    $0x0,%edx
  800485:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800488:	77 55                	ja     8004df <printnum+0x75>
  80048a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80048d:	72 05                	jb     800494 <printnum+0x2a>
  80048f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800492:	77 4b                	ja     8004df <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800494:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800497:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80049a:	8b 45 18             	mov    0x18(%ebp),%eax
  80049d:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a2:	52                   	push   %edx
  8004a3:	50                   	push   %eax
  8004a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8004aa:	e8 f5 21 00 00       	call   8026a4 <__udivdi3>
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	ff 75 20             	pushl  0x20(%ebp)
  8004b8:	53                   	push   %ebx
  8004b9:	ff 75 18             	pushl  0x18(%ebp)
  8004bc:	52                   	push   %edx
  8004bd:	50                   	push   %eax
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	e8 a1 ff ff ff       	call   80046a <printnum>
  8004c9:	83 c4 20             	add    $0x20,%esp
  8004cc:	eb 1a                	jmp    8004e8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 20             	pushl  0x20(%ebp)
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	ff d0                	call   *%eax
  8004dc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004df:	ff 4d 1c             	decl   0x1c(%ebp)
  8004e2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004e6:	7f e6                	jg     8004ce <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004f6:	53                   	push   %ebx
  8004f7:	51                   	push   %ecx
  8004f8:	52                   	push   %edx
  8004f9:	50                   	push   %eax
  8004fa:	e8 b5 22 00 00       	call   8027b4 <__umoddi3>
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	05 b4 2c 80 00       	add    $0x802cb4,%eax
  800507:	8a 00                	mov    (%eax),%al
  800509:	0f be c0             	movsbl %al,%eax
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	50                   	push   %eax
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	ff d0                	call   *%eax
  800518:	83 c4 10             	add    $0x10,%esp
}
  80051b:	90                   	nop
  80051c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800524:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800528:	7e 1c                	jle    800546 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	8d 50 08             	lea    0x8(%eax),%edx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	89 10                	mov    %edx,(%eax)
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	83 e8 08             	sub    $0x8,%eax
  80053f:	8b 50 04             	mov    0x4(%eax),%edx
  800542:	8b 00                	mov    (%eax),%eax
  800544:	eb 40                	jmp    800586 <getuint+0x65>
	else if (lflag)
  800546:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80054a:	74 1e                	je     80056a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	8d 50 04             	lea    0x4(%eax),%edx
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	89 10                	mov    %edx,(%eax)
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	83 e8 04             	sub    $0x4,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	ba 00 00 00 00       	mov    $0x0,%edx
  800568:	eb 1c                	jmp    800586 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	8d 50 04             	lea    0x4(%eax),%edx
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	89 10                	mov    %edx,(%eax)
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	83 e8 04             	sub    $0x4,%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800586:	5d                   	pop    %ebp
  800587:	c3                   	ret    

00800588 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80058b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80058f:	7e 1c                	jle    8005ad <getint+0x25>
		return va_arg(*ap, long long);
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	8d 50 08             	lea    0x8(%eax),%edx
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	89 10                	mov    %edx,(%eax)
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	83 e8 08             	sub    $0x8,%eax
  8005a6:	8b 50 04             	mov    0x4(%eax),%edx
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	eb 38                	jmp    8005e5 <getint+0x5d>
	else if (lflag)
  8005ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b1:	74 1a                	je     8005cd <getint+0x45>
		return va_arg(*ap, long);
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	8d 50 04             	lea    0x4(%eax),%edx
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	89 10                	mov    %edx,(%eax)
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	83 e8 04             	sub    $0x4,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	99                   	cltd   
  8005cb:	eb 18                	jmp    8005e5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	89 10                	mov    %edx,(%eax)
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	99                   	cltd   
}
  8005e5:	5d                   	pop    %ebp
  8005e6:	c3                   	ret    

008005e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	56                   	push   %esi
  8005eb:	53                   	push   %ebx
  8005ec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ef:	eb 17                	jmp    800608 <vprintfmt+0x21>
			if (ch == '\0')
  8005f1:	85 db                	test   %ebx,%ebx
  8005f3:	0f 84 c1 03 00 00    	je     8009ba <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	53                   	push   %ebx
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800608:	8b 45 10             	mov    0x10(%ebp),%eax
  80060b:	8d 50 01             	lea    0x1(%eax),%edx
  80060e:	89 55 10             	mov    %edx,0x10(%ebp)
  800611:	8a 00                	mov    (%eax),%al
  800613:	0f b6 d8             	movzbl %al,%ebx
  800616:	83 fb 25             	cmp    $0x25,%ebx
  800619:	75 d6                	jne    8005f1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80061b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80061f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800626:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80062d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800634:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063b:	8b 45 10             	mov    0x10(%ebp),%eax
  80063e:	8d 50 01             	lea    0x1(%eax),%edx
  800641:	89 55 10             	mov    %edx,0x10(%ebp)
  800644:	8a 00                	mov    (%eax),%al
  800646:	0f b6 d8             	movzbl %al,%ebx
  800649:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80064c:	83 f8 5b             	cmp    $0x5b,%eax
  80064f:	0f 87 3d 03 00 00    	ja     800992 <vprintfmt+0x3ab>
  800655:	8b 04 85 d8 2c 80 00 	mov    0x802cd8(,%eax,4),%eax
  80065c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80065e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800662:	eb d7                	jmp    80063b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800664:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800668:	eb d1                	jmp    80063b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80066a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800671:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800674:	89 d0                	mov    %edx,%eax
  800676:	c1 e0 02             	shl    $0x2,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	01 c0                	add    %eax,%eax
  80067d:	01 d8                	add    %ebx,%eax
  80067f:	83 e8 30             	sub    $0x30,%eax
  800682:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800685:	8b 45 10             	mov    0x10(%ebp),%eax
  800688:	8a 00                	mov    (%eax),%al
  80068a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80068d:	83 fb 2f             	cmp    $0x2f,%ebx
  800690:	7e 3e                	jle    8006d0 <vprintfmt+0xe9>
  800692:	83 fb 39             	cmp    $0x39,%ebx
  800695:	7f 39                	jg     8006d0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800697:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80069a:	eb d5                	jmp    800671 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	83 c0 04             	add    $0x4,%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	83 e8 04             	sub    $0x4,%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006b0:	eb 1f                	jmp    8006d1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b6:	79 83                	jns    80063b <vprintfmt+0x54>
				width = 0;
  8006b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006bf:	e9 77 ff ff ff       	jmp    80063b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006cb:	e9 6b ff ff ff       	jmp    80063b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006d0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d5:	0f 89 60 ff ff ff    	jns    80063b <vprintfmt+0x54>
				width = precision, precision = -1;
  8006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006e8:	e9 4e ff ff ff       	jmp    80063b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ed:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006f0:	e9 46 ff ff ff       	jmp    80063b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	83 c0 04             	add    $0x4,%eax
  8006fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	83 e8 04             	sub    $0x4,%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	50                   	push   %eax
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	ff d0                	call   *%eax
  800712:	83 c4 10             	add    $0x10,%esp
			break;
  800715:	e9 9b 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	83 c0 04             	add    $0x4,%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	83 e8 04             	sub    $0x4,%eax
  800729:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80072b:	85 db                	test   %ebx,%ebx
  80072d:	79 02                	jns    800731 <vprintfmt+0x14a>
				err = -err;
  80072f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800731:	83 fb 64             	cmp    $0x64,%ebx
  800734:	7f 0b                	jg     800741 <vprintfmt+0x15a>
  800736:	8b 34 9d 20 2b 80 00 	mov    0x802b20(,%ebx,4),%esi
  80073d:	85 f6                	test   %esi,%esi
  80073f:	75 19                	jne    80075a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800741:	53                   	push   %ebx
  800742:	68 c5 2c 80 00       	push   $0x802cc5
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 70 02 00 00       	call   8009c2 <printfmt>
  800752:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800755:	e9 5b 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80075a:	56                   	push   %esi
  80075b:	68 ce 2c 80 00       	push   $0x802cce
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	ff 75 08             	pushl  0x8(%ebp)
  800766:	e8 57 02 00 00       	call   8009c2 <printfmt>
  80076b:	83 c4 10             	add    $0x10,%esp
			break;
  80076e:	e9 42 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	83 c0 04             	add    $0x4,%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	83 e8 04             	sub    $0x4,%eax
  800782:	8b 30                	mov    (%eax),%esi
  800784:	85 f6                	test   %esi,%esi
  800786:	75 05                	jne    80078d <vprintfmt+0x1a6>
				p = "(null)";
  800788:	be d1 2c 80 00       	mov    $0x802cd1,%esi
			if (width > 0 && padc != '-')
  80078d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800791:	7e 6d                	jle    800800 <vprintfmt+0x219>
  800793:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800797:	74 67                	je     800800 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	50                   	push   %eax
  8007a0:	56                   	push   %esi
  8007a1:	e8 1e 03 00 00       	call   800ac4 <strnlen>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007ac:	eb 16                	jmp    8007c4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c8:	7f e4                	jg     8007ae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ca:	eb 34                	jmp    800800 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d0:	74 1c                	je     8007ee <vprintfmt+0x207>
  8007d2:	83 fb 1f             	cmp    $0x1f,%ebx
  8007d5:	7e 05                	jle    8007dc <vprintfmt+0x1f5>
  8007d7:	83 fb 7e             	cmp    $0x7e,%ebx
  8007da:	7e 12                	jle    8007ee <vprintfmt+0x207>
					putch('?', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	6a 3f                	push   $0x3f
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	ff d0                	call   *%eax
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	eb 0f                	jmp    8007fd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	53                   	push   %ebx
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800800:	89 f0                	mov    %esi,%eax
  800802:	8d 70 01             	lea    0x1(%eax),%esi
  800805:	8a 00                	mov    (%eax),%al
  800807:	0f be d8             	movsbl %al,%ebx
  80080a:	85 db                	test   %ebx,%ebx
  80080c:	74 24                	je     800832 <vprintfmt+0x24b>
  80080e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800812:	78 b8                	js     8007cc <vprintfmt+0x1e5>
  800814:	ff 4d e0             	decl   -0x20(%ebp)
  800817:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80081b:	79 af                	jns    8007cc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80081d:	eb 13                	jmp    800832 <vprintfmt+0x24b>
				putch(' ', putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	6a 20                	push   $0x20
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	ff d0                	call   *%eax
  80082c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80082f:	ff 4d e4             	decl   -0x1c(%ebp)
  800832:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800836:	7f e7                	jg     80081f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800838:	e9 78 01 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 e8             	pushl  -0x18(%ebp)
  800843:	8d 45 14             	lea    0x14(%ebp),%eax
  800846:	50                   	push   %eax
  800847:	e8 3c fd ff ff       	call   800588 <getint>
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800852:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085b:	85 d2                	test   %edx,%edx
  80085d:	79 23                	jns    800882 <vprintfmt+0x29b>
				putch('-', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	6a 2d                	push   $0x2d
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800875:	f7 d8                	neg    %eax
  800877:	83 d2 00             	adc    $0x0,%edx
  80087a:	f7 da                	neg    %edx
  80087c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800882:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800889:	e9 bc 00 00 00       	jmp    80094a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	ff 75 e8             	pushl  -0x18(%ebp)
  800894:	8d 45 14             	lea    0x14(%ebp),%eax
  800897:	50                   	push   %eax
  800898:	e8 84 fc ff ff       	call   800521 <getuint>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ad:	e9 98 00 00 00       	jmp    80094a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	6a 58                	push   $0x58
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	6a 58                	push   $0x58
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	6a 58                	push   $0x58
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 ce 00 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	6a 30                	push   $0x30
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	6a 78                	push   $0x78
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 14             	mov    %eax,0x14(%ebp)
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800918:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800922:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800929:	eb 1f                	jmp    80094a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 e8             	pushl  -0x18(%ebp)
  800931:	8d 45 14             	lea    0x14(%ebp),%eax
  800934:	50                   	push   %eax
  800935:	e8 e7 fb ff ff       	call   800521 <getuint>
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800940:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800943:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80094a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80094e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800951:	83 ec 04             	sub    $0x4,%esp
  800954:	52                   	push   %edx
  800955:	ff 75 e4             	pushl  -0x1c(%ebp)
  800958:	50                   	push   %eax
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	ff 75 f0             	pushl  -0x10(%ebp)
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	ff 75 08             	pushl  0x8(%ebp)
  800965:	e8 00 fb ff ff       	call   80046a <printnum>
  80096a:	83 c4 20             	add    $0x20,%esp
			break;
  80096d:	eb 46                	jmp    8009b5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
			break;
  80097e:	eb 35                	jmp    8009b5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800980:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800987:	eb 2c                	jmp    8009b5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800989:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800990:	eb 23                	jmp    8009b5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	6a 25                	push   $0x25
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	ff d0                	call   *%eax
  80099f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a2:	ff 4d 10             	decl   0x10(%ebp)
  8009a5:	eb 03                	jmp    8009aa <vprintfmt+0x3c3>
  8009a7:	ff 4d 10             	decl   0x10(%ebp)
  8009aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ad:	48                   	dec    %eax
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	3c 25                	cmp    $0x25,%al
  8009b2:	75 f3                	jne    8009a7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009b4:	90                   	nop
		}
	}
  8009b5:	e9 35 fc ff ff       	jmp    8005ef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009ba:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009be:	5b                   	pop    %ebx
  8009bf:	5e                   	pop    %esi
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009cb:	83 c0 04             	add    $0x4,%eax
  8009ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d7:	50                   	push   %eax
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 04 fc ff ff       	call   8005e7 <vprintfmt>
  8009e3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009e6:	90                   	nop
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	8b 40 08             	mov    0x8(%eax),%eax
  8009f2:	8d 50 01             	lea    0x1(%eax),%edx
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fe:	8b 10                	mov    (%eax),%edx
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	8b 40 04             	mov    0x4(%eax),%eax
  800a06:	39 c2                	cmp    %eax,%edx
  800a08:	73 12                	jae    800a1c <sprintputch+0x33>
		*b->buf++ = ch;
  800a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	89 0a                	mov    %ecx,(%edx)
  800a17:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1a:	88 10                	mov    %dl,(%eax)
}
  800a1c:	90                   	nop
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	01 d0                	add    %edx,%eax
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a44:	74 06                	je     800a4c <vsnprintf+0x2d>
  800a46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a4a:	7f 07                	jg     800a53 <vsnprintf+0x34>
		return -E_INVAL;
  800a4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800a51:	eb 20                	jmp    800a73 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a53:	ff 75 14             	pushl  0x14(%ebp)
  800a56:	ff 75 10             	pushl  0x10(%ebp)
  800a59:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a5c:	50                   	push   %eax
  800a5d:	68 e9 09 80 00       	push   $0x8009e9
  800a62:	e8 80 fb ff ff       	call   8005e7 <vprintfmt>
  800a67:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800a7e:	83 c0 04             	add    $0x4,%eax
  800a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a84:	8b 45 10             	mov    0x10(%ebp),%eax
  800a87:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 89 ff ff ff       	call   800a1f <vsnprintf>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aae:	eb 06                	jmp    800ab6 <strlen+0x15>
		n++;
  800ab0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab3:	ff 45 08             	incl   0x8(%ebp)
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8a 00                	mov    (%eax),%al
  800abb:	84 c0                	test   %al,%al
  800abd:	75 f1                	jne    800ab0 <strlen+0xf>
		n++;
	return n;
  800abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ad1:	eb 09                	jmp    800adc <strnlen+0x18>
		n++;
  800ad3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad6:	ff 45 08             	incl   0x8(%ebp)
  800ad9:	ff 4d 0c             	decl   0xc(%ebp)
  800adc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae0:	74 09                	je     800aeb <strnlen+0x27>
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	84 c0                	test   %al,%al
  800ae9:	75 e8                	jne    800ad3 <strnlen+0xf>
		n++;
	return n;
  800aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800afc:	90                   	nop
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8d 50 01             	lea    0x1(%eax),%edx
  800b03:	89 55 08             	mov    %edx,0x8(%ebp)
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b0f:	8a 12                	mov    (%edx),%dl
  800b11:	88 10                	mov    %dl,(%eax)
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	84 c0                	test   %al,%al
  800b17:	75 e4                	jne    800afd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b31:	eb 1f                	jmp    800b52 <strncpy+0x34>
		*dst++ = *src;
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8d 50 01             	lea    0x1(%eax),%edx
  800b39:	89 55 08             	mov    %edx,0x8(%ebp)
  800b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3f:	8a 12                	mov    (%edx),%dl
  800b41:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	84 c0                	test   %al,%al
  800b4a:	74 03                	je     800b4f <strncpy+0x31>
			src++;
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4f:	ff 45 fc             	incl   -0x4(%ebp)
  800b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b55:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b58:	72 d9                	jb     800b33 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b6f:	74 30                	je     800ba1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b71:	eb 16                	jmp    800b89 <strlcpy+0x2a>
			*dst++ = *src++;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8d 50 01             	lea    0x1(%eax),%edx
  800b79:	89 55 08             	mov    %edx,0x8(%ebp)
  800b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b82:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b85:	8a 12                	mov    (%edx),%dl
  800b87:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b89:	ff 4d 10             	decl   0x10(%ebp)
  800b8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b90:	74 09                	je     800b9b <strlcpy+0x3c>
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	8a 00                	mov    (%eax),%al
  800b97:	84 c0                	test   %al,%al
  800b99:	75 d8                	jne    800b73 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba7:	29 c2                	sub    %eax,%edx
  800ba9:	89 d0                	mov    %edx,%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bb0:	eb 06                	jmp    800bb8 <strcmp+0xb>
		p++, q++;
  800bb2:	ff 45 08             	incl   0x8(%ebp)
  800bb5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	84 c0                	test   %al,%al
  800bbf:	74 0e                	je     800bcf <strcmp+0x22>
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8a 10                	mov    (%eax),%dl
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	8a 00                	mov    (%eax),%al
  800bcb:	38 c2                	cmp    %al,%dl
  800bcd:	74 e3                	je     800bb2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	0f b6 d0             	movzbl %al,%edx
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	0f b6 c0             	movzbl %al,%eax
  800bdf:	29 c2                	sub    %eax,%edx
  800be1:	89 d0                	mov    %edx,%eax
}
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800be8:	eb 09                	jmp    800bf3 <strncmp+0xe>
		n--, p++, q++;
  800bea:	ff 4d 10             	decl   0x10(%ebp)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bf3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf7:	74 17                	je     800c10 <strncmp+0x2b>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	74 0e                	je     800c10 <strncmp+0x2b>
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 10                	mov    (%eax),%dl
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	38 c2                	cmp    %al,%dl
  800c0e:	74 da                	je     800bea <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c14:	75 07                	jne    800c1d <strncmp+0x38>
		return 0;
  800c16:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1b:	eb 14                	jmp    800c31 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8a 00                	mov    (%eax),%al
  800c22:	0f b6 d0             	movzbl %al,%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	0f b6 c0             	movzbl %al,%eax
  800c2d:	29 c2                	sub    %eax,%edx
  800c2f:	89 d0                	mov    %edx,%eax
}
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 04             	sub    $0x4,%esp
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c3f:	eb 12                	jmp    800c53 <strchr+0x20>
		if (*s == c)
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c49:	75 05                	jne    800c50 <strchr+0x1d>
			return (char *) s;
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	eb 11                	jmp    800c61 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c50:	ff 45 08             	incl   0x8(%ebp)
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	84 c0                	test   %al,%al
  800c5a:	75 e5                	jne    800c41 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 04             	sub    $0x4,%esp
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c6f:	eb 0d                	jmp    800c7e <strfind+0x1b>
		if (*s == c)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c79:	74 0e                	je     800c89 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c7b:	ff 45 08             	incl   0x8(%ebp)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	84 c0                	test   %al,%al
  800c85:	75 ea                	jne    800c71 <strfind+0xe>
  800c87:	eb 01                	jmp    800c8a <strfind+0x27>
		if (*s == c)
			break;
  800c89:	90                   	nop
	return (char *) s;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c9b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c9f:	76 63                	jbe    800d04 <memset+0x75>
		uint64 data_block = c;
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	99                   	cltd   
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800cb5:	c1 e0 08             	shl    $0x8,%eax
  800cb8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cbb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800cc8:	c1 e0 10             	shl    $0x10,%eax
  800ccb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cce:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd7:	89 c2                	mov    %eax,%edx
  800cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cde:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ce1:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ce4:	eb 18                	jmp    800cfe <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ce6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ce9:	8d 41 08             	lea    0x8(%ecx),%eax
  800cec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cf5:	89 01                	mov    %eax,(%ecx)
  800cf7:	89 51 04             	mov    %edx,0x4(%ecx)
  800cfa:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800cfe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d02:	77 e2                	ja     800ce6 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d08:	74 23                	je     800d2d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d10:	eb 0e                	jmp    800d20 <memset+0x91>
			*p8++ = (uint8)c;
  800d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d15:	8d 50 01             	lea    0x1(%eax),%edx
  800d18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d26:	89 55 10             	mov    %edx,0x10(%ebp)
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	75 e5                	jne    800d12 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d44:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d48:	76 24                	jbe    800d6e <memcpy+0x3c>
		while(n >= 8){
  800d4a:	eb 1c                	jmp    800d68 <memcpy+0x36>
			*d64 = *s64;
  800d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4f:	8b 50 04             	mov    0x4(%eax),%edx
  800d52:	8b 00                	mov    (%eax),%eax
  800d54:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d57:	89 01                	mov    %eax,(%ecx)
  800d59:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d5c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d60:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d64:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d68:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d6c:	77 de                	ja     800d4c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 31                	je     800da5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d80:	eb 16                	jmp    800d98 <memcpy+0x66>
			*d8++ = *s8++;
  800d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d91:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d94:	8a 12                	mov    (%edx),%dl
  800d96:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d98:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	75 dd                	jne    800d82 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dc2:	73 50                	jae    800e14 <memmove+0x6a>
  800dc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dca:	01 d0                	add    %edx,%eax
  800dcc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dcf:	76 43                	jbe    800e14 <memmove+0x6a>
		s += n;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dda:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ddd:	eb 10                	jmp    800def <memmove+0x45>
			*--d = *--s;
  800ddf:	ff 4d f8             	decl   -0x8(%ebp)
  800de2:	ff 4d fc             	decl   -0x4(%ebp)
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de8:	8a 10                	mov    (%eax),%dl
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 e3                	jne    800ddf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dfc:	eb 23                	jmp    800e21 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e01:	8d 50 01             	lea    0x1(%eax),%edx
  800e04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e10:	8a 12                	mov    (%edx),%dl
  800e12:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	75 dd                	jne    800dfe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e38:	eb 2a                	jmp    800e64 <memcmp+0x3e>
		if (*s1 != *s2)
  800e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3d:	8a 10                	mov    (%eax),%dl
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	38 c2                	cmp    %al,%dl
  800e46:	74 16                	je     800e5e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	0f b6 d0             	movzbl %al,%edx
  800e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	0f b6 c0             	movzbl %al,%eax
  800e58:	29 c2                	sub    %eax,%edx
  800e5a:	89 d0                	mov    %edx,%eax
  800e5c:	eb 18                	jmp    800e76 <memcmp+0x50>
		s1++, s2++;
  800e5e:	ff 45 fc             	incl   -0x4(%ebp)
  800e61:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e64:	8b 45 10             	mov    0x10(%ebp),%eax
  800e67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	75 c9                	jne    800e3a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 45 10             	mov    0x10(%ebp),%eax
  800e84:	01 d0                	add    %edx,%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e89:	eb 15                	jmp    800ea0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	0f b6 d0             	movzbl %al,%edx
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	39 c2                	cmp    %eax,%edx
  800e9b:	74 0d                	je     800eaa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e9d:	ff 45 08             	incl   0x8(%ebp)
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ea6:	72 e3                	jb     800e8b <memfind+0x13>
  800ea8:	eb 01                	jmp    800eab <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eaa:	90                   	nop
	return (void *) s;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    

00800eb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ebd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec4:	eb 03                	jmp    800ec9 <strtol+0x19>
		s++;
  800ec6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	3c 20                	cmp    $0x20,%al
  800ed0:	74 f4                	je     800ec6 <strtol+0x16>
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3c 09                	cmp    $0x9,%al
  800ed9:	74 eb                	je     800ec6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3c 2b                	cmp    $0x2b,%al
  800ee2:	75 05                	jne    800ee9 <strtol+0x39>
		s++;
  800ee4:	ff 45 08             	incl   0x8(%ebp)
  800ee7:	eb 13                	jmp    800efc <strtol+0x4c>
	else if (*s == '-')
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 2d                	cmp    $0x2d,%al
  800ef0:	75 0a                	jne    800efc <strtol+0x4c>
		s++, neg = 1;
  800ef2:	ff 45 08             	incl   0x8(%ebp)
  800ef5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	74 06                	je     800f08 <strtol+0x58>
  800f02:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f06:	75 20                	jne    800f28 <strtol+0x78>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 30                	cmp    $0x30,%al
  800f0f:	75 17                	jne    800f28 <strtol+0x78>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	40                   	inc    %eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 78                	cmp    $0x78,%al
  800f19:	75 0d                	jne    800f28 <strtol+0x78>
		s += 2, base = 16;
  800f1b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f26:	eb 28                	jmp    800f50 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2c:	75 15                	jne    800f43 <strtol+0x93>
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 30                	cmp    $0x30,%al
  800f35:	75 0c                	jne    800f43 <strtol+0x93>
		s++, base = 8;
  800f37:	ff 45 08             	incl   0x8(%ebp)
  800f3a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f41:	eb 0d                	jmp    800f50 <strtol+0xa0>
	else if (base == 0)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	75 07                	jne    800f50 <strtol+0xa0>
		base = 10;
  800f49:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 2f                	cmp    $0x2f,%al
  800f57:	7e 19                	jle    800f72 <strtol+0xc2>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 39                	cmp    $0x39,%al
  800f60:	7f 10                	jg     800f72 <strtol+0xc2>
			dig = *s - '0';
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	0f be c0             	movsbl %al,%eax
  800f6a:	83 e8 30             	sub    $0x30,%eax
  800f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f70:	eb 42                	jmp    800fb4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3c 60                	cmp    $0x60,%al
  800f79:	7e 19                	jle    800f94 <strtol+0xe4>
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	3c 7a                	cmp    $0x7a,%al
  800f82:	7f 10                	jg     800f94 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f be c0             	movsbl %al,%eax
  800f8c:	83 e8 57             	sub    $0x57,%eax
  800f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f92:	eb 20                	jmp    800fb4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	3c 40                	cmp    $0x40,%al
  800f9b:	7e 39                	jle    800fd6 <strtol+0x126>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 5a                	cmp    $0x5a,%al
  800fa4:	7f 30                	jg     800fd6 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f be c0             	movsbl %al,%eax
  800fae:	83 e8 37             	sub    $0x37,%eax
  800fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fba:	7d 19                	jge    800fd5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fbc:	ff 45 08             	incl   0x8(%ebp)
  800fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fd0:	e9 7b ff ff ff       	jmp    800f50 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fd5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fda:	74 08                	je     800fe4 <strtol+0x134>
		*endptr = (char *) s;
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fe4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fe8:	74 07                	je     800ff1 <strtol+0x141>
  800fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fed:	f7 d8                	neg    %eax
  800fef:	eb 03                	jmp    800ff4 <strtol+0x144>
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <ltostr>:

void
ltostr(long value, char *str)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801003:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80100a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100e:	79 13                	jns    801023 <ltostr+0x2d>
	{
		neg = 1;
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80101d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801020:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80102b:	99                   	cltd   
  80102c:	f7 f9                	idiv   %ecx
  80102e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	8d 50 01             	lea    0x1(%eax),%edx
  801037:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103a:	89 c2                	mov    %eax,%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 d0                	add    %edx,%eax
  801041:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801044:	83 c2 30             	add    $0x30,%edx
  801047:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801049:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801051:	f7 e9                	imul   %ecx
  801053:	c1 fa 02             	sar    $0x2,%edx
  801056:	89 c8                	mov    %ecx,%eax
  801058:	c1 f8 1f             	sar    $0x1f,%eax
  80105b:	29 c2                	sub    %eax,%edx
  80105d:	89 d0                	mov    %edx,%eax
  80105f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	75 bb                	jne    801023 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801068:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	48                   	dec    %eax
  801073:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801076:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80107a:	74 3d                	je     8010b9 <ltostr+0xc3>
		start = 1 ;
  80107c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801083:	eb 34                	jmp    8010b9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	01 c2                	add    %eax,%edx
  80109a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80109d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a0:	01 c8                	add    %ecx,%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	01 c2                	add    %eax,%edx
  8010ae:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010b1:	88 02                	mov    %al,(%edx)
		start++ ;
  8010b3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010b6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010bf:	7c c4                	jl     801085 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	01 d0                	add    %edx,%eax
  8010c9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010cc:	90                   	nop
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010d5:	ff 75 08             	pushl  0x8(%ebp)
  8010d8:	e8 c4 f9 ff ff       	call   800aa1 <strlen>
  8010dd:	83 c4 04             	add    $0x4,%esp
  8010e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010e3:	ff 75 0c             	pushl  0xc(%ebp)
  8010e6:	e8 b6 f9 ff ff       	call   800aa1 <strlen>
  8010eb:	83 c4 04             	add    $0x4,%esp
  8010ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 17                	jmp    801118 <strcconcat+0x49>
		final[s] = str1[s] ;
  801101:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	01 c2                	add    %eax,%edx
  801109:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	01 c8                	add    %ecx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801115:	ff 45 fc             	incl   -0x4(%ebp)
  801118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80111e:	7c e1                	jl     801101 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801120:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801127:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80112e:	eb 1f                	jmp    80114f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801130:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801133:	8d 50 01             	lea    0x1(%eax),%edx
  801136:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801139:	89 c2                	mov    %eax,%edx
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 c2                	add    %eax,%edx
  801140:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 c8                	add    %ecx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80114c:	ff 45 f8             	incl   -0x8(%ebp)
  80114f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801152:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801155:	7c d9                	jl     801130 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801157:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115a:	8b 45 10             	mov    0x10(%ebp),%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	c6 00 00             	movb   $0x0,(%eax)
}
  801162:	90                   	nop
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801171:	8b 45 14             	mov    0x14(%ebp),%eax
  801174:	8b 00                	mov    (%eax),%eax
  801176:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117d:	8b 45 10             	mov    0x10(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801188:	eb 0c                	jmp    801196 <strsplit+0x31>
			*string++ = 0;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	89 55 08             	mov    %edx,0x8(%ebp)
  801193:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	84 c0                	test   %al,%al
  80119d:	74 18                	je     8011b7 <strsplit+0x52>
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	0f be c0             	movsbl %al,%eax
  8011a7:	50                   	push   %eax
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	e8 83 fa ff ff       	call   800c33 <strchr>
  8011b0:	83 c4 08             	add    $0x8,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	75 d3                	jne    80118a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	74 5a                	je     80121a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	83 f8 0f             	cmp    $0xf,%eax
  8011c8:	75 07                	jne    8011d1 <strsplit+0x6c>
		{
			return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cf:	eb 66                	jmp    801237 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8011d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8011dc:	89 0a                	mov    %ecx,(%edx)
  8011de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	01 c2                	add    %eax,%edx
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011ef:	eb 03                	jmp    8011f4 <strsplit+0x8f>
			string++;
  8011f1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	74 8b                	je     801188 <strsplit+0x23>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	0f be c0             	movsbl %al,%eax
  801205:	50                   	push   %eax
  801206:	ff 75 0c             	pushl  0xc(%ebp)
  801209:	e8 25 fa ff ff       	call   800c33 <strchr>
  80120e:	83 c4 08             	add    $0x8,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	74 dc                	je     8011f1 <strsplit+0x8c>
			string++;
	}
  801215:	e9 6e ff ff ff       	jmp    801188 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80121a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80121b:	8b 45 14             	mov    0x14(%ebp),%eax
  80121e:	8b 00                	mov    (%eax),%eax
  801220:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801227:	8b 45 10             	mov    0x10(%ebp),%eax
  80122a:	01 d0                	add    %edx,%eax
  80122c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801232:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124c:	eb 4a                	jmp    801298 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80124e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	01 c2                	add    %eax,%edx
  801256:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 c8                	add    %ecx,%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801262:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 40                	cmp    $0x40,%al
  80126e:	7e 25                	jle    801295 <str2lower+0x5c>
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	01 d0                	add    %edx,%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 17                	jg     801295 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80127e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801289:	8b 55 08             	mov    0x8(%ebp),%edx
  80128c:	01 ca                	add    %ecx,%edx
  80128e:	8a 12                	mov    (%edx),%dl
  801290:	83 c2 20             	add    $0x20,%edx
  801293:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801295:	ff 45 fc             	incl   -0x4(%ebp)
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	e8 01 f8 ff ff       	call   800aa1 <strlen>
  8012a0:	83 c4 04             	add    $0x4,%esp
  8012a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012a6:	7f a6                	jg     80124e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8012a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8012b3:	a1 08 40 80 00       	mov    0x804008,%eax
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	74 42                	je     8012fe <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8012bc:	83 ec 08             	sub    $0x8,%esp
  8012bf:	68 00 00 00 82       	push   $0x82000000
  8012c4:	68 00 00 00 80       	push   $0x80000000
  8012c9:	e8 00 08 00 00       	call   801ace <initialize_dynamic_allocator>
  8012ce:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8012d1:	e8 e7 05 00 00       	call   8018bd <sys_get_uheap_strategy>
  8012d6:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8012db:	a1 40 40 80 00       	mov    0x804040,%eax
  8012e0:	05 00 10 00 00       	add    $0x1000,%eax
  8012e5:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8012ea:	a1 10 c1 81 00       	mov    0x81c110,%eax
  8012ef:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8012f4:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8012fb:	00 00 00 
	}
}
  8012fe:	90                   	nop
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	68 06 04 00 00       	push   $0x406
  80131d:	50                   	push   %eax
  80131e:	e8 e4 01 00 00       	call   801507 <__sys_allocate_page>
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801329:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80132d:	79 14                	jns    801343 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80132f:	83 ec 04             	sub    $0x4,%esp
  801332:	68 48 2e 80 00       	push   $0x802e48
  801337:	6a 1f                	push   $0x1f
  801339:	68 84 2e 80 00       	push   $0x802e84
  80133e:	e8 72 11 00 00       	call   8024b5 <_panic>
	return 0;
  801343:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801359:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	50                   	push   %eax
  801362:	e8 e7 01 00 00       	call   80154e <__sys_unmap_frame>
  801367:	83 c4 10             	add    $0x10,%esp
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80136d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801371:	79 14                	jns    801387 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801373:	83 ec 04             	sub    $0x4,%esp
  801376:	68 90 2e 80 00       	push   $0x802e90
  80137b:	6a 2a                	push   $0x2a
  80137d:	68 84 2e 80 00       	push   $0x802e84
  801382:	e8 2e 11 00 00       	call   8024b5 <_panic>
}
  801387:	90                   	nop
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801390:	e8 18 ff ff ff       	call   8012ad <uheap_init>
	if (size == 0) return NULL ;
  801395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801399:	75 07                	jne    8013a2 <malloc+0x18>
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a0:	eb 14                	jmp    8013b6 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	68 d0 2e 80 00       	push   $0x802ed0
  8013aa:	6a 3e                	push   $0x3e
  8013ac:	68 84 2e 80 00       	push   $0x802e84
  8013b1:	e8 ff 10 00 00       	call   8024b5 <_panic>
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	68 f8 2e 80 00       	push   $0x802ef8
  8013c6:	6a 49                	push   $0x49
  8013c8:	68 84 2e 80 00       	push   $0x802e84
  8013cd:	e8 e3 10 00 00       	call   8024b5 <_panic>

008013d2 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 18             	sub    $0x18,%esp
  8013d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013db:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8013de:	e8 ca fe ff ff       	call   8012ad <uheap_init>
	if (size == 0) return NULL ;
  8013e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013e7:	75 07                	jne    8013f0 <smalloc+0x1e>
  8013e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ee:	eb 14                	jmp    801404 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	68 1c 2f 80 00       	push   $0x802f1c
  8013f8:	6a 5a                	push   $0x5a
  8013fa:	68 84 2e 80 00       	push   $0x802e84
  8013ff:	e8 b1 10 00 00       	call   8024b5 <_panic>
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80140c:	e8 9c fe ff ff       	call   8012ad <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	68 44 2f 80 00       	push   $0x802f44
  801419:	6a 6a                	push   $0x6a
  80141b:	68 84 2e 80 00       	push   $0x802e84
  801420:	e8 90 10 00 00       	call   8024b5 <_panic>

00801425 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80142b:	e8 7d fe ff ff       	call   8012ad <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	68 68 2f 80 00       	push   $0x802f68
  801438:	68 88 00 00 00       	push   $0x88
  80143d:	68 84 2e 80 00       	push   $0x802e84
  801442:	e8 6e 10 00 00       	call   8024b5 <_panic>

00801447 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	68 90 2f 80 00       	push   $0x802f90
  801455:	68 9b 00 00 00       	push   $0x9b
  80145a:	68 84 2e 80 00       	push   $0x802e84
  80145f:	e8 51 10 00 00       	call   8024b5 <_panic>

00801464 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801476:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801479:	8b 7d 18             	mov    0x18(%ebp),%edi
  80147c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80147f:	cd 30                	int    $0x30
  801481:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801484:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	5b                   	pop    %ebx
  80148b:	5e                   	pop    %esi
  80148c:	5f                   	pop    %edi
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 10             	mov    0x10(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80149b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	6a 00                	push   $0x0
  8014a7:	51                   	push   %ecx
  8014a8:	52                   	push   %edx
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	50                   	push   %eax
  8014ad:	6a 00                	push   $0x0
  8014af:	e8 b0 ff ff ff       	call   801464 <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	90                   	nop
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_cgetc>:

int
sys_cgetc(void)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 02                	push   $0x2
  8014c9:	e8 96 ff ff ff       	call   801464 <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 03                	push   $0x3
  8014e2:	e8 7d ff ff ff       	call   801464 <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
}
  8014ea:	90                   	nop
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 04                	push   $0x4
  8014fc:	e8 63 ff ff ff       	call   801464 <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
}
  801504:	90                   	nop
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80150a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	52                   	push   %edx
  801517:	50                   	push   %eax
  801518:	6a 08                	push   $0x8
  80151a:	e8 45 ff ff ff       	call   801464 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	56                   	push   %esi
  801528:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801529:	8b 75 18             	mov    0x18(%ebp),%esi
  80152c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801532:	8b 55 0c             	mov    0xc(%ebp),%edx
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	56                   	push   %esi
  801539:	53                   	push   %ebx
  80153a:	51                   	push   %ecx
  80153b:	52                   	push   %edx
  80153c:	50                   	push   %eax
  80153d:	6a 09                	push   $0x9
  80153f:	e8 20 ff ff ff       	call   801464 <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154a:	5b                   	pop    %ebx
  80154b:	5e                   	pop    %esi
  80154c:	5d                   	pop    %ebp
  80154d:	c3                   	ret    

0080154e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	6a 0a                	push   $0xa
  80155e:	e8 01 ff ff ff       	call   801464 <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	6a 0b                	push   $0xb
  801579:	e8 e6 fe ff ff       	call   801464 <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 0c                	push   $0xc
  801592:	e8 cd fe ff ff       	call   801464 <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 0d                	push   $0xd
  8015ab:	e8 b4 fe ff ff       	call   801464 <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 0e                	push   $0xe
  8015c4:	e8 9b fe ff ff       	call   801464 <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 0f                	push   $0xf
  8015dd:	e8 82 fe ff ff       	call   801464 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	ff 75 08             	pushl  0x8(%ebp)
  8015f5:	6a 10                	push   $0x10
  8015f7:	e8 68 fe ff ff       	call   801464 <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 11                	push   $0x11
  801610:	e8 4f fe ff ff       	call   801464 <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
}
  801618:	90                   	nop
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <sys_cputc>:

void
sys_cputc(const char c)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801627:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	50                   	push   %eax
  801634:	6a 01                	push   $0x1
  801636:	e8 29 fe ff ff       	call   801464 <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	90                   	nop
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 14                	push   $0x14
  801650:	e8 0f fe ff ff       	call   801464 <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
}
  801658:	90                   	nop
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	8b 45 10             	mov    0x10(%ebp),%eax
  801664:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801667:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80166a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	51                   	push   %ecx
  801674:	52                   	push   %edx
  801675:	ff 75 0c             	pushl  0xc(%ebp)
  801678:	50                   	push   %eax
  801679:	6a 15                	push   $0x15
  80167b:	e8 e4 fd ff ff       	call   801464 <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	52                   	push   %edx
  801695:	50                   	push   %eax
  801696:	6a 16                	push   $0x16
  801698:	e8 c7 fd ff ff       	call   801464 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	51                   	push   %ecx
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	6a 17                	push   $0x17
  8016b7:	e8 a8 fd ff ff       	call   801464 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	52                   	push   %edx
  8016d1:	50                   	push   %eax
  8016d2:	6a 18                	push   $0x18
  8016d4:	e8 8b fd ff ff       	call   801464 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	6a 00                	push   $0x0
  8016e6:	ff 75 14             	pushl  0x14(%ebp)
  8016e9:	ff 75 10             	pushl  0x10(%ebp)
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	50                   	push   %eax
  8016f0:	6a 19                	push   $0x19
  8016f2:	e8 6d fd ff ff       	call   801464 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	50                   	push   %eax
  80170b:	6a 1a                	push   $0x1a
  80170d:	e8 52 fd ff ff       	call   801464 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	90                   	nop
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	50                   	push   %eax
  801727:	6a 1b                	push   $0x1b
  801729:	e8 36 fd ff ff       	call   801464 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 05                	push   $0x5
  801742:	e8 1d fd ff ff       	call   801464 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 06                	push   $0x6
  80175b:	e8 04 fd ff ff       	call   801464 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 07                	push   $0x7
  801774:	e8 eb fc ff ff       	call   801464 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_exit_env>:


void sys_exit_env(void)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 1c                	push   $0x1c
  80178d:	e8 d2 fc ff ff       	call   801464 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	90                   	nop
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80179e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a1:	8d 50 04             	lea    0x4(%eax),%edx
  8017a4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	52                   	push   %edx
  8017ae:	50                   	push   %eax
  8017af:	6a 1d                	push   $0x1d
  8017b1:	e8 ae fc ff ff       	call   801464 <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
	return result;
  8017b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c2:	89 01                	mov    %eax,(%ecx)
  8017c4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	c9                   	leave  
  8017cb:	c2 04 00             	ret    $0x4

008017ce <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	ff 75 10             	pushl  0x10(%ebp)
  8017d8:	ff 75 0c             	pushl  0xc(%ebp)
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	6a 13                	push   $0x13
  8017e0:	e8 7f fc ff ff       	call   801464 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e8:	90                   	nop
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_rcr2>:
uint32 sys_rcr2()
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 1e                	push   $0x1e
  8017fa:	e8 65 fc ff ff       	call   801464 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 04             	sub    $0x4,%esp
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801810:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	50                   	push   %eax
  80181d:	6a 1f                	push   $0x1f
  80181f:	e8 40 fc ff ff       	call   801464 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
	return ;
  801827:	90                   	nop
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <rsttst>:
void rsttst()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 21                	push   $0x21
  801839:	e8 26 fc ff ff       	call   801464 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
	return ;
  801841:	90                   	nop
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	8b 45 14             	mov    0x14(%ebp),%eax
  80184d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801850:	8b 55 18             	mov    0x18(%ebp),%edx
  801853:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801857:	52                   	push   %edx
  801858:	50                   	push   %eax
  801859:	ff 75 10             	pushl  0x10(%ebp)
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 20                	push   $0x20
  801864:	e8 fb fb ff ff       	call   801464 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return ;
  80186c:	90                   	nop
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <chktst>:
void chktst(uint32 n)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	6a 22                	push   $0x22
  80187f:	e8 e0 fb ff ff       	call   801464 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
	return ;
  801887:	90                   	nop
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <inctst>:

void inctst()
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 23                	push   $0x23
  801899:	e8 c6 fb ff ff       	call   801464 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a1:	90                   	nop
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <gettst>:
uint32 gettst()
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 24                	push   $0x24
  8018b3:	e8 ac fb ff ff       	call   801464 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 25                	push   $0x25
  8018cc:	e8 93 fb ff ff       	call   801464 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
  8018d4:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8018d9:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	ff 75 08             	pushl  0x8(%ebp)
  8018f6:	6a 26                	push   $0x26
  8018f8:	e8 67 fb ff ff       	call   801464 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801900:	90                   	nop
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801907:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	6a 00                	push   $0x0
  801915:	53                   	push   %ebx
  801916:	51                   	push   %ecx
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 27                	push   $0x27
  80191b:	e8 44 fb ff ff       	call   801464 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	52                   	push   %edx
  801938:	50                   	push   %eax
  801939:	6a 28                	push   $0x28
  80193b:	e8 24 fb ff ff       	call   801464 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801948:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	51                   	push   %ecx
  801954:	ff 75 10             	pushl  0x10(%ebp)
  801957:	52                   	push   %edx
  801958:	50                   	push   %eax
  801959:	6a 29                	push   $0x29
  80195b:	e8 04 fb ff ff       	call   801464 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	ff 75 10             	pushl  0x10(%ebp)
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	6a 12                	push   $0x12
  801977:	e8 e8 fa ff ff       	call   801464 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
	return ;
  80197f:	90                   	nop
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	52                   	push   %edx
  801992:	50                   	push   %eax
  801993:	6a 2a                	push   $0x2a
  801995:	e8 ca fa ff ff       	call   801464 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
	return;
  80199d:	90                   	nop
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 2b                	push   $0x2b
  8019af:	e8 b0 fa ff ff       	call   801464 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	6a 2d                	push   $0x2d
  8019ca:	e8 95 fa ff ff       	call   801464 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
	return;
  8019d2:	90                   	nop
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	6a 2c                	push   $0x2c
  8019e6:	e8 79 fa ff ff       	call   801464 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ee:	90                   	nop
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	68 b4 2f 80 00       	push   $0x802fb4
  8019ff:	68 25 01 00 00       	push   $0x125
  801a04:	68 e7 2f 80 00       	push   $0x802fe7
  801a09:	e8 a7 0a 00 00       	call   8024b5 <_panic>

00801a0e <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801a14:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801a1b:	72 09                	jb     801a26 <to_page_va+0x18>
  801a1d:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801a24:	72 14                	jb     801a3a <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	68 f8 2f 80 00       	push   $0x802ff8
  801a2e:	6a 15                	push   $0x15
  801a30:	68 23 30 80 00       	push   $0x803023
  801a35:	e8 7b 0a 00 00       	call   8024b5 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	ba 60 40 80 00       	mov    $0x804060,%edx
  801a42:	29 d0                	sub    %edx,%eax
  801a44:	c1 f8 02             	sar    $0x2,%eax
  801a47:	89 c2                	mov    %eax,%edx
  801a49:	89 d0                	mov    %edx,%eax
  801a4b:	c1 e0 02             	shl    $0x2,%eax
  801a4e:	01 d0                	add    %edx,%eax
  801a50:	c1 e0 02             	shl    $0x2,%eax
  801a53:	01 d0                	add    %edx,%eax
  801a55:	c1 e0 02             	shl    $0x2,%eax
  801a58:	01 d0                	add    %edx,%eax
  801a5a:	89 c1                	mov    %eax,%ecx
  801a5c:	c1 e1 08             	shl    $0x8,%ecx
  801a5f:	01 c8                	add    %ecx,%eax
  801a61:	89 c1                	mov    %eax,%ecx
  801a63:	c1 e1 10             	shl    $0x10,%ecx
  801a66:	01 c8                	add    %ecx,%eax
  801a68:	01 c0                	add    %eax,%eax
  801a6a:	01 d0                	add    %edx,%eax
  801a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a72:	c1 e0 0c             	shl    $0xc,%eax
  801a75:	89 c2                	mov    %eax,%edx
  801a77:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801a7c:	01 d0                	add    %edx,%eax
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801a86:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a8e:	29 c2                	sub    %eax,%edx
  801a90:	89 d0                	mov    %edx,%eax
  801a92:	c1 e8 0c             	shr    $0xc,%eax
  801a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801a98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a9c:	78 09                	js     801aa7 <to_page_info+0x27>
  801a9e:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801aa5:	7e 14                	jle    801abb <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	68 3c 30 80 00       	push   $0x80303c
  801aaf:	6a 22                	push   $0x22
  801ab1:	68 23 30 80 00       	push   $0x803023
  801ab6:	e8 fa 09 00 00       	call   8024b5 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abe:	89 d0                	mov    %edx,%eax
  801ac0:	01 c0                	add    %eax,%eax
  801ac2:	01 d0                	add    %edx,%eax
  801ac4:	c1 e0 02             	shl    $0x2,%eax
  801ac7:	05 60 40 80 00       	add    $0x804060,%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	05 00 00 00 02       	add    $0x2000000,%eax
  801adc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801adf:	73 16                	jae    801af7 <initialize_dynamic_allocator+0x29>
  801ae1:	68 60 30 80 00       	push   $0x803060
  801ae6:	68 86 30 80 00       	push   $0x803086
  801aeb:	6a 34                	push   $0x34
  801aed:	68 23 30 80 00       	push   $0x803023
  801af2:	e8 be 09 00 00       	call   8024b5 <_panic>
		is_initialized = 1;
  801af7:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801afe:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0c:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801b11:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801b18:	00 00 00 
  801b1b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801b22:	00 00 00 
  801b25:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801b2c:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b32:	2b 45 08             	sub    0x8(%ebp),%eax
  801b35:	c1 e8 0c             	shr    $0xc,%eax
  801b38:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801b3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801b42:	e9 c8 00 00 00       	jmp    801c0f <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b4a:	89 d0                	mov    %edx,%eax
  801b4c:	01 c0                	add    %eax,%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	c1 e0 02             	shl    $0x2,%eax
  801b53:	05 68 40 80 00       	add    $0x804068,%eax
  801b58:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b60:	89 d0                	mov    %edx,%eax
  801b62:	01 c0                	add    %eax,%eax
  801b64:	01 d0                	add    %edx,%eax
  801b66:	c1 e0 02             	shl    $0x2,%eax
  801b69:	05 6a 40 80 00       	add    $0x80406a,%eax
  801b6e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801b73:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801b79:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801b7c:	89 c8                	mov    %ecx,%eax
  801b7e:	01 c0                	add    %eax,%eax
  801b80:	01 c8                	add    %ecx,%eax
  801b82:	c1 e0 02             	shl    $0x2,%eax
  801b85:	05 64 40 80 00       	add    $0x804064,%eax
  801b8a:	89 10                	mov    %edx,(%eax)
  801b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8f:	89 d0                	mov    %edx,%eax
  801b91:	01 c0                	add    %eax,%eax
  801b93:	01 d0                	add    %edx,%eax
  801b95:	c1 e0 02             	shl    $0x2,%eax
  801b98:	05 64 40 80 00       	add    $0x804064,%eax
  801b9d:	8b 00                	mov    (%eax),%eax
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	74 1b                	je     801bbe <initialize_dynamic_allocator+0xf0>
  801ba3:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801ba9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801bac:	89 c8                	mov    %ecx,%eax
  801bae:	01 c0                	add    %eax,%eax
  801bb0:	01 c8                	add    %ecx,%eax
  801bb2:	c1 e0 02             	shl    $0x2,%eax
  801bb5:	05 60 40 80 00       	add    $0x804060,%eax
  801bba:	89 02                	mov    %eax,(%edx)
  801bbc:	eb 16                	jmp    801bd4 <initialize_dynamic_allocator+0x106>
  801bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc1:	89 d0                	mov    %edx,%eax
  801bc3:	01 c0                	add    %eax,%eax
  801bc5:	01 d0                	add    %edx,%eax
  801bc7:	c1 e0 02             	shl    $0x2,%eax
  801bca:	05 60 40 80 00       	add    $0x804060,%eax
  801bcf:	a3 48 40 80 00       	mov    %eax,0x804048
  801bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd7:	89 d0                	mov    %edx,%eax
  801bd9:	01 c0                	add    %eax,%eax
  801bdb:	01 d0                	add    %edx,%eax
  801bdd:	c1 e0 02             	shl    $0x2,%eax
  801be0:	05 60 40 80 00       	add    $0x804060,%eax
  801be5:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801bea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bed:	89 d0                	mov    %edx,%eax
  801bef:	01 c0                	add    %eax,%eax
  801bf1:	01 d0                	add    %edx,%eax
  801bf3:	c1 e0 02             	shl    $0x2,%eax
  801bf6:	05 60 40 80 00       	add    $0x804060,%eax
  801bfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c01:	a1 54 40 80 00       	mov    0x804054,%eax
  801c06:	40                   	inc    %eax
  801c07:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801c0c:	ff 45 f4             	incl   -0xc(%ebp)
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801c15:	0f 8c 2c ff ff ff    	jl     801b47 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801c1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801c22:	eb 36                	jmp    801c5a <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c27:	c1 e0 04             	shl    $0x4,%eax
  801c2a:	05 80 c0 81 00       	add    $0x81c080,%eax
  801c2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c38:	c1 e0 04             	shl    $0x4,%eax
  801c3b:	05 84 c0 81 00       	add    $0x81c084,%eax
  801c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c49:	c1 e0 04             	shl    $0x4,%eax
  801c4c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801c51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801c57:	ff 45 f0             	incl   -0x10(%ebp)
  801c5a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801c5e:	7e c4                	jle    801c24 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801c60:	90                   	nop
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	83 ec 0c             	sub    $0xc,%esp
  801c6f:	50                   	push   %eax
  801c70:	e8 0b fe ff ff       	call   801a80 <to_page_info>
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7e:	8b 40 08             	mov    0x8(%eax),%eax
  801c81:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801c8c:	83 ec 0c             	sub    $0xc,%esp
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	e8 77 fd ff ff       	call   801a0e <to_page_va>
  801c97:	83 c4 10             	add    $0x10,%esp
  801c9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801c9d:	b8 00 10 00 00       	mov    $0x1000,%eax
  801ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca7:	f7 75 08             	divl   0x8(%ebp)
  801caa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801cad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb0:	83 ec 0c             	sub    $0xc,%esp
  801cb3:	50                   	push   %eax
  801cb4:	e8 48 f6 ff ff       	call   801301 <get_page>
  801cb9:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc2:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccc:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801cd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801cd7:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801cde:	eb 19                	jmp    801cf9 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce3:	ba 01 00 00 00       	mov    $0x1,%edx
  801ce8:	88 c1                	mov    %al,%cl
  801cea:	d3 e2                	shl    %cl,%edx
  801cec:	89 d0                	mov    %edx,%eax
  801cee:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cf1:	74 0e                	je     801d01 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801cf3:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801cf6:	ff 45 f0             	incl   -0x10(%ebp)
  801cf9:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801cfd:	7e e1                	jle    801ce0 <split_page_to_blocks+0x5a>
  801cff:	eb 01                	jmp    801d02 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801d01:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801d02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d09:	e9 a7 00 00 00       	jmp    801db5 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d11:	0f af 45 08          	imul   0x8(%ebp),%eax
  801d15:	89 c2                	mov    %eax,%edx
  801d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d1a:	01 d0                	add    %edx,%eax
  801d1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801d1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d23:	75 14                	jne    801d39 <split_page_to_blocks+0xb3>
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	68 9c 30 80 00       	push   $0x80309c
  801d2d:	6a 7c                	push   $0x7c
  801d2f:	68 23 30 80 00       	push   $0x803023
  801d34:	e8 7c 07 00 00       	call   8024b5 <_panic>
  801d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3c:	c1 e0 04             	shl    $0x4,%eax
  801d3f:	05 84 c0 81 00       	add    $0x81c084,%eax
  801d44:	8b 10                	mov    (%eax),%edx
  801d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d49:	89 50 04             	mov    %edx,0x4(%eax)
  801d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4f:	8b 40 04             	mov    0x4(%eax),%eax
  801d52:	85 c0                	test   %eax,%eax
  801d54:	74 14                	je     801d6a <split_page_to_blocks+0xe4>
  801d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d59:	c1 e0 04             	shl    $0x4,%eax
  801d5c:	05 84 c0 81 00       	add    $0x81c084,%eax
  801d61:	8b 00                	mov    (%eax),%eax
  801d63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d66:	89 10                	mov    %edx,(%eax)
  801d68:	eb 11                	jmp    801d7b <split_page_to_blocks+0xf5>
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	c1 e0 04             	shl    $0x4,%eax
  801d70:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d79:	89 02                	mov    %eax,(%edx)
  801d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7e:	c1 e0 04             	shl    $0x4,%eax
  801d81:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801d87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8a:	89 02                	mov    %eax,(%edx)
  801d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	c1 e0 04             	shl    $0x4,%eax
  801d9b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801da0:	8b 00                	mov    (%eax),%eax
  801da2:	8d 50 01             	lea    0x1(%eax),%edx
  801da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da8:	c1 e0 04             	shl    $0x4,%eax
  801dab:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801db0:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801db2:	ff 45 ec             	incl   -0x14(%ebp)
  801db5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801dbb:	0f 82 4d ff ff ff    	jb     801d0e <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801dc1:	90                   	nop
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801dca:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801dd1:	76 19                	jbe    801dec <alloc_block+0x28>
  801dd3:	68 c0 30 80 00       	push   $0x8030c0
  801dd8:	68 86 30 80 00       	push   $0x803086
  801ddd:	68 8a 00 00 00       	push   $0x8a
  801de2:	68 23 30 80 00       	push   $0x803023
  801de7:	e8 c9 06 00 00       	call   8024b5 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  801dec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801df3:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801dfa:	eb 19                	jmp    801e15 <alloc_block+0x51>
		if((1 << i) >= size) break;
  801dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dff:	ba 01 00 00 00       	mov    $0x1,%edx
  801e04:	88 c1                	mov    %al,%cl
  801e06:	d3 e2                	shl    %cl,%edx
  801e08:	89 d0                	mov    %edx,%eax
  801e0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e0d:	73 0e                	jae    801e1d <alloc_block+0x59>
		idx++;
  801e0f:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801e12:	ff 45 f0             	incl   -0x10(%ebp)
  801e15:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801e19:	7e e1                	jle    801dfc <alloc_block+0x38>
  801e1b:	eb 01                	jmp    801e1e <alloc_block+0x5a>
		if((1 << i) >= size) break;
  801e1d:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	c1 e0 04             	shl    $0x4,%eax
  801e24:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801e29:	8b 00                	mov    (%eax),%eax
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	0f 84 df 00 00 00    	je     801f12 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  801e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e36:	c1 e0 04             	shl    $0x4,%eax
  801e39:	05 80 c0 81 00       	add    $0x81c080,%eax
  801e3e:	8b 00                	mov    (%eax),%eax
  801e40:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  801e43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e47:	75 17                	jne    801e60 <alloc_block+0x9c>
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	68 e1 30 80 00       	push   $0x8030e1
  801e51:	68 9e 00 00 00       	push   $0x9e
  801e56:	68 23 30 80 00       	push   $0x803023
  801e5b:	e8 55 06 00 00       	call   8024b5 <_panic>
  801e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e63:	8b 00                	mov    (%eax),%eax
  801e65:	85 c0                	test   %eax,%eax
  801e67:	74 10                	je     801e79 <alloc_block+0xb5>
  801e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6c:	8b 00                	mov    (%eax),%eax
  801e6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e71:	8b 52 04             	mov    0x4(%edx),%edx
  801e74:	89 50 04             	mov    %edx,0x4(%eax)
  801e77:	eb 14                	jmp    801e8d <alloc_block+0xc9>
  801e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7c:	8b 40 04             	mov    0x4(%eax),%eax
  801e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e82:	c1 e2 04             	shl    $0x4,%edx
  801e85:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  801e8b:	89 02                	mov    %eax,(%edx)
  801e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e90:	8b 40 04             	mov    0x4(%eax),%eax
  801e93:	85 c0                	test   %eax,%eax
  801e95:	74 0f                	je     801ea6 <alloc_block+0xe2>
  801e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9a:	8b 40 04             	mov    0x4(%eax),%eax
  801e9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ea0:	8b 12                	mov    (%edx),%edx
  801ea2:	89 10                	mov    %edx,(%eax)
  801ea4:	eb 13                	jmp    801eb9 <alloc_block+0xf5>
  801ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea9:	8b 00                	mov    (%eax),%eax
  801eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eae:	c1 e2 04             	shl    $0x4,%edx
  801eb1:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  801eb7:	89 02                	mov    %eax,(%edx)
  801eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	c1 e0 04             	shl    $0x4,%eax
  801ed2:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801ed7:	8b 00                	mov    (%eax),%eax
  801ed9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	c1 e0 04             	shl    $0x4,%eax
  801ee2:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801ee7:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  801ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	50                   	push   %eax
  801ef0:	e8 8b fb ff ff       	call   801a80 <to_page_info>
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  801efb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801efe:	66 8b 40 0a          	mov    0xa(%eax),%ax
  801f02:	48                   	dec    %eax
  801f03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f06:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  801f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0d:	e9 bc 02 00 00       	jmp    8021ce <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  801f12:	a1 54 40 80 00       	mov    0x804054,%eax
  801f17:	85 c0                	test   %eax,%eax
  801f19:	0f 84 7d 02 00 00    	je     80219c <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  801f1f:	a1 48 40 80 00       	mov    0x804048,%eax
  801f24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  801f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f2b:	75 17                	jne    801f44 <alloc_block+0x180>
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	68 e1 30 80 00       	push   $0x8030e1
  801f35:	68 a9 00 00 00       	push   $0xa9
  801f3a:	68 23 30 80 00       	push   $0x803023
  801f3f:	e8 71 05 00 00       	call   8024b5 <_panic>
  801f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f47:	8b 00                	mov    (%eax),%eax
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	74 10                	je     801f5d <alloc_block+0x199>
  801f4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f50:	8b 00                	mov    (%eax),%eax
  801f52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f55:	8b 52 04             	mov    0x4(%edx),%edx
  801f58:	89 50 04             	mov    %edx,0x4(%eax)
  801f5b:	eb 0b                	jmp    801f68 <alloc_block+0x1a4>
  801f5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f60:	8b 40 04             	mov    0x4(%eax),%eax
  801f63:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f6b:	8b 40 04             	mov    0x4(%eax),%eax
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	74 0f                	je     801f81 <alloc_block+0x1bd>
  801f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f75:	8b 40 04             	mov    0x4(%eax),%eax
  801f78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f7b:	8b 12                	mov    (%edx),%edx
  801f7d:	89 10                	mov    %edx,(%eax)
  801f7f:	eb 0a                	jmp    801f8b <alloc_block+0x1c7>
  801f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	a3 48 40 80 00       	mov    %eax,0x804048
  801f8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f9e:	a1 54 40 80 00       	mov    0x804054,%eax
  801fa3:	48                   	dec    %eax
  801fa4:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	83 c0 03             	add    $0x3,%eax
  801faf:	ba 01 00 00 00       	mov    $0x1,%edx
  801fb4:	88 c1                	mov    %al,%cl
  801fb6:	d3 e2                	shl    %cl,%edx
  801fb8:	89 d0                	mov    %edx,%eax
  801fba:	83 ec 08             	sub    $0x8,%esp
  801fbd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc0:	50                   	push   %eax
  801fc1:	e8 c0 fc ff ff       	call   801c86 <split_page_to_blocks>
  801fc6:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  801fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcc:	c1 e0 04             	shl    $0x4,%eax
  801fcf:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fd4:	8b 00                	mov    (%eax),%eax
  801fd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  801fd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fdd:	75 17                	jne    801ff6 <alloc_block+0x232>
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	68 e1 30 80 00       	push   $0x8030e1
  801fe7:	68 b0 00 00 00       	push   $0xb0
  801fec:	68 23 30 80 00       	push   $0x803023
  801ff1:	e8 bf 04 00 00       	call   8024b5 <_panic>
  801ff6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	74 10                	je     80200f <alloc_block+0x24b>
  801fff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802002:	8b 00                	mov    (%eax),%eax
  802004:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802007:	8b 52 04             	mov    0x4(%edx),%edx
  80200a:	89 50 04             	mov    %edx,0x4(%eax)
  80200d:	eb 14                	jmp    802023 <alloc_block+0x25f>
  80200f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802012:	8b 40 04             	mov    0x4(%eax),%eax
  802015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802018:	c1 e2 04             	shl    $0x4,%edx
  80201b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802021:	89 02                	mov    %eax,(%edx)
  802023:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802026:	8b 40 04             	mov    0x4(%eax),%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	74 0f                	je     80203c <alloc_block+0x278>
  80202d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802030:	8b 40 04             	mov    0x4(%eax),%eax
  802033:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802036:	8b 12                	mov    (%edx),%edx
  802038:	89 10                	mov    %edx,(%eax)
  80203a:	eb 13                	jmp    80204f <alloc_block+0x28b>
  80203c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80203f:	8b 00                	mov    (%eax),%eax
  802041:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802044:	c1 e2 04             	shl    $0x4,%edx
  802047:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80204d:	89 02                	mov    %eax,(%edx)
  80204f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802052:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802058:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80205b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	c1 e0 04             	shl    $0x4,%eax
  802068:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80206d:	8b 00                	mov    (%eax),%eax
  80206f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802075:	c1 e0 04             	shl    $0x4,%eax
  802078:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80207d:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80207f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	50                   	push   %eax
  802086:	e8 f5 f9 ff ff       	call   801a80 <to_page_info>
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802091:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802094:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802098:	48                   	dec    %eax
  802099:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80209c:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8020a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a3:	e9 26 01 00 00       	jmp    8021ce <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8020a8:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8020ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ae:	c1 e0 04             	shl    $0x4,%eax
  8020b1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020b6:	8b 00                	mov    (%eax),%eax
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	0f 84 dc 00 00 00    	je     80219c <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	c1 e0 04             	shl    $0x4,%eax
  8020c6:	05 80 c0 81 00       	add    $0x81c080,%eax
  8020cb:	8b 00                	mov    (%eax),%eax
  8020cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8020d0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8020d4:	75 17                	jne    8020ed <alloc_block+0x329>
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	68 e1 30 80 00       	push   $0x8030e1
  8020de:	68 be 00 00 00       	push   $0xbe
  8020e3:	68 23 30 80 00       	push   $0x803023
  8020e8:	e8 c8 03 00 00       	call   8024b5 <_panic>
  8020ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020f0:	8b 00                	mov    (%eax),%eax
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	74 10                	je     802106 <alloc_block+0x342>
  8020f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8020fe:	8b 52 04             	mov    0x4(%edx),%edx
  802101:	89 50 04             	mov    %edx,0x4(%eax)
  802104:	eb 14                	jmp    80211a <alloc_block+0x356>
  802106:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802109:	8b 40 04             	mov    0x4(%eax),%eax
  80210c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210f:	c1 e2 04             	shl    $0x4,%edx
  802112:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802118:	89 02                	mov    %eax,(%edx)
  80211a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80211d:	8b 40 04             	mov    0x4(%eax),%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	74 0f                	je     802133 <alloc_block+0x36f>
  802124:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802127:	8b 40 04             	mov    0x4(%eax),%eax
  80212a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80212d:	8b 12                	mov    (%edx),%edx
  80212f:	89 10                	mov    %edx,(%eax)
  802131:	eb 13                	jmp    802146 <alloc_block+0x382>
  802133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213b:	c1 e2 04             	shl    $0x4,%edx
  80213e:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802144:	89 02                	mov    %eax,(%edx)
  802146:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802149:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80214f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802152:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	c1 e0 04             	shl    $0x4,%eax
  80215f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802164:	8b 00                	mov    (%eax),%eax
  802166:	8d 50 ff             	lea    -0x1(%eax),%edx
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	c1 e0 04             	shl    $0x4,%eax
  80216f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802174:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802176:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802179:	83 ec 0c             	sub    $0xc,%esp
  80217c:	50                   	push   %eax
  80217d:	e8 fe f8 ff ff       	call   801a80 <to_page_info>
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802188:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80218b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80218f:	48                   	dec    %eax
  802190:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802193:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802197:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80219a:	eb 32                	jmp    8021ce <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80219c:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8021a0:	77 15                	ja     8021b7 <alloc_block+0x3f3>
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	c1 e0 04             	shl    $0x4,%eax
  8021a8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021ad:	8b 00                	mov    (%eax),%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	0f 84 f1 fe ff ff    	je     8020a8 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	68 ff 30 80 00       	push   $0x8030ff
  8021bf:	68 c8 00 00 00       	push   $0xc8
  8021c4:	68 23 30 80 00       	push   $0x803023
  8021c9:	e8 e7 02 00 00       	call   8024b5 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8021de:	39 c2                	cmp    %eax,%edx
  8021e0:	72 0c                	jb     8021ee <free_block+0x1e>
  8021e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e5:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ea:	39 c2                	cmp    %eax,%edx
  8021ec:	72 19                	jb     802207 <free_block+0x37>
  8021ee:	68 10 31 80 00       	push   $0x803110
  8021f3:	68 86 30 80 00       	push   $0x803086
  8021f8:	68 d7 00 00 00       	push   $0xd7
  8021fd:	68 23 30 80 00       	push   $0x803023
  802202:	e8 ae 02 00 00       	call   8024b5 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	83 ec 0c             	sub    $0xc,%esp
  802213:	50                   	push   %eax
  802214:	e8 67 f8 ff ff       	call   801a80 <to_page_info>
  802219:	83 c4 10             	add    $0x10,%esp
  80221c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80221f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802222:	8b 40 08             	mov    0x8(%eax),%eax
  802225:	0f b7 c0             	movzwl %ax,%eax
  802228:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80222b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802232:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802239:	eb 19                	jmp    802254 <free_block+0x84>
	    if ((1 << i) == blk_size)
  80223b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223e:	ba 01 00 00 00       	mov    $0x1,%edx
  802243:	88 c1                	mov    %al,%cl
  802245:	d3 e2                	shl    %cl,%edx
  802247:	89 d0                	mov    %edx,%eax
  802249:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80224c:	74 0e                	je     80225c <free_block+0x8c>
	        break;
	    idx++;
  80224e:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802251:	ff 45 f0             	incl   -0x10(%ebp)
  802254:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802258:	7e e1                	jle    80223b <free_block+0x6b>
  80225a:	eb 01                	jmp    80225d <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  80225c:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  80225d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802260:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802264:	40                   	inc    %eax
  802265:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802268:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  80226c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802270:	75 17                	jne    802289 <free_block+0xb9>
  802272:	83 ec 04             	sub    $0x4,%esp
  802275:	68 9c 30 80 00       	push   $0x80309c
  80227a:	68 ee 00 00 00       	push   $0xee
  80227f:	68 23 30 80 00       	push   $0x803023
  802284:	e8 2c 02 00 00       	call   8024b5 <_panic>
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	c1 e0 04             	shl    $0x4,%eax
  80228f:	05 84 c0 81 00       	add    $0x81c084,%eax
  802294:	8b 10                	mov    (%eax),%edx
  802296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802299:	89 50 04             	mov    %edx,0x4(%eax)
  80229c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80229f:	8b 40 04             	mov    0x4(%eax),%eax
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	74 14                	je     8022ba <free_block+0xea>
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	c1 e0 04             	shl    $0x4,%eax
  8022ac:	05 84 c0 81 00       	add    $0x81c084,%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022b6:	89 10                	mov    %edx,(%eax)
  8022b8:	eb 11                	jmp    8022cb <free_block+0xfb>
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	c1 e0 04             	shl    $0x4,%eax
  8022c0:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8022c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c9:	89 02                	mov    %eax,(%edx)
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	c1 e0 04             	shl    $0x4,%eax
  8022d1:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8022d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022da:	89 02                	mov    %eax,(%edx)
  8022dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	c1 e0 04             	shl    $0x4,%eax
  8022eb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022f0:	8b 00                	mov    (%eax),%eax
  8022f2:	8d 50 01             	lea    0x1(%eax),%edx
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	c1 e0 04             	shl    $0x4,%eax
  8022fb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802300:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802302:	b8 00 10 00 00       	mov    $0x1000,%eax
  802307:	ba 00 00 00 00       	mov    $0x0,%edx
  80230c:	f7 75 e0             	divl   -0x20(%ebp)
  80230f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802315:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802319:	0f b7 c0             	movzwl %ax,%eax
  80231c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80231f:	0f 85 70 01 00 00    	jne    802495 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802325:	83 ec 0c             	sub    $0xc,%esp
  802328:	ff 75 e4             	pushl  -0x1c(%ebp)
  80232b:	e8 de f6 ff ff       	call   801a0e <to_page_va>
  802330:	83 c4 10             	add    $0x10,%esp
  802333:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802336:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80233d:	e9 b7 00 00 00       	jmp    8023f9 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802342:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802345:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802348:	01 d0                	add    %edx,%eax
  80234a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  80234d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802351:	75 17                	jne    80236a <free_block+0x19a>
  802353:	83 ec 04             	sub    $0x4,%esp
  802356:	68 e1 30 80 00       	push   $0x8030e1
  80235b:	68 f8 00 00 00       	push   $0xf8
  802360:	68 23 30 80 00       	push   $0x803023
  802365:	e8 4b 01 00 00       	call   8024b5 <_panic>
  80236a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	74 10                	je     802383 <free_block+0x1b3>
  802373:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80237b:	8b 52 04             	mov    0x4(%edx),%edx
  80237e:	89 50 04             	mov    %edx,0x4(%eax)
  802381:	eb 14                	jmp    802397 <free_block+0x1c7>
  802383:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802386:	8b 40 04             	mov    0x4(%eax),%eax
  802389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238c:	c1 e2 04             	shl    $0x4,%edx
  80238f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802395:	89 02                	mov    %eax,(%edx)
  802397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80239a:	8b 40 04             	mov    0x4(%eax),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	74 0f                	je     8023b0 <free_block+0x1e0>
  8023a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023a4:	8b 40 04             	mov    0x4(%eax),%eax
  8023a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023aa:	8b 12                	mov    (%edx),%edx
  8023ac:	89 10                	mov    %edx,(%eax)
  8023ae:	eb 13                	jmp    8023c3 <free_block+0x1f3>
  8023b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b8:	c1 e2 04             	shl    $0x4,%edx
  8023bb:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023c1:	89 02                	mov    %eax,(%edx)
  8023c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	c1 e0 04             	shl    $0x4,%eax
  8023dc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023e1:	8b 00                	mov    (%eax),%eax
  8023e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	c1 e0 04             	shl    $0x4,%eax
  8023ec:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023f1:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8023f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f6:	01 45 ec             	add    %eax,-0x14(%ebp)
  8023f9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802400:	0f 86 3c ff ff ff    	jbe    802342 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802409:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80240f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802412:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802418:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80241c:	75 17                	jne    802435 <free_block+0x265>
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	68 9c 30 80 00       	push   $0x80309c
  802426:	68 fe 00 00 00       	push   $0xfe
  80242b:	68 23 30 80 00       	push   $0x803023
  802430:	e8 80 00 00 00       	call   8024b5 <_panic>
  802435:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80243b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243e:	89 50 04             	mov    %edx,0x4(%eax)
  802441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802444:	8b 40 04             	mov    0x4(%eax),%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	74 0c                	je     802457 <free_block+0x287>
  80244b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802450:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	eb 08                	jmp    80245f <free_block+0x28f>
  802457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80245a:	a3 48 40 80 00       	mov    %eax,0x804048
  80245f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802462:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802470:	a1 54 40 80 00       	mov    0x804054,%eax
  802475:	40                   	inc    %eax
  802476:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802481:	e8 88 f5 ff ff       	call   801a0e <to_page_va>
  802486:	83 c4 10             	add    $0x10,%esp
  802489:	83 ec 0c             	sub    $0xc,%esp
  80248c:	50                   	push   %eax
  80248d:	e8 b8 ee ff ff       	call   80134a <return_page>
  802492:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	68 48 31 80 00       	push   $0x803148
  8024a6:	68 11 01 00 00       	push   $0x111
  8024ab:	68 23 30 80 00       	push   $0x803023
  8024b0:	e8 00 00 00 00       	call   8024b5 <_panic>

008024b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8024bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8024be:	83 c0 04             	add    $0x4,%eax
  8024c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8024c4:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	74 16                	je     8024e3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8024cd:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8024d2:	83 ec 08             	sub    $0x8,%esp
  8024d5:	50                   	push   %eax
  8024d6:	68 6c 31 80 00       	push   $0x80316c
  8024db:	e8 e8 de ff ff       	call   8003c8 <cprintf>
  8024e0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8024e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8024e8:	83 ec 0c             	sub    $0xc,%esp
  8024eb:	ff 75 0c             	pushl  0xc(%ebp)
  8024ee:	ff 75 08             	pushl  0x8(%ebp)
  8024f1:	50                   	push   %eax
  8024f2:	68 74 31 80 00       	push   $0x803174
  8024f7:	6a 74                	push   $0x74
  8024f9:	e8 f7 de ff ff       	call   8003f5 <cprintf_colored>
  8024fe:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802501:	8b 45 10             	mov    0x10(%ebp),%eax
  802504:	83 ec 08             	sub    $0x8,%esp
  802507:	ff 75 f4             	pushl  -0xc(%ebp)
  80250a:	50                   	push   %eax
  80250b:	e8 49 de ff ff       	call   800359 <vcprintf>
  802510:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802513:	83 ec 08             	sub    $0x8,%esp
  802516:	6a 00                	push   $0x0
  802518:	68 9c 31 80 00       	push   $0x80319c
  80251d:	e8 37 de ff ff       	call   800359 <vcprintf>
  802522:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802525:	e8 b0 dd ff ff       	call   8002da <exit>

	// should not return here
	while (1) ;
  80252a:	eb fe                	jmp    80252a <_panic+0x75>

0080252c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802532:	a1 20 40 80 00       	mov    0x804020,%eax
  802537:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80253d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802540:	39 c2                	cmp    %eax,%edx
  802542:	74 14                	je     802558 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802544:	83 ec 04             	sub    $0x4,%esp
  802547:	68 a0 31 80 00       	push   $0x8031a0
  80254c:	6a 26                	push   $0x26
  80254e:	68 ec 31 80 00       	push   $0x8031ec
  802553:	e8 5d ff ff ff       	call   8024b5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802558:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80255f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802566:	e9 c5 00 00 00       	jmp    802630 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	01 d0                	add    %edx,%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	75 08                	jne    802588 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802580:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802583:	e9 a5 00 00 00       	jmp    80262d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802588:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80258f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802596:	eb 69                	jmp    802601 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802598:	a1 20 40 80 00       	mov    0x804020,%eax
  80259d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8025a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025a6:	89 d0                	mov    %edx,%eax
  8025a8:	01 c0                	add    %eax,%eax
  8025aa:	01 d0                	add    %edx,%eax
  8025ac:	c1 e0 03             	shl    $0x3,%eax
  8025af:	01 c8                	add    %ecx,%eax
  8025b1:	8a 40 04             	mov    0x4(%eax),%al
  8025b4:	84 c0                	test   %al,%al
  8025b6:	75 46                	jne    8025fe <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8025b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8025bd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8025c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025c6:	89 d0                	mov    %edx,%eax
  8025c8:	01 c0                	add    %eax,%eax
  8025ca:	01 d0                	add    %edx,%eax
  8025cc:	c1 e0 03             	shl    $0x3,%eax
  8025cf:	01 c8                	add    %ecx,%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8025e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	01 c8                	add    %ecx,%eax
  8025ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8025f1:	39 c2                	cmp    %eax,%edx
  8025f3:	75 09                	jne    8025fe <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8025f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8025fc:	eb 15                	jmp    802613 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8025fe:	ff 45 e8             	incl   -0x18(%ebp)
  802601:	a1 20 40 80 00       	mov    0x804020,%eax
  802606:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80260c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260f:	39 c2                	cmp    %eax,%edx
  802611:	77 85                	ja     802598 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802613:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802617:	75 14                	jne    80262d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	68 f8 31 80 00       	push   $0x8031f8
  802621:	6a 3a                	push   $0x3a
  802623:	68 ec 31 80 00       	push   $0x8031ec
  802628:	e8 88 fe ff ff       	call   8024b5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80262d:	ff 45 f0             	incl   -0x10(%ebp)
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802636:	0f 8c 2f ff ff ff    	jl     80256b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80263c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802643:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80264a:	eb 26                	jmp    802672 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80264c:	a1 20 40 80 00       	mov    0x804020,%eax
  802651:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802657:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80265a:	89 d0                	mov    %edx,%eax
  80265c:	01 c0                	add    %eax,%eax
  80265e:	01 d0                	add    %edx,%eax
  802660:	c1 e0 03             	shl    $0x3,%eax
  802663:	01 c8                	add    %ecx,%eax
  802665:	8a 40 04             	mov    0x4(%eax),%al
  802668:	3c 01                	cmp    $0x1,%al
  80266a:	75 03                	jne    80266f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80266c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80266f:	ff 45 e0             	incl   -0x20(%ebp)
  802672:	a1 20 40 80 00       	mov    0x804020,%eax
  802677:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80267d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802680:	39 c2                	cmp    %eax,%edx
  802682:	77 c8                	ja     80264c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80268a:	74 14                	je     8026a0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 4c 32 80 00       	push   $0x80324c
  802694:	6a 44                	push   $0x44
  802696:	68 ec 31 80 00       	push   $0x8031ec
  80269b:	e8 15 fe ff ff       	call   8024b5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8026a0:	90                   	nop
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    
  8026a3:	90                   	nop

008026a4 <__udivdi3>:
  8026a4:	55                   	push   %ebp
  8026a5:	57                   	push   %edi
  8026a6:	56                   	push   %esi
  8026a7:	53                   	push   %ebx
  8026a8:	83 ec 1c             	sub    $0x1c,%esp
  8026ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8026af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8026b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026bb:	89 ca                	mov    %ecx,%edx
  8026bd:	89 f8                	mov    %edi,%eax
  8026bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8026c3:	85 f6                	test   %esi,%esi
  8026c5:	75 2d                	jne    8026f4 <__udivdi3+0x50>
  8026c7:	39 cf                	cmp    %ecx,%edi
  8026c9:	77 65                	ja     802730 <__udivdi3+0x8c>
  8026cb:	89 fd                	mov    %edi,%ebp
  8026cd:	85 ff                	test   %edi,%edi
  8026cf:	75 0b                	jne    8026dc <__udivdi3+0x38>
  8026d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d6:	31 d2                	xor    %edx,%edx
  8026d8:	f7 f7                	div    %edi
  8026da:	89 c5                	mov    %eax,%ebp
  8026dc:	31 d2                	xor    %edx,%edx
  8026de:	89 c8                	mov    %ecx,%eax
  8026e0:	f7 f5                	div    %ebp
  8026e2:	89 c1                	mov    %eax,%ecx
  8026e4:	89 d8                	mov    %ebx,%eax
  8026e6:	f7 f5                	div    %ebp
  8026e8:	89 cf                	mov    %ecx,%edi
  8026ea:	89 fa                	mov    %edi,%edx
  8026ec:	83 c4 1c             	add    $0x1c,%esp
  8026ef:	5b                   	pop    %ebx
  8026f0:	5e                   	pop    %esi
  8026f1:	5f                   	pop    %edi
  8026f2:	5d                   	pop    %ebp
  8026f3:	c3                   	ret    
  8026f4:	39 ce                	cmp    %ecx,%esi
  8026f6:	77 28                	ja     802720 <__udivdi3+0x7c>
  8026f8:	0f bd fe             	bsr    %esi,%edi
  8026fb:	83 f7 1f             	xor    $0x1f,%edi
  8026fe:	75 40                	jne    802740 <__udivdi3+0x9c>
  802700:	39 ce                	cmp    %ecx,%esi
  802702:	72 0a                	jb     80270e <__udivdi3+0x6a>
  802704:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802708:	0f 87 9e 00 00 00    	ja     8027ac <__udivdi3+0x108>
  80270e:	b8 01 00 00 00       	mov    $0x1,%eax
  802713:	89 fa                	mov    %edi,%edx
  802715:	83 c4 1c             	add    $0x1c,%esp
  802718:	5b                   	pop    %ebx
  802719:	5e                   	pop    %esi
  80271a:	5f                   	pop    %edi
  80271b:	5d                   	pop    %ebp
  80271c:	c3                   	ret    
  80271d:	8d 76 00             	lea    0x0(%esi),%esi
  802720:	31 ff                	xor    %edi,%edi
  802722:	31 c0                	xor    %eax,%eax
  802724:	89 fa                	mov    %edi,%edx
  802726:	83 c4 1c             	add    $0x1c,%esp
  802729:	5b                   	pop    %ebx
  80272a:	5e                   	pop    %esi
  80272b:	5f                   	pop    %edi
  80272c:	5d                   	pop    %ebp
  80272d:	c3                   	ret    
  80272e:	66 90                	xchg   %ax,%ax
  802730:	89 d8                	mov    %ebx,%eax
  802732:	f7 f7                	div    %edi
  802734:	31 ff                	xor    %edi,%edi
  802736:	89 fa                	mov    %edi,%edx
  802738:	83 c4 1c             	add    $0x1c,%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    
  802740:	bd 20 00 00 00       	mov    $0x20,%ebp
  802745:	89 eb                	mov    %ebp,%ebx
  802747:	29 fb                	sub    %edi,%ebx
  802749:	89 f9                	mov    %edi,%ecx
  80274b:	d3 e6                	shl    %cl,%esi
  80274d:	89 c5                	mov    %eax,%ebp
  80274f:	88 d9                	mov    %bl,%cl
  802751:	d3 ed                	shr    %cl,%ebp
  802753:	89 e9                	mov    %ebp,%ecx
  802755:	09 f1                	or     %esi,%ecx
  802757:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80275b:	89 f9                	mov    %edi,%ecx
  80275d:	d3 e0                	shl    %cl,%eax
  80275f:	89 c5                	mov    %eax,%ebp
  802761:	89 d6                	mov    %edx,%esi
  802763:	88 d9                	mov    %bl,%cl
  802765:	d3 ee                	shr    %cl,%esi
  802767:	89 f9                	mov    %edi,%ecx
  802769:	d3 e2                	shl    %cl,%edx
  80276b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80276f:	88 d9                	mov    %bl,%cl
  802771:	d3 e8                	shr    %cl,%eax
  802773:	09 c2                	or     %eax,%edx
  802775:	89 d0                	mov    %edx,%eax
  802777:	89 f2                	mov    %esi,%edx
  802779:	f7 74 24 0c          	divl   0xc(%esp)
  80277d:	89 d6                	mov    %edx,%esi
  80277f:	89 c3                	mov    %eax,%ebx
  802781:	f7 e5                	mul    %ebp
  802783:	39 d6                	cmp    %edx,%esi
  802785:	72 19                	jb     8027a0 <__udivdi3+0xfc>
  802787:	74 0b                	je     802794 <__udivdi3+0xf0>
  802789:	89 d8                	mov    %ebx,%eax
  80278b:	31 ff                	xor    %edi,%edi
  80278d:	e9 58 ff ff ff       	jmp    8026ea <__udivdi3+0x46>
  802792:	66 90                	xchg   %ax,%ax
  802794:	8b 54 24 08          	mov    0x8(%esp),%edx
  802798:	89 f9                	mov    %edi,%ecx
  80279a:	d3 e2                	shl    %cl,%edx
  80279c:	39 c2                	cmp    %eax,%edx
  80279e:	73 e9                	jae    802789 <__udivdi3+0xe5>
  8027a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027a3:	31 ff                	xor    %edi,%edi
  8027a5:	e9 40 ff ff ff       	jmp    8026ea <__udivdi3+0x46>
  8027aa:	66 90                	xchg   %ax,%ax
  8027ac:	31 c0                	xor    %eax,%eax
  8027ae:	e9 37 ff ff ff       	jmp    8026ea <__udivdi3+0x46>
  8027b3:	90                   	nop

008027b4 <__umoddi3>:
  8027b4:	55                   	push   %ebp
  8027b5:	57                   	push   %edi
  8027b6:	56                   	push   %esi
  8027b7:	53                   	push   %ebx
  8027b8:	83 ec 1c             	sub    $0x1c,%esp
  8027bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8027bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027d3:	89 f3                	mov    %esi,%ebx
  8027d5:	89 fa                	mov    %edi,%edx
  8027d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027db:	89 34 24             	mov    %esi,(%esp)
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	75 1a                	jne    8027fc <__umoddi3+0x48>
  8027e2:	39 f7                	cmp    %esi,%edi
  8027e4:	0f 86 a2 00 00 00    	jbe    80288c <__umoddi3+0xd8>
  8027ea:	89 c8                	mov    %ecx,%eax
  8027ec:	89 f2                	mov    %esi,%edx
  8027ee:	f7 f7                	div    %edi
  8027f0:	89 d0                	mov    %edx,%eax
  8027f2:	31 d2                	xor    %edx,%edx
  8027f4:	83 c4 1c             	add    $0x1c,%esp
  8027f7:	5b                   	pop    %ebx
  8027f8:	5e                   	pop    %esi
  8027f9:	5f                   	pop    %edi
  8027fa:	5d                   	pop    %ebp
  8027fb:	c3                   	ret    
  8027fc:	39 f0                	cmp    %esi,%eax
  8027fe:	0f 87 ac 00 00 00    	ja     8028b0 <__umoddi3+0xfc>
  802804:	0f bd e8             	bsr    %eax,%ebp
  802807:	83 f5 1f             	xor    $0x1f,%ebp
  80280a:	0f 84 ac 00 00 00    	je     8028bc <__umoddi3+0x108>
  802810:	bf 20 00 00 00       	mov    $0x20,%edi
  802815:	29 ef                	sub    %ebp,%edi
  802817:	89 fe                	mov    %edi,%esi
  802819:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80281d:	89 e9                	mov    %ebp,%ecx
  80281f:	d3 e0                	shl    %cl,%eax
  802821:	89 d7                	mov    %edx,%edi
  802823:	89 f1                	mov    %esi,%ecx
  802825:	d3 ef                	shr    %cl,%edi
  802827:	09 c7                	or     %eax,%edi
  802829:	89 e9                	mov    %ebp,%ecx
  80282b:	d3 e2                	shl    %cl,%edx
  80282d:	89 14 24             	mov    %edx,(%esp)
  802830:	89 d8                	mov    %ebx,%eax
  802832:	d3 e0                	shl    %cl,%eax
  802834:	89 c2                	mov    %eax,%edx
  802836:	8b 44 24 08          	mov    0x8(%esp),%eax
  80283a:	d3 e0                	shl    %cl,%eax
  80283c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802840:	8b 44 24 08          	mov    0x8(%esp),%eax
  802844:	89 f1                	mov    %esi,%ecx
  802846:	d3 e8                	shr    %cl,%eax
  802848:	09 d0                	or     %edx,%eax
  80284a:	d3 eb                	shr    %cl,%ebx
  80284c:	89 da                	mov    %ebx,%edx
  80284e:	f7 f7                	div    %edi
  802850:	89 d3                	mov    %edx,%ebx
  802852:	f7 24 24             	mull   (%esp)
  802855:	89 c6                	mov    %eax,%esi
  802857:	89 d1                	mov    %edx,%ecx
  802859:	39 d3                	cmp    %edx,%ebx
  80285b:	0f 82 87 00 00 00    	jb     8028e8 <__umoddi3+0x134>
  802861:	0f 84 91 00 00 00    	je     8028f8 <__umoddi3+0x144>
  802867:	8b 54 24 04          	mov    0x4(%esp),%edx
  80286b:	29 f2                	sub    %esi,%edx
  80286d:	19 cb                	sbb    %ecx,%ebx
  80286f:	89 d8                	mov    %ebx,%eax
  802871:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802875:	d3 e0                	shl    %cl,%eax
  802877:	89 e9                	mov    %ebp,%ecx
  802879:	d3 ea                	shr    %cl,%edx
  80287b:	09 d0                	or     %edx,%eax
  80287d:	89 e9                	mov    %ebp,%ecx
  80287f:	d3 eb                	shr    %cl,%ebx
  802881:	89 da                	mov    %ebx,%edx
  802883:	83 c4 1c             	add    $0x1c,%esp
  802886:	5b                   	pop    %ebx
  802887:	5e                   	pop    %esi
  802888:	5f                   	pop    %edi
  802889:	5d                   	pop    %ebp
  80288a:	c3                   	ret    
  80288b:	90                   	nop
  80288c:	89 fd                	mov    %edi,%ebp
  80288e:	85 ff                	test   %edi,%edi
  802890:	75 0b                	jne    80289d <__umoddi3+0xe9>
  802892:	b8 01 00 00 00       	mov    $0x1,%eax
  802897:	31 d2                	xor    %edx,%edx
  802899:	f7 f7                	div    %edi
  80289b:	89 c5                	mov    %eax,%ebp
  80289d:	89 f0                	mov    %esi,%eax
  80289f:	31 d2                	xor    %edx,%edx
  8028a1:	f7 f5                	div    %ebp
  8028a3:	89 c8                	mov    %ecx,%eax
  8028a5:	f7 f5                	div    %ebp
  8028a7:	89 d0                	mov    %edx,%eax
  8028a9:	e9 44 ff ff ff       	jmp    8027f2 <__umoddi3+0x3e>
  8028ae:	66 90                	xchg   %ax,%ax
  8028b0:	89 c8                	mov    %ecx,%eax
  8028b2:	89 f2                	mov    %esi,%edx
  8028b4:	83 c4 1c             	add    $0x1c,%esp
  8028b7:	5b                   	pop    %ebx
  8028b8:	5e                   	pop    %esi
  8028b9:	5f                   	pop    %edi
  8028ba:	5d                   	pop    %ebp
  8028bb:	c3                   	ret    
  8028bc:	3b 04 24             	cmp    (%esp),%eax
  8028bf:	72 06                	jb     8028c7 <__umoddi3+0x113>
  8028c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8028c5:	77 0f                	ja     8028d6 <__umoddi3+0x122>
  8028c7:	89 f2                	mov    %esi,%edx
  8028c9:	29 f9                	sub    %edi,%ecx
  8028cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8028cf:	89 14 24             	mov    %edx,(%esp)
  8028d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028da:	8b 14 24             	mov    (%esp),%edx
  8028dd:	83 c4 1c             	add    $0x1c,%esp
  8028e0:	5b                   	pop    %ebx
  8028e1:	5e                   	pop    %esi
  8028e2:	5f                   	pop    %edi
  8028e3:	5d                   	pop    %ebp
  8028e4:	c3                   	ret    
  8028e5:	8d 76 00             	lea    0x0(%esi),%esi
  8028e8:	2b 04 24             	sub    (%esp),%eax
  8028eb:	19 fa                	sbb    %edi,%edx
  8028ed:	89 d1                	mov    %edx,%ecx
  8028ef:	89 c6                	mov    %eax,%esi
  8028f1:	e9 71 ff ff ff       	jmp    802867 <__umoddi3+0xb3>
  8028f6:	66 90                	xchg   %ax,%ax
  8028f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8028fc:	72 ea                	jb     8028e8 <__umoddi3+0x134>
  8028fe:	89 d9                	mov    %ebx,%ecx
  802900:	e9 62 ff ff ff       	jmp    802867 <__umoddi3+0xb3>
