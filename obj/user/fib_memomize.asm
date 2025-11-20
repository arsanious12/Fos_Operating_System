
obj/user/fib_memomize:     file format elf32-i386


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
  800031:	e8 7f 01 00 00       	call   8001b5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	int index=0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 e0 2b 80 00       	push   $0x802be0
  800057:	e8 d6 0b 00 00       	call   800c32 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 d8 10 00 00       	call   80114a <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 9c 15 00 00       	call   801624 <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (int i = 0; i <= index; ++i)
  80008e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800095:	eb 1f                	jmp    8000b6 <_main+0x7e>
	{
		memo[i] = 0;
  800097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80009a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	01 d0                	add    %edx,%eax
  8000a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8000ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
	index = strtol(buff1, NULL, 10);

	int64 *memo = malloc((index+1) * sizeof(int64));
	for (int i = 0; i <= index; ++i)
  8000b3:	ff 45 f4             	incl   -0xc(%ebp)
  8000b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000bc:	7e d9                	jle    800097 <_main+0x5f>
	{
		memo[i] = 0;
	}
	int64 res = fibonacci(index, memo) ;
  8000be:	83 ec 08             	sub    $0x8,%esp
  8000c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c7:	e8 35 00 00 00       	call   800101 <fibonacci>
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	free(memo);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000db:	e8 72 15 00 00       	call   801652 <free>
  8000e0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ec:	68 fe 2b 80 00       	push   $0x802bfe
  8000f1:	e8 d6 03 00 00       	call   8004cc <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 26 1a 00 00       	call   801b24 <inctst>
	return;
  8000fe:	90                   	nop
}
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	57                   	push   %edi
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	83 ec 0c             	sub    $0xc,%esp
	if (memo[n]!=0)	return memo[n];
  80010a:	8b 45 08             	mov    0x8(%ebp),%eax
  80010d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800114:	8b 45 0c             	mov    0xc(%ebp),%eax
  800117:	01 d0                	add    %edx,%eax
  800119:	8b 50 04             	mov    0x4(%eax),%edx
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	09 d0                	or     %edx,%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	74 16                	je     80013a <fibonacci+0x39>
  800124:	8b 45 08             	mov    0x8(%ebp),%eax
  800127:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80012e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800131:	01 d0                	add    %edx,%eax
  800133:	8b 50 04             	mov    0x4(%eax),%edx
  800136:	8b 00                	mov    (%eax),%eax
  800138:	eb 73                	jmp    8001ad <fibonacci+0xac>
	if (n <= 1)
  80013a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80013e:	7f 23                	jg     800163 <fibonacci+0x62>
		return memo[n] = 1 ;
  800140:	8b 45 08             	mov    0x8(%ebp),%eax
  800143:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80014a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  800155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80015c:	8b 50 04             	mov    0x4(%eax),%edx
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	eb 4a                	jmp    8001ad <fibonacci+0xac>
	return (memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo)) ;
  800163:	8b 45 08             	mov    0x8(%ebp),%eax
  800166:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80016d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800170:	8d 3c 02             	lea    (%edx,%eax,1),%edi
  800173:	8b 45 08             	mov    0x8(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	ff 75 0c             	pushl  0xc(%ebp)
  80017d:	50                   	push   %eax
  80017e:	e8 7e ff ff ff       	call   800101 <fibonacci>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	89 c3                	mov    %eax,%ebx
  800188:	89 d6                	mov    %edx,%esi
  80018a:	8b 45 08             	mov    0x8(%ebp),%eax
  80018d:	83 e8 02             	sub    $0x2,%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 0c             	pushl  0xc(%ebp)
  800196:	50                   	push   %eax
  800197:	e8 65 ff ff ff       	call   800101 <fibonacci>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	01 d8                	add    %ebx,%eax
  8001a1:	11 f2                	adc    %esi,%edx
  8001a3:	89 07                	mov    %eax,(%edi)
  8001a5:	89 57 04             	mov    %edx,0x4(%edi)
  8001a8:	8b 07                	mov    (%edi),%eax
  8001aa:	8b 57 04             	mov    0x4(%edi),%edx
}
  8001ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b0:	5b                   	pop    %ebx
  8001b1:	5e                   	pop    %esi
  8001b2:	5f                   	pop    %edi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    

008001b5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	57                   	push   %edi
  8001b9:	56                   	push   %esi
  8001ba:	53                   	push   %ebx
  8001bb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001be:	e8 23 18 00 00       	call   8019e6 <sys_getenvindex>
  8001c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001c9:	89 d0                	mov    %edx,%eax
  8001cb:	c1 e0 06             	shl    $0x6,%eax
  8001ce:	29 d0                	sub    %edx,%eax
  8001d0:	c1 e0 02             	shl    $0x2,%eax
  8001d3:	01 d0                	add    %edx,%eax
  8001d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001dc:	01 c8                	add    %ecx,%eax
  8001de:	c1 e0 03             	shl    $0x3,%eax
  8001e1:	01 d0                	add    %edx,%eax
  8001e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001ea:	29 c2                	sub    %eax,%edx
  8001ec:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001f3:	89 c2                	mov    %eax,%edx
  8001f5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001fb:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800200:	a1 20 40 80 00       	mov    0x804020,%eax
  800205:	8a 40 20             	mov    0x20(%eax),%al
  800208:	84 c0                	test   %al,%al
  80020a:	74 0d                	je     800219 <libmain+0x64>
		binaryname = myEnv->prog_name;
  80020c:	a1 20 40 80 00       	mov    0x804020,%eax
  800211:	83 c0 20             	add    $0x20,%eax
  800214:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80021d:	7e 0a                	jle    800229 <libmain+0x74>
		binaryname = argv[0];
  80021f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	ff 75 0c             	pushl  0xc(%ebp)
  80022f:	ff 75 08             	pushl  0x8(%ebp)
  800232:	e8 01 fe ff ff       	call   800038 <_main>
  800237:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80023a:	a1 00 40 80 00       	mov    0x804000,%eax
  80023f:	85 c0                	test   %eax,%eax
  800241:	0f 84 01 01 00 00    	je     800348 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800247:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80024d:	bb 0c 2d 80 00       	mov    $0x802d0c,%ebx
  800252:	ba 0e 00 00 00       	mov    $0xe,%edx
  800257:	89 c7                	mov    %eax,%edi
  800259:	89 de                	mov    %ebx,%esi
  80025b:	89 d1                	mov    %edx,%ecx
  80025d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80025f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800262:	b9 56 00 00 00       	mov    $0x56,%ecx
  800267:	b0 00                	mov    $0x0,%al
  800269:	89 d7                	mov    %edx,%edi
  80026b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80026d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800274:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	50                   	push   %eax
  80027b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800281:	50                   	push   %eax
  800282:	e8 95 19 00 00       	call   801c1c <sys_utilities>
  800287:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80028a:	e8 de 14 00 00       	call   80176d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	68 2c 2c 80 00       	push   $0x802c2c
  800297:	e8 be 01 00 00       	call   80045a <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80029f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	74 18                	je     8002be <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002a6:	e8 8f 19 00 00       	call   801c3a <sys_get_optimal_num_faults>
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	50                   	push   %eax
  8002af:	68 54 2c 80 00       	push   $0x802c54
  8002b4:	e8 a1 01 00 00       	call   80045a <cprintf>
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	eb 59                	jmp    800317 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002be:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c3:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8002d4:	83 ec 04             	sub    $0x4,%esp
  8002d7:	52                   	push   %edx
  8002d8:	50                   	push   %eax
  8002d9:	68 78 2c 80 00       	push   $0x802c78
  8002de:	e8 77 01 00 00       	call   80045a <cprintf>
  8002e3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8002eb:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8002f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f6:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8002fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800301:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800307:	51                   	push   %ecx
  800308:	52                   	push   %edx
  800309:	50                   	push   %eax
  80030a:	68 a0 2c 80 00       	push   $0x802ca0
  80030f:	e8 46 01 00 00       	call   80045a <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800317:	a1 20 40 80 00       	mov    0x804020,%eax
  80031c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800322:	83 ec 08             	sub    $0x8,%esp
  800325:	50                   	push   %eax
  800326:	68 f8 2c 80 00       	push   $0x802cf8
  80032b:	e8 2a 01 00 00       	call   80045a <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	68 2c 2c 80 00       	push   $0x802c2c
  80033b:	e8 1a 01 00 00       	call   80045a <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800343:	e8 3f 14 00 00       	call   801787 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800348:	e8 1f 00 00 00       	call   80036c <exit>
}
  80034d:	90                   	nop
  80034e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	6a 00                	push   $0x0
  800361:	e8 4c 16 00 00       	call   8019b2 <sys_destroy_env>
  800366:	83 c4 10             	add    $0x10,%esp
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <exit>:

void
exit(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800372:	e8 a1 16 00 00       	call   801a18 <sys_exit_env>
}
  800377:	90                   	nop
  800378:	c9                   	leave  
  800379:	c3                   	ret    

0080037a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	53                   	push   %ebx
  80037e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800381:	8b 45 0c             	mov    0xc(%ebp),%eax
  800384:	8b 00                	mov    (%eax),%eax
  800386:	8d 48 01             	lea    0x1(%eax),%ecx
  800389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038c:	89 0a                	mov    %ecx,(%edx)
  80038e:	8b 55 08             	mov    0x8(%ebp),%edx
  800391:	88 d1                	mov    %dl,%cl
  800393:	8b 55 0c             	mov    0xc(%ebp),%edx
  800396:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80039a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039d:	8b 00                	mov    (%eax),%eax
  80039f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a4:	75 30                	jne    8003d6 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8003a6:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8003ac:	a0 44 40 80 00       	mov    0x804044,%al
  8003b1:	0f b6 c0             	movzbl %al,%eax
  8003b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b7:	8b 09                	mov    (%ecx),%ecx
  8003b9:	89 cb                	mov    %ecx,%ebx
  8003bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003be:	83 c1 08             	add    $0x8,%ecx
  8003c1:	52                   	push   %edx
  8003c2:	50                   	push   %eax
  8003c3:	53                   	push   %ebx
  8003c4:	51                   	push   %ecx
  8003c5:	e8 5f 13 00 00       	call   801729 <sys_cputs>
  8003ca:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d9:	8b 40 04             	mov    0x4(%eax),%eax
  8003dc:	8d 50 01             	lea    0x1(%eax),%edx
  8003df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003e5:	90                   	nop
  8003e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e9:	c9                   	leave  
  8003ea:	c3                   	ret    

008003eb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003eb:	55                   	push   %ebp
  8003ec:	89 e5                	mov    %esp,%ebp
  8003ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003fb:	00 00 00 
	b.cnt = 0;
  8003fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800405:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800408:	ff 75 0c             	pushl  0xc(%ebp)
  80040b:	ff 75 08             	pushl  0x8(%ebp)
  80040e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800414:	50                   	push   %eax
  800415:	68 7a 03 80 00       	push   $0x80037a
  80041a:	e8 5a 02 00 00       	call   800679 <vprintfmt>
  80041f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800422:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800428:	a0 44 40 80 00       	mov    0x804044,%al
  80042d:	0f b6 c0             	movzbl %al,%eax
  800430:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800436:	52                   	push   %edx
  800437:	50                   	push   %eax
  800438:	51                   	push   %ecx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 e1 12 00 00       	call   801729 <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 6f ff ff ff       	call   8003eb <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80048d:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	c1 e0 08             	shl    $0x8,%eax
  80049a:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  80049f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b1:	50                   	push   %eax
  8004b2:	e8 34 ff ff ff       	call   8003eb <vcprintf>
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8004bd:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  8004c4:	07 00 00 

	return cnt;
  8004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004d2:	e8 96 12 00 00       	call   80176d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004d7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	e8 ff fe ff ff       	call   8003eb <vcprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
  8004ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004f2:	e8 90 12 00 00       	call   801787 <sys_unlock_cons>
	return cnt;
  8004f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

008004fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	53                   	push   %ebx
  800500:	83 ec 14             	sub    $0x14,%esp
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80050f:	8b 45 18             	mov    0x18(%ebp),%eax
  800512:	ba 00 00 00 00       	mov    $0x0,%edx
  800517:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80051a:	77 55                	ja     800571 <printnum+0x75>
  80051c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80051f:	72 05                	jb     800526 <printnum+0x2a>
  800521:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800524:	77 4b                	ja     800571 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800526:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800529:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80052c:	8b 45 18             	mov    0x18(%ebp),%eax
  80052f:	ba 00 00 00 00       	mov    $0x0,%edx
  800534:	52                   	push   %edx
  800535:	50                   	push   %eax
  800536:	ff 75 f4             	pushl  -0xc(%ebp)
  800539:	ff 75 f0             	pushl  -0x10(%ebp)
  80053c:	e8 3b 24 00 00       	call   80297c <__udivdi3>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	ff 75 20             	pushl  0x20(%ebp)
  80054a:	53                   	push   %ebx
  80054b:	ff 75 18             	pushl  0x18(%ebp)
  80054e:	52                   	push   %edx
  80054f:	50                   	push   %eax
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	ff 75 08             	pushl  0x8(%ebp)
  800556:	e8 a1 ff ff ff       	call   8004fc <printnum>
  80055b:	83 c4 20             	add    $0x20,%esp
  80055e:	eb 1a                	jmp    80057a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	ff 75 0c             	pushl  0xc(%ebp)
  800566:	ff 75 20             	pushl  0x20(%ebp)
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	ff d0                	call   *%eax
  80056e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800571:	ff 4d 1c             	decl   0x1c(%ebp)
  800574:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800578:	7f e6                	jg     800560 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80057a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80057d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800588:	53                   	push   %ebx
  800589:	51                   	push   %ecx
  80058a:	52                   	push   %edx
  80058b:	50                   	push   %eax
  80058c:	e8 fb 24 00 00       	call   802a8c <__umoddi3>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	05 94 2f 80 00       	add    $0x802f94,%eax
  800599:	8a 00                	mov    (%eax),%al
  80059b:	0f be c0             	movsbl %al,%eax
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	ff 75 0c             	pushl  0xc(%ebp)
  8005a4:	50                   	push   %eax
  8005a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a8:	ff d0                	call   *%eax
  8005aa:	83 c4 10             	add    $0x10,%esp
}
  8005ad:	90                   	nop
  8005ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005b6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ba:	7e 1c                	jle    8005d8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	8d 50 08             	lea    0x8(%eax),%edx
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	89 10                	mov    %edx,(%eax)
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	83 e8 08             	sub    $0x8,%eax
  8005d1:	8b 50 04             	mov    0x4(%eax),%edx
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	eb 40                	jmp    800618 <getuint+0x65>
	else if (lflag)
  8005d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005dc:	74 1e                	je     8005fc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 04             	lea    0x4(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 04             	sub    $0x4,%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	eb 1c                	jmp    800618 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	8d 50 04             	lea    0x4(%eax),%edx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	89 10                	mov    %edx,(%eax)
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	83 e8 04             	sub    $0x4,%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800618:	5d                   	pop    %ebp
  800619:	c3                   	ret    

0080061a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80061a:	55                   	push   %ebp
  80061b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80061d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800621:	7e 1c                	jle    80063f <getint+0x25>
		return va_arg(*ap, long long);
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	8d 50 08             	lea    0x8(%eax),%edx
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	89 10                	mov    %edx,(%eax)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 e8 08             	sub    $0x8,%eax
  800638:	8b 50 04             	mov    0x4(%eax),%edx
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	eb 38                	jmp    800677 <getint+0x5d>
	else if (lflag)
  80063f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800643:	74 1a                	je     80065f <getint+0x45>
		return va_arg(*ap, long);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	8d 50 04             	lea    0x4(%eax),%edx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	89 10                	mov    %edx,(%eax)
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	83 e8 04             	sub    $0x4,%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	99                   	cltd   
  80065d:	eb 18                	jmp    800677 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	8d 50 04             	lea    0x4(%eax),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	89 10                	mov    %edx,(%eax)
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	83 e8 04             	sub    $0x4,%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	99                   	cltd   
}
  800677:	5d                   	pop    %ebp
  800678:	c3                   	ret    

00800679 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	56                   	push   %esi
  80067d:	53                   	push   %ebx
  80067e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800681:	eb 17                	jmp    80069a <vprintfmt+0x21>
			if (ch == '\0')
  800683:	85 db                	test   %ebx,%ebx
  800685:	0f 84 c1 03 00 00    	je     800a4c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	53                   	push   %ebx
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	ff d0                	call   *%eax
  800697:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80069a:	8b 45 10             	mov    0x10(%ebp),%eax
  80069d:	8d 50 01             	lea    0x1(%eax),%edx
  8006a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8006a3:	8a 00                	mov    (%eax),%al
  8006a5:	0f b6 d8             	movzbl %al,%ebx
  8006a8:	83 fb 25             	cmp    $0x25,%ebx
  8006ab:	75 d6                	jne    800683 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006ad:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d0:	8d 50 01             	lea    0x1(%eax),%edx
  8006d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8006d6:	8a 00                	mov    (%eax),%al
  8006d8:	0f b6 d8             	movzbl %al,%ebx
  8006db:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006de:	83 f8 5b             	cmp    $0x5b,%eax
  8006e1:	0f 87 3d 03 00 00    	ja     800a24 <vprintfmt+0x3ab>
  8006e7:	8b 04 85 b8 2f 80 00 	mov    0x802fb8(,%eax,4),%eax
  8006ee:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006f0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006f4:	eb d7                	jmp    8006cd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006f6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006fa:	eb d1                	jmp    8006cd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800703:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800706:	89 d0                	mov    %edx,%eax
  800708:	c1 e0 02             	shl    $0x2,%eax
  80070b:	01 d0                	add    %edx,%eax
  80070d:	01 c0                	add    %eax,%eax
  80070f:	01 d8                	add    %ebx,%eax
  800711:	83 e8 30             	sub    $0x30,%eax
  800714:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800717:	8b 45 10             	mov    0x10(%ebp),%eax
  80071a:	8a 00                	mov    (%eax),%al
  80071c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80071f:	83 fb 2f             	cmp    $0x2f,%ebx
  800722:	7e 3e                	jle    800762 <vprintfmt+0xe9>
  800724:	83 fb 39             	cmp    $0x39,%ebx
  800727:	7f 39                	jg     800762 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800729:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80072c:	eb d5                	jmp    800703 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	83 c0 04             	add    $0x4,%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800742:	eb 1f                	jmp    800763 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800744:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800748:	79 83                	jns    8006cd <vprintfmt+0x54>
				width = 0;
  80074a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800751:	e9 77 ff ff ff       	jmp    8006cd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800756:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80075d:	e9 6b ff ff ff       	jmp    8006cd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800762:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800763:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800767:	0f 89 60 ff ff ff    	jns    8006cd <vprintfmt+0x54>
				width = precision, precision = -1;
  80076d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800773:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80077a:	e9 4e ff ff ff       	jmp    8006cd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80077f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800782:	e9 46 ff ff ff       	jmp    8006cd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	83 c0 04             	add    $0x4,%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	83 e8 04             	sub    $0x4,%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	50                   	push   %eax
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
			break;
  8007a7:	e9 9b 02 00 00       	jmp    800a47 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	83 c0 04             	add    $0x4,%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	83 e8 04             	sub    $0x4,%eax
  8007bb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007bd:	85 db                	test   %ebx,%ebx
  8007bf:	79 02                	jns    8007c3 <vprintfmt+0x14a>
				err = -err;
  8007c1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007c3:	83 fb 64             	cmp    $0x64,%ebx
  8007c6:	7f 0b                	jg     8007d3 <vprintfmt+0x15a>
  8007c8:	8b 34 9d 00 2e 80 00 	mov    0x802e00(,%ebx,4),%esi
  8007cf:	85 f6                	test   %esi,%esi
  8007d1:	75 19                	jne    8007ec <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007d3:	53                   	push   %ebx
  8007d4:	68 a5 2f 80 00       	push   $0x802fa5
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	ff 75 08             	pushl  0x8(%ebp)
  8007df:	e8 70 02 00 00       	call   800a54 <printfmt>
  8007e4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007e7:	e9 5b 02 00 00       	jmp    800a47 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ec:	56                   	push   %esi
  8007ed:	68 ae 2f 80 00       	push   $0x802fae
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	ff 75 08             	pushl  0x8(%ebp)
  8007f8:	e8 57 02 00 00       	call   800a54 <printfmt>
  8007fd:	83 c4 10             	add    $0x10,%esp
			break;
  800800:	e9 42 02 00 00       	jmp    800a47 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	83 c0 04             	add    $0x4,%eax
  80080b:	89 45 14             	mov    %eax,0x14(%ebp)
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	83 e8 04             	sub    $0x4,%eax
  800814:	8b 30                	mov    (%eax),%esi
  800816:	85 f6                	test   %esi,%esi
  800818:	75 05                	jne    80081f <vprintfmt+0x1a6>
				p = "(null)";
  80081a:	be b1 2f 80 00       	mov    $0x802fb1,%esi
			if (width > 0 && padc != '-')
  80081f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800823:	7e 6d                	jle    800892 <vprintfmt+0x219>
  800825:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800829:	74 67                	je     800892 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80082b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	50                   	push   %eax
  800832:	56                   	push   %esi
  800833:	e8 26 05 00 00       	call   800d5e <strnlen>
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80083e:	eb 16                	jmp    800856 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800840:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	50                   	push   %eax
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800853:	ff 4d e4             	decl   -0x1c(%ebp)
  800856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085a:	7f e4                	jg     800840 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80085c:	eb 34                	jmp    800892 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80085e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800862:	74 1c                	je     800880 <vprintfmt+0x207>
  800864:	83 fb 1f             	cmp    $0x1f,%ebx
  800867:	7e 05                	jle    80086e <vprintfmt+0x1f5>
  800869:	83 fb 7e             	cmp    $0x7e,%ebx
  80086c:	7e 12                	jle    800880 <vprintfmt+0x207>
					putch('?', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	6a 3f                	push   $0x3f
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	eb 0f                	jmp    80088f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	53                   	push   %ebx
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	ff d0                	call   *%eax
  80088c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80088f:	ff 4d e4             	decl   -0x1c(%ebp)
  800892:	89 f0                	mov    %esi,%eax
  800894:	8d 70 01             	lea    0x1(%eax),%esi
  800897:	8a 00                	mov    (%eax),%al
  800899:	0f be d8             	movsbl %al,%ebx
  80089c:	85 db                	test   %ebx,%ebx
  80089e:	74 24                	je     8008c4 <vprintfmt+0x24b>
  8008a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008a4:	78 b8                	js     80085e <vprintfmt+0x1e5>
  8008a6:	ff 4d e0             	decl   -0x20(%ebp)
  8008a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008ad:	79 af                	jns    80085e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008af:	eb 13                	jmp    8008c4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	6a 20                	push   $0x20
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	ff d0                	call   *%eax
  8008be:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7f e7                	jg     8008b1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008ca:	e9 78 01 00 00       	jmp    800a47 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d8:	50                   	push   %eax
  8008d9:	e8 3c fd ff ff       	call   80061a <getint>
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ed:	85 d2                	test   %edx,%edx
  8008ef:	79 23                	jns    800914 <vprintfmt+0x29b>
				putch('-', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	6a 2d                	push   $0x2d
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800907:	f7 d8                	neg    %eax
  800909:	83 d2 00             	adc    $0x0,%edx
  80090c:	f7 da                	neg    %edx
  80090e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800911:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800914:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80091b:	e9 bc 00 00 00       	jmp    8009dc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 e8             	pushl  -0x18(%ebp)
  800926:	8d 45 14             	lea    0x14(%ebp),%eax
  800929:	50                   	push   %eax
  80092a:	e8 84 fc ff ff       	call   8005b3 <getuint>
  80092f:	83 c4 10             	add    $0x10,%esp
  800932:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800935:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800938:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80093f:	e9 98 00 00 00       	jmp    8009dc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 58                	push   $0x58
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	6a 58                	push   $0x58
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	6a 58                	push   $0x58
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	ff d0                	call   *%eax
  800971:	83 c4 10             	add    $0x10,%esp
			break;
  800974:	e9 ce 00 00 00       	jmp    800a47 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 0c             	pushl  0xc(%ebp)
  80097f:	6a 30                	push   $0x30
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	ff d0                	call   *%eax
  800986:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	6a 78                	push   $0x78
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	ff d0                	call   *%eax
  800996:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 c0 04             	add    $0x4,%eax
  80099f:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	83 e8 04             	sub    $0x4,%eax
  8009a8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009b4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009bb:	eb 1f                	jmp    8009dc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c6:	50                   	push   %eax
  8009c7:	e8 e7 fb ff ff       	call   8005b3 <getuint>
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009dc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e3:	83 ec 04             	sub    $0x4,%esp
  8009e6:	52                   	push   %edx
  8009e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ea:	50                   	push   %eax
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	e8 00 fb ff ff       	call   8004fc <printnum>
  8009fc:	83 c4 20             	add    $0x20,%esp
			break;
  8009ff:	eb 46                	jmp    800a47 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	53                   	push   %ebx
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	ff d0                	call   *%eax
  800a0d:	83 c4 10             	add    $0x10,%esp
			break;
  800a10:	eb 35                	jmp    800a47 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a12:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800a19:	eb 2c                	jmp    800a47 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a1b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800a22:	eb 23                	jmp    800a47 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 25                	push   $0x25
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a34:	ff 4d 10             	decl   0x10(%ebp)
  800a37:	eb 03                	jmp    800a3c <vprintfmt+0x3c3>
  800a39:	ff 4d 10             	decl   0x10(%ebp)
  800a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3f:	48                   	dec    %eax
  800a40:	8a 00                	mov    (%eax),%al
  800a42:	3c 25                	cmp    $0x25,%al
  800a44:	75 f3                	jne    800a39 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a46:	90                   	nop
		}
	}
  800a47:	e9 35 fc ff ff       	jmp    800681 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a4c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800a5d:	83 c0 04             	add    $0x4,%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a63:	8b 45 10             	mov    0x10(%ebp),%eax
  800a66:	ff 75 f4             	pushl  -0xc(%ebp)
  800a69:	50                   	push   %eax
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	ff 75 08             	pushl  0x8(%ebp)
  800a70:	e8 04 fc ff ff       	call   800679 <vprintfmt>
  800a75:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a78:	90                   	nop
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a81:	8b 40 08             	mov    0x8(%eax),%eax
  800a84:	8d 50 01             	lea    0x1(%eax),%edx
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a90:	8b 10                	mov    (%eax),%edx
  800a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a95:	8b 40 04             	mov    0x4(%eax),%eax
  800a98:	39 c2                	cmp    %eax,%edx
  800a9a:	73 12                	jae    800aae <sprintputch+0x33>
		*b->buf++ = ch;
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	8d 48 01             	lea    0x1(%eax),%ecx
  800aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa7:	89 0a                	mov    %ecx,(%edx)
  800aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aac:	88 10                	mov    %dl,(%eax)
}
  800aae:	90                   	nop
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	01 d0                	add    %edx,%eax
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ad2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ad6:	74 06                	je     800ade <vsnprintf+0x2d>
  800ad8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800adc:	7f 07                	jg     800ae5 <vsnprintf+0x34>
		return -E_INVAL;
  800ade:	b8 03 00 00 00       	mov    $0x3,%eax
  800ae3:	eb 20                	jmp    800b05 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ae5:	ff 75 14             	pushl  0x14(%ebp)
  800ae8:	ff 75 10             	pushl  0x10(%ebp)
  800aeb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aee:	50                   	push   %eax
  800aef:	68 7b 0a 80 00       	push   $0x800a7b
  800af4:	e8 80 fb ff ff       	call   800679 <vprintfmt>
  800af9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b0d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b10:	83 c0 04             	add    $0x4,%eax
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b16:	8b 45 10             	mov    0x10(%ebp),%eax
  800b19:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1c:	50                   	push   %eax
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	ff 75 08             	pushl  0x8(%ebp)
  800b23:	e8 89 ff ff ff       	call   800ab1 <vsnprintf>
  800b28:	83 c4 10             	add    $0x10,%esp
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b3d:	74 13                	je     800b52 <readline+0x1f>
		cprintf("%s", prompt);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 08             	pushl  0x8(%ebp)
  800b45:	68 28 31 80 00       	push   $0x803128
  800b4a:	e8 0b f9 ff ff       	call   80045a <cprintf>
  800b4f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b59:	83 ec 0c             	sub    $0xc,%esp
  800b5c:	6a 00                	push   $0x0
  800b5e:	e8 1e 1c 00 00       	call   802781 <iscons>
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b69:	e8 00 1c 00 00       	call   80276e <getchar>
  800b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b75:	79 22                	jns    800b99 <readline+0x66>
			if (c != -E_EOF)
  800b77:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b7b:	0f 84 ad 00 00 00    	je     800c2e <readline+0xfb>
				cprintf("read error: %e\n", c);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 ec             	pushl  -0x14(%ebp)
  800b87:	68 2b 31 80 00       	push   $0x80312b
  800b8c:	e8 c9 f8 ff ff       	call   80045a <cprintf>
  800b91:	83 c4 10             	add    $0x10,%esp
			break;
  800b94:	e9 95 00 00 00       	jmp    800c2e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b99:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b9d:	7e 34                	jle    800bd3 <readline+0xa0>
  800b9f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ba6:	7f 2b                	jg     800bd3 <readline+0xa0>
			if (echoing)
  800ba8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bac:	74 0e                	je     800bbc <readline+0x89>
				cputchar(c);
  800bae:	83 ec 0c             	sub    $0xc,%esp
  800bb1:	ff 75 ec             	pushl  -0x14(%ebp)
  800bb4:	e8 96 1b 00 00       	call   80274f <cputchar>
  800bb9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bbf:	8d 50 01             	lea    0x1(%eax),%edx
  800bc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bc5:	89 c2                	mov    %eax,%edx
  800bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bca:	01 d0                	add    %edx,%eax
  800bcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bcf:	88 10                	mov    %dl,(%eax)
  800bd1:	eb 56                	jmp    800c29 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800bd3:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bd7:	75 1f                	jne    800bf8 <readline+0xc5>
  800bd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bdd:	7e 19                	jle    800bf8 <readline+0xc5>
			if (echoing)
  800bdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800be3:	74 0e                	je     800bf3 <readline+0xc0>
				cputchar(c);
  800be5:	83 ec 0c             	sub    $0xc,%esp
  800be8:	ff 75 ec             	pushl  -0x14(%ebp)
  800beb:	e8 5f 1b 00 00       	call   80274f <cputchar>
  800bf0:	83 c4 10             	add    $0x10,%esp

			i--;
  800bf3:	ff 4d f4             	decl   -0xc(%ebp)
  800bf6:	eb 31                	jmp    800c29 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800bf8:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800bfc:	74 0a                	je     800c08 <readline+0xd5>
  800bfe:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c02:	0f 85 61 ff ff ff    	jne    800b69 <readline+0x36>
			if (echoing)
  800c08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c0c:	74 0e                	je     800c1c <readline+0xe9>
				cputchar(c);
  800c0e:	83 ec 0c             	sub    $0xc,%esp
  800c11:	ff 75 ec             	pushl  -0x14(%ebp)
  800c14:	e8 36 1b 00 00       	call   80274f <cputchar>
  800c19:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800c27:	eb 06                	jmp    800c2f <readline+0xfc>
		}
	}
  800c29:	e9 3b ff ff ff       	jmp    800b69 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800c2e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800c2f:	90                   	nop
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800c38:	e8 30 0b 00 00       	call   80176d <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800c3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c41:	74 13                	je     800c56 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800c43:	83 ec 08             	sub    $0x8,%esp
  800c46:	ff 75 08             	pushl  0x8(%ebp)
  800c49:	68 28 31 80 00       	push   $0x803128
  800c4e:	e8 07 f8 ff ff       	call   80045a <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800c5d:	83 ec 0c             	sub    $0xc,%esp
  800c60:	6a 00                	push   $0x0
  800c62:	e8 1a 1b 00 00       	call   802781 <iscons>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800c6d:	e8 fc 1a 00 00       	call   80276e <getchar>
  800c72:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800c75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c79:	79 22                	jns    800c9d <atomic_readline+0x6b>
				if (c != -E_EOF)
  800c7b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c7f:	0f 84 ad 00 00 00    	je     800d32 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800c85:	83 ec 08             	sub    $0x8,%esp
  800c88:	ff 75 ec             	pushl  -0x14(%ebp)
  800c8b:	68 2b 31 80 00       	push   $0x80312b
  800c90:	e8 c5 f7 ff ff       	call   80045a <cprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
				break;
  800c98:	e9 95 00 00 00       	jmp    800d32 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800c9d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ca1:	7e 34                	jle    800cd7 <atomic_readline+0xa5>
  800ca3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800caa:	7f 2b                	jg     800cd7 <atomic_readline+0xa5>
				if (echoing)
  800cac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cb0:	74 0e                	je     800cc0 <atomic_readline+0x8e>
					cputchar(c);
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	ff 75 ec             	pushl  -0x14(%ebp)
  800cb8:	e8 92 1a 00 00       	call   80274f <cputchar>
  800cbd:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc3:	8d 50 01             	lea    0x1(%eax),%edx
  800cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800cc9:	89 c2                	mov    %eax,%edx
  800ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cce:	01 d0                	add    %edx,%eax
  800cd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800cd3:	88 10                	mov    %dl,(%eax)
  800cd5:	eb 56                	jmp    800d2d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800cd7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800cdb:	75 1f                	jne    800cfc <atomic_readline+0xca>
  800cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ce1:	7e 19                	jle    800cfc <atomic_readline+0xca>
				if (echoing)
  800ce3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ce7:	74 0e                	je     800cf7 <atomic_readline+0xc5>
					cputchar(c);
  800ce9:	83 ec 0c             	sub    $0xc,%esp
  800cec:	ff 75 ec             	pushl  -0x14(%ebp)
  800cef:	e8 5b 1a 00 00       	call   80274f <cputchar>
  800cf4:	83 c4 10             	add    $0x10,%esp
				i--;
  800cf7:	ff 4d f4             	decl   -0xc(%ebp)
  800cfa:	eb 31                	jmp    800d2d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800cfc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800d00:	74 0a                	je     800d0c <atomic_readline+0xda>
  800d02:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800d06:	0f 85 61 ff ff ff    	jne    800c6d <atomic_readline+0x3b>
				if (echoing)
  800d0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d10:	74 0e                	je     800d20 <atomic_readline+0xee>
					cputchar(c);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	ff 75 ec             	pushl  -0x14(%ebp)
  800d18:	e8 32 1a 00 00       	call   80274f <cputchar>
  800d1d:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	01 d0                	add    %edx,%eax
  800d28:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800d2b:	eb 06                	jmp    800d33 <atomic_readline+0x101>
			}
		}
  800d2d:	e9 3b ff ff ff       	jmp    800c6d <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800d32:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800d33:	e8 4f 0a 00 00       	call   801787 <sys_unlock_cons>
}
  800d38:	90                   	nop
  800d39:	c9                   	leave  
  800d3a:	c3                   	ret    

00800d3b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d48:	eb 06                	jmp    800d50 <strlen+0x15>
		n++;
  800d4a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4d:	ff 45 08             	incl   0x8(%ebp)
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	84 c0                	test   %al,%al
  800d57:	75 f1                	jne    800d4a <strlen+0xf>
		n++;
	return n;
  800d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d6b:	eb 09                	jmp    800d76 <strnlen+0x18>
		n++;
  800d6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d70:	ff 45 08             	incl   0x8(%ebp)
  800d73:	ff 4d 0c             	decl   0xc(%ebp)
  800d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7a:	74 09                	je     800d85 <strnlen+0x27>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	84 c0                	test   %al,%al
  800d83:	75 e8                	jne    800d6d <strnlen+0xf>
		n++;
	return n;
  800d85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d96:	90                   	nop
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da9:	8a 12                	mov    (%edx),%dl
  800dab:	88 10                	mov    %dl,(%eax)
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	84 c0                	test   %al,%al
  800db1:	75 e4                	jne    800d97 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db6:	c9                   	leave  
  800db7:	c3                   	ret    

00800db8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcb:	eb 1f                	jmp    800dec <strncpy+0x34>
		*dst++ = *src;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8d 50 01             	lea    0x1(%eax),%edx
  800dd3:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd9:	8a 12                	mov    (%edx),%dl
  800ddb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 03                	je     800de9 <strncpy+0x31>
			src++;
  800de6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de9:	ff 45 fc             	incl   -0x4(%ebp)
  800dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800def:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df2:	72 d9                	jb     800dcd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e09:	74 30                	je     800e3b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e0b:	eb 16                	jmp    800e23 <strlcpy+0x2a>
			*dst++ = *src++;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8d 50 01             	lea    0x1(%eax),%edx
  800e13:	89 55 08             	mov    %edx,0x8(%ebp)
  800e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e19:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e1f:	8a 12                	mov    (%edx),%dl
  800e21:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e23:	ff 4d 10             	decl   0x10(%ebp)
  800e26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2a:	74 09                	je     800e35 <strlcpy+0x3c>
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	84 c0                	test   %al,%al
  800e33:	75 d8                	jne    800e0d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e41:	29 c2                	sub    %eax,%edx
  800e43:	89 d0                	mov    %edx,%eax
}
  800e45:	c9                   	leave  
  800e46:	c3                   	ret    

00800e47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e4a:	eb 06                	jmp    800e52 <strcmp+0xb>
		p++, q++;
  800e4c:	ff 45 08             	incl   0x8(%ebp)
  800e4f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	74 0e                	je     800e69 <strcmp+0x22>
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	38 c2                	cmp    %al,%dl
  800e67:	74 e3                	je     800e4c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	0f b6 d0             	movzbl %al,%edx
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	0f b6 c0             	movzbl %al,%eax
  800e79:	29 c2                	sub    %eax,%edx
  800e7b:	89 d0                	mov    %edx,%eax
}
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e82:	eb 09                	jmp    800e8d <strncmp+0xe>
		n--, p++, q++;
  800e84:	ff 4d 10             	decl   0x10(%ebp)
  800e87:	ff 45 08             	incl   0x8(%ebp)
  800e8a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e91:	74 17                	je     800eaa <strncmp+0x2b>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	74 0e                	je     800eaa <strncmp+0x2b>
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8a 10                	mov    (%eax),%dl
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	38 c2                	cmp    %al,%dl
  800ea8:	74 da                	je     800e84 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	75 07                	jne    800eb7 <strncmp+0x38>
		return 0;
  800eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb5:	eb 14                	jmp    800ecb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	0f b6 d0             	movzbl %al,%edx
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	0f b6 c0             	movzbl %al,%eax
  800ec7:	29 c2                	sub    %eax,%edx
  800ec9:	89 d0                	mov    %edx,%eax
}
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 04             	sub    $0x4,%esp
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed9:	eb 12                	jmp    800eed <strchr+0x20>
		if (*s == c)
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee3:	75 05                	jne    800eea <strchr+0x1d>
			return (char *) s;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	eb 11                	jmp    800efb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eea:	ff 45 08             	incl   0x8(%ebp)
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	84 c0                	test   %al,%al
  800ef4:	75 e5                	jne    800edb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ef6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 04             	sub    $0x4,%esp
  800f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f09:	eb 0d                	jmp    800f18 <strfind+0x1b>
		if (*s == c)
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f13:	74 0e                	je     800f23 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f15:	ff 45 08             	incl   0x8(%ebp)
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	84 c0                	test   %al,%al
  800f1f:	75 ea                	jne    800f0b <strfind+0xe>
  800f21:	eb 01                	jmp    800f24 <strfind+0x27>
		if (*s == c)
			break;
  800f23:	90                   	nop
	return (char *) s;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f35:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f39:	76 63                	jbe    800f9e <memset+0x75>
		uint64 data_block = c;
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	99                   	cltd   
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f4f:	c1 e0 08             	shl    $0x8,%eax
  800f52:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f55:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f62:	c1 e0 10             	shl    $0x10,%eax
  800f65:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f68:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f71:	89 c2                	mov    %eax,%edx
  800f73:	b8 00 00 00 00       	mov    $0x0,%eax
  800f78:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f7b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f7e:	eb 18                	jmp    800f98 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f80:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f83:	8d 41 08             	lea    0x8(%ecx),%eax
  800f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f8f:	89 01                	mov    %eax,(%ecx)
  800f91:	89 51 04             	mov    %edx,0x4(%ecx)
  800f94:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f98:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f9c:	77 e2                	ja     800f80 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	74 23                	je     800fc7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800faa:	eb 0e                	jmp    800fba <memset+0x91>
			*p8++ = (uint8)c;
  800fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faf:	8d 50 01             	lea    0x1(%eax),%edx
  800fb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	75 e5                	jne    800fac <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fde:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fe2:	76 24                	jbe    801008 <memcpy+0x3c>
		while(n >= 8){
  800fe4:	eb 1c                	jmp    801002 <memcpy+0x36>
			*d64 = *s64;
  800fe6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe9:	8b 50 04             	mov    0x4(%eax),%edx
  800fec:	8b 00                	mov    (%eax),%eax
  800fee:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ff1:	89 01                	mov    %eax,(%ecx)
  800ff3:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ff6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ffa:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ffe:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801002:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801006:	77 de                	ja     800fe6 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 31                	je     80103f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801014:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801017:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80101a:	eb 16                	jmp    801032 <memcpy+0x66>
			*d8++ = *s8++;
  80101c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101f:	8d 50 01             	lea    0x1(%eax),%edx
  801022:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	8d 4a 01             	lea    0x1(%edx),%ecx
  80102b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80102e:	8a 12                	mov    (%edx),%dl
  801030:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801032:	8b 45 10             	mov    0x10(%ebp),%eax
  801035:	8d 50 ff             	lea    -0x1(%eax),%edx
  801038:	89 55 10             	mov    %edx,0x10(%ebp)
  80103b:	85 c0                	test   %eax,%eax
  80103d:	75 dd                	jne    80101c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	73 50                	jae    8010ae <memmove+0x6a>
  80105e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801061:	8b 45 10             	mov    0x10(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801069:	76 43                	jbe    8010ae <memmove+0x6a>
		s += n;
  80106b:	8b 45 10             	mov    0x10(%ebp),%eax
  80106e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801071:	8b 45 10             	mov    0x10(%ebp),%eax
  801074:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801077:	eb 10                	jmp    801089 <memmove+0x45>
			*--d = *--s;
  801079:	ff 4d f8             	decl   -0x8(%ebp)
  80107c:	ff 4d fc             	decl   -0x4(%ebp)
  80107f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801082:	8a 10                	mov    (%eax),%dl
  801084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801087:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801089:	8b 45 10             	mov    0x10(%ebp),%eax
  80108c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108f:	89 55 10             	mov    %edx,0x10(%ebp)
  801092:	85 c0                	test   %eax,%eax
  801094:	75 e3                	jne    801079 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801096:	eb 23                	jmp    8010bb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801098:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109b:	8d 50 01             	lea    0x1(%eax),%edx
  80109e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010aa:	8a 12                	mov    (%edx),%dl
  8010ac:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	75 dd                	jne    801098 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    

008010c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d2:	eb 2a                	jmp    8010fe <memcmp+0x3e>
		if (*s1 != *s2)
  8010d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d7:	8a 10                	mov    (%eax),%dl
  8010d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	38 c2                	cmp    %al,%dl
  8010e0:	74 16                	je     8010f8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	0f b6 d0             	movzbl %al,%edx
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	0f b6 c0             	movzbl %al,%eax
  8010f2:	29 c2                	sub    %eax,%edx
  8010f4:	89 d0                	mov    %edx,%eax
  8010f6:	eb 18                	jmp    801110 <memcmp+0x50>
		s1++, s2++;
  8010f8:	ff 45 fc             	incl   -0x4(%ebp)
  8010fb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	8d 50 ff             	lea    -0x1(%eax),%edx
  801104:	89 55 10             	mov    %edx,0x10(%ebp)
  801107:	85 c0                	test   %eax,%eax
  801109:	75 c9                	jne    8010d4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80110b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801123:	eb 15                	jmp    80113a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	0f b6 d0             	movzbl %al,%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	0f b6 c0             	movzbl %al,%eax
  801133:	39 c2                	cmp    %eax,%edx
  801135:	74 0d                	je     801144 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801137:	ff 45 08             	incl   0x8(%ebp)
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801140:	72 e3                	jb     801125 <memfind+0x13>
  801142:	eb 01                	jmp    801145 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801144:	90                   	nop
	return (void *) s;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115e:	eb 03                	jmp    801163 <strtol+0x19>
		s++;
  801160:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	3c 20                	cmp    $0x20,%al
  80116a:	74 f4                	je     801160 <strtol+0x16>
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	3c 09                	cmp    $0x9,%al
  801173:	74 eb                	je     801160 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 2b                	cmp    $0x2b,%al
  80117c:	75 05                	jne    801183 <strtol+0x39>
		s++;
  80117e:	ff 45 08             	incl   0x8(%ebp)
  801181:	eb 13                	jmp    801196 <strtol+0x4c>
	else if (*s == '-')
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 2d                	cmp    $0x2d,%al
  80118a:	75 0a                	jne    801196 <strtol+0x4c>
		s++, neg = 1;
  80118c:	ff 45 08             	incl   0x8(%ebp)
  80118f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801196:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119a:	74 06                	je     8011a2 <strtol+0x58>
  80119c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011a0:	75 20                	jne    8011c2 <strtol+0x78>
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	3c 30                	cmp    $0x30,%al
  8011a9:	75 17                	jne    8011c2 <strtol+0x78>
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	40                   	inc    %eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3c 78                	cmp    $0x78,%al
  8011b3:	75 0d                	jne    8011c2 <strtol+0x78>
		s += 2, base = 16;
  8011b5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011b9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011c0:	eb 28                	jmp    8011ea <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c6:	75 15                	jne    8011dd <strtol+0x93>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 30                	cmp    $0x30,%al
  8011cf:	75 0c                	jne    8011dd <strtol+0x93>
		s++, base = 8;
  8011d1:	ff 45 08             	incl   0x8(%ebp)
  8011d4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011db:	eb 0d                	jmp    8011ea <strtol+0xa0>
	else if (base == 0)
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	75 07                	jne    8011ea <strtol+0xa0>
		base = 10;
  8011e3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 2f                	cmp    $0x2f,%al
  8011f1:	7e 19                	jle    80120c <strtol+0xc2>
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	3c 39                	cmp    $0x39,%al
  8011fa:	7f 10                	jg     80120c <strtol+0xc2>
			dig = *s - '0';
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	0f be c0             	movsbl %al,%eax
  801204:	83 e8 30             	sub    $0x30,%eax
  801207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80120a:	eb 42                	jmp    80124e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 60                	cmp    $0x60,%al
  801213:	7e 19                	jle    80122e <strtol+0xe4>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 7a                	cmp    $0x7a,%al
  80121c:	7f 10                	jg     80122e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 57             	sub    $0x57,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 20                	jmp    80124e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 40                	cmp    $0x40,%al
  801235:	7e 39                	jle    801270 <strtol+0x126>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 5a                	cmp    $0x5a,%al
  80123e:	7f 30                	jg     801270 <strtol+0x126>
			dig = *s - 'A' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 37             	sub    $0x37,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 10             	cmp    0x10(%ebp),%eax
  801254:	7d 19                	jge    80126f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801256:	ff 45 08             	incl   0x8(%ebp)
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801260:	89 c2                	mov    %eax,%edx
  801262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801265:	01 d0                	add    %edx,%eax
  801267:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80126a:	e9 7b ff ff ff       	jmp    8011ea <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80126f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801270:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801274:	74 08                	je     80127e <strtol+0x134>
		*endptr = (char *) s;
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	8b 55 08             	mov    0x8(%ebp),%edx
  80127c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80127e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801282:	74 07                	je     80128b <strtol+0x141>
  801284:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801287:	f7 d8                	neg    %eax
  801289:	eb 03                	jmp    80128e <strtol+0x144>
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <ltostr>:

void
ltostr(long value, char *str)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801296:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80129d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a8:	79 13                	jns    8012bd <ltostr+0x2d>
	{
		neg = 1;
  8012aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012b7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ba:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012c5:	99                   	cltd   
  8012c6:	f7 f9                	idiv   %ecx
  8012c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ce:	8d 50 01             	lea    0x1(%eax),%edx
  8012d1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012d4:	89 c2                	mov    %eax,%edx
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	01 d0                	add    %edx,%eax
  8012db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012de:	83 c2 30             	add    $0x30,%edx
  8012e1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012eb:	f7 e9                	imul   %ecx
  8012ed:	c1 fa 02             	sar    $0x2,%edx
  8012f0:	89 c8                	mov    %ecx,%eax
  8012f2:	c1 f8 1f             	sar    $0x1f,%eax
  8012f5:	29 c2                	sub    %eax,%edx
  8012f7:	89 d0                	mov    %edx,%eax
  8012f9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801300:	75 bb                	jne    8012bd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	48                   	dec    %eax
  80130d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801310:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801314:	74 3d                	je     801353 <ltostr+0xc3>
		start = 1 ;
  801316:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80131d:	eb 34                	jmp    801353 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80131f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80132c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	01 c2                	add    %eax,%edx
  801334:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 c8                	add    %ecx,%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801340:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	01 c2                	add    %eax,%edx
  801348:	8a 45 eb             	mov    -0x15(%ebp),%al
  80134b:	88 02                	mov    %al,(%edx)
		start++ ;
  80134d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801350:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801356:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801359:	7c c4                	jl     80131f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80135b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	01 d0                	add    %edx,%eax
  801363:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801366:	90                   	nop
  801367:	c9                   	leave  
  801368:	c3                   	ret    

00801369 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80136f:	ff 75 08             	pushl  0x8(%ebp)
  801372:	e8 c4 f9 ff ff       	call   800d3b <strlen>
  801377:	83 c4 04             	add    $0x4,%esp
  80137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80137d:	ff 75 0c             	pushl  0xc(%ebp)
  801380:	e8 b6 f9 ff ff       	call   800d3b <strlen>
  801385:	83 c4 04             	add    $0x4,%esp
  801388:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80138b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801392:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801399:	eb 17                	jmp    8013b2 <strcconcat+0x49>
		final[s] = str1[s] ;
  80139b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139e:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a1:	01 c2                	add    %eax,%edx
  8013a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	01 c8                	add    %ecx,%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013af:	ff 45 fc             	incl   -0x4(%ebp)
  8013b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013b8:	7c e1                	jl     80139b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013c8:	eb 1f                	jmp    8013e9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cd:	8d 50 01             	lea    0x1(%eax),%edx
  8013d0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d8:	01 c2                	add    %eax,%edx
  8013da:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e0:	01 c8                	add    %ecx,%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013e6:	ff 45 f8             	incl   -0x8(%ebp)
  8013e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ef:	7c d9                	jl     8013ca <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	01 d0                	add    %edx,%eax
  8013f9:	c6 00 00             	movb   $0x0,(%eax)
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801402:	8b 45 14             	mov    0x14(%ebp),%eax
  801405:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80140b:	8b 45 14             	mov    0x14(%ebp),%eax
  80140e:	8b 00                	mov    (%eax),%eax
  801410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	01 d0                	add    %edx,%eax
  80141c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801422:	eb 0c                	jmp    801430 <strsplit+0x31>
			*string++ = 0;
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8d 50 01             	lea    0x1(%eax),%edx
  80142a:	89 55 08             	mov    %edx,0x8(%ebp)
  80142d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	84 c0                	test   %al,%al
  801437:	74 18                	je     801451 <strsplit+0x52>
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	50                   	push   %eax
  801442:	ff 75 0c             	pushl  0xc(%ebp)
  801445:	e8 83 fa ff ff       	call   800ecd <strchr>
  80144a:	83 c4 08             	add    $0x8,%esp
  80144d:	85 c0                	test   %eax,%eax
  80144f:	75 d3                	jne    801424 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	84 c0                	test   %al,%al
  801458:	74 5a                	je     8014b4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80145a:	8b 45 14             	mov    0x14(%ebp),%eax
  80145d:	8b 00                	mov    (%eax),%eax
  80145f:	83 f8 0f             	cmp    $0xf,%eax
  801462:	75 07                	jne    80146b <strsplit+0x6c>
		{
			return 0;
  801464:	b8 00 00 00 00       	mov    $0x0,%eax
  801469:	eb 66                	jmp    8014d1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80146b:	8b 45 14             	mov    0x14(%ebp),%eax
  80146e:	8b 00                	mov    (%eax),%eax
  801470:	8d 48 01             	lea    0x1(%eax),%ecx
  801473:	8b 55 14             	mov    0x14(%ebp),%edx
  801476:	89 0a                	mov    %ecx,(%edx)
  801478:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147f:	8b 45 10             	mov    0x10(%ebp),%eax
  801482:	01 c2                	add    %eax,%edx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801489:	eb 03                	jmp    80148e <strsplit+0x8f>
			string++;
  80148b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	84 c0                	test   %al,%al
  801495:	74 8b                	je     801422 <strsplit+0x23>
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	0f be c0             	movsbl %al,%eax
  80149f:	50                   	push   %eax
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	e8 25 fa ff ff       	call   800ecd <strchr>
  8014a8:	83 c4 08             	add    $0x8,%esp
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	74 dc                	je     80148b <strsplit+0x8c>
			string++;
	}
  8014af:	e9 6e ff ff ff       	jmp    801422 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	8b 00                	mov    (%eax),%eax
  8014ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014cc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e6:	eb 4a                	jmp    801532 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	01 c2                	add    %eax,%edx
  8014f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f6:	01 c8                	add    %ecx,%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801502:	01 d0                	add    %edx,%eax
  801504:	8a 00                	mov    (%eax),%al
  801506:	3c 40                	cmp    $0x40,%al
  801508:	7e 25                	jle    80152f <str2lower+0x5c>
  80150a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	01 d0                	add    %edx,%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	3c 5a                	cmp    $0x5a,%al
  801516:	7f 17                	jg     80152f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801518:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	01 d0                	add    %edx,%eax
  801520:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801523:	8b 55 08             	mov    0x8(%ebp),%edx
  801526:	01 ca                	add    %ecx,%edx
  801528:	8a 12                	mov    (%edx),%dl
  80152a:	83 c2 20             	add    $0x20,%edx
  80152d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80152f:	ff 45 fc             	incl   -0x4(%ebp)
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	e8 01 f8 ff ff       	call   800d3b <strlen>
  80153a:	83 c4 04             	add    $0x4,%esp
  80153d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801540:	7f a6                	jg     8014e8 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80154d:	a1 08 40 80 00       	mov    0x804008,%eax
  801552:	85 c0                	test   %eax,%eax
  801554:	74 42                	je     801598 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801556:	83 ec 08             	sub    $0x8,%esp
  801559:	68 00 00 00 82       	push   $0x82000000
  80155e:	68 00 00 00 80       	push   $0x80000000
  801563:	e8 00 08 00 00       	call   801d68 <initialize_dynamic_allocator>
  801568:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80156b:	e8 e7 05 00 00       	call   801b57 <sys_get_uheap_strategy>
  801570:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801575:	a1 40 40 80 00       	mov    0x804040,%eax
  80157a:	05 00 10 00 00       	add    $0x1000,%eax
  80157f:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801584:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801589:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  80158e:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801595:	00 00 00 
	}
}
  801598:	90                   	nop
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015af:	83 ec 08             	sub    $0x8,%esp
  8015b2:	68 06 04 00 00       	push   $0x406
  8015b7:	50                   	push   %eax
  8015b8:	e8 e4 01 00 00       	call   8017a1 <__sys_allocate_page>
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015c7:	79 14                	jns    8015dd <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	68 3c 31 80 00       	push   $0x80313c
  8015d1:	6a 1f                	push   $0x1f
  8015d3:	68 78 31 80 00       	push   $0x803178
  8015d8:	e8 ae 11 00 00       	call   80278b <_panic>
	return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	50                   	push   %eax
  8015fc:	e8 e7 01 00 00       	call   8017e8 <__sys_unmap_frame>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80160b:	79 14                	jns    801621 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	68 84 31 80 00       	push   $0x803184
  801615:	6a 2a                	push   $0x2a
  801617:	68 78 31 80 00       	push   $0x803178
  80161c:	e8 6a 11 00 00       	call   80278b <_panic>
}
  801621:	90                   	nop
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80162a:	e8 18 ff ff ff       	call   801547 <uheap_init>
	if (size == 0) return NULL ;
  80162f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801633:	75 07                	jne    80163c <malloc+0x18>
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
  80163a:	eb 14                	jmp    801650 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 c4 31 80 00       	push   $0x8031c4
  801644:	6a 3e                	push   $0x3e
  801646:	68 78 31 80 00       	push   $0x803178
  80164b:	e8 3b 11 00 00       	call   80278b <_panic>
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 ec 31 80 00       	push   $0x8031ec
  801660:	6a 49                	push   $0x49
  801662:	68 78 31 80 00       	push   $0x803178
  801667:	e8 1f 11 00 00       	call   80278b <_panic>

0080166c <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 18             	sub    $0x18,%esp
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801678:	e8 ca fe ff ff       	call   801547 <uheap_init>
	if (size == 0) return NULL ;
  80167d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801681:	75 07                	jne    80168a <smalloc+0x1e>
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	eb 14                	jmp    80169e <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	68 10 32 80 00       	push   $0x803210
  801692:	6a 5a                	push   $0x5a
  801694:	68 78 31 80 00       	push   $0x803178
  801699:	e8 ed 10 00 00       	call   80278b <_panic>
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016a6:	e8 9c fe ff ff       	call   801547 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	68 38 32 80 00       	push   $0x803238
  8016b3:	6a 6a                	push   $0x6a
  8016b5:	68 78 31 80 00       	push   $0x803178
  8016ba:	e8 cc 10 00 00       	call   80278b <_panic>

008016bf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016c5:	e8 7d fe ff ff       	call   801547 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	68 5c 32 80 00       	push   $0x80325c
  8016d2:	68 88 00 00 00       	push   $0x88
  8016d7:	68 78 31 80 00       	push   $0x803178
  8016dc:	e8 aa 10 00 00       	call   80278b <_panic>

008016e1 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8016e7:	83 ec 04             	sub    $0x4,%esp
  8016ea:	68 84 32 80 00       	push   $0x803284
  8016ef:	68 9b 00 00 00       	push   $0x9b
  8016f4:	68 78 31 80 00       	push   $0x803178
  8016f9:	e8 8d 10 00 00       	call   80278b <_panic>

008016fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	57                   	push   %edi
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801710:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801713:	8b 7d 18             	mov    0x18(%ebp),%edi
  801716:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801719:	cd 30                	int    $0x30
  80171b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5f                   	pop    %edi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	8b 45 10             	mov    0x10(%ebp),%eax
  801732:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801735:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801738:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	6a 00                	push   $0x0
  801741:	51                   	push   %ecx
  801742:	52                   	push   %edx
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	50                   	push   %eax
  801747:	6a 00                	push   $0x0
  801749:	e8 b0 ff ff ff       	call   8016fe <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	90                   	nop
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_cgetc>:

int
sys_cgetc(void)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 02                	push   $0x2
  801763:	e8 96 ff ff ff       	call   8016fe <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 03                	push   $0x3
  80177c:	e8 7d ff ff ff       	call   8016fe <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	90                   	nop
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 04                	push   $0x4
  801796:	e8 63 ff ff ff       	call   8016fe <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	90                   	nop
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	52                   	push   %edx
  8017b1:	50                   	push   %eax
  8017b2:	6a 08                	push   $0x8
  8017b4:	e8 45 ff ff ff       	call   8016fe <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	56                   	push   %esi
  8017c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8017c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	56                   	push   %esi
  8017d3:	53                   	push   %ebx
  8017d4:	51                   	push   %ecx
  8017d5:	52                   	push   %edx
  8017d6:	50                   	push   %eax
  8017d7:	6a 09                	push   $0x9
  8017d9:	e8 20 ff ff ff       	call   8016fe <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e4:	5b                   	pop    %ebx
  8017e5:	5e                   	pop    %esi
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	ff 75 08             	pushl  0x8(%ebp)
  8017f6:	6a 0a                	push   $0xa
  8017f8:	e8 01 ff ff ff       	call   8016fe <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	6a 0b                	push   $0xb
  801813:	e8 e6 fe ff ff       	call   8016fe <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 0c                	push   $0xc
  80182c:	e8 cd fe ff ff       	call   8016fe <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 0d                	push   $0xd
  801845:	e8 b4 fe ff ff       	call   8016fe <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 0e                	push   $0xe
  80185e:	e8 9b fe ff ff       	call   8016fe <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 0f                	push   $0xf
  801877:	e8 82 fe ff ff       	call   8016fe <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	ff 75 08             	pushl  0x8(%ebp)
  80188f:	6a 10                	push   $0x10
  801891:	e8 68 fe ff ff       	call   8016fe <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 11                	push   $0x11
  8018aa:	e8 4f fe ff ff       	call   8016fe <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	90                   	nop
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	50                   	push   %eax
  8018ce:	6a 01                	push   $0x1
  8018d0:	e8 29 fe ff ff       	call   8016fe <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 14                	push   $0x14
  8018ea:	e8 0f fe ff ff       	call   8016fe <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	90                   	nop
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801901:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801904:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	51                   	push   %ecx
  80190e:	52                   	push   %edx
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	50                   	push   %eax
  801913:	6a 15                	push   $0x15
  801915:	e8 e4 fd ff ff       	call   8016fe <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	6a 16                	push   $0x16
  801932:	e8 c7 fd ff ff       	call   8016fe <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80193f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801942:	8b 55 0c             	mov    0xc(%ebp),%edx
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	51                   	push   %ecx
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	6a 17                	push   $0x17
  801951:	e8 a8 fd ff ff       	call   8016fe <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	6a 18                	push   $0x18
  80196e:	e8 8b fd ff ff       	call   8016fe <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	ff 75 14             	pushl  0x14(%ebp)
  801983:	ff 75 10             	pushl  0x10(%ebp)
  801986:	ff 75 0c             	pushl  0xc(%ebp)
  801989:	50                   	push   %eax
  80198a:	6a 19                	push   $0x19
  80198c:	e8 6d fd ff ff       	call   8016fe <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	50                   	push   %eax
  8019a5:	6a 1a                	push   $0x1a
  8019a7:	e8 52 fd ff ff       	call   8016fe <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	90                   	nop
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	50                   	push   %eax
  8019c1:	6a 1b                	push   $0x1b
  8019c3:	e8 36 fd ff ff       	call   8016fe <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 05                	push   $0x5
  8019dc:	e8 1d fd ff ff       	call   8016fe <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 06                	push   $0x6
  8019f5:	e8 04 fd ff ff       	call   8016fe <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 07                	push   $0x7
  801a0e:	e8 eb fc ff ff       	call   8016fe <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_exit_env>:


void sys_exit_env(void)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 1c                	push   $0x1c
  801a27:	e8 d2 fc ff ff       	call   8016fe <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	90                   	nop
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a3b:	8d 50 04             	lea    0x4(%eax),%edx
  801a3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 1d                	push   $0x1d
  801a4b:	e8 ae fc ff ff       	call   8016fe <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
	return result;
  801a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a5c:	89 01                	mov    %eax,(%ecx)
  801a5e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	c9                   	leave  
  801a65:	c2 04 00             	ret    $0x4

00801a68 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	ff 75 10             	pushl  0x10(%ebp)
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	6a 13                	push   $0x13
  801a7a:	e8 7f fc ff ff       	call   8016fe <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a82:	90                   	nop
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 1e                	push   $0x1e
  801a94:	e8 65 fc ff ff       	call   8016fe <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801aaa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	50                   	push   %eax
  801ab7:	6a 1f                	push   $0x1f
  801ab9:	e8 40 fc ff ff       	call   8016fe <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac1:	90                   	nop
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <rsttst>:
void rsttst()
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 21                	push   $0x21
  801ad3:	e8 26 fc ff ff       	call   8016fe <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801aea:	8b 55 18             	mov    0x18(%ebp),%edx
  801aed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	ff 75 10             	pushl  0x10(%ebp)
  801af6:	ff 75 0c             	pushl  0xc(%ebp)
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	6a 20                	push   $0x20
  801afe:	e8 fb fb ff ff       	call   8016fe <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
	return ;
  801b06:	90                   	nop
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <chktst>:
void chktst(uint32 n)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	6a 22                	push   $0x22
  801b19:	e8 e0 fb ff ff       	call   8016fe <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b21:	90                   	nop
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <inctst>:

void inctst()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 23                	push   $0x23
  801b33:	e8 c6 fb ff ff       	call   8016fe <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3b:	90                   	nop
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <gettst>:
uint32 gettst()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 24                	push   $0x24
  801b4d:	e8 ac fb ff ff       	call   8016fe <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 25                	push   $0x25
  801b66:	e8 93 fb ff ff       	call   8016fe <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
  801b6e:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801b73:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	6a 26                	push   $0x26
  801b92:	e8 67 fb ff ff       	call   8016fe <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9a:	90                   	nop
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ba1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	53                   	push   %ebx
  801bb0:	51                   	push   %ecx
  801bb1:	52                   	push   %edx
  801bb2:	50                   	push   %eax
  801bb3:	6a 27                	push   $0x27
  801bb5:	e8 44 fb ff ff       	call   8016fe <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	52                   	push   %edx
  801bd2:	50                   	push   %eax
  801bd3:	6a 28                	push   $0x28
  801bd5:	e8 24 fb ff ff       	call   8016fe <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801be2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	51                   	push   %ecx
  801bee:	ff 75 10             	pushl  0x10(%ebp)
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 29                	push   $0x29
  801bf5:	e8 04 fb ff ff       	call   8016fe <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 10             	pushl  0x10(%ebp)
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 12                	push   $0x12
  801c11:	e8 e8 fa ff ff       	call   8016fe <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return ;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	52                   	push   %edx
  801c2c:	50                   	push   %eax
  801c2d:	6a 2a                	push   $0x2a
  801c2f:	e8 ca fa ff ff       	call   8016fe <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
	return;
  801c37:	90                   	nop
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 2b                	push   $0x2b
  801c49:	e8 b0 fa ff ff       	call   8016fe <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	ff 75 0c             	pushl  0xc(%ebp)
  801c5f:	ff 75 08             	pushl  0x8(%ebp)
  801c62:	6a 2d                	push   $0x2d
  801c64:	e8 95 fa ff ff       	call   8016fe <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
	return;
  801c6c:	90                   	nop
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	ff 75 08             	pushl  0x8(%ebp)
  801c7e:	6a 2c                	push   $0x2c
  801c80:	e8 79 fa ff ff       	call   8016fe <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
	return ;
  801c88:	90                   	nop
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c91:	83 ec 04             	sub    $0x4,%esp
  801c94:	68 a8 32 80 00       	push   $0x8032a8
  801c99:	68 25 01 00 00       	push   $0x125
  801c9e:	68 db 32 80 00       	push   $0x8032db
  801ca3:	e8 e3 0a 00 00       	call   80278b <_panic>

00801ca8 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801cae:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801cb5:	72 09                	jb     801cc0 <to_page_va+0x18>
  801cb7:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801cbe:	72 14                	jb     801cd4 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	68 ec 32 80 00       	push   $0x8032ec
  801cc8:	6a 15                	push   $0x15
  801cca:	68 17 33 80 00       	push   $0x803317
  801ccf:	e8 b7 0a 00 00       	call   80278b <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	ba 60 40 80 00       	mov    $0x804060,%edx
  801cdc:	29 d0                	sub    %edx,%eax
  801cde:	c1 f8 02             	sar    $0x2,%eax
  801ce1:	89 c2                	mov    %eax,%edx
  801ce3:	89 d0                	mov    %edx,%eax
  801ce5:	c1 e0 02             	shl    $0x2,%eax
  801ce8:	01 d0                	add    %edx,%eax
  801cea:	c1 e0 02             	shl    $0x2,%eax
  801ced:	01 d0                	add    %edx,%eax
  801cef:	c1 e0 02             	shl    $0x2,%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	89 c1                	mov    %eax,%ecx
  801cf6:	c1 e1 08             	shl    $0x8,%ecx
  801cf9:	01 c8                	add    %ecx,%eax
  801cfb:	89 c1                	mov    %eax,%ecx
  801cfd:	c1 e1 10             	shl    $0x10,%ecx
  801d00:	01 c8                	add    %ecx,%eax
  801d02:	01 c0                	add    %eax,%eax
  801d04:	01 d0                	add    %edx,%eax
  801d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0c:	c1 e0 0c             	shl    $0xc,%eax
  801d0f:	89 c2                	mov    %eax,%edx
  801d11:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d16:	01 d0                	add    %edx,%eax
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801d20:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d25:	8b 55 08             	mov    0x8(%ebp),%edx
  801d28:	29 c2                	sub    %eax,%edx
  801d2a:	89 d0                	mov    %edx,%eax
  801d2c:	c1 e8 0c             	shr    $0xc,%eax
  801d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d36:	78 09                	js     801d41 <to_page_info+0x27>
  801d38:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801d3f:	7e 14                	jle    801d55 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801d41:	83 ec 04             	sub    $0x4,%esp
  801d44:	68 30 33 80 00       	push   $0x803330
  801d49:	6a 22                	push   $0x22
  801d4b:	68 17 33 80 00       	push   $0x803317
  801d50:	e8 36 0a 00 00       	call   80278b <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d58:	89 d0                	mov    %edx,%eax
  801d5a:	01 c0                	add    %eax,%eax
  801d5c:	01 d0                	add    %edx,%eax
  801d5e:	c1 e0 02             	shl    $0x2,%eax
  801d61:	05 60 40 80 00       	add    $0x804060,%eax
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	05 00 00 00 02       	add    $0x2000000,%eax
  801d76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d79:	73 16                	jae    801d91 <initialize_dynamic_allocator+0x29>
  801d7b:	68 54 33 80 00       	push   $0x803354
  801d80:	68 7a 33 80 00       	push   $0x80337a
  801d85:	6a 34                	push   $0x34
  801d87:	68 17 33 80 00       	push   $0x803317
  801d8c:	e8 fa 09 00 00       	call   80278b <_panic>
		is_initialized = 1;
  801d91:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801d98:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da6:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801dab:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801db2:	00 00 00 
  801db5:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801dbc:	00 00 00 
  801dbf:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801dc6:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcc:	2b 45 08             	sub    0x8(%ebp),%eax
  801dcf:	c1 e8 0c             	shr    $0xc,%eax
  801dd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ddc:	e9 c8 00 00 00       	jmp    801ea9 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de4:	89 d0                	mov    %edx,%eax
  801de6:	01 c0                	add    %eax,%eax
  801de8:	01 d0                	add    %edx,%eax
  801dea:	c1 e0 02             	shl    $0x2,%eax
  801ded:	05 68 40 80 00       	add    $0x804068,%eax
  801df2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dfa:	89 d0                	mov    %edx,%eax
  801dfc:	01 c0                	add    %eax,%eax
  801dfe:	01 d0                	add    %edx,%eax
  801e00:	c1 e0 02             	shl    $0x2,%eax
  801e03:	05 6a 40 80 00       	add    $0x80406a,%eax
  801e08:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801e0d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e13:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e16:	89 c8                	mov    %ecx,%eax
  801e18:	01 c0                	add    %eax,%eax
  801e1a:	01 c8                	add    %ecx,%eax
  801e1c:	c1 e0 02             	shl    $0x2,%eax
  801e1f:	05 64 40 80 00       	add    $0x804064,%eax
  801e24:	89 10                	mov    %edx,(%eax)
  801e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e29:	89 d0                	mov    %edx,%eax
  801e2b:	01 c0                	add    %eax,%eax
  801e2d:	01 d0                	add    %edx,%eax
  801e2f:	c1 e0 02             	shl    $0x2,%eax
  801e32:	05 64 40 80 00       	add    $0x804064,%eax
  801e37:	8b 00                	mov    (%eax),%eax
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	74 1b                	je     801e58 <initialize_dynamic_allocator+0xf0>
  801e3d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e43:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e46:	89 c8                	mov    %ecx,%eax
  801e48:	01 c0                	add    %eax,%eax
  801e4a:	01 c8                	add    %ecx,%eax
  801e4c:	c1 e0 02             	shl    $0x2,%eax
  801e4f:	05 60 40 80 00       	add    $0x804060,%eax
  801e54:	89 02                	mov    %eax,(%edx)
  801e56:	eb 16                	jmp    801e6e <initialize_dynamic_allocator+0x106>
  801e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5b:	89 d0                	mov    %edx,%eax
  801e5d:	01 c0                	add    %eax,%eax
  801e5f:	01 d0                	add    %edx,%eax
  801e61:	c1 e0 02             	shl    $0x2,%eax
  801e64:	05 60 40 80 00       	add    $0x804060,%eax
  801e69:	a3 48 40 80 00       	mov    %eax,0x804048
  801e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e71:	89 d0                	mov    %edx,%eax
  801e73:	01 c0                	add    %eax,%eax
  801e75:	01 d0                	add    %edx,%eax
  801e77:	c1 e0 02             	shl    $0x2,%eax
  801e7a:	05 60 40 80 00       	add    $0x804060,%eax
  801e7f:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e87:	89 d0                	mov    %edx,%eax
  801e89:	01 c0                	add    %eax,%eax
  801e8b:	01 d0                	add    %edx,%eax
  801e8d:	c1 e0 02             	shl    $0x2,%eax
  801e90:	05 60 40 80 00       	add    $0x804060,%eax
  801e95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e9b:	a1 54 40 80 00       	mov    0x804054,%eax
  801ea0:	40                   	inc    %eax
  801ea1:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801ea6:	ff 45 f4             	incl   -0xc(%ebp)
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801eaf:	0f 8c 2c ff ff ff    	jl     801de1 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801eb5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ebc:	eb 36                	jmp    801ef4 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec1:	c1 e0 04             	shl    $0x4,%eax
  801ec4:	05 80 c0 81 00       	add    $0x81c080,%eax
  801ec9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed2:	c1 e0 04             	shl    $0x4,%eax
  801ed5:	05 84 c0 81 00       	add    $0x81c084,%eax
  801eda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee3:	c1 e0 04             	shl    $0x4,%eax
  801ee6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801eeb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801ef1:	ff 45 f0             	incl   -0x10(%ebp)
  801ef4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801ef8:	7e c4                	jle    801ebe <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801efa:	90                   	nop
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	50                   	push   %eax
  801f0a:	e8 0b fe ff ff       	call   801d1a <to_page_info>
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 40 08             	mov    0x8(%eax),%eax
  801f1b:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	e8 77 fd ff ff       	call   801ca8 <to_page_va>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801f37:	b8 00 10 00 00       	mov    $0x1000,%eax
  801f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f41:	f7 75 08             	divl   0x8(%ebp)
  801f44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	50                   	push   %eax
  801f4e:	e8 48 f6 ff ff       	call   80159b <get_page>
  801f53:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5c:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f66:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801f6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f71:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801f78:	eb 19                	jmp    801f93 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7d:	ba 01 00 00 00       	mov    $0x1,%edx
  801f82:	88 c1                	mov    %al,%cl
  801f84:	d3 e2                	shl    %cl,%edx
  801f86:	89 d0                	mov    %edx,%eax
  801f88:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f8b:	74 0e                	je     801f9b <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801f8d:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f90:	ff 45 f0             	incl   -0x10(%ebp)
  801f93:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801f97:	7e e1                	jle    801f7a <split_page_to_blocks+0x5a>
  801f99:	eb 01                	jmp    801f9c <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801f9b:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801f9c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801fa3:	e9 a7 00 00 00       	jmp    80204f <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fab:	0f af 45 08          	imul   0x8(%ebp),%eax
  801faf:	89 c2                	mov    %eax,%edx
  801fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb4:	01 d0                	add    %edx,%eax
  801fb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801fb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fbd:	75 14                	jne    801fd3 <split_page_to_blocks+0xb3>
  801fbf:	83 ec 04             	sub    $0x4,%esp
  801fc2:	68 90 33 80 00       	push   $0x803390
  801fc7:	6a 7c                	push   $0x7c
  801fc9:	68 17 33 80 00       	push   $0x803317
  801fce:	e8 b8 07 00 00       	call   80278b <_panic>
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	c1 e0 04             	shl    $0x4,%eax
  801fd9:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fde:	8b 10                	mov    (%eax),%edx
  801fe0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe3:	89 50 04             	mov    %edx,0x4(%eax)
  801fe6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe9:	8b 40 04             	mov    0x4(%eax),%eax
  801fec:	85 c0                	test   %eax,%eax
  801fee:	74 14                	je     802004 <split_page_to_blocks+0xe4>
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	c1 e0 04             	shl    $0x4,%eax
  801ff6:	05 84 c0 81 00       	add    $0x81c084,%eax
  801ffb:	8b 00                	mov    (%eax),%eax
  801ffd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802000:	89 10                	mov    %edx,(%eax)
  802002:	eb 11                	jmp    802015 <split_page_to_blocks+0xf5>
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	c1 e0 04             	shl    $0x4,%eax
  80200a:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802010:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802013:	89 02                	mov    %eax,(%edx)
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	c1 e0 04             	shl    $0x4,%eax
  80201b:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802021:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802024:	89 02                	mov    %eax,(%edx)
  802026:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802029:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	c1 e0 04             	shl    $0x4,%eax
  802035:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80203a:	8b 00                	mov    (%eax),%eax
  80203c:	8d 50 01             	lea    0x1(%eax),%edx
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	c1 e0 04             	shl    $0x4,%eax
  802045:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80204a:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80204c:	ff 45 ec             	incl   -0x14(%ebp)
  80204f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802052:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802055:	0f 82 4d ff ff ff    	jb     801fa8 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80205b:	90                   	nop
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802064:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80206b:	76 19                	jbe    802086 <alloc_block+0x28>
  80206d:	68 b4 33 80 00       	push   $0x8033b4
  802072:	68 7a 33 80 00       	push   $0x80337a
  802077:	68 8a 00 00 00       	push   $0x8a
  80207c:	68 17 33 80 00       	push   $0x803317
  802081:	e8 05 07 00 00       	call   80278b <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80208d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802094:	eb 19                	jmp    8020af <alloc_block+0x51>
		if((1 << i) >= size) break;
  802096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802099:	ba 01 00 00 00       	mov    $0x1,%edx
  80209e:	88 c1                	mov    %al,%cl
  8020a0:	d3 e2                	shl    %cl,%edx
  8020a2:	89 d0                	mov    %edx,%eax
  8020a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a7:	73 0e                	jae    8020b7 <alloc_block+0x59>
		idx++;
  8020a9:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8020ac:	ff 45 f0             	incl   -0x10(%ebp)
  8020af:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8020b3:	7e e1                	jle    802096 <alloc_block+0x38>
  8020b5:	eb 01                	jmp    8020b8 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8020b7:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	c1 e0 04             	shl    $0x4,%eax
  8020be:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020c3:	8b 00                	mov    (%eax),%eax
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	0f 84 df 00 00 00    	je     8021ac <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	c1 e0 04             	shl    $0x4,%eax
  8020d3:	05 80 c0 81 00       	add    $0x81c080,%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8020dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020e1:	75 17                	jne    8020fa <alloc_block+0x9c>
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	68 d5 33 80 00       	push   $0x8033d5
  8020eb:	68 9e 00 00 00       	push   $0x9e
  8020f0:	68 17 33 80 00       	push   $0x803317
  8020f5:	e8 91 06 00 00       	call   80278b <_panic>
  8020fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fd:	8b 00                	mov    (%eax),%eax
  8020ff:	85 c0                	test   %eax,%eax
  802101:	74 10                	je     802113 <alloc_block+0xb5>
  802103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80210b:	8b 52 04             	mov    0x4(%edx),%edx
  80210e:	89 50 04             	mov    %edx,0x4(%eax)
  802111:	eb 14                	jmp    802127 <alloc_block+0xc9>
  802113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802116:	8b 40 04             	mov    0x4(%eax),%eax
  802119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211c:	c1 e2 04             	shl    $0x4,%edx
  80211f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802125:	89 02                	mov    %eax,(%edx)
  802127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212a:	8b 40 04             	mov    0x4(%eax),%eax
  80212d:	85 c0                	test   %eax,%eax
  80212f:	74 0f                	je     802140 <alloc_block+0xe2>
  802131:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802134:	8b 40 04             	mov    0x4(%eax),%eax
  802137:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80213a:	8b 12                	mov    (%edx),%edx
  80213c:	89 10                	mov    %edx,(%eax)
  80213e:	eb 13                	jmp    802153 <alloc_block+0xf5>
  802140:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802143:	8b 00                	mov    (%eax),%eax
  802145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802148:	c1 e2 04             	shl    $0x4,%edx
  80214b:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802151:	89 02                	mov    %eax,(%edx)
  802153:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802156:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80215c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802169:	c1 e0 04             	shl    $0x4,%eax
  80216c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802171:	8b 00                	mov    (%eax),%eax
  802173:	8d 50 ff             	lea    -0x1(%eax),%edx
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	c1 e0 04             	shl    $0x4,%eax
  80217c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802181:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	50                   	push   %eax
  80218a:	e8 8b fb ff ff       	call   801d1a <to_page_info>
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802198:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80219c:	48                   	dec    %eax
  80219d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021a0:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8021a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a7:	e9 bc 02 00 00       	jmp    802468 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8021ac:	a1 54 40 80 00       	mov    0x804054,%eax
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	0f 84 7d 02 00 00    	je     802436 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8021b9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8021c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021c5:	75 17                	jne    8021de <alloc_block+0x180>
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	68 d5 33 80 00       	push   $0x8033d5
  8021cf:	68 a9 00 00 00       	push   $0xa9
  8021d4:	68 17 33 80 00       	push   $0x803317
  8021d9:	e8 ad 05 00 00       	call   80278b <_panic>
  8021de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 10                	je     8021f7 <alloc_block+0x199>
  8021e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021ef:	8b 52 04             	mov    0x4(%edx),%edx
  8021f2:	89 50 04             	mov    %edx,0x4(%eax)
  8021f5:	eb 0b                	jmp    802202 <alloc_block+0x1a4>
  8021f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021fa:	8b 40 04             	mov    0x4(%eax),%eax
  8021fd:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802205:	8b 40 04             	mov    0x4(%eax),%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	74 0f                	je     80221b <alloc_block+0x1bd>
  80220c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80220f:	8b 40 04             	mov    0x4(%eax),%eax
  802212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802215:	8b 12                	mov    (%edx),%edx
  802217:	89 10                	mov    %edx,(%eax)
  802219:	eb 0a                	jmp    802225 <alloc_block+0x1c7>
  80221b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221e:	8b 00                	mov    (%eax),%eax
  802220:	a3 48 40 80 00       	mov    %eax,0x804048
  802225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80222e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802231:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802238:	a1 54 40 80 00       	mov    0x804054,%eax
  80223d:	48                   	dec    %eax
  80223e:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	83 c0 03             	add    $0x3,%eax
  802249:	ba 01 00 00 00       	mov    $0x1,%edx
  80224e:	88 c1                	mov    %al,%cl
  802250:	d3 e2                	shl    %cl,%edx
  802252:	89 d0                	mov    %edx,%eax
  802254:	83 ec 08             	sub    $0x8,%esp
  802257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80225a:	50                   	push   %eax
  80225b:	e8 c0 fc ff ff       	call   801f20 <split_page_to_blocks>
  802260:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	c1 e0 04             	shl    $0x4,%eax
  802269:	05 80 c0 81 00       	add    $0x81c080,%eax
  80226e:	8b 00                	mov    (%eax),%eax
  802270:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802273:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802277:	75 17                	jne    802290 <alloc_block+0x232>
  802279:	83 ec 04             	sub    $0x4,%esp
  80227c:	68 d5 33 80 00       	push   $0x8033d5
  802281:	68 b0 00 00 00       	push   $0xb0
  802286:	68 17 33 80 00       	push   $0x803317
  80228b:	e8 fb 04 00 00       	call   80278b <_panic>
  802290:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802293:	8b 00                	mov    (%eax),%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	74 10                	je     8022a9 <alloc_block+0x24b>
  802299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80229c:	8b 00                	mov    (%eax),%eax
  80229e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022a1:	8b 52 04             	mov    0x4(%edx),%edx
  8022a4:	89 50 04             	mov    %edx,0x4(%eax)
  8022a7:	eb 14                	jmp    8022bd <alloc_block+0x25f>
  8022a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ac:	8b 40 04             	mov    0x4(%eax),%eax
  8022af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b2:	c1 e2 04             	shl    $0x4,%edx
  8022b5:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8022bb:	89 02                	mov    %eax,(%edx)
  8022bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c0:	8b 40 04             	mov    0x4(%eax),%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 0f                	je     8022d6 <alloc_block+0x278>
  8022c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ca:	8b 40 04             	mov    0x4(%eax),%eax
  8022cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022d0:	8b 12                	mov    (%edx),%edx
  8022d2:	89 10                	mov    %edx,(%eax)
  8022d4:	eb 13                	jmp    8022e9 <alloc_block+0x28b>
  8022d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022de:	c1 e2 04             	shl    $0x4,%edx
  8022e1:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8022e7:	89 02                	mov    %eax,(%edx)
  8022e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	c1 e0 04             	shl    $0x4,%eax
  802302:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	8d 50 ff             	lea    -0x1(%eax),%edx
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	c1 e0 04             	shl    $0x4,%eax
  802312:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802317:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802319:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	50                   	push   %eax
  802320:	e8 f5 f9 ff ff       	call   801d1a <to_page_info>
  802325:	83 c4 10             	add    $0x10,%esp
  802328:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80232b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80232e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802332:	48                   	dec    %eax
  802333:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802336:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80233a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80233d:	e9 26 01 00 00       	jmp    802468 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802342:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	c1 e0 04             	shl    $0x4,%eax
  80234b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802350:	8b 00                	mov    (%eax),%eax
  802352:	85 c0                	test   %eax,%eax
  802354:	0f 84 dc 00 00 00    	je     802436 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	c1 e0 04             	shl    $0x4,%eax
  802360:	05 80 c0 81 00       	add    $0x81c080,%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80236a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80236e:	75 17                	jne    802387 <alloc_block+0x329>
  802370:	83 ec 04             	sub    $0x4,%esp
  802373:	68 d5 33 80 00       	push   $0x8033d5
  802378:	68 be 00 00 00       	push   $0xbe
  80237d:	68 17 33 80 00       	push   $0x803317
  802382:	e8 04 04 00 00       	call   80278b <_panic>
  802387:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80238a:	8b 00                	mov    (%eax),%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	74 10                	je     8023a0 <alloc_block+0x342>
  802390:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802393:	8b 00                	mov    (%eax),%eax
  802395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802398:	8b 52 04             	mov    0x4(%edx),%edx
  80239b:	89 50 04             	mov    %edx,0x4(%eax)
  80239e:	eb 14                	jmp    8023b4 <alloc_block+0x356>
  8023a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a3:	8b 40 04             	mov    0x4(%eax),%eax
  8023a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a9:	c1 e2 04             	shl    $0x4,%edx
  8023ac:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023b2:	89 02                	mov    %eax,(%edx)
  8023b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023b7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	74 0f                	je     8023cd <alloc_block+0x36f>
  8023be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023c1:	8b 40 04             	mov    0x4(%eax),%eax
  8023c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023c7:	8b 12                	mov    (%edx),%edx
  8023c9:	89 10                	mov    %edx,(%eax)
  8023cb:	eb 13                	jmp    8023e0 <alloc_block+0x382>
  8023cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d0:	8b 00                	mov    (%eax),%eax
  8023d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d5:	c1 e2 04             	shl    $0x4,%edx
  8023d8:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023de:	89 02                	mov    %eax,(%edx)
  8023e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	c1 e0 04             	shl    $0x4,%eax
  8023f9:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	8d 50 ff             	lea    -0x1(%eax),%edx
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	c1 e0 04             	shl    $0x4,%eax
  802409:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80240e:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802410:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802413:	83 ec 0c             	sub    $0xc,%esp
  802416:	50                   	push   %eax
  802417:	e8 fe f8 ff ff       	call   801d1a <to_page_info>
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802422:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802425:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802429:	48                   	dec    %eax
  80242a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80242d:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802431:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802434:	eb 32                	jmp    802468 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802436:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80243a:	77 15                	ja     802451 <alloc_block+0x3f3>
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	c1 e0 04             	shl    $0x4,%eax
  802442:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	85 c0                	test   %eax,%eax
  80244b:	0f 84 f1 fe ff ff    	je     802342 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802451:	83 ec 04             	sub    $0x4,%esp
  802454:	68 f3 33 80 00       	push   $0x8033f3
  802459:	68 c8 00 00 00       	push   $0xc8
  80245e:	68 17 33 80 00       	push   $0x803317
  802463:	e8 23 03 00 00       	call   80278b <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802470:	8b 55 08             	mov    0x8(%ebp),%edx
  802473:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802478:	39 c2                	cmp    %eax,%edx
  80247a:	72 0c                	jb     802488 <free_block+0x1e>
  80247c:	8b 55 08             	mov    0x8(%ebp),%edx
  80247f:	a1 40 40 80 00       	mov    0x804040,%eax
  802484:	39 c2                	cmp    %eax,%edx
  802486:	72 19                	jb     8024a1 <free_block+0x37>
  802488:	68 04 34 80 00       	push   $0x803404
  80248d:	68 7a 33 80 00       	push   $0x80337a
  802492:	68 d7 00 00 00       	push   $0xd7
  802497:	68 17 33 80 00       	push   $0x803317
  80249c:	e8 ea 02 00 00       	call   80278b <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	83 ec 0c             	sub    $0xc,%esp
  8024ad:	50                   	push   %eax
  8024ae:	e8 67 f8 ff ff       	call   801d1a <to_page_info>
  8024b3:	83 c4 10             	add    $0x10,%esp
  8024b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8024b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024bc:	8b 40 08             	mov    0x8(%eax),%eax
  8024bf:	0f b7 c0             	movzwl %ax,%eax
  8024c2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8024c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8024cc:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8024d3:	eb 19                	jmp    8024ee <free_block+0x84>
	    if ((1 << i) == blk_size)
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	ba 01 00 00 00       	mov    $0x1,%edx
  8024dd:	88 c1                	mov    %al,%cl
  8024df:	d3 e2                	shl    %cl,%edx
  8024e1:	89 d0                	mov    %edx,%eax
  8024e3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8024e6:	74 0e                	je     8024f6 <free_block+0x8c>
	        break;
	    idx++;
  8024e8:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8024eb:	ff 45 f0             	incl   -0x10(%ebp)
  8024ee:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8024f2:	7e e1                	jle    8024d5 <free_block+0x6b>
  8024f4:	eb 01                	jmp    8024f7 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8024f6:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8024f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fa:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8024fe:	40                   	inc    %eax
  8024ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802502:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802506:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80250a:	75 17                	jne    802523 <free_block+0xb9>
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	68 90 33 80 00       	push   $0x803390
  802514:	68 ee 00 00 00       	push   $0xee
  802519:	68 17 33 80 00       	push   $0x803317
  80251e:	e8 68 02 00 00       	call   80278b <_panic>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	c1 e0 04             	shl    $0x4,%eax
  802529:	05 84 c0 81 00       	add    $0x81c084,%eax
  80252e:	8b 10                	mov    (%eax),%edx
  802530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802533:	89 50 04             	mov    %edx,0x4(%eax)
  802536:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	74 14                	je     802554 <free_block+0xea>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	c1 e0 04             	shl    $0x4,%eax
  802546:	05 84 c0 81 00       	add    $0x81c084,%eax
  80254b:	8b 00                	mov    (%eax),%eax
  80254d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802550:	89 10                	mov    %edx,(%eax)
  802552:	eb 11                	jmp    802565 <free_block+0xfb>
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	c1 e0 04             	shl    $0x4,%eax
  80255a:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802563:	89 02                	mov    %eax,(%edx)
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	c1 e0 04             	shl    $0x4,%eax
  80256b:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802571:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802574:	89 02                	mov    %eax,(%edx)
  802576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	c1 e0 04             	shl    $0x4,%eax
  802585:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	8d 50 01             	lea    0x1(%eax),%edx
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	c1 e0 04             	shl    $0x4,%eax
  802595:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80259a:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80259c:	b8 00 10 00 00       	mov    $0x1000,%eax
  8025a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a6:	f7 75 e0             	divl   -0x20(%ebp)
  8025a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8025ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025af:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025b3:	0f b7 c0             	movzwl %ax,%eax
  8025b6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8025b9:	0f 85 70 01 00 00    	jne    80272f <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8025bf:	83 ec 0c             	sub    $0xc,%esp
  8025c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025c5:	e8 de f6 ff ff       	call   801ca8 <to_page_va>
  8025ca:	83 c4 10             	add    $0x10,%esp
  8025cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8025d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025d7:	e9 b7 00 00 00       	jmp    802693 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8025dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e2:	01 d0                	add    %edx,%eax
  8025e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8025e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8025eb:	75 17                	jne    802604 <free_block+0x19a>
  8025ed:	83 ec 04             	sub    $0x4,%esp
  8025f0:	68 d5 33 80 00       	push   $0x8033d5
  8025f5:	68 f8 00 00 00       	push   $0xf8
  8025fa:	68 17 33 80 00       	push   $0x803317
  8025ff:	e8 87 01 00 00       	call   80278b <_panic>
  802604:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	74 10                	je     80261d <free_block+0x1b3>
  80260d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802615:	8b 52 04             	mov    0x4(%edx),%edx
  802618:	89 50 04             	mov    %edx,0x4(%eax)
  80261b:	eb 14                	jmp    802631 <free_block+0x1c7>
  80261d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802620:	8b 40 04             	mov    0x4(%eax),%eax
  802623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802626:	c1 e2 04             	shl    $0x4,%edx
  802629:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80262f:	89 02                	mov    %eax,(%edx)
  802631:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802634:	8b 40 04             	mov    0x4(%eax),%eax
  802637:	85 c0                	test   %eax,%eax
  802639:	74 0f                	je     80264a <free_block+0x1e0>
  80263b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80263e:	8b 40 04             	mov    0x4(%eax),%eax
  802641:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802644:	8b 12                	mov    (%edx),%edx
  802646:	89 10                	mov    %edx,(%eax)
  802648:	eb 13                	jmp    80265d <free_block+0x1f3>
  80264a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802652:	c1 e2 04             	shl    $0x4,%edx
  802655:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80265b:	89 02                	mov    %eax,(%edx)
  80265d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802666:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	c1 e0 04             	shl    $0x4,%eax
  802676:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80267b:	8b 00                	mov    (%eax),%eax
  80267d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	c1 e0 04             	shl    $0x4,%eax
  802686:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80268b:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80268d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802690:	01 45 ec             	add    %eax,-0x14(%ebp)
  802693:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80269a:	0f 86 3c ff ff ff    	jbe    8025dc <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8026a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a3:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8026a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ac:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8026b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026b6:	75 17                	jne    8026cf <free_block+0x265>
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	68 90 33 80 00       	push   $0x803390
  8026c0:	68 fe 00 00 00       	push   $0xfe
  8026c5:	68 17 33 80 00       	push   $0x803317
  8026ca:	e8 bc 00 00 00       	call   80278b <_panic>
  8026cf:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8026d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d8:	89 50 04             	mov    %edx,0x4(%eax)
  8026db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026de:	8b 40 04             	mov    0x4(%eax),%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 0c                	je     8026f1 <free_block+0x287>
  8026e5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ed:	89 10                	mov    %edx,(%eax)
  8026ef:	eb 08                	jmp    8026f9 <free_block+0x28f>
  8026f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f4:	a3 48 40 80 00       	mov    %eax,0x804048
  8026f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fc:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270a:	a1 54 40 80 00       	mov    0x804054,%eax
  80270f:	40                   	inc    %eax
  802710:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802715:	83 ec 0c             	sub    $0xc,%esp
  802718:	ff 75 e4             	pushl  -0x1c(%ebp)
  80271b:	e8 88 f5 ff ff       	call   801ca8 <to_page_va>
  802720:	83 c4 10             	add    $0x10,%esp
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	50                   	push   %eax
  802727:	e8 b8 ee ff ff       	call   8015e4 <return_page>
  80272c:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80272f:	90                   	nop
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	68 3c 34 80 00       	push   $0x80343c
  802740:	68 11 01 00 00       	push   $0x111
  802745:	68 17 33 80 00       	push   $0x803317
  80274a:	e8 3c 00 00 00       	call   80278b <_panic>

0080274f <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
  802752:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80275b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80275f:	83 ec 0c             	sub    $0xc,%esp
  802762:	50                   	push   %eax
  802763:	e8 4d f1 ff ff       	call   8018b5 <sys_cputc>
  802768:	83 c4 10             	add    $0x10,%esp
}
  80276b:	90                   	nop
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <getchar>:


int
getchar(void)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  802774:	e8 db ef ff ff       	call   801754 <sys_cgetc>
  802779:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <iscons>:

int iscons(int fdnum)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  802784:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802789:	5d                   	pop    %ebp
  80278a:	c3                   	ret    

0080278b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802791:	8d 45 10             	lea    0x10(%ebp),%eax
  802794:	83 c0 04             	add    $0x4,%eax
  802797:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80279a:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 16                	je     8027b9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8027a3:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  8027a8:	83 ec 08             	sub    $0x8,%esp
  8027ab:	50                   	push   %eax
  8027ac:	68 60 34 80 00       	push   $0x803460
  8027b1:	e8 a4 dc ff ff       	call   80045a <cprintf>
  8027b6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8027b9:	a1 04 40 80 00       	mov    0x804004,%eax
  8027be:	83 ec 0c             	sub    $0xc,%esp
  8027c1:	ff 75 0c             	pushl  0xc(%ebp)
  8027c4:	ff 75 08             	pushl  0x8(%ebp)
  8027c7:	50                   	push   %eax
  8027c8:	68 68 34 80 00       	push   $0x803468
  8027cd:	6a 74                	push   $0x74
  8027cf:	e8 b3 dc ff ff       	call   800487 <cprintf_colored>
  8027d4:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8027d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8027da:	83 ec 08             	sub    $0x8,%esp
  8027dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e0:	50                   	push   %eax
  8027e1:	e8 05 dc ff ff       	call   8003eb <vcprintf>
  8027e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8027e9:	83 ec 08             	sub    $0x8,%esp
  8027ec:	6a 00                	push   $0x0
  8027ee:	68 90 34 80 00       	push   $0x803490
  8027f3:	e8 f3 db ff ff       	call   8003eb <vcprintf>
  8027f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8027fb:	e8 6c db ff ff       	call   80036c <exit>

	// should not return here
	while (1) ;
  802800:	eb fe                	jmp    802800 <_panic+0x75>

00802802 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802802:	55                   	push   %ebp
  802803:	89 e5                	mov    %esp,%ebp
  802805:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802808:	a1 20 40 80 00       	mov    0x804020,%eax
  80280d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802813:	8b 45 0c             	mov    0xc(%ebp),%eax
  802816:	39 c2                	cmp    %eax,%edx
  802818:	74 14                	je     80282e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80281a:	83 ec 04             	sub    $0x4,%esp
  80281d:	68 94 34 80 00       	push   $0x803494
  802822:	6a 26                	push   $0x26
  802824:	68 e0 34 80 00       	push   $0x8034e0
  802829:	e8 5d ff ff ff       	call   80278b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80282e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802835:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80283c:	e9 c5 00 00 00       	jmp    802906 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802844:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	01 d0                	add    %edx,%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	75 08                	jne    80285e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802856:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802859:	e9 a5 00 00 00       	jmp    802903 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80285e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802865:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80286c:	eb 69                	jmp    8028d7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80286e:	a1 20 40 80 00       	mov    0x804020,%eax
  802873:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802879:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80287c:	89 d0                	mov    %edx,%eax
  80287e:	01 c0                	add    %eax,%eax
  802880:	01 d0                	add    %edx,%eax
  802882:	c1 e0 03             	shl    $0x3,%eax
  802885:	01 c8                	add    %ecx,%eax
  802887:	8a 40 04             	mov    0x4(%eax),%al
  80288a:	84 c0                	test   %al,%al
  80288c:	75 46                	jne    8028d4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80288e:	a1 20 40 80 00       	mov    0x804020,%eax
  802893:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  802899:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80289c:	89 d0                	mov    %edx,%eax
  80289e:	01 c0                	add    %eax,%eax
  8028a0:	01 d0                	add    %edx,%eax
  8028a2:	c1 e0 03             	shl    $0x3,%eax
  8028a5:	01 c8                	add    %ecx,%eax
  8028a7:	8b 00                	mov    (%eax),%eax
  8028a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8028b4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8028c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c3:	01 c8                	add    %ecx,%eax
  8028c5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8028c7:	39 c2                	cmp    %eax,%edx
  8028c9:	75 09                	jne    8028d4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8028cb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8028d2:	eb 15                	jmp    8028e9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8028d4:	ff 45 e8             	incl   -0x18(%ebp)
  8028d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8028dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8028e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e5:	39 c2                	cmp    %eax,%edx
  8028e7:	77 85                	ja     80286e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8028e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028ed:	75 14                	jne    802903 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	68 ec 34 80 00       	push   $0x8034ec
  8028f7:	6a 3a                	push   $0x3a
  8028f9:	68 e0 34 80 00       	push   $0x8034e0
  8028fe:	e8 88 fe ff ff       	call   80278b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802903:	ff 45 f0             	incl   -0x10(%ebp)
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80290c:	0f 8c 2f ff ff ff    	jl     802841 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802912:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802919:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802920:	eb 26                	jmp    802948 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802922:	a1 20 40 80 00       	mov    0x804020,%eax
  802927:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80292d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802930:	89 d0                	mov    %edx,%eax
  802932:	01 c0                	add    %eax,%eax
  802934:	01 d0                	add    %edx,%eax
  802936:	c1 e0 03             	shl    $0x3,%eax
  802939:	01 c8                	add    %ecx,%eax
  80293b:	8a 40 04             	mov    0x4(%eax),%al
  80293e:	3c 01                	cmp    $0x1,%al
  802940:	75 03                	jne    802945 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802942:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802945:	ff 45 e0             	incl   -0x20(%ebp)
  802948:	a1 20 40 80 00       	mov    0x804020,%eax
  80294d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802953:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802956:	39 c2                	cmp    %eax,%edx
  802958:	77 c8                	ja     802922 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802960:	74 14                	je     802976 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 40 35 80 00       	push   $0x803540
  80296a:	6a 44                	push   $0x44
  80296c:	68 e0 34 80 00       	push   $0x8034e0
  802971:	e8 15 fe ff ff       	call   80278b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802976:	90                   	nop
  802977:	c9                   	leave  
  802978:	c3                   	ret    
  802979:	66 90                	xchg   %ax,%ax
  80297b:	90                   	nop

0080297c <__udivdi3>:
  80297c:	55                   	push   %ebp
  80297d:	57                   	push   %edi
  80297e:	56                   	push   %esi
  80297f:	53                   	push   %ebx
  802980:	83 ec 1c             	sub    $0x1c,%esp
  802983:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802987:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80298b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80298f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802993:	89 ca                	mov    %ecx,%edx
  802995:	89 f8                	mov    %edi,%eax
  802997:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80299b:	85 f6                	test   %esi,%esi
  80299d:	75 2d                	jne    8029cc <__udivdi3+0x50>
  80299f:	39 cf                	cmp    %ecx,%edi
  8029a1:	77 65                	ja     802a08 <__udivdi3+0x8c>
  8029a3:	89 fd                	mov    %edi,%ebp
  8029a5:	85 ff                	test   %edi,%edi
  8029a7:	75 0b                	jne    8029b4 <__udivdi3+0x38>
  8029a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ae:	31 d2                	xor    %edx,%edx
  8029b0:	f7 f7                	div    %edi
  8029b2:	89 c5                	mov    %eax,%ebp
  8029b4:	31 d2                	xor    %edx,%edx
  8029b6:	89 c8                	mov    %ecx,%eax
  8029b8:	f7 f5                	div    %ebp
  8029ba:	89 c1                	mov    %eax,%ecx
  8029bc:	89 d8                	mov    %ebx,%eax
  8029be:	f7 f5                	div    %ebp
  8029c0:	89 cf                	mov    %ecx,%edi
  8029c2:	89 fa                	mov    %edi,%edx
  8029c4:	83 c4 1c             	add    $0x1c,%esp
  8029c7:	5b                   	pop    %ebx
  8029c8:	5e                   	pop    %esi
  8029c9:	5f                   	pop    %edi
  8029ca:	5d                   	pop    %ebp
  8029cb:	c3                   	ret    
  8029cc:	39 ce                	cmp    %ecx,%esi
  8029ce:	77 28                	ja     8029f8 <__udivdi3+0x7c>
  8029d0:	0f bd fe             	bsr    %esi,%edi
  8029d3:	83 f7 1f             	xor    $0x1f,%edi
  8029d6:	75 40                	jne    802a18 <__udivdi3+0x9c>
  8029d8:	39 ce                	cmp    %ecx,%esi
  8029da:	72 0a                	jb     8029e6 <__udivdi3+0x6a>
  8029dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029e0:	0f 87 9e 00 00 00    	ja     802a84 <__udivdi3+0x108>
  8029e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029eb:	89 fa                	mov    %edi,%edx
  8029ed:	83 c4 1c             	add    $0x1c,%esp
  8029f0:	5b                   	pop    %ebx
  8029f1:	5e                   	pop    %esi
  8029f2:	5f                   	pop    %edi
  8029f3:	5d                   	pop    %ebp
  8029f4:	c3                   	ret    
  8029f5:	8d 76 00             	lea    0x0(%esi),%esi
  8029f8:	31 ff                	xor    %edi,%edi
  8029fa:	31 c0                	xor    %eax,%eax
  8029fc:	89 fa                	mov    %edi,%edx
  8029fe:	83 c4 1c             	add    $0x1c,%esp
  802a01:	5b                   	pop    %ebx
  802a02:	5e                   	pop    %esi
  802a03:	5f                   	pop    %edi
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
  802a06:	66 90                	xchg   %ax,%ax
  802a08:	89 d8                	mov    %ebx,%eax
  802a0a:	f7 f7                	div    %edi
  802a0c:	31 ff                	xor    %edi,%edi
  802a0e:	89 fa                	mov    %edi,%edx
  802a10:	83 c4 1c             	add    $0x1c,%esp
  802a13:	5b                   	pop    %ebx
  802a14:	5e                   	pop    %esi
  802a15:	5f                   	pop    %edi
  802a16:	5d                   	pop    %ebp
  802a17:	c3                   	ret    
  802a18:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a1d:	89 eb                	mov    %ebp,%ebx
  802a1f:	29 fb                	sub    %edi,%ebx
  802a21:	89 f9                	mov    %edi,%ecx
  802a23:	d3 e6                	shl    %cl,%esi
  802a25:	89 c5                	mov    %eax,%ebp
  802a27:	88 d9                	mov    %bl,%cl
  802a29:	d3 ed                	shr    %cl,%ebp
  802a2b:	89 e9                	mov    %ebp,%ecx
  802a2d:	09 f1                	or     %esi,%ecx
  802a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a33:	89 f9                	mov    %edi,%ecx
  802a35:	d3 e0                	shl    %cl,%eax
  802a37:	89 c5                	mov    %eax,%ebp
  802a39:	89 d6                	mov    %edx,%esi
  802a3b:	88 d9                	mov    %bl,%cl
  802a3d:	d3 ee                	shr    %cl,%esi
  802a3f:	89 f9                	mov    %edi,%ecx
  802a41:	d3 e2                	shl    %cl,%edx
  802a43:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a47:	88 d9                	mov    %bl,%cl
  802a49:	d3 e8                	shr    %cl,%eax
  802a4b:	09 c2                	or     %eax,%edx
  802a4d:	89 d0                	mov    %edx,%eax
  802a4f:	89 f2                	mov    %esi,%edx
  802a51:	f7 74 24 0c          	divl   0xc(%esp)
  802a55:	89 d6                	mov    %edx,%esi
  802a57:	89 c3                	mov    %eax,%ebx
  802a59:	f7 e5                	mul    %ebp
  802a5b:	39 d6                	cmp    %edx,%esi
  802a5d:	72 19                	jb     802a78 <__udivdi3+0xfc>
  802a5f:	74 0b                	je     802a6c <__udivdi3+0xf0>
  802a61:	89 d8                	mov    %ebx,%eax
  802a63:	31 ff                	xor    %edi,%edi
  802a65:	e9 58 ff ff ff       	jmp    8029c2 <__udivdi3+0x46>
  802a6a:	66 90                	xchg   %ax,%ax
  802a6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a70:	89 f9                	mov    %edi,%ecx
  802a72:	d3 e2                	shl    %cl,%edx
  802a74:	39 c2                	cmp    %eax,%edx
  802a76:	73 e9                	jae    802a61 <__udivdi3+0xe5>
  802a78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a7b:	31 ff                	xor    %edi,%edi
  802a7d:	e9 40 ff ff ff       	jmp    8029c2 <__udivdi3+0x46>
  802a82:	66 90                	xchg   %ax,%ax
  802a84:	31 c0                	xor    %eax,%eax
  802a86:	e9 37 ff ff ff       	jmp    8029c2 <__udivdi3+0x46>
  802a8b:	90                   	nop

00802a8c <__umoddi3>:
  802a8c:	55                   	push   %ebp
  802a8d:	57                   	push   %edi
  802a8e:	56                   	push   %esi
  802a8f:	53                   	push   %ebx
  802a90:	83 ec 1c             	sub    $0x1c,%esp
  802a93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a97:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802aa7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802aab:	89 f3                	mov    %esi,%ebx
  802aad:	89 fa                	mov    %edi,%edx
  802aaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ab3:	89 34 24             	mov    %esi,(%esp)
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	75 1a                	jne    802ad4 <__umoddi3+0x48>
  802aba:	39 f7                	cmp    %esi,%edi
  802abc:	0f 86 a2 00 00 00    	jbe    802b64 <__umoddi3+0xd8>
  802ac2:	89 c8                	mov    %ecx,%eax
  802ac4:	89 f2                	mov    %esi,%edx
  802ac6:	f7 f7                	div    %edi
  802ac8:	89 d0                	mov    %edx,%eax
  802aca:	31 d2                	xor    %edx,%edx
  802acc:	83 c4 1c             	add    $0x1c,%esp
  802acf:	5b                   	pop    %ebx
  802ad0:	5e                   	pop    %esi
  802ad1:	5f                   	pop    %edi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    
  802ad4:	39 f0                	cmp    %esi,%eax
  802ad6:	0f 87 ac 00 00 00    	ja     802b88 <__umoddi3+0xfc>
  802adc:	0f bd e8             	bsr    %eax,%ebp
  802adf:	83 f5 1f             	xor    $0x1f,%ebp
  802ae2:	0f 84 ac 00 00 00    	je     802b94 <__umoddi3+0x108>
  802ae8:	bf 20 00 00 00       	mov    $0x20,%edi
  802aed:	29 ef                	sub    %ebp,%edi
  802aef:	89 fe                	mov    %edi,%esi
  802af1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802af5:	89 e9                	mov    %ebp,%ecx
  802af7:	d3 e0                	shl    %cl,%eax
  802af9:	89 d7                	mov    %edx,%edi
  802afb:	89 f1                	mov    %esi,%ecx
  802afd:	d3 ef                	shr    %cl,%edi
  802aff:	09 c7                	or     %eax,%edi
  802b01:	89 e9                	mov    %ebp,%ecx
  802b03:	d3 e2                	shl    %cl,%edx
  802b05:	89 14 24             	mov    %edx,(%esp)
  802b08:	89 d8                	mov    %ebx,%eax
  802b0a:	d3 e0                	shl    %cl,%eax
  802b0c:	89 c2                	mov    %eax,%edx
  802b0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b12:	d3 e0                	shl    %cl,%eax
  802b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b18:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b1c:	89 f1                	mov    %esi,%ecx
  802b1e:	d3 e8                	shr    %cl,%eax
  802b20:	09 d0                	or     %edx,%eax
  802b22:	d3 eb                	shr    %cl,%ebx
  802b24:	89 da                	mov    %ebx,%edx
  802b26:	f7 f7                	div    %edi
  802b28:	89 d3                	mov    %edx,%ebx
  802b2a:	f7 24 24             	mull   (%esp)
  802b2d:	89 c6                	mov    %eax,%esi
  802b2f:	89 d1                	mov    %edx,%ecx
  802b31:	39 d3                	cmp    %edx,%ebx
  802b33:	0f 82 87 00 00 00    	jb     802bc0 <__umoddi3+0x134>
  802b39:	0f 84 91 00 00 00    	je     802bd0 <__umoddi3+0x144>
  802b3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b43:	29 f2                	sub    %esi,%edx
  802b45:	19 cb                	sbb    %ecx,%ebx
  802b47:	89 d8                	mov    %ebx,%eax
  802b49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b4d:	d3 e0                	shl    %cl,%eax
  802b4f:	89 e9                	mov    %ebp,%ecx
  802b51:	d3 ea                	shr    %cl,%edx
  802b53:	09 d0                	or     %edx,%eax
  802b55:	89 e9                	mov    %ebp,%ecx
  802b57:	d3 eb                	shr    %cl,%ebx
  802b59:	89 da                	mov    %ebx,%edx
  802b5b:	83 c4 1c             	add    $0x1c,%esp
  802b5e:	5b                   	pop    %ebx
  802b5f:	5e                   	pop    %esi
  802b60:	5f                   	pop    %edi
  802b61:	5d                   	pop    %ebp
  802b62:	c3                   	ret    
  802b63:	90                   	nop
  802b64:	89 fd                	mov    %edi,%ebp
  802b66:	85 ff                	test   %edi,%edi
  802b68:	75 0b                	jne    802b75 <__umoddi3+0xe9>
  802b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b6f:	31 d2                	xor    %edx,%edx
  802b71:	f7 f7                	div    %edi
  802b73:	89 c5                	mov    %eax,%ebp
  802b75:	89 f0                	mov    %esi,%eax
  802b77:	31 d2                	xor    %edx,%edx
  802b79:	f7 f5                	div    %ebp
  802b7b:	89 c8                	mov    %ecx,%eax
  802b7d:	f7 f5                	div    %ebp
  802b7f:	89 d0                	mov    %edx,%eax
  802b81:	e9 44 ff ff ff       	jmp    802aca <__umoddi3+0x3e>
  802b86:	66 90                	xchg   %ax,%ax
  802b88:	89 c8                	mov    %ecx,%eax
  802b8a:	89 f2                	mov    %esi,%edx
  802b8c:	83 c4 1c             	add    $0x1c,%esp
  802b8f:	5b                   	pop    %ebx
  802b90:	5e                   	pop    %esi
  802b91:	5f                   	pop    %edi
  802b92:	5d                   	pop    %ebp
  802b93:	c3                   	ret    
  802b94:	3b 04 24             	cmp    (%esp),%eax
  802b97:	72 06                	jb     802b9f <__umoddi3+0x113>
  802b99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b9d:	77 0f                	ja     802bae <__umoddi3+0x122>
  802b9f:	89 f2                	mov    %esi,%edx
  802ba1:	29 f9                	sub    %edi,%ecx
  802ba3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802ba7:	89 14 24             	mov    %edx,(%esp)
  802baa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bae:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bb2:	8b 14 24             	mov    (%esp),%edx
  802bb5:	83 c4 1c             	add    $0x1c,%esp
  802bb8:	5b                   	pop    %ebx
  802bb9:	5e                   	pop    %esi
  802bba:	5f                   	pop    %edi
  802bbb:	5d                   	pop    %ebp
  802bbc:	c3                   	ret    
  802bbd:	8d 76 00             	lea    0x0(%esi),%esi
  802bc0:	2b 04 24             	sub    (%esp),%eax
  802bc3:	19 fa                	sbb    %edi,%edx
  802bc5:	89 d1                	mov    %edx,%ecx
  802bc7:	89 c6                	mov    %eax,%esi
  802bc9:	e9 71 ff ff ff       	jmp    802b3f <__umoddi3+0xb3>
  802bce:	66 90                	xchg   %ax,%ax
  802bd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802bd4:	72 ea                	jb     802bc0 <__umoddi3+0x134>
  802bd6:	89 d9                	mov    %ebx,%ecx
  802bd8:	e9 62 ff ff ff       	jmp    802b3f <__umoddi3+0xb3>
