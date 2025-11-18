
obj/user/fib_loop:     file format elf32-i386


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
  800031:	e8 41 01 00 00       	call   800177 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int index=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 a0 2b 80 00       	push   $0x802ba0
  800057:	e8 98 0b 00 00       	call   800bf4 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 9a 10 00 00       	call   80110c <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 5e 15 00 00       	call   8015e6 <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 res = fibonacci(index, memo) ;
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	ff 75 f4             	pushl  -0xc(%ebp)
  800097:	e8 35 00 00 00       	call   8000d1 <fibonacci>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000a2:	89 55 ec             	mov    %edx,-0x14(%ebp)

	free(memo);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ab:	e8 64 15 00 00       	call   801614 <free>
  8000b0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000bc:	68 be 2b 80 00       	push   $0x802bbe
  8000c1:	e8 c8 03 00 00       	call   80048e <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 18 1a 00 00       	call   801ae6 <inctst>
	return;
  8000ce:	90                   	nop
}
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i <= n; ++i)
  8000d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e0:	eb 72                	jmp    800154 <fibonacci+0x83>
	{
		if (i <= 1)
  8000e2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8000e6:	7f 1e                	jg     800106 <fibonacci+0x35>
			memo[i] = 1;
  8000e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  8000fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  800104:	eb 4b                	jmp    800151 <fibonacci+0x80>
		else
			memo[i] = memo[i-1] + memo[i-2] ;
  800106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800109:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	8d 34 02             	lea    (%edx,%eax,1),%esi
  800116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800119:	05 ff ff ff 1f       	add    $0x1fffffff,%eax
  80011e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	8b 08                	mov    (%eax),%ecx
  80012c:	8b 58 04             	mov    0x4(%eax),%ebx
  80012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800132:	05 fe ff ff 1f       	add    $0x1ffffffe,%eax
  800137:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80013e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800141:	01 d0                	add    %edx,%eax
  800143:	8b 50 04             	mov    0x4(%eax),%edx
  800146:	8b 00                	mov    (%eax),%eax
  800148:	01 c8                	add    %ecx,%eax
  80014a:	11 da                	adc    %ebx,%edx
  80014c:	89 06                	mov    %eax,(%esi)
  80014e:	89 56 04             	mov    %edx,0x4(%esi)
}


int64 fibonacci(int n, int64 *memo)
{
	for (int i = 0; i <= n; ++i)
  800151:	ff 45 f4             	incl   -0xc(%ebp)
  800154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800157:	3b 45 08             	cmp    0x8(%ebp),%eax
  80015a:	7e 86                	jle    8000e2 <fibonacci+0x11>
		if (i <= 1)
			memo[i] = 1;
		else
			memo[i] = memo[i-1] + memo[i-2] ;
	}
	return memo[n];
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800166:	8b 45 0c             	mov    0xc(%ebp),%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	8b 50 04             	mov    0x4(%eax),%edx
  80016e:	8b 00                	mov    (%eax),%eax
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    

00800177 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	57                   	push   %edi
  80017b:	56                   	push   %esi
  80017c:	53                   	push   %ebx
  80017d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800180:	e8 23 18 00 00       	call   8019a8 <sys_getenvindex>
  800185:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 06             	shl    $0x6,%eax
  800190:	29 d0                	sub    %edx,%eax
  800192:	c1 e0 02             	shl    $0x2,%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80019e:	01 c8                	add    %ecx,%eax
  8001a0:	c1 e0 03             	shl    $0x3,%eax
  8001a3:	01 d0                	add    %edx,%eax
  8001a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001ac:	29 c2                	sub    %eax,%edx
  8001ae:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001b5:	89 c2                	mov    %eax,%edx
  8001b7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001bd:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c7:	8a 40 20             	mov    0x20(%eax),%al
  8001ca:	84 c0                	test   %al,%al
  8001cc:	74 0d                	je     8001db <libmain+0x64>
		binaryname = myEnv->prog_name;
  8001ce:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d3:	83 c0 20             	add    $0x20,%eax
  8001d6:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001df:	7e 0a                	jle    8001eb <libmain+0x74>
		binaryname = argv[0];
  8001e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e4:	8b 00                	mov    (%eax),%eax
  8001e6:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	ff 75 0c             	pushl  0xc(%ebp)
  8001f1:	ff 75 08             	pushl  0x8(%ebp)
  8001f4:	e8 3f fe ff ff       	call   800038 <_main>
  8001f9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001fc:	a1 00 40 80 00       	mov    0x804000,%eax
  800201:	85 c0                	test   %eax,%eax
  800203:	0f 84 01 01 00 00    	je     80030a <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800209:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80020f:	bb cc 2c 80 00       	mov    $0x802ccc,%ebx
  800214:	ba 0e 00 00 00       	mov    $0xe,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800221:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800224:	b9 56 00 00 00       	mov    $0x56,%ecx
  800229:	b0 00                	mov    $0x0,%al
  80022b:	89 d7                	mov    %edx,%edi
  80022d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80022f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800236:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	50                   	push   %eax
  80023d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800243:	50                   	push   %eax
  800244:	e8 95 19 00 00       	call   801bde <sys_utilities>
  800249:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80024c:	e8 de 14 00 00       	call   80172f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	68 ec 2b 80 00       	push   $0x802bec
  800259:	e8 be 01 00 00       	call   80041c <cprintf>
  80025e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800261:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800264:	85 c0                	test   %eax,%eax
  800266:	74 18                	je     800280 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800268:	e8 8f 19 00 00       	call   801bfc <sys_get_optimal_num_faults>
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	50                   	push   %eax
  800271:	68 14 2c 80 00       	push   $0x802c14
  800276:	e8 a1 01 00 00       	call   80041c <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	eb 59                	jmp    8002d9 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800280:	a1 20 40 80 00       	mov    0x804020,%eax
  800285:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80028b:	a1 20 40 80 00       	mov    0x804020,%eax
  800290:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800296:	83 ec 04             	sub    $0x4,%esp
  800299:	52                   	push   %edx
  80029a:	50                   	push   %eax
  80029b:	68 38 2c 80 00       	push   $0x802c38
  8002a0:	e8 77 01 00 00       	call   80041c <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ad:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8002b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b8:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8002be:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c3:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8002c9:	51                   	push   %ecx
  8002ca:	52                   	push   %edx
  8002cb:	50                   	push   %eax
  8002cc:	68 60 2c 80 00       	push   $0x802c60
  8002d1:	e8 46 01 00 00       	call   80041c <cprintf>
  8002d6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002de:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	50                   	push   %eax
  8002e8:	68 b8 2c 80 00       	push   $0x802cb8
  8002ed:	e8 2a 01 00 00       	call   80041c <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002f5:	83 ec 0c             	sub    $0xc,%esp
  8002f8:	68 ec 2b 80 00       	push   $0x802bec
  8002fd:	e8 1a 01 00 00       	call   80041c <cprintf>
  800302:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800305:	e8 3f 14 00 00       	call   801749 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80030a:	e8 1f 00 00 00       	call   80032e <exit>
}
  80030f:	90                   	nop
  800310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800313:	5b                   	pop    %ebx
  800314:	5e                   	pop    %esi
  800315:	5f                   	pop    %edi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	6a 00                	push   $0x0
  800323:	e8 4c 16 00 00       	call   801974 <sys_destroy_env>
  800328:	83 c4 10             	add    $0x10,%esp
}
  80032b:	90                   	nop
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <exit>:

void
exit(void)
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800334:	e8 a1 16 00 00       	call   8019da <sys_exit_env>
}
  800339:	90                   	nop
  80033a:	c9                   	leave  
  80033b:	c3                   	ret    

0080033c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	53                   	push   %ebx
  800340:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8b 00                	mov    (%eax),%eax
  800348:	8d 48 01             	lea    0x1(%eax),%ecx
  80034b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034e:	89 0a                	mov    %ecx,(%edx)
  800350:	8b 55 08             	mov    0x8(%ebp),%edx
  800353:	88 d1                	mov    %dl,%cl
  800355:	8b 55 0c             	mov    0xc(%ebp),%edx
  800358:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80035c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	3d ff 00 00 00       	cmp    $0xff,%eax
  800366:	75 30                	jne    800398 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800368:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  80036e:	a0 44 40 80 00       	mov    0x804044,%al
  800373:	0f b6 c0             	movzbl %al,%eax
  800376:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800379:	8b 09                	mov    (%ecx),%ecx
  80037b:	89 cb                	mov    %ecx,%ebx
  80037d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800380:	83 c1 08             	add    $0x8,%ecx
  800383:	52                   	push   %edx
  800384:	50                   	push   %eax
  800385:	53                   	push   %ebx
  800386:	51                   	push   %ecx
  800387:	e8 5f 13 00 00       	call   8016eb <sys_cputs>
  80038c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80038f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039b:	8b 40 04             	mov    0x4(%eax),%eax
  80039e:	8d 50 01             	lea    0x1(%eax),%edx
  8003a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003a7:	90                   	nop
  8003a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003bd:	00 00 00 
	b.cnt = 0;
  8003c0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003ca:	ff 75 0c             	pushl  0xc(%ebp)
  8003cd:	ff 75 08             	pushl  0x8(%ebp)
  8003d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d6:	50                   	push   %eax
  8003d7:	68 3c 03 80 00       	push   $0x80033c
  8003dc:	e8 5a 02 00 00       	call   80063b <vprintfmt>
  8003e1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003e4:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  8003ea:	a0 44 40 80 00       	mov    0x804044,%al
  8003ef:	0f b6 c0             	movzbl %al,%eax
  8003f2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003f8:	52                   	push   %edx
  8003f9:	50                   	push   %eax
  8003fa:	51                   	push   %ecx
  8003fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800401:	83 c0 08             	add    $0x8,%eax
  800404:	50                   	push   %eax
  800405:	e8 e1 12 00 00       	call   8016eb <sys_cputs>
  80040a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80040d:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800414:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800422:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800429:	8d 45 0c             	lea    0xc(%ebp),%eax
  80042c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80042f:	8b 45 08             	mov    0x8(%ebp),%eax
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	ff 75 f4             	pushl  -0xc(%ebp)
  800438:	50                   	push   %eax
  800439:	e8 6f ff ff ff       	call   8003ad <vcprintf>
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800444:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800447:	c9                   	leave  
  800448:	c3                   	ret    

00800449 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80044f:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800456:	8b 45 08             	mov    0x8(%ebp),%eax
  800459:	c1 e0 08             	shl    $0x8,%eax
  80045c:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  800461:	8d 45 0c             	lea    0xc(%ebp),%eax
  800464:	83 c0 04             	add    $0x4,%eax
  800467:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 f4             	pushl  -0xc(%ebp)
  800473:	50                   	push   %eax
  800474:	e8 34 ff ff ff       	call   8003ad <vcprintf>
  800479:	83 c4 10             	add    $0x10,%esp
  80047c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80047f:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  800486:	07 00 00 

	return cnt;
  800489:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    

0080048e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800494:	e8 96 12 00 00       	call   80172f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800499:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a8:	50                   	push   %eax
  8004a9:	e8 ff fe ff ff       	call   8003ad <vcprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b4:	e8 90 12 00 00       	call   801749 <sys_unlock_cons>
	return cnt;
  8004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004bc:	c9                   	leave  
  8004bd:	c3                   	ret    

008004be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	53                   	push   %ebx
  8004c2:	83 ec 14             	sub    $0x14,%esp
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004dc:	77 55                	ja     800533 <printnum+0x75>
  8004de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e1:	72 05                	jb     8004e8 <printnum+0x2a>
  8004e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e6:	77 4b                	ja     800533 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004eb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f6:	52                   	push   %edx
  8004f7:	50                   	push   %eax
  8004f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8004fe:	e8 39 24 00 00       	call   80293c <__udivdi3>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	83 ec 04             	sub    $0x4,%esp
  800509:	ff 75 20             	pushl  0x20(%ebp)
  80050c:	53                   	push   %ebx
  80050d:	ff 75 18             	pushl  0x18(%ebp)
  800510:	52                   	push   %edx
  800511:	50                   	push   %eax
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	ff 75 08             	pushl  0x8(%ebp)
  800518:	e8 a1 ff ff ff       	call   8004be <printnum>
  80051d:	83 c4 20             	add    $0x20,%esp
  800520:	eb 1a                	jmp    80053c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 20             	pushl  0x20(%ebp)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	ff d0                	call   *%eax
  800530:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800533:	ff 4d 1c             	decl   0x1c(%ebp)
  800536:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80053a:	7f e6                	jg     800522 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80053f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80054a:	53                   	push   %ebx
  80054b:	51                   	push   %ecx
  80054c:	52                   	push   %edx
  80054d:	50                   	push   %eax
  80054e:	e8 f9 24 00 00       	call   802a4c <__umoddi3>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	05 54 2f 80 00       	add    $0x802f54,%eax
  80055b:	8a 00                	mov    (%eax),%al
  80055d:	0f be c0             	movsbl %al,%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	ff 75 0c             	pushl  0xc(%ebp)
  800566:	50                   	push   %eax
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	ff d0                	call   *%eax
  80056c:	83 c4 10             	add    $0x10,%esp
}
  80056f:	90                   	nop
  800570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800573:	c9                   	leave  
  800574:	c3                   	ret    

00800575 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800578:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057c:	7e 1c                	jle    80059a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80057e:	8b 45 08             	mov    0x8(%ebp),%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	8d 50 08             	lea    0x8(%eax),%edx
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	89 10                	mov    %edx,(%eax)
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 e8 08             	sub    $0x8,%eax
  800593:	8b 50 04             	mov    0x4(%eax),%edx
  800596:	8b 00                	mov    (%eax),%eax
  800598:	eb 40                	jmp    8005da <getuint+0x65>
	else if (lflag)
  80059a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059e:	74 1e                	je     8005be <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	8d 50 04             	lea    0x4(%eax),%edx
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	89 10                	mov    %edx,(%eax)
  8005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	83 e8 04             	sub    $0x4,%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	eb 1c                	jmp    8005da <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8d 50 04             	lea    0x4(%eax),%edx
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	89 10                	mov    %edx,(%eax)
  8005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	83 e8 04             	sub    $0x4,%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005da:	5d                   	pop    %ebp
  8005db:	c3                   	ret    

008005dc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e3:	7e 1c                	jle    800601 <getint+0x25>
		return va_arg(*ap, long long);
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	8d 50 08             	lea    0x8(%eax),%edx
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	89 10                	mov    %edx,(%eax)
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	83 e8 08             	sub    $0x8,%eax
  8005fa:	8b 50 04             	mov    0x4(%eax),%edx
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	eb 38                	jmp    800639 <getint+0x5d>
	else if (lflag)
  800601:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800605:	74 1a                	je     800621 <getint+0x45>
		return va_arg(*ap, long);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	8d 50 04             	lea    0x4(%eax),%edx
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	89 10                	mov    %edx,(%eax)
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	83 e8 04             	sub    $0x4,%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	99                   	cltd   
  80061f:	eb 18                	jmp    800639 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	8d 50 04             	lea    0x4(%eax),%edx
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	89 10                	mov    %edx,(%eax)
  80062e:	8b 45 08             	mov    0x8(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	83 e8 04             	sub    $0x4,%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	99                   	cltd   
}
  800639:	5d                   	pop    %ebp
  80063a:	c3                   	ret    

0080063b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	56                   	push   %esi
  80063f:	53                   	push   %ebx
  800640:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800643:	eb 17                	jmp    80065c <vprintfmt+0x21>
			if (ch == '\0')
  800645:	85 db                	test   %ebx,%ebx
  800647:	0f 84 c1 03 00 00    	je     800a0e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	ff 75 0c             	pushl  0xc(%ebp)
  800653:	53                   	push   %ebx
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	ff d0                	call   *%eax
  800659:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065c:	8b 45 10             	mov    0x10(%ebp),%eax
  80065f:	8d 50 01             	lea    0x1(%eax),%edx
  800662:	89 55 10             	mov    %edx,0x10(%ebp)
  800665:	8a 00                	mov    (%eax),%al
  800667:	0f b6 d8             	movzbl %al,%ebx
  80066a:	83 fb 25             	cmp    $0x25,%ebx
  80066d:	75 d6                	jne    800645 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800673:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80067a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800681:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800688:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068f:	8b 45 10             	mov    0x10(%ebp),%eax
  800692:	8d 50 01             	lea    0x1(%eax),%edx
  800695:	89 55 10             	mov    %edx,0x10(%ebp)
  800698:	8a 00                	mov    (%eax),%al
  80069a:	0f b6 d8             	movzbl %al,%ebx
  80069d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a0:	83 f8 5b             	cmp    $0x5b,%eax
  8006a3:	0f 87 3d 03 00 00    	ja     8009e6 <vprintfmt+0x3ab>
  8006a9:	8b 04 85 78 2f 80 00 	mov    0x802f78(,%eax,4),%eax
  8006b0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b6:	eb d7                	jmp    80068f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006bc:	eb d1                	jmp    80068f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c8:	89 d0                	mov    %edx,%eax
  8006ca:	c1 e0 02             	shl    $0x2,%eax
  8006cd:	01 d0                	add    %edx,%eax
  8006cf:	01 c0                	add    %eax,%eax
  8006d1:	01 d8                	add    %ebx,%eax
  8006d3:	83 e8 30             	sub    $0x30,%eax
  8006d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006dc:	8a 00                	mov    (%eax),%al
  8006de:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e1:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e4:	7e 3e                	jle    800724 <vprintfmt+0xe9>
  8006e6:	83 fb 39             	cmp    $0x39,%ebx
  8006e9:	7f 39                	jg     800724 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006eb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006ee:	eb d5                	jmp    8006c5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	83 c0 04             	add    $0x4,%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800704:	eb 1f                	jmp    800725 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800706:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070a:	79 83                	jns    80068f <vprintfmt+0x54>
				width = 0;
  80070c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800713:	e9 77 ff ff ff       	jmp    80068f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800718:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80071f:	e9 6b ff ff ff       	jmp    80068f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800724:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800725:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800729:	0f 89 60 ff ff ff    	jns    80068f <vprintfmt+0x54>
				width = precision, precision = -1;
  80072f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800735:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80073c:	e9 4e ff ff ff       	jmp    80068f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800741:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800744:	e9 46 ff ff ff       	jmp    80068f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	50                   	push   %eax
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	ff d0                	call   *%eax
  800766:	83 c4 10             	add    $0x10,%esp
			break;
  800769:	e9 9b 02 00 00       	jmp    800a09 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	83 c0 04             	add    $0x4,%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	83 e8 04             	sub    $0x4,%eax
  80077d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80077f:	85 db                	test   %ebx,%ebx
  800781:	79 02                	jns    800785 <vprintfmt+0x14a>
				err = -err;
  800783:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800785:	83 fb 64             	cmp    $0x64,%ebx
  800788:	7f 0b                	jg     800795 <vprintfmt+0x15a>
  80078a:	8b 34 9d c0 2d 80 00 	mov    0x802dc0(,%ebx,4),%esi
  800791:	85 f6                	test   %esi,%esi
  800793:	75 19                	jne    8007ae <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800795:	53                   	push   %ebx
  800796:	68 65 2f 80 00       	push   $0x802f65
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	ff 75 08             	pushl  0x8(%ebp)
  8007a1:	e8 70 02 00 00       	call   800a16 <printfmt>
  8007a6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a9:	e9 5b 02 00 00       	jmp    800a09 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ae:	56                   	push   %esi
  8007af:	68 6e 2f 80 00       	push   $0x802f6e
  8007b4:	ff 75 0c             	pushl  0xc(%ebp)
  8007b7:	ff 75 08             	pushl  0x8(%ebp)
  8007ba:	e8 57 02 00 00       	call   800a16 <printfmt>
  8007bf:	83 c4 10             	add    $0x10,%esp
			break;
  8007c2:	e9 42 02 00 00       	jmp    800a09 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	83 c0 04             	add    $0x4,%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	83 e8 04             	sub    $0x4,%eax
  8007d6:	8b 30                	mov    (%eax),%esi
  8007d8:	85 f6                	test   %esi,%esi
  8007da:	75 05                	jne    8007e1 <vprintfmt+0x1a6>
				p = "(null)";
  8007dc:	be 71 2f 80 00       	mov    $0x802f71,%esi
			if (width > 0 && padc != '-')
  8007e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e5:	7e 6d                	jle    800854 <vprintfmt+0x219>
  8007e7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007eb:	74 67                	je     800854 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	50                   	push   %eax
  8007f4:	56                   	push   %esi
  8007f5:	e8 26 05 00 00       	call   800d20 <strnlen>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800800:	eb 16                	jmp    800818 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800802:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	ff d0                	call   *%eax
  800812:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800815:	ff 4d e4             	decl   -0x1c(%ebp)
  800818:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081c:	7f e4                	jg     800802 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081e:	eb 34                	jmp    800854 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800820:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800824:	74 1c                	je     800842 <vprintfmt+0x207>
  800826:	83 fb 1f             	cmp    $0x1f,%ebx
  800829:	7e 05                	jle    800830 <vprintfmt+0x1f5>
  80082b:	83 fb 7e             	cmp    $0x7e,%ebx
  80082e:	7e 12                	jle    800842 <vprintfmt+0x207>
					putch('?', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 3f                	push   $0x3f
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	eb 0f                	jmp    800851 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	53                   	push   %ebx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800851:	ff 4d e4             	decl   -0x1c(%ebp)
  800854:	89 f0                	mov    %esi,%eax
  800856:	8d 70 01             	lea    0x1(%eax),%esi
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f be d8             	movsbl %al,%ebx
  80085e:	85 db                	test   %ebx,%ebx
  800860:	74 24                	je     800886 <vprintfmt+0x24b>
  800862:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800866:	78 b8                	js     800820 <vprintfmt+0x1e5>
  800868:	ff 4d e0             	decl   -0x20(%ebp)
  80086b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086f:	79 af                	jns    800820 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800871:	eb 13                	jmp    800886 <vprintfmt+0x24b>
				putch(' ', putdat);
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	6a 20                	push   $0x20
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800883:	ff 4d e4             	decl   -0x1c(%ebp)
  800886:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088a:	7f e7                	jg     800873 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80088c:	e9 78 01 00 00       	jmp    800a09 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 e8             	pushl  -0x18(%ebp)
  800897:	8d 45 14             	lea    0x14(%ebp),%eax
  80089a:	50                   	push   %eax
  80089b:	e8 3c fd ff ff       	call   8005dc <getint>
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008af:	85 d2                	test   %edx,%edx
  8008b1:	79 23                	jns    8008d6 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	6a 2d                	push   $0x2d
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c9:	f7 d8                	neg    %eax
  8008cb:	83 d2 00             	adc    $0x0,%edx
  8008ce:	f7 da                	neg    %edx
  8008d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008dd:	e9 bc 00 00 00       	jmp    80099e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008eb:	50                   	push   %eax
  8008ec:	e8 84 fc ff ff       	call   800575 <getuint>
  8008f1:	83 c4 10             	add    $0x10,%esp
  8008f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800901:	e9 98 00 00 00       	jmp    80099e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	6a 58                	push   $0x58
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	ff d0                	call   *%eax
  800913:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	6a 58                	push   $0x58
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	6a 58                	push   $0x58
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
			break;
  800936:	e9 ce 00 00 00       	jmp    800a09 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	6a 30                	push   $0x30
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	ff d0                	call   *%eax
  800948:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	6a 78                	push   $0x78
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	ff d0                	call   *%eax
  800958:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	83 c0 04             	add    $0x4,%eax
  800961:	89 45 14             	mov    %eax,0x14(%ebp)
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	83 e8 04             	sub    $0x4,%eax
  80096a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800976:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097d:	eb 1f                	jmp    80099e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 e8             	pushl  -0x18(%ebp)
  800985:	8d 45 14             	lea    0x14(%ebp),%eax
  800988:	50                   	push   %eax
  800989:	e8 e7 fb ff ff       	call   800575 <getuint>
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800994:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800997:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80099e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	52                   	push   %edx
  8009a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ac:	50                   	push   %eax
  8009ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	ff 75 08             	pushl  0x8(%ebp)
  8009b9:	e8 00 fb ff ff       	call   8004be <printnum>
  8009be:	83 c4 20             	add    $0x20,%esp
			break;
  8009c1:	eb 46                	jmp    800a09 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	53                   	push   %ebx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
			break;
  8009d2:	eb 35                	jmp    800a09 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d4:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  8009db:	eb 2c                	jmp    800a09 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009dd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  8009e4:	eb 23                	jmp    800a09 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	6a 25                	push   $0x25
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	ff d0                	call   *%eax
  8009f3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f6:	ff 4d 10             	decl   0x10(%ebp)
  8009f9:	eb 03                	jmp    8009fe <vprintfmt+0x3c3>
  8009fb:	ff 4d 10             	decl   0x10(%ebp)
  8009fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800a01:	48                   	dec    %eax
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	3c 25                	cmp    $0x25,%al
  800a06:	75 f3                	jne    8009fb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a08:	90                   	nop
		}
	}
  800a09:	e9 35 fc ff ff       	jmp    800643 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a0e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a12:	5b                   	pop    %ebx
  800a13:	5e                   	pop    %esi
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a1c:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1f:	83 c0 04             	add    $0x4,%eax
  800a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a25:	8b 45 10             	mov    0x10(%ebp),%eax
  800a28:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 0c             	pushl  0xc(%ebp)
  800a2f:	ff 75 08             	pushl  0x8(%ebp)
  800a32:	e8 04 fc ff ff       	call   80063b <vprintfmt>
  800a37:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a3a:	90                   	nop
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a43:	8b 40 08             	mov    0x8(%eax),%eax
  800a46:	8d 50 01             	lea    0x1(%eax),%edx
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a52:	8b 10                	mov    (%eax),%edx
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	8b 40 04             	mov    0x4(%eax),%eax
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	73 12                	jae    800a70 <sprintputch+0x33>
		*b->buf++ = ch;
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8b 00                	mov    (%eax),%eax
  800a63:	8d 48 01             	lea    0x1(%eax),%ecx
  800a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a69:	89 0a                	mov    %ecx,(%edx)
  800a6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6e:	88 10                	mov    %dl,(%eax)
}
  800a70:	90                   	nop
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	01 d0                	add    %edx,%eax
  800a8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a98:	74 06                	je     800aa0 <vsnprintf+0x2d>
  800a9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9e:	7f 07                	jg     800aa7 <vsnprintf+0x34>
		return -E_INVAL;
  800aa0:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa5:	eb 20                	jmp    800ac7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa7:	ff 75 14             	pushl  0x14(%ebp)
  800aaa:	ff 75 10             	pushl  0x10(%ebp)
  800aad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab0:	50                   	push   %eax
  800ab1:	68 3d 0a 80 00       	push   $0x800a3d
  800ab6:	e8 80 fb ff ff       	call   80063b <vprintfmt>
  800abb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800acf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  800adb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ade:	50                   	push   %eax
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	ff 75 08             	pushl  0x8(%ebp)
  800ae5:	e8 89 ff ff ff       	call   800a73 <vsnprintf>
  800aea:	83 c4 10             	add    $0x10,%esp
  800aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800afb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aff:	74 13                	je     800b14 <readline+0x1f>
		cprintf("%s", prompt);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 08             	pushl  0x8(%ebp)
  800b07:	68 e8 30 80 00       	push   $0x8030e8
  800b0c:	e8 0b f9 ff ff       	call   80041c <cprintf>
  800b11:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800b14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b1b:	83 ec 0c             	sub    $0xc,%esp
  800b1e:	6a 00                	push   $0x0
  800b20:	e8 1e 1c 00 00       	call   802743 <iscons>
  800b25:	83 c4 10             	add    $0x10,%esp
  800b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b2b:	e8 00 1c 00 00       	call   802730 <getchar>
  800b30:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b37:	79 22                	jns    800b5b <readline+0x66>
			if (c != -E_EOF)
  800b39:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b3d:	0f 84 ad 00 00 00    	je     800bf0 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 ec             	pushl  -0x14(%ebp)
  800b49:	68 eb 30 80 00       	push   $0x8030eb
  800b4e:	e8 c9 f8 ff ff       	call   80041c <cprintf>
  800b53:	83 c4 10             	add    $0x10,%esp
			break;
  800b56:	e9 95 00 00 00       	jmp    800bf0 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b5b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b5f:	7e 34                	jle    800b95 <readline+0xa0>
  800b61:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b68:	7f 2b                	jg     800b95 <readline+0xa0>
			if (echoing)
  800b6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b6e:	74 0e                	je     800b7e <readline+0x89>
				cputchar(c);
  800b70:	83 ec 0c             	sub    $0xc,%esp
  800b73:	ff 75 ec             	pushl  -0x14(%ebp)
  800b76:	e8 96 1b 00 00       	call   802711 <cputchar>
  800b7b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b87:	89 c2                	mov    %eax,%edx
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8c:	01 d0                	add    %edx,%eax
  800b8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b91:	88 10                	mov    %dl,(%eax)
  800b93:	eb 56                	jmp    800beb <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b95:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b99:	75 1f                	jne    800bba <readline+0xc5>
  800b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b9f:	7e 19                	jle    800bba <readline+0xc5>
			if (echoing)
  800ba1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ba5:	74 0e                	je     800bb5 <readline+0xc0>
				cputchar(c);
  800ba7:	83 ec 0c             	sub    $0xc,%esp
  800baa:	ff 75 ec             	pushl  -0x14(%ebp)
  800bad:	e8 5f 1b 00 00       	call   802711 <cputchar>
  800bb2:	83 c4 10             	add    $0x10,%esp

			i--;
  800bb5:	ff 4d f4             	decl   -0xc(%ebp)
  800bb8:	eb 31                	jmp    800beb <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800bba:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800bbe:	74 0a                	je     800bca <readline+0xd5>
  800bc0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800bc4:	0f 85 61 ff ff ff    	jne    800b2b <readline+0x36>
			if (echoing)
  800bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bce:	74 0e                	je     800bde <readline+0xe9>
				cputchar(c);
  800bd0:	83 ec 0c             	sub    $0xc,%esp
  800bd3:	ff 75 ec             	pushl  -0x14(%ebp)
  800bd6:	e8 36 1b 00 00       	call   802711 <cputchar>
  800bdb:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be4:	01 d0                	add    %edx,%eax
  800be6:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800be9:	eb 06                	jmp    800bf1 <readline+0xfc>
		}
	}
  800beb:	e9 3b ff ff ff       	jmp    800b2b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800bf0:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800bf1:	90                   	nop
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800bfa:	e8 30 0b 00 00       	call   80172f <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800bff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c03:	74 13                	je     800c18 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 08             	pushl  0x8(%ebp)
  800c0b:	68 e8 30 80 00       	push   $0x8030e8
  800c10:	e8 07 f8 ff ff       	call   80041c <cprintf>
  800c15:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800c1f:	83 ec 0c             	sub    $0xc,%esp
  800c22:	6a 00                	push   $0x0
  800c24:	e8 1a 1b 00 00       	call   802743 <iscons>
  800c29:	83 c4 10             	add    $0x10,%esp
  800c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800c2f:	e8 fc 1a 00 00       	call   802730 <getchar>
  800c34:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800c37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c3b:	79 22                	jns    800c5f <atomic_readline+0x6b>
				if (c != -E_EOF)
  800c3d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c41:	0f 84 ad 00 00 00    	je     800cf4 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 ec             	pushl  -0x14(%ebp)
  800c4d:	68 eb 30 80 00       	push   $0x8030eb
  800c52:	e8 c5 f7 ff ff       	call   80041c <cprintf>
  800c57:	83 c4 10             	add    $0x10,%esp
				break;
  800c5a:	e9 95 00 00 00       	jmp    800cf4 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800c5f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800c63:	7e 34                	jle    800c99 <atomic_readline+0xa5>
  800c65:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800c6c:	7f 2b                	jg     800c99 <atomic_readline+0xa5>
				if (echoing)
  800c6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c72:	74 0e                	je     800c82 <atomic_readline+0x8e>
					cputchar(c);
  800c74:	83 ec 0c             	sub    $0xc,%esp
  800c77:	ff 75 ec             	pushl  -0x14(%ebp)
  800c7a:	e8 92 1a 00 00       	call   802711 <cputchar>
  800c7f:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c85:	8d 50 01             	lea    0x1(%eax),%edx
  800c88:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	01 d0                	add    %edx,%eax
  800c92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c95:	88 10                	mov    %dl,(%eax)
  800c97:	eb 56                	jmp    800cef <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c99:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c9d:	75 1f                	jne    800cbe <atomic_readline+0xca>
  800c9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ca3:	7e 19                	jle    800cbe <atomic_readline+0xca>
				if (echoing)
  800ca5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ca9:	74 0e                	je     800cb9 <atomic_readline+0xc5>
					cputchar(c);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	ff 75 ec             	pushl  -0x14(%ebp)
  800cb1:	e8 5b 1a 00 00       	call   802711 <cputchar>
  800cb6:	83 c4 10             	add    $0x10,%esp
				i--;
  800cb9:	ff 4d f4             	decl   -0xc(%ebp)
  800cbc:	eb 31                	jmp    800cef <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800cbe:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800cc2:	74 0a                	je     800cce <atomic_readline+0xda>
  800cc4:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800cc8:	0f 85 61 ff ff ff    	jne    800c2f <atomic_readline+0x3b>
				if (echoing)
  800cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cd2:	74 0e                	je     800ce2 <atomic_readline+0xee>
					cputchar(c);
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  800cda:	e8 32 1a 00 00       	call   802711 <cputchar>
  800cdf:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800ce2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce8:	01 d0                	add    %edx,%eax
  800cea:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800ced:	eb 06                	jmp    800cf5 <atomic_readline+0x101>
			}
		}
  800cef:	e9 3b ff ff ff       	jmp    800c2f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800cf4:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800cf5:	e8 4f 0a 00 00       	call   801749 <sys_unlock_cons>
}
  800cfa:	90                   	nop
  800cfb:	c9                   	leave  
  800cfc:	c3                   	ret    

00800cfd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d0a:	eb 06                	jmp    800d12 <strlen+0x15>
		n++;
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0f:	ff 45 08             	incl   0x8(%ebp)
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	84 c0                	test   %al,%al
  800d19:	75 f1                	jne    800d0c <strlen+0xf>
		n++;
	return n;
  800d1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1e:	c9                   	leave  
  800d1f:	c3                   	ret    

00800d20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d2d:	eb 09                	jmp    800d38 <strnlen+0x18>
		n++;
  800d2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d32:	ff 45 08             	incl   0x8(%ebp)
  800d35:	ff 4d 0c             	decl   0xc(%ebp)
  800d38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d3c:	74 09                	je     800d47 <strnlen+0x27>
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	84 c0                	test   %al,%al
  800d45:	75 e8                	jne    800d2f <strnlen+0xf>
		n++;
	return n;
  800d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d58:	90                   	nop
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8d 50 01             	lea    0x1(%eax),%edx
  800d5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d6b:	8a 12                	mov    (%edx),%dl
  800d6d:	88 10                	mov    %dl,(%eax)
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	75 e4                	jne    800d59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d8d:	eb 1f                	jmp    800dae <strncpy+0x34>
		*dst++ = *src;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8d 50 01             	lea    0x1(%eax),%edx
  800d95:	89 55 08             	mov    %edx,0x8(%ebp)
  800d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9b:	8a 12                	mov    (%edx),%dl
  800d9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	84 c0                	test   %al,%al
  800da6:	74 03                	je     800dab <strncpy+0x31>
			src++;
  800da8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dab:	ff 45 fc             	incl   -0x4(%ebp)
  800dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800db4:	72 d9                	jb     800d8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800db6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcb:	74 30                	je     800dfd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dcd:	eb 16                	jmp    800de5 <strlcpy+0x2a>
			*dst++ = *src++;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8d 50 01             	lea    0x1(%eax),%edx
  800dd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de1:	8a 12                	mov    (%edx),%dl
  800de3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800de5:	ff 4d 10             	decl   0x10(%ebp)
  800de8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dec:	74 09                	je     800df7 <strlcpy+0x3c>
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	84 c0                	test   %al,%al
  800df5:	75 d8                	jne    800dcf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e03:	29 c2                	sub    %eax,%edx
  800e05:	89 d0                	mov    %edx,%eax
}
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e0c:	eb 06                	jmp    800e14 <strcmp+0xb>
		p++, q++;
  800e0e:	ff 45 08             	incl   0x8(%ebp)
  800e11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	84 c0                	test   %al,%al
  800e1b:	74 0e                	je     800e2b <strcmp+0x22>
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 10                	mov    (%eax),%dl
  800e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	38 c2                	cmp    %al,%dl
  800e29:	74 e3                	je     800e0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	0f b6 d0             	movzbl %al,%edx
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 c0             	movzbl %al,%eax
  800e3b:	29 c2                	sub    %eax,%edx
  800e3d:	89 d0                	mov    %edx,%eax
}
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e44:	eb 09                	jmp    800e4f <strncmp+0xe>
		n--, p++, q++;
  800e46:	ff 4d 10             	decl   0x10(%ebp)
  800e49:	ff 45 08             	incl   0x8(%ebp)
  800e4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e53:	74 17                	je     800e6c <strncmp+0x2b>
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	84 c0                	test   %al,%al
  800e5c:	74 0e                	je     800e6c <strncmp+0x2b>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 10                	mov    (%eax),%dl
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	38 c2                	cmp    %al,%dl
  800e6a:	74 da                	je     800e46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e70:	75 07                	jne    800e79 <strncmp+0x38>
		return 0;
  800e72:	b8 00 00 00 00       	mov    $0x0,%eax
  800e77:	eb 14                	jmp    800e8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	0f b6 d0             	movzbl %al,%edx
  800e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 c0             	movzbl %al,%eax
  800e89:	29 c2                	sub    %eax,%edx
  800e8b:	89 d0                	mov    %edx,%eax
}
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    

00800e8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	83 ec 04             	sub    $0x4,%esp
  800e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e9b:	eb 12                	jmp    800eaf <strchr+0x20>
		if (*s == c)
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ea5:	75 05                	jne    800eac <strchr+0x1d>
			return (char *) s;
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	eb 11                	jmp    800ebd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eac:	ff 45 08             	incl   0x8(%ebp)
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	84 c0                	test   %al,%al
  800eb6:	75 e5                	jne    800e9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebd:	c9                   	leave  
  800ebe:	c3                   	ret    

00800ebf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	83 ec 04             	sub    $0x4,%esp
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ecb:	eb 0d                	jmp    800eda <strfind+0x1b>
		if (*s == c)
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed5:	74 0e                	je     800ee5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ed7:	ff 45 08             	incl   0x8(%ebp)
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 ea                	jne    800ecd <strfind+0xe>
  800ee3:	eb 01                	jmp    800ee6 <strfind+0x27>
		if (*s == c)
			break;
  800ee5:	90                   	nop
	return (char *) s;
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    

00800eeb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ef7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efb:	76 63                	jbe    800f60 <memset+0x75>
		uint64 data_block = c;
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	99                   	cltd   
  800f01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f04:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f11:	c1 e0 08             	shl    $0x8,%eax
  800f14:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f17:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f20:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f24:	c1 e0 10             	shl    $0x10,%eax
  800f27:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f2a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f33:	89 c2                	mov    %eax,%edx
  800f35:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f3d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f40:	eb 18                	jmp    800f5a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f42:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f45:	8d 41 08             	lea    0x8(%ecx),%eax
  800f48:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f51:	89 01                	mov    %eax,(%ecx)
  800f53:	89 51 04             	mov    %edx,0x4(%ecx)
  800f56:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f5a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f5e:	77 e2                	ja     800f42 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	74 23                	je     800f89 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f69:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f6c:	eb 0e                	jmp    800f7c <memset+0x91>
			*p8++ = (uint8)c;
  800f6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f71:	8d 50 01             	lea    0x1(%eax),%edx
  800f74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f7a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f82:	89 55 10             	mov    %edx,0x10(%ebp)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	75 e5                	jne    800f6e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fa0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fa4:	76 24                	jbe    800fca <memcpy+0x3c>
		while(n >= 8){
  800fa6:	eb 1c                	jmp    800fc4 <memcpy+0x36>
			*d64 = *s64;
  800fa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fab:	8b 50 04             	mov    0x4(%eax),%edx
  800fae:	8b 00                	mov    (%eax),%eax
  800fb0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fb3:	89 01                	mov    %eax,(%ecx)
  800fb5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fb8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fbc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fc0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800fc4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fc8:	77 de                	ja     800fa8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	74 31                	je     801001 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fdc:	eb 16                	jmp    800ff4 <memcpy+0x66>
			*d8++ = *s8++;
  800fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe1:	8d 50 01             	lea    0x1(%eax),%edx
  800fe4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fed:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ff0:	8a 12                	mov    (%edx),%dl
  800ff2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	75 dd                	jne    800fde <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80101e:	73 50                	jae    801070 <memmove+0x6a>
  801020:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801023:	8b 45 10             	mov    0x10(%ebp),%eax
  801026:	01 d0                	add    %edx,%eax
  801028:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80102b:	76 43                	jbe    801070 <memmove+0x6a>
		s += n;
  80102d:	8b 45 10             	mov    0x10(%ebp),%eax
  801030:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801033:	8b 45 10             	mov    0x10(%ebp),%eax
  801036:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801039:	eb 10                	jmp    80104b <memmove+0x45>
			*--d = *--s;
  80103b:	ff 4d f8             	decl   -0x8(%ebp)
  80103e:	ff 4d fc             	decl   -0x4(%ebp)
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	8a 10                	mov    (%eax),%dl
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80104b:	8b 45 10             	mov    0x10(%ebp),%eax
  80104e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801051:	89 55 10             	mov    %edx,0x10(%ebp)
  801054:	85 c0                	test   %eax,%eax
  801056:	75 e3                	jne    80103b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801058:	eb 23                	jmp    80107d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801094:	eb 2a                	jmp    8010c0 <memcmp+0x3e>
		if (*s1 != *s2)
  801096:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801099:	8a 10                	mov    (%eax),%dl
  80109b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	38 c2                	cmp    %al,%dl
  8010a2:	74 16                	je     8010ba <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	0f b6 d0             	movzbl %al,%edx
  8010ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	0f b6 c0             	movzbl %al,%eax
  8010b4:	29 c2                	sub    %eax,%edx
  8010b6:	89 d0                	mov    %edx,%eax
  8010b8:	eb 18                	jmp    8010d2 <memcmp+0x50>
		s1++, s2++;
  8010ba:	ff 45 fc             	incl   -0x4(%ebp)
  8010bd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	75 c9                	jne    801096 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010e5:	eb 15                	jmp    8010fc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	0f b6 d0             	movzbl %al,%edx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	0f b6 c0             	movzbl %al,%eax
  8010f5:	39 c2                	cmp    %eax,%edx
  8010f7:	74 0d                	je     801106 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010f9:	ff 45 08             	incl   0x8(%ebp)
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801102:	72 e3                	jb     8010e7 <memfind+0x13>
  801104:	eb 01                	jmp    801107 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801106:	90                   	nop
	return (void *) s;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801112:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801119:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801120:	eb 03                	jmp    801125 <strtol+0x19>
		s++;
  801122:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 20                	cmp    $0x20,%al
  80112c:	74 f4                	je     801122 <strtol+0x16>
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	3c 09                	cmp    $0x9,%al
  801135:	74 eb                	je     801122 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	3c 2b                	cmp    $0x2b,%al
  80113e:	75 05                	jne    801145 <strtol+0x39>
		s++;
  801140:	ff 45 08             	incl   0x8(%ebp)
  801143:	eb 13                	jmp    801158 <strtol+0x4c>
	else if (*s == '-')
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	3c 2d                	cmp    $0x2d,%al
  80114c:	75 0a                	jne    801158 <strtol+0x4c>
		s++, neg = 1;
  80114e:	ff 45 08             	incl   0x8(%ebp)
  801151:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	74 06                	je     801164 <strtol+0x58>
  80115e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801162:	75 20                	jne    801184 <strtol+0x78>
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 30                	cmp    $0x30,%al
  80116b:	75 17                	jne    801184 <strtol+0x78>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	40                   	inc    %eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 78                	cmp    $0x78,%al
  801175:	75 0d                	jne    801184 <strtol+0x78>
		s += 2, base = 16;
  801177:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80117b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801182:	eb 28                	jmp    8011ac <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801184:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801188:	75 15                	jne    80119f <strtol+0x93>
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 30                	cmp    $0x30,%al
  801191:	75 0c                	jne    80119f <strtol+0x93>
		s++, base = 8;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80119d:	eb 0d                	jmp    8011ac <strtol+0xa0>
	else if (base == 0)
  80119f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a3:	75 07                	jne    8011ac <strtol+0xa0>
		base = 10;
  8011a5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3c 2f                	cmp    $0x2f,%al
  8011b3:	7e 19                	jle    8011ce <strtol+0xc2>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 39                	cmp    $0x39,%al
  8011bc:	7f 10                	jg     8011ce <strtol+0xc2>
			dig = *s - '0';
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	0f be c0             	movsbl %al,%eax
  8011c6:	83 e8 30             	sub    $0x30,%eax
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	eb 42                	jmp    801210 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 60                	cmp    $0x60,%al
  8011d5:	7e 19                	jle    8011f0 <strtol+0xe4>
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	3c 7a                	cmp    $0x7a,%al
  8011de:	7f 10                	jg     8011f0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	0f be c0             	movsbl %al,%eax
  8011e8:	83 e8 57             	sub    $0x57,%eax
  8011eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ee:	eb 20                	jmp    801210 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	3c 40                	cmp    $0x40,%al
  8011f7:	7e 39                	jle    801232 <strtol+0x126>
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 5a                	cmp    $0x5a,%al
  801200:	7f 30                	jg     801232 <strtol+0x126>
			dig = *s - 'A' + 10;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	0f be c0             	movsbl %al,%eax
  80120a:	83 e8 37             	sub    $0x37,%eax
  80120d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801213:	3b 45 10             	cmp    0x10(%ebp),%eax
  801216:	7d 19                	jge    801231 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801218:	ff 45 08             	incl   0x8(%ebp)
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801222:	89 c2                	mov    %eax,%edx
  801224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801227:	01 d0                	add    %edx,%eax
  801229:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80122c:	e9 7b ff ff ff       	jmp    8011ac <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801231:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801232:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801236:	74 08                	je     801240 <strtol+0x134>
		*endptr = (char *) s;
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	8b 55 08             	mov    0x8(%ebp),%edx
  80123e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801240:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801244:	74 07                	je     80124d <strtol+0x141>
  801246:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801249:	f7 d8                	neg    %eax
  80124b:	eb 03                	jmp    801250 <strtol+0x144>
  80124d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <ltostr>:

void
ltostr(long value, char *str)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80125f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801266:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126a:	79 13                	jns    80127f <ltostr+0x2d>
	{
		neg = 1;
  80126c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801279:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80127c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801287:	99                   	cltd   
  801288:	f7 f9                	idiv   %ecx
  80128a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80128d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801290:	8d 50 01             	lea    0x1(%eax),%edx
  801293:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801296:	89 c2                	mov    %eax,%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a0:	83 c2 30             	add    $0x30,%edx
  8012a3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012ad:	f7 e9                	imul   %ecx
  8012af:	c1 fa 02             	sar    $0x2,%edx
  8012b2:	89 c8                	mov    %ecx,%eax
  8012b4:	c1 f8 1f             	sar    $0x1f,%eax
  8012b7:	29 c2                	sub    %eax,%edx
  8012b9:	89 d0                	mov    %edx,%eax
  8012bb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c2:	75 bb                	jne    80127f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ce:	48                   	dec    %eax
  8012cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012d6:	74 3d                	je     801315 <ltostr+0xc3>
		start = 1 ;
  8012d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012df:	eb 34                	jmp    801315 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	01 d0                	add    %edx,%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	01 c2                	add    %eax,%edx
  8012f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 c8                	add    %ecx,%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801302:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80130d:	88 02                	mov    %al,(%edx)
		start++ ;
  80130f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801312:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801318:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80131b:	7c c4                	jl     8012e1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80131d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	01 d0                	add    %edx,%eax
  801325:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801328:	90                   	nop
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801331:	ff 75 08             	pushl  0x8(%ebp)
  801334:	e8 c4 f9 ff ff       	call   800cfd <strlen>
  801339:	83 c4 04             	add    $0x4,%esp
  80133c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80133f:	ff 75 0c             	pushl  0xc(%ebp)
  801342:	e8 b6 f9 ff ff       	call   800cfd <strlen>
  801347:	83 c4 04             	add    $0x4,%esp
  80134a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80134d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801354:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135b:	eb 17                	jmp    801374 <strcconcat+0x49>
		final[s] = str1[s] ;
  80135d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	01 c2                	add    %eax,%edx
  801365:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	01 c8                	add    %ecx,%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801371:	ff 45 fc             	incl   -0x4(%ebp)
  801374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801377:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80137a:	7c e1                	jl     80135d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80137c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801383:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80138a:	eb 1f                	jmp    8013ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80138c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138f:	8d 50 01             	lea    0x1(%eax),%edx
  801392:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801395:	89 c2                	mov    %eax,%edx
  801397:	8b 45 10             	mov    0x10(%ebp),%eax
  80139a:	01 c2                	add    %eax,%edx
  80139c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 c8                	add    %ecx,%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013a8:	ff 45 f8             	incl   -0x8(%ebp)
  8013ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b1:	7c d9                	jl     80138c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8013be:	90                   	nop
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d0:	8b 00                	mov    (%eax),%eax
  8013d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	01 d0                	add    %edx,%eax
  8013de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013e4:	eb 0c                	jmp    8013f2 <strsplit+0x31>
			*string++ = 0;
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8d 50 01             	lea    0x1(%eax),%edx
  8013ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	84 c0                	test   %al,%al
  8013f9:	74 18                	je     801413 <strsplit+0x52>
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	50                   	push   %eax
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	e8 83 fa ff ff       	call   800e8f <strchr>
  80140c:	83 c4 08             	add    $0x8,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 d3                	jne    8013e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	84 c0                	test   %al,%al
  80141a:	74 5a                	je     801476 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	83 f8 0f             	cmp    $0xf,%eax
  801424:	75 07                	jne    80142d <strsplit+0x6c>
		{
			return 0;
  801426:	b8 00 00 00 00       	mov    $0x0,%eax
  80142b:	eb 66                	jmp    801493 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80142d:	8b 45 14             	mov    0x14(%ebp),%eax
  801430:	8b 00                	mov    (%eax),%eax
  801432:	8d 48 01             	lea    0x1(%eax),%ecx
  801435:	8b 55 14             	mov    0x14(%ebp),%edx
  801438:	89 0a                	mov    %ecx,(%edx)
  80143a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801441:	8b 45 10             	mov    0x10(%ebp),%eax
  801444:	01 c2                	add    %eax,%edx
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80144b:	eb 03                	jmp    801450 <strsplit+0x8f>
			string++;
  80144d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	84 c0                	test   %al,%al
  801457:	74 8b                	je     8013e4 <strsplit+0x23>
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	0f be c0             	movsbl %al,%eax
  801461:	50                   	push   %eax
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	e8 25 fa ff ff       	call   800e8f <strchr>
  80146a:	83 c4 08             	add    $0x8,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	74 dc                	je     80144d <strsplit+0x8c>
			string++;
	}
  801471:	e9 6e ff ff ff       	jmp    8013e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801476:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801477:	8b 45 14             	mov    0x14(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 d0                	add    %edx,%eax
  801488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80148e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a8:	eb 4a                	jmp    8014f4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	01 c2                	add    %eax,%edx
  8014b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	01 c8                	add    %ecx,%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	3c 40                	cmp    $0x40,%al
  8014ca:	7e 25                	jle    8014f1 <str2lower+0x5c>
  8014cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d2:	01 d0                	add    %edx,%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 5a                	cmp    $0x5a,%al
  8014d8:	7f 17                	jg     8014f1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	01 d0                	add    %edx,%eax
  8014e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e8:	01 ca                	add    %ecx,%edx
  8014ea:	8a 12                	mov    (%edx),%dl
  8014ec:	83 c2 20             	add    $0x20,%edx
  8014ef:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014f1:	ff 45 fc             	incl   -0x4(%ebp)
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	e8 01 f8 ff ff       	call   800cfd <strlen>
  8014fc:	83 c4 04             	add    $0x4,%esp
  8014ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801502:	7f a6                	jg     8014aa <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801504:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80150f:	a1 08 40 80 00       	mov    0x804008,%eax
  801514:	85 c0                	test   %eax,%eax
  801516:	74 42                	je     80155a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801518:	83 ec 08             	sub    $0x8,%esp
  80151b:	68 00 00 00 82       	push   $0x82000000
  801520:	68 00 00 00 80       	push   $0x80000000
  801525:	e8 00 08 00 00       	call   801d2a <initialize_dynamic_allocator>
  80152a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80152d:	e8 e7 05 00 00       	call   801b19 <sys_get_uheap_strategy>
  801532:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801537:	a1 40 40 80 00       	mov    0x804040,%eax
  80153c:	05 00 10 00 00       	add    $0x1000,%eax
  801541:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801546:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80154b:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801550:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801557:	00 00 00 
	}
}
  80155a:	90                   	nop
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	68 06 04 00 00       	push   $0x406
  801579:	50                   	push   %eax
  80157a:	e8 e4 01 00 00       	call   801763 <__sys_allocate_page>
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801589:	79 14                	jns    80159f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	68 fc 30 80 00       	push   $0x8030fc
  801593:	6a 1f                	push   $0x1f
  801595:	68 38 31 80 00       	push   $0x803138
  80159a:	e8 ae 11 00 00       	call   80274d <_panic>
	return 0;
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ba:	83 ec 0c             	sub    $0xc,%esp
  8015bd:	50                   	push   %eax
  8015be:	e8 e7 01 00 00       	call   8017aa <__sys_unmap_frame>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015cd:	79 14                	jns    8015e3 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	68 44 31 80 00       	push   $0x803144
  8015d7:	6a 2a                	push   $0x2a
  8015d9:	68 38 31 80 00       	push   $0x803138
  8015de:	e8 6a 11 00 00       	call   80274d <_panic>
}
  8015e3:	90                   	nop
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015ec:	e8 18 ff ff ff       	call   801509 <uheap_init>
	if (size == 0) return NULL ;
  8015f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015f5:	75 07                	jne    8015fe <malloc+0x18>
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fc:	eb 14                	jmp    801612 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 84 31 80 00       	push   $0x803184
  801606:	6a 3e                	push   $0x3e
  801608:	68 38 31 80 00       	push   $0x803138
  80160d:	e8 3b 11 00 00       	call   80274d <_panic>
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80161a:	83 ec 04             	sub    $0x4,%esp
  80161d:	68 ac 31 80 00       	push   $0x8031ac
  801622:	6a 49                	push   $0x49
  801624:	68 38 31 80 00       	push   $0x803138
  801629:	e8 1f 11 00 00       	call   80274d <_panic>

0080162e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 18             	sub    $0x18,%esp
  801634:	8b 45 10             	mov    0x10(%ebp),%eax
  801637:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80163a:	e8 ca fe ff ff       	call   801509 <uheap_init>
	if (size == 0) return NULL ;
  80163f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801643:	75 07                	jne    80164c <smalloc+0x1e>
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	eb 14                	jmp    801660 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	68 d0 31 80 00       	push   $0x8031d0
  801654:	6a 5a                	push   $0x5a
  801656:	68 38 31 80 00       	push   $0x803138
  80165b:	e8 ed 10 00 00       	call   80274d <_panic>
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801668:	e8 9c fe ff ff       	call   801509 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	68 f8 31 80 00       	push   $0x8031f8
  801675:	6a 6a                	push   $0x6a
  801677:	68 38 31 80 00       	push   $0x803138
  80167c:	e8 cc 10 00 00       	call   80274d <_panic>

00801681 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801687:	e8 7d fe ff ff       	call   801509 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	68 1c 32 80 00       	push   $0x80321c
  801694:	68 88 00 00 00       	push   $0x88
  801699:	68 38 31 80 00       	push   $0x803138
  80169e:	e8 aa 10 00 00       	call   80274d <_panic>

008016a3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	68 44 32 80 00       	push   $0x803244
  8016b1:	68 9b 00 00 00       	push   $0x9b
  8016b6:	68 38 31 80 00       	push   $0x803138
  8016bb:	e8 8d 10 00 00       	call   80274d <_panic>

008016c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	57                   	push   %edi
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
  8016c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016db:	cd 30                	int    $0x30
  8016dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8016e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	5b                   	pop    %ebx
  8016e7:	5e                   	pop    %esi
  8016e8:	5f                   	pop    %edi
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016fa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	6a 00                	push   $0x0
  801703:	51                   	push   %ecx
  801704:	52                   	push   %edx
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	50                   	push   %eax
  801709:	6a 00                	push   $0x0
  80170b:	e8 b0 ff ff ff       	call   8016c0 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	90                   	nop
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_cgetc>:

int
sys_cgetc(void)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 02                	push   $0x2
  801725:	e8 96 ff ff ff       	call   8016c0 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 03                	push   $0x3
  80173e:	e8 7d ff ff ff       	call   8016c0 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	90                   	nop
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 04                	push   $0x4
  801758:	e8 63 ff ff ff       	call   8016c0 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	90                   	nop
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	6a 08                	push   $0x8
  801776:	e8 45 ff ff ff       	call   8016c0 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801785:	8b 75 18             	mov    0x18(%ebp),%esi
  801788:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	56                   	push   %esi
  801795:	53                   	push   %ebx
  801796:	51                   	push   %ecx
  801797:	52                   	push   %edx
  801798:	50                   	push   %eax
  801799:	6a 09                	push   $0x9
  80179b:	e8 20 ff ff ff       	call   8016c0 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	ff 75 08             	pushl  0x8(%ebp)
  8017b8:	6a 0a                	push   $0xa
  8017ba:	e8 01 ff ff ff       	call   8016c0 <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 0b                	push   $0xb
  8017d5:	e8 e6 fe ff ff       	call   8016c0 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 0c                	push   $0xc
  8017ee:	e8 cd fe ff ff       	call   8016c0 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 0d                	push   $0xd
  801807:	e8 b4 fe ff ff       	call   8016c0 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 0e                	push   $0xe
  801820:	e8 9b fe ff ff       	call   8016c0 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 0f                	push   $0xf
  801839:	e8 82 fe ff ff       	call   8016c0 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	ff 75 08             	pushl  0x8(%ebp)
  801851:	6a 10                	push   $0x10
  801853:	e8 68 fe ff ff       	call   8016c0 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 11                	push   $0x11
  80186c:	e8 4f fe ff ff       	call   8016c0 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_cputc>:

void
sys_cputc(const char c)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801883:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	50                   	push   %eax
  801890:	6a 01                	push   $0x1
  801892:	e8 29 fe ff ff       	call   8016c0 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	90                   	nop
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 14                	push   $0x14
  8018ac:	e8 0f fe ff ff       	call   8016c0 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	90                   	nop
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	51                   	push   %ecx
  8018d0:	52                   	push   %edx
  8018d1:	ff 75 0c             	pushl  0xc(%ebp)
  8018d4:	50                   	push   %eax
  8018d5:	6a 15                	push   $0x15
  8018d7:	e8 e4 fd ff ff       	call   8016c0 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	52                   	push   %edx
  8018f1:	50                   	push   %eax
  8018f2:	6a 16                	push   $0x16
  8018f4:	e8 c7 fd ff ff       	call   8016c0 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801901:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	51                   	push   %ecx
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 17                	push   $0x17
  801913:	e8 a8 fd ff ff       	call   8016c0 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801920:	8b 55 0c             	mov    0xc(%ebp),%edx
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	52                   	push   %edx
  80192d:	50                   	push   %eax
  80192e:	6a 18                	push   $0x18
  801930:	e8 8b fd ff ff       	call   8016c0 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	ff 75 14             	pushl  0x14(%ebp)
  801945:	ff 75 10             	pushl  0x10(%ebp)
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	50                   	push   %eax
  80194c:	6a 19                	push   $0x19
  80194e:	e8 6d fd ff ff       	call   8016c0 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	50                   	push   %eax
  801967:	6a 1a                	push   $0x1a
  801969:	e8 52 fd ff ff       	call   8016c0 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	50                   	push   %eax
  801983:	6a 1b                	push   $0x1b
  801985:	e8 36 fd ff ff       	call   8016c0 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 05                	push   $0x5
  80199e:	e8 1d fd ff ff       	call   8016c0 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 06                	push   $0x6
  8019b7:	e8 04 fd ff ff       	call   8016c0 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 07                	push   $0x7
  8019d0:	e8 eb fc ff ff       	call   8016c0 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_exit_env>:


void sys_exit_env(void)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 1c                	push   $0x1c
  8019e9:	e8 d2 fc ff ff       	call   8016c0 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	90                   	nop
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019fd:	8d 50 04             	lea    0x4(%eax),%edx
  801a00:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 1d                	push   $0x1d
  801a0d:	e8 ae fc ff ff       	call   8016c0 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
	return result;
  801a15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a1e:	89 01                	mov    %eax,(%ecx)
  801a20:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	c9                   	leave  
  801a27:	c2 04 00             	ret    $0x4

00801a2a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 10             	pushl  0x10(%ebp)
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 13                	push   $0x13
  801a3c:	e8 7f fc ff ff       	call   8016c0 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return ;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 1e                	push   $0x1e
  801a56:	e8 65 fc ff ff       	call   8016c0 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a6c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	50                   	push   %eax
  801a79:	6a 1f                	push   $0x1f
  801a7b:	e8 40 fc ff ff       	call   8016c0 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
	return ;
  801a83:	90                   	nop
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <rsttst>:
void rsttst()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 21                	push   $0x21
  801a95:	e8 26 fc ff ff       	call   8016c0 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9d:	90                   	nop
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801aac:	8b 55 18             	mov    0x18(%ebp),%edx
  801aaf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab3:	52                   	push   %edx
  801ab4:	50                   	push   %eax
  801ab5:	ff 75 10             	pushl  0x10(%ebp)
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 20                	push   $0x20
  801ac0:	e8 fb fb ff ff       	call   8016c0 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <chktst>:
void chktst(uint32 n)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	6a 22                	push   $0x22
  801adb:	e8 e0 fb ff ff       	call   8016c0 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae3:	90                   	nop
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <inctst>:

void inctst()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 23                	push   $0x23
  801af5:	e8 c6 fb ff ff       	call   8016c0 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
	return ;
  801afd:	90                   	nop
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <gettst>:
uint32 gettst()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 24                	push   $0x24
  801b0f:	e8 ac fb ff ff       	call   8016c0 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 25                	push   $0x25
  801b28:	e8 93 fb ff ff       	call   8016c0 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
  801b30:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801b35:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	ff 75 08             	pushl  0x8(%ebp)
  801b52:	6a 26                	push   $0x26
  801b54:	e8 67 fb ff ff       	call   8016c0 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5c:	90                   	nop
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	53                   	push   %ebx
  801b72:	51                   	push   %ecx
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	6a 27                	push   $0x27
  801b77:	e8 44 fb ff ff       	call   8016c0 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 28                	push   $0x28
  801b97:	e8 24 fb ff ff       	call   8016c0 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ba4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	51                   	push   %ecx
  801bb0:	ff 75 10             	pushl  0x10(%ebp)
  801bb3:	52                   	push   %edx
  801bb4:	50                   	push   %eax
  801bb5:	6a 29                	push   $0x29
  801bb7:	e8 04 fb ff ff       	call   8016c0 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 10             	pushl  0x10(%ebp)
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	6a 12                	push   $0x12
  801bd3:	e8 e8 fa ff ff       	call   8016c0 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdb:	90                   	nop
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	52                   	push   %edx
  801bee:	50                   	push   %eax
  801bef:	6a 2a                	push   $0x2a
  801bf1:	e8 ca fa ff ff       	call   8016c0 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
	return;
  801bf9:	90                   	nop
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 2b                	push   $0x2b
  801c0b:	e8 b0 fa ff ff       	call   8016c0 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	ff 75 08             	pushl  0x8(%ebp)
  801c24:	6a 2d                	push   $0x2d
  801c26:	e8 95 fa ff ff       	call   8016c0 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	6a 2c                	push   $0x2c
  801c42:	e8 79 fa ff ff       	call   8016c0 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4a:	90                   	nop
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c53:	83 ec 04             	sub    $0x4,%esp
  801c56:	68 68 32 80 00       	push   $0x803268
  801c5b:	68 25 01 00 00       	push   $0x125
  801c60:	68 9b 32 80 00       	push   $0x80329b
  801c65:	e8 e3 0a 00 00       	call   80274d <_panic>

00801c6a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801c70:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801c77:	72 09                	jb     801c82 <to_page_va+0x18>
  801c79:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801c80:	72 14                	jb     801c96 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801c82:	83 ec 04             	sub    $0x4,%esp
  801c85:	68 ac 32 80 00       	push   $0x8032ac
  801c8a:	6a 15                	push   $0x15
  801c8c:	68 d7 32 80 00       	push   $0x8032d7
  801c91:	e8 b7 0a 00 00       	call   80274d <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	ba 60 40 80 00       	mov    $0x804060,%edx
  801c9e:	29 d0                	sub    %edx,%eax
  801ca0:	c1 f8 02             	sar    $0x2,%eax
  801ca3:	89 c2                	mov    %eax,%edx
  801ca5:	89 d0                	mov    %edx,%eax
  801ca7:	c1 e0 02             	shl    $0x2,%eax
  801caa:	01 d0                	add    %edx,%eax
  801cac:	c1 e0 02             	shl    $0x2,%eax
  801caf:	01 d0                	add    %edx,%eax
  801cb1:	c1 e0 02             	shl    $0x2,%eax
  801cb4:	01 d0                	add    %edx,%eax
  801cb6:	89 c1                	mov    %eax,%ecx
  801cb8:	c1 e1 08             	shl    $0x8,%ecx
  801cbb:	01 c8                	add    %ecx,%eax
  801cbd:	89 c1                	mov    %eax,%ecx
  801cbf:	c1 e1 10             	shl    $0x10,%ecx
  801cc2:	01 c8                	add    %ecx,%eax
  801cc4:	01 c0                	add    %eax,%eax
  801cc6:	01 d0                	add    %edx,%eax
  801cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	c1 e0 0c             	shl    $0xc,%eax
  801cd1:	89 c2                	mov    %eax,%edx
  801cd3:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801cd8:	01 d0                	add    %edx,%eax
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801ce2:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  801cea:	29 c2                	sub    %eax,%edx
  801cec:	89 d0                	mov    %edx,%eax
  801cee:	c1 e8 0c             	shr    $0xc,%eax
  801cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf8:	78 09                	js     801d03 <to_page_info+0x27>
  801cfa:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801d01:	7e 14                	jle    801d17 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	68 f0 32 80 00       	push   $0x8032f0
  801d0b:	6a 22                	push   $0x22
  801d0d:	68 d7 32 80 00       	push   $0x8032d7
  801d12:	e8 36 0a 00 00       	call   80274d <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1a:	89 d0                	mov    %edx,%eax
  801d1c:	01 c0                	add    %eax,%eax
  801d1e:	01 d0                	add    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	05 60 40 80 00       	add    $0x804060,%eax
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	05 00 00 00 02       	add    $0x2000000,%eax
  801d38:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d3b:	73 16                	jae    801d53 <initialize_dynamic_allocator+0x29>
  801d3d:	68 14 33 80 00       	push   $0x803314
  801d42:	68 3a 33 80 00       	push   $0x80333a
  801d47:	6a 34                	push   $0x34
  801d49:	68 d7 32 80 00       	push   $0x8032d7
  801d4e:	e8 fa 09 00 00       	call   80274d <_panic>
		is_initialized = 1;
  801d53:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801d5a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801d6d:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801d74:	00 00 00 
  801d77:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801d7e:	00 00 00 
  801d81:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801d88:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	2b 45 08             	sub    0x8(%ebp),%eax
  801d91:	c1 e8 0c             	shr    $0xc,%eax
  801d94:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801d97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d9e:	e9 c8 00 00 00       	jmp    801e6b <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801da3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da6:	89 d0                	mov    %edx,%eax
  801da8:	01 c0                	add    %eax,%eax
  801daa:	01 d0                	add    %edx,%eax
  801dac:	c1 e0 02             	shl    $0x2,%eax
  801daf:	05 68 40 80 00       	add    $0x804068,%eax
  801db4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbc:	89 d0                	mov    %edx,%eax
  801dbe:	01 c0                	add    %eax,%eax
  801dc0:	01 d0                	add    %edx,%eax
  801dc2:	c1 e0 02             	shl    $0x2,%eax
  801dc5:	05 6a 40 80 00       	add    $0x80406a,%eax
  801dca:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801dcf:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801dd5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801dd8:	89 c8                	mov    %ecx,%eax
  801dda:	01 c0                	add    %eax,%eax
  801ddc:	01 c8                	add    %ecx,%eax
  801dde:	c1 e0 02             	shl    $0x2,%eax
  801de1:	05 64 40 80 00       	add    $0x804064,%eax
  801de6:	89 10                	mov    %edx,(%eax)
  801de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801deb:	89 d0                	mov    %edx,%eax
  801ded:	01 c0                	add    %eax,%eax
  801def:	01 d0                	add    %edx,%eax
  801df1:	c1 e0 02             	shl    $0x2,%eax
  801df4:	05 64 40 80 00       	add    $0x804064,%eax
  801df9:	8b 00                	mov    (%eax),%eax
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	74 1b                	je     801e1a <initialize_dynamic_allocator+0xf0>
  801dff:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e08:	89 c8                	mov    %ecx,%eax
  801e0a:	01 c0                	add    %eax,%eax
  801e0c:	01 c8                	add    %ecx,%eax
  801e0e:	c1 e0 02             	shl    $0x2,%eax
  801e11:	05 60 40 80 00       	add    $0x804060,%eax
  801e16:	89 02                	mov    %eax,(%edx)
  801e18:	eb 16                	jmp    801e30 <initialize_dynamic_allocator+0x106>
  801e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1d:	89 d0                	mov    %edx,%eax
  801e1f:	01 c0                	add    %eax,%eax
  801e21:	01 d0                	add    %edx,%eax
  801e23:	c1 e0 02             	shl    $0x2,%eax
  801e26:	05 60 40 80 00       	add    $0x804060,%eax
  801e2b:	a3 48 40 80 00       	mov    %eax,0x804048
  801e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e33:	89 d0                	mov    %edx,%eax
  801e35:	01 c0                	add    %eax,%eax
  801e37:	01 d0                	add    %edx,%eax
  801e39:	c1 e0 02             	shl    $0x2,%eax
  801e3c:	05 60 40 80 00       	add    $0x804060,%eax
  801e41:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e49:	89 d0                	mov    %edx,%eax
  801e4b:	01 c0                	add    %eax,%eax
  801e4d:	01 d0                	add    %edx,%eax
  801e4f:	c1 e0 02             	shl    $0x2,%eax
  801e52:	05 60 40 80 00       	add    $0x804060,%eax
  801e57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e5d:	a1 54 40 80 00       	mov    0x804054,%eax
  801e62:	40                   	inc    %eax
  801e63:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801e68:	ff 45 f4             	incl   -0xc(%ebp)
  801e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e71:	0f 8c 2c ff ff ff    	jl     801da3 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801e77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801e7e:	eb 36                	jmp    801eb6 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e83:	c1 e0 04             	shl    $0x4,%eax
  801e86:	05 80 c0 81 00       	add    $0x81c080,%eax
  801e8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e94:	c1 e0 04             	shl    $0x4,%eax
  801e97:	05 84 c0 81 00       	add    $0x81c084,%eax
  801e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea5:	c1 e0 04             	shl    $0x4,%eax
  801ea8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801ead:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801eb3:	ff 45 f0             	incl   -0x10(%ebp)
  801eb6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801eba:	7e c4                	jle    801e80 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801ebc:	90                   	nop
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	50                   	push   %eax
  801ecc:	e8 0b fe ff ff       	call   801cdc <to_page_info>
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eda:	8b 40 08             	mov    0x8(%eax),%eax
  801edd:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801ee8:	83 ec 0c             	sub    $0xc,%esp
  801eeb:	ff 75 0c             	pushl  0xc(%ebp)
  801eee:	e8 77 fd ff ff       	call   801c6a <to_page_va>
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801ef9:	b8 00 10 00 00       	mov    $0x1000,%eax
  801efe:	ba 00 00 00 00       	mov    $0x0,%edx
  801f03:	f7 75 08             	divl   0x8(%ebp)
  801f06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	50                   	push   %eax
  801f10:	e8 48 f6 ff ff       	call   80155d <get_page>
  801f15:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f28:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801f2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f33:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801f3a:	eb 19                	jmp    801f55 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3f:	ba 01 00 00 00       	mov    $0x1,%edx
  801f44:	88 c1                	mov    %al,%cl
  801f46:	d3 e2                	shl    %cl,%edx
  801f48:	89 d0                	mov    %edx,%eax
  801f4a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f4d:	74 0e                	je     801f5d <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  801f4f:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801f52:	ff 45 f0             	incl   -0x10(%ebp)
  801f55:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  801f59:	7e e1                	jle    801f3c <split_page_to_blocks+0x5a>
  801f5b:	eb 01                	jmp    801f5e <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  801f5d:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  801f5e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f65:	e9 a7 00 00 00       	jmp    802011 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  801f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6d:	0f af 45 08          	imul   0x8(%ebp),%eax
  801f71:	89 c2                	mov    %eax,%edx
  801f73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f76:	01 d0                	add    %edx,%eax
  801f78:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  801f7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f7f:	75 14                	jne    801f95 <split_page_to_blocks+0xb3>
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	68 50 33 80 00       	push   $0x803350
  801f89:	6a 7c                	push   $0x7c
  801f8b:	68 d7 32 80 00       	push   $0x8032d7
  801f90:	e8 b8 07 00 00       	call   80274d <_panic>
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	c1 e0 04             	shl    $0x4,%eax
  801f9b:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fa0:	8b 10                	mov    (%eax),%edx
  801fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa5:	89 50 04             	mov    %edx,0x4(%eax)
  801fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fab:	8b 40 04             	mov    0x4(%eax),%eax
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	74 14                	je     801fc6 <split_page_to_blocks+0xe4>
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	c1 e0 04             	shl    $0x4,%eax
  801fb8:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fc2:	89 10                	mov    %edx,(%eax)
  801fc4:	eb 11                	jmp    801fd7 <split_page_to_blocks+0xf5>
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	c1 e0 04             	shl    $0x4,%eax
  801fcc:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  801fd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd5:	89 02                	mov    %eax,(%edx)
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	c1 e0 04             	shl    $0x4,%eax
  801fdd:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  801fe3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe6:	89 02                	mov    %eax,(%edx)
  801fe8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801feb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	c1 e0 04             	shl    $0x4,%eax
  801ff7:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801ffc:	8b 00                	mov    (%eax),%eax
  801ffe:	8d 50 01             	lea    0x1(%eax),%edx
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	c1 e0 04             	shl    $0x4,%eax
  802007:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80200c:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80200e:	ff 45 ec             	incl   -0x14(%ebp)
  802011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802014:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802017:	0f 82 4d ff ff ff    	jb     801f6a <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80201d:	90                   	nop
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802026:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80202d:	76 19                	jbe    802048 <alloc_block+0x28>
  80202f:	68 74 33 80 00       	push   $0x803374
  802034:	68 3a 33 80 00       	push   $0x80333a
  802039:	68 8a 00 00 00       	push   $0x8a
  80203e:	68 d7 32 80 00       	push   $0x8032d7
  802043:	e8 05 07 00 00       	call   80274d <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802048:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80204f:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802056:	eb 19                	jmp    802071 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205b:	ba 01 00 00 00       	mov    $0x1,%edx
  802060:	88 c1                	mov    %al,%cl
  802062:	d3 e2                	shl    %cl,%edx
  802064:	89 d0                	mov    %edx,%eax
  802066:	3b 45 08             	cmp    0x8(%ebp),%eax
  802069:	73 0e                	jae    802079 <alloc_block+0x59>
		idx++;
  80206b:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80206e:	ff 45 f0             	incl   -0x10(%ebp)
  802071:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802075:	7e e1                	jle    802058 <alloc_block+0x38>
  802077:	eb 01                	jmp    80207a <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802079:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	c1 e0 04             	shl    $0x4,%eax
  802080:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802085:	8b 00                	mov    (%eax),%eax
  802087:	85 c0                	test   %eax,%eax
  802089:	0f 84 df 00 00 00    	je     80216e <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	c1 e0 04             	shl    $0x4,%eax
  802095:	05 80 c0 81 00       	add    $0x81c080,%eax
  80209a:	8b 00                	mov    (%eax),%eax
  80209c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80209f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020a3:	75 17                	jne    8020bc <alloc_block+0x9c>
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 95 33 80 00       	push   $0x803395
  8020ad:	68 9e 00 00 00       	push   $0x9e
  8020b2:	68 d7 32 80 00       	push   $0x8032d7
  8020b7:	e8 91 06 00 00       	call   80274d <_panic>
  8020bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bf:	8b 00                	mov    (%eax),%eax
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	74 10                	je     8020d5 <alloc_block+0xb5>
  8020c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c8:	8b 00                	mov    (%eax),%eax
  8020ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020cd:	8b 52 04             	mov    0x4(%edx),%edx
  8020d0:	89 50 04             	mov    %edx,0x4(%eax)
  8020d3:	eb 14                	jmp    8020e9 <alloc_block+0xc9>
  8020d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d8:	8b 40 04             	mov    0x4(%eax),%eax
  8020db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020de:	c1 e2 04             	shl    $0x4,%edx
  8020e1:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8020e7:	89 02                	mov    %eax,(%edx)
  8020e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ec:	8b 40 04             	mov    0x4(%eax),%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	74 0f                	je     802102 <alloc_block+0xe2>
  8020f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f6:	8b 40 04             	mov    0x4(%eax),%eax
  8020f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020fc:	8b 12                	mov    (%edx),%edx
  8020fe:	89 10                	mov    %edx,(%eax)
  802100:	eb 13                	jmp    802115 <alloc_block+0xf5>
  802102:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210a:	c1 e2 04             	shl    $0x4,%edx
  80210d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802113:	89 02                	mov    %eax,(%edx)
  802115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802118:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80211e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802121:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	c1 e0 04             	shl    $0x4,%eax
  80212e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802133:	8b 00                	mov    (%eax),%eax
  802135:	8d 50 ff             	lea    -0x1(%eax),%edx
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	c1 e0 04             	shl    $0x4,%eax
  80213e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802143:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802148:	83 ec 0c             	sub    $0xc,%esp
  80214b:	50                   	push   %eax
  80214c:	e8 8b fb ff ff       	call   801cdc <to_page_info>
  802151:	83 c4 10             	add    $0x10,%esp
  802154:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80215e:	48                   	dec    %eax
  80215f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802162:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802169:	e9 bc 02 00 00       	jmp    80242a <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80216e:	a1 54 40 80 00       	mov    0x804054,%eax
  802173:	85 c0                	test   %eax,%eax
  802175:	0f 84 7d 02 00 00    	je     8023f8 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80217b:	a1 48 40 80 00       	mov    0x804048,%eax
  802180:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802183:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802187:	75 17                	jne    8021a0 <alloc_block+0x180>
  802189:	83 ec 04             	sub    $0x4,%esp
  80218c:	68 95 33 80 00       	push   $0x803395
  802191:	68 a9 00 00 00       	push   $0xa9
  802196:	68 d7 32 80 00       	push   $0x8032d7
  80219b:	e8 ad 05 00 00       	call   80274d <_panic>
  8021a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021a3:	8b 00                	mov    (%eax),%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 10                	je     8021b9 <alloc_block+0x199>
  8021a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ac:	8b 00                	mov    (%eax),%eax
  8021ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021b1:	8b 52 04             	mov    0x4(%edx),%edx
  8021b4:	89 50 04             	mov    %edx,0x4(%eax)
  8021b7:	eb 0b                	jmp    8021c4 <alloc_block+0x1a4>
  8021b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021bc:	8b 40 04             	mov    0x4(%eax),%eax
  8021bf:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021c7:	8b 40 04             	mov    0x4(%eax),%eax
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	74 0f                	je     8021dd <alloc_block+0x1bd>
  8021ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021d1:	8b 40 04             	mov    0x4(%eax),%eax
  8021d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021d7:	8b 12                	mov    (%edx),%edx
  8021d9:	89 10                	mov    %edx,(%eax)
  8021db:	eb 0a                	jmp    8021e7 <alloc_block+0x1c7>
  8021dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	a3 48 40 80 00       	mov    %eax,0x804048
  8021e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021fa:	a1 54 40 80 00       	mov    0x804054,%eax
  8021ff:	48                   	dec    %eax
  802200:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	83 c0 03             	add    $0x3,%eax
  80220b:	ba 01 00 00 00       	mov    $0x1,%edx
  802210:	88 c1                	mov    %al,%cl
  802212:	d3 e2                	shl    %cl,%edx
  802214:	89 d0                	mov    %edx,%eax
  802216:	83 ec 08             	sub    $0x8,%esp
  802219:	ff 75 e4             	pushl  -0x1c(%ebp)
  80221c:	50                   	push   %eax
  80221d:	e8 c0 fc ff ff       	call   801ee2 <split_page_to_blocks>
  802222:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	c1 e0 04             	shl    $0x4,%eax
  80222b:	05 80 c0 81 00       	add    $0x81c080,%eax
  802230:	8b 00                	mov    (%eax),%eax
  802232:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802235:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802239:	75 17                	jne    802252 <alloc_block+0x232>
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 95 33 80 00       	push   $0x803395
  802243:	68 b0 00 00 00       	push   $0xb0
  802248:	68 d7 32 80 00       	push   $0x8032d7
  80224d:	e8 fb 04 00 00       	call   80274d <_panic>
  802252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802255:	8b 00                	mov    (%eax),%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	74 10                	je     80226b <alloc_block+0x24b>
  80225b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802263:	8b 52 04             	mov    0x4(%edx),%edx
  802266:	89 50 04             	mov    %edx,0x4(%eax)
  802269:	eb 14                	jmp    80227f <alloc_block+0x25f>
  80226b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802274:	c1 e2 04             	shl    $0x4,%edx
  802277:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80227d:	89 02                	mov    %eax,(%edx)
  80227f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802282:	8b 40 04             	mov    0x4(%eax),%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	74 0f                	je     802298 <alloc_block+0x278>
  802289:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80228c:	8b 40 04             	mov    0x4(%eax),%eax
  80228f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802292:	8b 12                	mov    (%edx),%edx
  802294:	89 10                	mov    %edx,(%eax)
  802296:	eb 13                	jmp    8022ab <alloc_block+0x28b>
  802298:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80229b:	8b 00                	mov    (%eax),%eax
  80229d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a0:	c1 e2 04             	shl    $0x4,%edx
  8022a3:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8022a9:	89 02                	mov    %eax,(%edx)
  8022ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	c1 e0 04             	shl    $0x4,%eax
  8022c4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	c1 e0 04             	shl    $0x4,%eax
  8022d4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022d9:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8022db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022de:	83 ec 0c             	sub    $0xc,%esp
  8022e1:	50                   	push   %eax
  8022e2:	e8 f5 f9 ff ff       	call   801cdc <to_page_info>
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8022ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022f0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8022f4:	48                   	dec    %eax
  8022f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8022f8:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8022fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ff:	e9 26 01 00 00       	jmp    80242a <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802304:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	c1 e0 04             	shl    $0x4,%eax
  80230d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802312:	8b 00                	mov    (%eax),%eax
  802314:	85 c0                	test   %eax,%eax
  802316:	0f 84 dc 00 00 00    	je     8023f8 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	c1 e0 04             	shl    $0x4,%eax
  802322:	05 80 c0 81 00       	add    $0x81c080,%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80232c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802330:	75 17                	jne    802349 <alloc_block+0x329>
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	68 95 33 80 00       	push   $0x803395
  80233a:	68 be 00 00 00       	push   $0xbe
  80233f:	68 d7 32 80 00       	push   $0x8032d7
  802344:	e8 04 04 00 00       	call   80274d <_panic>
  802349:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80234c:	8b 00                	mov    (%eax),%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	74 10                	je     802362 <alloc_block+0x342>
  802352:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802355:	8b 00                	mov    (%eax),%eax
  802357:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80235a:	8b 52 04             	mov    0x4(%edx),%edx
  80235d:	89 50 04             	mov    %edx,0x4(%eax)
  802360:	eb 14                	jmp    802376 <alloc_block+0x356>
  802362:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236b:	c1 e2 04             	shl    $0x4,%edx
  80236e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802374:	89 02                	mov    %eax,(%edx)
  802376:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802379:	8b 40 04             	mov    0x4(%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	74 0f                	je     80238f <alloc_block+0x36f>
  802380:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802383:	8b 40 04             	mov    0x4(%eax),%eax
  802386:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802389:	8b 12                	mov    (%edx),%edx
  80238b:	89 10                	mov    %edx,(%eax)
  80238d:	eb 13                	jmp    8023a2 <alloc_block+0x382>
  80238f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802392:	8b 00                	mov    (%eax),%eax
  802394:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802397:	c1 e2 04             	shl    $0x4,%edx
  80239a:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023a0:	89 02                	mov    %eax,(%edx)
  8023a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	c1 e0 04             	shl    $0x4,%eax
  8023bb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	c1 e0 04             	shl    $0x4,%eax
  8023cb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023d0:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8023d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d5:	83 ec 0c             	sub    $0xc,%esp
  8023d8:	50                   	push   %eax
  8023d9:	e8 fe f8 ff ff       	call   801cdc <to_page_info>
  8023de:	83 c4 10             	add    $0x10,%esp
  8023e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8023e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8023eb:	48                   	dec    %eax
  8023ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023ef:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8023f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023f6:	eb 32                	jmp    80242a <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8023f8:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8023fc:	77 15                	ja     802413 <alloc_block+0x3f3>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	c1 e0 04             	shl    $0x4,%eax
  802404:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	0f 84 f1 fe ff ff    	je     802304 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	68 b3 33 80 00       	push   $0x8033b3
  80241b:	68 c8 00 00 00       	push   $0xc8
  802420:	68 d7 32 80 00       	push   $0x8032d7
  802425:	e8 23 03 00 00       	call   80274d <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802432:	8b 55 08             	mov    0x8(%ebp),%edx
  802435:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80243a:	39 c2                	cmp    %eax,%edx
  80243c:	72 0c                	jb     80244a <free_block+0x1e>
  80243e:	8b 55 08             	mov    0x8(%ebp),%edx
  802441:	a1 40 40 80 00       	mov    0x804040,%eax
  802446:	39 c2                	cmp    %eax,%edx
  802448:	72 19                	jb     802463 <free_block+0x37>
  80244a:	68 c4 33 80 00       	push   $0x8033c4
  80244f:	68 3a 33 80 00       	push   $0x80333a
  802454:	68 d7 00 00 00       	push   $0xd7
  802459:	68 d7 32 80 00       	push   $0x8032d7
  80245e:	e8 ea 02 00 00       	call   80274d <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	83 ec 0c             	sub    $0xc,%esp
  80246f:	50                   	push   %eax
  802470:	e8 67 f8 ff ff       	call   801cdc <to_page_info>
  802475:	83 c4 10             	add    $0x10,%esp
  802478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80247b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80247e:	8b 40 08             	mov    0x8(%eax),%eax
  802481:	0f b7 c0             	movzwl %ax,%eax
  802484:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802487:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80248e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802495:	eb 19                	jmp    8024b0 <free_block+0x84>
	    if ((1 << i) == blk_size)
  802497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249a:	ba 01 00 00 00       	mov    $0x1,%edx
  80249f:	88 c1                	mov    %al,%cl
  8024a1:	d3 e2                	shl    %cl,%edx
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8024a8:	74 0e                	je     8024b8 <free_block+0x8c>
	        break;
	    idx++;
  8024aa:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8024ad:	ff 45 f0             	incl   -0x10(%ebp)
  8024b0:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8024b4:	7e e1                	jle    802497 <free_block+0x6b>
  8024b6:	eb 01                	jmp    8024b9 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8024b8:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8024b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024bc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8024c0:	40                   	inc    %eax
  8024c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024c4:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8024c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024cc:	75 17                	jne    8024e5 <free_block+0xb9>
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	68 50 33 80 00       	push   $0x803350
  8024d6:	68 ee 00 00 00       	push   $0xee
  8024db:	68 d7 32 80 00       	push   $0x8032d7
  8024e0:	e8 68 02 00 00       	call   80274d <_panic>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	c1 e0 04             	shl    $0x4,%eax
  8024eb:	05 84 c0 81 00       	add    $0x81c084,%eax
  8024f0:	8b 10                	mov    (%eax),%edx
  8024f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f5:	89 50 04             	mov    %edx,0x4(%eax)
  8024f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	74 14                	je     802516 <free_block+0xea>
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	c1 e0 04             	shl    $0x4,%eax
  802508:	05 84 c0 81 00       	add    $0x81c084,%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802512:	89 10                	mov    %edx,(%eax)
  802514:	eb 11                	jmp    802527 <free_block+0xfb>
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	c1 e0 04             	shl    $0x4,%eax
  80251c:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802522:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802525:	89 02                	mov    %eax,(%edx)
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	c1 e0 04             	shl    $0x4,%eax
  80252d:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802533:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802536:	89 02                	mov    %eax,(%edx)
  802538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80253b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	c1 e0 04             	shl    $0x4,%eax
  802547:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	8d 50 01             	lea    0x1(%eax),%edx
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	c1 e0 04             	shl    $0x4,%eax
  802557:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80255c:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80255e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802563:	ba 00 00 00 00       	mov    $0x0,%edx
  802568:	f7 75 e0             	divl   -0x20(%ebp)
  80256b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80256e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802571:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802575:	0f b7 c0             	movzwl %ax,%eax
  802578:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80257b:	0f 85 70 01 00 00    	jne    8026f1 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	ff 75 e4             	pushl  -0x1c(%ebp)
  802587:	e8 de f6 ff ff       	call   801c6a <to_page_va>
  80258c:	83 c4 10             	add    $0x10,%esp
  80258f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802592:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802599:	e9 b7 00 00 00       	jmp    802655 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80259e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a4:	01 d0                	add    %edx,%eax
  8025a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8025a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8025ad:	75 17                	jne    8025c6 <free_block+0x19a>
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	68 95 33 80 00       	push   $0x803395
  8025b7:	68 f8 00 00 00       	push   $0xf8
  8025bc:	68 d7 32 80 00       	push   $0x8032d7
  8025c1:	e8 87 01 00 00       	call   80274d <_panic>
  8025c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 10                	je     8025df <free_block+0x1b3>
  8025cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8025d7:	8b 52 04             	mov    0x4(%edx),%edx
  8025da:	89 50 04             	mov    %edx,0x4(%eax)
  8025dd:	eb 14                	jmp    8025f3 <free_block+0x1c7>
  8025df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e8:	c1 e2 04             	shl    $0x4,%edx
  8025eb:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8025f1:	89 02                	mov    %eax,(%edx)
  8025f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	74 0f                	je     80260c <free_block+0x1e0>
  8025fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802606:	8b 12                	mov    (%edx),%edx
  802608:	89 10                	mov    %edx,(%eax)
  80260a:	eb 13                	jmp    80261f <free_block+0x1f3>
  80260c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802614:	c1 e2 04             	shl    $0x4,%edx
  802617:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80261d:	89 02                	mov    %eax,(%edx)
  80261f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80262b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	c1 e0 04             	shl    $0x4,%eax
  802638:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	c1 e0 04             	shl    $0x4,%eax
  802648:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80264d:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80264f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802652:	01 45 ec             	add    %eax,-0x14(%ebp)
  802655:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80265c:	0f 86 3c ff ff ff    	jbe    80259e <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802665:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80266b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802674:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802678:	75 17                	jne    802691 <free_block+0x265>
  80267a:	83 ec 04             	sub    $0x4,%esp
  80267d:	68 50 33 80 00       	push   $0x803350
  802682:	68 fe 00 00 00       	push   $0xfe
  802687:	68 d7 32 80 00       	push   $0x8032d7
  80268c:	e8 bc 00 00 00       	call   80274d <_panic>
  802691:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269a:	89 50 04             	mov    %edx,0x4(%eax)
  80269d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a0:	8b 40 04             	mov    0x4(%eax),%eax
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	74 0c                	je     8026b3 <free_block+0x287>
  8026a7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026af:	89 10                	mov    %edx,(%eax)
  8026b1:	eb 08                	jmp    8026bb <free_block+0x28f>
  8026b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b6:	a3 48 40 80 00       	mov    %eax,0x804048
  8026bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026be:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8026c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cc:	a1 54 40 80 00       	mov    0x804054,%eax
  8026d1:	40                   	inc    %eax
  8026d2:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8026d7:	83 ec 0c             	sub    $0xc,%esp
  8026da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026dd:	e8 88 f5 ff ff       	call   801c6a <to_page_va>
  8026e2:	83 c4 10             	add    $0x10,%esp
  8026e5:	83 ec 0c             	sub    $0xc,%esp
  8026e8:	50                   	push   %eax
  8026e9:	e8 b8 ee ff ff       	call   8015a6 <return_page>
  8026ee:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8026f1:	90                   	nop
  8026f2:	c9                   	leave  
  8026f3:	c3                   	ret    

008026f4 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8026fa:	83 ec 04             	sub    $0x4,%esp
  8026fd:	68 fc 33 80 00       	push   $0x8033fc
  802702:	68 11 01 00 00       	push   $0x111
  802707:	68 d7 32 80 00       	push   $0x8032d7
  80270c:	e8 3c 00 00 00       	call   80274d <_panic>

00802711 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
  802714:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80271d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  802721:	83 ec 0c             	sub    $0xc,%esp
  802724:	50                   	push   %eax
  802725:	e8 4d f1 ff ff       	call   801877 <sys_cputc>
  80272a:	83 c4 10             	add    $0x10,%esp
}
  80272d:	90                   	nop
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <getchar>:


int
getchar(void)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  802736:	e8 db ef ff ff       	call   801716 <sys_cgetc>
  80273b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    

00802743 <iscons>:

int iscons(int fdnum)
{
  802743:	55                   	push   %ebp
  802744:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  802746:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80274b:	5d                   	pop    %ebp
  80274c:	c3                   	ret    

0080274d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802753:	8d 45 10             	lea    0x10(%ebp),%eax
  802756:	83 c0 04             	add    $0x4,%eax
  802759:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80275c:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	74 16                	je     80277b <_panic+0x2e>
		cprintf("%s: ", argv0);
  802765:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  80276a:	83 ec 08             	sub    $0x8,%esp
  80276d:	50                   	push   %eax
  80276e:	68 20 34 80 00       	push   $0x803420
  802773:	e8 a4 dc ff ff       	call   80041c <cprintf>
  802778:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80277b:	a1 04 40 80 00       	mov    0x804004,%eax
  802780:	83 ec 0c             	sub    $0xc,%esp
  802783:	ff 75 0c             	pushl  0xc(%ebp)
  802786:	ff 75 08             	pushl  0x8(%ebp)
  802789:	50                   	push   %eax
  80278a:	68 28 34 80 00       	push   $0x803428
  80278f:	6a 74                	push   $0x74
  802791:	e8 b3 dc ff ff       	call   800449 <cprintf_colored>
  802796:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802799:	8b 45 10             	mov    0x10(%ebp),%eax
  80279c:	83 ec 08             	sub    $0x8,%esp
  80279f:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a2:	50                   	push   %eax
  8027a3:	e8 05 dc ff ff       	call   8003ad <vcprintf>
  8027a8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8027ab:	83 ec 08             	sub    $0x8,%esp
  8027ae:	6a 00                	push   $0x0
  8027b0:	68 50 34 80 00       	push   $0x803450
  8027b5:	e8 f3 db ff ff       	call   8003ad <vcprintf>
  8027ba:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8027bd:	e8 6c db ff ff       	call   80032e <exit>

	// should not return here
	while (1) ;
  8027c2:	eb fe                	jmp    8027c2 <_panic+0x75>

008027c4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8027ca:	a1 20 40 80 00       	mov    0x804020,%eax
  8027cf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8027d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d8:	39 c2                	cmp    %eax,%edx
  8027da:	74 14                	je     8027f0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8027dc:	83 ec 04             	sub    $0x4,%esp
  8027df:	68 54 34 80 00       	push   $0x803454
  8027e4:	6a 26                	push   $0x26
  8027e6:	68 a0 34 80 00       	push   $0x8034a0
  8027eb:	e8 5d ff ff ff       	call   80274d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8027f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8027f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8027fe:	e9 c5 00 00 00       	jmp    8028c8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	01 d0                	add    %edx,%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	75 08                	jne    802820 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802818:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80281b:	e9 a5 00 00 00       	jmp    8028c5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  802820:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802827:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80282e:	eb 69                	jmp    802899 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802830:	a1 20 40 80 00       	mov    0x804020,%eax
  802835:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80283b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80283e:	89 d0                	mov    %edx,%eax
  802840:	01 c0                	add    %eax,%eax
  802842:	01 d0                	add    %edx,%eax
  802844:	c1 e0 03             	shl    $0x3,%eax
  802847:	01 c8                	add    %ecx,%eax
  802849:	8a 40 04             	mov    0x4(%eax),%al
  80284c:	84 c0                	test   %al,%al
  80284e:	75 46                	jne    802896 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802850:	a1 20 40 80 00       	mov    0x804020,%eax
  802855:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80285b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80285e:	89 d0                	mov    %edx,%eax
  802860:	01 c0                	add    %eax,%eax
  802862:	01 d0                	add    %edx,%eax
  802864:	c1 e0 03             	shl    $0x3,%eax
  802867:	01 c8                	add    %ecx,%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80286e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802871:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802876:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	01 c8                	add    %ecx,%eax
  802887:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802889:	39 c2                	cmp    %eax,%edx
  80288b:	75 09                	jne    802896 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80288d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802894:	eb 15                	jmp    8028ab <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802896:	ff 45 e8             	incl   -0x18(%ebp)
  802899:	a1 20 40 80 00       	mov    0x804020,%eax
  80289e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8028a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a7:	39 c2                	cmp    %eax,%edx
  8028a9:	77 85                	ja     802830 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8028ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028af:	75 14                	jne    8028c5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 ac 34 80 00       	push   $0x8034ac
  8028b9:	6a 3a                	push   $0x3a
  8028bb:	68 a0 34 80 00       	push   $0x8034a0
  8028c0:	e8 88 fe ff ff       	call   80274d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8028c5:	ff 45 f0             	incl   -0x10(%ebp)
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028ce:	0f 8c 2f ff ff ff    	jl     802803 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8028d4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8028db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8028e2:	eb 26                	jmp    80290a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8028e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8028e9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8028ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028f2:	89 d0                	mov    %edx,%eax
  8028f4:	01 c0                	add    %eax,%eax
  8028f6:	01 d0                	add    %edx,%eax
  8028f8:	c1 e0 03             	shl    $0x3,%eax
  8028fb:	01 c8                	add    %ecx,%eax
  8028fd:	8a 40 04             	mov    0x4(%eax),%al
  802900:	3c 01                	cmp    $0x1,%al
  802902:	75 03                	jne    802907 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802904:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802907:	ff 45 e0             	incl   -0x20(%ebp)
  80290a:	a1 20 40 80 00       	mov    0x804020,%eax
  80290f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  802915:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802918:	39 c2                	cmp    %eax,%edx
  80291a:	77 c8                	ja     8028e4 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802922:	74 14                	je     802938 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	68 00 35 80 00       	push   $0x803500
  80292c:	6a 44                	push   $0x44
  80292e:	68 a0 34 80 00       	push   $0x8034a0
  802933:	e8 15 fe ff ff       	call   80274d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802938:	90                   	nop
  802939:	c9                   	leave  
  80293a:	c3                   	ret    
  80293b:	90                   	nop

0080293c <__udivdi3>:
  80293c:	55                   	push   %ebp
  80293d:	57                   	push   %edi
  80293e:	56                   	push   %esi
  80293f:	53                   	push   %ebx
  802940:	83 ec 1c             	sub    $0x1c,%esp
  802943:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802947:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80294b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80294f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802953:	89 ca                	mov    %ecx,%edx
  802955:	89 f8                	mov    %edi,%eax
  802957:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80295b:	85 f6                	test   %esi,%esi
  80295d:	75 2d                	jne    80298c <__udivdi3+0x50>
  80295f:	39 cf                	cmp    %ecx,%edi
  802961:	77 65                	ja     8029c8 <__udivdi3+0x8c>
  802963:	89 fd                	mov    %edi,%ebp
  802965:	85 ff                	test   %edi,%edi
  802967:	75 0b                	jne    802974 <__udivdi3+0x38>
  802969:	b8 01 00 00 00       	mov    $0x1,%eax
  80296e:	31 d2                	xor    %edx,%edx
  802970:	f7 f7                	div    %edi
  802972:	89 c5                	mov    %eax,%ebp
  802974:	31 d2                	xor    %edx,%edx
  802976:	89 c8                	mov    %ecx,%eax
  802978:	f7 f5                	div    %ebp
  80297a:	89 c1                	mov    %eax,%ecx
  80297c:	89 d8                	mov    %ebx,%eax
  80297e:	f7 f5                	div    %ebp
  802980:	89 cf                	mov    %ecx,%edi
  802982:	89 fa                	mov    %edi,%edx
  802984:	83 c4 1c             	add    $0x1c,%esp
  802987:	5b                   	pop    %ebx
  802988:	5e                   	pop    %esi
  802989:	5f                   	pop    %edi
  80298a:	5d                   	pop    %ebp
  80298b:	c3                   	ret    
  80298c:	39 ce                	cmp    %ecx,%esi
  80298e:	77 28                	ja     8029b8 <__udivdi3+0x7c>
  802990:	0f bd fe             	bsr    %esi,%edi
  802993:	83 f7 1f             	xor    $0x1f,%edi
  802996:	75 40                	jne    8029d8 <__udivdi3+0x9c>
  802998:	39 ce                	cmp    %ecx,%esi
  80299a:	72 0a                	jb     8029a6 <__udivdi3+0x6a>
  80299c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029a0:	0f 87 9e 00 00 00    	ja     802a44 <__udivdi3+0x108>
  8029a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ab:	89 fa                	mov    %edi,%edx
  8029ad:	83 c4 1c             	add    $0x1c,%esp
  8029b0:	5b                   	pop    %ebx
  8029b1:	5e                   	pop    %esi
  8029b2:	5f                   	pop    %edi
  8029b3:	5d                   	pop    %ebp
  8029b4:	c3                   	ret    
  8029b5:	8d 76 00             	lea    0x0(%esi),%esi
  8029b8:	31 ff                	xor    %edi,%edi
  8029ba:	31 c0                	xor    %eax,%eax
  8029bc:	89 fa                	mov    %edi,%edx
  8029be:	83 c4 1c             	add    $0x1c,%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    
  8029c6:	66 90                	xchg   %ax,%ax
  8029c8:	89 d8                	mov    %ebx,%eax
  8029ca:	f7 f7                	div    %edi
  8029cc:	31 ff                	xor    %edi,%edi
  8029ce:	89 fa                	mov    %edi,%edx
  8029d0:	83 c4 1c             	add    $0x1c,%esp
  8029d3:	5b                   	pop    %ebx
  8029d4:	5e                   	pop    %esi
  8029d5:	5f                   	pop    %edi
  8029d6:	5d                   	pop    %ebp
  8029d7:	c3                   	ret    
  8029d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8029dd:	89 eb                	mov    %ebp,%ebx
  8029df:	29 fb                	sub    %edi,%ebx
  8029e1:	89 f9                	mov    %edi,%ecx
  8029e3:	d3 e6                	shl    %cl,%esi
  8029e5:	89 c5                	mov    %eax,%ebp
  8029e7:	88 d9                	mov    %bl,%cl
  8029e9:	d3 ed                	shr    %cl,%ebp
  8029eb:	89 e9                	mov    %ebp,%ecx
  8029ed:	09 f1                	or     %esi,%ecx
  8029ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029f3:	89 f9                	mov    %edi,%ecx
  8029f5:	d3 e0                	shl    %cl,%eax
  8029f7:	89 c5                	mov    %eax,%ebp
  8029f9:	89 d6                	mov    %edx,%esi
  8029fb:	88 d9                	mov    %bl,%cl
  8029fd:	d3 ee                	shr    %cl,%esi
  8029ff:	89 f9                	mov    %edi,%ecx
  802a01:	d3 e2                	shl    %cl,%edx
  802a03:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a07:	88 d9                	mov    %bl,%cl
  802a09:	d3 e8                	shr    %cl,%eax
  802a0b:	09 c2                	or     %eax,%edx
  802a0d:	89 d0                	mov    %edx,%eax
  802a0f:	89 f2                	mov    %esi,%edx
  802a11:	f7 74 24 0c          	divl   0xc(%esp)
  802a15:	89 d6                	mov    %edx,%esi
  802a17:	89 c3                	mov    %eax,%ebx
  802a19:	f7 e5                	mul    %ebp
  802a1b:	39 d6                	cmp    %edx,%esi
  802a1d:	72 19                	jb     802a38 <__udivdi3+0xfc>
  802a1f:	74 0b                	je     802a2c <__udivdi3+0xf0>
  802a21:	89 d8                	mov    %ebx,%eax
  802a23:	31 ff                	xor    %edi,%edi
  802a25:	e9 58 ff ff ff       	jmp    802982 <__udivdi3+0x46>
  802a2a:	66 90                	xchg   %ax,%ax
  802a2c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a30:	89 f9                	mov    %edi,%ecx
  802a32:	d3 e2                	shl    %cl,%edx
  802a34:	39 c2                	cmp    %eax,%edx
  802a36:	73 e9                	jae    802a21 <__udivdi3+0xe5>
  802a38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a3b:	31 ff                	xor    %edi,%edi
  802a3d:	e9 40 ff ff ff       	jmp    802982 <__udivdi3+0x46>
  802a42:	66 90                	xchg   %ax,%ax
  802a44:	31 c0                	xor    %eax,%eax
  802a46:	e9 37 ff ff ff       	jmp    802982 <__udivdi3+0x46>
  802a4b:	90                   	nop

00802a4c <__umoddi3>:
  802a4c:	55                   	push   %ebp
  802a4d:	57                   	push   %edi
  802a4e:	56                   	push   %esi
  802a4f:	53                   	push   %ebx
  802a50:	83 ec 1c             	sub    $0x1c,%esp
  802a53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a57:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a6b:	89 f3                	mov    %esi,%ebx
  802a6d:	89 fa                	mov    %edi,%edx
  802a6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a73:	89 34 24             	mov    %esi,(%esp)
  802a76:	85 c0                	test   %eax,%eax
  802a78:	75 1a                	jne    802a94 <__umoddi3+0x48>
  802a7a:	39 f7                	cmp    %esi,%edi
  802a7c:	0f 86 a2 00 00 00    	jbe    802b24 <__umoddi3+0xd8>
  802a82:	89 c8                	mov    %ecx,%eax
  802a84:	89 f2                	mov    %esi,%edx
  802a86:	f7 f7                	div    %edi
  802a88:	89 d0                	mov    %edx,%eax
  802a8a:	31 d2                	xor    %edx,%edx
  802a8c:	83 c4 1c             	add    $0x1c,%esp
  802a8f:	5b                   	pop    %ebx
  802a90:	5e                   	pop    %esi
  802a91:	5f                   	pop    %edi
  802a92:	5d                   	pop    %ebp
  802a93:	c3                   	ret    
  802a94:	39 f0                	cmp    %esi,%eax
  802a96:	0f 87 ac 00 00 00    	ja     802b48 <__umoddi3+0xfc>
  802a9c:	0f bd e8             	bsr    %eax,%ebp
  802a9f:	83 f5 1f             	xor    $0x1f,%ebp
  802aa2:	0f 84 ac 00 00 00    	je     802b54 <__umoddi3+0x108>
  802aa8:	bf 20 00 00 00       	mov    $0x20,%edi
  802aad:	29 ef                	sub    %ebp,%edi
  802aaf:	89 fe                	mov    %edi,%esi
  802ab1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ab5:	89 e9                	mov    %ebp,%ecx
  802ab7:	d3 e0                	shl    %cl,%eax
  802ab9:	89 d7                	mov    %edx,%edi
  802abb:	89 f1                	mov    %esi,%ecx
  802abd:	d3 ef                	shr    %cl,%edi
  802abf:	09 c7                	or     %eax,%edi
  802ac1:	89 e9                	mov    %ebp,%ecx
  802ac3:	d3 e2                	shl    %cl,%edx
  802ac5:	89 14 24             	mov    %edx,(%esp)
  802ac8:	89 d8                	mov    %ebx,%eax
  802aca:	d3 e0                	shl    %cl,%eax
  802acc:	89 c2                	mov    %eax,%edx
  802ace:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ad2:	d3 e0                	shl    %cl,%eax
  802ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802adc:	89 f1                	mov    %esi,%ecx
  802ade:	d3 e8                	shr    %cl,%eax
  802ae0:	09 d0                	or     %edx,%eax
  802ae2:	d3 eb                	shr    %cl,%ebx
  802ae4:	89 da                	mov    %ebx,%edx
  802ae6:	f7 f7                	div    %edi
  802ae8:	89 d3                	mov    %edx,%ebx
  802aea:	f7 24 24             	mull   (%esp)
  802aed:	89 c6                	mov    %eax,%esi
  802aef:	89 d1                	mov    %edx,%ecx
  802af1:	39 d3                	cmp    %edx,%ebx
  802af3:	0f 82 87 00 00 00    	jb     802b80 <__umoddi3+0x134>
  802af9:	0f 84 91 00 00 00    	je     802b90 <__umoddi3+0x144>
  802aff:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b03:	29 f2                	sub    %esi,%edx
  802b05:	19 cb                	sbb    %ecx,%ebx
  802b07:	89 d8                	mov    %ebx,%eax
  802b09:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b0d:	d3 e0                	shl    %cl,%eax
  802b0f:	89 e9                	mov    %ebp,%ecx
  802b11:	d3 ea                	shr    %cl,%edx
  802b13:	09 d0                	or     %edx,%eax
  802b15:	89 e9                	mov    %ebp,%ecx
  802b17:	d3 eb                	shr    %cl,%ebx
  802b19:	89 da                	mov    %ebx,%edx
  802b1b:	83 c4 1c             	add    $0x1c,%esp
  802b1e:	5b                   	pop    %ebx
  802b1f:	5e                   	pop    %esi
  802b20:	5f                   	pop    %edi
  802b21:	5d                   	pop    %ebp
  802b22:	c3                   	ret    
  802b23:	90                   	nop
  802b24:	89 fd                	mov    %edi,%ebp
  802b26:	85 ff                	test   %edi,%edi
  802b28:	75 0b                	jne    802b35 <__umoddi3+0xe9>
  802b2a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b2f:	31 d2                	xor    %edx,%edx
  802b31:	f7 f7                	div    %edi
  802b33:	89 c5                	mov    %eax,%ebp
  802b35:	89 f0                	mov    %esi,%eax
  802b37:	31 d2                	xor    %edx,%edx
  802b39:	f7 f5                	div    %ebp
  802b3b:	89 c8                	mov    %ecx,%eax
  802b3d:	f7 f5                	div    %ebp
  802b3f:	89 d0                	mov    %edx,%eax
  802b41:	e9 44 ff ff ff       	jmp    802a8a <__umoddi3+0x3e>
  802b46:	66 90                	xchg   %ax,%ax
  802b48:	89 c8                	mov    %ecx,%eax
  802b4a:	89 f2                	mov    %esi,%edx
  802b4c:	83 c4 1c             	add    $0x1c,%esp
  802b4f:	5b                   	pop    %ebx
  802b50:	5e                   	pop    %esi
  802b51:	5f                   	pop    %edi
  802b52:	5d                   	pop    %ebp
  802b53:	c3                   	ret    
  802b54:	3b 04 24             	cmp    (%esp),%eax
  802b57:	72 06                	jb     802b5f <__umoddi3+0x113>
  802b59:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b5d:	77 0f                	ja     802b6e <__umoddi3+0x122>
  802b5f:	89 f2                	mov    %esi,%edx
  802b61:	29 f9                	sub    %edi,%ecx
  802b63:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b67:	89 14 24             	mov    %edx,(%esp)
  802b6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b72:	8b 14 24             	mov    (%esp),%edx
  802b75:	83 c4 1c             	add    $0x1c,%esp
  802b78:	5b                   	pop    %ebx
  802b79:	5e                   	pop    %esi
  802b7a:	5f                   	pop    %edi
  802b7b:	5d                   	pop    %ebp
  802b7c:	c3                   	ret    
  802b7d:	8d 76 00             	lea    0x0(%esi),%esi
  802b80:	2b 04 24             	sub    (%esp),%eax
  802b83:	19 fa                	sbb    %edi,%edx
  802b85:	89 d1                	mov    %edx,%ecx
  802b87:	89 c6                	mov    %eax,%esi
  802b89:	e9 71 ff ff ff       	jmp    802aff <__umoddi3+0xb3>
  802b8e:	66 90                	xchg   %ax,%ax
  802b90:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b94:	72 ea                	jb     802b80 <__umoddi3+0x134>
  802b96:	89 d9                	mov    %ebx,%ecx
  802b98:	e9 62 ff ff ff       	jmp    802aff <__umoddi3+0xb3>
