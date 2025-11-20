
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
  80004b:	e8 4f 13 00 00       	call   80139f <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 20 29 80 00       	push   $0x802920
  800061:	e8 e9 03 00 00       	call   80044f <atomic_cprintf>
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
  8000be:	e8 8c 03 00 00       	call   80044f <atomic_cprintf>
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
  8000d7:	e8 f1 12 00 00       	call   8013cd <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 b5 12 00 00       	call   80139f <malloc>
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
  800114:	e8 36 03 00 00       	call   80044f <atomic_cprintf>
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
  80012d:	e8 9b 12 00 00       	call   8013cd <free>
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
  800141:	e8 1b 16 00 00       	call   801761 <sys_getenvindex>
  800146:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 06             	shl    $0x6,%eax
  800151:	29 d0                	sub    %edx,%eax
  800153:	c1 e0 02             	shl    $0x2,%eax
  800156:	01 d0                	add    %edx,%eax
  800158:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015f:	01 c8                	add    %ecx,%eax
  800161:	c1 e0 03             	shl    $0x3,%eax
  800164:	01 d0                	add    %edx,%eax
  800166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016d:	29 c2                	sub    %eax,%edx
  80016f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800176:	89 c2                	mov    %eax,%edx
  800178:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80017e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800183:	a1 20 40 80 00       	mov    0x804020,%eax
  800188:	8a 40 20             	mov    0x20(%eax),%al
  80018b:	84 c0                	test   %al,%al
  80018d:	74 0d                	je     80019c <libmain+0x64>
		binaryname = myEnv->prog_name;
  80018f:	a1 20 40 80 00       	mov    0x804020,%eax
  800194:	83 c0 20             	add    $0x20,%eax
  800197:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a0:	7e 0a                	jle    8001ac <libmain+0x74>
		binaryname = argv[0];
  8001a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a5:	8b 00                	mov    (%eax),%eax
  8001a7:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	ff 75 0c             	pushl  0xc(%ebp)
  8001b2:	ff 75 08             	pushl  0x8(%ebp)
  8001b5:	e8 7e fe ff ff       	call   800038 <_main>
  8001ba:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001bd:	a1 00 40 80 00       	mov    0x804000,%eax
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	0f 84 01 01 00 00    	je     8002cb <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001ca:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001d0:	bb 38 2a 80 00       	mov    $0x802a38,%ebx
  8001d5:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001da:	89 c7                	mov    %eax,%edi
  8001dc:	89 de                	mov    %ebx,%esi
  8001de:	89 d1                	mov    %edx,%ecx
  8001e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001e2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001e5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001ea:	b0 00                	mov    $0x0,%al
  8001ec:	89 d7                	mov    %edx,%edi
  8001ee:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	50                   	push   %eax
  8001fe:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	e8 8d 17 00 00       	call   801997 <sys_utilities>
  80020a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80020d:	e8 d6 12 00 00       	call   8014e8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	68 58 29 80 00       	push   $0x802958
  80021a:	e8 be 01 00 00       	call   8003dd <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	85 c0                	test   %eax,%eax
  800227:	74 18                	je     800241 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800229:	e8 87 17 00 00       	call   8019b5 <sys_get_optimal_num_faults>
  80022e:	83 ec 08             	sub    $0x8,%esp
  800231:	50                   	push   %eax
  800232:	68 80 29 80 00       	push   $0x802980
  800237:	e8 a1 01 00 00       	call   8003dd <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	eb 59                	jmp    80029a <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800241:	a1 20 40 80 00       	mov    0x804020,%eax
  800246:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80024c:	a1 20 40 80 00       	mov    0x804020,%eax
  800251:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	68 a4 29 80 00       	push   $0x8029a4
  800261:	e8 77 01 00 00       	call   8003dd <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800269:	a1 20 40 80 00       	mov    0x804020,%eax
  80026e:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80027f:	a1 20 40 80 00       	mov    0x804020,%eax
  800284:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80028a:	51                   	push   %ecx
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 cc 29 80 00       	push   $0x8029cc
  800292:	e8 46 01 00 00       	call   8003dd <cprintf>
  800297:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80029a:	a1 20 40 80 00       	mov    0x804020,%eax
  80029f:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	50                   	push   %eax
  8002a9:	68 24 2a 80 00       	push   $0x802a24
  8002ae:	e8 2a 01 00 00       	call   8003dd <cprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 58 29 80 00       	push   $0x802958
  8002be:	e8 1a 01 00 00       	call   8003dd <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002c6:	e8 37 12 00 00       	call   801502 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002cb:	e8 1f 00 00 00       	call   8002ef <exit>
}
  8002d0:	90                   	nop
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    

008002d9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	6a 00                	push   $0x0
  8002e4:	e8 44 14 00 00       	call   80172d <sys_destroy_env>
  8002e9:	83 c4 10             	add    $0x10,%esp
}
  8002ec:	90                   	nop
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <exit>:

void
exit(void)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f5:	e8 99 14 00 00       	call   801793 <sys_exit_env>
}
  8002fa:	90                   	nop
  8002fb:	c9                   	leave  
  8002fc:	c3                   	ret    

008002fd <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	53                   	push   %ebx
  800301:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	8b 00                	mov    (%eax),%eax
  800309:	8d 48 01             	lea    0x1(%eax),%ecx
  80030c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80030f:	89 0a                	mov    %ecx,(%edx)
  800311:	8b 55 08             	mov    0x8(%ebp),%edx
  800314:	88 d1                	mov    %dl,%cl
  800316:	8b 55 0c             	mov    0xc(%ebp),%edx
  800319:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80031d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800320:	8b 00                	mov    (%eax),%eax
  800322:	3d ff 00 00 00       	cmp    $0xff,%eax
  800327:	75 30                	jne    800359 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800329:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  80032f:	a0 44 40 80 00       	mov    0x804044,%al
  800334:	0f b6 c0             	movzbl %al,%eax
  800337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033a:	8b 09                	mov    (%ecx),%ecx
  80033c:	89 cb                	mov    %ecx,%ebx
  80033e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800341:	83 c1 08             	add    $0x8,%ecx
  800344:	52                   	push   %edx
  800345:	50                   	push   %eax
  800346:	53                   	push   %ebx
  800347:	51                   	push   %ecx
  800348:	e8 57 11 00 00       	call   8014a4 <sys_cputs>
  80034d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800350:	8b 45 0c             	mov    0xc(%ebp),%eax
  800353:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035c:	8b 40 04             	mov    0x4(%eax),%eax
  80035f:	8d 50 01             	lea    0x1(%eax),%edx
  800362:	8b 45 0c             	mov    0xc(%ebp),%eax
  800365:	89 50 04             	mov    %edx,0x4(%eax)
}
  800368:	90                   	nop
  800369:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800377:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80037e:	00 00 00 
	b.cnt = 0;
  800381:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800388:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80038b:	ff 75 0c             	pushl  0xc(%ebp)
  80038e:	ff 75 08             	pushl  0x8(%ebp)
  800391:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800397:	50                   	push   %eax
  800398:	68 fd 02 80 00       	push   $0x8002fd
  80039d:	e8 5a 02 00 00       	call   8005fc <vprintfmt>
  8003a2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003a5:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8003ab:	a0 44 40 80 00       	mov    0x804044,%al
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003b9:	52                   	push   %edx
  8003ba:	50                   	push   %eax
  8003bb:	51                   	push   %ecx
  8003bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c2:	83 c0 08             	add    $0x8,%eax
  8003c5:	50                   	push   %eax
  8003c6:	e8 d9 10 00 00       	call   8014a4 <sys_cputs>
  8003cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003ce:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  8003d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003db:	c9                   	leave  
  8003dc:	c3                   	ret    

008003dd <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003e3:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8003ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f9:	50                   	push   %eax
  8003fa:	e8 6f ff ff ff       	call   80036e <vcprintf>
  8003ff:	83 c4 10             	add    $0x10,%esp
  800402:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800405:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800410:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	c1 e0 08             	shl    $0x8,%eax
  80041d:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  800422:	8d 45 0c             	lea    0xc(%ebp),%eax
  800425:	83 c0 04             	add    $0x4,%eax
  800428:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80042b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	ff 75 f4             	pushl  -0xc(%ebp)
  800434:	50                   	push   %eax
  800435:	e8 34 ff ff ff       	call   80036e <vcprintf>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800440:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  800447:	07 00 00 

	return cnt;
  80044a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    

0080044f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800455:	e8 8e 10 00 00       	call   8014e8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80045a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80045d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	ff 75 f4             	pushl  -0xc(%ebp)
  800469:	50                   	push   %eax
  80046a:	e8 ff fe ff ff       	call   80036e <vcprintf>
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800475:	e8 88 10 00 00       	call   801502 <sys_unlock_cons>
	return cnt;
  80047a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	53                   	push   %ebx
  800483:	83 ec 14             	sub    $0x14,%esp
  800486:	8b 45 10             	mov    0x10(%ebp),%eax
  800489:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800492:	8b 45 18             	mov    0x18(%ebp),%eax
  800495:	ba 00 00 00 00       	mov    $0x0,%edx
  80049a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80049d:	77 55                	ja     8004f4 <printnum+0x75>
  80049f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004a2:	72 05                	jb     8004a9 <printnum+0x2a>
  8004a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004a7:	77 4b                	ja     8004f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004af:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b7:	52                   	push   %edx
  8004b8:	50                   	push   %eax
  8004b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8004bf:	e8 f4 21 00 00       	call   8026b8 <__udivdi3>
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	ff 75 20             	pushl  0x20(%ebp)
  8004cd:	53                   	push   %ebx
  8004ce:	ff 75 18             	pushl  0x18(%ebp)
  8004d1:	52                   	push   %edx
  8004d2:	50                   	push   %eax
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	e8 a1 ff ff ff       	call   80047f <printnum>
  8004de:	83 c4 20             	add    $0x20,%esp
  8004e1:	eb 1a                	jmp    8004fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 0c             	pushl  0xc(%ebp)
  8004e9:	ff 75 20             	pushl  0x20(%ebp)
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	ff d0                	call   *%eax
  8004f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8004f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004fb:	7f e6                	jg     8004e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800500:	bb 00 00 00 00       	mov    $0x0,%ebx
  800505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80050b:	53                   	push   %ebx
  80050c:	51                   	push   %ecx
  80050d:	52                   	push   %edx
  80050e:	50                   	push   %eax
  80050f:	e8 b4 22 00 00       	call   8027c8 <__umoddi3>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	05 b4 2c 80 00       	add    $0x802cb4,%eax
  80051c:	8a 00                	mov    (%eax),%al
  80051e:	0f be c0             	movsbl %al,%eax
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	50                   	push   %eax
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	ff d0                	call   *%eax
  80052d:	83 c4 10             	add    $0x10,%esp
}
  800530:	90                   	nop
  800531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800539:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80053d:	7e 1c                	jle    80055b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	8d 50 08             	lea    0x8(%eax),%edx
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	89 10                	mov    %edx,(%eax)
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	83 e8 08             	sub    $0x8,%eax
  800554:	8b 50 04             	mov    0x4(%eax),%edx
  800557:	8b 00                	mov    (%eax),%eax
  800559:	eb 40                	jmp    80059b <getuint+0x65>
	else if (lflag)
  80055b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80055f:	74 1e                	je     80057f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	8d 50 04             	lea    0x4(%eax),%edx
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	89 10                	mov    %edx,(%eax)
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 e8 04             	sub    $0x4,%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	ba 00 00 00 00       	mov    $0x0,%edx
  80057d:	eb 1c                	jmp    80059b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 04             	lea    0x4(%eax),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	83 e8 04             	sub    $0x4,%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80059b:	5d                   	pop    %ebp
  80059c:	c3                   	ret    

0080059d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a4:	7e 1c                	jle    8005c2 <getint+0x25>
		return va_arg(*ap, long long);
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	8d 50 08             	lea    0x8(%eax),%edx
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	89 10                	mov    %edx,(%eax)
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	83 e8 08             	sub    $0x8,%eax
  8005bb:	8b 50 04             	mov    0x4(%eax),%edx
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	eb 38                	jmp    8005fa <getint+0x5d>
	else if (lflag)
  8005c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c6:	74 1a                	je     8005e2 <getint+0x45>
		return va_arg(*ap, long);
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	8d 50 04             	lea    0x4(%eax),%edx
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	89 10                	mov    %edx,(%eax)
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	83 e8 04             	sub    $0x4,%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	99                   	cltd   
  8005e0:	eb 18                	jmp    8005fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	89 10                	mov    %edx,(%eax)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	83 e8 04             	sub    $0x4,%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	99                   	cltd   
}
  8005fa:	5d                   	pop    %ebp
  8005fb:	c3                   	ret    

008005fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fc:	55                   	push   %ebp
  8005fd:	89 e5                	mov    %esp,%ebp
  8005ff:	56                   	push   %esi
  800600:	53                   	push   %ebx
  800601:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800604:	eb 17                	jmp    80061d <vprintfmt+0x21>
			if (ch == '\0')
  800606:	85 db                	test   %ebx,%ebx
  800608:	0f 84 c1 03 00 00    	je     8009cf <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	53                   	push   %ebx
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061d:	8b 45 10             	mov    0x10(%ebp),%eax
  800620:	8d 50 01             	lea    0x1(%eax),%edx
  800623:	89 55 10             	mov    %edx,0x10(%ebp)
  800626:	8a 00                	mov    (%eax),%al
  800628:	0f b6 d8             	movzbl %al,%ebx
  80062b:	83 fb 25             	cmp    $0x25,%ebx
  80062e:	75 d6                	jne    800606 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800630:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800634:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80063b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800642:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800649:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800650:	8b 45 10             	mov    0x10(%ebp),%eax
  800653:	8d 50 01             	lea    0x1(%eax),%edx
  800656:	89 55 10             	mov    %edx,0x10(%ebp)
  800659:	8a 00                	mov    (%eax),%al
  80065b:	0f b6 d8             	movzbl %al,%ebx
  80065e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800661:	83 f8 5b             	cmp    $0x5b,%eax
  800664:	0f 87 3d 03 00 00    	ja     8009a7 <vprintfmt+0x3ab>
  80066a:	8b 04 85 d8 2c 80 00 	mov    0x802cd8(,%eax,4),%eax
  800671:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800673:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800677:	eb d7                	jmp    800650 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800679:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80067d:	eb d1                	jmp    800650 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80067f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800686:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800689:	89 d0                	mov    %edx,%eax
  80068b:	c1 e0 02             	shl    $0x2,%eax
  80068e:	01 d0                	add    %edx,%eax
  800690:	01 c0                	add    %eax,%eax
  800692:	01 d8                	add    %ebx,%eax
  800694:	83 e8 30             	sub    $0x30,%eax
  800697:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80069a:	8b 45 10             	mov    0x10(%ebp),%eax
  80069d:	8a 00                	mov    (%eax),%al
  80069f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8006a5:	7e 3e                	jle    8006e5 <vprintfmt+0xe9>
  8006a7:	83 fb 39             	cmp    $0x39,%ebx
  8006aa:	7f 39                	jg     8006e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006af:	eb d5                	jmp    800686 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	83 c0 04             	add    $0x4,%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	83 e8 04             	sub    $0x4,%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006c5:	eb 1f                	jmp    8006e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cb:	79 83                	jns    800650 <vprintfmt+0x54>
				width = 0;
  8006cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006d4:	e9 77 ff ff ff       	jmp    800650 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006e0:	e9 6b ff ff ff       	jmp    800650 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ea:	0f 89 60 ff ff ff    	jns    800650 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006fd:	e9 4e ff ff ff       	jmp    800650 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800702:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800705:	e9 46 ff ff ff       	jmp    800650 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	83 c0 04             	add    $0x4,%eax
  800710:	89 45 14             	mov    %eax,0x14(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	50                   	push   %eax
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
			break;
  80072a:	e9 9b 02 00 00       	jmp    8009ca <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	83 c0 04             	add    $0x4,%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	83 e8 04             	sub    $0x4,%eax
  80073e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800740:	85 db                	test   %ebx,%ebx
  800742:	79 02                	jns    800746 <vprintfmt+0x14a>
				err = -err;
  800744:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800746:	83 fb 64             	cmp    $0x64,%ebx
  800749:	7f 0b                	jg     800756 <vprintfmt+0x15a>
  80074b:	8b 34 9d 20 2b 80 00 	mov    0x802b20(,%ebx,4),%esi
  800752:	85 f6                	test   %esi,%esi
  800754:	75 19                	jne    80076f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800756:	53                   	push   %ebx
  800757:	68 c5 2c 80 00       	push   $0x802cc5
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	ff 75 08             	pushl  0x8(%ebp)
  800762:	e8 70 02 00 00       	call   8009d7 <printfmt>
  800767:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80076a:	e9 5b 02 00 00       	jmp    8009ca <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80076f:	56                   	push   %esi
  800770:	68 ce 2c 80 00       	push   $0x802cce
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	ff 75 08             	pushl  0x8(%ebp)
  80077b:	e8 57 02 00 00       	call   8009d7 <printfmt>
  800780:	83 c4 10             	add    $0x10,%esp
			break;
  800783:	e9 42 02 00 00       	jmp    8009ca <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	83 c0 04             	add    $0x4,%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	83 e8 04             	sub    $0x4,%eax
  800797:	8b 30                	mov    (%eax),%esi
  800799:	85 f6                	test   %esi,%esi
  80079b:	75 05                	jne    8007a2 <vprintfmt+0x1a6>
				p = "(null)";
  80079d:	be d1 2c 80 00       	mov    $0x802cd1,%esi
			if (width > 0 && padc != '-')
  8007a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a6:	7e 6d                	jle    800815 <vprintfmt+0x219>
  8007a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ac:	74 67                	je     800815 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	50                   	push   %eax
  8007b5:	56                   	push   %esi
  8007b6:	e8 1e 03 00 00       	call   800ad9 <strnlen>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007c1:	eb 16                	jmp    8007d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	ff 75 0c             	pushl  0xc(%ebp)
  8007cd:	50                   	push   %eax
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	ff d0                	call   *%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8007d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dd:	7f e4                	jg     8007c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007df:	eb 34                	jmp    800815 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007e5:	74 1c                	je     800803 <vprintfmt+0x207>
  8007e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8007ea:	7e 05                	jle    8007f1 <vprintfmt+0x1f5>
  8007ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8007ef:	7e 12                	jle    800803 <vprintfmt+0x207>
					putch('?', putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	6a 3f                	push   $0x3f
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	ff d0                	call   *%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	eb 0f                	jmp    800812 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	53                   	push   %ebx
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	ff d0                	call   *%eax
  80080f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800812:	ff 4d e4             	decl   -0x1c(%ebp)
  800815:	89 f0                	mov    %esi,%eax
  800817:	8d 70 01             	lea    0x1(%eax),%esi
  80081a:	8a 00                	mov    (%eax),%al
  80081c:	0f be d8             	movsbl %al,%ebx
  80081f:	85 db                	test   %ebx,%ebx
  800821:	74 24                	je     800847 <vprintfmt+0x24b>
  800823:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800827:	78 b8                	js     8007e1 <vprintfmt+0x1e5>
  800829:	ff 4d e0             	decl   -0x20(%ebp)
  80082c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800830:	79 af                	jns    8007e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800832:	eb 13                	jmp    800847 <vprintfmt+0x24b>
				putch(' ', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	6a 20                	push   $0x20
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800844:	ff 4d e4             	decl   -0x1c(%ebp)
  800847:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084b:	7f e7                	jg     800834 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80084d:	e9 78 01 00 00       	jmp    8009ca <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	ff 75 e8             	pushl  -0x18(%ebp)
  800858:	8d 45 14             	lea    0x14(%ebp),%eax
  80085b:	50                   	push   %eax
  80085c:	e8 3c fd ff ff       	call   80059d <getint>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800867:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800870:	85 d2                	test   %edx,%edx
  800872:	79 23                	jns    800897 <vprintfmt+0x29b>
				putch('-', putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	6a 2d                	push   $0x2d
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	ff d0                	call   *%eax
  800881:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800887:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088a:	f7 d8                	neg    %eax
  80088c:	83 d2 00             	adc    $0x0,%edx
  80088f:	f7 da                	neg    %edx
  800891:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800894:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800897:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80089e:	e9 bc 00 00 00       	jmp    80095f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	e8 84 fc ff ff       	call   800536 <getuint>
  8008b2:	83 c4 10             	add    $0x10,%esp
  8008b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008bb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008c2:	e9 98 00 00 00       	jmp    80095f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	6a 58                	push   $0x58
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	ff d0                	call   *%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	6a 58                	push   $0x58
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	6a 58                	push   $0x58
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
			break;
  8008f7:	e9 ce 00 00 00       	jmp    8009ca <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	ff 75 0c             	pushl  0xc(%ebp)
  800902:	6a 30                	push   $0x30
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	6a 78                	push   $0x78
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	83 c0 04             	add    $0x4,%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	83 e8 04             	sub    $0x4,%eax
  80092b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80092d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800930:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800937:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80093e:	eb 1f                	jmp    80095f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 e8             	pushl  -0x18(%ebp)
  800946:	8d 45 14             	lea    0x14(%ebp),%eax
  800949:	50                   	push   %eax
  80094a:	e8 e7 fb ff ff       	call   800536 <getuint>
  80094f:	83 c4 10             	add    $0x10,%esp
  800952:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800955:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800958:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80095f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800963:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800966:	83 ec 04             	sub    $0x4,%esp
  800969:	52                   	push   %edx
  80096a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80096d:	50                   	push   %eax
  80096e:	ff 75 f4             	pushl  -0xc(%ebp)
  800971:	ff 75 f0             	pushl  -0x10(%ebp)
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	ff 75 08             	pushl  0x8(%ebp)
  80097a:	e8 00 fb ff ff       	call   80047f <printnum>
  80097f:	83 c4 20             	add    $0x20,%esp
			break;
  800982:	eb 46                	jmp    8009ca <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	53                   	push   %ebx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			break;
  800993:	eb 35                	jmp    8009ca <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800995:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  80099c:	eb 2c                	jmp    8009ca <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80099e:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8009a5:	eb 23                	jmp    8009ca <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	6a 25                	push   $0x25
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
  8009b4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b7:	ff 4d 10             	decl   0x10(%ebp)
  8009ba:	eb 03                	jmp    8009bf <vprintfmt+0x3c3>
  8009bc:	ff 4d 10             	decl   0x10(%ebp)
  8009bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c2:	48                   	dec    %eax
  8009c3:	8a 00                	mov    (%eax),%al
  8009c5:	3c 25                	cmp    $0x25,%al
  8009c7:	75 f3                	jne    8009bc <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009c9:	90                   	nop
		}
	}
  8009ca:	e9 35 fc ff ff       	jmp    800604 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009cf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8009e0:	83 c0 04             	add    $0x4,%eax
  8009e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ec:	50                   	push   %eax
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	ff 75 08             	pushl  0x8(%ebp)
  8009f3:	e8 04 fc ff ff       	call   8005fc <vprintfmt>
  8009f8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009fb:	90                   	nop
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	8b 40 08             	mov    0x8(%eax),%eax
  800a07:	8d 50 01             	lea    0x1(%eax),%edx
  800a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a13:	8b 10                	mov    (%eax),%edx
  800a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a18:	8b 40 04             	mov    0x4(%eax),%eax
  800a1b:	39 c2                	cmp    %eax,%edx
  800a1d:	73 12                	jae    800a31 <sprintputch+0x33>
		*b->buf++ = ch;
  800a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	8d 48 01             	lea    0x1(%eax),%ecx
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	89 0a                	mov    %ecx,(%edx)
  800a2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a2f:	88 10                	mov    %dl,(%eax)
}
  800a31:	90                   	nop
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	01 d0                	add    %edx,%eax
  800a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a59:	74 06                	je     800a61 <vsnprintf+0x2d>
  800a5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a5f:	7f 07                	jg     800a68 <vsnprintf+0x34>
		return -E_INVAL;
  800a61:	b8 03 00 00 00       	mov    $0x3,%eax
  800a66:	eb 20                	jmp    800a88 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a68:	ff 75 14             	pushl  0x14(%ebp)
  800a6b:	ff 75 10             	pushl  0x10(%ebp)
  800a6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a71:	50                   	push   %eax
  800a72:	68 fe 09 80 00       	push   $0x8009fe
  800a77:	e8 80 fb ff ff       	call   8005fc <vprintfmt>
  800a7c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a82:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a90:	8d 45 10             	lea    0x10(%ebp),%eax
  800a93:	83 c0 04             	add    $0x4,%eax
  800a96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a99:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9f:	50                   	push   %eax
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 89 ff ff ff       	call   800a34 <vsnprintf>
  800aab:	83 c4 10             	add    $0x10,%esp
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab4:	c9                   	leave  
  800ab5:	c3                   	ret    

00800ab6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800abc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ac3:	eb 06                	jmp    800acb <strlen+0x15>
		n++;
  800ac5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac8:	ff 45 08             	incl   0x8(%ebp)
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8a 00                	mov    (%eax),%al
  800ad0:	84 c0                	test   %al,%al
  800ad2:	75 f1                	jne    800ac5 <strlen+0xf>
		n++;
	return n;
  800ad4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800adf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae6:	eb 09                	jmp    800af1 <strnlen+0x18>
		n++;
  800ae8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aeb:	ff 45 08             	incl   0x8(%ebp)
  800aee:	ff 4d 0c             	decl   0xc(%ebp)
  800af1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af5:	74 09                	je     800b00 <strnlen+0x27>
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	84 c0                	test   %al,%al
  800afe:	75 e8                	jne    800ae8 <strnlen+0xf>
		n++;
	return n;
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b03:	c9                   	leave  
  800b04:	c3                   	ret    

00800b05 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b11:	90                   	nop
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8d 50 01             	lea    0x1(%eax),%edx
  800b18:	89 55 08             	mov    %edx,0x8(%ebp)
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b21:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b24:	8a 12                	mov    (%edx),%dl
  800b26:	88 10                	mov    %dl,(%eax)
  800b28:	8a 00                	mov    (%eax),%al
  800b2a:	84 c0                	test   %al,%al
  800b2c:	75 e4                	jne    800b12 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b46:	eb 1f                	jmp    800b67 <strncpy+0x34>
		*dst++ = *src;
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8d 50 01             	lea    0x1(%eax),%edx
  800b4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b54:	8a 12                	mov    (%edx),%dl
  800b56:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	8a 00                	mov    (%eax),%al
  800b5d:	84 c0                	test   %al,%al
  800b5f:	74 03                	je     800b64 <strncpy+0x31>
			src++;
  800b61:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b64:	ff 45 fc             	incl   -0x4(%ebp)
  800b67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b6a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b6d:	72 d9                	jb     800b48 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b84:	74 30                	je     800bb6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b86:	eb 16                	jmp    800b9e <strlcpy+0x2a>
			*dst++ = *src++;
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8d 50 01             	lea    0x1(%eax),%edx
  800b8e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b94:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b97:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b9a:	8a 12                	mov    (%edx),%dl
  800b9c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b9e:	ff 4d 10             	decl   0x10(%ebp)
  800ba1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba5:	74 09                	je     800bb0 <strlcpy+0x3c>
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 d8                	jne    800b88 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bbc:	29 c2                	sub    %eax,%edx
  800bbe:	89 d0                	mov    %edx,%eax
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bc5:	eb 06                	jmp    800bcd <strcmp+0xb>
		p++, q++;
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	74 0e                	je     800be4 <strcmp+0x22>
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8a 10                	mov    (%eax),%dl
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	38 c2                	cmp    %al,%dl
  800be2:	74 e3                	je     800bc7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8a 00                	mov    (%eax),%al
  800be9:	0f b6 d0             	movzbl %al,%edx
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	0f b6 c0             	movzbl %al,%eax
  800bf4:	29 c2                	sub    %eax,%edx
  800bf6:	89 d0                	mov    %edx,%eax
}
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bfd:	eb 09                	jmp    800c08 <strncmp+0xe>
		n--, p++, q++;
  800bff:	ff 4d 10             	decl   0x10(%ebp)
  800c02:	ff 45 08             	incl   0x8(%ebp)
  800c05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c0c:	74 17                	je     800c25 <strncmp+0x2b>
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	84 c0                	test   %al,%al
  800c15:	74 0e                	je     800c25 <strncmp+0x2b>
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	8a 10                	mov    (%eax),%dl
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	38 c2                	cmp    %al,%dl
  800c23:	74 da                	je     800bff <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c29:	75 07                	jne    800c32 <strncmp+0x38>
		return 0;
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	eb 14                	jmp    800c46 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	0f b6 d0             	movzbl %al,%edx
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	0f b6 c0             	movzbl %al,%eax
  800c42:	29 c2                	sub    %eax,%edx
  800c44:	89 d0                	mov    %edx,%eax
}
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 04             	sub    $0x4,%esp
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c54:	eb 12                	jmp    800c68 <strchr+0x20>
		if (*s == c)
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c5e:	75 05                	jne    800c65 <strchr+0x1d>
			return (char *) s;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	eb 11                	jmp    800c76 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c65:	ff 45 08             	incl   0x8(%ebp)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	75 e5                	jne    800c56 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 04             	sub    $0x4,%esp
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c84:	eb 0d                	jmp    800c93 <strfind+0x1b>
		if (*s == c)
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c8e:	74 0e                	je     800c9e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c90:	ff 45 08             	incl   0x8(%ebp)
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	84 c0                	test   %al,%al
  800c9a:	75 ea                	jne    800c86 <strfind+0xe>
  800c9c:	eb 01                	jmp    800c9f <strfind+0x27>
		if (*s == c)
			break;
  800c9e:	90                   	nop
	return (char *) s;
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800cb0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cb4:	76 63                	jbe    800d19 <memset+0x75>
		uint64 data_block = c;
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	99                   	cltd   
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800cca:	c1 e0 08             	shl    $0x8,%eax
  800ccd:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cd0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800cdd:	c1 e0 10             	shl    $0x10,%eax
  800ce0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ce3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cec:	89 c2                	mov    %eax,%edx
  800cee:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cf6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800cf9:	eb 18                	jmp    800d13 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800cfb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800cfe:	8d 41 08             	lea    0x8(%ecx),%eax
  800d01:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d0a:	89 01                	mov    %eax,(%ecx)
  800d0c:	89 51 04             	mov    %edx,0x4(%ecx)
  800d0f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800d13:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d17:	77 e2                	ja     800cfb <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	74 23                	je     800d42 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d22:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d25:	eb 0e                	jmp    800d35 <memset+0x91>
			*p8++ = (uint8)c;
  800d27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2a:	8d 50 01             	lea    0x1(%eax),%edx
  800d2d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d35:	8b 45 10             	mov    0x10(%ebp),%eax
  800d38:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	75 e5                	jne    800d27 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d45:	c9                   	leave  
  800d46:	c3                   	ret    

00800d47 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d59:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d5d:	76 24                	jbe    800d83 <memcpy+0x3c>
		while(n >= 8){
  800d5f:	eb 1c                	jmp    800d7d <memcpy+0x36>
			*d64 = *s64;
  800d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d64:	8b 50 04             	mov    0x4(%eax),%edx
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d6c:	89 01                	mov    %eax,(%ecx)
  800d6e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d71:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d75:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d79:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d7d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d81:	77 de                	ja     800d61 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d87:	74 31                	je     800dba <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d95:	eb 16                	jmp    800dad <memcpy+0x66>
			*d8++ = *s8++;
  800d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800da0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da6:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800da9:	8a 12                	mov    (%edx),%dl
  800dab:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800dad:	8b 45 10             	mov    0x10(%ebp),%eax
  800db0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db3:	89 55 10             	mov    %edx,0x10(%ebp)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	75 dd                	jne    800d97 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dd7:	73 50                	jae    800e29 <memmove+0x6a>
  800dd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddf:	01 d0                	add    %edx,%eax
  800de1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de4:	76 43                	jbe    800e29 <memmove+0x6a>
		s += n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800df2:	eb 10                	jmp    800e04 <memmove+0x45>
			*--d = *--s;
  800df4:	ff 4d f8             	decl   -0x8(%ebp)
  800df7:	ff 4d fc             	decl   -0x4(%ebp)
  800dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfd:	8a 10                	mov    (%eax),%dl
  800dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e02:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e04:	8b 45 10             	mov    0x10(%ebp),%eax
  800e07:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	75 e3                	jne    800df4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e11:	eb 23                	jmp    800e36 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e16:	8d 50 01             	lea    0x1(%eax),%edx
  800e19:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e22:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e25:	8a 12                	mov    (%edx),%dl
  800e27:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	75 dd                	jne    800e13 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e4d:	eb 2a                	jmp    800e79 <memcmp+0x3e>
		if (*s1 != *s2)
  800e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e52:	8a 10                	mov    (%eax),%dl
  800e54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	38 c2                	cmp    %al,%dl
  800e5b:	74 16                	je     800e73 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	0f b6 d0             	movzbl %al,%edx
  800e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f b6 c0             	movzbl %al,%eax
  800e6d:	29 c2                	sub    %eax,%edx
  800e6f:	89 d0                	mov    %edx,%eax
  800e71:	eb 18                	jmp    800e8b <memcmp+0x50>
		s1++, s2++;
  800e73:	ff 45 fc             	incl   -0x4(%ebp)
  800e76:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 c9                	jne    800e4f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e9e:	eb 15                	jmp    800eb5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	0f b6 d0             	movzbl %al,%edx
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	0f b6 c0             	movzbl %al,%eax
  800eae:	39 c2                	cmp    %eax,%edx
  800eb0:	74 0d                	je     800ebf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eb2:	ff 45 08             	incl   0x8(%ebp)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ebb:	72 e3                	jb     800ea0 <memfind+0x13>
  800ebd:	eb 01                	jmp    800ec0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ebf:	90                   	nop
	return (void *) s;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ecb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ed2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed9:	eb 03                	jmp    800ede <strtol+0x19>
		s++;
  800edb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	3c 20                	cmp    $0x20,%al
  800ee5:	74 f4                	je     800edb <strtol+0x16>
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	3c 09                	cmp    $0x9,%al
  800eee:	74 eb                	je     800edb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3c 2b                	cmp    $0x2b,%al
  800ef7:	75 05                	jne    800efe <strtol+0x39>
		s++;
  800ef9:	ff 45 08             	incl   0x8(%ebp)
  800efc:	eb 13                	jmp    800f11 <strtol+0x4c>
	else if (*s == '-')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 2d                	cmp    $0x2d,%al
  800f05:	75 0a                	jne    800f11 <strtol+0x4c>
		s++, neg = 1;
  800f07:	ff 45 08             	incl   0x8(%ebp)
  800f0a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 06                	je     800f1d <strtol+0x58>
  800f17:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f1b:	75 20                	jne    800f3d <strtol+0x78>
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3c 30                	cmp    $0x30,%al
  800f24:	75 17                	jne    800f3d <strtol+0x78>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	40                   	inc    %eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 78                	cmp    $0x78,%al
  800f2e:	75 0d                	jne    800f3d <strtol+0x78>
		s += 2, base = 16;
  800f30:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f34:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f3b:	eb 28                	jmp    800f65 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	75 15                	jne    800f58 <strtol+0x93>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 30                	cmp    $0x30,%al
  800f4a:	75 0c                	jne    800f58 <strtol+0x93>
		s++, base = 8;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f56:	eb 0d                	jmp    800f65 <strtol+0xa0>
	else if (base == 0)
  800f58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5c:	75 07                	jne    800f65 <strtol+0xa0>
		base = 10;
  800f5e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 2f                	cmp    $0x2f,%al
  800f6c:	7e 19                	jle    800f87 <strtol+0xc2>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 39                	cmp    $0x39,%al
  800f75:	7f 10                	jg     800f87 <strtol+0xc2>
			dig = *s - '0';
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	0f be c0             	movsbl %al,%eax
  800f7f:	83 e8 30             	sub    $0x30,%eax
  800f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f85:	eb 42                	jmp    800fc9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 60                	cmp    $0x60,%al
  800f8e:	7e 19                	jle    800fa9 <strtol+0xe4>
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 7a                	cmp    $0x7a,%al
  800f97:	7f 10                	jg     800fa9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f be c0             	movsbl %al,%eax
  800fa1:	83 e8 57             	sub    $0x57,%eax
  800fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa7:	eb 20                	jmp    800fc9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 40                	cmp    $0x40,%al
  800fb0:	7e 39                	jle    800feb <strtol+0x126>
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	3c 5a                	cmp    $0x5a,%al
  800fb9:	7f 30                	jg     800feb <strtol+0x126>
			dig = *s - 'A' + 10;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f be c0             	movsbl %al,%eax
  800fc3:	83 e8 37             	sub    $0x37,%eax
  800fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fcc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fcf:	7d 19                	jge    800fea <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fd1:	ff 45 08             	incl   0x8(%ebp)
  800fd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fdb:	89 c2                	mov    %eax,%edx
  800fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fe5:	e9 7b ff ff ff       	jmp    800f65 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fea:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800feb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fef:	74 08                	je     800ff9 <strtol+0x134>
		*endptr = (char *) s;
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ff9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ffd:	74 07                	je     801006 <strtol+0x141>
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801002:	f7 d8                	neg    %eax
  801004:	eb 03                	jmp    801009 <strtol+0x144>
  801006:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <ltostr>:

void
ltostr(long value, char *str)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801011:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801018:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80101f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801023:	79 13                	jns    801038 <ltostr+0x2d>
	{
		neg = 1;
  801025:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801032:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801035:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801040:	99                   	cltd   
  801041:	f7 f9                	idiv   %ecx
  801043:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	8d 50 01             	lea    0x1(%eax),%edx
  80104c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104f:	89 c2                	mov    %eax,%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	01 d0                	add    %edx,%eax
  801056:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801059:	83 c2 30             	add    $0x30,%edx
  80105c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80105e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801061:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801066:	f7 e9                	imul   %ecx
  801068:	c1 fa 02             	sar    $0x2,%edx
  80106b:	89 c8                	mov    %ecx,%eax
  80106d:	c1 f8 1f             	sar    $0x1f,%eax
  801070:	29 c2                	sub    %eax,%edx
  801072:	89 d0                	mov    %edx,%eax
  801074:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801077:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80107b:	75 bb                	jne    801038 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80107d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801087:	48                   	dec    %eax
  801088:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80108b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108f:	74 3d                	je     8010ce <ltostr+0xc3>
		start = 1 ;
  801091:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801098:	eb 34                	jmp    8010ce <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80109a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a0:	01 d0                	add    %edx,%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ad:	01 c2                	add    %eax,%edx
  8010af:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 c8                	add    %ecx,%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	01 c2                	add    %eax,%edx
  8010c3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010c6:	88 02                	mov    %al,(%edx)
		start++ ;
  8010c8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010cb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010d4:	7c c4                	jl     80109a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
  8010de:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010e1:	90                   	nop
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010ea:	ff 75 08             	pushl  0x8(%ebp)
  8010ed:	e8 c4 f9 ff ff       	call   800ab6 <strlen>
  8010f2:	83 c4 04             	add    $0x4,%esp
  8010f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010f8:	ff 75 0c             	pushl  0xc(%ebp)
  8010fb:	e8 b6 f9 ff ff       	call   800ab6 <strlen>
  801100:	83 c4 04             	add    $0x4,%esp
  801103:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80110d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801114:	eb 17                	jmp    80112d <strcconcat+0x49>
		final[s] = str1[s] ;
  801116:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801119:	8b 45 10             	mov    0x10(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	01 c8                	add    %ecx,%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80112a:	ff 45 fc             	incl   -0x4(%ebp)
  80112d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801130:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801133:	7c e1                	jl     801116 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801135:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80113c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801143:	eb 1f                	jmp    801164 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801145:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801148:	8d 50 01             	lea    0x1(%eax),%edx
  80114b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80114e:	89 c2                	mov    %eax,%edx
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801161:	ff 45 f8             	incl   -0x8(%ebp)
  801164:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801167:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80116a:	7c d9                	jl     801145 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80116c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	01 d0                	add    %edx,%eax
  801174:	c6 00 00             	movb   $0x0,(%eax)
}
  801177:	90                   	nop
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80117d:	8b 45 14             	mov    0x14(%ebp),%eax
  801180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801186:	8b 45 14             	mov    0x14(%ebp),%eax
  801189:	8b 00                	mov    (%eax),%eax
  80118b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	01 d0                	add    %edx,%eax
  801197:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80119d:	eb 0c                	jmp    8011ab <strsplit+0x31>
			*string++ = 0;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8d 50 01             	lea    0x1(%eax),%edx
  8011a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8011a8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	84 c0                	test   %al,%al
  8011b2:	74 18                	je     8011cc <strsplit+0x52>
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f be c0             	movsbl %al,%eax
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	e8 83 fa ff ff       	call   800c48 <strchr>
  8011c5:	83 c4 08             	add    $0x8,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	75 d3                	jne    80119f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	84 c0                	test   %al,%al
  8011d3:	74 5a                	je     80122f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	8b 00                	mov    (%eax),%eax
  8011da:	83 f8 0f             	cmp    $0xf,%eax
  8011dd:	75 07                	jne    8011e6 <strsplit+0x6c>
		{
			return 0;
  8011df:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e4:	eb 66                	jmp    80124c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8011ee:	8b 55 14             	mov    0x14(%ebp),%edx
  8011f1:	89 0a                	mov    %ecx,(%edx)
  8011f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fd:	01 c2                	add    %eax,%edx
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801204:	eb 03                	jmp    801209 <strsplit+0x8f>
			string++;
  801206:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 8b                	je     80119d <strsplit+0x23>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	0f be c0             	movsbl %al,%eax
  80121a:	50                   	push   %eax
  80121b:	ff 75 0c             	pushl  0xc(%ebp)
  80121e:	e8 25 fa ff ff       	call   800c48 <strchr>
  801223:	83 c4 08             	add    $0x8,%esp
  801226:	85 c0                	test   %eax,%eax
  801228:	74 dc                	je     801206 <strsplit+0x8c>
			string++;
	}
  80122a:	e9 6e ff ff ff       	jmp    80119d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80122f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801230:	8b 45 14             	mov    0x14(%ebp),%eax
  801233:	8b 00                	mov    (%eax),%eax
  801235:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123c:	8b 45 10             	mov    0x10(%ebp),%eax
  80123f:	01 d0                	add    %edx,%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801247:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80125a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801261:	eb 4a                	jmp    8012ad <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801263:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801277:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	3c 40                	cmp    $0x40,%al
  801283:	7e 25                	jle    8012aa <str2lower+0x5c>
  801285:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	3c 5a                	cmp    $0x5a,%al
  801291:	7f 17                	jg     8012aa <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801293:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	01 d0                	add    %edx,%eax
  80129b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129e:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a1:	01 ca                	add    %ecx,%edx
  8012a3:	8a 12                	mov    (%edx),%dl
  8012a5:	83 c2 20             	add    $0x20,%edx
  8012a8:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	ff 75 0c             	pushl  0xc(%ebp)
  8012b0:	e8 01 f8 ff ff       	call   800ab6 <strlen>
  8012b5:	83 c4 04             	add    $0x4,%esp
  8012b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012bb:	7f a6                	jg     801263 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8012bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    

008012c2 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8012c8:	a1 08 40 80 00       	mov    0x804008,%eax
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	74 42                	je     801313 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8012d1:	83 ec 08             	sub    $0x8,%esp
  8012d4:	68 00 00 00 82       	push   $0x82000000
  8012d9:	68 00 00 00 80       	push   $0x80000000
  8012de:	e8 00 08 00 00       	call   801ae3 <initialize_dynamic_allocator>
  8012e3:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8012e6:	e8 e7 05 00 00       	call   8018d2 <sys_get_uheap_strategy>
  8012eb:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8012f0:	a1 40 40 80 00       	mov    0x804040,%eax
  8012f5:	05 00 10 00 00       	add    $0x1000,%eax
  8012fa:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8012ff:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801304:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801309:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801310:	00 00 00 
	}
}
  801313:	90                   	nop
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801325:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132a:	83 ec 08             	sub    $0x8,%esp
  80132d:	68 06 04 00 00       	push   $0x406
  801332:	50                   	push   %eax
  801333:	e8 e4 01 00 00       	call   80151c <__sys_allocate_page>
  801338:	83 c4 10             	add    $0x10,%esp
  80133b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80133e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801342:	79 14                	jns    801358 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	68 48 2e 80 00       	push   $0x802e48
  80134c:	6a 1f                	push   $0x1f
  80134e:	68 84 2e 80 00       	push   $0x802e84
  801353:	e8 72 11 00 00       	call   8024ca <_panic>
	return 0;
  801358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801373:	83 ec 0c             	sub    $0xc,%esp
  801376:	50                   	push   %eax
  801377:	e8 e7 01 00 00       	call   801563 <__sys_unmap_frame>
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801382:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801386:	79 14                	jns    80139c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	68 90 2e 80 00       	push   $0x802e90
  801390:	6a 2a                	push   $0x2a
  801392:	68 84 2e 80 00       	push   $0x802e84
  801397:	e8 2e 11 00 00       	call   8024ca <_panic>
}
  80139c:	90                   	nop
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8013a5:	e8 18 ff ff ff       	call   8012c2 <uheap_init>
	if (size == 0) return NULL ;
  8013aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ae:	75 07                	jne    8013b7 <malloc+0x18>
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b5:	eb 14                	jmp    8013cb <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8013b7:	83 ec 04             	sub    $0x4,%esp
  8013ba:	68 d0 2e 80 00       	push   $0x802ed0
  8013bf:	6a 3e                	push   $0x3e
  8013c1:	68 84 2e 80 00       	push   $0x802e84
  8013c6:	e8 ff 10 00 00       	call   8024ca <_panic>
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	68 f8 2e 80 00       	push   $0x802ef8
  8013db:	6a 49                	push   $0x49
  8013dd:	68 84 2e 80 00       	push   $0x802e84
  8013e2:	e8 e3 10 00 00       	call   8024ca <_panic>

008013e7 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 18             	sub    $0x18,%esp
  8013ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f0:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8013f3:	e8 ca fe ff ff       	call   8012c2 <uheap_init>
	if (size == 0) return NULL ;
  8013f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013fc:	75 07                	jne    801405 <smalloc+0x1e>
  8013fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801403:	eb 14                	jmp    801419 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801405:	83 ec 04             	sub    $0x4,%esp
  801408:	68 1c 2f 80 00       	push   $0x802f1c
  80140d:	6a 5a                	push   $0x5a
  80140f:	68 84 2e 80 00       	push   $0x802e84
  801414:	e8 b1 10 00 00       	call   8024ca <_panic>
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801421:	e8 9c fe ff ff       	call   8012c2 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801426:	83 ec 04             	sub    $0x4,%esp
  801429:	68 44 2f 80 00       	push   $0x802f44
  80142e:	6a 6a                	push   $0x6a
  801430:	68 84 2e 80 00       	push   $0x802e84
  801435:	e8 90 10 00 00       	call   8024ca <_panic>

0080143a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801440:	e8 7d fe ff ff       	call   8012c2 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 68 2f 80 00       	push   $0x802f68
  80144d:	68 88 00 00 00       	push   $0x88
  801452:	68 84 2e 80 00       	push   $0x802e84
  801457:	e8 6e 10 00 00       	call   8024ca <_panic>

0080145c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	68 90 2f 80 00       	push   $0x802f90
  80146a:	68 9b 00 00 00       	push   $0x9b
  80146f:	68 84 2e 80 00       	push   $0x802e84
  801474:	e8 51 10 00 00       	call   8024ca <_panic>

00801479 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	57                   	push   %edi
  80147d:	56                   	push   %esi
  80147e:	53                   	push   %ebx
  80147f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8b 55 0c             	mov    0xc(%ebp),%edx
  801488:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80148b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80148e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801491:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801494:	cd 30                	int    $0x30
  801496:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801499:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	5b                   	pop    %ebx
  8014a0:	5e                   	pop    %esi
  8014a1:	5f                   	pop    %edi
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	6a 00                	push   $0x0
  8014bc:	51                   	push   %ecx
  8014bd:	52                   	push   %edx
  8014be:	ff 75 0c             	pushl  0xc(%ebp)
  8014c1:	50                   	push   %eax
  8014c2:	6a 00                	push   $0x0
  8014c4:	e8 b0 ff ff ff       	call   801479 <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	90                   	nop
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 02                	push   $0x2
  8014de:	e8 96 ff ff ff       	call   801479 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 03                	push   $0x3
  8014f7:	e8 7d ff ff ff       	call   801479 <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	90                   	nop
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 04                	push   $0x4
  801511:	e8 63 ff ff ff       	call   801479 <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	90                   	nop
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80151f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	52                   	push   %edx
  80152c:	50                   	push   %eax
  80152d:	6a 08                	push   $0x8
  80152f:	e8 45 ff ff ff       	call   801479 <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	56                   	push   %esi
  80153d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80153e:	8b 75 18             	mov    0x18(%ebp),%esi
  801541:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801544:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801547:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
  80154f:	51                   	push   %ecx
  801550:	52                   	push   %edx
  801551:	50                   	push   %eax
  801552:	6a 09                	push   $0x9
  801554:	e8 20 ff ff ff       	call   801479 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    

00801563 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	6a 0a                	push   $0xa
  801573:	e8 01 ff ff ff       	call   801479 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	ff 75 08             	pushl  0x8(%ebp)
  80158c:	6a 0b                	push   $0xb
  80158e:	e8 e6 fe ff ff       	call   801479 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 0c                	push   $0xc
  8015a7:	e8 cd fe ff ff       	call   801479 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 0d                	push   $0xd
  8015c0:	e8 b4 fe ff ff       	call   801479 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 0e                	push   $0xe
  8015d9:	e8 9b fe ff ff       	call   801479 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 0f                	push   $0xf
  8015f2:	e8 82 fe ff ff       	call   801479 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	ff 75 08             	pushl  0x8(%ebp)
  80160a:	6a 10                	push   $0x10
  80160c:	e8 68 fe ff ff       	call   801479 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 11                	push   $0x11
  801625:	e8 4f fe ff ff       	call   801479 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	90                   	nop
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_cputc>:

void
sys_cputc(const char c)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80163c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	50                   	push   %eax
  801649:	6a 01                	push   $0x1
  80164b:	e8 29 fe ff ff       	call   801479 <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	90                   	nop
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 14                	push   $0x14
  801665:	e8 0f fe ff ff       	call   801479 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	90                   	nop
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80167c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80167f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	51                   	push   %ecx
  801689:	52                   	push   %edx
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	50                   	push   %eax
  80168e:	6a 15                	push   $0x15
  801690:	e8 e4 fd ff ff       	call   801479 <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	52                   	push   %edx
  8016aa:	50                   	push   %eax
  8016ab:	6a 16                	push   $0x16
  8016ad:	e8 c7 fd ff ff       	call   801479 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	51                   	push   %ecx
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	6a 17                	push   $0x17
  8016cc:	e8 a8 fd ff ff       	call   801479 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	6a 18                	push   $0x18
  8016e9:	e8 8b fd ff ff       	call   801479 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	ff 75 14             	pushl  0x14(%ebp)
  8016fe:	ff 75 10             	pushl  0x10(%ebp)
  801701:	ff 75 0c             	pushl  0xc(%ebp)
  801704:	50                   	push   %eax
  801705:	6a 19                	push   $0x19
  801707:	e8 6d fd ff ff       	call   801479 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	50                   	push   %eax
  801720:	6a 1a                	push   $0x1a
  801722:	e8 52 fd ff ff       	call   801479 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	90                   	nop
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	50                   	push   %eax
  80173c:	6a 1b                	push   $0x1b
  80173e:	e8 36 fd ff ff       	call   801479 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 05                	push   $0x5
  801757:	e8 1d fd ff ff       	call   801479 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 06                	push   $0x6
  801770:	e8 04 fd ff ff       	call   801479 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 07                	push   $0x7
  801789:	e8 eb fc ff ff       	call   801479 <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_exit_env>:


void sys_exit_env(void)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 1c                	push   $0x1c
  8017a2:	e8 d2 fc ff ff       	call   801479 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	90                   	nop
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017b3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b6:	8d 50 04             	lea    0x4(%eax),%edx
  8017b9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	52                   	push   %edx
  8017c3:	50                   	push   %eax
  8017c4:	6a 1d                	push   $0x1d
  8017c6:	e8 ae fc ff ff       	call   801479 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d7:	89 01                	mov    %eax,(%ecx)
  8017d9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	c9                   	leave  
  8017e0:	c2 04 00             	ret    $0x4

008017e3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	ff 75 10             	pushl  0x10(%ebp)
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	6a 13                	push   $0x13
  8017f5:	e8 7f fc ff ff       	call   801479 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fd:	90                   	nop
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_rcr2>:
uint32 sys_rcr2()
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 1e                	push   $0x1e
  80180f:	e8 65 fc ff ff       	call   801479 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 04             	sub    $0x4,%esp
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801825:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	50                   	push   %eax
  801832:	6a 1f                	push   $0x1f
  801834:	e8 40 fc ff ff       	call   801479 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
	return ;
  80183c:	90                   	nop
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <rsttst>:
void rsttst()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 21                	push   $0x21
  80184e:	e8 26 fc ff ff       	call   801479 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
	return ;
  801856:	90                   	nop
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	8b 45 14             	mov    0x14(%ebp),%eax
  801862:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801865:	8b 55 18             	mov    0x18(%ebp),%edx
  801868:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80186c:	52                   	push   %edx
  80186d:	50                   	push   %eax
  80186e:	ff 75 10             	pushl  0x10(%ebp)
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	ff 75 08             	pushl  0x8(%ebp)
  801877:	6a 20                	push   $0x20
  801879:	e8 fb fb ff ff       	call   801479 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
	return ;
  801881:	90                   	nop
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <chktst>:
void chktst(uint32 n)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	6a 22                	push   $0x22
  801894:	e8 e0 fb ff ff       	call   801479 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
	return ;
  80189c:	90                   	nop
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <inctst>:

void inctst()
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 23                	push   $0x23
  8018ae:	e8 c6 fb ff ff       	call   801479 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b6:	90                   	nop
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <gettst>:
uint32 gettst()
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 24                	push   $0x24
  8018c8:	e8 ac fb ff ff       	call   801479 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 25                	push   $0x25
  8018e1:	e8 93 fb ff ff       	call   801479 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
  8018e9:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8018ee:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	ff 75 08             	pushl  0x8(%ebp)
  80190b:	6a 26                	push   $0x26
  80190d:	e8 67 fb ff ff       	call   801479 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
	return ;
  801915:	90                   	nop
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80191c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	6a 00                	push   $0x0
  80192a:	53                   	push   %ebx
  80192b:	51                   	push   %ecx
  80192c:	52                   	push   %edx
  80192d:	50                   	push   %eax
  80192e:	6a 27                	push   $0x27
  801930:	e8 44 fb ff ff       	call   801479 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801940:	8b 55 0c             	mov    0xc(%ebp),%edx
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 28                	push   $0x28
  801950:	e8 24 fb ff ff       	call   801479 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80195d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801960:	8b 55 0c             	mov    0xc(%ebp),%edx
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	6a 00                	push   $0x0
  801968:	51                   	push   %ecx
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	52                   	push   %edx
  80196d:	50                   	push   %eax
  80196e:	6a 29                	push   $0x29
  801970:	e8 04 fb ff ff       	call   801479 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 10             	pushl  0x10(%ebp)
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	6a 12                	push   $0x12
  80198c:	e8 e8 fa ff ff       	call   801479 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
	return ;
  801994:	90                   	nop
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	6a 2a                	push   $0x2a
  8019aa:	e8 ca fa ff ff       	call   801479 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
	return;
  8019b2:	90                   	nop
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 2b                	push   $0x2b
  8019c4:	e8 b0 fa ff ff       	call   801479 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 2d                	push   $0x2d
  8019df:	e8 95 fa ff ff       	call   801479 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	ff 75 08             	pushl  0x8(%ebp)
  8019f9:	6a 2c                	push   $0x2c
  8019fb:	e8 79 fa ff ff       	call   801479 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
	return ;
  801a03:	90                   	nop
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 b4 2f 80 00       	push   $0x802fb4
  801a14:	68 25 01 00 00       	push   $0x125
  801a19:	68 e7 2f 80 00       	push   $0x802fe7
  801a1e:	e8 a7 0a 00 00       	call   8024ca <_panic>

00801a23 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801a29:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801a30:	72 09                	jb     801a3b <to_page_va+0x18>
  801a32:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801a39:	72 14                	jb     801a4f <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	68 f8 2f 80 00       	push   $0x802ff8
  801a43:	6a 15                	push   $0x15
  801a45:	68 23 30 80 00       	push   $0x803023
  801a4a:	e8 7b 0a 00 00       	call   8024ca <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	ba 60 40 80 00       	mov    $0x804060,%edx
  801a57:	29 d0                	sub    %edx,%eax
  801a59:	c1 f8 02             	sar    $0x2,%eax
  801a5c:	89 c2                	mov    %eax,%edx
  801a5e:	89 d0                	mov    %edx,%eax
  801a60:	c1 e0 02             	shl    $0x2,%eax
  801a63:	01 d0                	add    %edx,%eax
  801a65:	c1 e0 02             	shl    $0x2,%eax
  801a68:	01 d0                	add    %edx,%eax
  801a6a:	c1 e0 02             	shl    $0x2,%eax
  801a6d:	01 d0                	add    %edx,%eax
  801a6f:	89 c1                	mov    %eax,%ecx
  801a71:	c1 e1 08             	shl    $0x8,%ecx
  801a74:	01 c8                	add    %ecx,%eax
  801a76:	89 c1                	mov    %eax,%ecx
  801a78:	c1 e1 10             	shl    $0x10,%ecx
  801a7b:	01 c8                	add    %ecx,%eax
  801a7d:	01 c0                	add    %eax,%eax
  801a7f:	01 d0                	add    %edx,%eax
  801a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a87:	c1 e0 0c             	shl    $0xc,%eax
  801a8a:	89 c2                	mov    %eax,%edx
  801a8c:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801a91:	01 d0                	add    %edx,%eax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801a9b:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa3:	29 c2                	sub    %eax,%edx
  801aa5:	89 d0                	mov    %edx,%eax
  801aa7:	c1 e8 0c             	shr    $0xc,%eax
  801aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ab1:	78 09                	js     801abc <to_page_info+0x27>
  801ab3:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801aba:	7e 14                	jle    801ad0 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	68 3c 30 80 00       	push   $0x80303c
  801ac4:	6a 22                	push   $0x22
  801ac6:	68 23 30 80 00       	push   $0x803023
  801acb:	e8 fa 09 00 00       	call   8024ca <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad3:	89 d0                	mov    %edx,%eax
  801ad5:	01 c0                	add    %eax,%eax
  801ad7:	01 d0                	add    %edx,%eax
  801ad9:	c1 e0 02             	shl    $0x2,%eax
  801adc:	05 60 40 80 00       	add    $0x804060,%eax
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	05 00 00 00 02       	add    $0x2000000,%eax
  801af1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801af4:	73 16                	jae    801b0c <initialize_dynamic_allocator+0x29>
  801af6:	68 60 30 80 00       	push   $0x803060
  801afb:	68 86 30 80 00       	push   $0x803086
  801b00:	6a 34                	push   $0x34
  801b02:	68 23 30 80 00       	push   $0x803023
  801b07:	e8 be 09 00 00       	call   8024ca <_panic>
		is_initialized = 1;
  801b0c:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801b13:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b21:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801b26:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801b2d:	00 00 00 
  801b30:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801b37:	00 00 00 
  801b3a:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801b41:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	2b 45 08             	sub    0x8(%ebp),%eax
  801b4a:	c1 e8 0c             	shr    $0xc,%eax
  801b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801b57:	e9 c8 00 00 00       	jmp    801c24 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5f:	89 d0                	mov    %edx,%eax
  801b61:	01 c0                	add    %eax,%eax
  801b63:	01 d0                	add    %edx,%eax
  801b65:	c1 e0 02             	shl    $0x2,%eax
  801b68:	05 68 40 80 00       	add    $0x804068,%eax
  801b6d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b75:	89 d0                	mov    %edx,%eax
  801b77:	01 c0                	add    %eax,%eax
  801b79:	01 d0                	add    %edx,%eax
  801b7b:	c1 e0 02             	shl    $0x2,%eax
  801b7e:	05 6a 40 80 00       	add    $0x80406a,%eax
  801b83:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801b88:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801b8e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801b91:	89 c8                	mov    %ecx,%eax
  801b93:	01 c0                	add    %eax,%eax
  801b95:	01 c8                	add    %ecx,%eax
  801b97:	c1 e0 02             	shl    $0x2,%eax
  801b9a:	05 64 40 80 00       	add    $0x804064,%eax
  801b9f:	89 10                	mov    %edx,(%eax)
  801ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba4:	89 d0                	mov    %edx,%eax
  801ba6:	01 c0                	add    %eax,%eax
  801ba8:	01 d0                	add    %edx,%eax
  801baa:	c1 e0 02             	shl    $0x2,%eax
  801bad:	05 64 40 80 00       	add    $0x804064,%eax
  801bb2:	8b 00                	mov    (%eax),%eax
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	74 1b                	je     801bd3 <initialize_dynamic_allocator+0xf0>
  801bb8:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801bbe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801bc1:	89 c8                	mov    %ecx,%eax
  801bc3:	01 c0                	add    %eax,%eax
  801bc5:	01 c8                	add    %ecx,%eax
  801bc7:	c1 e0 02             	shl    $0x2,%eax
  801bca:	05 60 40 80 00       	add    $0x804060,%eax
  801bcf:	89 02                	mov    %eax,(%edx)
  801bd1:	eb 16                	jmp    801be9 <initialize_dynamic_allocator+0x106>
  801bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd6:	89 d0                	mov    %edx,%eax
  801bd8:	01 c0                	add    %eax,%eax
  801bda:	01 d0                	add    %edx,%eax
  801bdc:	c1 e0 02             	shl    $0x2,%eax
  801bdf:	05 60 40 80 00       	add    $0x804060,%eax
  801be4:	a3 48 40 80 00       	mov    %eax,0x804048
  801be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bec:	89 d0                	mov    %edx,%eax
  801bee:	01 c0                	add    %eax,%eax
  801bf0:	01 d0                	add    %edx,%eax
  801bf2:	c1 e0 02             	shl    $0x2,%eax
  801bf5:	05 60 40 80 00       	add    $0x804060,%eax
  801bfa:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801bff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c02:	89 d0                	mov    %edx,%eax
  801c04:	01 c0                	add    %eax,%eax
  801c06:	01 d0                	add    %edx,%eax
  801c08:	c1 e0 02             	shl    $0x2,%eax
  801c0b:	05 60 40 80 00       	add    $0x804060,%eax
  801c10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c16:	a1 54 40 80 00       	mov    0x804054,%eax
  801c1b:	40                   	inc    %eax
  801c1c:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801c21:	ff 45 f4             	incl   -0xc(%ebp)
  801c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c27:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801c2a:	0f 8c 2c ff ff ff    	jl     801b5c <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801c30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801c37:	eb 36                	jmp    801c6f <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3c:	c1 e0 04             	shl    $0x4,%eax
  801c3f:	05 80 c0 81 00       	add    $0x81c080,%eax
  801c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4d:	c1 e0 04             	shl    $0x4,%eax
  801c50:	05 84 c0 81 00       	add    $0x81c084,%eax
  801c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5e:	c1 e0 04             	shl    $0x4,%eax
  801c61:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801c66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801c6c:	ff 45 f0             	incl   -0x10(%ebp)
  801c6f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801c73:	7e c4                	jle    801c39 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801c75:	90                   	nop
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	50                   	push   %eax
  801c85:	e8 0b fe ff ff       	call   801a95 <to_page_info>
  801c8a:	83 c4 10             	add    $0x10,%esp
  801c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c93:	8b 40 08             	mov    0x8(%eax),%eax
  801c96:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801ca1:	83 ec 0c             	sub    $0xc,%esp
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	e8 77 fd ff ff       	call   801a23 <to_page_va>
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801cb2:	b8 00 10 00 00       	mov    $0x1000,%eax
  801cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbc:	f7 75 08             	divl   0x8(%ebp)
  801cbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc5:	83 ec 0c             	sub    $0xc,%esp
  801cc8:	50                   	push   %eax
  801cc9:	e8 48 f6 ff ff       	call   801316 <get_page>
  801cce:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd7:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce1:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801ce5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801cec:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801cf3:	eb 19                	jmp    801d0e <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf8:	ba 01 00 00 00       	mov    $0x1,%edx
  801cfd:	88 c1                	mov    %al,%cl
  801cff:	d3 e2                	shl    %cl,%edx
  801d01:	89 d0                	mov    %edx,%eax
  801d03:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d06:	74 0e                	je     801d16 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801d08:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801d0b:	ff 45 f0             	incl   -0x10(%ebp)
  801d0e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801d12:	7e e1                	jle    801cf5 <split_page_to_blocks+0x5a>
  801d14:	eb 01                	jmp    801d17 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801d16:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801d17:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d1e:	e9 a7 00 00 00       	jmp    801dca <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d26:	0f af 45 08          	imul   0x8(%ebp),%eax
  801d2a:	89 c2                	mov    %eax,%edx
  801d2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d2f:	01 d0                	add    %edx,%eax
  801d31:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801d34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d38:	75 14                	jne    801d4e <split_page_to_blocks+0xb3>
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	68 9c 30 80 00       	push   $0x80309c
  801d42:	6a 7c                	push   $0x7c
  801d44:	68 23 30 80 00       	push   $0x803023
  801d49:	e8 7c 07 00 00       	call   8024ca <_panic>
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	c1 e0 04             	shl    $0x4,%eax
  801d54:	05 84 c0 81 00       	add    $0x81c084,%eax
  801d59:	8b 10                	mov    (%eax),%edx
  801d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d5e:	89 50 04             	mov    %edx,0x4(%eax)
  801d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d64:	8b 40 04             	mov    0x4(%eax),%eax
  801d67:	85 c0                	test   %eax,%eax
  801d69:	74 14                	je     801d7f <split_page_to_blocks+0xe4>
  801d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6e:	c1 e0 04             	shl    $0x4,%eax
  801d71:	05 84 c0 81 00       	add    $0x81c084,%eax
  801d76:	8b 00                	mov    (%eax),%eax
  801d78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d7b:	89 10                	mov    %edx,(%eax)
  801d7d:	eb 11                	jmp    801d90 <split_page_to_blocks+0xf5>
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	c1 e0 04             	shl    $0x4,%eax
  801d85:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8e:	89 02                	mov    %eax,(%edx)
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	c1 e0 04             	shl    $0x4,%eax
  801d96:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d9f:	89 02                	mov    %eax,(%edx)
  801da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	c1 e0 04             	shl    $0x4,%eax
  801db0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801db5:	8b 00                	mov    (%eax),%eax
  801db7:	8d 50 01             	lea    0x1(%eax),%edx
  801dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbd:	c1 e0 04             	shl    $0x4,%eax
  801dc0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801dc5:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801dc7:	ff 45 ec             	incl   -0x14(%ebp)
  801dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801dd0:	0f 82 4d ff ff ff    	jb     801d23 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  801dd6:	90                   	nop
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801ddf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801de6:	76 19                	jbe    801e01 <alloc_block+0x28>
  801de8:	68 c0 30 80 00       	push   $0x8030c0
  801ded:	68 86 30 80 00       	push   $0x803086
  801df2:	68 8a 00 00 00       	push   $0x8a
  801df7:	68 23 30 80 00       	push   $0x803023
  801dfc:	e8 c9 06 00 00       	call   8024ca <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  801e01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801e08:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801e0f:	eb 19                	jmp    801e2a <alloc_block+0x51>
		if((1 << i) >= size) break;
  801e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e14:	ba 01 00 00 00       	mov    $0x1,%edx
  801e19:	88 c1                	mov    %al,%cl
  801e1b:	d3 e2                	shl    %cl,%edx
  801e1d:	89 d0                	mov    %edx,%eax
  801e1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e22:	73 0e                	jae    801e32 <alloc_block+0x59>
		idx++;
  801e24:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  801e27:	ff 45 f0             	incl   -0x10(%ebp)
  801e2a:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801e2e:	7e e1                	jle    801e11 <alloc_block+0x38>
  801e30:	eb 01                	jmp    801e33 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  801e32:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  801e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e36:	c1 e0 04             	shl    $0x4,%eax
  801e39:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801e3e:	8b 00                	mov    (%eax),%eax
  801e40:	85 c0                	test   %eax,%eax
  801e42:	0f 84 df 00 00 00    	je     801f27 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	c1 e0 04             	shl    $0x4,%eax
  801e4e:	05 80 c0 81 00       	add    $0x81c080,%eax
  801e53:	8b 00                	mov    (%eax),%eax
  801e55:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  801e58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e5c:	75 17                	jne    801e75 <alloc_block+0x9c>
  801e5e:	83 ec 04             	sub    $0x4,%esp
  801e61:	68 e1 30 80 00       	push   $0x8030e1
  801e66:	68 9e 00 00 00       	push   $0x9e
  801e6b:	68 23 30 80 00       	push   $0x803023
  801e70:	e8 55 06 00 00       	call   8024ca <_panic>
  801e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e78:	8b 00                	mov    (%eax),%eax
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	74 10                	je     801e8e <alloc_block+0xb5>
  801e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e81:	8b 00                	mov    (%eax),%eax
  801e83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e86:	8b 52 04             	mov    0x4(%edx),%edx
  801e89:	89 50 04             	mov    %edx,0x4(%eax)
  801e8c:	eb 14                	jmp    801ea2 <alloc_block+0xc9>
  801e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e91:	8b 40 04             	mov    0x4(%eax),%eax
  801e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e97:	c1 e2 04             	shl    $0x4,%edx
  801e9a:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  801ea0:	89 02                	mov    %eax,(%edx)
  801ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea5:	8b 40 04             	mov    0x4(%eax),%eax
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	74 0f                	je     801ebb <alloc_block+0xe2>
  801eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eaf:	8b 40 04             	mov    0x4(%eax),%eax
  801eb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801eb5:	8b 12                	mov    (%edx),%edx
  801eb7:	89 10                	mov    %edx,(%eax)
  801eb9:	eb 13                	jmp    801ece <alloc_block+0xf5>
  801ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebe:	8b 00                	mov    (%eax),%eax
  801ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec3:	c1 e2 04             	shl    $0x4,%edx
  801ec6:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  801ecc:	89 02                	mov    %eax,(%edx)
  801ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	c1 e0 04             	shl    $0x4,%eax
  801ee7:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801eec:	8b 00                	mov    (%eax),%eax
  801eee:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef4:	c1 e0 04             	shl    $0x4,%eax
  801ef7:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801efc:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  801efe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	50                   	push   %eax
  801f05:	e8 8b fb ff ff       	call   801a95 <to_page_info>
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  801f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f13:	66 8b 40 0a          	mov    0xa(%eax),%ax
  801f17:	48                   	dec    %eax
  801f18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f1b:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  801f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f22:	e9 bc 02 00 00       	jmp    8021e3 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  801f27:	a1 54 40 80 00       	mov    0x804054,%eax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 84 7d 02 00 00    	je     8021b1 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  801f34:	a1 48 40 80 00       	mov    0x804048,%eax
  801f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  801f3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f40:	75 17                	jne    801f59 <alloc_block+0x180>
  801f42:	83 ec 04             	sub    $0x4,%esp
  801f45:	68 e1 30 80 00       	push   $0x8030e1
  801f4a:	68 a9 00 00 00       	push   $0xa9
  801f4f:	68 23 30 80 00       	push   $0x803023
  801f54:	e8 71 05 00 00       	call   8024ca <_panic>
  801f59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f5c:	8b 00                	mov    (%eax),%eax
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	74 10                	je     801f72 <alloc_block+0x199>
  801f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f6a:	8b 52 04             	mov    0x4(%edx),%edx
  801f6d:	89 50 04             	mov    %edx,0x4(%eax)
  801f70:	eb 0b                	jmp    801f7d <alloc_block+0x1a4>
  801f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f75:	8b 40 04             	mov    0x4(%eax),%eax
  801f78:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f80:	8b 40 04             	mov    0x4(%eax),%eax
  801f83:	85 c0                	test   %eax,%eax
  801f85:	74 0f                	je     801f96 <alloc_block+0x1bd>
  801f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f8a:	8b 40 04             	mov    0x4(%eax),%eax
  801f8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f90:	8b 12                	mov    (%edx),%edx
  801f92:	89 10                	mov    %edx,(%eax)
  801f94:	eb 0a                	jmp    801fa0 <alloc_block+0x1c7>
  801f96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	a3 48 40 80 00       	mov    %eax,0x804048
  801fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb3:	a1 54 40 80 00       	mov    0x804054,%eax
  801fb8:	48                   	dec    %eax
  801fb9:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	83 c0 03             	add    $0x3,%eax
  801fc4:	ba 01 00 00 00       	mov    $0x1,%edx
  801fc9:	88 c1                	mov    %al,%cl
  801fcb:	d3 e2                	shl    %cl,%edx
  801fcd:	89 d0                	mov    %edx,%eax
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fd5:	50                   	push   %eax
  801fd6:	e8 c0 fc ff ff       	call   801c9b <split_page_to_blocks>
  801fdb:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	c1 e0 04             	shl    $0x4,%eax
  801fe4:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fe9:	8b 00                	mov    (%eax),%eax
  801feb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  801fee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ff2:	75 17                	jne    80200b <alloc_block+0x232>
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 e1 30 80 00       	push   $0x8030e1
  801ffc:	68 b0 00 00 00       	push   $0xb0
  802001:	68 23 30 80 00       	push   $0x803023
  802006:	e8 bf 04 00 00       	call   8024ca <_panic>
  80200b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80200e:	8b 00                	mov    (%eax),%eax
  802010:	85 c0                	test   %eax,%eax
  802012:	74 10                	je     802024 <alloc_block+0x24b>
  802014:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802017:	8b 00                	mov    (%eax),%eax
  802019:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80201c:	8b 52 04             	mov    0x4(%edx),%edx
  80201f:	89 50 04             	mov    %edx,0x4(%eax)
  802022:	eb 14                	jmp    802038 <alloc_block+0x25f>
  802024:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802027:	8b 40 04             	mov    0x4(%eax),%eax
  80202a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202d:	c1 e2 04             	shl    $0x4,%edx
  802030:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802036:	89 02                	mov    %eax,(%edx)
  802038:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80203b:	8b 40 04             	mov    0x4(%eax),%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	74 0f                	je     802051 <alloc_block+0x278>
  802042:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802045:	8b 40 04             	mov    0x4(%eax),%eax
  802048:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80204b:	8b 12                	mov    (%edx),%edx
  80204d:	89 10                	mov    %edx,(%eax)
  80204f:	eb 13                	jmp    802064 <alloc_block+0x28b>
  802051:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802054:	8b 00                	mov    (%eax),%eax
  802056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802059:	c1 e2 04             	shl    $0x4,%edx
  80205c:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802062:	89 02                	mov    %eax,(%edx)
  802064:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802067:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80206d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207a:	c1 e0 04             	shl    $0x4,%eax
  80207d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802082:	8b 00                	mov    (%eax),%eax
  802084:	8d 50 ff             	lea    -0x1(%eax),%edx
  802087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208a:	c1 e0 04             	shl    $0x4,%eax
  80208d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802092:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802094:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	50                   	push   %eax
  80209b:	e8 f5 f9 ff ff       	call   801a95 <to_page_info>
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8020a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020a9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8020ad:	48                   	dec    %eax
  8020ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8020b1:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8020b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b8:	e9 26 01 00 00       	jmp    8021e3 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8020bd:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	c1 e0 04             	shl    $0x4,%eax
  8020c6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020cb:	8b 00                	mov    (%eax),%eax
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	0f 84 dc 00 00 00    	je     8021b1 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d8:	c1 e0 04             	shl    $0x4,%eax
  8020db:	05 80 c0 81 00       	add    $0x81c080,%eax
  8020e0:	8b 00                	mov    (%eax),%eax
  8020e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8020e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8020e9:	75 17                	jne    802102 <alloc_block+0x329>
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	68 e1 30 80 00       	push   $0x8030e1
  8020f3:	68 be 00 00 00       	push   $0xbe
  8020f8:	68 23 30 80 00       	push   $0x803023
  8020fd:	e8 c8 03 00 00       	call   8024ca <_panic>
  802102:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	85 c0                	test   %eax,%eax
  802109:	74 10                	je     80211b <alloc_block+0x342>
  80210b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802113:	8b 52 04             	mov    0x4(%edx),%edx
  802116:	89 50 04             	mov    %edx,0x4(%eax)
  802119:	eb 14                	jmp    80212f <alloc_block+0x356>
  80211b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80211e:	8b 40 04             	mov    0x4(%eax),%eax
  802121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802124:	c1 e2 04             	shl    $0x4,%edx
  802127:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80212d:	89 02                	mov    %eax,(%edx)
  80212f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802132:	8b 40 04             	mov    0x4(%eax),%eax
  802135:	85 c0                	test   %eax,%eax
  802137:	74 0f                	je     802148 <alloc_block+0x36f>
  802139:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80213c:	8b 40 04             	mov    0x4(%eax),%eax
  80213f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802142:	8b 12                	mov    (%edx),%edx
  802144:	89 10                	mov    %edx,(%eax)
  802146:	eb 13                	jmp    80215b <alloc_block+0x382>
  802148:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80214b:	8b 00                	mov    (%eax),%eax
  80214d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802150:	c1 e2 04             	shl    $0x4,%edx
  802153:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802159:	89 02                	mov    %eax,(%edx)
  80215b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80215e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802164:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802167:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	c1 e0 04             	shl    $0x4,%eax
  802174:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	c1 e0 04             	shl    $0x4,%eax
  802184:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802189:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80218b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80218e:	83 ec 0c             	sub    $0xc,%esp
  802191:	50                   	push   %eax
  802192:	e8 fe f8 ff ff       	call   801a95 <to_page_info>
  802197:	83 c4 10             	add    $0x10,%esp
  80219a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80219d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021a0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8021a4:	48                   	dec    %eax
  8021a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021a8:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8021ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021af:	eb 32                	jmp    8021e3 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8021b1:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8021b5:	77 15                	ja     8021cc <alloc_block+0x3f3>
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	c1 e0 04             	shl    $0x4,%eax
  8021bd:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021c2:	8b 00                	mov    (%eax),%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	0f 84 f1 fe ff ff    	je     8020bd <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	68 ff 30 80 00       	push   $0x8030ff
  8021d4:	68 c8 00 00 00       	push   $0xc8
  8021d9:	68 23 30 80 00       	push   $0x803023
  8021de:	e8 e7 02 00 00       	call   8024ca <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8021eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ee:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8021f3:	39 c2                	cmp    %eax,%edx
  8021f5:	72 0c                	jb     802203 <free_block+0x1e>
  8021f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fa:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ff:	39 c2                	cmp    %eax,%edx
  802201:	72 19                	jb     80221c <free_block+0x37>
  802203:	68 10 31 80 00       	push   $0x803110
  802208:	68 86 30 80 00       	push   $0x803086
  80220d:	68 d7 00 00 00       	push   $0xd7
  802212:	68 23 30 80 00       	push   $0x803023
  802217:	e8 ae 02 00 00       	call   8024ca <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	83 ec 0c             	sub    $0xc,%esp
  802228:	50                   	push   %eax
  802229:	e8 67 f8 ff ff       	call   801a95 <to_page_info>
  80222e:	83 c4 10             	add    $0x10,%esp
  802231:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802237:	8b 40 08             	mov    0x8(%eax),%eax
  80223a:	0f b7 c0             	movzwl %ax,%eax
  80223d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802247:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80224e:	eb 19                	jmp    802269 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802253:	ba 01 00 00 00       	mov    $0x1,%edx
  802258:	88 c1                	mov    %al,%cl
  80225a:	d3 e2                	shl    %cl,%edx
  80225c:	89 d0                	mov    %edx,%eax
  80225e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802261:	74 0e                	je     802271 <free_block+0x8c>
	        break;
	    idx++;
  802263:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802266:	ff 45 f0             	incl   -0x10(%ebp)
  802269:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80226d:	7e e1                	jle    802250 <free_block+0x6b>
  80226f:	eb 01                	jmp    802272 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802271:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802275:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802279:	40                   	inc    %eax
  80227a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80227d:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802281:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802285:	75 17                	jne    80229e <free_block+0xb9>
  802287:	83 ec 04             	sub    $0x4,%esp
  80228a:	68 9c 30 80 00       	push   $0x80309c
  80228f:	68 ee 00 00 00       	push   $0xee
  802294:	68 23 30 80 00       	push   $0x803023
  802299:	e8 2c 02 00 00       	call   8024ca <_panic>
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	c1 e0 04             	shl    $0x4,%eax
  8022a4:	05 84 c0 81 00       	add    $0x81c084,%eax
  8022a9:	8b 10                	mov    (%eax),%edx
  8022ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ae:	89 50 04             	mov    %edx,0x4(%eax)
  8022b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b4:	8b 40 04             	mov    0x4(%eax),%eax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	74 14                	je     8022cf <free_block+0xea>
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	c1 e0 04             	shl    $0x4,%eax
  8022c1:	05 84 c0 81 00       	add    $0x81c084,%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022cb:	89 10                	mov    %edx,(%eax)
  8022cd:	eb 11                	jmp    8022e0 <free_block+0xfb>
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	c1 e0 04             	shl    $0x4,%eax
  8022d5:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8022db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022de:	89 02                	mov    %eax,(%edx)
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	c1 e0 04             	shl    $0x4,%eax
  8022e6:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8022ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ef:	89 02                	mov    %eax,(%edx)
  8022f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	c1 e0 04             	shl    $0x4,%eax
  802300:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	8d 50 01             	lea    0x1(%eax),%edx
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	c1 e0 04             	shl    $0x4,%eax
  802310:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802315:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802317:	b8 00 10 00 00       	mov    $0x1000,%eax
  80231c:	ba 00 00 00 00       	mov    $0x0,%edx
  802321:	f7 75 e0             	divl   -0x20(%ebp)
  802324:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80232a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80232e:	0f b7 c0             	movzwl %ax,%eax
  802331:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802334:	0f 85 70 01 00 00    	jne    8024aa <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  80233a:	83 ec 0c             	sub    $0xc,%esp
  80233d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802340:	e8 de f6 ff ff       	call   801a23 <to_page_va>
  802345:	83 c4 10             	add    $0x10,%esp
  802348:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80234b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802352:	e9 b7 00 00 00       	jmp    80240e <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802357:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80235a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235d:	01 d0                	add    %edx,%eax
  80235f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802362:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802366:	75 17                	jne    80237f <free_block+0x19a>
  802368:	83 ec 04             	sub    $0x4,%esp
  80236b:	68 e1 30 80 00       	push   $0x8030e1
  802370:	68 f8 00 00 00       	push   $0xf8
  802375:	68 23 30 80 00       	push   $0x803023
  80237a:	e8 4b 01 00 00       	call   8024ca <_panic>
  80237f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	74 10                	je     802398 <free_block+0x1b3>
  802388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802390:	8b 52 04             	mov    0x4(%edx),%edx
  802393:	89 50 04             	mov    %edx,0x4(%eax)
  802396:	eb 14                	jmp    8023ac <free_block+0x1c7>
  802398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80239b:	8b 40 04             	mov    0x4(%eax),%eax
  80239e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a1:	c1 e2 04             	shl    $0x4,%edx
  8023a4:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023aa:	89 02                	mov    %eax,(%edx)
  8023ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023af:	8b 40 04             	mov    0x4(%eax),%eax
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	74 0f                	je     8023c5 <free_block+0x1e0>
  8023b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b9:	8b 40 04             	mov    0x4(%eax),%eax
  8023bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023bf:	8b 12                	mov    (%edx),%edx
  8023c1:	89 10                	mov    %edx,(%eax)
  8023c3:	eb 13                	jmp    8023d8 <free_block+0x1f3>
  8023c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c8:	8b 00                	mov    (%eax),%eax
  8023ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cd:	c1 e2 04             	shl    $0x4,%edx
  8023d0:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023d6:	89 02                	mov    %eax,(%edx)
  8023d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	c1 e0 04             	shl    $0x4,%eax
  8023f1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	c1 e0 04             	shl    $0x4,%eax
  802401:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802406:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802408:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80240b:	01 45 ec             	add    %eax,-0x14(%ebp)
  80240e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802415:	0f 86 3c ff ff ff    	jbe    802357 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  80241b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802427:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  80242d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802431:	75 17                	jne    80244a <free_block+0x265>
  802433:	83 ec 04             	sub    $0x4,%esp
  802436:	68 9c 30 80 00       	push   $0x80309c
  80243b:	68 fe 00 00 00       	push   $0xfe
  802440:	68 23 30 80 00       	push   $0x803023
  802445:	e8 80 00 00 00       	call   8024ca <_panic>
  80244a:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802453:	89 50 04             	mov    %edx,0x4(%eax)
  802456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802459:	8b 40 04             	mov    0x4(%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	74 0c                	je     80246c <free_block+0x287>
  802460:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802465:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802468:	89 10                	mov    %edx,(%eax)
  80246a:	eb 08                	jmp    802474 <free_block+0x28f>
  80246c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246f:	a3 48 40 80 00       	mov    %eax,0x804048
  802474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802477:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80247c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80247f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802485:	a1 54 40 80 00       	mov    0x804054,%eax
  80248a:	40                   	inc    %eax
  80248b:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802490:	83 ec 0c             	sub    $0xc,%esp
  802493:	ff 75 e4             	pushl  -0x1c(%ebp)
  802496:	e8 88 f5 ff ff       	call   801a23 <to_page_va>
  80249b:	83 c4 10             	add    $0x10,%esp
  80249e:	83 ec 0c             	sub    $0xc,%esp
  8024a1:	50                   	push   %eax
  8024a2:	e8 b8 ee ff ff       	call   80135f <return_page>
  8024a7:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8024aa:	90                   	nop
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	68 48 31 80 00       	push   $0x803148
  8024bb:	68 11 01 00 00       	push   $0x111
  8024c0:	68 23 30 80 00       	push   $0x803023
  8024c5:	e8 00 00 00 00       	call   8024ca <_panic>

008024ca <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8024d0:	8d 45 10             	lea    0x10(%ebp),%eax
  8024d3:	83 c0 04             	add    $0x4,%eax
  8024d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8024d9:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 16                	je     8024f8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8024e2:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8024e7:	83 ec 08             	sub    $0x8,%esp
  8024ea:	50                   	push   %eax
  8024eb:	68 6c 31 80 00       	push   $0x80316c
  8024f0:	e8 e8 de ff ff       	call   8003dd <cprintf>
  8024f5:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8024f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8024fd:	83 ec 0c             	sub    $0xc,%esp
  802500:	ff 75 0c             	pushl  0xc(%ebp)
  802503:	ff 75 08             	pushl  0x8(%ebp)
  802506:	50                   	push   %eax
  802507:	68 74 31 80 00       	push   $0x803174
  80250c:	6a 74                	push   $0x74
  80250e:	e8 f7 de ff ff       	call   80040a <cprintf_colored>
  802513:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802516:	8b 45 10             	mov    0x10(%ebp),%eax
  802519:	83 ec 08             	sub    $0x8,%esp
  80251c:	ff 75 f4             	pushl  -0xc(%ebp)
  80251f:	50                   	push   %eax
  802520:	e8 49 de ff ff       	call   80036e <vcprintf>
  802525:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802528:	83 ec 08             	sub    $0x8,%esp
  80252b:	6a 00                	push   $0x0
  80252d:	68 9c 31 80 00       	push   $0x80319c
  802532:	e8 37 de ff ff       	call   80036e <vcprintf>
  802537:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80253a:	e8 b0 dd ff ff       	call   8002ef <exit>

	// should not return here
	while (1) ;
  80253f:	eb fe                	jmp    80253f <_panic+0x75>

00802541 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802547:	a1 20 40 80 00       	mov    0x804020,%eax
  80254c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802552:	8b 45 0c             	mov    0xc(%ebp),%eax
  802555:	39 c2                	cmp    %eax,%edx
  802557:	74 14                	je     80256d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	68 a0 31 80 00       	push   $0x8031a0
  802561:	6a 26                	push   $0x26
  802563:	68 ec 31 80 00       	push   $0x8031ec
  802568:	e8 5d ff ff ff       	call   8024ca <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80256d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802574:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80257b:	e9 c5 00 00 00       	jmp    802645 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802583:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	01 d0                	add    %edx,%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	75 08                	jne    80259d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802595:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802598:	e9 a5 00 00 00       	jmp    802642 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80259d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8025a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8025ab:	eb 69                	jmp    802616 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8025ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8025b2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8025b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025bb:	89 d0                	mov    %edx,%eax
  8025bd:	01 c0                	add    %eax,%eax
  8025bf:	01 d0                	add    %edx,%eax
  8025c1:	c1 e0 03             	shl    $0x3,%eax
  8025c4:	01 c8                	add    %ecx,%eax
  8025c6:	8a 40 04             	mov    0x4(%eax),%al
  8025c9:	84 c0                	test   %al,%al
  8025cb:	75 46                	jne    802613 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8025cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8025d2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8025d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025db:	89 d0                	mov    %edx,%eax
  8025dd:	01 c0                	add    %eax,%eax
  8025df:	01 d0                	add    %edx,%eax
  8025e1:	c1 e0 03             	shl    $0x3,%eax
  8025e4:	01 c8                	add    %ecx,%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025f3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8025f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	01 c8                	add    %ecx,%eax
  802604:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802606:	39 c2                	cmp    %eax,%edx
  802608:	75 09                	jne    802613 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80260a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802611:	eb 15                	jmp    802628 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802613:	ff 45 e8             	incl   -0x18(%ebp)
  802616:	a1 20 40 80 00       	mov    0x804020,%eax
  80261b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802621:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802624:	39 c2                	cmp    %eax,%edx
  802626:	77 85                	ja     8025ad <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802628:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80262c:	75 14                	jne    802642 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80262e:	83 ec 04             	sub    $0x4,%esp
  802631:	68 f8 31 80 00       	push   $0x8031f8
  802636:	6a 3a                	push   $0x3a
  802638:	68 ec 31 80 00       	push   $0x8031ec
  80263d:	e8 88 fe ff ff       	call   8024ca <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802642:	ff 45 f0             	incl   -0x10(%ebp)
  802645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802648:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80264b:	0f 8c 2f ff ff ff    	jl     802580 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802651:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802658:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80265f:	eb 26                	jmp    802687 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802661:	a1 20 40 80 00       	mov    0x804020,%eax
  802666:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80266c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80266f:	89 d0                	mov    %edx,%eax
  802671:	01 c0                	add    %eax,%eax
  802673:	01 d0                	add    %edx,%eax
  802675:	c1 e0 03             	shl    $0x3,%eax
  802678:	01 c8                	add    %ecx,%eax
  80267a:	8a 40 04             	mov    0x4(%eax),%al
  80267d:	3c 01                	cmp    $0x1,%al
  80267f:	75 03                	jne    802684 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802681:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802684:	ff 45 e0             	incl   -0x20(%ebp)
  802687:	a1 20 40 80 00       	mov    0x804020,%eax
  80268c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802695:	39 c2                	cmp    %eax,%edx
  802697:	77 c8                	ja     802661 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80269f:	74 14                	je     8026b5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8026a1:	83 ec 04             	sub    $0x4,%esp
  8026a4:	68 4c 32 80 00       	push   $0x80324c
  8026a9:	6a 44                	push   $0x44
  8026ab:	68 ec 31 80 00       	push   $0x8031ec
  8026b0:	e8 15 fe ff ff       	call   8024ca <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8026b5:	90                   	nop
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <__udivdi3>:
  8026b8:	55                   	push   %ebp
  8026b9:	57                   	push   %edi
  8026ba:	56                   	push   %esi
  8026bb:	53                   	push   %ebx
  8026bc:	83 ec 1c             	sub    $0x1c,%esp
  8026bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8026c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8026c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026cf:	89 ca                	mov    %ecx,%edx
  8026d1:	89 f8                	mov    %edi,%eax
  8026d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8026d7:	85 f6                	test   %esi,%esi
  8026d9:	75 2d                	jne    802708 <__udivdi3+0x50>
  8026db:	39 cf                	cmp    %ecx,%edi
  8026dd:	77 65                	ja     802744 <__udivdi3+0x8c>
  8026df:	89 fd                	mov    %edi,%ebp
  8026e1:	85 ff                	test   %edi,%edi
  8026e3:	75 0b                	jne    8026f0 <__udivdi3+0x38>
  8026e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ea:	31 d2                	xor    %edx,%edx
  8026ec:	f7 f7                	div    %edi
  8026ee:	89 c5                	mov    %eax,%ebp
  8026f0:	31 d2                	xor    %edx,%edx
  8026f2:	89 c8                	mov    %ecx,%eax
  8026f4:	f7 f5                	div    %ebp
  8026f6:	89 c1                	mov    %eax,%ecx
  8026f8:	89 d8                	mov    %ebx,%eax
  8026fa:	f7 f5                	div    %ebp
  8026fc:	89 cf                	mov    %ecx,%edi
  8026fe:	89 fa                	mov    %edi,%edx
  802700:	83 c4 1c             	add    $0x1c,%esp
  802703:	5b                   	pop    %ebx
  802704:	5e                   	pop    %esi
  802705:	5f                   	pop    %edi
  802706:	5d                   	pop    %ebp
  802707:	c3                   	ret    
  802708:	39 ce                	cmp    %ecx,%esi
  80270a:	77 28                	ja     802734 <__udivdi3+0x7c>
  80270c:	0f bd fe             	bsr    %esi,%edi
  80270f:	83 f7 1f             	xor    $0x1f,%edi
  802712:	75 40                	jne    802754 <__udivdi3+0x9c>
  802714:	39 ce                	cmp    %ecx,%esi
  802716:	72 0a                	jb     802722 <__udivdi3+0x6a>
  802718:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80271c:	0f 87 9e 00 00 00    	ja     8027c0 <__udivdi3+0x108>
  802722:	b8 01 00 00 00       	mov    $0x1,%eax
  802727:	89 fa                	mov    %edi,%edx
  802729:	83 c4 1c             	add    $0x1c,%esp
  80272c:	5b                   	pop    %ebx
  80272d:	5e                   	pop    %esi
  80272e:	5f                   	pop    %edi
  80272f:	5d                   	pop    %ebp
  802730:	c3                   	ret    
  802731:	8d 76 00             	lea    0x0(%esi),%esi
  802734:	31 ff                	xor    %edi,%edi
  802736:	31 c0                	xor    %eax,%eax
  802738:	89 fa                	mov    %edi,%edx
  80273a:	83 c4 1c             	add    $0x1c,%esp
  80273d:	5b                   	pop    %ebx
  80273e:	5e                   	pop    %esi
  80273f:	5f                   	pop    %edi
  802740:	5d                   	pop    %ebp
  802741:	c3                   	ret    
  802742:	66 90                	xchg   %ax,%ax
  802744:	89 d8                	mov    %ebx,%eax
  802746:	f7 f7                	div    %edi
  802748:	31 ff                	xor    %edi,%edi
  80274a:	89 fa                	mov    %edi,%edx
  80274c:	83 c4 1c             	add    $0x1c,%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    
  802754:	bd 20 00 00 00       	mov    $0x20,%ebp
  802759:	89 eb                	mov    %ebp,%ebx
  80275b:	29 fb                	sub    %edi,%ebx
  80275d:	89 f9                	mov    %edi,%ecx
  80275f:	d3 e6                	shl    %cl,%esi
  802761:	89 c5                	mov    %eax,%ebp
  802763:	88 d9                	mov    %bl,%cl
  802765:	d3 ed                	shr    %cl,%ebp
  802767:	89 e9                	mov    %ebp,%ecx
  802769:	09 f1                	or     %esi,%ecx
  80276b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80276f:	89 f9                	mov    %edi,%ecx
  802771:	d3 e0                	shl    %cl,%eax
  802773:	89 c5                	mov    %eax,%ebp
  802775:	89 d6                	mov    %edx,%esi
  802777:	88 d9                	mov    %bl,%cl
  802779:	d3 ee                	shr    %cl,%esi
  80277b:	89 f9                	mov    %edi,%ecx
  80277d:	d3 e2                	shl    %cl,%edx
  80277f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802783:	88 d9                	mov    %bl,%cl
  802785:	d3 e8                	shr    %cl,%eax
  802787:	09 c2                	or     %eax,%edx
  802789:	89 d0                	mov    %edx,%eax
  80278b:	89 f2                	mov    %esi,%edx
  80278d:	f7 74 24 0c          	divl   0xc(%esp)
  802791:	89 d6                	mov    %edx,%esi
  802793:	89 c3                	mov    %eax,%ebx
  802795:	f7 e5                	mul    %ebp
  802797:	39 d6                	cmp    %edx,%esi
  802799:	72 19                	jb     8027b4 <__udivdi3+0xfc>
  80279b:	74 0b                	je     8027a8 <__udivdi3+0xf0>
  80279d:	89 d8                	mov    %ebx,%eax
  80279f:	31 ff                	xor    %edi,%edi
  8027a1:	e9 58 ff ff ff       	jmp    8026fe <__udivdi3+0x46>
  8027a6:	66 90                	xchg   %ax,%ax
  8027a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8027ac:	89 f9                	mov    %edi,%ecx
  8027ae:	d3 e2                	shl    %cl,%edx
  8027b0:	39 c2                	cmp    %eax,%edx
  8027b2:	73 e9                	jae    80279d <__udivdi3+0xe5>
  8027b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027b7:	31 ff                	xor    %edi,%edi
  8027b9:	e9 40 ff ff ff       	jmp    8026fe <__udivdi3+0x46>
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	31 c0                	xor    %eax,%eax
  8027c2:	e9 37 ff ff ff       	jmp    8026fe <__udivdi3+0x46>
  8027c7:	90                   	nop

008027c8 <__umoddi3>:
  8027c8:	55                   	push   %ebp
  8027c9:	57                   	push   %edi
  8027ca:	56                   	push   %esi
  8027cb:	53                   	push   %ebx
  8027cc:	83 ec 1c             	sub    $0x1c,%esp
  8027cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8027d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e7:	89 f3                	mov    %esi,%ebx
  8027e9:	89 fa                	mov    %edi,%edx
  8027eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027ef:	89 34 24             	mov    %esi,(%esp)
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	75 1a                	jne    802810 <__umoddi3+0x48>
  8027f6:	39 f7                	cmp    %esi,%edi
  8027f8:	0f 86 a2 00 00 00    	jbe    8028a0 <__umoddi3+0xd8>
  8027fe:	89 c8                	mov    %ecx,%eax
  802800:	89 f2                	mov    %esi,%edx
  802802:	f7 f7                	div    %edi
  802804:	89 d0                	mov    %edx,%eax
  802806:	31 d2                	xor    %edx,%edx
  802808:	83 c4 1c             	add    $0x1c,%esp
  80280b:	5b                   	pop    %ebx
  80280c:	5e                   	pop    %esi
  80280d:	5f                   	pop    %edi
  80280e:	5d                   	pop    %ebp
  80280f:	c3                   	ret    
  802810:	39 f0                	cmp    %esi,%eax
  802812:	0f 87 ac 00 00 00    	ja     8028c4 <__umoddi3+0xfc>
  802818:	0f bd e8             	bsr    %eax,%ebp
  80281b:	83 f5 1f             	xor    $0x1f,%ebp
  80281e:	0f 84 ac 00 00 00    	je     8028d0 <__umoddi3+0x108>
  802824:	bf 20 00 00 00       	mov    $0x20,%edi
  802829:	29 ef                	sub    %ebp,%edi
  80282b:	89 fe                	mov    %edi,%esi
  80282d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802831:	89 e9                	mov    %ebp,%ecx
  802833:	d3 e0                	shl    %cl,%eax
  802835:	89 d7                	mov    %edx,%edi
  802837:	89 f1                	mov    %esi,%ecx
  802839:	d3 ef                	shr    %cl,%edi
  80283b:	09 c7                	or     %eax,%edi
  80283d:	89 e9                	mov    %ebp,%ecx
  80283f:	d3 e2                	shl    %cl,%edx
  802841:	89 14 24             	mov    %edx,(%esp)
  802844:	89 d8                	mov    %ebx,%eax
  802846:	d3 e0                	shl    %cl,%eax
  802848:	89 c2                	mov    %eax,%edx
  80284a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80284e:	d3 e0                	shl    %cl,%eax
  802850:	89 44 24 04          	mov    %eax,0x4(%esp)
  802854:	8b 44 24 08          	mov    0x8(%esp),%eax
  802858:	89 f1                	mov    %esi,%ecx
  80285a:	d3 e8                	shr    %cl,%eax
  80285c:	09 d0                	or     %edx,%eax
  80285e:	d3 eb                	shr    %cl,%ebx
  802860:	89 da                	mov    %ebx,%edx
  802862:	f7 f7                	div    %edi
  802864:	89 d3                	mov    %edx,%ebx
  802866:	f7 24 24             	mull   (%esp)
  802869:	89 c6                	mov    %eax,%esi
  80286b:	89 d1                	mov    %edx,%ecx
  80286d:	39 d3                	cmp    %edx,%ebx
  80286f:	0f 82 87 00 00 00    	jb     8028fc <__umoddi3+0x134>
  802875:	0f 84 91 00 00 00    	je     80290c <__umoddi3+0x144>
  80287b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80287f:	29 f2                	sub    %esi,%edx
  802881:	19 cb                	sbb    %ecx,%ebx
  802883:	89 d8                	mov    %ebx,%eax
  802885:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802889:	d3 e0                	shl    %cl,%eax
  80288b:	89 e9                	mov    %ebp,%ecx
  80288d:	d3 ea                	shr    %cl,%edx
  80288f:	09 d0                	or     %edx,%eax
  802891:	89 e9                	mov    %ebp,%ecx
  802893:	d3 eb                	shr    %cl,%ebx
  802895:	89 da                	mov    %ebx,%edx
  802897:	83 c4 1c             	add    $0x1c,%esp
  80289a:	5b                   	pop    %ebx
  80289b:	5e                   	pop    %esi
  80289c:	5f                   	pop    %edi
  80289d:	5d                   	pop    %ebp
  80289e:	c3                   	ret    
  80289f:	90                   	nop
  8028a0:	89 fd                	mov    %edi,%ebp
  8028a2:	85 ff                	test   %edi,%edi
  8028a4:	75 0b                	jne    8028b1 <__umoddi3+0xe9>
  8028a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ab:	31 d2                	xor    %edx,%edx
  8028ad:	f7 f7                	div    %edi
  8028af:	89 c5                	mov    %eax,%ebp
  8028b1:	89 f0                	mov    %esi,%eax
  8028b3:	31 d2                	xor    %edx,%edx
  8028b5:	f7 f5                	div    %ebp
  8028b7:	89 c8                	mov    %ecx,%eax
  8028b9:	f7 f5                	div    %ebp
  8028bb:	89 d0                	mov    %edx,%eax
  8028bd:	e9 44 ff ff ff       	jmp    802806 <__umoddi3+0x3e>
  8028c2:	66 90                	xchg   %ax,%ax
  8028c4:	89 c8                	mov    %ecx,%eax
  8028c6:	89 f2                	mov    %esi,%edx
  8028c8:	83 c4 1c             	add    $0x1c,%esp
  8028cb:	5b                   	pop    %ebx
  8028cc:	5e                   	pop    %esi
  8028cd:	5f                   	pop    %edi
  8028ce:	5d                   	pop    %ebp
  8028cf:	c3                   	ret    
  8028d0:	3b 04 24             	cmp    (%esp),%eax
  8028d3:	72 06                	jb     8028db <__umoddi3+0x113>
  8028d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8028d9:	77 0f                	ja     8028ea <__umoddi3+0x122>
  8028db:	89 f2                	mov    %esi,%edx
  8028dd:	29 f9                	sub    %edi,%ecx
  8028df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8028e3:	89 14 24             	mov    %edx,(%esp)
  8028e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028ee:	8b 14 24             	mov    (%esp),%edx
  8028f1:	83 c4 1c             	add    $0x1c,%esp
  8028f4:	5b                   	pop    %ebx
  8028f5:	5e                   	pop    %esi
  8028f6:	5f                   	pop    %edi
  8028f7:	5d                   	pop    %ebp
  8028f8:	c3                   	ret    
  8028f9:	8d 76 00             	lea    0x0(%esi),%esi
  8028fc:	2b 04 24             	sub    (%esp),%eax
  8028ff:	19 fa                	sbb    %edi,%edx
  802901:	89 d1                	mov    %edx,%ecx
  802903:	89 c6                	mov    %eax,%esi
  802905:	e9 71 ff ff ff       	jmp    80287b <__umoddi3+0xb3>
  80290a:	66 90                	xchg   %ax,%ax
  80290c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802910:	72 ea                	jb     8028fc <__umoddi3+0x134>
  802912:	89 d9                	mov    %ebx,%ecx
  802914:	e9 62 ff ff ff       	jmp    80287b <__umoddi3+0xb3>
