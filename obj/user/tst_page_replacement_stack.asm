
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 fd 00 00 00       	call   800133 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 14 a0 00 00    	sub    $0xa014,%esp
	int8 arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	int freePages = sys_calculate_free_frames();
  800049:	e8 67 15 00 00       	call   8015b5 <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 aa 15 00 00       	call   801600 <sys_pf_calculate_allocated_pages>
  800056:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800060:	eb 15                	jmp    800077 <_main+0x3f>
		arr[i] = -1 ;
  800062:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800070:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  800077:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  80007e:	7e e2                	jle    800062 <_main+0x2a>
		arr[i] = -1 ;


	cprintf_colored(TEXT_cyan, "%~\nchecking REPLACEMENT fault handling of STACK pages... \n");
  800080:	83 ec 08             	sub    $0x8,%esp
  800083:	68 c0 1c 80 00       	push   $0x801cc0
  800088:	6a 03                	push   $0x3
  80008a:	e8 4f 05 00 00       	call   8005de <cprintf_colored>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800092:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800099:	eb 2c                	jmp    8000c7 <_main+0x8f>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  80009b:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  8000a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a4:	01 d0                	add    %edx,%eax
  8000a6:	8a 00                	mov    (%eax),%al
  8000a8:	3c ff                	cmp    $0xff,%al
  8000aa:	74 14                	je     8000c0 <_main+0x88>
  8000ac:	83 ec 04             	sub    $0x4,%esp
  8000af:	68 fc 1c 80 00       	push   $0x801cfc
  8000b4:	6a 1a                	push   $0x1a
  8000b6:	68 2c 1d 80 00       	push   $0x801d2c
  8000bb:	e8 23 02 00 00       	call   8002e3 <_panic>
		arr[i] = -1 ;


	cprintf_colored(TEXT_cyan, "%~\nchecking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c0:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c7:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000ce:	7e cb                	jle    80009b <_main+0x63>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  10) panic("Unexpected extra/less pages have been added to page file");
  8000d0:	e8 2b 15 00 00       	call   801600 <sys_pf_calculate_allocated_pages>
  8000d5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d8:	83 f8 0a             	cmp    $0xa,%eax
  8000db:	74 14                	je     8000f1 <_main+0xb9>
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	68 50 1d 80 00       	push   $0x801d50
  8000e5:	6a 1c                	push   $0x1c
  8000e7:	68 2c 1d 80 00       	push   $0x801d2c
  8000ec:	e8 f2 01 00 00       	call   8002e3 <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000f1:	e8 bf 14 00 00       	call   8015b5 <sys_calculate_free_frames>
  8000f6:	89 c3                	mov    %eax,%ebx
  8000f8:	e8 d1 14 00 00       	call   8015ce <sys_calculate_modified_frames>
  8000fd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	39 c2                	cmp    %eax,%edx
  800105:	74 14                	je     80011b <_main+0xe3>
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	68 8c 1d 80 00       	push   $0x801d8c
  80010f:	6a 1e                	push   $0x1e
  800111:	68 2c 1d 80 00       	push   $0x801d2c
  800116:	e8 c8 01 00 00       	call   8002e3 <_panic>
	}//consider tables of PF, disk pages

	cprintf_colored(TEXT_light_green, "%~\nCongratulations: stack pages created, modified and read is completed successfully\n\n");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 f0 1d 80 00       	push   $0x801df0
  800123:	6a 0a                	push   $0xa
  800125:	e8 b4 04 00 00       	call   8005de <cprintf_colored>
  80012a:	83 c4 10             	add    $0x10,%esp


	return;
  80012d:	90                   	nop
}
  80012e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800131:	c9                   	leave  
  800132:	c3                   	ret    

00800133 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	57                   	push   %edi
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80013c:	e8 3d 16 00 00       	call   80177e <sys_getenvindex>
  800141:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800147:	89 d0                	mov    %edx,%eax
  800149:	c1 e0 02             	shl    $0x2,%eax
  80014c:	01 d0                	add    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80015a:	01 d0                	add    %edx,%eax
  80015c:	c1 e0 02             	shl    $0x2,%eax
  80015f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800164:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800169:	a1 20 30 80 00       	mov    0x803020,%eax
  80016e:	8a 40 20             	mov    0x20(%eax),%al
  800171:	84 c0                	test   %al,%al
  800173:	74 0d                	je     800182 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800175:	a1 20 30 80 00       	mov    0x803020,%eax
  80017a:	83 c0 20             	add    $0x20,%eax
  80017d:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800186:	7e 0a                	jle    800192 <libmain+0x5f>
		binaryname = argv[0];
  800188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018b:	8b 00                	mov    (%eax),%eax
  80018d:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800192:	83 ec 08             	sub    $0x8,%esp
  800195:	ff 75 0c             	pushl  0xc(%ebp)
  800198:	ff 75 08             	pushl  0x8(%ebp)
  80019b:	e8 98 fe ff ff       	call   800038 <_main>
  8001a0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a3:	a1 00 30 80 00       	mov    0x803000,%eax
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	0f 84 01 01 00 00    	je     8002b1 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b6:	bb 40 1f 80 00       	mov    $0x801f40,%ebx
  8001bb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c0:	89 c7                	mov    %eax,%edi
  8001c2:	89 de                	mov    %ebx,%esi
  8001c4:	89 d1                	mov    %edx,%ecx
  8001c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001c8:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001cb:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d0:	b0 00                	mov    $0x0,%al
  8001d2:	89 d7                	mov    %edx,%edi
  8001d4:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	50                   	push   %eax
  8001e4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 c4 17 00 00       	call   8019b4 <sys_utilities>
  8001f0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f3:	e8 0d 13 00 00       	call   801505 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	68 60 1e 80 00       	push   $0x801e60
  800200:	e8 ac 03 00 00       	call   8005b1 <cprintf>
  800205:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020b:	85 c0                	test   %eax,%eax
  80020d:	74 18                	je     800227 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80020f:	e8 be 17 00 00       	call   8019d2 <sys_get_optimal_num_faults>
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	68 88 1e 80 00       	push   $0x801e88
  80021d:	e8 8f 03 00 00       	call   8005b1 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
  800225:	eb 59                	jmp    800280 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800232:	a1 20 30 80 00       	mov    0x803020,%eax
  800237:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80023d:	83 ec 04             	sub    $0x4,%esp
  800240:	52                   	push   %edx
  800241:	50                   	push   %eax
  800242:	68 ac 1e 80 00       	push   $0x801eac
  800247:	e8 65 03 00 00       	call   8005b1 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80024f:	a1 20 30 80 00       	mov    0x803020,%eax
  800254:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80025a:	a1 20 30 80 00       	mov    0x803020,%eax
  80025f:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800265:	a1 20 30 80 00       	mov    0x803020,%eax
  80026a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800270:	51                   	push   %ecx
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	68 d4 1e 80 00       	push   $0x801ed4
  800278:	e8 34 03 00 00       	call   8005b1 <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800280:	a1 20 30 80 00       	mov    0x803020,%eax
  800285:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	50                   	push   %eax
  80028f:	68 2c 1f 80 00       	push   $0x801f2c
  800294:	e8 18 03 00 00       	call   8005b1 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 60 1e 80 00       	push   $0x801e60
  8002a4:	e8 08 03 00 00       	call   8005b1 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002ac:	e8 6e 12 00 00       	call   80151f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002b1:	e8 1f 00 00 00       	call   8002d5 <exit>
}
  8002b6:	90                   	nop
  8002b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ba:	5b                   	pop    %ebx
  8002bb:	5e                   	pop    %esi
  8002bc:	5f                   	pop    %edi
  8002bd:	5d                   	pop    %ebp
  8002be:	c3                   	ret    

008002bf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	6a 00                	push   $0x0
  8002ca:	e8 7b 14 00 00       	call   80174a <sys_destroy_env>
  8002cf:	83 c4 10             	add    $0x10,%esp
}
  8002d2:	90                   	nop
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <exit>:

void
exit(void)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002db:	e8 d0 14 00 00       	call   8017b0 <sys_exit_env>
}
  8002e0:	90                   	nop
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002e9:	8d 45 10             	lea    0x10(%ebp),%eax
  8002ec:	83 c0 04             	add    $0x4,%eax
  8002ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f2:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002f7:	85 c0                	test   %eax,%eax
  8002f9:	74 16                	je     800311 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002fb:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	50                   	push   %eax
  800304:	68 a4 1f 80 00       	push   $0x801fa4
  800309:	e8 a3 02 00 00       	call   8005b1 <cprintf>
  80030e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800311:	a1 04 30 80 00       	mov    0x803004,%eax
  800316:	83 ec 0c             	sub    $0xc,%esp
  800319:	ff 75 0c             	pushl  0xc(%ebp)
  80031c:	ff 75 08             	pushl  0x8(%ebp)
  80031f:	50                   	push   %eax
  800320:	68 ac 1f 80 00       	push   $0x801fac
  800325:	6a 74                	push   $0x74
  800327:	e8 b2 02 00 00       	call   8005de <cprintf_colored>
  80032c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	ff 75 f4             	pushl  -0xc(%ebp)
  800338:	50                   	push   %eax
  800339:	e8 04 02 00 00       	call   800542 <vcprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	6a 00                	push   $0x0
  800346:	68 d4 1f 80 00       	push   $0x801fd4
  80034b:	e8 f2 01 00 00       	call   800542 <vcprintf>
  800350:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800353:	e8 7d ff ff ff       	call   8002d5 <exit>

	// should not return here
	while (1) ;
  800358:	eb fe                	jmp    800358 <_panic+0x75>

0080035a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800360:	a1 20 30 80 00       	mov    0x803020,%eax
  800365:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80036b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036e:	39 c2                	cmp    %eax,%edx
  800370:	74 14                	je     800386 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 d8 1f 80 00       	push   $0x801fd8
  80037a:	6a 26                	push   $0x26
  80037c:	68 24 20 80 00       	push   $0x802024
  800381:	e8 5d ff ff ff       	call   8002e3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800386:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800394:	e9 c5 00 00 00       	jmp    80045e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	01 d0                	add    %edx,%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	85 c0                	test   %eax,%eax
  8003ac:	75 08                	jne    8003b6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003ae:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b1:	e9 a5 00 00 00       	jmp    80045b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c4:	eb 69                	jmp    80042f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cb:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d4:	89 d0                	mov    %edx,%eax
  8003d6:	01 c0                	add    %eax,%eax
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	c1 e0 03             	shl    $0x3,%eax
  8003dd:	01 c8                	add    %ecx,%eax
  8003df:	8a 40 04             	mov    0x4(%eax),%al
  8003e2:	84 c0                	test   %al,%al
  8003e4:	75 46                	jne    80042c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003eb:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f4:	89 d0                	mov    %edx,%eax
  8003f6:	01 c0                	add    %eax,%eax
  8003f8:	01 d0                	add    %edx,%eax
  8003fa:	c1 e0 03             	shl    $0x3,%eax
  8003fd:	01 c8                	add    %ecx,%eax
  8003ff:	8b 00                	mov    (%eax),%eax
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800404:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800407:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800411:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	01 c8                	add    %ecx,%eax
  80041d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041f:	39 c2                	cmp    %eax,%edx
  800421:	75 09                	jne    80042c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800423:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80042a:	eb 15                	jmp    800441 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042c:	ff 45 e8             	incl   -0x18(%ebp)
  80042f:	a1 20 30 80 00       	mov    0x803020,%eax
  800434:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80043a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043d:	39 c2                	cmp    %eax,%edx
  80043f:	77 85                	ja     8003c6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800441:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800445:	75 14                	jne    80045b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 30 20 80 00       	push   $0x802030
  80044f:	6a 3a                	push   $0x3a
  800451:	68 24 20 80 00       	push   $0x802024
  800456:	e8 88 fe ff ff       	call   8002e3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80045b:	ff 45 f0             	incl   -0x10(%ebp)
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800464:	0f 8c 2f ff ff ff    	jl     800399 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80046a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800471:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800478:	eb 26                	jmp    8004a0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80047a:	a1 20 30 80 00       	mov    0x803020,%eax
  80047f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800485:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800488:	89 d0                	mov    %edx,%eax
  80048a:	01 c0                	add    %eax,%eax
  80048c:	01 d0                	add    %edx,%eax
  80048e:	c1 e0 03             	shl    $0x3,%eax
  800491:	01 c8                	add    %ecx,%eax
  800493:	8a 40 04             	mov    0x4(%eax),%al
  800496:	3c 01                	cmp    $0x1,%al
  800498:	75 03                	jne    80049d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80049a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80049d:	ff 45 e0             	incl   -0x20(%ebp)
  8004a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ae:	39 c2                	cmp    %eax,%edx
  8004b0:	77 c8                	ja     80047a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b8:	74 14                	je     8004ce <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	68 84 20 80 00       	push   $0x802084
  8004c2:	6a 44                	push   $0x44
  8004c4:	68 24 20 80 00       	push   $0x802024
  8004c9:	e8 15 fe ff ff       	call   8002e3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ce:	90                   	nop
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	53                   	push   %ebx
  8004d5:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e3:	89 0a                	mov    %ecx,(%edx)
  8004e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e8:	88 d1                	mov    %dl,%cl
  8004ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004fb:	75 30                	jne    80052d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004fd:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800503:	a0 44 30 80 00       	mov    0x803044,%al
  800508:	0f b6 c0             	movzbl %al,%eax
  80050b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050e:	8b 09                	mov    (%ecx),%ecx
  800510:	89 cb                	mov    %ecx,%ebx
  800512:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800515:	83 c1 08             	add    $0x8,%ecx
  800518:	52                   	push   %edx
  800519:	50                   	push   %eax
  80051a:	53                   	push   %ebx
  80051b:	51                   	push   %ecx
  80051c:	e8 a0 0f 00 00       	call   8014c1 <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800524:	8b 45 0c             	mov    0xc(%ebp),%eax
  800527:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800530:	8b 40 04             	mov    0x4(%eax),%eax
  800533:	8d 50 01             	lea    0x1(%eax),%edx
  800536:	8b 45 0c             	mov    0xc(%ebp),%eax
  800539:	89 50 04             	mov    %edx,0x4(%eax)
}
  80053c:	90                   	nop
  80053d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800540:	c9                   	leave  
  800541:	c3                   	ret    

00800542 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800542:	55                   	push   %ebp
  800543:	89 e5                	mov    %esp,%ebp
  800545:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80054b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800552:	00 00 00 
	b.cnt = 0;
  800555:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80055c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80055f:	ff 75 0c             	pushl  0xc(%ebp)
  800562:	ff 75 08             	pushl  0x8(%ebp)
  800565:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056b:	50                   	push   %eax
  80056c:	68 d1 04 80 00       	push   $0x8004d1
  800571:	e8 5a 02 00 00       	call   8007d0 <vprintfmt>
  800576:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800579:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80057f:	a0 44 30 80 00       	mov    0x803044,%al
  800584:	0f b6 c0             	movzbl %al,%eax
  800587:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80058d:	52                   	push   %edx
  80058e:	50                   	push   %eax
  80058f:	51                   	push   %ecx
  800590:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800596:	83 c0 08             	add    $0x8,%eax
  800599:	50                   	push   %eax
  80059a:	e8 22 0f 00 00       	call   8014c1 <sys_cputs>
  80059f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a2:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005a9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005af:	c9                   	leave  
  8005b0:	c3                   	ret    

008005b1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005b1:	55                   	push   %ebp
  8005b2:	89 e5                	mov    %esp,%ebp
  8005b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005be:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	50                   	push   %eax
  8005ce:	e8 6f ff ff ff       	call   800542 <vcprintf>
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dc:	c9                   	leave  
  8005dd:	c3                   	ret    

008005de <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005de:	55                   	push   %ebp
  8005df:	89 e5                	mov    %esp,%ebp
  8005e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e4:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	c1 e0 08             	shl    $0x8,%eax
  8005f1:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	83 c0 04             	add    $0x4,%eax
  8005fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 f4             	pushl  -0xc(%ebp)
  800608:	50                   	push   %eax
  800609:	e8 34 ff ff ff       	call   800542 <vcprintf>
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800614:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80061b:	07 00 00 

	return cnt;
  80061e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
  800626:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800629:	e8 d7 0e 00 00       	call   801505 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80062e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800631:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	ff 75 f4             	pushl  -0xc(%ebp)
  80063d:	50                   	push   %eax
  80063e:	e8 ff fe ff ff       	call   800542 <vcprintf>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800649:	e8 d1 0e 00 00       	call   80151f <sys_unlock_cons>
	return cnt;
  80064e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800651:	c9                   	leave  
  800652:	c3                   	ret    

00800653 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	53                   	push   %ebx
  800657:	83 ec 14             	sub    $0x14,%esp
  80065a:	8b 45 10             	mov    0x10(%ebp),%eax
  80065d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800666:	8b 45 18             	mov    0x18(%ebp),%eax
  800669:	ba 00 00 00 00       	mov    $0x0,%edx
  80066e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800671:	77 55                	ja     8006c8 <printnum+0x75>
  800673:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800676:	72 05                	jb     80067d <printnum+0x2a>
  800678:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80067b:	77 4b                	ja     8006c8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80067d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800680:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800683:	8b 45 18             	mov    0x18(%ebp),%eax
  800686:	ba 00 00 00 00       	mov    $0x0,%edx
  80068b:	52                   	push   %edx
  80068c:	50                   	push   %eax
  80068d:	ff 75 f4             	pushl  -0xc(%ebp)
  800690:	ff 75 f0             	pushl  -0x10(%ebp)
  800693:	e8 a8 13 00 00       	call   801a40 <__udivdi3>
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	83 ec 04             	sub    $0x4,%esp
  80069e:	ff 75 20             	pushl  0x20(%ebp)
  8006a1:	53                   	push   %ebx
  8006a2:	ff 75 18             	pushl  0x18(%ebp)
  8006a5:	52                   	push   %edx
  8006a6:	50                   	push   %eax
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 a1 ff ff ff       	call   800653 <printnum>
  8006b2:	83 c4 20             	add    $0x20,%esp
  8006b5:	eb 1a                	jmp    8006d1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	ff 75 20             	pushl  0x20(%ebp)
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	ff d0                	call   *%eax
  8006c5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c8:	ff 4d 1c             	decl   0x1c(%ebp)
  8006cb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006cf:	7f e6                	jg     8006b7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006df:	53                   	push   %ebx
  8006e0:	51                   	push   %ecx
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	e8 68 14 00 00       	call   801b50 <__umoddi3>
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	05 f4 22 80 00       	add    $0x8022f4,%eax
  8006f0:	8a 00                	mov    (%eax),%al
  8006f2:	0f be c0             	movsbl %al,%eax
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
}
  800704:	90                   	nop
  800705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800708:	c9                   	leave  
  800709:	c3                   	ret    

0080070a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80070a:	55                   	push   %ebp
  80070b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80070d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800711:	7e 1c                	jle    80072f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	8d 50 08             	lea    0x8(%eax),%edx
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	89 10                	mov    %edx,(%eax)
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	83 e8 08             	sub    $0x8,%eax
  800728:	8b 50 04             	mov    0x4(%eax),%edx
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	eb 40                	jmp    80076f <getuint+0x65>
	else if (lflag)
  80072f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800733:	74 1e                	je     800753 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	8d 50 04             	lea    0x4(%eax),%edx
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	89 10                	mov    %edx,(%eax)
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	83 e8 04             	sub    $0x4,%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	eb 1c                	jmp    80076f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	8d 50 04             	lea    0x4(%eax),%edx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 10                	mov    %edx,(%eax)
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80076f:	5d                   	pop    %ebp
  800770:	c3                   	ret    

00800771 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800774:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800778:	7e 1c                	jle    800796 <getint+0x25>
		return va_arg(*ap, long long);
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	8d 50 08             	lea    0x8(%eax),%edx
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	89 10                	mov    %edx,(%eax)
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	83 e8 08             	sub    $0x8,%eax
  80078f:	8b 50 04             	mov    0x4(%eax),%edx
  800792:	8b 00                	mov    (%eax),%eax
  800794:	eb 38                	jmp    8007ce <getint+0x5d>
	else if (lflag)
  800796:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80079a:	74 1a                	je     8007b6 <getint+0x45>
		return va_arg(*ap, long);
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	89 10                	mov    %edx,(%eax)
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	83 e8 04             	sub    $0x4,%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	99                   	cltd   
  8007b4:	eb 18                	jmp    8007ce <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 04             	lea    0x4(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	99                   	cltd   
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	56                   	push   %esi
  8007d4:	53                   	push   %ebx
  8007d5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d8:	eb 17                	jmp    8007f1 <vprintfmt+0x21>
			if (ch == '\0')
  8007da:	85 db                	test   %ebx,%ebx
  8007dc:	0f 84 c1 03 00 00    	je     800ba3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	ff d0                	call   *%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f4:	8d 50 01             	lea    0x1(%eax),%edx
  8007f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8007fa:	8a 00                	mov    (%eax),%al
  8007fc:	0f b6 d8             	movzbl %al,%ebx
  8007ff:	83 fb 25             	cmp    $0x25,%ebx
  800802:	75 d6                	jne    8007da <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800804:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800808:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80080f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800816:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80081d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800824:	8b 45 10             	mov    0x10(%ebp),%eax
  800827:	8d 50 01             	lea    0x1(%eax),%edx
  80082a:	89 55 10             	mov    %edx,0x10(%ebp)
  80082d:	8a 00                	mov    (%eax),%al
  80082f:	0f b6 d8             	movzbl %al,%ebx
  800832:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800835:	83 f8 5b             	cmp    $0x5b,%eax
  800838:	0f 87 3d 03 00 00    	ja     800b7b <vprintfmt+0x3ab>
  80083e:	8b 04 85 18 23 80 00 	mov    0x802318(,%eax,4),%eax
  800845:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800847:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80084b:	eb d7                	jmp    800824 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800851:	eb d1                	jmp    800824 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80085a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085d:	89 d0                	mov    %edx,%eax
  80085f:	c1 e0 02             	shl    $0x2,%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d8                	add    %ebx,%eax
  800868:	83 e8 30             	sub    $0x30,%eax
  80086b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80086e:	8b 45 10             	mov    0x10(%ebp),%eax
  800871:	8a 00                	mov    (%eax),%al
  800873:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800876:	83 fb 2f             	cmp    $0x2f,%ebx
  800879:	7e 3e                	jle    8008b9 <vprintfmt+0xe9>
  80087b:	83 fb 39             	cmp    $0x39,%ebx
  80087e:	7f 39                	jg     8008b9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800880:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800883:	eb d5                	jmp    80085a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800899:	eb 1f                	jmp    8008ba <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80089b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089f:	79 83                	jns    800824 <vprintfmt+0x54>
				width = 0;
  8008a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008a8:	e9 77 ff ff ff       	jmp    800824 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008ad:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b4:	e9 6b ff ff ff       	jmp    800824 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008be:	0f 89 60 ff ff ff    	jns    800824 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d1:	e9 4e ff ff ff       	jmp    800824 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008d9:	e9 46 ff ff ff       	jmp    800824 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	83 c0 04             	add    $0x4,%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 9b 02 00 00       	jmp    800b9e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800914:	85 db                	test   %ebx,%ebx
  800916:	79 02                	jns    80091a <vprintfmt+0x14a>
				err = -err;
  800918:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80091a:	83 fb 64             	cmp    $0x64,%ebx
  80091d:	7f 0b                	jg     80092a <vprintfmt+0x15a>
  80091f:	8b 34 9d 60 21 80 00 	mov    0x802160(,%ebx,4),%esi
  800926:	85 f6                	test   %esi,%esi
  800928:	75 19                	jne    800943 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80092a:	53                   	push   %ebx
  80092b:	68 05 23 80 00       	push   $0x802305
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	ff 75 08             	pushl  0x8(%ebp)
  800936:	e8 70 02 00 00       	call   800bab <printfmt>
  80093b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80093e:	e9 5b 02 00 00       	jmp    800b9e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800943:	56                   	push   %esi
  800944:	68 0e 23 80 00       	push   $0x80230e
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	ff 75 08             	pushl  0x8(%ebp)
  80094f:	e8 57 02 00 00       	call   800bab <printfmt>
  800954:	83 c4 10             	add    $0x10,%esp
			break;
  800957:	e9 42 02 00 00       	jmp    800b9e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	83 c0 04             	add    $0x4,%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 30                	mov    (%eax),%esi
  80096d:	85 f6                	test   %esi,%esi
  80096f:	75 05                	jne    800976 <vprintfmt+0x1a6>
				p = "(null)";
  800971:	be 11 23 80 00       	mov    $0x802311,%esi
			if (width > 0 && padc != '-')
  800976:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097a:	7e 6d                	jle    8009e9 <vprintfmt+0x219>
  80097c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800980:	74 67                	je     8009e9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	50                   	push   %eax
  800989:	56                   	push   %esi
  80098a:	e8 1e 03 00 00       	call   800cad <strnlen>
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800995:	eb 16                	jmp    8009ad <vprintfmt+0x1dd>
					putch(padc, putdat);
  800997:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	50                   	push   %eax
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	ff d0                	call   *%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b1:	7f e4                	jg     800997 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b3:	eb 34                	jmp    8009e9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009b9:	74 1c                	je     8009d7 <vprintfmt+0x207>
  8009bb:	83 fb 1f             	cmp    $0x1f,%ebx
  8009be:	7e 05                	jle    8009c5 <vprintfmt+0x1f5>
  8009c0:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c3:	7e 12                	jle    8009d7 <vprintfmt+0x207>
					putch('?', putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	6a 3f                	push   $0x3f
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	ff d0                	call   *%eax
  8009d2:	83 c4 10             	add    $0x10,%esp
  8009d5:	eb 0f                	jmp    8009e6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	89 f0                	mov    %esi,%eax
  8009eb:	8d 70 01             	lea    0x1(%eax),%esi
  8009ee:	8a 00                	mov    (%eax),%al
  8009f0:	0f be d8             	movsbl %al,%ebx
  8009f3:	85 db                	test   %ebx,%ebx
  8009f5:	74 24                	je     800a1b <vprintfmt+0x24b>
  8009f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009fb:	78 b8                	js     8009b5 <vprintfmt+0x1e5>
  8009fd:	ff 4d e0             	decl   -0x20(%ebp)
  800a00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a04:	79 af                	jns    8009b5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a06:	eb 13                	jmp    800a1b <vprintfmt+0x24b>
				putch(' ', putdat);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	6a 20                	push   $0x20
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	ff d0                	call   *%eax
  800a15:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a18:	ff 4d e4             	decl   -0x1c(%ebp)
  800a1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1f:	7f e7                	jg     800a08 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a21:	e9 78 01 00 00       	jmp    800b9e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2f:	50                   	push   %eax
  800a30:	e8 3c fd ff ff       	call   800771 <getint>
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a44:	85 d2                	test   %edx,%edx
  800a46:	79 23                	jns    800a6b <vprintfmt+0x29b>
				putch('-', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	6a 2d                	push   $0x2d
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5e:	f7 d8                	neg    %eax
  800a60:	83 d2 00             	adc    $0x0,%edx
  800a63:	f7 da                	neg    %edx
  800a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	e8 84 fc ff ff       	call   80070a <getuint>
  800a86:	83 c4 10             	add    $0x10,%esp
  800a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a8f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a96:	e9 98 00 00 00       	jmp    800b33 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	6a 58                	push   $0x58
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	ff d0                	call   *%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	6a 58                	push   $0x58
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 58                	push   $0x58
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			break;
  800acb:	e9 ce 00 00 00       	jmp    800b9e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	6a 30                	push   $0x30
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	6a 78                	push   $0x78
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	ff d0                	call   *%eax
  800aed:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b0b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b12:	eb 1f                	jmp    800b33 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1d:	50                   	push   %eax
  800b1e:	e8 e7 fb ff ff       	call   80070a <getuint>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b2c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b33:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b3a:	83 ec 04             	sub    $0x4,%esp
  800b3d:	52                   	push   %edx
  800b3e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b41:	50                   	push   %eax
  800b42:	ff 75 f4             	pushl  -0xc(%ebp)
  800b45:	ff 75 f0             	pushl  -0x10(%ebp)
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	ff 75 08             	pushl  0x8(%ebp)
  800b4e:	e8 00 fb ff ff       	call   800653 <printnum>
  800b53:	83 c4 20             	add    $0x20,%esp
			break;
  800b56:	eb 46                	jmp    800b9e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	53                   	push   %ebx
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
			break;
  800b67:	eb 35                	jmp    800b9e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b69:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b70:	eb 2c                	jmp    800b9e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b72:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b79:	eb 23                	jmp    800b9e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	6a 25                	push   $0x25
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	ff d0                	call   *%eax
  800b88:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b8b:	ff 4d 10             	decl   0x10(%ebp)
  800b8e:	eb 03                	jmp    800b93 <vprintfmt+0x3c3>
  800b90:	ff 4d 10             	decl   0x10(%ebp)
  800b93:	8b 45 10             	mov    0x10(%ebp),%eax
  800b96:	48                   	dec    %eax
  800b97:	8a 00                	mov    (%eax),%al
  800b99:	3c 25                	cmp    $0x25,%al
  800b9b:	75 f3                	jne    800b90 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b9d:	90                   	nop
		}
	}
  800b9e:	e9 35 fc ff ff       	jmp    8007d8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba7:	5b                   	pop    %ebx
  800ba8:	5e                   	pop    %esi
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb4:	83 c0 04             	add    $0x4,%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc0:	50                   	push   %eax
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 04 fc ff ff       	call   8007d0 <vprintfmt>
  800bcc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bcf:	90                   	nop
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8b 40 08             	mov    0x8(%eax),%eax
  800bdb:	8d 50 01             	lea    0x1(%eax),%edx
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 10                	mov    (%eax),%edx
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	8b 40 04             	mov    0x4(%eax),%eax
  800bef:	39 c2                	cmp    %eax,%edx
  800bf1:	73 12                	jae    800c05 <sprintputch+0x33>
		*b->buf++ = ch;
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8b 00                	mov    (%eax),%eax
  800bf8:	8d 48 01             	lea    0x1(%eax),%ecx
  800bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfe:	89 0a                	mov    %ecx,(%edx)
  800c00:	8b 55 08             	mov    0x8(%ebp),%edx
  800c03:	88 10                	mov    %dl,(%eax)
}
  800c05:	90                   	nop
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	01 d0                	add    %edx,%eax
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c2d:	74 06                	je     800c35 <vsnprintf+0x2d>
  800c2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c33:	7f 07                	jg     800c3c <vsnprintf+0x34>
		return -E_INVAL;
  800c35:	b8 03 00 00 00       	mov    $0x3,%eax
  800c3a:	eb 20                	jmp    800c5c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c3c:	ff 75 14             	pushl  0x14(%ebp)
  800c3f:	ff 75 10             	pushl  0x10(%ebp)
  800c42:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c45:	50                   	push   %eax
  800c46:	68 d2 0b 80 00       	push   $0x800bd2
  800c4b:	e8 80 fb ff ff       	call   8007d0 <vprintfmt>
  800c50:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c56:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c64:	8d 45 10             	lea    0x10(%ebp),%eax
  800c67:	83 c0 04             	add    $0x4,%eax
  800c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c70:	ff 75 f4             	pushl  -0xc(%ebp)
  800c73:	50                   	push   %eax
  800c74:	ff 75 0c             	pushl  0xc(%ebp)
  800c77:	ff 75 08             	pushl  0x8(%ebp)
  800c7a:	e8 89 ff ff ff       	call   800c08 <vsnprintf>
  800c7f:	83 c4 10             	add    $0x10,%esp
  800c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c97:	eb 06                	jmp    800c9f <strlen+0x15>
		n++;
  800c99:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c9c:	ff 45 08             	incl   0x8(%ebp)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	75 f1                	jne    800c99 <strlen+0xf>
		n++;
	return n;
  800ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cba:	eb 09                	jmp    800cc5 <strnlen+0x18>
		n++;
  800cbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cbf:	ff 45 08             	incl   0x8(%ebp)
  800cc2:	ff 4d 0c             	decl   0xc(%ebp)
  800cc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc9:	74 09                	je     800cd4 <strnlen+0x27>
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e8                	jne    800cbc <strnlen+0xf>
		n++;
	return n;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ce5:	90                   	nop
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8d 50 01             	lea    0x1(%eax),%edx
  800cec:	89 55 08             	mov    %edx,0x8(%ebp)
  800cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf8:	8a 12                	mov    (%edx),%dl
  800cfa:	88 10                	mov    %dl,(%eax)
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	84 c0                	test   %al,%al
  800d00:	75 e4                	jne    800ce6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1a:	eb 1f                	jmp    800d3b <strncpy+0x34>
		*dst++ = *src;
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8d 50 01             	lea    0x1(%eax),%edx
  800d22:	89 55 08             	mov    %edx,0x8(%ebp)
  800d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d28:	8a 12                	mov    (%edx),%dl
  800d2a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	84 c0                	test   %al,%al
  800d33:	74 03                	je     800d38 <strncpy+0x31>
			src++;
  800d35:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d38:	ff 45 fc             	incl   -0x4(%ebp)
  800d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d41:	72 d9                	jb     800d1c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d43:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d58:	74 30                	je     800d8a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d5a:	eb 16                	jmp    800d72 <strlcpy+0x2a>
			*dst++ = *src++;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8d 50 01             	lea    0x1(%eax),%edx
  800d62:	89 55 08             	mov    %edx,0x8(%ebp)
  800d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d6b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d6e:	8a 12                	mov    (%edx),%dl
  800d70:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d72:	ff 4d 10             	decl   0x10(%ebp)
  800d75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d79:	74 09                	je     800d84 <strlcpy+0x3c>
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	84 c0                	test   %al,%al
  800d82:	75 d8                	jne    800d5c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d99:	eb 06                	jmp    800da1 <strcmp+0xb>
		p++, q++;
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	74 0e                	je     800db8 <strcmp+0x22>
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8a 10                	mov    (%eax),%dl
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	38 c2                	cmp    %al,%dl
  800db6:	74 e3                	je     800d9b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	0f b6 d0             	movzbl %al,%edx
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	0f b6 c0             	movzbl %al,%eax
  800dc8:	29 c2                	sub    %eax,%edx
  800dca:	89 d0                	mov    %edx,%eax
}
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    

00800dce <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd1:	eb 09                	jmp    800ddc <strncmp+0xe>
		n--, p++, q++;
  800dd3:	ff 4d 10             	decl   0x10(%ebp)
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ddc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de0:	74 17                	je     800df9 <strncmp+0x2b>
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	84 c0                	test   %al,%al
  800de9:	74 0e                	je     800df9 <strncmp+0x2b>
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 10                	mov    (%eax),%dl
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	38 c2                	cmp    %al,%dl
  800df7:	74 da                	je     800dd3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800df9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfd:	75 07                	jne    800e06 <strncmp+0x38>
		return 0;
  800dff:	b8 00 00 00 00       	mov    $0x0,%eax
  800e04:	eb 14                	jmp    800e1a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	0f b6 d0             	movzbl %al,%edx
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	0f b6 c0             	movzbl %al,%eax
  800e16:	29 c2                	sub    %eax,%edx
  800e18:	89 d0                	mov    %edx,%eax
}
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	83 ec 04             	sub    $0x4,%esp
  800e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e25:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e28:	eb 12                	jmp    800e3c <strchr+0x20>
		if (*s == c)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e32:	75 05                	jne    800e39 <strchr+0x1d>
			return (char *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	eb 11                	jmp    800e4a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e39:	ff 45 08             	incl   0x8(%ebp)
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	84 c0                	test   %al,%al
  800e43:	75 e5                	jne    800e2a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 04             	sub    $0x4,%esp
  800e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e55:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e58:	eb 0d                	jmp    800e67 <strfind+0x1b>
		if (*s == c)
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8a 00                	mov    (%eax),%al
  800e5f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e62:	74 0e                	je     800e72 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e64:	ff 45 08             	incl   0x8(%ebp)
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	84 c0                	test   %al,%al
  800e6e:	75 ea                	jne    800e5a <strfind+0xe>
  800e70:	eb 01                	jmp    800e73 <strfind+0x27>
		if (*s == c)
			break;
  800e72:	90                   	nop
	return (char *) s;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e84:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e88:	76 63                	jbe    800eed <memset+0x75>
		uint64 data_block = c;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	99                   	cltd   
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e91:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9a:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e9e:	c1 e0 08             	shl    $0x8,%eax
  800ea1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ead:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eb1:	c1 e0 10             	shl    $0x10,%eax
  800eb4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec0:	89 c2                	mov    %eax,%edx
  800ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eca:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ecd:	eb 18                	jmp    800ee7 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ecf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed2:	8d 41 08             	lea    0x8(%ecx),%eax
  800ed5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ede:	89 01                	mov    %eax,(%ecx)
  800ee0:	89 51 04             	mov    %edx,0x4(%ecx)
  800ee3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ee7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eeb:	77 e2                	ja     800ecf <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef1:	74 23                	je     800f16 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef9:	eb 0e                	jmp    800f09 <memset+0x91>
			*p8++ = (uint8)c;
  800efb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efe:	8d 50 01             	lea    0x1(%eax),%edx
  800f01:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f07:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	75 e5                	jne    800efb <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f2d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f31:	76 24                	jbe    800f57 <memcpy+0x3c>
		while(n >= 8){
  800f33:	eb 1c                	jmp    800f51 <memcpy+0x36>
			*d64 = *s64;
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8b 50 04             	mov    0x4(%eax),%edx
  800f3b:	8b 00                	mov    (%eax),%eax
  800f3d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f40:	89 01                	mov    %eax,(%ecx)
  800f42:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f45:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f49:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f4d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f51:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f55:	77 de                	ja     800f35 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5b:	74 31                	je     800f8e <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f66:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f69:	eb 16                	jmp    800f81 <memcpy+0x66>
			*d8++ = *s8++;
  800f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6e:	8d 50 01             	lea    0x1(%eax),%edx
  800f71:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f77:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f7d:	8a 12                	mov    (%edx),%dl
  800f7f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f81:	8b 45 10             	mov    0x10(%ebp),%eax
  800f84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f87:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	75 dd                	jne    800f6b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fab:	73 50                	jae    800ffd <memmove+0x6a>
  800fad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	01 d0                	add    %edx,%eax
  800fb5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb8:	76 43                	jbe    800ffd <memmove+0x6a>
		s += n;
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc6:	eb 10                	jmp    800fd8 <memmove+0x45>
			*--d = *--s;
  800fc8:	ff 4d f8             	decl   -0x8(%ebp)
  800fcb:	ff 4d fc             	decl   -0x4(%ebp)
  800fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd1:	8a 10                	mov    (%eax),%dl
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fde:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	75 e3                	jne    800fc8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fe5:	eb 23                	jmp    80100a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fea:	8d 50 01             	lea    0x1(%eax),%edx
  800fed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff9:	8a 12                	mov    (%edx),%dl
  800ffb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	8d 50 ff             	lea    -0x1(%eax),%edx
  801003:	89 55 10             	mov    %edx,0x10(%ebp)
  801006:	85 c0                	test   %eax,%eax
  801008:	75 dd                	jne    800fe7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801021:	eb 2a                	jmp    80104d <memcmp+0x3e>
		if (*s1 != *s2)
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801026:	8a 10                	mov    (%eax),%dl
  801028:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	38 c2                	cmp    %al,%dl
  80102f:	74 16                	je     801047 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f b6 d0             	movzbl %al,%edx
  801039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	0f b6 c0             	movzbl %al,%eax
  801041:	29 c2                	sub    %eax,%edx
  801043:	89 d0                	mov    %edx,%eax
  801045:	eb 18                	jmp    80105f <memcmp+0x50>
		s1++, s2++;
  801047:	ff 45 fc             	incl   -0x4(%ebp)
  80104a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80104d:	8b 45 10             	mov    0x10(%ebp),%eax
  801050:	8d 50 ff             	lea    -0x1(%eax),%edx
  801053:	89 55 10             	mov    %edx,0x10(%ebp)
  801056:	85 c0                	test   %eax,%eax
  801058:	75 c9                	jne    801023 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801067:	8b 55 08             	mov    0x8(%ebp),%edx
  80106a:	8b 45 10             	mov    0x10(%ebp),%eax
  80106d:	01 d0                	add    %edx,%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801072:	eb 15                	jmp    801089 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f b6 d0             	movzbl %al,%edx
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	0f b6 c0             	movzbl %al,%eax
  801082:	39 c2                	cmp    %eax,%edx
  801084:	74 0d                	je     801093 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801086:	ff 45 08             	incl   0x8(%ebp)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80108f:	72 e3                	jb     801074 <memfind+0x13>
  801091:	eb 01                	jmp    801094 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801093:	90                   	nop
	return (void *) s;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ad:	eb 03                	jmp    8010b2 <strtol+0x19>
		s++;
  8010af:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	3c 20                	cmp    $0x20,%al
  8010b9:	74 f4                	je     8010af <strtol+0x16>
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 09                	cmp    $0x9,%al
  8010c2:	74 eb                	je     8010af <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 2b                	cmp    $0x2b,%al
  8010cb:	75 05                	jne    8010d2 <strtol+0x39>
		s++;
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	eb 13                	jmp    8010e5 <strtol+0x4c>
	else if (*s == '-')
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 2d                	cmp    $0x2d,%al
  8010d9:	75 0a                	jne    8010e5 <strtol+0x4c>
		s++, neg = 1;
  8010db:	ff 45 08             	incl   0x8(%ebp)
  8010de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e9:	74 06                	je     8010f1 <strtol+0x58>
  8010eb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ef:	75 20                	jne    801111 <strtol+0x78>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 30                	cmp    $0x30,%al
  8010f8:	75 17                	jne    801111 <strtol+0x78>
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	40                   	inc    %eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 78                	cmp    $0x78,%al
  801102:	75 0d                	jne    801111 <strtol+0x78>
		s += 2, base = 16;
  801104:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801108:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80110f:	eb 28                	jmp    801139 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801111:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801115:	75 15                	jne    80112c <strtol+0x93>
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 30                	cmp    $0x30,%al
  80111e:	75 0c                	jne    80112c <strtol+0x93>
		s++, base = 8;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112a:	eb 0d                	jmp    801139 <strtol+0xa0>
	else if (base == 0)
  80112c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801130:	75 07                	jne    801139 <strtol+0xa0>
		base = 10;
  801132:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	3c 2f                	cmp    $0x2f,%al
  801140:	7e 19                	jle    80115b <strtol+0xc2>
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	3c 39                	cmp    $0x39,%al
  801149:	7f 10                	jg     80115b <strtol+0xc2>
			dig = *s - '0';
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	0f be c0             	movsbl %al,%eax
  801153:	83 e8 30             	sub    $0x30,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801159:	eb 42                	jmp    80119d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 60                	cmp    $0x60,%al
  801162:	7e 19                	jle    80117d <strtol+0xe4>
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 7a                	cmp    $0x7a,%al
  80116b:	7f 10                	jg     80117d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f be c0             	movsbl %al,%eax
  801175:	83 e8 57             	sub    $0x57,%eax
  801178:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117b:	eb 20                	jmp    80119d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	3c 40                	cmp    $0x40,%al
  801184:	7e 39                	jle    8011bf <strtol+0x126>
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	3c 5a                	cmp    $0x5a,%al
  80118d:	7f 30                	jg     8011bf <strtol+0x126>
			dig = *s - 'A' + 10;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	0f be c0             	movsbl %al,%eax
  801197:	83 e8 37             	sub    $0x37,%eax
  80119a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80119d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a3:	7d 19                	jge    8011be <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011a5:	ff 45 08             	incl   0x8(%ebp)
  8011a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ab:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b9:	e9 7b ff ff ff       	jmp    801139 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011be:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c3:	74 08                	je     8011cd <strtol+0x134>
		*endptr = (char *) s;
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d1:	74 07                	je     8011da <strtol+0x141>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	f7 d8                	neg    %eax
  8011d8:	eb 03                	jmp    8011dd <strtol+0x144>
  8011da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <ltostr>:

void
ltostr(long value, char *str)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f7:	79 13                	jns    80120c <ltostr+0x2d>
	{
		neg = 1;
  8011f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801206:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801209:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801214:	99                   	cltd   
  801215:	f7 f9                	idiv   %ecx
  801217:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121d:	8d 50 01             	lea    0x1(%eax),%edx
  801220:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801223:	89 c2                	mov    %eax,%edx
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	01 d0                	add    %edx,%eax
  80122a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122d:	83 c2 30             	add    $0x30,%edx
  801230:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801232:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801235:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123a:	f7 e9                	imul   %ecx
  80123c:	c1 fa 02             	sar    $0x2,%edx
  80123f:	89 c8                	mov    %ecx,%eax
  801241:	c1 f8 1f             	sar    $0x1f,%eax
  801244:	29 c2                	sub    %eax,%edx
  801246:	89 d0                	mov    %edx,%eax
  801248:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80124b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80124f:	75 bb                	jne    80120c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801251:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801258:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125b:	48                   	dec    %eax
  80125c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80125f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801263:	74 3d                	je     8012a2 <ltostr+0xc3>
		start = 1 ;
  801265:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80126c:	eb 34                	jmp    8012a2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80126e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 d0                	add    %edx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80127b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801281:	01 c2                	add    %eax,%edx
  801283:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 c8                	add    %ecx,%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80128f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	01 c2                	add    %eax,%edx
  801297:	8a 45 eb             	mov    -0x15(%ebp),%al
  80129a:	88 02                	mov    %al,(%edx)
		start++ ;
  80129c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80129f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a8:	7c c4                	jl     80126e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	01 d0                	add    %edx,%eax
  8012b2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012b5:	90                   	nop
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 c4 f9 ff ff       	call   800c8a <strlen>
  8012c6:	83 c4 04             	add    $0x4,%esp
  8012c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012cc:	ff 75 0c             	pushl  0xc(%ebp)
  8012cf:	e8 b6 f9 ff ff       	call   800c8a <strlen>
  8012d4:	83 c4 04             	add    $0x4,%esp
  8012d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e8:	eb 17                	jmp    801301 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	01 c2                	add    %eax,%edx
  8012f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	01 c8                	add    %ecx,%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012fe:	ff 45 fc             	incl   -0x4(%ebp)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801307:	7c e1                	jl     8012ea <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801309:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801310:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801317:	eb 1f                	jmp    801338 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	8d 50 01             	lea    0x1(%eax),%edx
  80131f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801322:	89 c2                	mov    %eax,%edx
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	01 c2                	add    %eax,%edx
  801329:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	01 c8                	add    %ecx,%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801335:	ff 45 f8             	incl   -0x8(%ebp)
  801338:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80133e:	7c d9                	jl     801319 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801340:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801343:	8b 45 10             	mov    0x10(%ebp),%eax
  801346:	01 d0                	add    %edx,%eax
  801348:	c6 00 00             	movb   $0x0,(%eax)
}
  80134b:	90                   	nop
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801351:	8b 45 14             	mov    0x14(%ebp),%eax
  801354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80135a:	8b 45 14             	mov    0x14(%ebp),%eax
  80135d:	8b 00                	mov    (%eax),%eax
  80135f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801366:	8b 45 10             	mov    0x10(%ebp),%eax
  801369:	01 d0                	add    %edx,%eax
  80136b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801371:	eb 0c                	jmp    80137f <strsplit+0x31>
			*string++ = 0;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8d 50 01             	lea    0x1(%eax),%edx
  801379:	89 55 08             	mov    %edx,0x8(%ebp)
  80137c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	74 18                	je     8013a0 <strsplit+0x52>
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	0f be c0             	movsbl %al,%eax
  801390:	50                   	push   %eax
  801391:	ff 75 0c             	pushl  0xc(%ebp)
  801394:	e8 83 fa ff ff       	call   800e1c <strchr>
  801399:	83 c4 08             	add    $0x8,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	75 d3                	jne    801373 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	84 c0                	test   %al,%al
  8013a7:	74 5a                	je     801403 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ac:	8b 00                	mov    (%eax),%eax
  8013ae:	83 f8 0f             	cmp    $0xf,%eax
  8013b1:	75 07                	jne    8013ba <strsplit+0x6c>
		{
			return 0;
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b8:	eb 66                	jmp    801420 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013c5:	89 0a                	mov    %ecx,(%edx)
  8013c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	01 c2                	add    %eax,%edx
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d8:	eb 03                	jmp    8013dd <strsplit+0x8f>
			string++;
  8013da:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	84 c0                	test   %al,%al
  8013e4:	74 8b                	je     801371 <strsplit+0x23>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f be c0             	movsbl %al,%eax
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 0c             	pushl  0xc(%ebp)
  8013f2:	e8 25 fa ff ff       	call   800e1c <strchr>
  8013f7:	83 c4 08             	add    $0x8,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	74 dc                	je     8013da <strsplit+0x8c>
			string++;
	}
  8013fe:	e9 6e ff ff ff       	jmp    801371 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801403:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801404:	8b 45 14             	mov    0x14(%ebp),%eax
  801407:	8b 00                	mov    (%eax),%eax
  801409:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801410:	8b 45 10             	mov    0x10(%ebp),%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80141b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80142e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801435:	eb 4a                	jmp    801481 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801437:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	01 c2                	add    %eax,%edx
  80143f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c8                	add    %ecx,%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80144b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	01 d0                	add    %edx,%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	3c 40                	cmp    $0x40,%al
  801457:	7e 25                	jle    80147e <str2lower+0x5c>
  801459:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	01 d0                	add    %edx,%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	3c 5a                	cmp    $0x5a,%al
  801465:	7f 17                	jg     80147e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801467:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801472:	8b 55 08             	mov    0x8(%ebp),%edx
  801475:	01 ca                	add    %ecx,%edx
  801477:	8a 12                	mov    (%edx),%dl
  801479:	83 c2 20             	add    $0x20,%edx
  80147c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80147e:	ff 45 fc             	incl   -0x4(%ebp)
  801481:	ff 75 0c             	pushl  0xc(%ebp)
  801484:	e8 01 f8 ff ff       	call   800c8a <strlen>
  801489:	83 c4 04             	add    $0x4,%esp
  80148c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80148f:	7f a6                	jg     801437 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801491:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	57                   	push   %edi
  80149a:	56                   	push   %esi
  80149b:	53                   	push   %ebx
  80149c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014b1:	cd 30                	int    $0x30
  8014b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	5b                   	pop    %ebx
  8014bd:	5e                   	pop    %esi
  8014be:	5f                   	pop    %edi
  8014bf:	5d                   	pop    %ebp
  8014c0:	c3                   	ret    

008014c1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 04             	sub    $0x4,%esp
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	6a 00                	push   $0x0
  8014d9:	51                   	push   %ecx
  8014da:	52                   	push   %edx
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	50                   	push   %eax
  8014df:	6a 00                	push   $0x0
  8014e1:	e8 b0 ff ff ff       	call   801496 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
}
  8014e9:	90                   	nop
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_cgetc>:

int
sys_cgetc(void)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 02                	push   $0x2
  8014fb:	e8 96 ff ff ff       	call   801496 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 03                	push   $0x3
  801514:	e8 7d ff ff ff       	call   801496 <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	90                   	nop
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 04                	push   $0x4
  80152e:	e8 63 ff ff ff       	call   801496 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	90                   	nop
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80153c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	52                   	push   %edx
  801549:	50                   	push   %eax
  80154a:	6a 08                	push   $0x8
  80154c:	e8 45 ff ff ff       	call   801496 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	56                   	push   %esi
  80155a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80155b:	8b 75 18             	mov    0x18(%ebp),%esi
  80155e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801561:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801564:	8b 55 0c             	mov    0xc(%ebp),%edx
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	56                   	push   %esi
  80156b:	53                   	push   %ebx
  80156c:	51                   	push   %ecx
  80156d:	52                   	push   %edx
  80156e:	50                   	push   %eax
  80156f:	6a 09                	push   $0x9
  801571:	e8 20 ff ff ff       	call   801496 <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
}
  801579:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	ff 75 08             	pushl  0x8(%ebp)
  80158e:	6a 0a                	push   $0xa
  801590:	e8 01 ff ff ff       	call   801496 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	ff 75 0c             	pushl  0xc(%ebp)
  8015a6:	ff 75 08             	pushl  0x8(%ebp)
  8015a9:	6a 0b                	push   $0xb
  8015ab:	e8 e6 fe ff ff       	call   801496 <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 0c                	push   $0xc
  8015c4:	e8 cd fe ff ff       	call   801496 <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 0d                	push   $0xd
  8015dd:	e8 b4 fe ff ff       	call   801496 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 0e                	push   $0xe
  8015f6:	e8 9b fe ff ff       	call   801496 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 0f                	push   $0xf
  80160f:	e8 82 fe ff ff       	call   801496 <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	6a 10                	push   $0x10
  801629:	e8 68 fe ff ff       	call   801496 <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 11                	push   $0x11
  801642:	e8 4f fe ff ff       	call   801496 <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
}
  80164a:	90                   	nop
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_cputc>:

void
sys_cputc(const char c)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801659:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	50                   	push   %eax
  801666:	6a 01                	push   $0x1
  801668:	e8 29 fe ff ff       	call   801496 <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	90                   	nop
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 14                	push   $0x14
  801682:	e8 0f fe ff ff       	call   801496 <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
}
  80168a:	90                   	nop
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	8b 45 10             	mov    0x10(%ebp),%eax
  801696:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801699:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80169c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	51                   	push   %ecx
  8016a6:	52                   	push   %edx
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	50                   	push   %eax
  8016ab:	6a 15                	push   $0x15
  8016ad:	e8 e4 fd ff ff       	call   801496 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	52                   	push   %edx
  8016c7:	50                   	push   %eax
  8016c8:	6a 16                	push   $0x16
  8016ca:	e8 c7 fd ff ff       	call   801496 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	51                   	push   %ecx
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	6a 17                	push   $0x17
  8016e9:	e8 a8 fd ff ff       	call   801496 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	52                   	push   %edx
  801703:	50                   	push   %eax
  801704:	6a 18                	push   $0x18
  801706:	e8 8b fd ff ff       	call   801496 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	6a 00                	push   $0x0
  801718:	ff 75 14             	pushl  0x14(%ebp)
  80171b:	ff 75 10             	pushl  0x10(%ebp)
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	50                   	push   %eax
  801722:	6a 19                	push   $0x19
  801724:	e8 6d fd ff ff       	call   801496 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	50                   	push   %eax
  80173d:	6a 1a                	push   $0x1a
  80173f:	e8 52 fd ff ff       	call   801496 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	90                   	nop
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	50                   	push   %eax
  801759:	6a 1b                	push   $0x1b
  80175b:	e8 36 fd ff ff       	call   801496 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 05                	push   $0x5
  801774:	e8 1d fd ff ff       	call   801496 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 06                	push   $0x6
  80178d:	e8 04 fd ff ff       	call   801496 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 07                	push   $0x7
  8017a6:	e8 eb fc ff ff       	call   801496 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_exit_env>:


void sys_exit_env(void)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 1c                	push   $0x1c
  8017bf:	e8 d2 fc ff ff       	call   801496 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	90                   	nop
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d3:	8d 50 04             	lea    0x4(%eax),%edx
  8017d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	52                   	push   %edx
  8017e0:	50                   	push   %eax
  8017e1:	6a 1d                	push   $0x1d
  8017e3:	e8 ae fc ff ff       	call   801496 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
	return result;
  8017eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f4:	89 01                	mov    %eax,(%ecx)
  8017f6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	c9                   	leave  
  8017fd:	c2 04 00             	ret    $0x4

00801800 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	ff 75 10             	pushl  0x10(%ebp)
  80180a:	ff 75 0c             	pushl  0xc(%ebp)
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	6a 13                	push   $0x13
  801812:	e8 7f fc ff ff       	call   801496 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
	return ;
  80181a:	90                   	nop
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_rcr2>:
uint32 sys_rcr2()
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 1e                	push   $0x1e
  80182c:	e8 65 fc ff ff       	call   801496 <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 04             	sub    $0x4,%esp
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801842:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	50                   	push   %eax
  80184f:	6a 1f                	push   $0x1f
  801851:	e8 40 fc ff ff       	call   801496 <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
	return ;
  801859:	90                   	nop
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <rsttst>:
void rsttst()
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 21                	push   $0x21
  80186b:	e8 26 fc ff ff       	call   801496 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
	return ;
  801873:	90                   	nop
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 04             	sub    $0x4,%esp
  80187c:	8b 45 14             	mov    0x14(%ebp),%eax
  80187f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801882:	8b 55 18             	mov    0x18(%ebp),%edx
  801885:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801889:	52                   	push   %edx
  80188a:	50                   	push   %eax
  80188b:	ff 75 10             	pushl  0x10(%ebp)
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	6a 20                	push   $0x20
  801896:	e8 fb fb ff ff       	call   801496 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
	return ;
  80189e:	90                   	nop
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <chktst>:
void chktst(uint32 n)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	6a 22                	push   $0x22
  8018b1:	e8 e0 fb ff ff       	call   801496 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b9:	90                   	nop
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <inctst>:

void inctst()
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 23                	push   $0x23
  8018cb:	e8 c6 fb ff ff       	call   801496 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d3:	90                   	nop
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <gettst>:
uint32 gettst()
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 24                	push   $0x24
  8018e5:	e8 ac fb ff ff       	call   801496 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 25                	push   $0x25
  8018fe:	e8 93 fb ff ff       	call   801496 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
  801906:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80190b:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 26                	push   $0x26
  80192a:	e8 67 fb ff ff       	call   801496 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
	return ;
  801932:	90                   	nop
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801939:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80193c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	53                   	push   %ebx
  801948:	51                   	push   %ecx
  801949:	52                   	push   %edx
  80194a:	50                   	push   %eax
  80194b:	6a 27                	push   $0x27
  80194d:	e8 44 fb ff ff       	call   801496 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80195d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	6a 28                	push   $0x28
  80196d:	e8 24 fb ff ff       	call   801496 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80197a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80197d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	51                   	push   %ecx
  801986:	ff 75 10             	pushl  0x10(%ebp)
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	6a 29                	push   $0x29
  80198d:	e8 04 fb ff ff       	call   801496 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	ff 75 10             	pushl  0x10(%ebp)
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	6a 12                	push   $0x12
  8019a9:	e8 e8 fa ff ff       	call   801496 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b1:	90                   	nop
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 2a                	push   $0x2a
  8019c7:	e8 ca fa ff ff       	call   801496 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
	return;
  8019cf:	90                   	nop
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 2b                	push   $0x2b
  8019e1:	e8 b0 fa ff ff       	call   801496 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	ff 75 0c             	pushl  0xc(%ebp)
  8019f7:	ff 75 08             	pushl  0x8(%ebp)
  8019fa:	6a 2d                	push   $0x2d
  8019fc:	e8 95 fa ff ff       	call   801496 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
	return;
  801a04:	90                   	nop
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	ff 75 08             	pushl  0x8(%ebp)
  801a16:	6a 2c                	push   $0x2c
  801a18:	e8 79 fa ff ff       	call   801496 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a20:	90                   	nop
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	68 88 24 80 00       	push   $0x802488
  801a31:	68 25 01 00 00       	push   $0x125
  801a36:	68 bb 24 80 00       	push   $0x8024bb
  801a3b:	e8 a3 e8 ff ff       	call   8002e3 <_panic>

00801a40 <__udivdi3>:
  801a40:	55                   	push   %ebp
  801a41:	57                   	push   %edi
  801a42:	56                   	push   %esi
  801a43:	53                   	push   %ebx
  801a44:	83 ec 1c             	sub    $0x1c,%esp
  801a47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a57:	89 ca                	mov    %ecx,%edx
  801a59:	89 f8                	mov    %edi,%eax
  801a5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a5f:	85 f6                	test   %esi,%esi
  801a61:	75 2d                	jne    801a90 <__udivdi3+0x50>
  801a63:	39 cf                	cmp    %ecx,%edi
  801a65:	77 65                	ja     801acc <__udivdi3+0x8c>
  801a67:	89 fd                	mov    %edi,%ebp
  801a69:	85 ff                	test   %edi,%edi
  801a6b:	75 0b                	jne    801a78 <__udivdi3+0x38>
  801a6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a72:	31 d2                	xor    %edx,%edx
  801a74:	f7 f7                	div    %edi
  801a76:	89 c5                	mov    %eax,%ebp
  801a78:	31 d2                	xor    %edx,%edx
  801a7a:	89 c8                	mov    %ecx,%eax
  801a7c:	f7 f5                	div    %ebp
  801a7e:	89 c1                	mov    %eax,%ecx
  801a80:	89 d8                	mov    %ebx,%eax
  801a82:	f7 f5                	div    %ebp
  801a84:	89 cf                	mov    %ecx,%edi
  801a86:	89 fa                	mov    %edi,%edx
  801a88:	83 c4 1c             	add    $0x1c,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5f                   	pop    %edi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    
  801a90:	39 ce                	cmp    %ecx,%esi
  801a92:	77 28                	ja     801abc <__udivdi3+0x7c>
  801a94:	0f bd fe             	bsr    %esi,%edi
  801a97:	83 f7 1f             	xor    $0x1f,%edi
  801a9a:	75 40                	jne    801adc <__udivdi3+0x9c>
  801a9c:	39 ce                	cmp    %ecx,%esi
  801a9e:	72 0a                	jb     801aaa <__udivdi3+0x6a>
  801aa0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aa4:	0f 87 9e 00 00 00    	ja     801b48 <__udivdi3+0x108>
  801aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aaf:	89 fa                	mov    %edi,%edx
  801ab1:	83 c4 1c             	add    $0x1c,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
  801ab9:	8d 76 00             	lea    0x0(%esi),%esi
  801abc:	31 ff                	xor    %edi,%edi
  801abe:	31 c0                	xor    %eax,%eax
  801ac0:	89 fa                	mov    %edi,%edx
  801ac2:	83 c4 1c             	add    $0x1c,%esp
  801ac5:	5b                   	pop    %ebx
  801ac6:	5e                   	pop    %esi
  801ac7:	5f                   	pop    %edi
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    
  801aca:	66 90                	xchg   %ax,%ax
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	f7 f7                	div    %edi
  801ad0:	31 ff                	xor    %edi,%edi
  801ad2:	89 fa                	mov    %edi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ae1:	89 eb                	mov    %ebp,%ebx
  801ae3:	29 fb                	sub    %edi,%ebx
  801ae5:	89 f9                	mov    %edi,%ecx
  801ae7:	d3 e6                	shl    %cl,%esi
  801ae9:	89 c5                	mov    %eax,%ebp
  801aeb:	88 d9                	mov    %bl,%cl
  801aed:	d3 ed                	shr    %cl,%ebp
  801aef:	89 e9                	mov    %ebp,%ecx
  801af1:	09 f1                	or     %esi,%ecx
  801af3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801af7:	89 f9                	mov    %edi,%ecx
  801af9:	d3 e0                	shl    %cl,%eax
  801afb:	89 c5                	mov    %eax,%ebp
  801afd:	89 d6                	mov    %edx,%esi
  801aff:	88 d9                	mov    %bl,%cl
  801b01:	d3 ee                	shr    %cl,%esi
  801b03:	89 f9                	mov    %edi,%ecx
  801b05:	d3 e2                	shl    %cl,%edx
  801b07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0b:	88 d9                	mov    %bl,%cl
  801b0d:	d3 e8                	shr    %cl,%eax
  801b0f:	09 c2                	or     %eax,%edx
  801b11:	89 d0                	mov    %edx,%eax
  801b13:	89 f2                	mov    %esi,%edx
  801b15:	f7 74 24 0c          	divl   0xc(%esp)
  801b19:	89 d6                	mov    %edx,%esi
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	f7 e5                	mul    %ebp
  801b1f:	39 d6                	cmp    %edx,%esi
  801b21:	72 19                	jb     801b3c <__udivdi3+0xfc>
  801b23:	74 0b                	je     801b30 <__udivdi3+0xf0>
  801b25:	89 d8                	mov    %ebx,%eax
  801b27:	31 ff                	xor    %edi,%edi
  801b29:	e9 58 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b2e:	66 90                	xchg   %ax,%ax
  801b30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b34:	89 f9                	mov    %edi,%ecx
  801b36:	d3 e2                	shl    %cl,%edx
  801b38:	39 c2                	cmp    %eax,%edx
  801b3a:	73 e9                	jae    801b25 <__udivdi3+0xe5>
  801b3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b3f:	31 ff                	xor    %edi,%edi
  801b41:	e9 40 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b46:	66 90                	xchg   %ax,%ax
  801b48:	31 c0                	xor    %eax,%eax
  801b4a:	e9 37 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b4f:	90                   	nop

00801b50 <__umoddi3>:
  801b50:	55                   	push   %ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b6f:	89 f3                	mov    %esi,%ebx
  801b71:	89 fa                	mov    %edi,%edx
  801b73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b77:	89 34 24             	mov    %esi,(%esp)
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	75 1a                	jne    801b98 <__umoddi3+0x48>
  801b7e:	39 f7                	cmp    %esi,%edi
  801b80:	0f 86 a2 00 00 00    	jbe    801c28 <__umoddi3+0xd8>
  801b86:	89 c8                	mov    %ecx,%eax
  801b88:	89 f2                	mov    %esi,%edx
  801b8a:	f7 f7                	div    %edi
  801b8c:	89 d0                	mov    %edx,%eax
  801b8e:	31 d2                	xor    %edx,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	39 f0                	cmp    %esi,%eax
  801b9a:	0f 87 ac 00 00 00    	ja     801c4c <__umoddi3+0xfc>
  801ba0:	0f bd e8             	bsr    %eax,%ebp
  801ba3:	83 f5 1f             	xor    $0x1f,%ebp
  801ba6:	0f 84 ac 00 00 00    	je     801c58 <__umoddi3+0x108>
  801bac:	bf 20 00 00 00       	mov    $0x20,%edi
  801bb1:	29 ef                	sub    %ebp,%edi
  801bb3:	89 fe                	mov    %edi,%esi
  801bb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bb9:	89 e9                	mov    %ebp,%ecx
  801bbb:	d3 e0                	shl    %cl,%eax
  801bbd:	89 d7                	mov    %edx,%edi
  801bbf:	89 f1                	mov    %esi,%ecx
  801bc1:	d3 ef                	shr    %cl,%edi
  801bc3:	09 c7                	or     %eax,%edi
  801bc5:	89 e9                	mov    %ebp,%ecx
  801bc7:	d3 e2                	shl    %cl,%edx
  801bc9:	89 14 24             	mov    %edx,(%esp)
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	d3 e0                	shl    %cl,%eax
  801bd0:	89 c2                	mov    %eax,%edx
  801bd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd6:	d3 e0                	shl    %cl,%eax
  801bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be0:	89 f1                	mov    %esi,%ecx
  801be2:	d3 e8                	shr    %cl,%eax
  801be4:	09 d0                	or     %edx,%eax
  801be6:	d3 eb                	shr    %cl,%ebx
  801be8:	89 da                	mov    %ebx,%edx
  801bea:	f7 f7                	div    %edi
  801bec:	89 d3                	mov    %edx,%ebx
  801bee:	f7 24 24             	mull   (%esp)
  801bf1:	89 c6                	mov    %eax,%esi
  801bf3:	89 d1                	mov    %edx,%ecx
  801bf5:	39 d3                	cmp    %edx,%ebx
  801bf7:	0f 82 87 00 00 00    	jb     801c84 <__umoddi3+0x134>
  801bfd:	0f 84 91 00 00 00    	je     801c94 <__umoddi3+0x144>
  801c03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c07:	29 f2                	sub    %esi,%edx
  801c09:	19 cb                	sbb    %ecx,%ebx
  801c0b:	89 d8                	mov    %ebx,%eax
  801c0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c11:	d3 e0                	shl    %cl,%eax
  801c13:	89 e9                	mov    %ebp,%ecx
  801c15:	d3 ea                	shr    %cl,%edx
  801c17:	09 d0                	or     %edx,%eax
  801c19:	89 e9                	mov    %ebp,%ecx
  801c1b:	d3 eb                	shr    %cl,%ebx
  801c1d:	89 da                	mov    %ebx,%edx
  801c1f:	83 c4 1c             	add    $0x1c,%esp
  801c22:	5b                   	pop    %ebx
  801c23:	5e                   	pop    %esi
  801c24:	5f                   	pop    %edi
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    
  801c27:	90                   	nop
  801c28:	89 fd                	mov    %edi,%ebp
  801c2a:	85 ff                	test   %edi,%edi
  801c2c:	75 0b                	jne    801c39 <__umoddi3+0xe9>
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	31 d2                	xor    %edx,%edx
  801c35:	f7 f7                	div    %edi
  801c37:	89 c5                	mov    %eax,%ebp
  801c39:	89 f0                	mov    %esi,%eax
  801c3b:	31 d2                	xor    %edx,%edx
  801c3d:	f7 f5                	div    %ebp
  801c3f:	89 c8                	mov    %ecx,%eax
  801c41:	f7 f5                	div    %ebp
  801c43:	89 d0                	mov    %edx,%eax
  801c45:	e9 44 ff ff ff       	jmp    801b8e <__umoddi3+0x3e>
  801c4a:	66 90                	xchg   %ax,%ax
  801c4c:	89 c8                	mov    %ecx,%eax
  801c4e:	89 f2                	mov    %esi,%edx
  801c50:	83 c4 1c             	add    $0x1c,%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5f                   	pop    %edi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    
  801c58:	3b 04 24             	cmp    (%esp),%eax
  801c5b:	72 06                	jb     801c63 <__umoddi3+0x113>
  801c5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c61:	77 0f                	ja     801c72 <__umoddi3+0x122>
  801c63:	89 f2                	mov    %esi,%edx
  801c65:	29 f9                	sub    %edi,%ecx
  801c67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c6b:	89 14 24             	mov    %edx,(%esp)
  801c6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c76:	8b 14 24             	mov    (%esp),%edx
  801c79:	83 c4 1c             	add    $0x1c,%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5f                   	pop    %edi
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    
  801c81:	8d 76 00             	lea    0x0(%esi),%esi
  801c84:	2b 04 24             	sub    (%esp),%eax
  801c87:	19 fa                	sbb    %edi,%edx
  801c89:	89 d1                	mov    %edx,%ecx
  801c8b:	89 c6                	mov    %eax,%esi
  801c8d:	e9 71 ff ff ff       	jmp    801c03 <__umoddi3+0xb3>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c98:	72 ea                	jb     801c84 <__umoddi3+0x134>
  801c9a:	89 d9                	mov    %ebx,%ecx
  801c9c:	e9 62 ff ff ff       	jmp    801c03 <__umoddi3+0xb3>
