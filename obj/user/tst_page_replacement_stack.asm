
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
  800049:	e8 7c 15 00 00       	call   8015ca <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 bf 15 00 00       	call   801615 <sys_pf_calculate_allocated_pages>
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
  80008a:	e8 64 05 00 00       	call   8005f3 <cprintf_colored>
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
  8000bb:	e8 38 02 00 00       	call   8002f8 <_panic>
		arr[i] = -1 ;


	cprintf_colored(TEXT_cyan, "%~\nchecking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c0:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c7:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000ce:	7e cb                	jle    80009b <_main+0x63>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  10) panic("Unexpected extra/less pages have been added to page file");
  8000d0:	e8 40 15 00 00       	call   801615 <sys_pf_calculate_allocated_pages>
  8000d5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d8:	83 f8 0a             	cmp    $0xa,%eax
  8000db:	74 14                	je     8000f1 <_main+0xb9>
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	68 50 1d 80 00       	push   $0x801d50
  8000e5:	6a 1c                	push   $0x1c
  8000e7:	68 2c 1d 80 00       	push   $0x801d2c
  8000ec:	e8 07 02 00 00       	call   8002f8 <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000f1:	e8 d4 14 00 00       	call   8015ca <sys_calculate_free_frames>
  8000f6:	89 c3                	mov    %eax,%ebx
  8000f8:	e8 e6 14 00 00       	call   8015e3 <sys_calculate_modified_frames>
  8000fd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	39 c2                	cmp    %eax,%edx
  800105:	74 14                	je     80011b <_main+0xe3>
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	68 8c 1d 80 00       	push   $0x801d8c
  80010f:	6a 1e                	push   $0x1e
  800111:	68 2c 1d 80 00       	push   $0x801d2c
  800116:	e8 dd 01 00 00       	call   8002f8 <_panic>
	}//consider tables of PF, disk pages

	cprintf_colored(TEXT_light_green, "%~\nCongratulations: stack pages created, modified and read is completed successfully\n\n");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 f0 1d 80 00       	push   $0x801df0
  800123:	6a 0a                	push   $0xa
  800125:	e8 c9 04 00 00       	call   8005f3 <cprintf_colored>
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
  80013c:	e8 52 16 00 00       	call   801793 <sys_getenvindex>
  800141:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800147:	89 d0                	mov    %edx,%eax
  800149:	c1 e0 06             	shl    $0x6,%eax
  80014c:	29 d0                	sub    %edx,%eax
  80014e:	c1 e0 02             	shl    $0x2,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015a:	01 c8                	add    %ecx,%eax
  80015c:	c1 e0 03             	shl    $0x3,%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800168:	29 c2                	sub    %eax,%edx
  80016a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800171:	89 c2                	mov    %eax,%edx
  800173:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800179:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017e:	a1 20 30 80 00       	mov    0x803020,%eax
  800183:	8a 40 20             	mov    0x20(%eax),%al
  800186:	84 c0                	test   %al,%al
  800188:	74 0d                	je     800197 <libmain+0x64>
		binaryname = myEnv->prog_name;
  80018a:	a1 20 30 80 00       	mov    0x803020,%eax
  80018f:	83 c0 20             	add    $0x20,%eax
  800192:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800197:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019b:	7e 0a                	jle    8001a7 <libmain+0x74>
		binaryname = argv[0];
  80019d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	ff 75 0c             	pushl  0xc(%ebp)
  8001ad:	ff 75 08             	pushl  0x8(%ebp)
  8001b0:	e8 83 fe ff ff       	call   800038 <_main>
  8001b5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b8:	a1 00 30 80 00       	mov    0x803000,%eax
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	0f 84 01 01 00 00    	je     8002c6 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001c5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001cb:	bb 40 1f 80 00       	mov    $0x801f40,%ebx
  8001d0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001d5:	89 c7                	mov    %eax,%edi
  8001d7:	89 de                	mov    %ebx,%esi
  8001d9:	89 d1                	mov    %edx,%ecx
  8001db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001dd:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001e0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001e5:	b0 00                	mov    $0x0,%al
  8001e7:	89 d7                	mov    %edx,%edi
  8001e9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	50                   	push   %eax
  8001f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ff:	50                   	push   %eax
  800200:	e8 c4 17 00 00       	call   8019c9 <sys_utilities>
  800205:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800208:	e8 0d 13 00 00       	call   80151a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80020d:	83 ec 0c             	sub    $0xc,%esp
  800210:	68 60 1e 80 00       	push   $0x801e60
  800215:	e8 ac 03 00 00       	call   8005c6 <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80021d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800220:	85 c0                	test   %eax,%eax
  800222:	74 18                	je     80023c <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800224:	e8 be 17 00 00       	call   8019e7 <sys_get_optimal_num_faults>
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	50                   	push   %eax
  80022d:	68 88 1e 80 00       	push   $0x801e88
  800232:	e8 8f 03 00 00       	call   8005c6 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	eb 59                	jmp    800295 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80023c:	a1 20 30 80 00       	mov    0x803020,%eax
  800241:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800247:	a1 20 30 80 00       	mov    0x803020,%eax
  80024c:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	52                   	push   %edx
  800256:	50                   	push   %eax
  800257:	68 ac 1e 80 00       	push   $0x801eac
  80025c:	e8 65 03 00 00       	call   8005c6 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800264:	a1 20 30 80 00       	mov    0x803020,%eax
  800269:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80026f:	a1 20 30 80 00       	mov    0x803020,%eax
  800274:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80027a:	a1 20 30 80 00       	mov    0x803020,%eax
  80027f:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800285:	51                   	push   %ecx
  800286:	52                   	push   %edx
  800287:	50                   	push   %eax
  800288:	68 d4 1e 80 00       	push   $0x801ed4
  80028d:	e8 34 03 00 00       	call   8005c6 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800295:	a1 20 30 80 00       	mov    0x803020,%eax
  80029a:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	50                   	push   %eax
  8002a4:	68 2c 1f 80 00       	push   $0x801f2c
  8002a9:	e8 18 03 00 00       	call   8005c6 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002b1:	83 ec 0c             	sub    $0xc,%esp
  8002b4:	68 60 1e 80 00       	push   $0x801e60
  8002b9:	e8 08 03 00 00       	call   8005c6 <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002c1:	e8 6e 12 00 00       	call   801534 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002c6:	e8 1f 00 00 00       	call   8002ea <exit>
}
  8002cb:	90                   	nop
  8002cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5e                   	pop    %esi
  8002d1:	5f                   	pop    %edi
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    

008002d4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	6a 00                	push   $0x0
  8002df:	e8 7b 14 00 00       	call   80175f <sys_destroy_env>
  8002e4:	83 c4 10             	add    $0x10,%esp
}
  8002e7:	90                   	nop
  8002e8:	c9                   	leave  
  8002e9:	c3                   	ret    

008002ea <exit>:

void
exit(void)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f0:	e8 d0 14 00 00       	call   8017c5 <sys_exit_env>
}
  8002f5:	90                   	nop
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002fe:	8d 45 10             	lea    0x10(%ebp),%eax
  800301:	83 c0 04             	add    $0x4,%eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800307:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80030c:	85 c0                	test   %eax,%eax
  80030e:	74 16                	je     800326 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800310:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	50                   	push   %eax
  800319:	68 a4 1f 80 00       	push   $0x801fa4
  80031e:	e8 a3 02 00 00       	call   8005c6 <cprintf>
  800323:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800326:	a1 04 30 80 00       	mov    0x803004,%eax
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	50                   	push   %eax
  800335:	68 ac 1f 80 00       	push   $0x801fac
  80033a:	6a 74                	push   $0x74
  80033c:	e8 b2 02 00 00       	call   8005f3 <cprintf_colored>
  800341:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	83 ec 08             	sub    $0x8,%esp
  80034a:	ff 75 f4             	pushl  -0xc(%ebp)
  80034d:	50                   	push   %eax
  80034e:	e8 04 02 00 00       	call   800557 <vcprintf>
  800353:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	6a 00                	push   $0x0
  80035b:	68 d4 1f 80 00       	push   $0x801fd4
  800360:	e8 f2 01 00 00       	call   800557 <vcprintf>
  800365:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800368:	e8 7d ff ff ff       	call   8002ea <exit>

	// should not return here
	while (1) ;
  80036d:	eb fe                	jmp    80036d <_panic+0x75>

0080036f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800375:	a1 20 30 80 00       	mov    0x803020,%eax
  80037a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800380:	8b 45 0c             	mov    0xc(%ebp),%eax
  800383:	39 c2                	cmp    %eax,%edx
  800385:	74 14                	je     80039b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800387:	83 ec 04             	sub    $0x4,%esp
  80038a:	68 d8 1f 80 00       	push   $0x801fd8
  80038f:	6a 26                	push   $0x26
  800391:	68 24 20 80 00       	push   $0x802024
  800396:	e8 5d ff ff ff       	call   8002f8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80039b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a9:	e9 c5 00 00 00       	jmp    800473 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	85 c0                	test   %eax,%eax
  8003c1:	75 08                	jne    8003cb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003c3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c6:	e9 a5 00 00 00       	jmp    800470 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d9:	eb 69                	jmp    800444 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8003e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	01 c0                	add    %eax,%eax
  8003ed:	01 d0                	add    %edx,%eax
  8003ef:	c1 e0 03             	shl    $0x3,%eax
  8003f2:	01 c8                	add    %ecx,%eax
  8003f4:	8a 40 04             	mov    0x4(%eax),%al
  8003f7:	84 c0                	test   %al,%al
  8003f9:	75 46                	jne    800441 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800400:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800406:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800409:	89 d0                	mov    %edx,%eax
  80040b:	01 c0                	add    %eax,%eax
  80040d:	01 d0                	add    %edx,%eax
  80040f:	c1 e0 03             	shl    $0x3,%eax
  800412:	01 c8                	add    %ecx,%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800419:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80041c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800421:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800426:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	01 c8                	add    %ecx,%eax
  800432:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800434:	39 c2                	cmp    %eax,%edx
  800436:	75 09                	jne    800441 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800438:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80043f:	eb 15                	jmp    800456 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800441:	ff 45 e8             	incl   -0x18(%ebp)
  800444:	a1 20 30 80 00       	mov    0x803020,%eax
  800449:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80044f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800452:	39 c2                	cmp    %eax,%edx
  800454:	77 85                	ja     8003db <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80045a:	75 14                	jne    800470 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	68 30 20 80 00       	push   $0x802030
  800464:	6a 3a                	push   $0x3a
  800466:	68 24 20 80 00       	push   $0x802024
  80046b:	e8 88 fe ff ff       	call   8002f8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800470:	ff 45 f0             	incl   -0x10(%ebp)
  800473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800476:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800479:	0f 8c 2f ff ff ff    	jl     8003ae <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80047f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800486:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80048d:	eb 26                	jmp    8004b5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80048f:	a1 20 30 80 00       	mov    0x803020,%eax
  800494:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80049a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80049d:	89 d0                	mov    %edx,%eax
  80049f:	01 c0                	add    %eax,%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	c1 e0 03             	shl    $0x3,%eax
  8004a6:	01 c8                	add    %ecx,%eax
  8004a8:	8a 40 04             	mov    0x4(%eax),%al
  8004ab:	3c 01                	cmp    $0x1,%al
  8004ad:	75 03                	jne    8004b2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004af:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b2:	ff 45 e0             	incl   -0x20(%ebp)
  8004b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ba:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c3:	39 c2                	cmp    %eax,%edx
  8004c5:	77 c8                	ja     80048f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004cd:	74 14                	je     8004e3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004cf:	83 ec 04             	sub    $0x4,%esp
  8004d2:	68 84 20 80 00       	push   $0x802084
  8004d7:	6a 44                	push   $0x44
  8004d9:	68 24 20 80 00       	push   $0x802024
  8004de:	e8 15 fe ff ff       	call   8002f8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004e3:	90                   	nop
  8004e4:	c9                   	leave  
  8004e5:	c3                   	ret    

008004e6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	53                   	push   %ebx
  8004ea:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	8d 48 01             	lea    0x1(%eax),%ecx
  8004f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f8:	89 0a                	mov    %ecx,(%edx)
  8004fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fd:	88 d1                	mov    %dl,%cl
  8004ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800502:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800506:	8b 45 0c             	mov    0xc(%ebp),%eax
  800509:	8b 00                	mov    (%eax),%eax
  80050b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800510:	75 30                	jne    800542 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800512:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800518:	a0 44 30 80 00       	mov    0x803044,%al
  80051d:	0f b6 c0             	movzbl %al,%eax
  800520:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800523:	8b 09                	mov    (%ecx),%ecx
  800525:	89 cb                	mov    %ecx,%ebx
  800527:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052a:	83 c1 08             	add    $0x8,%ecx
  80052d:	52                   	push   %edx
  80052e:	50                   	push   %eax
  80052f:	53                   	push   %ebx
  800530:	51                   	push   %ecx
  800531:	e8 a0 0f 00 00       	call   8014d6 <sys_cputs>
  800536:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800542:	8b 45 0c             	mov    0xc(%ebp),%eax
  800545:	8b 40 04             	mov    0x4(%eax),%eax
  800548:	8d 50 01             	lea    0x1(%eax),%edx
  80054b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800551:	90                   	nop
  800552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800560:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800567:	00 00 00 
	b.cnt = 0;
  80056a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800571:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800574:	ff 75 0c             	pushl  0xc(%ebp)
  800577:	ff 75 08             	pushl  0x8(%ebp)
  80057a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800580:	50                   	push   %eax
  800581:	68 e6 04 80 00       	push   $0x8004e6
  800586:	e8 5a 02 00 00       	call   8007e5 <vprintfmt>
  80058b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80058e:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800594:	a0 44 30 80 00       	mov    0x803044,%al
  800599:	0f b6 c0             	movzbl %al,%eax
  80059c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005a2:	52                   	push   %edx
  8005a3:	50                   	push   %eax
  8005a4:	51                   	push   %ecx
  8005a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ab:	83 c0 08             	add    $0x8,%eax
  8005ae:	50                   	push   %eax
  8005af:	e8 22 0f 00 00       	call   8014d6 <sys_cputs>
  8005b4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005b7:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005cc:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005d3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e2:	50                   	push   %eax
  8005e3:	e8 6f ff ff ff       	call   800557 <vcprintf>
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f1:	c9                   	leave  
  8005f2:	c3                   	ret    

008005f3 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005f3:	55                   	push   %ebp
  8005f4:	89 e5                	mov    %esp,%ebp
  8005f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	c1 e0 08             	shl    $0x8,%eax
  800606:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80060b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800614:	8b 45 0c             	mov    0xc(%ebp),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 f4             	pushl  -0xc(%ebp)
  80061d:	50                   	push   %eax
  80061e:	e8 34 ff ff ff       	call   800557 <vcprintf>
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800629:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800630:	07 00 00 

	return cnt;
  800633:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800636:	c9                   	leave  
  800637:	c3                   	ret    

00800638 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80063e:	e8 d7 0e 00 00       	call   80151a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800643:	8d 45 0c             	lea    0xc(%ebp),%eax
  800646:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	ff 75 f4             	pushl  -0xc(%ebp)
  800652:	50                   	push   %eax
  800653:	e8 ff fe ff ff       	call   800557 <vcprintf>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80065e:	e8 d1 0e 00 00       	call   801534 <sys_unlock_cons>
	return cnt;
  800663:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800666:	c9                   	leave  
  800667:	c3                   	ret    

00800668 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	53                   	push   %ebx
  80066c:	83 ec 14             	sub    $0x14,%esp
  80066f:	8b 45 10             	mov    0x10(%ebp),%eax
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80067b:	8b 45 18             	mov    0x18(%ebp),%eax
  80067e:	ba 00 00 00 00       	mov    $0x0,%edx
  800683:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800686:	77 55                	ja     8006dd <printnum+0x75>
  800688:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80068b:	72 05                	jb     800692 <printnum+0x2a>
  80068d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800690:	77 4b                	ja     8006dd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800692:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800695:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800698:	8b 45 18             	mov    0x18(%ebp),%eax
  80069b:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a0:	52                   	push   %edx
  8006a1:	50                   	push   %eax
  8006a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8006a8:	e8 ab 13 00 00       	call   801a58 <__udivdi3>
  8006ad:	83 c4 10             	add    $0x10,%esp
  8006b0:	83 ec 04             	sub    $0x4,%esp
  8006b3:	ff 75 20             	pushl  0x20(%ebp)
  8006b6:	53                   	push   %ebx
  8006b7:	ff 75 18             	pushl  0x18(%ebp)
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	ff 75 0c             	pushl  0xc(%ebp)
  8006bf:	ff 75 08             	pushl  0x8(%ebp)
  8006c2:	e8 a1 ff ff ff       	call   800668 <printnum>
  8006c7:	83 c4 20             	add    $0x20,%esp
  8006ca:	eb 1a                	jmp    8006e6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 20             	pushl  0x20(%ebp)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	ff d0                	call   *%eax
  8006da:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006dd:	ff 4d 1c             	decl   0x1c(%ebp)
  8006e0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006e4:	7f e6                	jg     8006cc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006f4:	53                   	push   %ebx
  8006f5:	51                   	push   %ecx
  8006f6:	52                   	push   %edx
  8006f7:	50                   	push   %eax
  8006f8:	e8 6b 14 00 00       	call   801b68 <__umoddi3>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	05 f4 22 80 00       	add    $0x8022f4,%eax
  800705:	8a 00                	mov    (%eax),%al
  800707:	0f be c0             	movsbl %al,%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	50                   	push   %eax
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	ff d0                	call   *%eax
  800716:	83 c4 10             	add    $0x10,%esp
}
  800719:	90                   	nop
  80071a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800722:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800726:	7e 1c                	jle    800744 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 08             	lea    0x8(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 08             	sub    $0x8,%eax
  80073d:	8b 50 04             	mov    0x4(%eax),%edx
  800740:	8b 00                	mov    (%eax),%eax
  800742:	eb 40                	jmp    800784 <getuint+0x65>
	else if (lflag)
  800744:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800748:	74 1e                	je     800768 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	8d 50 04             	lea    0x4(%eax),%edx
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	89 10                	mov    %edx,(%eax)
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	83 e8 04             	sub    $0x4,%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	ba 00 00 00 00       	mov    $0x0,%edx
  800766:	eb 1c                	jmp    800784 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	8d 50 04             	lea    0x4(%eax),%edx
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	89 10                	mov    %edx,(%eax)
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	83 e8 04             	sub    $0x4,%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800789:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80078d:	7e 1c                	jle    8007ab <getint+0x25>
		return va_arg(*ap, long long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 08             	lea    0x8(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 08             	sub    $0x8,%eax
  8007a4:	8b 50 04             	mov    0x4(%eax),%edx
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	eb 38                	jmp    8007e3 <getint+0x5d>
	else if (lflag)
  8007ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007af:	74 1a                	je     8007cb <getint+0x45>
		return va_arg(*ap, long);
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	8d 50 04             	lea    0x4(%eax),%edx
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	89 10                	mov    %edx,(%eax)
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	83 e8 04             	sub    $0x4,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	99                   	cltd   
  8007c9:	eb 18                	jmp    8007e3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	8d 50 04             	lea    0x4(%eax),%edx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	89 10                	mov    %edx,(%eax)
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	83 e8 04             	sub    $0x4,%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	99                   	cltd   
}
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	56                   	push   %esi
  8007e9:	53                   	push   %ebx
  8007ea:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ed:	eb 17                	jmp    800806 <vprintfmt+0x21>
			if (ch == '\0')
  8007ef:	85 db                	test   %ebx,%ebx
  8007f1:	0f 84 c1 03 00 00    	je     800bb8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	53                   	push   %ebx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800806:	8b 45 10             	mov    0x10(%ebp),%eax
  800809:	8d 50 01             	lea    0x1(%eax),%edx
  80080c:	89 55 10             	mov    %edx,0x10(%ebp)
  80080f:	8a 00                	mov    (%eax),%al
  800811:	0f b6 d8             	movzbl %al,%ebx
  800814:	83 fb 25             	cmp    $0x25,%ebx
  800817:	75 d6                	jne    8007ef <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800819:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80081d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800824:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80082b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800832:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800839:	8b 45 10             	mov    0x10(%ebp),%eax
  80083c:	8d 50 01             	lea    0x1(%eax),%edx
  80083f:	89 55 10             	mov    %edx,0x10(%ebp)
  800842:	8a 00                	mov    (%eax),%al
  800844:	0f b6 d8             	movzbl %al,%ebx
  800847:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80084a:	83 f8 5b             	cmp    $0x5b,%eax
  80084d:	0f 87 3d 03 00 00    	ja     800b90 <vprintfmt+0x3ab>
  800853:	8b 04 85 18 23 80 00 	mov    0x802318(,%eax,4),%eax
  80085a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80085c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800860:	eb d7                	jmp    800839 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800862:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800866:	eb d1                	jmp    800839 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800868:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80086f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800872:	89 d0                	mov    %edx,%eax
  800874:	c1 e0 02             	shl    $0x2,%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	01 c0                	add    %eax,%eax
  80087b:	01 d8                	add    %ebx,%eax
  80087d:	83 e8 30             	sub    $0x30,%eax
  800880:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800883:	8b 45 10             	mov    0x10(%ebp),%eax
  800886:	8a 00                	mov    (%eax),%al
  800888:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80088b:	83 fb 2f             	cmp    $0x2f,%ebx
  80088e:	7e 3e                	jle    8008ce <vprintfmt+0xe9>
  800890:	83 fb 39             	cmp    $0x39,%ebx
  800893:	7f 39                	jg     8008ce <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800895:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800898:	eb d5                	jmp    80086f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 c0 04             	add    $0x4,%eax
  8008a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	83 e8 04             	sub    $0x4,%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008ae:	eb 1f                	jmp    8008cf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b4:	79 83                	jns    800839 <vprintfmt+0x54>
				width = 0;
  8008b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008bd:	e9 77 ff ff ff       	jmp    800839 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008c2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008c9:	e9 6b ff ff ff       	jmp    800839 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ce:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d3:	0f 89 60 ff ff ff    	jns    800839 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008e6:	e9 4e ff ff ff       	jmp    800839 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008eb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ee:	e9 46 ff ff ff       	jmp    800839 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	83 c0 04             	add    $0x4,%eax
  8008f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	83 e8 04             	sub    $0x4,%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	50                   	push   %eax
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
			break;
  800913:	e9 9b 02 00 00       	jmp    800bb3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	83 c0 04             	add    $0x4,%eax
  80091e:	89 45 14             	mov    %eax,0x14(%ebp)
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	83 e8 04             	sub    $0x4,%eax
  800927:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800929:	85 db                	test   %ebx,%ebx
  80092b:	79 02                	jns    80092f <vprintfmt+0x14a>
				err = -err;
  80092d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80092f:	83 fb 64             	cmp    $0x64,%ebx
  800932:	7f 0b                	jg     80093f <vprintfmt+0x15a>
  800934:	8b 34 9d 60 21 80 00 	mov    0x802160(,%ebx,4),%esi
  80093b:	85 f6                	test   %esi,%esi
  80093d:	75 19                	jne    800958 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80093f:	53                   	push   %ebx
  800940:	68 05 23 80 00       	push   $0x802305
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	ff 75 08             	pushl  0x8(%ebp)
  80094b:	e8 70 02 00 00       	call   800bc0 <printfmt>
  800950:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800953:	e9 5b 02 00 00       	jmp    800bb3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800958:	56                   	push   %esi
  800959:	68 0e 23 80 00       	push   $0x80230e
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	ff 75 08             	pushl  0x8(%ebp)
  800964:	e8 57 02 00 00       	call   800bc0 <printfmt>
  800969:	83 c4 10             	add    $0x10,%esp
			break;
  80096c:	e9 42 02 00 00       	jmp    800bb3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	83 c0 04             	add    $0x4,%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
  80097a:	8b 45 14             	mov    0x14(%ebp),%eax
  80097d:	83 e8 04             	sub    $0x4,%eax
  800980:	8b 30                	mov    (%eax),%esi
  800982:	85 f6                	test   %esi,%esi
  800984:	75 05                	jne    80098b <vprintfmt+0x1a6>
				p = "(null)";
  800986:	be 11 23 80 00       	mov    $0x802311,%esi
			if (width > 0 && padc != '-')
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	7e 6d                	jle    8009fe <vprintfmt+0x219>
  800991:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800995:	74 67                	je     8009fe <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800997:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	50                   	push   %eax
  80099e:	56                   	push   %esi
  80099f:	e8 1e 03 00 00       	call   800cc2 <strnlen>
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009aa:	eb 16                	jmp    8009c2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009ac:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	50                   	push   %eax
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e4                	jg     8009ac <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c8:	eb 34                	jmp    8009fe <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ce:	74 1c                	je     8009ec <vprintfmt+0x207>
  8009d0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d3:	7e 05                	jle    8009da <vprintfmt+0x1f5>
  8009d5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d8:	7e 12                	jle    8009ec <vprintfmt+0x207>
					putch('?', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 3f                	push   $0x3f
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
  8009ea:	eb 0f                	jmp    8009fb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fe:	89 f0                	mov    %esi,%eax
  800a00:	8d 70 01             	lea    0x1(%eax),%esi
  800a03:	8a 00                	mov    (%eax),%al
  800a05:	0f be d8             	movsbl %al,%ebx
  800a08:	85 db                	test   %ebx,%ebx
  800a0a:	74 24                	je     800a30 <vprintfmt+0x24b>
  800a0c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a10:	78 b8                	js     8009ca <vprintfmt+0x1e5>
  800a12:	ff 4d e0             	decl   -0x20(%ebp)
  800a15:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a19:	79 af                	jns    8009ca <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1b:	eb 13                	jmp    800a30 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 20                	push   $0x20
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7f e7                	jg     800a1d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a36:	e9 78 01 00 00       	jmp    800bb3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a41:	8d 45 14             	lea    0x14(%ebp),%eax
  800a44:	50                   	push   %eax
  800a45:	e8 3c fd ff ff       	call   800786 <getint>
  800a4a:	83 c4 10             	add    $0x10,%esp
  800a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a50:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a59:	85 d2                	test   %edx,%edx
  800a5b:	79 23                	jns    800a80 <vprintfmt+0x29b>
				putch('-', putdat);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 0c             	pushl  0xc(%ebp)
  800a63:	6a 2d                	push   $0x2d
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	ff d0                	call   *%eax
  800a6a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a73:	f7 d8                	neg    %eax
  800a75:	83 d2 00             	adc    $0x0,%edx
  800a78:	f7 da                	neg    %edx
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a87:	e9 bc 00 00 00       	jmp    800b48 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a92:	8d 45 14             	lea    0x14(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	e8 84 fc ff ff       	call   80071f <getuint>
  800a9b:	83 c4 10             	add    $0x10,%esp
  800a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aa4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aab:	e9 98 00 00 00       	jmp    800b48 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	6a 58                	push   $0x58
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	ff d0                	call   *%eax
  800abd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 58                	push   $0x58
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	6a 58                	push   $0x58
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
			break;
  800ae0:	e9 ce 00 00 00       	jmp    800bb3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	6a 30                	push   $0x30
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	ff d0                	call   *%eax
  800af2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 78                	push   $0x78
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b05:	8b 45 14             	mov    0x14(%ebp),%eax
  800b08:	83 c0 04             	add    $0x4,%eax
  800b0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	83 e8 04             	sub    $0x4,%eax
  800b14:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b27:	eb 1f                	jmp    800b48 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 e7 fb ff ff       	call   80071f <getuint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b41:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b48:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b4f:	83 ec 04             	sub    $0x4,%esp
  800b52:	52                   	push   %edx
  800b53:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b56:	50                   	push   %eax
  800b57:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b5d:	ff 75 0c             	pushl  0xc(%ebp)
  800b60:	ff 75 08             	pushl  0x8(%ebp)
  800b63:	e8 00 fb ff ff       	call   800668 <printnum>
  800b68:	83 c4 20             	add    $0x20,%esp
			break;
  800b6b:	eb 46                	jmp    800bb3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	53                   	push   %ebx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			break;
  800b7c:	eb 35                	jmp    800bb3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b7e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b85:	eb 2c                	jmp    800bb3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b87:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b8e:	eb 23                	jmp    800bb3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	6a 25                	push   $0x25
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba0:	ff 4d 10             	decl   0x10(%ebp)
  800ba3:	eb 03                	jmp    800ba8 <vprintfmt+0x3c3>
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bab:	48                   	dec    %eax
  800bac:	8a 00                	mov    (%eax),%al
  800bae:	3c 25                	cmp    $0x25,%al
  800bb0:	75 f3                	jne    800ba5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bb2:	90                   	nop
		}
	}
  800bb3:	e9 35 fc ff ff       	jmp    8007ed <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 04 fc ff ff       	call   8007e5 <vprintfmt>
  800be1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be4:	90                   	nop
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    

00800be7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bed:	8b 40 08             	mov    0x8(%eax),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	8b 10                	mov    (%eax),%edx
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 40 04             	mov    0x4(%eax),%eax
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	73 12                	jae    800c1a <sprintputch+0x33>
		*b->buf++ = ch;
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	8b 00                	mov    (%eax),%eax
  800c0d:	8d 48 01             	lea    0x1(%eax),%ecx
  800c10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c13:	89 0a                	mov    %ecx,(%edx)
  800c15:	8b 55 08             	mov    0x8(%ebp),%edx
  800c18:	88 10                	mov    %dl,(%eax)
}
  800c1a:	90                   	nop
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	01 d0                	add    %edx,%eax
  800c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c42:	74 06                	je     800c4a <vsnprintf+0x2d>
  800c44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c48:	7f 07                	jg     800c51 <vsnprintf+0x34>
		return -E_INVAL;
  800c4a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c4f:	eb 20                	jmp    800c71 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c51:	ff 75 14             	pushl  0x14(%ebp)
  800c54:	ff 75 10             	pushl  0x10(%ebp)
  800c57:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5a:	50                   	push   %eax
  800c5b:	68 e7 0b 80 00       	push   $0x800be7
  800c60:	e8 80 fb ff ff       	call   8007e5 <vprintfmt>
  800c65:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c79:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7c:	83 c0 04             	add    $0x4,%eax
  800c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c82:	8b 45 10             	mov    0x10(%ebp),%eax
  800c85:	ff 75 f4             	pushl  -0xc(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	ff 75 08             	pushl  0x8(%ebp)
  800c8f:	e8 89 ff ff ff       	call   800c1d <vsnprintf>
  800c94:	83 c4 10             	add    $0x10,%esp
  800c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cac:	eb 06                	jmp    800cb4 <strlen+0x15>
		n++;
  800cae:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb1:	ff 45 08             	incl   0x8(%ebp)
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	84 c0                	test   %al,%al
  800cbb:	75 f1                	jne    800cae <strlen+0xf>
		n++;
	return n;
  800cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ccf:	eb 09                	jmp    800cda <strnlen+0x18>
		n++;
  800cd1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd4:	ff 45 08             	incl   0x8(%ebp)
  800cd7:	ff 4d 0c             	decl   0xc(%ebp)
  800cda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cde:	74 09                	je     800ce9 <strnlen+0x27>
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	84 c0                	test   %al,%al
  800ce7:	75 e8                	jne    800cd1 <strnlen+0xf>
		n++;
	return n;
  800ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cfa:	90                   	nop
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8d 50 01             	lea    0x1(%eax),%edx
  800d01:	89 55 08             	mov    %edx,0x8(%ebp)
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d07:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0d:	8a 12                	mov    (%edx),%dl
  800d0f:	88 10                	mov    %dl,(%eax)
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	84 c0                	test   %al,%al
  800d15:	75 e4                	jne    800cfb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d2f:	eb 1f                	jmp    800d50 <strncpy+0x34>
		*dst++ = *src;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8d 50 01             	lea    0x1(%eax),%edx
  800d37:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3d:	8a 12                	mov    (%edx),%dl
  800d3f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	84 c0                	test   %al,%al
  800d48:	74 03                	je     800d4d <strncpy+0x31>
			src++;
  800d4a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4d:	ff 45 fc             	incl   -0x4(%ebp)
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d53:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d56:	72 d9                	jb     800d31 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d58:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6d:	74 30                	je     800d9f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d6f:	eb 16                	jmp    800d87 <strlcpy+0x2a>
			*dst++ = *src++;
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8d 50 01             	lea    0x1(%eax),%edx
  800d77:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d83:	8a 12                	mov    (%edx),%dl
  800d85:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d87:	ff 4d 10             	decl   0x10(%ebp)
  800d8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8e:	74 09                	je     800d99 <strlcpy+0x3c>
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	84 c0                	test   %al,%al
  800d97:	75 d8                	jne    800d71 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da5:	29 c2                	sub    %eax,%edx
  800da7:	89 d0                	mov    %edx,%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dae:	eb 06                	jmp    800db6 <strcmp+0xb>
		p++, q++;
  800db0:	ff 45 08             	incl   0x8(%ebp)
  800db3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	74 0e                	je     800dcd <strcmp+0x22>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 10                	mov    (%eax),%dl
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	38 c2                	cmp    %al,%dl
  800dcb:	74 e3                	je     800db0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	0f b6 d0             	movzbl %al,%edx
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	0f b6 c0             	movzbl %al,%eax
  800ddd:	29 c2                	sub    %eax,%edx
  800ddf:	89 d0                	mov    %edx,%eax
}
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de6:	eb 09                	jmp    800df1 <strncmp+0xe>
		n--, p++, q++;
  800de8:	ff 4d 10             	decl   0x10(%ebp)
  800deb:	ff 45 08             	incl   0x8(%ebp)
  800dee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	74 17                	je     800e0e <strncmp+0x2b>
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	84 c0                	test   %al,%al
  800dfe:	74 0e                	je     800e0e <strncmp+0x2b>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 10                	mov    (%eax),%dl
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	38 c2                	cmp    %al,%dl
  800e0c:	74 da                	je     800de8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e12:	75 07                	jne    800e1b <strncmp+0x38>
		return 0;
  800e14:	b8 00 00 00 00       	mov    $0x0,%eax
  800e19:	eb 14                	jmp    800e2f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f b6 d0             	movzbl %al,%edx
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	0f b6 c0             	movzbl %al,%eax
  800e2b:	29 c2                	sub    %eax,%edx
  800e2d:	89 d0                	mov    %edx,%eax
}
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    

00800e31 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 04             	sub    $0x4,%esp
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3d:	eb 12                	jmp    800e51 <strchr+0x20>
		if (*s == c)
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e47:	75 05                	jne    800e4e <strchr+0x1d>
			return (char *) s;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	eb 11                	jmp    800e5f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4e:	ff 45 08             	incl   0x8(%ebp)
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	84 c0                	test   %al,%al
  800e58:	75 e5                	jne    800e3f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6d:	eb 0d                	jmp    800e7c <strfind+0x1b>
		if (*s == c)
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e77:	74 0e                	je     800e87 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e79:	ff 45 08             	incl   0x8(%ebp)
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	84 c0                	test   %al,%al
  800e83:	75 ea                	jne    800e6f <strfind+0xe>
  800e85:	eb 01                	jmp    800e88 <strfind+0x27>
		if (*s == c)
			break;
  800e87:	90                   	nop
	return (char *) s;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e99:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e9d:	76 63                	jbe    800f02 <memset+0x75>
		uint64 data_block = c;
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	99                   	cltd   
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eaf:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800eb3:	c1 e0 08             	shl    $0x8,%eax
  800eb6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ec6:	c1 e0 10             	shl    $0x10,%eax
  800ec9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ecc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed5:	89 c2                	mov    %eax,%edx
  800ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  800edc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800edf:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ee2:	eb 18                	jmp    800efc <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ee4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ee7:	8d 41 08             	lea    0x8(%ecx),%eax
  800eea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef3:	89 01                	mov    %eax,(%ecx)
  800ef5:	89 51 04             	mov    %edx,0x4(%ecx)
  800ef8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800efc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f00:	77 e2                	ja     800ee4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f06:	74 23                	je     800f2b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f0e:	eb 0e                	jmp    800f1e <memset+0x91>
			*p8++ = (uint8)c;
  800f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f13:	8d 50 01             	lea    0x1(%eax),%edx
  800f16:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f21:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f24:	89 55 10             	mov    %edx,0x10(%ebp)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	75 e5                	jne    800f10 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f42:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f46:	76 24                	jbe    800f6c <memcpy+0x3c>
		while(n >= 8){
  800f48:	eb 1c                	jmp    800f66 <memcpy+0x36>
			*d64 = *s64;
  800f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4d:	8b 50 04             	mov    0x4(%eax),%edx
  800f50:	8b 00                	mov    (%eax),%eax
  800f52:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f55:	89 01                	mov    %eax,(%ecx)
  800f57:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f5a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f5e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f62:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f66:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f6a:	77 de                	ja     800f4a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f70:	74 31                	je     800fa3 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f7e:	eb 16                	jmp    800f96 <memcpy+0x66>
			*d8++ = *s8++;
  800f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f83:	8d 50 01             	lea    0x1(%eax),%edx
  800f86:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f92:	8a 12                	mov    (%edx),%dl
  800f94:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	75 dd                	jne    800f80 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa6:	c9                   	leave  
  800fa7:	c3                   	ret    

00800fa8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc0:	73 50                	jae    801012 <memmove+0x6a>
  800fc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc8:	01 d0                	add    %edx,%eax
  800fca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fcd:	76 43                	jbe    801012 <memmove+0x6a>
		s += n;
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fdb:	eb 10                	jmp    800fed <memmove+0x45>
			*--d = *--s;
  800fdd:	ff 4d f8             	decl   -0x8(%ebp)
  800fe0:	ff 4d fc             	decl   -0x4(%ebp)
  800fe3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe6:	8a 10                	mov    (%eax),%dl
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	75 e3                	jne    800fdd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ffa:	eb 23                	jmp    80101f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801005:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801008:	8d 4a 01             	lea    0x1(%edx),%ecx
  80100b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80100e:	8a 12                	mov    (%edx),%dl
  801010:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801012:	8b 45 10             	mov    0x10(%ebp),%eax
  801015:	8d 50 ff             	lea    -0x1(%eax),%edx
  801018:	89 55 10             	mov    %edx,0x10(%ebp)
  80101b:	85 c0                	test   %eax,%eax
  80101d:	75 dd                	jne    800ffc <memmove+0x54>
			*d++ = *s++;

	return dst;
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801022:	c9                   	leave  
  801023:	c3                   	ret    

00801024 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801036:	eb 2a                	jmp    801062 <memcmp+0x3e>
		if (*s1 != *s2)
  801038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103b:	8a 10                	mov    (%eax),%dl
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	38 c2                	cmp    %al,%dl
  801044:	74 16                	je     80105c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801046:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	0f b6 d0             	movzbl %al,%edx
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	0f b6 c0             	movzbl %al,%eax
  801056:	29 c2                	sub    %eax,%edx
  801058:	89 d0                	mov    %edx,%eax
  80105a:	eb 18                	jmp    801074 <memcmp+0x50>
		s1++, s2++;
  80105c:	ff 45 fc             	incl   -0x4(%ebp)
  80105f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801062:	8b 45 10             	mov    0x10(%ebp),%eax
  801065:	8d 50 ff             	lea    -0x1(%eax),%edx
  801068:	89 55 10             	mov    %edx,0x10(%ebp)
  80106b:	85 c0                	test   %eax,%eax
  80106d:	75 c9                	jne    801038 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80107c:	8b 55 08             	mov    0x8(%ebp),%edx
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801087:	eb 15                	jmp    80109e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	0f b6 d0             	movzbl %al,%edx
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	0f b6 c0             	movzbl %al,%eax
  801097:	39 c2                	cmp    %eax,%edx
  801099:	74 0d                	je     8010a8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a4:	72 e3                	jb     801089 <memfind+0x13>
  8010a6:	eb 01                	jmp    8010a9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a8:	90                   	nop
	return (void *) s;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c2:	eb 03                	jmp    8010c7 <strtol+0x19>
		s++;
  8010c4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 20                	cmp    $0x20,%al
  8010ce:	74 f4                	je     8010c4 <strtol+0x16>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3c 09                	cmp    $0x9,%al
  8010d7:	74 eb                	je     8010c4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 2b                	cmp    $0x2b,%al
  8010e0:	75 05                	jne    8010e7 <strtol+0x39>
		s++;
  8010e2:	ff 45 08             	incl   0x8(%ebp)
  8010e5:	eb 13                	jmp    8010fa <strtol+0x4c>
	else if (*s == '-')
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	3c 2d                	cmp    $0x2d,%al
  8010ee:	75 0a                	jne    8010fa <strtol+0x4c>
		s++, neg = 1;
  8010f0:	ff 45 08             	incl   0x8(%ebp)
  8010f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fe:	74 06                	je     801106 <strtol+0x58>
  801100:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801104:	75 20                	jne    801126 <strtol+0x78>
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	3c 30                	cmp    $0x30,%al
  80110d:	75 17                	jne    801126 <strtol+0x78>
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	40                   	inc    %eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 78                	cmp    $0x78,%al
  801117:	75 0d                	jne    801126 <strtol+0x78>
		s += 2, base = 16;
  801119:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80111d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801124:	eb 28                	jmp    80114e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801126:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112a:	75 15                	jne    801141 <strtol+0x93>
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	3c 30                	cmp    $0x30,%al
  801133:	75 0c                	jne    801141 <strtol+0x93>
		s++, base = 8;
  801135:	ff 45 08             	incl   0x8(%ebp)
  801138:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80113f:	eb 0d                	jmp    80114e <strtol+0xa0>
	else if (base == 0)
  801141:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801145:	75 07                	jne    80114e <strtol+0xa0>
		base = 10;
  801147:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	3c 2f                	cmp    $0x2f,%al
  801155:	7e 19                	jle    801170 <strtol+0xc2>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 39                	cmp    $0x39,%al
  80115e:	7f 10                	jg     801170 <strtol+0xc2>
			dig = *s - '0';
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	0f be c0             	movsbl %al,%eax
  801168:	83 e8 30             	sub    $0x30,%eax
  80116b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116e:	eb 42                	jmp    8011b2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	3c 60                	cmp    $0x60,%al
  801177:	7e 19                	jle    801192 <strtol+0xe4>
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3c 7a                	cmp    $0x7a,%al
  801180:	7f 10                	jg     801192 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f be c0             	movsbl %al,%eax
  80118a:	83 e8 57             	sub    $0x57,%eax
  80118d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801190:	eb 20                	jmp    8011b2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	3c 40                	cmp    $0x40,%al
  801199:	7e 39                	jle    8011d4 <strtol+0x126>
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	3c 5a                	cmp    $0x5a,%al
  8011a2:	7f 30                	jg     8011d4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	0f be c0             	movsbl %al,%eax
  8011ac:	83 e8 37             	sub    $0x37,%eax
  8011af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b8:	7d 19                	jge    8011d3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ba:	ff 45 08             	incl   0x8(%ebp)
  8011bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011c4:	89 c2                	mov    %eax,%edx
  8011c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c9:	01 d0                	add    %edx,%eax
  8011cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011ce:	e9 7b ff ff ff       	jmp    80114e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011d3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d8:	74 08                	je     8011e2 <strtol+0x134>
		*endptr = (char *) s;
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e6:	74 07                	je     8011ef <strtol+0x141>
  8011e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011eb:	f7 d8                	neg    %eax
  8011ed:	eb 03                	jmp    8011f2 <strtol+0x144>
  8011ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <ltostr>:

void
ltostr(long value, char *str)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801201:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801208:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120c:	79 13                	jns    801221 <ltostr+0x2d>
	{
		neg = 1;
  80120e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801215:	8b 45 0c             	mov    0xc(%ebp),%eax
  801218:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80121b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80121e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801229:	99                   	cltd   
  80122a:	f7 f9                	idiv   %ecx
  80122c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80122f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801232:	8d 50 01             	lea    0x1(%eax),%edx
  801235:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801238:	89 c2                	mov    %eax,%edx
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	01 d0                	add    %edx,%eax
  80123f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801242:	83 c2 30             	add    $0x30,%edx
  801245:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801247:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80124a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124f:	f7 e9                	imul   %ecx
  801251:	c1 fa 02             	sar    $0x2,%edx
  801254:	89 c8                	mov    %ecx,%eax
  801256:	c1 f8 1f             	sar    $0x1f,%eax
  801259:	29 c2                	sub    %eax,%edx
  80125b:	89 d0                	mov    %edx,%eax
  80125d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801264:	75 bb                	jne    801221 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80126d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801270:	48                   	dec    %eax
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801274:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801278:	74 3d                	je     8012b7 <ltostr+0xc3>
		start = 1 ;
  80127a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801281:	eb 34                	jmp    8012b7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 d0                	add    %edx,%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801293:	8b 45 0c             	mov    0xc(%ebp),%eax
  801296:	01 c2                	add    %eax,%edx
  801298:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	01 c8                	add    %ecx,%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012af:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012bd:	7c c4                	jl     801283 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	01 d0                	add    %edx,%eax
  8012c7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ca:	90                   	nop
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d3:	ff 75 08             	pushl  0x8(%ebp)
  8012d6:	e8 c4 f9 ff ff       	call   800c9f <strlen>
  8012db:	83 c4 04             	add    $0x4,%esp
  8012de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e1:	ff 75 0c             	pushl  0xc(%ebp)
  8012e4:	e8 b6 f9 ff ff       	call   800c9f <strlen>
  8012e9:	83 c4 04             	add    $0x4,%esp
  8012ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fd:	eb 17                	jmp    801316 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801302:	8b 45 10             	mov    0x10(%ebp),%eax
  801305:	01 c2                	add    %eax,%edx
  801307:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	01 c8                	add    %ecx,%eax
  80130f:	8a 00                	mov    (%eax),%al
  801311:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801313:	ff 45 fc             	incl   -0x4(%ebp)
  801316:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801319:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131c:	7c e1                	jl     8012ff <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80131e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801325:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132c:	eb 1f                	jmp    80134d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80132e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801331:	8d 50 01             	lea    0x1(%eax),%edx
  801334:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801337:	89 c2                	mov    %eax,%edx
  801339:	8b 45 10             	mov    0x10(%ebp),%eax
  80133c:	01 c2                	add    %eax,%edx
  80133e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c8                	add    %ecx,%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134a:	ff 45 f8             	incl   -0x8(%ebp)
  80134d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801350:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801353:	7c d9                	jl     80132e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801355:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 d0                	add    %edx,%eax
  80135d:	c6 00 00             	movb   $0x0,(%eax)
}
  801360:	90                   	nop
  801361:	c9                   	leave  
  801362:	c3                   	ret    

00801363 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136f:	8b 45 14             	mov    0x14(%ebp),%eax
  801372:	8b 00                	mov    (%eax),%eax
  801374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137b:	8b 45 10             	mov    0x10(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801386:	eb 0c                	jmp    801394 <strsplit+0x31>
			*string++ = 0;
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8d 50 01             	lea    0x1(%eax),%edx
  80138e:	89 55 08             	mov    %edx,0x8(%ebp)
  801391:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	84 c0                	test   %al,%al
  80139b:	74 18                	je     8013b5 <strsplit+0x52>
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	8a 00                	mov    (%eax),%al
  8013a2:	0f be c0             	movsbl %al,%eax
  8013a5:	50                   	push   %eax
  8013a6:	ff 75 0c             	pushl  0xc(%ebp)
  8013a9:	e8 83 fa ff ff       	call   800e31 <strchr>
  8013ae:	83 c4 08             	add    $0x8,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	75 d3                	jne    801388 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	8a 00                	mov    (%eax),%al
  8013ba:	84 c0                	test   %al,%al
  8013bc:	74 5a                	je     801418 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013be:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c1:	8b 00                	mov    (%eax),%eax
  8013c3:	83 f8 0f             	cmp    $0xf,%eax
  8013c6:	75 07                	jne    8013cf <strsplit+0x6c>
		{
			return 0;
  8013c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cd:	eb 66                	jmp    801435 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d7:	8b 55 14             	mov    0x14(%ebp),%edx
  8013da:	89 0a                	mov    %ecx,(%edx)
  8013dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e6:	01 c2                	add    %eax,%edx
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ed:	eb 03                	jmp    8013f2 <strsplit+0x8f>
			string++;
  8013ef:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	84 c0                	test   %al,%al
  8013f9:	74 8b                	je     801386 <strsplit+0x23>
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	50                   	push   %eax
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	e8 25 fa ff ff       	call   800e31 <strchr>
  80140c:	83 c4 08             	add    $0x8,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	74 dc                	je     8013ef <strsplit+0x8c>
			string++;
	}
  801413:	e9 6e ff ff ff       	jmp    801386 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801418:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801419:	8b 45 14             	mov    0x14(%ebp),%eax
  80141c:	8b 00                	mov    (%eax),%eax
  80141e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801425:	8b 45 10             	mov    0x10(%ebp),%eax
  801428:	01 d0                	add    %edx,%eax
  80142a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801430:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 4a                	jmp    801496 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80144c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	01 c2                	add    %eax,%edx
  801454:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	01 c8                	add    %ecx,%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801460:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801463:	8b 45 0c             	mov    0xc(%ebp),%eax
  801466:	01 d0                	add    %edx,%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	3c 40                	cmp    $0x40,%al
  80146c:	7e 25                	jle    801493 <str2lower+0x5c>
  80146e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 d0                	add    %edx,%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	3c 5a                	cmp    $0x5a,%al
  80147a:	7f 17                	jg     801493 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80147c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	01 d0                	add    %edx,%eax
  801484:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801487:	8b 55 08             	mov    0x8(%ebp),%edx
  80148a:	01 ca                	add    %ecx,%edx
  80148c:	8a 12                	mov    (%edx),%dl
  80148e:	83 c2 20             	add    $0x20,%edx
  801491:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801493:	ff 45 fc             	incl   -0x4(%ebp)
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	e8 01 f8 ff ff       	call   800c9f <strlen>
  80149e:	83 c4 04             	add    $0x4,%esp
  8014a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014a4:	7f a6                	jg     80144c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	57                   	push   %edi
  8014af:	56                   	push   %esi
  8014b0:	53                   	push   %ebx
  8014b1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014c3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014c6:	cd 30                	int    $0x30
  8014c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5f                   	pop    %edi
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    

008014d6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 04             	sub    $0x4,%esp
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	6a 00                	push   $0x0
  8014ee:	51                   	push   %ecx
  8014ef:	52                   	push   %edx
  8014f0:	ff 75 0c             	pushl  0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	6a 00                	push   $0x0
  8014f6:	e8 b0 ff ff ff       	call   8014ab <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
}
  8014fe:	90                   	nop
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_cgetc>:

int
sys_cgetc(void)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 02                	push   $0x2
  801510:	e8 96 ff ff ff       	call   8014ab <syscall>
  801515:	83 c4 18             	add    $0x18,%esp
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 03                	push   $0x3
  801529:	e8 7d ff ff ff       	call   8014ab <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	90                   	nop
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 04                	push   $0x4
  801543:	e8 63 ff ff ff       	call   8014ab <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	90                   	nop
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	52                   	push   %edx
  80155e:	50                   	push   %eax
  80155f:	6a 08                	push   $0x8
  801561:	e8 45 ff ff ff       	call   8014ab <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	56                   	push   %esi
  80156f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801570:	8b 75 18             	mov    0x18(%ebp),%esi
  801573:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801576:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
  801581:	51                   	push   %ecx
  801582:	52                   	push   %edx
  801583:	50                   	push   %eax
  801584:	6a 09                	push   $0x9
  801586:	e8 20 ff ff ff       	call   8014ab <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801591:	5b                   	pop    %ebx
  801592:	5e                   	pop    %esi
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    

00801595 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	ff 75 08             	pushl  0x8(%ebp)
  8015a3:	6a 0a                	push   $0xa
  8015a5:	e8 01 ff ff ff       	call   8014ab <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	ff 75 0c             	pushl  0xc(%ebp)
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	6a 0b                	push   $0xb
  8015c0:	e8 e6 fe ff ff       	call   8014ab <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 0c                	push   $0xc
  8015d9:	e8 cd fe ff ff       	call   8014ab <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 0d                	push   $0xd
  8015f2:	e8 b4 fe ff ff       	call   8014ab <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 0e                	push   $0xe
  80160b:	e8 9b fe ff ff       	call   8014ab <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 0f                	push   $0xf
  801624:	e8 82 fe ff ff       	call   8014ab <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	ff 75 08             	pushl  0x8(%ebp)
  80163c:	6a 10                	push   $0x10
  80163e:	e8 68 fe ff ff       	call   8014ab <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 11                	push   $0x11
  801657:	e8 4f fe ff ff       	call   8014ab <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	90                   	nop
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_cputc>:

void
sys_cputc(const char c)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80166e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	50                   	push   %eax
  80167b:	6a 01                	push   $0x1
  80167d:	e8 29 fe ff ff       	call   8014ab <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 14                	push   $0x14
  801697:	e8 0f fe ff ff       	call   8014ab <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	90                   	nop
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 04             	sub    $0x4,%esp
  8016a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	51                   	push   %ecx
  8016bb:	52                   	push   %edx
  8016bc:	ff 75 0c             	pushl  0xc(%ebp)
  8016bf:	50                   	push   %eax
  8016c0:	6a 15                	push   $0x15
  8016c2:	e8 e4 fd ff ff       	call   8014ab <syscall>
  8016c7:	83 c4 18             	add    $0x18,%esp
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	52                   	push   %edx
  8016dc:	50                   	push   %eax
  8016dd:	6a 16                	push   $0x16
  8016df:	e8 c7 fd ff ff       	call   8014ab <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	51                   	push   %ecx
  8016fa:	52                   	push   %edx
  8016fb:	50                   	push   %eax
  8016fc:	6a 17                	push   $0x17
  8016fe:	e8 a8 fd ff ff       	call   8014ab <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80170b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	52                   	push   %edx
  801718:	50                   	push   %eax
  801719:	6a 18                	push   $0x18
  80171b:	e8 8b fd ff ff       	call   8014ab <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	ff 75 14             	pushl  0x14(%ebp)
  801730:	ff 75 10             	pushl  0x10(%ebp)
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	50                   	push   %eax
  801737:	6a 19                	push   $0x19
  801739:	e8 6d fd ff ff       	call   8014ab <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	50                   	push   %eax
  801752:	6a 1a                	push   $0x1a
  801754:	e8 52 fd ff ff       	call   8014ab <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	90                   	nop
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	50                   	push   %eax
  80176e:	6a 1b                	push   $0x1b
  801770:	e8 36 fd ff ff       	call   8014ab <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 05                	push   $0x5
  801789:	e8 1d fd ff ff       	call   8014ab <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 06                	push   $0x6
  8017a2:	e8 04 fd ff ff       	call   8014ab <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 07                	push   $0x7
  8017bb:	e8 eb fc ff ff       	call   8014ab <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_exit_env>:


void sys_exit_env(void)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 1c                	push   $0x1c
  8017d4:	e8 d2 fc ff ff       	call   8014ab <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	90                   	nop
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017e5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e8:	8d 50 04             	lea    0x4(%eax),%edx
  8017eb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	52                   	push   %edx
  8017f5:	50                   	push   %eax
  8017f6:	6a 1d                	push   $0x1d
  8017f8:	e8 ae fc ff ff       	call   8014ab <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
	return result;
  801800:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801803:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801806:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801809:	89 01                	mov    %eax,(%ecx)
  80180b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	c9                   	leave  
  801812:	c2 04 00             	ret    $0x4

00801815 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	ff 75 10             	pushl  0x10(%ebp)
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	6a 13                	push   $0x13
  801827:	e8 7f fc ff ff       	call   8014ab <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
	return ;
  80182f:	90                   	nop
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_rcr2>:
uint32 sys_rcr2()
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 1e                	push   $0x1e
  801841:	e8 65 fc ff ff       	call   8014ab <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 04             	sub    $0x4,%esp
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801857:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	50                   	push   %eax
  801864:	6a 1f                	push   $0x1f
  801866:	e8 40 fc ff ff       	call   8014ab <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
	return ;
  80186e:	90                   	nop
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <rsttst>:
void rsttst()
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 21                	push   $0x21
  801880:	e8 26 fc ff ff       	call   8014ab <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
	return ;
  801888:	90                   	nop
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	83 ec 04             	sub    $0x4,%esp
  801891:	8b 45 14             	mov    0x14(%ebp),%eax
  801894:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801897:	8b 55 18             	mov    0x18(%ebp),%edx
  80189a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	ff 75 10             	pushl  0x10(%ebp)
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	ff 75 08             	pushl  0x8(%ebp)
  8018a9:	6a 20                	push   $0x20
  8018ab:	e8 fb fb ff ff       	call   8014ab <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b3:	90                   	nop
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <chktst>:
void chktst(uint32 n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	6a 22                	push   $0x22
  8018c6:	e8 e0 fb ff ff       	call   8014ab <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ce:	90                   	nop
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <inctst>:

void inctst()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 23                	push   $0x23
  8018e0:	e8 c6 fb ff ff       	call   8014ab <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e8:	90                   	nop
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <gettst>:
uint32 gettst()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 24                	push   $0x24
  8018fa:	e8 ac fb ff ff       	call   8014ab <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 25                	push   $0x25
  801913:	e8 93 fb ff ff       	call   8014ab <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
  80191b:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801920:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	6a 26                	push   $0x26
  80193f:	e8 67 fb ff ff       	call   8014ab <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return ;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80194e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801951:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801954:	8b 55 0c             	mov    0xc(%ebp),%edx
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	6a 00                	push   $0x0
  80195c:	53                   	push   %ebx
  80195d:	51                   	push   %ecx
  80195e:	52                   	push   %edx
  80195f:	50                   	push   %eax
  801960:	6a 27                	push   $0x27
  801962:	e8 44 fb ff ff       	call   8014ab <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801972:	8b 55 0c             	mov    0xc(%ebp),%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	52                   	push   %edx
  80197f:	50                   	push   %eax
  801980:	6a 28                	push   $0x28
  801982:	e8 24 fb ff ff       	call   8014ab <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80198f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	51                   	push   %ecx
  80199b:	ff 75 10             	pushl  0x10(%ebp)
  80199e:	52                   	push   %edx
  80199f:	50                   	push   %eax
  8019a0:	6a 29                	push   $0x29
  8019a2:	e8 04 fb ff ff       	call   8014ab <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 10             	pushl  0x10(%ebp)
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	6a 12                	push   $0x12
  8019be:	e8 e8 fa ff ff       	call   8014ab <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	52                   	push   %edx
  8019d9:	50                   	push   %eax
  8019da:	6a 2a                	push   $0x2a
  8019dc:	e8 ca fa ff ff       	call   8014ab <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
	return;
  8019e4:	90                   	nop
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 2b                	push   $0x2b
  8019f6:	e8 b0 fa ff ff       	call   8014ab <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	6a 2d                	push   $0x2d
  801a11:	e8 95 fa ff ff       	call   8014ab <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
	return;
  801a19:	90                   	nop
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	ff 75 08             	pushl  0x8(%ebp)
  801a2b:	6a 2c                	push   $0x2c
  801a2d:	e8 79 fa ff ff       	call   8014ab <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
	return ;
  801a35:	90                   	nop
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	68 88 24 80 00       	push   $0x802488
  801a46:	68 25 01 00 00       	push   $0x125
  801a4b:	68 bb 24 80 00       	push   $0x8024bb
  801a50:	e8 a3 e8 ff ff       	call   8002f8 <_panic>
  801a55:	66 90                	xchg   %ax,%ax
  801a57:	90                   	nop

00801a58 <__udivdi3>:
  801a58:	55                   	push   %ebp
  801a59:	57                   	push   %edi
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 1c             	sub    $0x1c,%esp
  801a5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a6f:	89 ca                	mov    %ecx,%edx
  801a71:	89 f8                	mov    %edi,%eax
  801a73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a77:	85 f6                	test   %esi,%esi
  801a79:	75 2d                	jne    801aa8 <__udivdi3+0x50>
  801a7b:	39 cf                	cmp    %ecx,%edi
  801a7d:	77 65                	ja     801ae4 <__udivdi3+0x8c>
  801a7f:	89 fd                	mov    %edi,%ebp
  801a81:	85 ff                	test   %edi,%edi
  801a83:	75 0b                	jne    801a90 <__udivdi3+0x38>
  801a85:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8a:	31 d2                	xor    %edx,%edx
  801a8c:	f7 f7                	div    %edi
  801a8e:	89 c5                	mov    %eax,%ebp
  801a90:	31 d2                	xor    %edx,%edx
  801a92:	89 c8                	mov    %ecx,%eax
  801a94:	f7 f5                	div    %ebp
  801a96:	89 c1                	mov    %eax,%ecx
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	f7 f5                	div    %ebp
  801a9c:	89 cf                	mov    %ecx,%edi
  801a9e:	89 fa                	mov    %edi,%edx
  801aa0:	83 c4 1c             	add    $0x1c,%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5f                   	pop    %edi
  801aa6:	5d                   	pop    %ebp
  801aa7:	c3                   	ret    
  801aa8:	39 ce                	cmp    %ecx,%esi
  801aaa:	77 28                	ja     801ad4 <__udivdi3+0x7c>
  801aac:	0f bd fe             	bsr    %esi,%edi
  801aaf:	83 f7 1f             	xor    $0x1f,%edi
  801ab2:	75 40                	jne    801af4 <__udivdi3+0x9c>
  801ab4:	39 ce                	cmp    %ecx,%esi
  801ab6:	72 0a                	jb     801ac2 <__udivdi3+0x6a>
  801ab8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801abc:	0f 87 9e 00 00 00    	ja     801b60 <__udivdi3+0x108>
  801ac2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac7:	89 fa                	mov    %edi,%edx
  801ac9:	83 c4 1c             	add    $0x1c,%esp
  801acc:	5b                   	pop    %ebx
  801acd:	5e                   	pop    %esi
  801ace:	5f                   	pop    %edi
  801acf:	5d                   	pop    %ebp
  801ad0:	c3                   	ret    
  801ad1:	8d 76 00             	lea    0x0(%esi),%esi
  801ad4:	31 ff                	xor    %edi,%edi
  801ad6:	31 c0                	xor    %eax,%eax
  801ad8:	89 fa                	mov    %edi,%edx
  801ada:	83 c4 1c             	add    $0x1c,%esp
  801add:	5b                   	pop    %ebx
  801ade:	5e                   	pop    %esi
  801adf:	5f                   	pop    %edi
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    
  801ae2:	66 90                	xchg   %ax,%ax
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	f7 f7                	div    %edi
  801ae8:	31 ff                	xor    %edi,%edi
  801aea:	89 fa                	mov    %edi,%edx
  801aec:	83 c4 1c             	add    $0x1c,%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5f                   	pop    %edi
  801af2:	5d                   	pop    %ebp
  801af3:	c3                   	ret    
  801af4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801af9:	89 eb                	mov    %ebp,%ebx
  801afb:	29 fb                	sub    %edi,%ebx
  801afd:	89 f9                	mov    %edi,%ecx
  801aff:	d3 e6                	shl    %cl,%esi
  801b01:	89 c5                	mov    %eax,%ebp
  801b03:	88 d9                	mov    %bl,%cl
  801b05:	d3 ed                	shr    %cl,%ebp
  801b07:	89 e9                	mov    %ebp,%ecx
  801b09:	09 f1                	or     %esi,%ecx
  801b0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b0f:	89 f9                	mov    %edi,%ecx
  801b11:	d3 e0                	shl    %cl,%eax
  801b13:	89 c5                	mov    %eax,%ebp
  801b15:	89 d6                	mov    %edx,%esi
  801b17:	88 d9                	mov    %bl,%cl
  801b19:	d3 ee                	shr    %cl,%esi
  801b1b:	89 f9                	mov    %edi,%ecx
  801b1d:	d3 e2                	shl    %cl,%edx
  801b1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b23:	88 d9                	mov    %bl,%cl
  801b25:	d3 e8                	shr    %cl,%eax
  801b27:	09 c2                	or     %eax,%edx
  801b29:	89 d0                	mov    %edx,%eax
  801b2b:	89 f2                	mov    %esi,%edx
  801b2d:	f7 74 24 0c          	divl   0xc(%esp)
  801b31:	89 d6                	mov    %edx,%esi
  801b33:	89 c3                	mov    %eax,%ebx
  801b35:	f7 e5                	mul    %ebp
  801b37:	39 d6                	cmp    %edx,%esi
  801b39:	72 19                	jb     801b54 <__udivdi3+0xfc>
  801b3b:	74 0b                	je     801b48 <__udivdi3+0xf0>
  801b3d:	89 d8                	mov    %ebx,%eax
  801b3f:	31 ff                	xor    %edi,%edi
  801b41:	e9 58 ff ff ff       	jmp    801a9e <__udivdi3+0x46>
  801b46:	66 90                	xchg   %ax,%ax
  801b48:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b4c:	89 f9                	mov    %edi,%ecx
  801b4e:	d3 e2                	shl    %cl,%edx
  801b50:	39 c2                	cmp    %eax,%edx
  801b52:	73 e9                	jae    801b3d <__udivdi3+0xe5>
  801b54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b57:	31 ff                	xor    %edi,%edi
  801b59:	e9 40 ff ff ff       	jmp    801a9e <__udivdi3+0x46>
  801b5e:	66 90                	xchg   %ax,%ax
  801b60:	31 c0                	xor    %eax,%eax
  801b62:	e9 37 ff ff ff       	jmp    801a9e <__udivdi3+0x46>
  801b67:	90                   	nop

00801b68 <__umoddi3>:
  801b68:	55                   	push   %ebp
  801b69:	57                   	push   %edi
  801b6a:	56                   	push   %esi
  801b6b:	53                   	push   %ebx
  801b6c:	83 ec 1c             	sub    $0x1c,%esp
  801b6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b73:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b87:	89 f3                	mov    %esi,%ebx
  801b89:	89 fa                	mov    %edi,%edx
  801b8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b8f:	89 34 24             	mov    %esi,(%esp)
  801b92:	85 c0                	test   %eax,%eax
  801b94:	75 1a                	jne    801bb0 <__umoddi3+0x48>
  801b96:	39 f7                	cmp    %esi,%edi
  801b98:	0f 86 a2 00 00 00    	jbe    801c40 <__umoddi3+0xd8>
  801b9e:	89 c8                	mov    %ecx,%eax
  801ba0:	89 f2                	mov    %esi,%edx
  801ba2:	f7 f7                	div    %edi
  801ba4:	89 d0                	mov    %edx,%eax
  801ba6:	31 d2                	xor    %edx,%edx
  801ba8:	83 c4 1c             	add    $0x1c,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5f                   	pop    %edi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    
  801bb0:	39 f0                	cmp    %esi,%eax
  801bb2:	0f 87 ac 00 00 00    	ja     801c64 <__umoddi3+0xfc>
  801bb8:	0f bd e8             	bsr    %eax,%ebp
  801bbb:	83 f5 1f             	xor    $0x1f,%ebp
  801bbe:	0f 84 ac 00 00 00    	je     801c70 <__umoddi3+0x108>
  801bc4:	bf 20 00 00 00       	mov    $0x20,%edi
  801bc9:	29 ef                	sub    %ebp,%edi
  801bcb:	89 fe                	mov    %edi,%esi
  801bcd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bd1:	89 e9                	mov    %ebp,%ecx
  801bd3:	d3 e0                	shl    %cl,%eax
  801bd5:	89 d7                	mov    %edx,%edi
  801bd7:	89 f1                	mov    %esi,%ecx
  801bd9:	d3 ef                	shr    %cl,%edi
  801bdb:	09 c7                	or     %eax,%edi
  801bdd:	89 e9                	mov    %ebp,%ecx
  801bdf:	d3 e2                	shl    %cl,%edx
  801be1:	89 14 24             	mov    %edx,(%esp)
  801be4:	89 d8                	mov    %ebx,%eax
  801be6:	d3 e0                	shl    %cl,%eax
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bee:	d3 e0                	shl    %cl,%eax
  801bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bf8:	89 f1                	mov    %esi,%ecx
  801bfa:	d3 e8                	shr    %cl,%eax
  801bfc:	09 d0                	or     %edx,%eax
  801bfe:	d3 eb                	shr    %cl,%ebx
  801c00:	89 da                	mov    %ebx,%edx
  801c02:	f7 f7                	div    %edi
  801c04:	89 d3                	mov    %edx,%ebx
  801c06:	f7 24 24             	mull   (%esp)
  801c09:	89 c6                	mov    %eax,%esi
  801c0b:	89 d1                	mov    %edx,%ecx
  801c0d:	39 d3                	cmp    %edx,%ebx
  801c0f:	0f 82 87 00 00 00    	jb     801c9c <__umoddi3+0x134>
  801c15:	0f 84 91 00 00 00    	je     801cac <__umoddi3+0x144>
  801c1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c1f:	29 f2                	sub    %esi,%edx
  801c21:	19 cb                	sbb    %ecx,%ebx
  801c23:	89 d8                	mov    %ebx,%eax
  801c25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c29:	d3 e0                	shl    %cl,%eax
  801c2b:	89 e9                	mov    %ebp,%ecx
  801c2d:	d3 ea                	shr    %cl,%edx
  801c2f:	09 d0                	or     %edx,%eax
  801c31:	89 e9                	mov    %ebp,%ecx
  801c33:	d3 eb                	shr    %cl,%ebx
  801c35:	89 da                	mov    %ebx,%edx
  801c37:	83 c4 1c             	add    $0x1c,%esp
  801c3a:	5b                   	pop    %ebx
  801c3b:	5e                   	pop    %esi
  801c3c:	5f                   	pop    %edi
  801c3d:	5d                   	pop    %ebp
  801c3e:	c3                   	ret    
  801c3f:	90                   	nop
  801c40:	89 fd                	mov    %edi,%ebp
  801c42:	85 ff                	test   %edi,%edi
  801c44:	75 0b                	jne    801c51 <__umoddi3+0xe9>
  801c46:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4b:	31 d2                	xor    %edx,%edx
  801c4d:	f7 f7                	div    %edi
  801c4f:	89 c5                	mov    %eax,%ebp
  801c51:	89 f0                	mov    %esi,%eax
  801c53:	31 d2                	xor    %edx,%edx
  801c55:	f7 f5                	div    %ebp
  801c57:	89 c8                	mov    %ecx,%eax
  801c59:	f7 f5                	div    %ebp
  801c5b:	89 d0                	mov    %edx,%eax
  801c5d:	e9 44 ff ff ff       	jmp    801ba6 <__umoddi3+0x3e>
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	89 c8                	mov    %ecx,%eax
  801c66:	89 f2                	mov    %esi,%edx
  801c68:	83 c4 1c             	add    $0x1c,%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5f                   	pop    %edi
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    
  801c70:	3b 04 24             	cmp    (%esp),%eax
  801c73:	72 06                	jb     801c7b <__umoddi3+0x113>
  801c75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c79:	77 0f                	ja     801c8a <__umoddi3+0x122>
  801c7b:	89 f2                	mov    %esi,%edx
  801c7d:	29 f9                	sub    %edi,%ecx
  801c7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c83:	89 14 24             	mov    %edx,(%esp)
  801c86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c8e:	8b 14 24             	mov    (%esp),%edx
  801c91:	83 c4 1c             	add    $0x1c,%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	5f                   	pop    %edi
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    
  801c99:	8d 76 00             	lea    0x0(%esi),%esi
  801c9c:	2b 04 24             	sub    (%esp),%eax
  801c9f:	19 fa                	sbb    %edi,%edx
  801ca1:	89 d1                	mov    %edx,%ecx
  801ca3:	89 c6                	mov    %eax,%esi
  801ca5:	e9 71 ff ff ff       	jmp    801c1b <__umoddi3+0xb3>
  801caa:	66 90                	xchg   %ax,%ax
  801cac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cb0:	72 ea                	jb     801c9c <__umoddi3+0x134>
  801cb2:	89 d9                	mov    %ebx,%ecx
  801cb4:	e9 62 ff ff ff       	jmp    801c1b <__umoddi3+0xb3>
