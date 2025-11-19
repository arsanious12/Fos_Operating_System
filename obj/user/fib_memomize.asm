
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
  800057:	e8 c1 0b 00 00       	call   800c1d <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 c3 10 00 00       	call   801135 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 87 15 00 00       	call   80160f <malloc>
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
  8000db:	e8 5d 15 00 00       	call   80163d <free>
  8000e0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ec:	68 fe 2b 80 00       	push   $0x802bfe
  8000f1:	e8 c1 03 00 00       	call   8004b7 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 11 1a 00 00       	call   801b0f <inctst>
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
  8001be:	e8 0e 18 00 00       	call   8019d1 <sys_getenvindex>
  8001c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001c9:	89 d0                	mov    %edx,%eax
  8001cb:	c1 e0 02             	shl    $0x2,%eax
  8001ce:	01 d0                	add    %edx,%eax
  8001d0:	c1 e0 03             	shl    $0x3,%eax
  8001d3:	01 d0                	add    %edx,%eax
  8001d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001dc:	01 d0                	add    %edx,%eax
  8001de:	c1 e0 02             	shl    $0x2,%eax
  8001e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e6:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f0:	8a 40 20             	mov    0x20(%eax),%al
  8001f3:	84 c0                	test   %al,%al
  8001f5:	74 0d                	je     800204 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fc:	83 c0 20             	add    $0x20,%eax
  8001ff:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800208:	7e 0a                	jle    800214 <libmain+0x5f>
		binaryname = argv[0];
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	8b 00                	mov    (%eax),%eax
  80020f:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	ff 75 0c             	pushl  0xc(%ebp)
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	e8 16 fe ff ff       	call   800038 <_main>
  800222:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800225:	a1 00 40 80 00       	mov    0x804000,%eax
  80022a:	85 c0                	test   %eax,%eax
  80022c:	0f 84 01 01 00 00    	je     800333 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800232:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800238:	bb 0c 2d 80 00       	mov    $0x802d0c,%ebx
  80023d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800242:	89 c7                	mov    %eax,%edi
  800244:	89 de                	mov    %ebx,%esi
  800246:	89 d1                	mov    %edx,%ecx
  800248:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80024a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80024d:	b9 56 00 00 00       	mov    $0x56,%ecx
  800252:	b0 00                	mov    $0x0,%al
  800254:	89 d7                	mov    %edx,%edi
  800256:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800258:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80025f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	50                   	push   %eax
  800266:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	e8 95 19 00 00       	call   801c07 <sys_utilities>
  800272:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800275:	e8 de 14 00 00       	call   801758 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80027a:	83 ec 0c             	sub    $0xc,%esp
  80027d:	68 2c 2c 80 00       	push   $0x802c2c
  800282:	e8 be 01 00 00       	call   800445 <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80028a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028d:	85 c0                	test   %eax,%eax
  80028f:	74 18                	je     8002a9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800291:	e8 8f 19 00 00       	call   801c25 <sys_get_optimal_num_faults>
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	50                   	push   %eax
  80029a:	68 54 2c 80 00       	push   $0x802c54
  80029f:	e8 a1 01 00 00       	call   800445 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	eb 59                	jmp    800302 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ae:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8002b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b9:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	52                   	push   %edx
  8002c3:	50                   	push   %eax
  8002c4:	68 78 2c 80 00       	push   $0x802c78
  8002c9:	e8 77 01 00 00       	call   800445 <cprintf>
  8002ce:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d6:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e1:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002f2:	51                   	push   %ecx
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 a0 2c 80 00       	push   $0x802ca0
  8002fa:	e8 46 01 00 00       	call   800445 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800302:	a1 20 40 80 00       	mov    0x804020,%eax
  800307:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	50                   	push   %eax
  800311:	68 f8 2c 80 00       	push   $0x802cf8
  800316:	e8 2a 01 00 00       	call   800445 <cprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	68 2c 2c 80 00       	push   $0x802c2c
  800326:	e8 1a 01 00 00       	call   800445 <cprintf>
  80032b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80032e:	e8 3f 14 00 00       	call   801772 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800333:	e8 1f 00 00 00       	call   800357 <exit>
}
  800338:	90                   	nop
  800339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033c:	5b                   	pop    %ebx
  80033d:	5e                   	pop    %esi
  80033e:	5f                   	pop    %edi
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    

00800341 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	6a 00                	push   $0x0
  80034c:	e8 4c 16 00 00       	call   80199d <sys_destroy_env>
  800351:	83 c4 10             	add    $0x10,%esp
}
  800354:	90                   	nop
  800355:	c9                   	leave  
  800356:	c3                   	ret    

00800357 <exit>:

void
exit(void)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80035d:	e8 a1 16 00 00       	call   801a03 <sys_exit_env>
}
  800362:	90                   	nop
  800363:	c9                   	leave  
  800364:	c3                   	ret    

00800365 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
  800368:	53                   	push   %ebx
  800369:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80036c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	8d 48 01             	lea    0x1(%eax),%ecx
  800374:	8b 55 0c             	mov    0xc(%ebp),%edx
  800377:	89 0a                	mov    %ecx,(%edx)
  800379:	8b 55 08             	mov    0x8(%ebp),%edx
  80037c:	88 d1                	mov    %dl,%cl
  80037e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800381:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800385:	8b 45 0c             	mov    0xc(%ebp),%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038f:	75 30                	jne    8003c1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800391:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800397:	a0 44 40 80 00       	mov    0x804044,%al
  80039c:	0f b6 c0             	movzbl %al,%eax
  80039f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a2:	8b 09                	mov    (%ecx),%ecx
  8003a4:	89 cb                	mov    %ecx,%ebx
  8003a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a9:	83 c1 08             	add    $0x8,%ecx
  8003ac:	52                   	push   %edx
  8003ad:	50                   	push   %eax
  8003ae:	53                   	push   %ebx
  8003af:	51                   	push   %ecx
  8003b0:	e8 5f 13 00 00       	call   801714 <sys_cputs>
  8003b5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 40 04             	mov    0x4(%eax),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003d0:	90                   	nop
  8003d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d4:	c9                   	leave  
  8003d5:	c3                   	ret    

008003d6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e6:	00 00 00 
	b.cnt = 0;
  8003e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003f3:	ff 75 0c             	pushl  0xc(%ebp)
  8003f6:	ff 75 08             	pushl  0x8(%ebp)
  8003f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ff:	50                   	push   %eax
  800400:	68 65 03 80 00       	push   $0x800365
  800405:	e8 5a 02 00 00       	call   800664 <vprintfmt>
  80040a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80040d:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800413:	a0 44 40 80 00       	mov    0x804044,%al
  800418:	0f b6 c0             	movzbl %al,%eax
  80041b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800421:	52                   	push   %edx
  800422:	50                   	push   %eax
  800423:	51                   	push   %ecx
  800424:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042a:	83 c0 08             	add    $0x8,%eax
  80042d:	50                   	push   %eax
  80042e:	e8 e1 12 00 00       	call   801714 <sys_cputs>
  800433:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800436:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80043d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80044b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800452:	8d 45 0c             	lea    0xc(%ebp),%eax
  800455:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	ff 75 f4             	pushl  -0xc(%ebp)
  800461:	50                   	push   %eax
  800462:	e8 6f ff ff ff       	call   8003d6 <vcprintf>
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80046d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800470:	c9                   	leave  
  800471:	c3                   	ret    

00800472 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800478:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	c1 e0 08             	shl    $0x8,%eax
  800485:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  80048a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048d:	83 c0 04             	add    $0x4,%eax
  800490:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	ff 75 f4             	pushl  -0xc(%ebp)
  80049c:	50                   	push   %eax
  80049d:	e8 34 ff ff ff       	call   8003d6 <vcprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
  8004a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8004a8:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  8004af:	07 00 00 

	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004bd:	e8 96 12 00 00       	call   801758 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d1:	50                   	push   %eax
  8004d2:	e8 ff fe ff ff       	call   8003d6 <vcprintf>
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004dd:	e8 90 12 00 00       	call   801772 <sys_unlock_cons>
	return cnt;
  8004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	53                   	push   %ebx
  8004eb:	83 ec 14             	sub    $0x14,%esp
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8004fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800502:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800505:	77 55                	ja     80055c <printnum+0x75>
  800507:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80050a:	72 05                	jb     800511 <printnum+0x2a>
  80050c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80050f:	77 4b                	ja     80055c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800511:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800514:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800517:	8b 45 18             	mov    0x18(%ebp),%eax
  80051a:	ba 00 00 00 00       	mov    $0x0,%edx
  80051f:	52                   	push   %edx
  800520:	50                   	push   %eax
  800521:	ff 75 f4             	pushl  -0xc(%ebp)
  800524:	ff 75 f0             	pushl  -0x10(%ebp)
  800527:	e8 38 24 00 00       	call   802964 <__udivdi3>
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	ff 75 20             	pushl  0x20(%ebp)
  800535:	53                   	push   %ebx
  800536:	ff 75 18             	pushl  0x18(%ebp)
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	ff 75 0c             	pushl  0xc(%ebp)
  80053e:	ff 75 08             	pushl  0x8(%ebp)
  800541:	e8 a1 ff ff ff       	call   8004e7 <printnum>
  800546:	83 c4 20             	add    $0x20,%esp
  800549:	eb 1a                	jmp    800565 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 0c             	pushl  0xc(%ebp)
  800551:	ff 75 20             	pushl  0x20(%ebp)
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	ff d0                	call   *%eax
  800559:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80055c:	ff 4d 1c             	decl   0x1c(%ebp)
  80055f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800563:	7f e6                	jg     80054b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800565:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800568:	bb 00 00 00 00       	mov    $0x0,%ebx
  80056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800573:	53                   	push   %ebx
  800574:	51                   	push   %ecx
  800575:	52                   	push   %edx
  800576:	50                   	push   %eax
  800577:	e8 f8 24 00 00       	call   802a74 <__umoddi3>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	05 94 2f 80 00       	add    $0x802f94,%eax
  800584:	8a 00                	mov    (%eax),%al
  800586:	0f be c0             	movsbl %al,%eax
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	50                   	push   %eax
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	ff d0                	call   *%eax
  800595:	83 c4 10             	add    $0x10,%esp
}
  800598:	90                   	nop
  800599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a5:	7e 1c                	jle    8005c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	8d 50 08             	lea    0x8(%eax),%edx
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	89 10                	mov    %edx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	83 e8 08             	sub    $0x8,%eax
  8005bc:	8b 50 04             	mov    0x4(%eax),%edx
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	eb 40                	jmp    800603 <getuint+0x65>
	else if (lflag)
  8005c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c7:	74 1e                	je     8005e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	8d 50 04             	lea    0x4(%eax),%edx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	89 10                	mov    %edx,(%eax)
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	83 e8 04             	sub    $0x4,%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e5:	eb 1c                	jmp    800603 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	8d 50 04             	lea    0x4(%eax),%edx
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	89 10                	mov    %edx,(%eax)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	83 e8 04             	sub    $0x4,%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800603:	5d                   	pop    %ebp
  800604:	c3                   	ret    

00800605 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800605:	55                   	push   %ebp
  800606:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800608:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80060c:	7e 1c                	jle    80062a <getint+0x25>
		return va_arg(*ap, long long);
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	8d 50 08             	lea    0x8(%eax),%edx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	89 10                	mov    %edx,(%eax)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	83 e8 08             	sub    $0x8,%eax
  800623:	8b 50 04             	mov    0x4(%eax),%edx
  800626:	8b 00                	mov    (%eax),%eax
  800628:	eb 38                	jmp    800662 <getint+0x5d>
	else if (lflag)
  80062a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80062e:	74 1a                	je     80064a <getint+0x45>
		return va_arg(*ap, long);
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	8d 50 04             	lea    0x4(%eax),%edx
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	89 10                	mov    %edx,(%eax)
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	83 e8 04             	sub    $0x4,%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	99                   	cltd   
  800648:	eb 18                	jmp    800662 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	8d 50 04             	lea    0x4(%eax),%edx
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	89 10                	mov    %edx,(%eax)
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	83 e8 04             	sub    $0x4,%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	99                   	cltd   
}
  800662:	5d                   	pop    %ebp
  800663:	c3                   	ret    

00800664 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	56                   	push   %esi
  800668:	53                   	push   %ebx
  800669:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066c:	eb 17                	jmp    800685 <vprintfmt+0x21>
			if (ch == '\0')
  80066e:	85 db                	test   %ebx,%ebx
  800670:	0f 84 c1 03 00 00    	je     800a37 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	53                   	push   %ebx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	ff d0                	call   *%eax
  800682:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800685:	8b 45 10             	mov    0x10(%ebp),%eax
  800688:	8d 50 01             	lea    0x1(%eax),%edx
  80068b:	89 55 10             	mov    %edx,0x10(%ebp)
  80068e:	8a 00                	mov    (%eax),%al
  800690:	0f b6 d8             	movzbl %al,%ebx
  800693:	83 fb 25             	cmp    $0x25,%ebx
  800696:	75 d6                	jne    80066e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800698:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80069c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bb:	8d 50 01             	lea    0x1(%eax),%edx
  8006be:	89 55 10             	mov    %edx,0x10(%ebp)
  8006c1:	8a 00                	mov    (%eax),%al
  8006c3:	0f b6 d8             	movzbl %al,%ebx
  8006c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006c9:	83 f8 5b             	cmp    $0x5b,%eax
  8006cc:	0f 87 3d 03 00 00    	ja     800a0f <vprintfmt+0x3ab>
  8006d2:	8b 04 85 b8 2f 80 00 	mov    0x802fb8(,%eax,4),%eax
  8006d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006df:	eb d7                	jmp    8006b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006e5:	eb d1                	jmp    8006b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f1:	89 d0                	mov    %edx,%eax
  8006f3:	c1 e0 02             	shl    $0x2,%eax
  8006f6:	01 d0                	add    %edx,%eax
  8006f8:	01 c0                	add    %eax,%eax
  8006fa:	01 d8                	add    %ebx,%eax
  8006fc:	83 e8 30             	sub    $0x30,%eax
  8006ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800702:	8b 45 10             	mov    0x10(%ebp),%eax
  800705:	8a 00                	mov    (%eax),%al
  800707:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80070a:	83 fb 2f             	cmp    $0x2f,%ebx
  80070d:	7e 3e                	jle    80074d <vprintfmt+0xe9>
  80070f:	83 fb 39             	cmp    $0x39,%ebx
  800712:	7f 39                	jg     80074d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800714:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800717:	eb d5                	jmp    8006ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	83 c0 04             	add    $0x4,%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	83 e8 04             	sub    $0x4,%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80072d:	eb 1f                	jmp    80074e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800733:	79 83                	jns    8006b8 <vprintfmt+0x54>
				width = 0;
  800735:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80073c:	e9 77 ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800741:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800748:	e9 6b ff ff ff       	jmp    8006b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80074d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80074e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800752:	0f 89 60 ff ff ff    	jns    8006b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80075e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800765:	e9 4e ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80076a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80076d:	e9 46 ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	83 c0 04             	add    $0x4,%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	83 e8 04             	sub    $0x4,%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	50                   	push   %eax
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	ff d0                	call   *%eax
  80078f:	83 c4 10             	add    $0x10,%esp
			break;
  800792:	e9 9b 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	83 e8 04             	sub    $0x4,%eax
  8007a6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007a8:	85 db                	test   %ebx,%ebx
  8007aa:	79 02                	jns    8007ae <vprintfmt+0x14a>
				err = -err;
  8007ac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007ae:	83 fb 64             	cmp    $0x64,%ebx
  8007b1:	7f 0b                	jg     8007be <vprintfmt+0x15a>
  8007b3:	8b 34 9d 00 2e 80 00 	mov    0x802e00(,%ebx,4),%esi
  8007ba:	85 f6                	test   %esi,%esi
  8007bc:	75 19                	jne    8007d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007be:	53                   	push   %ebx
  8007bf:	68 a5 2f 80 00       	push   $0x802fa5
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 70 02 00 00       	call   800a3f <printfmt>
  8007cf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007d2:	e9 5b 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007d7:	56                   	push   %esi
  8007d8:	68 ae 2f 80 00       	push   $0x802fae
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	ff 75 08             	pushl  0x8(%ebp)
  8007e3:	e8 57 02 00 00       	call   800a3f <printfmt>
  8007e8:	83 c4 10             	add    $0x10,%esp
			break;
  8007eb:	e9 42 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	83 c0 04             	add    $0x4,%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 30                	mov    (%eax),%esi
  800801:	85 f6                	test   %esi,%esi
  800803:	75 05                	jne    80080a <vprintfmt+0x1a6>
				p = "(null)";
  800805:	be b1 2f 80 00       	mov    $0x802fb1,%esi
			if (width > 0 && padc != '-')
  80080a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080e:	7e 6d                	jle    80087d <vprintfmt+0x219>
  800810:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800814:	74 67                	je     80087d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	50                   	push   %eax
  80081d:	56                   	push   %esi
  80081e:	e8 26 05 00 00       	call   800d49 <strnlen>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800829:	eb 16                	jmp    800841 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80082b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80083e:	ff 4d e4             	decl   -0x1c(%ebp)
  800841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800845:	7f e4                	jg     80082b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800847:	eb 34                	jmp    80087d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800849:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80084d:	74 1c                	je     80086b <vprintfmt+0x207>
  80084f:	83 fb 1f             	cmp    $0x1f,%ebx
  800852:	7e 05                	jle    800859 <vprintfmt+0x1f5>
  800854:	83 fb 7e             	cmp    $0x7e,%ebx
  800857:	7e 12                	jle    80086b <vprintfmt+0x207>
					putch('?', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	6a 3f                	push   $0x3f
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	eb 0f                	jmp    80087a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	53                   	push   %ebx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087a:	ff 4d e4             	decl   -0x1c(%ebp)
  80087d:	89 f0                	mov    %esi,%eax
  80087f:	8d 70 01             	lea    0x1(%eax),%esi
  800882:	8a 00                	mov    (%eax),%al
  800884:	0f be d8             	movsbl %al,%ebx
  800887:	85 db                	test   %ebx,%ebx
  800889:	74 24                	je     8008af <vprintfmt+0x24b>
  80088b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80088f:	78 b8                	js     800849 <vprintfmt+0x1e5>
  800891:	ff 4d e0             	decl   -0x20(%ebp)
  800894:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800898:	79 af                	jns    800849 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089a:	eb 13                	jmp    8008af <vprintfmt+0x24b>
				putch(' ', putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	6a 20                	push   $0x20
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	ff d0                	call   *%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8008af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b3:	7f e7                	jg     80089c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008b5:	e9 78 01 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c3:	50                   	push   %eax
  8008c4:	e8 3c fd ff ff       	call   800605 <getint>
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d8:	85 d2                	test   %edx,%edx
  8008da:	79 23                	jns    8008ff <vprintfmt+0x29b>
				putch('-', putdat);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	6a 2d                	push   $0x2d
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f2:	f7 d8                	neg    %eax
  8008f4:	83 d2 00             	adc    $0x0,%edx
  8008f7:	f7 da                	neg    %edx
  8008f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800906:	e9 bc 00 00 00       	jmp    8009c7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 e8             	pushl  -0x18(%ebp)
  800911:	8d 45 14             	lea    0x14(%ebp),%eax
  800914:	50                   	push   %eax
  800915:	e8 84 fc ff ff       	call   80059e <getuint>
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800920:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800923:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80092a:	e9 98 00 00 00       	jmp    8009c7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	6a 58                	push   $0x58
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	ff d0                	call   *%eax
  80093c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	6a 58                	push   $0x58
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	6a 58                	push   $0x58
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	ff d0                	call   *%eax
  80095c:	83 c4 10             	add    $0x10,%esp
			break;
  80095f:	e9 ce 00 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	6a 30                	push   $0x30
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	ff d0                	call   *%eax
  800971:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	6a 78                	push   $0x78
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	ff d0                	call   *%eax
  800981:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800995:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80099f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009a6:	eb 1f                	jmp    8009c7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b1:	50                   	push   %eax
  8009b2:	e8 e7 fb ff ff       	call   80059e <getuint>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ce:	83 ec 04             	sub    $0x4,%esp
  8009d1:	52                   	push   %edx
  8009d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009d5:	50                   	push   %eax
  8009d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 00 fb ff ff       	call   8004e7 <printnum>
  8009e7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ea:	eb 46                	jmp    800a32 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			break;
  8009fb:	eb 35                	jmp    800a32 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009fd:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800a04:	eb 2c                	jmp    800a32 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a06:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800a0d:	eb 23                	jmp    800a32 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 25                	push   $0x25
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a1f:	ff 4d 10             	decl   0x10(%ebp)
  800a22:	eb 03                	jmp    800a27 <vprintfmt+0x3c3>
  800a24:	ff 4d 10             	decl   0x10(%ebp)
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	48                   	dec    %eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	3c 25                	cmp    $0x25,%al
  800a2f:	75 f3                	jne    800a24 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a31:	90                   	nop
		}
	}
  800a32:	e9 35 fc ff ff       	jmp    80066c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a3b:	5b                   	pop    %ebx
  800a3c:	5e                   	pop    %esi
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a45:	8d 45 10             	lea    0x10(%ebp),%eax
  800a48:	83 c0 04             	add    $0x4,%eax
  800a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	ff 75 08             	pushl  0x8(%ebp)
  800a5b:	e8 04 fc ff ff       	call   800664 <vprintfmt>
  800a60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a63:	90                   	nop
  800a64:	c9                   	leave  
  800a65:	c3                   	ret    

00800a66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8b 40 08             	mov    0x8(%eax),%eax
  800a6f:	8d 50 01             	lea    0x1(%eax),%edx
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	8b 10                	mov    (%eax),%edx
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	8b 40 04             	mov    0x4(%eax),%eax
  800a83:	39 c2                	cmp    %eax,%edx
  800a85:	73 12                	jae    800a99 <sprintputch+0x33>
		*b->buf++ = ch;
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a92:	89 0a                	mov    %ecx,(%edx)
  800a94:	8b 55 08             	mov    0x8(%ebp),%edx
  800a97:	88 10                	mov    %dl,(%eax)
}
  800a99:	90                   	nop
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	01 d0                	add    %edx,%eax
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ac1:	74 06                	je     800ac9 <vsnprintf+0x2d>
  800ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac7:	7f 07                	jg     800ad0 <vsnprintf+0x34>
		return -E_INVAL;
  800ac9:	b8 03 00 00 00       	mov    $0x3,%eax
  800ace:	eb 20                	jmp    800af0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ad0:	ff 75 14             	pushl  0x14(%ebp)
  800ad3:	ff 75 10             	pushl  0x10(%ebp)
  800ad6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ad9:	50                   	push   %eax
  800ada:	68 66 0a 80 00       	push   $0x800a66
  800adf:	e8 80 fb ff ff       	call   800664 <vprintfmt>
  800ae4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800af8:	8d 45 10             	lea    0x10(%ebp),%eax
  800afb:	83 c0 04             	add    $0x4,%eax
  800afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b01:	8b 45 10             	mov    0x10(%ebp),%eax
  800b04:	ff 75 f4             	pushl  -0xc(%ebp)
  800b07:	50                   	push   %eax
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	ff 75 08             	pushl  0x8(%ebp)
  800b0e:	e8 89 ff ff ff       	call   800a9c <vsnprintf>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800b24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b28:	74 13                	je     800b3d <readline+0x1f>
		cprintf("%s", prompt);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	68 28 31 80 00       	push   $0x803128
  800b35:	e8 0b f9 ff ff       	call   800445 <cprintf>
  800b3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	6a 00                	push   $0x0
  800b49:	e8 1e 1c 00 00       	call   80276c <iscons>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b54:	e8 00 1c 00 00       	call   802759 <getchar>
  800b59:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b60:	79 22                	jns    800b84 <readline+0x66>
			if (c != -E_EOF)
  800b62:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b66:	0f 84 ad 00 00 00    	je     800c19 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b72:	68 2b 31 80 00       	push   $0x80312b
  800b77:	e8 c9 f8 ff ff       	call   800445 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp
			break;
  800b7f:	e9 95 00 00 00       	jmp    800c19 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b84:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b88:	7e 34                	jle    800bbe <readline+0xa0>
  800b8a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b91:	7f 2b                	jg     800bbe <readline+0xa0>
			if (echoing)
  800b93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b97:	74 0e                	je     800ba7 <readline+0x89>
				cputchar(c);
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	ff 75 ec             	pushl  -0x14(%ebp)
  800b9f:	e8 96 1b 00 00       	call   80273a <cputchar>
  800ba4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800baa:	8d 50 01             	lea    0x1(%eax),%edx
  800bad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bb0:	89 c2                	mov    %eax,%edx
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	01 d0                	add    %edx,%eax
  800bb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bba:	88 10                	mov    %dl,(%eax)
  800bbc:	eb 56                	jmp    800c14 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800bbe:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bc2:	75 1f                	jne    800be3 <readline+0xc5>
  800bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bc8:	7e 19                	jle    800be3 <readline+0xc5>
			if (echoing)
  800bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bce:	74 0e                	je     800bde <readline+0xc0>
				cputchar(c);
  800bd0:	83 ec 0c             	sub    $0xc,%esp
  800bd3:	ff 75 ec             	pushl  -0x14(%ebp)
  800bd6:	e8 5f 1b 00 00       	call   80273a <cputchar>
  800bdb:	83 c4 10             	add    $0x10,%esp

			i--;
  800bde:	ff 4d f4             	decl   -0xc(%ebp)
  800be1:	eb 31                	jmp    800c14 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800be3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800be7:	74 0a                	je     800bf3 <readline+0xd5>
  800be9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800bed:	0f 85 61 ff ff ff    	jne    800b54 <readline+0x36>
			if (echoing)
  800bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bf7:	74 0e                	je     800c07 <readline+0xe9>
				cputchar(c);
  800bf9:	83 ec 0c             	sub    $0xc,%esp
  800bfc:	ff 75 ec             	pushl  -0x14(%ebp)
  800bff:	e8 36 1b 00 00       	call   80273a <cputchar>
  800c04:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800c12:	eb 06                	jmp    800c1a <readline+0xfc>
		}
	}
  800c14:	e9 3b ff ff ff       	jmp    800b54 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800c19:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800c1a:	90                   	nop
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800c23:	e8 30 0b 00 00       	call   801758 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c2c:	74 13                	je     800c41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 08             	pushl  0x8(%ebp)
  800c34:	68 28 31 80 00       	push   $0x803128
  800c39:	e8 07 f8 ff ff       	call   800445 <cprintf>
  800c3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	6a 00                	push   $0x0
  800c4d:	e8 1a 1b 00 00       	call   80276c <iscons>
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800c58:	e8 fc 1a 00 00       	call   802759 <getchar>
  800c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800c60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c64:	79 22                	jns    800c88 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800c66:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c6a:	0f 84 ad 00 00 00    	je     800d1d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 ec             	pushl  -0x14(%ebp)
  800c76:	68 2b 31 80 00       	push   $0x80312b
  800c7b:	e8 c5 f7 ff ff       	call   800445 <cprintf>
  800c80:	83 c4 10             	add    $0x10,%esp
				break;
  800c83:	e9 95 00 00 00       	jmp    800d1d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800c88:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800c8c:	7e 34                	jle    800cc2 <atomic_readline+0xa5>
  800c8e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800c95:	7f 2b                	jg     800cc2 <atomic_readline+0xa5>
				if (echoing)
  800c97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c9b:	74 0e                	je     800cab <atomic_readline+0x8e>
					cputchar(c);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ca3:	e8 92 1a 00 00       	call   80273a <cputchar>
  800ca8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	01 d0                	add    %edx,%eax
  800cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800cbe:	88 10                	mov    %dl,(%eax)
  800cc0:	eb 56                	jmp    800d18 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800cc2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800cc6:	75 1f                	jne    800ce7 <atomic_readline+0xca>
  800cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ccc:	7e 19                	jle    800ce7 <atomic_readline+0xca>
				if (echoing)
  800cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cd2:	74 0e                	je     800ce2 <atomic_readline+0xc5>
					cputchar(c);
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  800cda:	e8 5b 1a 00 00       	call   80273a <cputchar>
  800cdf:	83 c4 10             	add    $0x10,%esp
				i--;
  800ce2:	ff 4d f4             	decl   -0xc(%ebp)
  800ce5:	eb 31                	jmp    800d18 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800ce7:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ceb:	74 0a                	je     800cf7 <atomic_readline+0xda>
  800ced:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800cf1:	0f 85 61 ff ff ff    	jne    800c58 <atomic_readline+0x3b>
				if (echoing)
  800cf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cfb:	74 0e                	je     800d0b <atomic_readline+0xee>
					cputchar(c);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	ff 75 ec             	pushl  -0x14(%ebp)
  800d03:	e8 32 1a 00 00       	call   80273a <cputchar>
  800d08:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	01 d0                	add    %edx,%eax
  800d13:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800d16:	eb 06                	jmp    800d1e <atomic_readline+0x101>
			}
		}
  800d18:	e9 3b ff ff ff       	jmp    800c58 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800d1d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800d1e:	e8 4f 0a 00 00       	call   801772 <sys_unlock_cons>
}
  800d23:	90                   	nop
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d33:	eb 06                	jmp    800d3b <strlen+0x15>
		n++;
  800d35:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	84 c0                	test   %al,%al
  800d42:	75 f1                	jne    800d35 <strlen+0xf>
		n++;
	return n;
  800d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 09                	jmp    800d61 <strnlen+0x18>
		n++;
  800d58:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	ff 45 08             	incl   0x8(%ebp)
  800d5e:	ff 4d 0c             	decl   0xc(%ebp)
  800d61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d65:	74 09                	je     800d70 <strnlen+0x27>
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e8                	jne    800d58 <strnlen+0xf>
		n++;
	return n;
  800d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d81:	90                   	nop
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d94:	8a 12                	mov    (%edx),%dl
  800d96:	88 10                	mov    %dl,(%eax)
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 e4                	jne    800d82 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800daf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db6:	eb 1f                	jmp    800dd7 <strncpy+0x34>
		*dst++ = *src;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8d 50 01             	lea    0x1(%eax),%edx
  800dbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc4:	8a 12                	mov    (%edx),%dl
  800dc6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	84 c0                	test   %al,%al
  800dcf:	74 03                	je     800dd4 <strncpy+0x31>
			src++;
  800dd1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd4:	ff 45 fc             	incl   -0x4(%ebp)
  800dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dda:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ddd:	72 d9                	jb     800db8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 30                	je     800e26 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800df6:	eb 16                	jmp    800e0e <strlcpy+0x2a>
			*dst++ = *src++;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e0e:	ff 4d 10             	decl   0x10(%ebp)
  800e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e15:	74 09                	je     800e20 <strlcpy+0x3c>
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	84 c0                	test   %al,%al
  800e1e:	75 d8                	jne    800df8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e35:	eb 06                	jmp    800e3d <strcmp+0xb>
		p++, q++;
  800e37:	ff 45 08             	incl   0x8(%ebp)
  800e3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	74 0e                	je     800e54 <strcmp+0x22>
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 10                	mov    (%eax),%dl
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	38 c2                	cmp    %al,%dl
  800e52:	74 e3                	je     800e37 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f b6 d0             	movzbl %al,%edx
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 c0             	movzbl %al,%eax
  800e64:	29 c2                	sub    %eax,%edx
  800e66:	89 d0                	mov    %edx,%eax
}
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e6d:	eb 09                	jmp    800e78 <strncmp+0xe>
		n--, p++, q++;
  800e6f:	ff 4d 10             	decl   0x10(%ebp)
  800e72:	ff 45 08             	incl   0x8(%ebp)
  800e75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7c:	74 17                	je     800e95 <strncmp+0x2b>
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	84 c0                	test   %al,%al
  800e85:	74 0e                	je     800e95 <strncmp+0x2b>
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 10                	mov    (%eax),%dl
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	38 c2                	cmp    %al,%dl
  800e93:	74 da                	je     800e6f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e99:	75 07                	jne    800ea2 <strncmp+0x38>
		return 0;
  800e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea0:	eb 14                	jmp    800eb6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	0f b6 d0             	movzbl %al,%edx
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	0f b6 c0             	movzbl %al,%eax
  800eb2:	29 c2                	sub    %eax,%edx
  800eb4:	89 d0                	mov    %edx,%eax
}
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 04             	sub    $0x4,%esp
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec4:	eb 12                	jmp    800ed8 <strchr+0x20>
		if (*s == c)
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ece:	75 05                	jne    800ed5 <strchr+0x1d>
			return (char *) s;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	eb 11                	jmp    800ee6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed5:	ff 45 08             	incl   0x8(%ebp)
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	84 c0                	test   %al,%al
  800edf:	75 e5                	jne    800ec6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 04             	sub    $0x4,%esp
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef4:	eb 0d                	jmp    800f03 <strfind+0x1b>
		if (*s == c)
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800efe:	74 0e                	je     800f0e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f00:	ff 45 08             	incl   0x8(%ebp)
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	84 c0                	test   %al,%al
  800f0a:	75 ea                	jne    800ef6 <strfind+0xe>
  800f0c:	eb 01                	jmp    800f0f <strfind+0x27>
		if (*s == c)
			break;
  800f0e:	90                   	nop
	return (char *) s;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f20:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f24:	76 63                	jbe    800f89 <memset+0x75>
		uint64 data_block = c;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	99                   	cltd   
  800f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f36:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f3a:	c1 e0 08             	shl    $0x8,%eax
  800f3d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f40:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f49:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f4d:	c1 e0 10             	shl    $0x10,%eax
  800f50:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f53:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f63:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f66:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f69:	eb 18                	jmp    800f83 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f6e:	8d 41 08             	lea    0x8(%ecx),%eax
  800f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7a:	89 01                	mov    %eax,(%ecx)
  800f7c:	89 51 04             	mov    %edx,0x4(%ecx)
  800f7f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f83:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f87:	77 e2                	ja     800f6b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8d:	74 23                	je     800fb2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f92:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f95:	eb 0e                	jmp    800fa5 <memset+0x91>
			*p8++ = (uint8)c;
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fab:	89 55 10             	mov    %edx,0x10(%ebp)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	75 e5                	jne    800f97 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fc9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fcd:	76 24                	jbe    800ff3 <memcpy+0x3c>
		while(n >= 8){
  800fcf:	eb 1c                	jmp    800fed <memcpy+0x36>
			*d64 = *s64;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8b 50 04             	mov    0x4(%eax),%edx
  800fd7:	8b 00                	mov    (%eax),%eax
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	89 01                	mov    %eax,(%ecx)
  800fde:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fe1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fe5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fe9:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800fed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff1:	77 de                	ja     800fd1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ff3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff7:	74 31                	je     80102a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ff9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801005:	eb 16                	jmp    80101d <memcpy+0x66>
			*d8++ = *s8++;
  801007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100a:	8d 50 01             	lea    0x1(%eax),%edx
  80100d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801013:	8d 4a 01             	lea    0x1(%edx),%ecx
  801016:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801019:	8a 12                	mov    (%edx),%dl
  80101b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	8d 50 ff             	lea    -0x1(%eax),%edx
  801023:	89 55 10             	mov    %edx,0x10(%ebp)
  801026:	85 c0                	test   %eax,%eax
  801028:	75 dd                	jne    801007 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102d:	c9                   	leave  
  80102e:	c3                   	ret    

0080102f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801047:	73 50                	jae    801099 <memmove+0x6a>
  801049:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104c:	8b 45 10             	mov    0x10(%ebp),%eax
  80104f:	01 d0                	add    %edx,%eax
  801051:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801054:	76 43                	jbe    801099 <memmove+0x6a>
		s += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801062:	eb 10                	jmp    801074 <memmove+0x45>
			*--d = *--s;
  801064:	ff 4d f8             	decl   -0x8(%ebp)
  801067:	ff 4d fc             	decl   -0x4(%ebp)
  80106a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106d:	8a 10                	mov    (%eax),%dl
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107a:	89 55 10             	mov    %edx,0x10(%ebp)
  80107d:	85 c0                	test   %eax,%eax
  80107f:	75 e3                	jne    801064 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801081:	eb 23                	jmp    8010a6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	8d 50 01             	lea    0x1(%eax),%edx
  801089:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801092:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801095:	8a 12                	mov    (%edx),%dl
  801097:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109f:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	75 dd                	jne    801083 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010bd:	eb 2a                	jmp    8010e9 <memcmp+0x3e>
		if (*s1 != *s2)
  8010bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c2:	8a 10                	mov    (%eax),%dl
  8010c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	38 c2                	cmp    %al,%dl
  8010cb:	74 16                	je     8010e3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	0f b6 d0             	movzbl %al,%edx
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 c0             	movzbl %al,%eax
  8010dd:	29 c2                	sub    %eax,%edx
  8010df:	89 d0                	mov    %edx,%eax
  8010e1:	eb 18                	jmp    8010fb <memcmp+0x50>
		s1++, s2++;
  8010e3:	ff 45 fc             	incl   -0x4(%ebp)
  8010e6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	75 c9                	jne    8010bf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	8b 45 10             	mov    0x10(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80110e:	eb 15                	jmp    801125 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	0f b6 d0             	movzbl %al,%edx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	0f b6 c0             	movzbl %al,%eax
  80111e:	39 c2                	cmp    %eax,%edx
  801120:	74 0d                	je     80112f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801122:	ff 45 08             	incl   0x8(%ebp)
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80112b:	72 e3                	jb     801110 <memfind+0x13>
  80112d:	eb 01                	jmp    801130 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80112f:	90                   	nop
	return (void *) s;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80113b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801142:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801149:	eb 03                	jmp    80114e <strtol+0x19>
		s++;
  80114b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	3c 20                	cmp    $0x20,%al
  801155:	74 f4                	je     80114b <strtol+0x16>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 09                	cmp    $0x9,%al
  80115e:	74 eb                	je     80114b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 2b                	cmp    $0x2b,%al
  801167:	75 05                	jne    80116e <strtol+0x39>
		s++;
  801169:	ff 45 08             	incl   0x8(%ebp)
  80116c:	eb 13                	jmp    801181 <strtol+0x4c>
	else if (*s == '-')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 2d                	cmp    $0x2d,%al
  801175:	75 0a                	jne    801181 <strtol+0x4c>
		s++, neg = 1;
  801177:	ff 45 08             	incl   0x8(%ebp)
  80117a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801185:	74 06                	je     80118d <strtol+0x58>
  801187:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80118b:	75 20                	jne    8011ad <strtol+0x78>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 30                	cmp    $0x30,%al
  801194:	75 17                	jne    8011ad <strtol+0x78>
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	40                   	inc    %eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 78                	cmp    $0x78,%al
  80119e:	75 0d                	jne    8011ad <strtol+0x78>
		s += 2, base = 16;
  8011a0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011a4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011ab:	eb 28                	jmp    8011d5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b1:	75 15                	jne    8011c8 <strtol+0x93>
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 30                	cmp    $0x30,%al
  8011ba:	75 0c                	jne    8011c8 <strtol+0x93>
		s++, base = 8;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c6:	eb 0d                	jmp    8011d5 <strtol+0xa0>
	else if (base == 0)
  8011c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cc:	75 07                	jne    8011d5 <strtol+0xa0>
		base = 10;
  8011ce:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3c 2f                	cmp    $0x2f,%al
  8011dc:	7e 19                	jle    8011f7 <strtol+0xc2>
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	3c 39                	cmp    $0x39,%al
  8011e5:	7f 10                	jg     8011f7 <strtol+0xc2>
			dig = *s - '0';
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	0f be c0             	movsbl %al,%eax
  8011ef:	83 e8 30             	sub    $0x30,%eax
  8011f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011f5:	eb 42                	jmp    801239 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 60                	cmp    $0x60,%al
  8011fe:	7e 19                	jle    801219 <strtol+0xe4>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 7a                	cmp    $0x7a,%al
  801207:	7f 10                	jg     801219 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	0f be c0             	movsbl %al,%eax
  801211:	83 e8 57             	sub    $0x57,%eax
  801214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801217:	eb 20                	jmp    801239 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 40                	cmp    $0x40,%al
  801220:	7e 39                	jle    80125b <strtol+0x126>
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3c 5a                	cmp    $0x5a,%al
  801229:	7f 30                	jg     80125b <strtol+0x126>
			dig = *s - 'A' + 10;
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	0f be c0             	movsbl %al,%eax
  801233:	83 e8 37             	sub    $0x37,%eax
  801236:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80123f:	7d 19                	jge    80125a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801241:	ff 45 08             	incl   0x8(%ebp)
  801244:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801247:	0f af 45 10          	imul   0x10(%ebp),%eax
  80124b:	89 c2                	mov    %eax,%edx
  80124d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801250:	01 d0                	add    %edx,%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801255:	e9 7b ff ff ff       	jmp    8011d5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80125a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80125b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80125f:	74 08                	je     801269 <strtol+0x134>
		*endptr = (char *) s;
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	8b 55 08             	mov    0x8(%ebp),%edx
  801267:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801269:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126d:	74 07                	je     801276 <strtol+0x141>
  80126f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801272:	f7 d8                	neg    %eax
  801274:	eb 03                	jmp    801279 <strtol+0x144>
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <ltostr>:

void
ltostr(long value, char *str)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801288:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80128f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801293:	79 13                	jns    8012a8 <ltostr+0x2d>
	{
		neg = 1;
  801295:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012a2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012a5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b0:	99                   	cltd   
  8012b1:	f7 f9                	idiv   %ecx
  8012b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	8d 50 01             	lea    0x1(%eax),%edx
  8012bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	01 d0                	add    %edx,%eax
  8012c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c9:	83 c2 30             	add    $0x30,%edx
  8012cc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d6:	f7 e9                	imul   %ecx
  8012d8:	c1 fa 02             	sar    $0x2,%edx
  8012db:	89 c8                	mov    %ecx,%eax
  8012dd:	c1 f8 1f             	sar    $0x1f,%eax
  8012e0:	29 c2                	sub    %eax,%edx
  8012e2:	89 d0                	mov    %edx,%eax
  8012e4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012eb:	75 bb                	jne    8012a8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ff:	74 3d                	je     80133e <ltostr+0xc3>
		start = 1 ;
  801301:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801308:	eb 34                	jmp    80133e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80130a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	01 c2                	add    %eax,%edx
  80131f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	01 c8                	add    %ecx,%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80132b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	01 c2                	add    %eax,%edx
  801333:	8a 45 eb             	mov    -0x15(%ebp),%al
  801336:	88 02                	mov    %al,(%edx)
		start++ ;
  801338:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80133b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80133e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801344:	7c c4                	jl     80130a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801346:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801351:	90                   	nop
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 c4 f9 ff ff       	call   800d26 <strlen>
  801362:	83 c4 04             	add    $0x4,%esp
  801365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	e8 b6 f9 ff ff       	call   800d26 <strlen>
  801370:	83 c4 04             	add    $0x4,%esp
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801384:	eb 17                	jmp    80139d <strcconcat+0x49>
		final[s] = str1[s] ;
  801386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	01 c2                	add    %eax,%edx
  80138e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	01 c8                	add    %ecx,%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80139a:	ff 45 fc             	incl   -0x4(%ebp)
  80139d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013a3:	7c e1                	jl     801386 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013b3:	eb 1f                	jmp    8013d4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b8:	8d 50 01             	lea    0x1(%eax),%edx
  8013bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013be:	89 c2                	mov    %eax,%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 c2                	add    %eax,%edx
  8013c5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	01 c8                	add    %ecx,%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013d1:	ff 45 f8             	incl   -0x8(%ebp)
  8013d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013da:	7c d9                	jl     8013b5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	c6 00 00             	movb   $0x0,(%eax)
}
  8013e7:	90                   	nop
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80140d:	eb 0c                	jmp    80141b <strsplit+0x31>
			*string++ = 0;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8d 50 01             	lea    0x1(%eax),%edx
  801415:	89 55 08             	mov    %edx,0x8(%ebp)
  801418:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	84 c0                	test   %al,%al
  801422:	74 18                	je     80143c <strsplit+0x52>
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	0f be c0             	movsbl %al,%eax
  80142c:	50                   	push   %eax
  80142d:	ff 75 0c             	pushl  0xc(%ebp)
  801430:	e8 83 fa ff ff       	call   800eb8 <strchr>
  801435:	83 c4 08             	add    $0x8,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	75 d3                	jne    80140f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	84 c0                	test   %al,%al
  801443:	74 5a                	je     80149f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801445:	8b 45 14             	mov    0x14(%ebp),%eax
  801448:	8b 00                	mov    (%eax),%eax
  80144a:	83 f8 0f             	cmp    $0xf,%eax
  80144d:	75 07                	jne    801456 <strsplit+0x6c>
		{
			return 0;
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
  801454:	eb 66                	jmp    8014bc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801456:	8b 45 14             	mov    0x14(%ebp),%eax
  801459:	8b 00                	mov    (%eax),%eax
  80145b:	8d 48 01             	lea    0x1(%eax),%ecx
  80145e:	8b 55 14             	mov    0x14(%ebp),%edx
  801461:	89 0a                	mov    %ecx,(%edx)
  801463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146a:	8b 45 10             	mov    0x10(%ebp),%eax
  80146d:	01 c2                	add    %eax,%edx
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801474:	eb 03                	jmp    801479 <strsplit+0x8f>
			string++;
  801476:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	84 c0                	test   %al,%al
  801480:	74 8b                	je     80140d <strsplit+0x23>
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	0f be c0             	movsbl %al,%eax
  80148a:	50                   	push   %eax
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	e8 25 fa ff ff       	call   800eb8 <strchr>
  801493:	83 c4 08             	add    $0x8,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	74 dc                	je     801476 <strsplit+0x8c>
			string++;
	}
  80149a:	e9 6e ff ff ff       	jmp    80140d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80149f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a3:	8b 00                	mov    (%eax),%eax
  8014a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d1:	eb 4a                	jmp    80151d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	01 c2                	add    %eax,%edx
  8014db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	01 c8                	add    %ecx,%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	3c 40                	cmp    $0x40,%al
  8014f3:	7e 25                	jle    80151a <str2lower+0x5c>
  8014f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	01 d0                	add    %edx,%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	3c 5a                	cmp    $0x5a,%al
  801501:	7f 17                	jg     80151a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	01 d0                	add    %edx,%eax
  80150b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80150e:	8b 55 08             	mov    0x8(%ebp),%edx
  801511:	01 ca                	add    %ecx,%edx
  801513:	8a 12                	mov    (%edx),%dl
  801515:	83 c2 20             	add    $0x20,%edx
  801518:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80151a:	ff 45 fc             	incl   -0x4(%ebp)
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	e8 01 f8 ff ff       	call   800d26 <strlen>
  801525:	83 c4 04             	add    $0x4,%esp
  801528:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80152b:	7f a6                	jg     8014d3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80152d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801538:	a1 08 40 80 00       	mov    0x804008,%eax
  80153d:	85 c0                	test   %eax,%eax
  80153f:	74 42                	je     801583 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	68 00 00 00 82       	push   $0x82000000
  801549:	68 00 00 00 80       	push   $0x80000000
  80154e:	e8 00 08 00 00       	call   801d53 <initialize_dynamic_allocator>
  801553:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801556:	e8 e7 05 00 00       	call   801b42 <sys_get_uheap_strategy>
  80155b:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801560:	a1 40 40 80 00       	mov    0x804040,%eax
  801565:	05 00 10 00 00       	add    $0x1000,%eax
  80156a:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  80156f:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801574:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801579:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801580:	00 00 00 
	}
}
  801583:	90                   	nop
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	68 06 04 00 00       	push   $0x406
  8015a2:	50                   	push   %eax
  8015a3:	e8 e4 01 00 00       	call   80178c <__sys_allocate_page>
  8015a8:	83 c4 10             	add    $0x10,%esp
  8015ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b2:	79 14                	jns    8015c8 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	68 3c 31 80 00       	push   $0x80313c
  8015bc:	6a 1f                	push   $0x1f
  8015be:	68 78 31 80 00       	push   $0x803178
  8015c3:	e8 ae 11 00 00       	call   802776 <_panic>
	return 0;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015e3:	83 ec 0c             	sub    $0xc,%esp
  8015e6:	50                   	push   %eax
  8015e7:	e8 e7 01 00 00       	call   8017d3 <__sys_unmap_frame>
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015f6:	79 14                	jns    80160c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 84 31 80 00       	push   $0x803184
  801600:	6a 2a                	push   $0x2a
  801602:	68 78 31 80 00       	push   $0x803178
  801607:	e8 6a 11 00 00       	call   802776 <_panic>
}
  80160c:	90                   	nop
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801615:	e8 18 ff ff ff       	call   801532 <uheap_init>
	if (size == 0) return NULL ;
  80161a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80161e:	75 07                	jne    801627 <malloc+0x18>
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	eb 14                	jmp    80163b <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	68 c4 31 80 00       	push   $0x8031c4
  80162f:	6a 3e                	push   $0x3e
  801631:	68 78 31 80 00       	push   $0x803178
  801636:	e8 3b 11 00 00       	call   802776 <_panic>
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	68 ec 31 80 00       	push   $0x8031ec
  80164b:	6a 49                	push   $0x49
  80164d:	68 78 31 80 00       	push   $0x803178
  801652:	e8 1f 11 00 00       	call   802776 <_panic>

00801657 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 18             	sub    $0x18,%esp
  80165d:	8b 45 10             	mov    0x10(%ebp),%eax
  801660:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801663:	e8 ca fe ff ff       	call   801532 <uheap_init>
	if (size == 0) return NULL ;
  801668:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80166c:	75 07                	jne    801675 <smalloc+0x1e>
  80166e:	b8 00 00 00 00       	mov    $0x0,%eax
  801673:	eb 14                	jmp    801689 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	68 10 32 80 00       	push   $0x803210
  80167d:	6a 5a                	push   $0x5a
  80167f:	68 78 31 80 00       	push   $0x803178
  801684:	e8 ed 10 00 00       	call   802776 <_panic>
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801691:	e8 9c fe ff ff       	call   801532 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	68 38 32 80 00       	push   $0x803238
  80169e:	6a 6a                	push   $0x6a
  8016a0:	68 78 31 80 00       	push   $0x803178
  8016a5:	e8 cc 10 00 00       	call   802776 <_panic>

008016aa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016b0:	e8 7d fe ff ff       	call   801532 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 5c 32 80 00       	push   $0x80325c
  8016bd:	68 88 00 00 00       	push   $0x88
  8016c2:	68 78 31 80 00       	push   $0x803178
  8016c7:	e8 aa 10 00 00       	call   802776 <_panic>

008016cc <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	68 84 32 80 00       	push   $0x803284
  8016da:	68 9b 00 00 00       	push   $0x9b
  8016df:	68 78 31 80 00       	push   $0x803178
  8016e4:	e8 8d 10 00 00       	call   802776 <_panic>

008016e9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	57                   	push   %edi
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
  8016ef:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016fe:	8b 7d 18             	mov    0x18(%ebp),%edi
  801701:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801704:	cd 30                	int    $0x30
  801706:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801709:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5f                   	pop    %edi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    

00801714 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	8b 45 10             	mov    0x10(%ebp),%eax
  80171d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801720:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801723:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	6a 00                	push   $0x0
  80172c:	51                   	push   %ecx
  80172d:	52                   	push   %edx
  80172e:	ff 75 0c             	pushl  0xc(%ebp)
  801731:	50                   	push   %eax
  801732:	6a 00                	push   $0x0
  801734:	e8 b0 ff ff ff       	call   8016e9 <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
}
  80173c:	90                   	nop
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_cgetc>:

int
sys_cgetc(void)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 02                	push   $0x2
  80174e:	e8 96 ff ff ff       	call   8016e9 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 03                	push   $0x3
  801767:	e8 7d ff ff ff       	call   8016e9 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	90                   	nop
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 04                	push   $0x4
  801781:	e8 63 ff ff ff       	call   8016e9 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	90                   	nop
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	6a 08                	push   $0x8
  80179f:	e8 45 ff ff ff       	call   8016e9 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	56                   	push   %esi
  8017ad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8017b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	56                   	push   %esi
  8017be:	53                   	push   %ebx
  8017bf:	51                   	push   %ecx
  8017c0:	52                   	push   %edx
  8017c1:	50                   	push   %eax
  8017c2:	6a 09                	push   $0x9
  8017c4:	e8 20 ff ff ff       	call   8016e9 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    

008017d3 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	ff 75 08             	pushl  0x8(%ebp)
  8017e1:	6a 0a                	push   $0xa
  8017e3:	e8 01 ff ff ff       	call   8016e9 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	6a 0b                	push   $0xb
  8017fe:	e8 e6 fe ff ff       	call   8016e9 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 0c                	push   $0xc
  801817:	e8 cd fe ff ff       	call   8016e9 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 0d                	push   $0xd
  801830:	e8 b4 fe ff ff       	call   8016e9 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 0e                	push   $0xe
  801849:	e8 9b fe ff ff       	call   8016e9 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 0f                	push   $0xf
  801862:	e8 82 fe ff ff       	call   8016e9 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	ff 75 08             	pushl  0x8(%ebp)
  80187a:	6a 10                	push   $0x10
  80187c:	e8 68 fe ff ff       	call   8016e9 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 11                	push   $0x11
  801895:	e8 4f fe ff ff       	call   8016e9 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	90                   	nop
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 04             	sub    $0x4,%esp
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	50                   	push   %eax
  8018b9:	6a 01                	push   $0x1
  8018bb:	e8 29 fe ff ff       	call   8016e9 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	90                   	nop
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 14                	push   $0x14
  8018d5:	e8 0f fe ff ff       	call   8016e9 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018ec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	51                   	push   %ecx
  8018f9:	52                   	push   %edx
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	6a 15                	push   $0x15
  801900:	e8 e4 fd ff ff       	call   8016e9 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80190d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	52                   	push   %edx
  80191a:	50                   	push   %eax
  80191b:	6a 16                	push   $0x16
  80191d:	e8 c7 fd ff ff       	call   8016e9 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80192a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	51                   	push   %ecx
  801938:	52                   	push   %edx
  801939:	50                   	push   %eax
  80193a:	6a 17                	push   $0x17
  80193c:	e8 a8 fd ff ff       	call   8016e9 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	52                   	push   %edx
  801956:	50                   	push   %eax
  801957:	6a 18                	push   $0x18
  801959:	e8 8b fd ff ff       	call   8016e9 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 14             	pushl  0x14(%ebp)
  80196e:	ff 75 10             	pushl  0x10(%ebp)
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	50                   	push   %eax
  801975:	6a 19                	push   $0x19
  801977:	e8 6d fd ff ff       	call   8016e9 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	50                   	push   %eax
  801990:	6a 1a                	push   $0x1a
  801992:	e8 52 fd ff ff       	call   8016e9 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	90                   	nop
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	50                   	push   %eax
  8019ac:	6a 1b                	push   $0x1b
  8019ae:	e8 36 fd ff ff       	call   8016e9 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 05                	push   $0x5
  8019c7:	e8 1d fd ff ff       	call   8016e9 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 06                	push   $0x6
  8019e0:	e8 04 fd ff ff       	call   8016e9 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 07                	push   $0x7
  8019f9:	e8 eb fc ff ff       	call   8016e9 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_exit_env>:


void sys_exit_env(void)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 1c                	push   $0x1c
  801a12:	e8 d2 fc ff ff       	call   8016e9 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	90                   	nop
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a26:	8d 50 04             	lea    0x4(%eax),%edx
  801a29:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	52                   	push   %edx
  801a33:	50                   	push   %eax
  801a34:	6a 1d                	push   $0x1d
  801a36:	e8 ae fc ff ff       	call   8016e9 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
	return result;
  801a3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a47:	89 01                	mov    %eax,(%ecx)
  801a49:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	c9                   	leave  
  801a50:	c2 04 00             	ret    $0x4

00801a53 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	ff 75 10             	pushl  0x10(%ebp)
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	6a 13                	push   $0x13
  801a65:	e8 7f fc ff ff       	call   8016e9 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6d:	90                   	nop
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 1e                	push   $0x1e
  801a7f:	e8 65 fc ff ff       	call   8016e9 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a95:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	50                   	push   %eax
  801aa2:	6a 1f                	push   $0x1f
  801aa4:	e8 40 fc ff ff       	call   8016e9 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aac:	90                   	nop
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <rsttst>:
void rsttst()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 21                	push   $0x21
  801abe:	e8 26 fc ff ff       	call   8016e9 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac6:	90                   	nop
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 04             	sub    $0x4,%esp
  801acf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ad5:	8b 55 18             	mov    0x18(%ebp),%edx
  801ad8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	ff 75 10             	pushl  0x10(%ebp)
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	ff 75 08             	pushl  0x8(%ebp)
  801ae7:	6a 20                	push   $0x20
  801ae9:	e8 fb fb ff ff       	call   8016e9 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
	return ;
  801af1:	90                   	nop
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <chktst>:
void chktst(uint32 n)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	6a 22                	push   $0x22
  801b04:	e8 e0 fb ff ff       	call   8016e9 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0c:	90                   	nop
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <inctst>:

void inctst()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 23                	push   $0x23
  801b1e:	e8 c6 fb ff ff       	call   8016e9 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
	return ;
  801b26:	90                   	nop
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <gettst>:
uint32 gettst()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 24                	push   $0x24
  801b38:	e8 ac fb ff ff       	call   8016e9 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 25                	push   $0x25
  801b51:	e8 93 fb ff ff       	call   8016e9 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
  801b59:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801b5e:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 26                	push   $0x26
  801b7d:	e8 67 fb ff ff       	call   8016e9 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b8c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	6a 00                	push   $0x0
  801b9a:	53                   	push   %ebx
  801b9b:	51                   	push   %ecx
  801b9c:	52                   	push   %edx
  801b9d:	50                   	push   %eax
  801b9e:	6a 27                	push   $0x27
  801ba0:	e8 44 fb ff ff       	call   8016e9 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 28                	push   $0x28
  801bc0:	e8 24 fb ff ff       	call   8016e9 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bcd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	51                   	push   %ecx
  801bd9:	ff 75 10             	pushl  0x10(%ebp)
  801bdc:	52                   	push   %edx
  801bdd:	50                   	push   %eax
  801bde:	6a 29                	push   $0x29
  801be0:	e8 04 fb ff ff       	call   8016e9 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	ff 75 10             	pushl  0x10(%ebp)
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	ff 75 08             	pushl  0x8(%ebp)
  801bfa:	6a 12                	push   $0x12
  801bfc:	e8 e8 fa ff ff       	call   8016e9 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
	return ;
  801c04:	90                   	nop
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	52                   	push   %edx
  801c17:	50                   	push   %eax
  801c18:	6a 2a                	push   $0x2a
  801c1a:	e8 ca fa ff ff       	call   8016e9 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
	return;
  801c22:	90                   	nop
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 2b                	push   $0x2b
  801c34:	e8 b0 fa ff ff       	call   8016e9 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 2d                	push   $0x2d
  801c4f:	e8 95 fa ff ff       	call   8016e9 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	ff 75 08             	pushl  0x8(%ebp)
  801c69:	6a 2c                	push   $0x2c
  801c6b:	e8 79 fa ff ff       	call   8016e9 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return ;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	68 a8 32 80 00       	push   $0x8032a8
  801c84:	68 25 01 00 00       	push   $0x125
  801c89:	68 db 32 80 00       	push   $0x8032db
  801c8e:	e8 e3 0a 00 00       	call   802776 <_panic>

00801c93 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801c99:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801ca0:	72 09                	jb     801cab <to_page_va+0x18>
  801ca2:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801ca9:	72 14                	jb     801cbf <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	68 ec 32 80 00       	push   $0x8032ec
  801cb3:	6a 15                	push   $0x15
  801cb5:	68 17 33 80 00       	push   $0x803317
  801cba:	e8 b7 0a 00 00       	call   802776 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	ba 60 40 80 00       	mov    $0x804060,%edx
  801cc7:	29 d0                	sub    %edx,%eax
  801cc9:	c1 f8 02             	sar    $0x2,%eax
  801ccc:	89 c2                	mov    %eax,%edx
  801cce:	89 d0                	mov    %edx,%eax
  801cd0:	c1 e0 02             	shl    $0x2,%eax
  801cd3:	01 d0                	add    %edx,%eax
  801cd5:	c1 e0 02             	shl    $0x2,%eax
  801cd8:	01 d0                	add    %edx,%eax
  801cda:	c1 e0 02             	shl    $0x2,%eax
  801cdd:	01 d0                	add    %edx,%eax
  801cdf:	89 c1                	mov    %eax,%ecx
  801ce1:	c1 e1 08             	shl    $0x8,%ecx
  801ce4:	01 c8                	add    %ecx,%eax
  801ce6:	89 c1                	mov    %eax,%ecx
  801ce8:	c1 e1 10             	shl    $0x10,%ecx
  801ceb:	01 c8                	add    %ecx,%eax
  801ced:	01 c0                	add    %eax,%eax
  801cef:	01 d0                	add    %edx,%eax
  801cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf7:	c1 e0 0c             	shl    $0xc,%eax
  801cfa:	89 c2                	mov    %eax,%edx
  801cfc:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d01:	01 d0                	add    %edx,%eax
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801d0b:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d10:	8b 55 08             	mov    0x8(%ebp),%edx
  801d13:	29 c2                	sub    %eax,%edx
  801d15:	89 d0                	mov    %edx,%eax
  801d17:	c1 e8 0c             	shr    $0xc,%eax
  801d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d21:	78 09                	js     801d2c <to_page_info+0x27>
  801d23:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801d2a:	7e 14                	jle    801d40 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	68 30 33 80 00       	push   $0x803330
  801d34:	6a 22                	push   $0x22
  801d36:	68 17 33 80 00       	push   $0x803317
  801d3b:	e8 36 0a 00 00       	call   802776 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801d40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d43:	89 d0                	mov    %edx,%eax
  801d45:	01 c0                	add    %eax,%eax
  801d47:	01 d0                	add    %edx,%eax
  801d49:	c1 e0 02             	shl    $0x2,%eax
  801d4c:	05 60 40 80 00       	add    $0x804060,%eax
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	05 00 00 00 02       	add    $0x2000000,%eax
  801d61:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d64:	73 16                	jae    801d7c <initialize_dynamic_allocator+0x29>
  801d66:	68 54 33 80 00       	push   $0x803354
  801d6b:	68 7a 33 80 00       	push   $0x80337a
  801d70:	6a 34                	push   $0x34
  801d72:	68 17 33 80 00       	push   $0x803317
  801d77:	e8 fa 09 00 00       	call   802776 <_panic>
		is_initialized = 1;
  801d7c:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801d83:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d91:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801d96:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801d9d:	00 00 00 
  801da0:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801da7:	00 00 00 
  801daa:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801db1:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db7:	2b 45 08             	sub    0x8(%ebp),%eax
  801dba:	c1 e8 0c             	shr    $0xc,%eax
  801dbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801dc7:	e9 c8 00 00 00       	jmp    801e94 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dcf:	89 d0                	mov    %edx,%eax
  801dd1:	01 c0                	add    %eax,%eax
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	c1 e0 02             	shl    $0x2,%eax
  801dd8:	05 68 40 80 00       	add    $0x804068,%eax
  801ddd:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de5:	89 d0                	mov    %edx,%eax
  801de7:	01 c0                	add    %eax,%eax
  801de9:	01 d0                	add    %edx,%eax
  801deb:	c1 e0 02             	shl    $0x2,%eax
  801dee:	05 6a 40 80 00       	add    $0x80406a,%eax
  801df3:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801df8:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801dfe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e01:	89 c8                	mov    %ecx,%eax
  801e03:	01 c0                	add    %eax,%eax
  801e05:	01 c8                	add    %ecx,%eax
  801e07:	c1 e0 02             	shl    $0x2,%eax
  801e0a:	05 64 40 80 00       	add    $0x804064,%eax
  801e0f:	89 10                	mov    %edx,(%eax)
  801e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e14:	89 d0                	mov    %edx,%eax
  801e16:	01 c0                	add    %eax,%eax
  801e18:	01 d0                	add    %edx,%eax
  801e1a:	c1 e0 02             	shl    $0x2,%eax
  801e1d:	05 64 40 80 00       	add    $0x804064,%eax
  801e22:	8b 00                	mov    (%eax),%eax
  801e24:	85 c0                	test   %eax,%eax
  801e26:	74 1b                	je     801e43 <initialize_dynamic_allocator+0xf0>
  801e28:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e2e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e31:	89 c8                	mov    %ecx,%eax
  801e33:	01 c0                	add    %eax,%eax
  801e35:	01 c8                	add    %ecx,%eax
  801e37:	c1 e0 02             	shl    $0x2,%eax
  801e3a:	05 60 40 80 00       	add    $0x804060,%eax
  801e3f:	89 02                	mov    %eax,(%edx)
  801e41:	eb 16                	jmp    801e59 <initialize_dynamic_allocator+0x106>
  801e43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e46:	89 d0                	mov    %edx,%eax
  801e48:	01 c0                	add    %eax,%eax
  801e4a:	01 d0                	add    %edx,%eax
  801e4c:	c1 e0 02             	shl    $0x2,%eax
  801e4f:	05 60 40 80 00       	add    $0x804060,%eax
  801e54:	a3 48 40 80 00       	mov    %eax,0x804048
  801e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5c:	89 d0                	mov    %edx,%eax
  801e5e:	01 c0                	add    %eax,%eax
  801e60:	01 d0                	add    %edx,%eax
  801e62:	c1 e0 02             	shl    $0x2,%eax
  801e65:	05 60 40 80 00       	add    $0x804060,%eax
  801e6a:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801e6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e72:	89 d0                	mov    %edx,%eax
  801e74:	01 c0                	add    %eax,%eax
  801e76:	01 d0                	add    %edx,%eax
  801e78:	c1 e0 02             	shl    $0x2,%eax
  801e7b:	05 60 40 80 00       	add    $0x804060,%eax
  801e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e86:	a1 54 40 80 00       	mov    0x804054,%eax
  801e8b:	40                   	inc    %eax
  801e8c:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801e91:	ff 45 f4             	incl   -0xc(%ebp)
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e97:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e9a:	0f 8c 2c ff ff ff    	jl     801dcc <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801ea0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ea7:	eb 36                	jmp    801edf <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eac:	c1 e0 04             	shl    $0x4,%eax
  801eaf:	05 80 c0 81 00       	add    $0x81c080,%eax
  801eb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebd:	c1 e0 04             	shl    $0x4,%eax
  801ec0:	05 84 c0 81 00       	add    $0x81c084,%eax
  801ec5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ece:	c1 e0 04             	shl    $0x4,%eax
  801ed1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801ed6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801edc:	ff 45 f0             	incl   -0x10(%ebp)
  801edf:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801ee3:	7e c4                	jle    801ea9 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801ee5:	90                   	nop
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	50                   	push   %eax
  801ef5:	e8 0b fe ff ff       	call   801d05 <to_page_info>
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	8b 40 08             	mov    0x8(%eax),%eax
  801f06:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	ff 75 0c             	pushl  0xc(%ebp)
  801f17:	e8 77 fd ff ff       	call   801c93 <to_page_va>
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801f22:	b8 00 10 00 00       	mov    $0x1000,%eax
  801f27:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2c:	f7 75 08             	divl   0x8(%ebp)
  801f2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	50                   	push   %eax
  801f39:	e8 48 f6 ff ff       	call   801586 <get_page>
  801f3e:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f51:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801f55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f5c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801f63:	eb 19                	jmp    801f7e <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f68:	ba 01 00 00 00       	mov    $0x1,%edx
  801f6d:	88 c1                	mov    %al,%cl
  801f6f:	d3 e2                	shl    %cl,%edx
  801f71:	89 d0                	mov    %edx,%eax
  801f73:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f76:	74 0e                	je     801f86 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801f78:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f7b:	ff 45 f0             	incl   -0x10(%ebp)
  801f7e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801f82:	7e e1                	jle    801f65 <split_page_to_blocks+0x5a>
  801f84:	eb 01                	jmp    801f87 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801f86:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801f87:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f8e:	e9 a7 00 00 00       	jmp    80203a <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f96:	0f af 45 08          	imul   0x8(%ebp),%eax
  801f9a:	89 c2                	mov    %eax,%edx
  801f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9f:	01 d0                	add    %edx,%eax
  801fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801fa4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fa8:	75 14                	jne    801fbe <split_page_to_blocks+0xb3>
  801faa:	83 ec 04             	sub    $0x4,%esp
  801fad:	68 90 33 80 00       	push   $0x803390
  801fb2:	6a 7c                	push   $0x7c
  801fb4:	68 17 33 80 00       	push   $0x803317
  801fb9:	e8 b8 07 00 00       	call   802776 <_panic>
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	c1 e0 04             	shl    $0x4,%eax
  801fc4:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fc9:	8b 10                	mov    (%eax),%edx
  801fcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fce:	89 50 04             	mov    %edx,0x4(%eax)
  801fd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd4:	8b 40 04             	mov    0x4(%eax),%eax
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	74 14                	je     801fef <split_page_to_blocks+0xe4>
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	c1 e0 04             	shl    $0x4,%eax
  801fe1:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801feb:	89 10                	mov    %edx,(%eax)
  801fed:	eb 11                	jmp    802000 <split_page_to_blocks+0xf5>
  801fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff2:	c1 e0 04             	shl    $0x4,%eax
  801ff5:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ffe:	89 02                	mov    %eax,(%edx)
  802000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802003:	c1 e0 04             	shl    $0x4,%eax
  802006:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80200c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80200f:	89 02                	mov    %eax,(%edx)
  802011:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802014:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	c1 e0 04             	shl    $0x4,%eax
  802020:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	8d 50 01             	lea    0x1(%eax),%edx
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	c1 e0 04             	shl    $0x4,%eax
  802030:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802035:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802037:	ff 45 ec             	incl   -0x14(%ebp)
  80203a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80203d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802040:	0f 82 4d ff ff ff    	jb     801f93 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802046:	90                   	nop
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80204f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802056:	76 19                	jbe    802071 <alloc_block+0x28>
  802058:	68 b4 33 80 00       	push   $0x8033b4
  80205d:	68 7a 33 80 00       	push   $0x80337a
  802062:	68 8a 00 00 00       	push   $0x8a
  802067:	68 17 33 80 00       	push   $0x803317
  80206c:	e8 05 07 00 00       	call   802776 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802071:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802078:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80207f:	eb 19                	jmp    80209a <alloc_block+0x51>
		if((1 << i) >= size) break;
  802081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802084:	ba 01 00 00 00       	mov    $0x1,%edx
  802089:	88 c1                	mov    %al,%cl
  80208b:	d3 e2                	shl    %cl,%edx
  80208d:	89 d0                	mov    %edx,%eax
  80208f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802092:	73 0e                	jae    8020a2 <alloc_block+0x59>
		idx++;
  802094:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802097:	ff 45 f0             	incl   -0x10(%ebp)
  80209a:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80209e:	7e e1                	jle    802081 <alloc_block+0x38>
  8020a0:	eb 01                	jmp    8020a3 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8020a2:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	c1 e0 04             	shl    $0x4,%eax
  8020a9:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020ae:	8b 00                	mov    (%eax),%eax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	0f 84 df 00 00 00    	je     802197 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	c1 e0 04             	shl    $0x4,%eax
  8020be:	05 80 c0 81 00       	add    $0x81c080,%eax
  8020c3:	8b 00                	mov    (%eax),%eax
  8020c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8020c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020cc:	75 17                	jne    8020e5 <alloc_block+0x9c>
  8020ce:	83 ec 04             	sub    $0x4,%esp
  8020d1:	68 d5 33 80 00       	push   $0x8033d5
  8020d6:	68 9e 00 00 00       	push   $0x9e
  8020db:	68 17 33 80 00       	push   $0x803317
  8020e0:	e8 91 06 00 00       	call   802776 <_panic>
  8020e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e8:	8b 00                	mov    (%eax),%eax
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	74 10                	je     8020fe <alloc_block+0xb5>
  8020ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020f6:	8b 52 04             	mov    0x4(%edx),%edx
  8020f9:	89 50 04             	mov    %edx,0x4(%eax)
  8020fc:	eb 14                	jmp    802112 <alloc_block+0xc9>
  8020fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802101:	8b 40 04             	mov    0x4(%eax),%eax
  802104:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802107:	c1 e2 04             	shl    $0x4,%edx
  80210a:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802110:	89 02                	mov    %eax,(%edx)
  802112:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802115:	8b 40 04             	mov    0x4(%eax),%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	74 0f                	je     80212b <alloc_block+0xe2>
  80211c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211f:	8b 40 04             	mov    0x4(%eax),%eax
  802122:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802125:	8b 12                	mov    (%edx),%edx
  802127:	89 10                	mov    %edx,(%eax)
  802129:	eb 13                	jmp    80213e <alloc_block+0xf5>
  80212b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212e:	8b 00                	mov    (%eax),%eax
  802130:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802133:	c1 e2 04             	shl    $0x4,%edx
  802136:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80213c:	89 02                	mov    %eax,(%edx)
  80213e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802141:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802147:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802154:	c1 e0 04             	shl    $0x4,%eax
  802157:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	c1 e0 04             	shl    $0x4,%eax
  802167:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80216c:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80216e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	50                   	push   %eax
  802175:	e8 8b fb ff ff       	call   801d05 <to_page_info>
  80217a:	83 c4 10             	add    $0x10,%esp
  80217d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802183:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802187:	48                   	dec    %eax
  802188:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80218b:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80218f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802192:	e9 bc 02 00 00       	jmp    802453 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802197:	a1 54 40 80 00       	mov    0x804054,%eax
  80219c:	85 c0                	test   %eax,%eax
  80219e:	0f 84 7d 02 00 00    	je     802421 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8021a4:	a1 48 40 80 00       	mov    0x804048,%eax
  8021a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8021ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021b0:	75 17                	jne    8021c9 <alloc_block+0x180>
  8021b2:	83 ec 04             	sub    $0x4,%esp
  8021b5:	68 d5 33 80 00       	push   $0x8033d5
  8021ba:	68 a9 00 00 00       	push   $0xa9
  8021bf:	68 17 33 80 00       	push   $0x803317
  8021c4:	e8 ad 05 00 00       	call   802776 <_panic>
  8021c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021cc:	8b 00                	mov    (%eax),%eax
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	74 10                	je     8021e2 <alloc_block+0x199>
  8021d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021da:	8b 52 04             	mov    0x4(%edx),%edx
  8021dd:	89 50 04             	mov    %edx,0x4(%eax)
  8021e0:	eb 0b                	jmp    8021ed <alloc_block+0x1a4>
  8021e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e5:	8b 40 04             	mov    0x4(%eax),%eax
  8021e8:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f0:	8b 40 04             	mov    0x4(%eax),%eax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	74 0f                	je     802206 <alloc_block+0x1bd>
  8021f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021fa:	8b 40 04             	mov    0x4(%eax),%eax
  8021fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802200:	8b 12                	mov    (%edx),%edx
  802202:	89 10                	mov    %edx,(%eax)
  802204:	eb 0a                	jmp    802210 <alloc_block+0x1c7>
  802206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	a3 48 40 80 00       	mov    %eax,0x804048
  802210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802213:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802223:	a1 54 40 80 00       	mov    0x804054,%eax
  802228:	48                   	dec    %eax
  802229:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	83 c0 03             	add    $0x3,%eax
  802234:	ba 01 00 00 00       	mov    $0x1,%edx
  802239:	88 c1                	mov    %al,%cl
  80223b:	d3 e2                	shl    %cl,%edx
  80223d:	89 d0                	mov    %edx,%eax
  80223f:	83 ec 08             	sub    $0x8,%esp
  802242:	ff 75 e4             	pushl  -0x1c(%ebp)
  802245:	50                   	push   %eax
  802246:	e8 c0 fc ff ff       	call   801f0b <split_page_to_blocks>
  80224b:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	c1 e0 04             	shl    $0x4,%eax
  802254:	05 80 c0 81 00       	add    $0x81c080,%eax
  802259:	8b 00                	mov    (%eax),%eax
  80225b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80225e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802262:	75 17                	jne    80227b <alloc_block+0x232>
  802264:	83 ec 04             	sub    $0x4,%esp
  802267:	68 d5 33 80 00       	push   $0x8033d5
  80226c:	68 b0 00 00 00       	push   $0xb0
  802271:	68 17 33 80 00       	push   $0x803317
  802276:	e8 fb 04 00 00       	call   802776 <_panic>
  80227b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80227e:	8b 00                	mov    (%eax),%eax
  802280:	85 c0                	test   %eax,%eax
  802282:	74 10                	je     802294 <alloc_block+0x24b>
  802284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802287:	8b 00                	mov    (%eax),%eax
  802289:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80228c:	8b 52 04             	mov    0x4(%edx),%edx
  80228f:	89 50 04             	mov    %edx,0x4(%eax)
  802292:	eb 14                	jmp    8022a8 <alloc_block+0x25f>
  802294:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802297:	8b 40 04             	mov    0x4(%eax),%eax
  80229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229d:	c1 e2 04             	shl    $0x4,%edx
  8022a0:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8022a6:	89 02                	mov    %eax,(%edx)
  8022a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ab:	8b 40 04             	mov    0x4(%eax),%eax
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	74 0f                	je     8022c1 <alloc_block+0x278>
  8022b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022b5:	8b 40 04             	mov    0x4(%eax),%eax
  8022b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022bb:	8b 12                	mov    (%edx),%edx
  8022bd:	89 10                	mov    %edx,(%eax)
  8022bf:	eb 13                	jmp    8022d4 <alloc_block+0x28b>
  8022c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c9:	c1 e2 04             	shl    $0x4,%edx
  8022cc:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8022d2:	89 02                	mov    %eax,(%edx)
  8022d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	c1 e0 04             	shl    $0x4,%eax
  8022ed:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022f2:	8b 00                	mov    (%eax),%eax
  8022f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	c1 e0 04             	shl    $0x4,%eax
  8022fd:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802302:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802304:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802307:	83 ec 0c             	sub    $0xc,%esp
  80230a:	50                   	push   %eax
  80230b:	e8 f5 f9 ff ff       	call   801d05 <to_page_info>
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802316:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802319:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80231d:	48                   	dec    %eax
  80231e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802321:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802328:	e9 26 01 00 00       	jmp    802453 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80232d:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	c1 e0 04             	shl    $0x4,%eax
  802336:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80233b:	8b 00                	mov    (%eax),%eax
  80233d:	85 c0                	test   %eax,%eax
  80233f:	0f 84 dc 00 00 00    	je     802421 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	c1 e0 04             	shl    $0x4,%eax
  80234b:	05 80 c0 81 00       	add    $0x81c080,%eax
  802350:	8b 00                	mov    (%eax),%eax
  802352:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802355:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802359:	75 17                	jne    802372 <alloc_block+0x329>
  80235b:	83 ec 04             	sub    $0x4,%esp
  80235e:	68 d5 33 80 00       	push   $0x8033d5
  802363:	68 be 00 00 00       	push   $0xbe
  802368:	68 17 33 80 00       	push   $0x803317
  80236d:	e8 04 04 00 00       	call   802776 <_panic>
  802372:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802375:	8b 00                	mov    (%eax),%eax
  802377:	85 c0                	test   %eax,%eax
  802379:	74 10                	je     80238b <alloc_block+0x342>
  80237b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802383:	8b 52 04             	mov    0x4(%edx),%edx
  802386:	89 50 04             	mov    %edx,0x4(%eax)
  802389:	eb 14                	jmp    80239f <alloc_block+0x356>
  80238b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80238e:	8b 40 04             	mov    0x4(%eax),%eax
  802391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802394:	c1 e2 04             	shl    $0x4,%edx
  802397:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80239d:	89 02                	mov    %eax,(%edx)
  80239f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a2:	8b 40 04             	mov    0x4(%eax),%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	74 0f                	je     8023b8 <alloc_block+0x36f>
  8023a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ac:	8b 40 04             	mov    0x4(%eax),%eax
  8023af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023b2:	8b 12                	mov    (%edx),%edx
  8023b4:	89 10                	mov    %edx,(%eax)
  8023b6:	eb 13                	jmp    8023cb <alloc_block+0x382>
  8023b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c0:	c1 e2 04             	shl    $0x4,%edx
  8023c3:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023c9:	89 02                	mov    %eax,(%edx)
  8023cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	c1 e0 04             	shl    $0x4,%eax
  8023e4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023e9:	8b 00                	mov    (%eax),%eax
  8023eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	c1 e0 04             	shl    $0x4,%eax
  8023f4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023f9:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8023fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023fe:	83 ec 0c             	sub    $0xc,%esp
  802401:	50                   	push   %eax
  802402:	e8 fe f8 ff ff       	call   801d05 <to_page_info>
  802407:	83 c4 10             	add    $0x10,%esp
  80240a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80240d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802410:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802414:	48                   	dec    %eax
  802415:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802418:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80241c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80241f:	eb 32                	jmp    802453 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802421:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802425:	77 15                	ja     80243c <alloc_block+0x3f3>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	c1 e0 04             	shl    $0x4,%eax
  80242d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	0f 84 f1 fe ff ff    	je     80232d <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	68 f3 33 80 00       	push   $0x8033f3
  802444:	68 c8 00 00 00       	push   $0xc8
  802449:	68 17 33 80 00       	push   $0x803317
  80244e:	e8 23 03 00 00       	call   802776 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80245b:	8b 55 08             	mov    0x8(%ebp),%edx
  80245e:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802463:	39 c2                	cmp    %eax,%edx
  802465:	72 0c                	jb     802473 <free_block+0x1e>
  802467:	8b 55 08             	mov    0x8(%ebp),%edx
  80246a:	a1 40 40 80 00       	mov    0x804040,%eax
  80246f:	39 c2                	cmp    %eax,%edx
  802471:	72 19                	jb     80248c <free_block+0x37>
  802473:	68 04 34 80 00       	push   $0x803404
  802478:	68 7a 33 80 00       	push   $0x80337a
  80247d:	68 d7 00 00 00       	push   $0xd7
  802482:	68 17 33 80 00       	push   $0x803317
  802487:	e8 ea 02 00 00       	call   802776 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	83 ec 0c             	sub    $0xc,%esp
  802498:	50                   	push   %eax
  802499:	e8 67 f8 ff ff       	call   801d05 <to_page_info>
  80249e:	83 c4 10             	add    $0x10,%esp
  8024a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8024a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024a7:	8b 40 08             	mov    0x8(%eax),%eax
  8024aa:	0f b7 c0             	movzwl %ax,%eax
  8024ad:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8024b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8024b7:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8024be:	eb 19                	jmp    8024d9 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	ba 01 00 00 00       	mov    $0x1,%edx
  8024c8:	88 c1                	mov    %al,%cl
  8024ca:	d3 e2                	shl    %cl,%edx
  8024cc:	89 d0                	mov    %edx,%eax
  8024ce:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8024d1:	74 0e                	je     8024e1 <free_block+0x8c>
	        break;
	    idx++;
  8024d3:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8024d6:	ff 45 f0             	incl   -0x10(%ebp)
  8024d9:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8024dd:	7e e1                	jle    8024c0 <free_block+0x6b>
  8024df:	eb 01                	jmp    8024e2 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8024e1:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8024e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8024e9:	40                   	inc    %eax
  8024ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ed:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8024f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024f5:	75 17                	jne    80250e <free_block+0xb9>
  8024f7:	83 ec 04             	sub    $0x4,%esp
  8024fa:	68 90 33 80 00       	push   $0x803390
  8024ff:	68 ee 00 00 00       	push   $0xee
  802504:	68 17 33 80 00       	push   $0x803317
  802509:	e8 68 02 00 00       	call   802776 <_panic>
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	c1 e0 04             	shl    $0x4,%eax
  802514:	05 84 c0 81 00       	add    $0x81c084,%eax
  802519:	8b 10                	mov    (%eax),%edx
  80251b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251e:	89 50 04             	mov    %edx,0x4(%eax)
  802521:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802524:	8b 40 04             	mov    0x4(%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 14                	je     80253f <free_block+0xea>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	c1 e0 04             	shl    $0x4,%eax
  802531:	05 84 c0 81 00       	add    $0x81c084,%eax
  802536:	8b 00                	mov    (%eax),%eax
  802538:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80253b:	89 10                	mov    %edx,(%eax)
  80253d:	eb 11                	jmp    802550 <free_block+0xfb>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	c1 e0 04             	shl    $0x4,%eax
  802545:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80254b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254e:	89 02                	mov    %eax,(%edx)
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	c1 e0 04             	shl    $0x4,%eax
  802556:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80255c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80255f:	89 02                	mov    %eax,(%edx)
  802561:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	c1 e0 04             	shl    $0x4,%eax
  802570:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	8d 50 01             	lea    0x1(%eax),%edx
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	c1 e0 04             	shl    $0x4,%eax
  802580:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802585:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802587:	b8 00 10 00 00       	mov    $0x1000,%eax
  80258c:	ba 00 00 00 00       	mov    $0x0,%edx
  802591:	f7 75 e0             	divl   -0x20(%ebp)
  802594:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80259e:	0f b7 c0             	movzwl %ax,%eax
  8025a1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8025a4:	0f 85 70 01 00 00    	jne    80271a <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8025aa:	83 ec 0c             	sub    $0xc,%esp
  8025ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025b0:	e8 de f6 ff ff       	call   801c93 <to_page_va>
  8025b5:	83 c4 10             	add    $0x10,%esp
  8025b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8025bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025c2:	e9 b7 00 00 00       	jmp    80267e <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8025c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cd:	01 d0                	add    %edx,%eax
  8025cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8025d2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8025d6:	75 17                	jne    8025ef <free_block+0x19a>
  8025d8:	83 ec 04             	sub    $0x4,%esp
  8025db:	68 d5 33 80 00       	push   $0x8033d5
  8025e0:	68 f8 00 00 00       	push   $0xf8
  8025e5:	68 17 33 80 00       	push   $0x803317
  8025ea:	e8 87 01 00 00       	call   802776 <_panic>
  8025ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f2:	8b 00                	mov    (%eax),%eax
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	74 10                	je     802608 <free_block+0x1b3>
  8025f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802600:	8b 52 04             	mov    0x4(%edx),%edx
  802603:	89 50 04             	mov    %edx,0x4(%eax)
  802606:	eb 14                	jmp    80261c <free_block+0x1c7>
  802608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80260b:	8b 40 04             	mov    0x4(%eax),%eax
  80260e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802611:	c1 e2 04             	shl    $0x4,%edx
  802614:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80261a:	89 02                	mov    %eax,(%edx)
  80261c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80261f:	8b 40 04             	mov    0x4(%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 0f                	je     802635 <free_block+0x1e0>
  802626:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802629:	8b 40 04             	mov    0x4(%eax),%eax
  80262c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80262f:	8b 12                	mov    (%edx),%edx
  802631:	89 10                	mov    %edx,(%eax)
  802633:	eb 13                	jmp    802648 <free_block+0x1f3>
  802635:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263d:	c1 e2 04             	shl    $0x4,%edx
  802640:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802646:	89 02                	mov    %eax,(%edx)
  802648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80264b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802651:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802654:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	c1 e0 04             	shl    $0x4,%eax
  802661:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	8d 50 ff             	lea    -0x1(%eax),%edx
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	c1 e0 04             	shl    $0x4,%eax
  802671:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802676:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267b:	01 45 ec             	add    %eax,-0x14(%ebp)
  80267e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802685:	0f 86 3c ff ff ff    	jbe    8025c7 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  80268b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802697:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  80269d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026a1:	75 17                	jne    8026ba <free_block+0x265>
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	68 90 33 80 00       	push   $0x803390
  8026ab:	68 fe 00 00 00       	push   $0xfe
  8026b0:	68 17 33 80 00       	push   $0x803317
  8026b5:	e8 bc 00 00 00       	call   802776 <_panic>
  8026ba:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8026c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c3:	89 50 04             	mov    %edx,0x4(%eax)
  8026c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c9:	8b 40 04             	mov    0x4(%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	74 0c                	je     8026dc <free_block+0x287>
  8026d0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026d8:	89 10                	mov    %edx,(%eax)
  8026da:	eb 08                	jmp    8026e4 <free_block+0x28f>
  8026dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026df:	a3 48 40 80 00       	mov    %eax,0x804048
  8026e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e7:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8026ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f5:	a1 54 40 80 00       	mov    0x804054,%eax
  8026fa:	40                   	inc    %eax
  8026fb:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802700:	83 ec 0c             	sub    $0xc,%esp
  802703:	ff 75 e4             	pushl  -0x1c(%ebp)
  802706:	e8 88 f5 ff ff       	call   801c93 <to_page_va>
  80270b:	83 c4 10             	add    $0x10,%esp
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	50                   	push   %eax
  802712:	e8 b8 ee ff ff       	call   8015cf <return_page>
  802717:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80271a:	90                   	nop
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	68 3c 34 80 00       	push   $0x80343c
  80272b:	68 11 01 00 00       	push   $0x111
  802730:	68 17 33 80 00       	push   $0x803317
  802735:	e8 3c 00 00 00       	call   802776 <_panic>

0080273a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  802740:	8b 45 08             	mov    0x8(%ebp),%eax
  802743:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  802746:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80274a:	83 ec 0c             	sub    $0xc,%esp
  80274d:	50                   	push   %eax
  80274e:	e8 4d f1 ff ff       	call   8018a0 <sys_cputc>
  802753:	83 c4 10             	add    $0x10,%esp
}
  802756:	90                   	nop
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <getchar>:


int
getchar(void)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80275f:	e8 db ef ff ff       	call   80173f <sys_cgetc>
  802764:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <iscons>:

int iscons(int fdnum)
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80276f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802774:	5d                   	pop    %ebp
  802775:	c3                   	ret    

00802776 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80277c:	8d 45 10             	lea    0x10(%ebp),%eax
  80277f:	83 c0 04             	add    $0x4,%eax
  802782:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802785:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 16                	je     8027a4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80278e:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802793:	83 ec 08             	sub    $0x8,%esp
  802796:	50                   	push   %eax
  802797:	68 60 34 80 00       	push   $0x803460
  80279c:	e8 a4 dc ff ff       	call   800445 <cprintf>
  8027a1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8027a4:	a1 04 40 80 00       	mov    0x804004,%eax
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	ff 75 0c             	pushl  0xc(%ebp)
  8027af:	ff 75 08             	pushl  0x8(%ebp)
  8027b2:	50                   	push   %eax
  8027b3:	68 68 34 80 00       	push   $0x803468
  8027b8:	6a 74                	push   $0x74
  8027ba:	e8 b3 dc ff ff       	call   800472 <cprintf_colored>
  8027bf:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8027c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c5:	83 ec 08             	sub    $0x8,%esp
  8027c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8027cb:	50                   	push   %eax
  8027cc:	e8 05 dc ff ff       	call   8003d6 <vcprintf>
  8027d1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8027d4:	83 ec 08             	sub    $0x8,%esp
  8027d7:	6a 00                	push   $0x0
  8027d9:	68 90 34 80 00       	push   $0x803490
  8027de:	e8 f3 db ff ff       	call   8003d6 <vcprintf>
  8027e3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8027e6:	e8 6c db ff ff       	call   800357 <exit>

	// should not return here
	while (1) ;
  8027eb:	eb fe                	jmp    8027eb <_panic+0x75>

008027ed <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
  8027f0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8027f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8027f8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8027fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802801:	39 c2                	cmp    %eax,%edx
  802803:	74 14                	je     802819 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	68 94 34 80 00       	push   $0x803494
  80280d:	6a 26                	push   $0x26
  80280f:	68 e0 34 80 00       	push   $0x8034e0
  802814:	e8 5d ff ff ff       	call   802776 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802819:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802820:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802827:	e9 c5 00 00 00       	jmp    8028f1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	01 d0                	add    %edx,%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	75 08                	jne    802849 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802841:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802844:	e9 a5 00 00 00       	jmp    8028ee <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802849:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802850:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802857:	eb 69                	jmp    8028c2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802859:	a1 20 40 80 00       	mov    0x804020,%eax
  80285e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802864:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802867:	89 d0                	mov    %edx,%eax
  802869:	01 c0                	add    %eax,%eax
  80286b:	01 d0                	add    %edx,%eax
  80286d:	c1 e0 03             	shl    $0x3,%eax
  802870:	01 c8                	add    %ecx,%eax
  802872:	8a 40 04             	mov    0x4(%eax),%al
  802875:	84 c0                	test   %al,%al
  802877:	75 46                	jne    8028bf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802879:	a1 20 40 80 00       	mov    0x804020,%eax
  80287e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802884:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802887:	89 d0                	mov    %edx,%eax
  802889:	01 c0                	add    %eax,%eax
  80288b:	01 d0                	add    %edx,%eax
  80288d:	c1 e0 03             	shl    $0x3,%eax
  802890:	01 c8                	add    %ecx,%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802897:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80289a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80289f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8028a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	01 c8                	add    %ecx,%eax
  8028b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8028b2:	39 c2                	cmp    %eax,%edx
  8028b4:	75 09                	jne    8028bf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8028b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8028bd:	eb 15                	jmp    8028d4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8028bf:	ff 45 e8             	incl   -0x18(%ebp)
  8028c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8028c7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8028cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d0:	39 c2                	cmp    %eax,%edx
  8028d2:	77 85                	ja     802859 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8028d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028d8:	75 14                	jne    8028ee <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8028da:	83 ec 04             	sub    $0x4,%esp
  8028dd:	68 ec 34 80 00       	push   $0x8034ec
  8028e2:	6a 3a                	push   $0x3a
  8028e4:	68 e0 34 80 00       	push   $0x8034e0
  8028e9:	e8 88 fe ff ff       	call   802776 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8028ee:	ff 45 f0             	incl   -0x10(%ebp)
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028f7:	0f 8c 2f ff ff ff    	jl     80282c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8028fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802904:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80290b:	eb 26                	jmp    802933 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80290d:	a1 20 40 80 00       	mov    0x804020,%eax
  802912:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  802918:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80291b:	89 d0                	mov    %edx,%eax
  80291d:	01 c0                	add    %eax,%eax
  80291f:	01 d0                	add    %edx,%eax
  802921:	c1 e0 03             	shl    $0x3,%eax
  802924:	01 c8                	add    %ecx,%eax
  802926:	8a 40 04             	mov    0x4(%eax),%al
  802929:	3c 01                	cmp    $0x1,%al
  80292b:	75 03                	jne    802930 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80292d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802930:	ff 45 e0             	incl   -0x20(%ebp)
  802933:	a1 20 40 80 00       	mov    0x804020,%eax
  802938:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80293e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802941:	39 c2                	cmp    %eax,%edx
  802943:	77 c8                	ja     80290d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80294b:	74 14                	je     802961 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80294d:	83 ec 04             	sub    $0x4,%esp
  802950:	68 40 35 80 00       	push   $0x803540
  802955:	6a 44                	push   $0x44
  802957:	68 e0 34 80 00       	push   $0x8034e0
  80295c:	e8 15 fe ff ff       	call   802776 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802961:	90                   	nop
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <__udivdi3>:
  802964:	55                   	push   %ebp
  802965:	57                   	push   %edi
  802966:	56                   	push   %esi
  802967:	53                   	push   %ebx
  802968:	83 ec 1c             	sub    $0x1c,%esp
  80296b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80296f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802973:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802977:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80297b:	89 ca                	mov    %ecx,%edx
  80297d:	89 f8                	mov    %edi,%eax
  80297f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802983:	85 f6                	test   %esi,%esi
  802985:	75 2d                	jne    8029b4 <__udivdi3+0x50>
  802987:	39 cf                	cmp    %ecx,%edi
  802989:	77 65                	ja     8029f0 <__udivdi3+0x8c>
  80298b:	89 fd                	mov    %edi,%ebp
  80298d:	85 ff                	test   %edi,%edi
  80298f:	75 0b                	jne    80299c <__udivdi3+0x38>
  802991:	b8 01 00 00 00       	mov    $0x1,%eax
  802996:	31 d2                	xor    %edx,%edx
  802998:	f7 f7                	div    %edi
  80299a:	89 c5                	mov    %eax,%ebp
  80299c:	31 d2                	xor    %edx,%edx
  80299e:	89 c8                	mov    %ecx,%eax
  8029a0:	f7 f5                	div    %ebp
  8029a2:	89 c1                	mov    %eax,%ecx
  8029a4:	89 d8                	mov    %ebx,%eax
  8029a6:	f7 f5                	div    %ebp
  8029a8:	89 cf                	mov    %ecx,%edi
  8029aa:	89 fa                	mov    %edi,%edx
  8029ac:	83 c4 1c             	add    $0x1c,%esp
  8029af:	5b                   	pop    %ebx
  8029b0:	5e                   	pop    %esi
  8029b1:	5f                   	pop    %edi
  8029b2:	5d                   	pop    %ebp
  8029b3:	c3                   	ret    
  8029b4:	39 ce                	cmp    %ecx,%esi
  8029b6:	77 28                	ja     8029e0 <__udivdi3+0x7c>
  8029b8:	0f bd fe             	bsr    %esi,%edi
  8029bb:	83 f7 1f             	xor    $0x1f,%edi
  8029be:	75 40                	jne    802a00 <__udivdi3+0x9c>
  8029c0:	39 ce                	cmp    %ecx,%esi
  8029c2:	72 0a                	jb     8029ce <__udivdi3+0x6a>
  8029c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029c8:	0f 87 9e 00 00 00    	ja     802a6c <__udivdi3+0x108>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	89 fa                	mov    %edi,%edx
  8029d5:	83 c4 1c             	add    $0x1c,%esp
  8029d8:	5b                   	pop    %ebx
  8029d9:	5e                   	pop    %esi
  8029da:	5f                   	pop    %edi
  8029db:	5d                   	pop    %ebp
  8029dc:	c3                   	ret    
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	31 ff                	xor    %edi,%edi
  8029e2:	31 c0                	xor    %eax,%eax
  8029e4:	89 fa                	mov    %edi,%edx
  8029e6:	83 c4 1c             	add    $0x1c,%esp
  8029e9:	5b                   	pop    %ebx
  8029ea:	5e                   	pop    %esi
  8029eb:	5f                   	pop    %edi
  8029ec:	5d                   	pop    %ebp
  8029ed:	c3                   	ret    
  8029ee:	66 90                	xchg   %ax,%ax
  8029f0:	89 d8                	mov    %ebx,%eax
  8029f2:	f7 f7                	div    %edi
  8029f4:	31 ff                	xor    %edi,%edi
  8029f6:	89 fa                	mov    %edi,%edx
  8029f8:	83 c4 1c             	add    $0x1c,%esp
  8029fb:	5b                   	pop    %ebx
  8029fc:	5e                   	pop    %esi
  8029fd:	5f                   	pop    %edi
  8029fe:	5d                   	pop    %ebp
  8029ff:	c3                   	ret    
  802a00:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a05:	89 eb                	mov    %ebp,%ebx
  802a07:	29 fb                	sub    %edi,%ebx
  802a09:	89 f9                	mov    %edi,%ecx
  802a0b:	d3 e6                	shl    %cl,%esi
  802a0d:	89 c5                	mov    %eax,%ebp
  802a0f:	88 d9                	mov    %bl,%cl
  802a11:	d3 ed                	shr    %cl,%ebp
  802a13:	89 e9                	mov    %ebp,%ecx
  802a15:	09 f1                	or     %esi,%ecx
  802a17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a1b:	89 f9                	mov    %edi,%ecx
  802a1d:	d3 e0                	shl    %cl,%eax
  802a1f:	89 c5                	mov    %eax,%ebp
  802a21:	89 d6                	mov    %edx,%esi
  802a23:	88 d9                	mov    %bl,%cl
  802a25:	d3 ee                	shr    %cl,%esi
  802a27:	89 f9                	mov    %edi,%ecx
  802a29:	d3 e2                	shl    %cl,%edx
  802a2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a2f:	88 d9                	mov    %bl,%cl
  802a31:	d3 e8                	shr    %cl,%eax
  802a33:	09 c2                	or     %eax,%edx
  802a35:	89 d0                	mov    %edx,%eax
  802a37:	89 f2                	mov    %esi,%edx
  802a39:	f7 74 24 0c          	divl   0xc(%esp)
  802a3d:	89 d6                	mov    %edx,%esi
  802a3f:	89 c3                	mov    %eax,%ebx
  802a41:	f7 e5                	mul    %ebp
  802a43:	39 d6                	cmp    %edx,%esi
  802a45:	72 19                	jb     802a60 <__udivdi3+0xfc>
  802a47:	74 0b                	je     802a54 <__udivdi3+0xf0>
  802a49:	89 d8                	mov    %ebx,%eax
  802a4b:	31 ff                	xor    %edi,%edi
  802a4d:	e9 58 ff ff ff       	jmp    8029aa <__udivdi3+0x46>
  802a52:	66 90                	xchg   %ax,%ax
  802a54:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a58:	89 f9                	mov    %edi,%ecx
  802a5a:	d3 e2                	shl    %cl,%edx
  802a5c:	39 c2                	cmp    %eax,%edx
  802a5e:	73 e9                	jae    802a49 <__udivdi3+0xe5>
  802a60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a63:	31 ff                	xor    %edi,%edi
  802a65:	e9 40 ff ff ff       	jmp    8029aa <__udivdi3+0x46>
  802a6a:	66 90                	xchg   %ax,%ax
  802a6c:	31 c0                	xor    %eax,%eax
  802a6e:	e9 37 ff ff ff       	jmp    8029aa <__udivdi3+0x46>
  802a73:	90                   	nop

00802a74 <__umoddi3>:
  802a74:	55                   	push   %ebp
  802a75:	57                   	push   %edi
  802a76:	56                   	push   %esi
  802a77:	53                   	push   %ebx
  802a78:	83 ec 1c             	sub    $0x1c,%esp
  802a7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a93:	89 f3                	mov    %esi,%ebx
  802a95:	89 fa                	mov    %edi,%edx
  802a97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a9b:	89 34 24             	mov    %esi,(%esp)
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	75 1a                	jne    802abc <__umoddi3+0x48>
  802aa2:	39 f7                	cmp    %esi,%edi
  802aa4:	0f 86 a2 00 00 00    	jbe    802b4c <__umoddi3+0xd8>
  802aaa:	89 c8                	mov    %ecx,%eax
  802aac:	89 f2                	mov    %esi,%edx
  802aae:	f7 f7                	div    %edi
  802ab0:	89 d0                	mov    %edx,%eax
  802ab2:	31 d2                	xor    %edx,%edx
  802ab4:	83 c4 1c             	add    $0x1c,%esp
  802ab7:	5b                   	pop    %ebx
  802ab8:	5e                   	pop    %esi
  802ab9:	5f                   	pop    %edi
  802aba:	5d                   	pop    %ebp
  802abb:	c3                   	ret    
  802abc:	39 f0                	cmp    %esi,%eax
  802abe:	0f 87 ac 00 00 00    	ja     802b70 <__umoddi3+0xfc>
  802ac4:	0f bd e8             	bsr    %eax,%ebp
  802ac7:	83 f5 1f             	xor    $0x1f,%ebp
  802aca:	0f 84 ac 00 00 00    	je     802b7c <__umoddi3+0x108>
  802ad0:	bf 20 00 00 00       	mov    $0x20,%edi
  802ad5:	29 ef                	sub    %ebp,%edi
  802ad7:	89 fe                	mov    %edi,%esi
  802ad9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802add:	89 e9                	mov    %ebp,%ecx
  802adf:	d3 e0                	shl    %cl,%eax
  802ae1:	89 d7                	mov    %edx,%edi
  802ae3:	89 f1                	mov    %esi,%ecx
  802ae5:	d3 ef                	shr    %cl,%edi
  802ae7:	09 c7                	or     %eax,%edi
  802ae9:	89 e9                	mov    %ebp,%ecx
  802aeb:	d3 e2                	shl    %cl,%edx
  802aed:	89 14 24             	mov    %edx,(%esp)
  802af0:	89 d8                	mov    %ebx,%eax
  802af2:	d3 e0                	shl    %cl,%eax
  802af4:	89 c2                	mov    %eax,%edx
  802af6:	8b 44 24 08          	mov    0x8(%esp),%eax
  802afa:	d3 e0                	shl    %cl,%eax
  802afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b00:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b04:	89 f1                	mov    %esi,%ecx
  802b06:	d3 e8                	shr    %cl,%eax
  802b08:	09 d0                	or     %edx,%eax
  802b0a:	d3 eb                	shr    %cl,%ebx
  802b0c:	89 da                	mov    %ebx,%edx
  802b0e:	f7 f7                	div    %edi
  802b10:	89 d3                	mov    %edx,%ebx
  802b12:	f7 24 24             	mull   (%esp)
  802b15:	89 c6                	mov    %eax,%esi
  802b17:	89 d1                	mov    %edx,%ecx
  802b19:	39 d3                	cmp    %edx,%ebx
  802b1b:	0f 82 87 00 00 00    	jb     802ba8 <__umoddi3+0x134>
  802b21:	0f 84 91 00 00 00    	je     802bb8 <__umoddi3+0x144>
  802b27:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b2b:	29 f2                	sub    %esi,%edx
  802b2d:	19 cb                	sbb    %ecx,%ebx
  802b2f:	89 d8                	mov    %ebx,%eax
  802b31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b35:	d3 e0                	shl    %cl,%eax
  802b37:	89 e9                	mov    %ebp,%ecx
  802b39:	d3 ea                	shr    %cl,%edx
  802b3b:	09 d0                	or     %edx,%eax
  802b3d:	89 e9                	mov    %ebp,%ecx
  802b3f:	d3 eb                	shr    %cl,%ebx
  802b41:	89 da                	mov    %ebx,%edx
  802b43:	83 c4 1c             	add    $0x1c,%esp
  802b46:	5b                   	pop    %ebx
  802b47:	5e                   	pop    %esi
  802b48:	5f                   	pop    %edi
  802b49:	5d                   	pop    %ebp
  802b4a:	c3                   	ret    
  802b4b:	90                   	nop
  802b4c:	89 fd                	mov    %edi,%ebp
  802b4e:	85 ff                	test   %edi,%edi
  802b50:	75 0b                	jne    802b5d <__umoddi3+0xe9>
  802b52:	b8 01 00 00 00       	mov    $0x1,%eax
  802b57:	31 d2                	xor    %edx,%edx
  802b59:	f7 f7                	div    %edi
  802b5b:	89 c5                	mov    %eax,%ebp
  802b5d:	89 f0                	mov    %esi,%eax
  802b5f:	31 d2                	xor    %edx,%edx
  802b61:	f7 f5                	div    %ebp
  802b63:	89 c8                	mov    %ecx,%eax
  802b65:	f7 f5                	div    %ebp
  802b67:	89 d0                	mov    %edx,%eax
  802b69:	e9 44 ff ff ff       	jmp    802ab2 <__umoddi3+0x3e>
  802b6e:	66 90                	xchg   %ax,%ax
  802b70:	89 c8                	mov    %ecx,%eax
  802b72:	89 f2                	mov    %esi,%edx
  802b74:	83 c4 1c             	add    $0x1c,%esp
  802b77:	5b                   	pop    %ebx
  802b78:	5e                   	pop    %esi
  802b79:	5f                   	pop    %edi
  802b7a:	5d                   	pop    %ebp
  802b7b:	c3                   	ret    
  802b7c:	3b 04 24             	cmp    (%esp),%eax
  802b7f:	72 06                	jb     802b87 <__umoddi3+0x113>
  802b81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b85:	77 0f                	ja     802b96 <__umoddi3+0x122>
  802b87:	89 f2                	mov    %esi,%edx
  802b89:	29 f9                	sub    %edi,%ecx
  802b8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b8f:	89 14 24             	mov    %edx,(%esp)
  802b92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b96:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b9a:	8b 14 24             	mov    (%esp),%edx
  802b9d:	83 c4 1c             	add    $0x1c,%esp
  802ba0:	5b                   	pop    %ebx
  802ba1:	5e                   	pop    %esi
  802ba2:	5f                   	pop    %edi
  802ba3:	5d                   	pop    %ebp
  802ba4:	c3                   	ret    
  802ba5:	8d 76 00             	lea    0x0(%esi),%esi
  802ba8:	2b 04 24             	sub    (%esp),%eax
  802bab:	19 fa                	sbb    %edi,%edx
  802bad:	89 d1                	mov    %edx,%ecx
  802baf:	89 c6                	mov    %eax,%esi
  802bb1:	e9 71 ff ff ff       	jmp    802b27 <__umoddi3+0xb3>
  802bb6:	66 90                	xchg   %ax,%ax
  802bb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802bbc:	72 ea                	jb     802ba8 <__umoddi3+0x134>
  802bbe:	89 d9                	mov    %ebx,%ecx
  802bc0:	e9 62 ff ff ff       	jmp    802b27 <__umoddi3+0xb3>
