
obj/user/tst_page_replacement_mod_clock_2:     file format elf32-i386


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
  800031:	e8 2b 03 00 00       	call   800361 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x802000, 0x808000,
		0x827000,
		0x809000, 0x800000, 0x803000, 0x801000, 0x804000,0x80B000,0x80C000
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 4c             	sub    $0x4c,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  800041:	6a 01                	push   $0x1
  800043:	68 00 00 80 00       	push   $0x800000
  800048:	6a 0b                	push   $0xb
  80004a:	68 20 30 80 00       	push   $0x803020
  80004f:	e8 51 1b 00 00       	call   801ba5 <sys_check_WS_list>
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  80005a:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 e0 1e 80 00       	push   $0x801ee0
  800068:	6a 22                	push   $0x22
  80006a:	68 54 1f 80 00       	push   $0x801f54
  80006f:	e8 9d 04 00 00       	call   800511 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800074:	e8 6a 17 00 00       	call   8017e3 <sys_calculate_free_frames>
  800079:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007c:	e8 ad 17 00 00       	call   80182e <sys_pf_calculate_allocated_pages>
  800081:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	uint32 va;
	char invPageCmd[20] = "__InvPage__";
  800084:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  800087:	bb 8c 22 80 00       	mov    $0x80228c,%ebx
  80008c:	ba 03 00 00 00       	mov    $0x3,%edx
  800091:	89 c7                	mov    %eax,%edi
  800093:	89 de                	mov    %ebx,%esi
  800095:	89 d1                	mov    %edx,%ecx
  800097:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800099:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8000a0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)

	//Remove some pages from the WS
	cprintf_colored(TEXT_cyan, "%~\nRemove some pages from the WS... \n");
  8000a7:	83 ec 08             	sub    $0x8,%esp
  8000aa:	68 7c 1f 80 00       	push   $0x801f7c
  8000af:	6a 03                	push   $0x3
  8000b1:	e8 56 07 00 00       	call   80080c <cprintf_colored>
  8000b6:	83 c4 10             	add    $0x10,%esp
	{
		va = 0x805000;
  8000b9:	c7 45 d0 00 50 80 00 	movl   $0x805000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8000c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	50                   	push   %eax
  8000c7:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000ca:	50                   	push   %eax
  8000cb:	e8 12 1b 00 00       	call   801be2 <sys_utilities>
  8000d0:	83 c4 10             	add    $0x10,%esp
		va = 0x807000;
  8000d3:	c7 45 d0 00 70 80 00 	movl   $0x807000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8000da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000dd:	83 ec 08             	sub    $0x8,%esp
  8000e0:	50                   	push   %eax
  8000e1:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000e4:	50                   	push   %eax
  8000e5:	e8 f8 1a 00 00       	call   801be2 <sys_utilities>
  8000ea:	83 c4 10             	add    $0x10,%esp
		va = 0x809000;
  8000ed:	c7 45 d0 00 90 80 00 	movl   $0x809000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	50                   	push   %eax
  8000fb:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000fe:	50                   	push   %eax
  8000ff:	e8 de 1a 00 00       	call   801be2 <sys_utilities>
  800104:	83 c4 10             	add    $0x10,%esp
	}
	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800107:	c6 05 1f d1 80 00 61 	movb   $0x61,0x80d11f

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  80010e:	a0 1f e1 80 00       	mov    0x80e11f,%al
  800113:	88 45 cf             	mov    %al,-0x31(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800116:	a0 1f f1 80 00       	mov    0x80f11f,%al
  80011b:	88 45 ce             	mov    %al,-0x32(%ebp)
	char garbage4,garbage5;

	//Checking the WS after the 3 faults
	cprintf_colored(TEXT_cyan, "%~\nChecking MODIFIED CLOCK algorithm after freeing some pages [PLACEMENT]... \n");
  80011e:	83 ec 08             	sub    $0x8,%esp
  800121:	68 a4 1f 80 00       	push   $0x801fa4
  800126:	6a 03                	push   $0x3
  800128:	e8 df 06 00 00       	call   80080c <cprintf_colored>
  80012d:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedVAs1, 11, 0x806000, 1);
  800130:	6a 01                	push   $0x1
  800132:	68 00 60 80 00       	push   $0x806000
  800137:	6a 0b                	push   $0xb
  800139:	68 60 30 80 00       	push   $0x803060
  80013e:	e8 62 1a 00 00       	call   801ba5 <sys_check_WS_list>
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (found != 1) panic("MODIFIED CLOCK alg. failed.. trace it by printing WS before and after page fault");
  800149:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80014d:	74 14                	je     800163 <_main+0x12b>
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	68 f4 1f 80 00       	push   $0x801ff4
  800157:	6a 44                	push   $0x44
  800159:	68 54 1f 80 00       	push   $0x801f54
  80015e:	e8 ae 03 00 00       	call   800511 <_panic>
	}

	//Remove some pages from the WS
	cprintf_colored(TEXT_cyan, "%~\nRemove some other pages from the WS including last WS element... \n");
  800163:	83 ec 08             	sub    $0x8,%esp
  800166:	68 48 20 80 00       	push   $0x802048
  80016b:	6a 03                	push   $0x3
  80016d:	e8 9a 06 00 00       	call   80080c <cprintf_colored>
  800172:	83 c4 10             	add    $0x10,%esp
	{
		va = 0x827000;
  800175:	c7 45 d0 00 70 82 00 	movl   $0x827000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  80017c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	50                   	push   %eax
  800183:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  800186:	50                   	push   %eax
  800187:	e8 56 1a 00 00       	call   801be2 <sys_utilities>
  80018c:	83 c4 10             	add    $0x10,%esp
		va = 0x80F000;
  80018f:	c7 45 d0 00 f0 80 00 	movl   $0x80f000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  800196:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	50                   	push   %eax
  80019d:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8001a0:	50                   	push   %eax
  8001a1:	e8 3c 1a 00 00       	call   801be2 <sys_utilities>
  8001a6:	83 c4 10             	add    $0x10,%esp
		va = 0x806000;
  8001a9:	c7 45 d0 00 60 80 00 	movl   $0x806000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8001b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	50                   	push   %eax
  8001b7:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8001ba:	50                   	push   %eax
  8001bb:	e8 22 1a 00 00       	call   801be2 <sys_utilities>
  8001c0:	83 c4 10             	add    $0x10,%esp
		va = 0x808000;
  8001c3:	c7 45 d0 00 80 80 00 	movl   $0x808000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8001ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	50                   	push   %eax
  8001d1:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	e8 08 1a 00 00       	call   801be2 <sys_utilities>
  8001da:	83 c4 10             	add    $0x10,%esp
		va = 0x800000;
  8001dd:	c7 45 d0 00 00 80 00 	movl   $0x800000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8001e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	50                   	push   %eax
  8001eb:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	e8 ee 19 00 00       	call   801be2 <sys_utilities>
  8001f4:	83 c4 10             	add    $0x10,%esp
		va = 0x801000;
  8001f7:	c7 45 d0 00 10 80 00 	movl   $0x801000,-0x30(%ebp)
		sys_utilities(invPageCmd, va);
  8001fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	50                   	push   %eax
  800205:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	e8 d4 19 00 00       	call   801be2 <sys_utilities>
  80020e:	83 c4 10             	add    $0x10,%esp
	}
	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800211:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800218:	eb 26                	jmp    800240 <_main+0x208>
	{
		__arr__[i] = -1 ;
  80021a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021d:	05 20 31 80 00       	add    $0x803120,%eax
  800222:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*__ptr__ = *__ptr2__ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  800225:	a1 00 30 80 00       	mov    0x803000,%eax
  80022a:	8a 00                	mov    (%eax),%al
  80022c:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *__ptr2__ ;
  80022f:	a1 04 30 80 00       	mov    0x803004,%eax
  800234:	8a 00                	mov    (%eax),%al
  800236:	88 45 e6             	mov    %al,-0x1a(%ebp)
		va = 0x801000;
		sys_utilities(invPageCmd, va);
	}
	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800239:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  800240:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800247:	7e d1                	jle    80021a <_main+0x1e2>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	68 8e 20 80 00       	push   $0x80208e
  800251:	6a 03                	push   $0x3
  800253:	e8 b4 05 00 00       	call   80080c <cprintf_colored>
  800258:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  80025b:	a1 00 30 80 00       	mov    0x803000,%eax
  800260:	8a 00                	mov    (%eax),%al
  800262:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 a7 20 80 00       	push   $0x8020a7
  80026f:	6a 68                	push   $0x68
  800271:	68 54 1f 80 00       	push   $0x801f54
  800276:	e8 96 02 00 00       	call   800511 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  80027b:	a1 04 30 80 00       	mov    0x803004,%eax
  800280:	8a 00                	mov    (%eax),%al
  800282:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 a7 20 80 00       	push   $0x8020a7
  80028f:	6a 69                	push   $0x69
  800291:	68 54 1f 80 00       	push   $0x801f54
  800296:	e8 76 02 00 00       	call   800511 <_panic>
	}

	//Checking the WS after the 10 faults
	cprintf_colored(TEXT_cyan, "%~\nChecking MODIFIED CLOCK algorithm after freeing other set of pages [REPLACEMENT]... \n");
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	68 b4 20 80 00       	push   $0x8020b4
  8002a3:	6a 03                	push   $0x3
  8002a5:	e8 62 05 00 00       	call   80080c <cprintf_colored>
  8002aa:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedVAs2, 11, 0x80B000, 1);
  8002ad:	6a 01                	push   $0x1
  8002af:	68 00 b0 80 00       	push   $0x80b000
  8002b4:	6a 0b                	push   $0xb
  8002b6:	68 a0 30 80 00       	push   $0x8030a0
  8002bb:	e8 e5 18 00 00       	call   801ba5 <sys_check_WS_list>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (found != 1) panic("MODIFIED CLOCK alg. failed.. trace it by printing WS before and after page fault");
  8002c6:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8002ca:	74 14                	je     8002e0 <_main+0x2a8>
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	68 f4 1f 80 00       	push   $0x801ff4
  8002d4:	6a 70                	push   $0x70
  8002d6:	68 54 1f 80 00       	push   $0x801f54
  8002db:	e8 31 02 00 00       	call   800511 <_panic>
	}

	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  8002e0:	83 ec 08             	sub    $0x8,%esp
  8002e3:	68 10 21 80 00       	push   $0x802110
  8002e8:	6a 03                	push   $0x3
  8002ea:	e8 1d 05 00 00       	call   80080c <cprintf_colored>
  8002ef:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8002f2:	e8 37 15 00 00       	call   80182e <sys_pf_calculate_allocated_pages>
  8002f7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8002fa:	74 14                	je     800310 <_main+0x2d8>
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	68 40 21 80 00       	push   $0x802140
  800304:	6a 75                	push   $0x75
  800306:	68 54 1f 80 00       	push   $0x801f54
  80030b:	e8 01 02 00 00       	call   800511 <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800310:	e8 ce 14 00 00       	call   8017e3 <sys_calculate_free_frames>
  800315:	89 c3                	mov    %eax,%ebx
  800317:	e8 e0 14 00 00       	call   8017fc <sys_calculate_modified_frames>
  80031c:	01 d8                	add    %ebx,%eax
  80031e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800324:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800327:	74 1d                	je     800346 <_main+0x30e>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated. Expected = %d, Actual = %d", 0, (freePages - freePagesAfter));
  800329:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80032c:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 00                	push   $0x0
  800335:	68 ac 21 80 00       	push   $0x8021ac
  80033a:	6a 79                	push   $0x79
  80033c:	68 54 1f 80 00       	push   $0x801f54
  800341:	e8 cb 01 00 00       	call   800511 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [MODIFIED CLOCK Alg. #2] is completed successfully.\n");
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	68 2c 22 80 00       	push   $0x80222c
  80034e:	6a 0a                	push   $0xa
  800350:	e8 b7 04 00 00       	call   80080c <cprintf_colored>
  800355:	83 c4 10             	add    $0x10,%esp
	return;
  800358:	90                   	nop
}
  800359:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80035c:	5b                   	pop    %ebx
  80035d:	5e                   	pop    %esi
  80035e:	5f                   	pop    %edi
  80035f:	5d                   	pop    %ebp
  800360:	c3                   	ret    

00800361 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
  800367:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80036a:	e8 3d 16 00 00       	call   8019ac <sys_getenvindex>
  80036f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	c1 e0 02             	shl    $0x2,%eax
  80037a:	01 d0                	add    %edx,%eax
  80037c:	c1 e0 03             	shl    $0x3,%eax
  80037f:	01 d0                	add    %edx,%eax
  800381:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800388:	01 d0                	add    %edx,%eax
  80038a:	c1 e0 02             	shl    $0x2,%eax
  80038d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800392:	a3 e0 30 80 00       	mov    %eax,0x8030e0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800397:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80039c:	8a 40 20             	mov    0x20(%eax),%al
  80039f:	84 c0                	test   %al,%al
  8003a1:	74 0d                	je     8003b0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8003a3:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003a8:	83 c0 20             	add    $0x20,%eax
  8003ab:	a3 d0 30 80 00       	mov    %eax,0x8030d0

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b4:	7e 0a                	jle    8003c0 <libmain+0x5f>
		binaryname = argv[0];
  8003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	a3 d0 30 80 00       	mov    %eax,0x8030d0

	// call user main routine
	_main(argc, argv);
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	e8 6a fc ff ff       	call   800038 <_main>
  8003ce:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8003d1:	a1 cc 30 80 00       	mov    0x8030cc,%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	0f 84 01 01 00 00    	je     8004df <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8003de:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003e4:	bb 98 23 80 00       	mov    $0x802398,%ebx
  8003e9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003ee:	89 c7                	mov    %eax,%edi
  8003f0:	89 de                	mov    %ebx,%esi
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003f6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003f9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003fe:	b0 00                	mov    $0x0,%al
  800400:	89 d7                	mov    %edx,%edi
  800402:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800404:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80040b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	50                   	push   %eax
  800412:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	e8 c4 17 00 00       	call   801be2 <sys_utilities>
  80041e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800421:	e8 0d 13 00 00       	call   801733 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800426:	83 ec 0c             	sub    $0xc,%esp
  800429:	68 b8 22 80 00       	push   $0x8022b8
  80042e:	e8 ac 03 00 00       	call   8007df <cprintf>
  800433:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	85 c0                	test   %eax,%eax
  80043b:	74 18                	je     800455 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80043d:	e8 be 17 00 00       	call   801c00 <sys_get_optimal_num_faults>
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	50                   	push   %eax
  800446:	68 e0 22 80 00       	push   $0x8022e0
  80044b:	e8 8f 03 00 00       	call   8007df <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	eb 59                	jmp    8004ae <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800455:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80045a:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800460:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800465:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80046b:	83 ec 04             	sub    $0x4,%esp
  80046e:	52                   	push   %edx
  80046f:	50                   	push   %eax
  800470:	68 04 23 80 00       	push   $0x802304
  800475:	e8 65 03 00 00       	call   8007df <cprintf>
  80047a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80047d:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800482:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800488:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80048d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800493:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800498:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80049e:	51                   	push   %ecx
  80049f:	52                   	push   %edx
  8004a0:	50                   	push   %eax
  8004a1:	68 2c 23 80 00       	push   $0x80232c
  8004a6:	e8 34 03 00 00       	call   8007df <cprintf>
  8004ab:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ae:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8004b3:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	50                   	push   %eax
  8004bd:	68 84 23 80 00       	push   $0x802384
  8004c2:	e8 18 03 00 00       	call   8007df <cprintf>
  8004c7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8004ca:	83 ec 0c             	sub    $0xc,%esp
  8004cd:	68 b8 22 80 00       	push   $0x8022b8
  8004d2:	e8 08 03 00 00       	call   8007df <cprintf>
  8004d7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8004da:	e8 6e 12 00 00       	call   80174d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8004df:	e8 1f 00 00 00       	call   800503 <exit>
}
  8004e4:	90                   	nop
  8004e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e8:	5b                   	pop    %ebx
  8004e9:	5e                   	pop    %esi
  8004ea:	5f                   	pop    %edi
  8004eb:	5d                   	pop    %ebp
  8004ec:	c3                   	ret    

008004ed <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004f3:	83 ec 0c             	sub    $0xc,%esp
  8004f6:	6a 00                	push   $0x0
  8004f8:	e8 7b 14 00 00       	call   801978 <sys_destroy_env>
  8004fd:	83 c4 10             	add    $0x10,%esp
}
  800500:	90                   	nop
  800501:	c9                   	leave  
  800502:	c3                   	ret    

00800503 <exit>:

void
exit(void)
{
  800503:	55                   	push   %ebp
  800504:	89 e5                	mov    %esp,%ebp
  800506:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800509:	e8 d0 14 00 00       	call   8019de <sys_exit_env>
}
  80050e:	90                   	nop
  80050f:	c9                   	leave  
  800510:	c3                   	ret    

00800511 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800517:	8d 45 10             	lea    0x10(%ebp),%eax
  80051a:	83 c0 04             	add    $0x4,%eax
  80051d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800520:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  800525:	85 c0                	test   %eax,%eax
  800527:	74 16                	je     80053f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800529:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	50                   	push   %eax
  800532:	68 fc 23 80 00       	push   $0x8023fc
  800537:	e8 a3 02 00 00       	call   8007df <cprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80053f:	a1 d0 30 80 00       	mov    0x8030d0,%eax
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	ff 75 0c             	pushl  0xc(%ebp)
  80054a:	ff 75 08             	pushl  0x8(%ebp)
  80054d:	50                   	push   %eax
  80054e:	68 04 24 80 00       	push   $0x802404
  800553:	6a 74                	push   $0x74
  800555:	e8 b2 02 00 00       	call   80080c <cprintf_colored>
  80055a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80055d:	8b 45 10             	mov    0x10(%ebp),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	ff 75 f4             	pushl  -0xc(%ebp)
  800566:	50                   	push   %eax
  800567:	e8 04 02 00 00       	call   800770 <vcprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	6a 00                	push   $0x0
  800574:	68 2c 24 80 00       	push   $0x80242c
  800579:	e8 f2 01 00 00       	call   800770 <vcprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800581:	e8 7d ff ff ff       	call   800503 <exit>

	// should not return here
	while (1) ;
  800586:	eb fe                	jmp    800586 <_panic+0x75>

00800588 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80058e:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800593:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059c:	39 c2                	cmp    %eax,%edx
  80059e:	74 14                	je     8005b4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005a0:	83 ec 04             	sub    $0x4,%esp
  8005a3:	68 30 24 80 00       	push   $0x802430
  8005a8:	6a 26                	push   $0x26
  8005aa:	68 7c 24 80 00       	push   $0x80247c
  8005af:	e8 5d ff ff ff       	call   800511 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005c2:	e9 c5 00 00 00       	jmp    80068c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 d0                	add    %edx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	85 c0                	test   %eax,%eax
  8005da:	75 08                	jne    8005e4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005dc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005df:	e9 a5 00 00 00       	jmp    800689 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005f2:	eb 69                	jmp    80065d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005f4:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8005f9:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800602:	89 d0                	mov    %edx,%eax
  800604:	01 c0                	add    %eax,%eax
  800606:	01 d0                	add    %edx,%eax
  800608:	c1 e0 03             	shl    $0x3,%eax
  80060b:	01 c8                	add    %ecx,%eax
  80060d:	8a 40 04             	mov    0x4(%eax),%al
  800610:	84 c0                	test   %al,%al
  800612:	75 46                	jne    80065a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800614:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800619:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80061f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800622:	89 d0                	mov    %edx,%eax
  800624:	01 c0                	add    %eax,%eax
  800626:	01 d0                	add    %edx,%eax
  800628:	c1 e0 03             	shl    $0x3,%eax
  80062b:	01 c8                	add    %ecx,%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800632:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800635:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80063a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80063c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	01 c8                	add    %ecx,%eax
  80064b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80064d:	39 c2                	cmp    %eax,%edx
  80064f:	75 09                	jne    80065a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800651:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800658:	eb 15                	jmp    80066f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065a:	ff 45 e8             	incl   -0x18(%ebp)
  80065d:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800662:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80066b:	39 c2                	cmp    %eax,%edx
  80066d:	77 85                	ja     8005f4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80066f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800673:	75 14                	jne    800689 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800675:	83 ec 04             	sub    $0x4,%esp
  800678:	68 88 24 80 00       	push   $0x802488
  80067d:	6a 3a                	push   $0x3a
  80067f:	68 7c 24 80 00       	push   $0x80247c
  800684:	e8 88 fe ff ff       	call   800511 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800689:	ff 45 f0             	incl   -0x10(%ebp)
  80068c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80068f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800692:	0f 8c 2f ff ff ff    	jl     8005c7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800698:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80069f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006a6:	eb 26                	jmp    8006ce <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006a8:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8006ad:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b6:	89 d0                	mov    %edx,%eax
  8006b8:	01 c0                	add    %eax,%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	c1 e0 03             	shl    $0x3,%eax
  8006bf:	01 c8                	add    %ecx,%eax
  8006c1:	8a 40 04             	mov    0x4(%eax),%al
  8006c4:	3c 01                	cmp    $0x1,%al
  8006c6:	75 03                	jne    8006cb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006c8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cb:	ff 45 e0             	incl   -0x20(%ebp)
  8006ce:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8006d3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006dc:	39 c2                	cmp    %eax,%edx
  8006de:	77 c8                	ja     8006a8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006e6:	74 14                	je     8006fc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 dc 24 80 00       	push   $0x8024dc
  8006f0:	6a 44                	push   $0x44
  8006f2:	68 7c 24 80 00       	push   $0x80247c
  8006f7:	e8 15 fe ff ff       	call   800511 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006fc:	90                   	nop
  8006fd:	c9                   	leave  
  8006fe:	c3                   	ret    

008006ff <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	53                   	push   %ebx
  800703:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800706:	8b 45 0c             	mov    0xc(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 48 01             	lea    0x1(%eax),%ecx
  80070e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800711:	89 0a                	mov    %ecx,(%edx)
  800713:	8b 55 08             	mov    0x8(%ebp),%edx
  800716:	88 d1                	mov    %dl,%cl
  800718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80071f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	3d ff 00 00 00       	cmp    $0xff,%eax
  800729:	75 30                	jne    80075b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80072b:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  800731:	a0 04 31 80 00       	mov    0x803104,%al
  800736:	0f b6 c0             	movzbl %al,%eax
  800739:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80073c:	8b 09                	mov    (%ecx),%ecx
  80073e:	89 cb                	mov    %ecx,%ebx
  800740:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800743:	83 c1 08             	add    $0x8,%ecx
  800746:	52                   	push   %edx
  800747:	50                   	push   %eax
  800748:	53                   	push   %ebx
  800749:	51                   	push   %ecx
  80074a:	e8 a0 0f 00 00       	call   8016ef <sys_cputs>
  80074f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800752:	8b 45 0c             	mov    0xc(%ebp),%eax
  800755:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075e:	8b 40 04             	mov    0x4(%eax),%eax
  800761:	8d 50 01             	lea    0x1(%eax),%edx
  800764:	8b 45 0c             	mov    0xc(%ebp),%eax
  800767:	89 50 04             	mov    %edx,0x4(%eax)
}
  80076a:	90                   	nop
  80076b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    

00800770 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800779:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800780:	00 00 00 
	b.cnt = 0;
  800783:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80078a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80078d:	ff 75 0c             	pushl  0xc(%ebp)
  800790:	ff 75 08             	pushl  0x8(%ebp)
  800793:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800799:	50                   	push   %eax
  80079a:	68 ff 06 80 00       	push   $0x8006ff
  80079f:	e8 5a 02 00 00       	call   8009fe <vprintfmt>
  8007a4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8007a7:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  8007ad:	a0 04 31 80 00       	mov    0x803104,%al
  8007b2:	0f b6 c0             	movzbl %al,%eax
  8007b5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8007bb:	52                   	push   %edx
  8007bc:	50                   	push   %eax
  8007bd:	51                   	push   %ecx
  8007be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007c4:	83 c0 08             	add    $0x8,%eax
  8007c7:	50                   	push   %eax
  8007c8:	e8 22 0f 00 00       	call   8016ef <sys_cputs>
  8007cd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007d0:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
	return b.cnt;
  8007d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007dd:	c9                   	leave  
  8007de:	c3                   	ret    

008007df <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007e5:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	va_start(ap, fmt);
  8007ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fb:	50                   	push   %eax
  8007fc:	e8 6f ff ff ff       	call   800770 <vcprintf>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    

0080080c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800812:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	curTextClr = (textClr << 8) ; //set text color by the given value
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	c1 e0 08             	shl    $0x8,%eax
  80081f:	a3 fc 71 82 00       	mov    %eax,0x8271fc
	va_start(ap, fmt);
  800824:	8d 45 0c             	lea    0xc(%ebp),%eax
  800827:	83 c0 04             	add    $0x4,%eax
  80082a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80082d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 f4             	pushl  -0xc(%ebp)
  800836:	50                   	push   %eax
  800837:	e8 34 ff ff ff       	call   800770 <vcprintf>
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800842:	c7 05 fc 71 82 00 00 	movl   $0x700,0x8271fc
  800849:	07 00 00 

	return cnt;
  80084c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800857:	e8 d7 0e 00 00       	call   801733 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80085c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80085f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 f4             	pushl  -0xc(%ebp)
  80086b:	50                   	push   %eax
  80086c:	e8 ff fe ff ff       	call   800770 <vcprintf>
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800877:	e8 d1 0e 00 00       	call   80174d <sys_unlock_cons>
	return cnt;
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80087f:	c9                   	leave  
  800880:	c3                   	ret    

00800881 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	53                   	push   %ebx
  800885:	83 ec 14             	sub    $0x14,%esp
  800888:	8b 45 10             	mov    0x10(%ebp),%eax
  80088b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800894:	8b 45 18             	mov    0x18(%ebp),%eax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80089f:	77 55                	ja     8008f6 <printnum+0x75>
  8008a1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a4:	72 05                	jb     8008ab <printnum+0x2a>
  8008a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008a9:	77 4b                	ja     8008f6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ab:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ae:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008b1:	8b 45 18             	mov    0x18(%ebp),%eax
  8008b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b9:	52                   	push   %edx
  8008ba:	50                   	push   %eax
  8008bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8008be:	ff 75 f0             	pushl  -0x10(%ebp)
  8008c1:	e8 aa 13 00 00       	call   801c70 <__udivdi3>
  8008c6:	83 c4 10             	add    $0x10,%esp
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	ff 75 20             	pushl  0x20(%ebp)
  8008cf:	53                   	push   %ebx
  8008d0:	ff 75 18             	pushl  0x18(%ebp)
  8008d3:	52                   	push   %edx
  8008d4:	50                   	push   %eax
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 a1 ff ff ff       	call   800881 <printnum>
  8008e0:	83 c4 20             	add    $0x20,%esp
  8008e3:	eb 1a                	jmp    8008ff <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	ff 75 20             	pushl  0x20(%ebp)
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	ff d0                	call   *%eax
  8008f3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008f6:	ff 4d 1c             	decl   0x1c(%ebp)
  8008f9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008fd:	7f e6                	jg     8008e5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008ff:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800902:	bb 00 00 00 00       	mov    $0x0,%ebx
  800907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80090d:	53                   	push   %ebx
  80090e:	51                   	push   %ecx
  80090f:	52                   	push   %edx
  800910:	50                   	push   %eax
  800911:	e8 6a 14 00 00       	call   801d80 <__umoddi3>
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	05 54 27 80 00       	add    $0x802754,%eax
  80091e:	8a 00                	mov    (%eax),%al
  800920:	0f be c0             	movsbl %al,%eax
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	50                   	push   %eax
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	ff d0                	call   *%eax
  80092f:	83 c4 10             	add    $0x10,%esp
}
  800932:	90                   	nop
  800933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800936:	c9                   	leave  
  800937:	c3                   	ret    

00800938 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80093b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093f:	7e 1c                	jle    80095d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	8d 50 08             	lea    0x8(%eax),%edx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	89 10                	mov    %edx,(%eax)
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	83 e8 08             	sub    $0x8,%eax
  800956:	8b 50 04             	mov    0x4(%eax),%edx
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	eb 40                	jmp    80099d <getuint+0x65>
	else if (lflag)
  80095d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800961:	74 1e                	je     800981 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	8d 50 04             	lea    0x4(%eax),%edx
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	89 10                	mov    %edx,(%eax)
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	83 e8 04             	sub    $0x4,%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	ba 00 00 00 00       	mov    $0x0,%edx
  80097f:	eb 1c                	jmp    80099d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 50 04             	lea    0x4(%eax),%edx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	89 10                	mov    %edx,(%eax)
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	83 e8 04             	sub    $0x4,%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009a2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009a6:	7e 1c                	jle    8009c4 <getint+0x25>
		return va_arg(*ap, long long);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	8d 50 08             	lea    0x8(%eax),%edx
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	89 10                	mov    %edx,(%eax)
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	83 e8 08             	sub    $0x8,%eax
  8009bd:	8b 50 04             	mov    0x4(%eax),%edx
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	eb 38                	jmp    8009fc <getint+0x5d>
	else if (lflag)
  8009c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c8:	74 1a                	je     8009e4 <getint+0x45>
		return va_arg(*ap, long);
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	8d 50 04             	lea    0x4(%eax),%edx
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	89 10                	mov    %edx,(%eax)
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 00                	mov    (%eax),%eax
  8009dc:	83 e8 04             	sub    $0x4,%eax
  8009df:	8b 00                	mov    (%eax),%eax
  8009e1:	99                   	cltd   
  8009e2:	eb 18                	jmp    8009fc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8b 00                	mov    (%eax),%eax
  8009e9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	89 10                	mov    %edx,(%eax)
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	8b 00                	mov    (%eax),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	99                   	cltd   
}
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	56                   	push   %esi
  800a02:	53                   	push   %ebx
  800a03:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a06:	eb 17                	jmp    800a1f <vprintfmt+0x21>
			if (ch == '\0')
  800a08:	85 db                	test   %ebx,%ebx
  800a0a:	0f 84 c1 03 00 00    	je     800dd1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	53                   	push   %ebx
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a22:	8d 50 01             	lea    0x1(%eax),%edx
  800a25:	89 55 10             	mov    %edx,0x10(%ebp)
  800a28:	8a 00                	mov    (%eax),%al
  800a2a:	0f b6 d8             	movzbl %al,%ebx
  800a2d:	83 fb 25             	cmp    $0x25,%ebx
  800a30:	75 d6                	jne    800a08 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a32:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a36:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a3d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a44:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a4b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a52:	8b 45 10             	mov    0x10(%ebp),%eax
  800a55:	8d 50 01             	lea    0x1(%eax),%edx
  800a58:	89 55 10             	mov    %edx,0x10(%ebp)
  800a5b:	8a 00                	mov    (%eax),%al
  800a5d:	0f b6 d8             	movzbl %al,%ebx
  800a60:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a63:	83 f8 5b             	cmp    $0x5b,%eax
  800a66:	0f 87 3d 03 00 00    	ja     800da9 <vprintfmt+0x3ab>
  800a6c:	8b 04 85 78 27 80 00 	mov    0x802778(,%eax,4),%eax
  800a73:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a75:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a79:	eb d7                	jmp    800a52 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a7b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a7f:	eb d1                	jmp    800a52 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a81:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	c1 e0 02             	shl    $0x2,%eax
  800a90:	01 d0                	add    %edx,%eax
  800a92:	01 c0                	add    %eax,%eax
  800a94:	01 d8                	add    %ebx,%eax
  800a96:	83 e8 30             	sub    $0x30,%eax
  800a99:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9f:	8a 00                	mov    (%eax),%al
  800aa1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aa4:	83 fb 2f             	cmp    $0x2f,%ebx
  800aa7:	7e 3e                	jle    800ae7 <vprintfmt+0xe9>
  800aa9:	83 fb 39             	cmp    $0x39,%ebx
  800aac:	7f 39                	jg     800ae7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aae:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ab1:	eb d5                	jmp    800a88 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ac7:	eb 1f                	jmp    800ae8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ac9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acd:	79 83                	jns    800a52 <vprintfmt+0x54>
				width = 0;
  800acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ad6:	e9 77 ff ff ff       	jmp    800a52 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800adb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ae2:	e9 6b ff ff ff       	jmp    800a52 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ae7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ae8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aec:	0f 89 60 ff ff ff    	jns    800a52 <vprintfmt+0x54>
				width = precision, precision = -1;
  800af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800af8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aff:	e9 4e ff ff ff       	jmp    800a52 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b04:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b07:	e9 46 ff ff ff       	jmp    800a52 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 00                	mov    (%eax),%eax
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	50                   	push   %eax
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			break;
  800b2c:	e9 9b 02 00 00       	jmp    800dcc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b31:	8b 45 14             	mov    0x14(%ebp),%eax
  800b34:	83 c0 04             	add    $0x4,%eax
  800b37:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3d:	83 e8 04             	sub    $0x4,%eax
  800b40:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b42:	85 db                	test   %ebx,%ebx
  800b44:	79 02                	jns    800b48 <vprintfmt+0x14a>
				err = -err;
  800b46:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b48:	83 fb 64             	cmp    $0x64,%ebx
  800b4b:	7f 0b                	jg     800b58 <vprintfmt+0x15a>
  800b4d:	8b 34 9d c0 25 80 00 	mov    0x8025c0(,%ebx,4),%esi
  800b54:	85 f6                	test   %esi,%esi
  800b56:	75 19                	jne    800b71 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b58:	53                   	push   %ebx
  800b59:	68 65 27 80 00       	push   $0x802765
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	ff 75 08             	pushl  0x8(%ebp)
  800b64:	e8 70 02 00 00       	call   800dd9 <printfmt>
  800b69:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b6c:	e9 5b 02 00 00       	jmp    800dcc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b71:	56                   	push   %esi
  800b72:	68 6e 27 80 00       	push   $0x80276e
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	ff 75 08             	pushl  0x8(%ebp)
  800b7d:	e8 57 02 00 00       	call   800dd9 <printfmt>
  800b82:	83 c4 10             	add    $0x10,%esp
			break;
  800b85:	e9 42 02 00 00       	jmp    800dcc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8d:	83 c0 04             	add    $0x4,%eax
  800b90:	89 45 14             	mov    %eax,0x14(%ebp)
  800b93:	8b 45 14             	mov    0x14(%ebp),%eax
  800b96:	83 e8 04             	sub    $0x4,%eax
  800b99:	8b 30                	mov    (%eax),%esi
  800b9b:	85 f6                	test   %esi,%esi
  800b9d:	75 05                	jne    800ba4 <vprintfmt+0x1a6>
				p = "(null)";
  800b9f:	be 71 27 80 00       	mov    $0x802771,%esi
			if (width > 0 && padc != '-')
  800ba4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba8:	7e 6d                	jle    800c17 <vprintfmt+0x219>
  800baa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bae:	74 67                	je     800c17 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	50                   	push   %eax
  800bb7:	56                   	push   %esi
  800bb8:	e8 1e 03 00 00       	call   800edb <strnlen>
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bc3:	eb 16                	jmp    800bdb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bc5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	50                   	push   %eax
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	ff d0                	call   *%eax
  800bd5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bdf:	7f e4                	jg     800bc5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be1:	eb 34                	jmp    800c17 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800be3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800be7:	74 1c                	je     800c05 <vprintfmt+0x207>
  800be9:	83 fb 1f             	cmp    $0x1f,%ebx
  800bec:	7e 05                	jle    800bf3 <vprintfmt+0x1f5>
  800bee:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf1:	7e 12                	jle    800c05 <vprintfmt+0x207>
					putch('?', putdat);
  800bf3:	83 ec 08             	sub    $0x8,%esp
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	6a 3f                	push   $0x3f
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
  800c03:	eb 0f                	jmp    800c14 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	53                   	push   %ebx
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	ff d0                	call   *%eax
  800c11:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c14:	ff 4d e4             	decl   -0x1c(%ebp)
  800c17:	89 f0                	mov    %esi,%eax
  800c19:	8d 70 01             	lea    0x1(%eax),%esi
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	0f be d8             	movsbl %al,%ebx
  800c21:	85 db                	test   %ebx,%ebx
  800c23:	74 24                	je     800c49 <vprintfmt+0x24b>
  800c25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c29:	78 b8                	js     800be3 <vprintfmt+0x1e5>
  800c2b:	ff 4d e0             	decl   -0x20(%ebp)
  800c2e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c32:	79 af                	jns    800be3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c34:	eb 13                	jmp    800c49 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	6a 20                	push   $0x20
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	ff d0                	call   *%eax
  800c43:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c46:	ff 4d e4             	decl   -0x1c(%ebp)
  800c49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4d:	7f e7                	jg     800c36 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c4f:	e9 78 01 00 00       	jmp    800dcc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5d:	50                   	push   %eax
  800c5e:	e8 3c fd ff ff       	call   80099f <getint>
  800c63:	83 c4 10             	add    $0x10,%esp
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c72:	85 d2                	test   %edx,%edx
  800c74:	79 23                	jns    800c99 <vprintfmt+0x29b>
				putch('-', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 2d                	push   $0x2d
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c8c:	f7 d8                	neg    %eax
  800c8e:	83 d2 00             	adc    $0x0,%edx
  800c91:	f7 da                	neg    %edx
  800c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c99:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca0:	e9 bc 00 00 00       	jmp    800d61 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	ff 75 e8             	pushl  -0x18(%ebp)
  800cab:	8d 45 14             	lea    0x14(%ebp),%eax
  800cae:	50                   	push   %eax
  800caf:	e8 84 fc ff ff       	call   800938 <getuint>
  800cb4:	83 c4 10             	add    $0x10,%esp
  800cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cbd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc4:	e9 98 00 00 00       	jmp    800d61 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cc9:	83 ec 08             	sub    $0x8,%esp
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	6a 58                	push   $0x58
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	ff d0                	call   *%eax
  800cd6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cd9:	83 ec 08             	sub    $0x8,%esp
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	6a 58                	push   $0x58
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	ff d0                	call   *%eax
  800ce6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	6a 58                	push   $0x58
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
			break;
  800cf9:	e9 ce 00 00 00       	jmp    800dcc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	6a 30                	push   $0x30
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	ff d0                	call   *%eax
  800d0b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d0e:	83 ec 08             	sub    $0x8,%esp
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	6a 78                	push   $0x78
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	ff d0                	call   *%eax
  800d1b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d21:	83 c0 04             	add    $0x4,%eax
  800d24:	89 45 14             	mov    %eax,0x14(%ebp)
  800d27:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2a:	83 e8 04             	sub    $0x4,%eax
  800d2d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d40:	eb 1f                	jmp    800d61 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d42:	83 ec 08             	sub    $0x8,%esp
  800d45:	ff 75 e8             	pushl  -0x18(%ebp)
  800d48:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4b:	50                   	push   %eax
  800d4c:	e8 e7 fb ff ff       	call   800938 <getuint>
  800d51:	83 c4 10             	add    $0x10,%esp
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d61:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d68:	83 ec 04             	sub    $0x4,%esp
  800d6b:	52                   	push   %edx
  800d6c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	ff 75 f4             	pushl  -0xc(%ebp)
  800d73:	ff 75 f0             	pushl  -0x10(%ebp)
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	ff 75 08             	pushl  0x8(%ebp)
  800d7c:	e8 00 fb ff ff       	call   800881 <printnum>
  800d81:	83 c4 20             	add    $0x20,%esp
			break;
  800d84:	eb 46                	jmp    800dcc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	53                   	push   %ebx
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	ff d0                	call   *%eax
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	eb 35                	jmp    800dcc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d97:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
			break;
  800d9e:	eb 2c                	jmp    800dcc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800da0:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
			break;
  800da7:	eb 23                	jmp    800dcc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	6a 25                	push   $0x25
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800db9:	ff 4d 10             	decl   0x10(%ebp)
  800dbc:	eb 03                	jmp    800dc1 <vprintfmt+0x3c3>
  800dbe:	ff 4d 10             	decl   0x10(%ebp)
  800dc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc4:	48                   	dec    %eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	3c 25                	cmp    $0x25,%al
  800dc9:	75 f3                	jne    800dbe <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dcb:	90                   	nop
		}
	}
  800dcc:	e9 35 fc ff ff       	jmp    800a06 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dd1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ddf:	8d 45 10             	lea    0x10(%ebp),%eax
  800de2:	83 c0 04             	add    $0x4,%eax
  800de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800de8:	8b 45 10             	mov    0x10(%ebp),%eax
  800deb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dee:	50                   	push   %eax
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	ff 75 08             	pushl  0x8(%ebp)
  800df5:	e8 04 fc ff ff       	call   8009fe <vprintfmt>
  800dfa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dfd:	90                   	nop
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	8b 40 08             	mov    0x8(%eax),%eax
  800e09:	8d 50 01             	lea    0x1(%eax),%edx
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	8b 10                	mov    (%eax),%edx
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8b 40 04             	mov    0x4(%eax),%eax
  800e1d:	39 c2                	cmp    %eax,%edx
  800e1f:	73 12                	jae    800e33 <sprintputch+0x33>
		*b->buf++ = ch;
  800e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e24:	8b 00                	mov    (%eax),%eax
  800e26:	8d 48 01             	lea    0x1(%eax),%ecx
  800e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2c:	89 0a                	mov    %ecx,(%edx)
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	88 10                	mov    %dl,(%eax)
}
  800e33:	90                   	nop
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	01 d0                	add    %edx,%eax
  800e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e5b:	74 06                	je     800e63 <vsnprintf+0x2d>
  800e5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e61:	7f 07                	jg     800e6a <vsnprintf+0x34>
		return -E_INVAL;
  800e63:	b8 03 00 00 00       	mov    $0x3,%eax
  800e68:	eb 20                	jmp    800e8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e6a:	ff 75 14             	pushl  0x14(%ebp)
  800e6d:	ff 75 10             	pushl  0x10(%ebp)
  800e70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e73:	50                   	push   %eax
  800e74:	68 00 0e 80 00       	push   $0x800e00
  800e79:	e8 80 fb ff ff       	call   8009fe <vprintfmt>
  800e7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e92:	8d 45 10             	lea    0x10(%ebp),%eax
  800e95:	83 c0 04             	add    $0x4,%eax
  800e98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea1:	50                   	push   %eax
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	ff 75 08             	pushl  0x8(%ebp)
  800ea8:	e8 89 ff ff ff       	call   800e36 <vsnprintf>
  800ead:	83 c4 10             	add    $0x10,%esp
  800eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ebe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec5:	eb 06                	jmp    800ecd <strlen+0x15>
		n++;
  800ec7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eca:	ff 45 08             	incl   0x8(%ebp)
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	84 c0                	test   %al,%al
  800ed4:	75 f1                	jne    800ec7 <strlen+0xf>
		n++;
	return n;
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ee1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee8:	eb 09                	jmp    800ef3 <strnlen+0x18>
		n++;
  800eea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eed:	ff 45 08             	incl   0x8(%ebp)
  800ef0:	ff 4d 0c             	decl   0xc(%ebp)
  800ef3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef7:	74 09                	je     800f02 <strnlen+0x27>
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	84 c0                	test   %al,%al
  800f00:	75 e8                	jne    800eea <strnlen+0xf>
		n++;
	return n;
  800f02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f13:	90                   	nop
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8d 50 01             	lea    0x1(%eax),%edx
  800f1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f26:	8a 12                	mov    (%edx),%dl
  800f28:	88 10                	mov    %dl,(%eax)
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	75 e4                	jne    800f14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f48:	eb 1f                	jmp    800f69 <strncpy+0x34>
		*dst++ = *src;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8d 50 01             	lea    0x1(%eax),%edx
  800f50:	89 55 08             	mov    %edx,0x8(%ebp)
  800f53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f56:	8a 12                	mov    (%edx),%dl
  800f58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	84 c0                	test   %al,%al
  800f61:	74 03                	je     800f66 <strncpy+0x31>
			src++;
  800f63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f66:	ff 45 fc             	incl   -0x4(%ebp)
  800f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f6f:	72 d9                	jb     800f4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f86:	74 30                	je     800fb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f88:	eb 16                	jmp    800fa0 <strlcpy+0x2a>
			*dst++ = *src++;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8d 50 01             	lea    0x1(%eax),%edx
  800f90:	89 55 08             	mov    %edx,0x8(%ebp)
  800f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f9c:	8a 12                	mov    (%edx),%dl
  800f9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fa0:	ff 4d 10             	decl   0x10(%ebp)
  800fa3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa7:	74 09                	je     800fb2 <strlcpy+0x3c>
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	84 c0                	test   %al,%al
  800fb0:	75 d8                	jne    800f8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	c9                   	leave  
  800fc3:	c3                   	ret    

00800fc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fc7:	eb 06                	jmp    800fcf <strcmp+0xb>
		p++, q++;
  800fc9:	ff 45 08             	incl   0x8(%ebp)
  800fcc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	84 c0                	test   %al,%al
  800fd6:	74 0e                	je     800fe6 <strcmp+0x22>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 10                	mov    (%eax),%dl
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	38 c2                	cmp    %al,%dl
  800fe4:	74 e3                	je     800fc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f b6 d0             	movzbl %al,%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	0f b6 c0             	movzbl %al,%eax
  800ff6:	29 c2                	sub    %eax,%edx
  800ff8:	89 d0                	mov    %edx,%eax
}
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    

00800ffc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fff:	eb 09                	jmp    80100a <strncmp+0xe>
		n--, p++, q++;
  801001:	ff 4d 10             	decl   0x10(%ebp)
  801004:	ff 45 08             	incl   0x8(%ebp)
  801007:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80100a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100e:	74 17                	je     801027 <strncmp+0x2b>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	84 c0                	test   %al,%al
  801017:	74 0e                	je     801027 <strncmp+0x2b>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 10                	mov    (%eax),%dl
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	38 c2                	cmp    %al,%dl
  801025:	74 da                	je     801001 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801027:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102b:	75 07                	jne    801034 <strncmp+0x38>
		return 0;
  80102d:	b8 00 00 00 00       	mov    $0x0,%eax
  801032:	eb 14                	jmp    801048 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	0f b6 d0             	movzbl %al,%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	0f b6 c0             	movzbl %al,%eax
  801044:	29 c2                	sub    %eax,%edx
  801046:	89 d0                	mov    %edx,%eax
}
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 04             	sub    $0x4,%esp
  801050:	8b 45 0c             	mov    0xc(%ebp),%eax
  801053:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801056:	eb 12                	jmp    80106a <strchr+0x20>
		if (*s == c)
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801060:	75 05                	jne    801067 <strchr+0x1d>
			return (char *) s;
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	eb 11                	jmp    801078 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	84 c0                	test   %al,%al
  801071:	75 e5                	jne    801058 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801073:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 04             	sub    $0x4,%esp
  801080:	8b 45 0c             	mov    0xc(%ebp),%eax
  801083:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801086:	eb 0d                	jmp    801095 <strfind+0x1b>
		if (*s == c)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801090:	74 0e                	je     8010a0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801092:	ff 45 08             	incl   0x8(%ebp)
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 ea                	jne    801088 <strfind+0xe>
  80109e:	eb 01                	jmp    8010a1 <strfind+0x27>
		if (*s == c)
			break;
  8010a0:	90                   	nop
	return (char *) s;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8010b2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b6:	76 63                	jbe    80111b <memset+0x75>
		uint64 data_block = c;
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	99                   	cltd   
  8010bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8010cc:	c1 e0 08             	shl    $0x8,%eax
  8010cf:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010d2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8010d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010db:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8010df:	c1 e0 10             	shl    $0x10,%eax
  8010e2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010e5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8010e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010f8:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010fb:	eb 18                	jmp    801115 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010fd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801100:	8d 41 08             	lea    0x8(%ecx),%eax
  801103:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801106:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110c:	89 01                	mov    %eax,(%ecx)
  80110e:	89 51 04             	mov    %edx,0x4(%ecx)
  801111:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801115:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801119:	77 e2                	ja     8010fd <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80111b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111f:	74 23                	je     801144 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801124:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801127:	eb 0e                	jmp    801137 <memset+0x91>
			*p8++ = (uint8)c;
  801129:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112c:	8d 50 01             	lea    0x1(%eax),%edx
  80112f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801132:	8b 55 0c             	mov    0xc(%ebp),%edx
  801135:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801137:	8b 45 10             	mov    0x10(%ebp),%eax
  80113a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80113d:	89 55 10             	mov    %edx,0x10(%ebp)
  801140:	85 c0                	test   %eax,%eax
  801142:	75 e5                	jne    801129 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80115b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80115f:	76 24                	jbe    801185 <memcpy+0x3c>
		while(n >= 8){
  801161:	eb 1c                	jmp    80117f <memcpy+0x36>
			*d64 = *s64;
  801163:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801166:	8b 50 04             	mov    0x4(%eax),%edx
  801169:	8b 00                	mov    (%eax),%eax
  80116b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80116e:	89 01                	mov    %eax,(%ecx)
  801170:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801173:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801177:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80117b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80117f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801183:	77 de                	ja     801163 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801185:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801189:	74 31                	je     8011bc <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80118b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801197:	eb 16                	jmp    8011af <memcpy+0x66>
			*d8++ = *s8++;
  801199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80119c:	8d 50 01             	lea    0x1(%eax),%edx
  80119f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8011a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011ab:	8a 12                	mov    (%edx),%dl
  8011ad:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	75 dd                	jne    801199 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011d9:	73 50                	jae    80122b <memmove+0x6a>
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011e6:	76 43                	jbe    80122b <memmove+0x6a>
		s += n;
  8011e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011eb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011f4:	eb 10                	jmp    801206 <memmove+0x45>
			*--d = *--s;
  8011f6:	ff 4d f8             	decl   -0x8(%ebp)
  8011f9:	ff 4d fc             	decl   -0x4(%ebp)
  8011fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ff:	8a 10                	mov    (%eax),%dl
  801201:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801204:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120c:	89 55 10             	mov    %edx,0x10(%ebp)
  80120f:	85 c0                	test   %eax,%eax
  801211:	75 e3                	jne    8011f6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801213:	eb 23                	jmp    801238 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801215:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801218:	8d 50 01             	lea    0x1(%eax),%edx
  80121b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801221:	8d 4a 01             	lea    0x1(%edx),%ecx
  801224:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801227:	8a 12                	mov    (%edx),%dl
  801229:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80122b:	8b 45 10             	mov    0x10(%ebp),%eax
  80122e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801231:	89 55 10             	mov    %edx,0x10(%ebp)
  801234:	85 c0                	test   %eax,%eax
  801236:	75 dd                	jne    801215 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80124f:	eb 2a                	jmp    80127b <memcmp+0x3e>
		if (*s1 != *s2)
  801251:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801254:	8a 10                	mov    (%eax),%dl
  801256:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	38 c2                	cmp    %al,%dl
  80125d:	74 16                	je     801275 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80125f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	0f b6 d0             	movzbl %al,%edx
  801267:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	0f b6 c0             	movzbl %al,%eax
  80126f:	29 c2                	sub    %eax,%edx
  801271:	89 d0                	mov    %edx,%eax
  801273:	eb 18                	jmp    80128d <memcmp+0x50>
		s1++, s2++;
  801275:	ff 45 fc             	incl   -0x4(%ebp)
  801278:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80127b:	8b 45 10             	mov    0x10(%ebp),%eax
  80127e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801281:	89 55 10             	mov    %edx,0x10(%ebp)
  801284:	85 c0                	test   %eax,%eax
  801286:	75 c9                	jne    801251 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801295:	8b 55 08             	mov    0x8(%ebp),%edx
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012a0:	eb 15                	jmp    8012b7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	0f b6 d0             	movzbl %al,%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	0f b6 c0             	movzbl %al,%eax
  8012b0:	39 c2                	cmp    %eax,%edx
  8012b2:	74 0d                	je     8012c1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012b4:	ff 45 08             	incl   0x8(%ebp)
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012bd:	72 e3                	jb     8012a2 <memfind+0x13>
  8012bf:	eb 01                	jmp    8012c2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8012c1:	90                   	nop
	return (void *) s;
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8012cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8012d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012db:	eb 03                	jmp    8012e0 <strtol+0x19>
		s++;
  8012dd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	3c 20                	cmp    $0x20,%al
  8012e7:	74 f4                	je     8012dd <strtol+0x16>
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	3c 09                	cmp    $0x9,%al
  8012f0:	74 eb                	je     8012dd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 2b                	cmp    $0x2b,%al
  8012f9:	75 05                	jne    801300 <strtol+0x39>
		s++;
  8012fb:	ff 45 08             	incl   0x8(%ebp)
  8012fe:	eb 13                	jmp    801313 <strtol+0x4c>
	else if (*s == '-')
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	3c 2d                	cmp    $0x2d,%al
  801307:	75 0a                	jne    801313 <strtol+0x4c>
		s++, neg = 1;
  801309:	ff 45 08             	incl   0x8(%ebp)
  80130c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801313:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801317:	74 06                	je     80131f <strtol+0x58>
  801319:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80131d:	75 20                	jne    80133f <strtol+0x78>
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	3c 30                	cmp    $0x30,%al
  801326:	75 17                	jne    80133f <strtol+0x78>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	40                   	inc    %eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 78                	cmp    $0x78,%al
  801330:	75 0d                	jne    80133f <strtol+0x78>
		s += 2, base = 16;
  801332:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801336:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80133d:	eb 28                	jmp    801367 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80133f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801343:	75 15                	jne    80135a <strtol+0x93>
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	3c 30                	cmp    $0x30,%al
  80134c:	75 0c                	jne    80135a <strtol+0x93>
		s++, base = 8;
  80134e:	ff 45 08             	incl   0x8(%ebp)
  801351:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801358:	eb 0d                	jmp    801367 <strtol+0xa0>
	else if (base == 0)
  80135a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135e:	75 07                	jne    801367 <strtol+0xa0>
		base = 10;
  801360:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	3c 2f                	cmp    $0x2f,%al
  80136e:	7e 19                	jle    801389 <strtol+0xc2>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	3c 39                	cmp    $0x39,%al
  801377:	7f 10                	jg     801389 <strtol+0xc2>
			dig = *s - '0';
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	0f be c0             	movsbl %al,%eax
  801381:	83 e8 30             	sub    $0x30,%eax
  801384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801387:	eb 42                	jmp    8013cb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	3c 60                	cmp    $0x60,%al
  801390:	7e 19                	jle    8013ab <strtol+0xe4>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	3c 7a                	cmp    $0x7a,%al
  801399:	7f 10                	jg     8013ab <strtol+0xe4>
			dig = *s - 'a' + 10;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	0f be c0             	movsbl %al,%eax
  8013a3:	83 e8 57             	sub    $0x57,%eax
  8013a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a9:	eb 20                	jmp    8013cb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 40                	cmp    $0x40,%al
  8013b2:	7e 39                	jle    8013ed <strtol+0x126>
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	3c 5a                	cmp    $0x5a,%al
  8013bb:	7f 30                	jg     8013ed <strtol+0x126>
			dig = *s - 'A' + 10;
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	0f be c0             	movsbl %al,%eax
  8013c5:	83 e8 37             	sub    $0x37,%eax
  8013c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8013cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ce:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013d1:	7d 19                	jge    8013ec <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8013d3:	ff 45 08             	incl   0x8(%ebp)
  8013d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013dd:	89 c2                	mov    %eax,%edx
  8013df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013e7:	e9 7b ff ff ff       	jmp    801367 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013ec:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013f1:	74 08                	je     8013fb <strtol+0x134>
		*endptr = (char *) s;
  8013f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ff:	74 07                	je     801408 <strtol+0x141>
  801401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801404:	f7 d8                	neg    %eax
  801406:	eb 03                	jmp    80140b <strtol+0x144>
  801408:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <ltostr>:

void
ltostr(long value, char *str)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801413:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80141a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801421:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801425:	79 13                	jns    80143a <ltostr+0x2d>
	{
		neg = 1;
  801427:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801434:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801437:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801442:	99                   	cltd   
  801443:	f7 f9                	idiv   %ecx
  801445:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801448:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144b:	8d 50 01             	lea    0x1(%eax),%edx
  80144e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801451:	89 c2                	mov    %eax,%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80145b:	83 c2 30             	add    $0x30,%edx
  80145e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801460:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801463:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801468:	f7 e9                	imul   %ecx
  80146a:	c1 fa 02             	sar    $0x2,%edx
  80146d:	89 c8                	mov    %ecx,%eax
  80146f:	c1 f8 1f             	sar    $0x1f,%eax
  801472:	29 c2                	sub    %eax,%edx
  801474:	89 d0                	mov    %edx,%eax
  801476:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801479:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80147d:	75 bb                	jne    80143a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80147f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	48                   	dec    %eax
  80148a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80148d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801491:	74 3d                	je     8014d0 <ltostr+0xc3>
		start = 1 ;
  801493:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80149a:	eb 34                	jmp    8014d0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80149c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	01 d0                	add    %edx,%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	01 c2                	add    %eax,%edx
  8014b1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b7:	01 c8                	add    %ecx,%eax
  8014b9:	8a 00                	mov    (%eax),%al
  8014bb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8014bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8014c8:	88 02                	mov    %al,(%edx)
		start++ ;
  8014ca:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014cd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014d6:	7c c4                	jl     80149c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	01 d0                	add    %edx,%eax
  8014e0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014ec:	ff 75 08             	pushl  0x8(%ebp)
  8014ef:	e8 c4 f9 ff ff       	call   800eb8 <strlen>
  8014f4:	83 c4 04             	add    $0x4,%esp
  8014f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014fa:	ff 75 0c             	pushl  0xc(%ebp)
  8014fd:	e8 b6 f9 ff ff       	call   800eb8 <strlen>
  801502:	83 c4 04             	add    $0x4,%esp
  801505:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80150f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801516:	eb 17                	jmp    80152f <strcconcat+0x49>
		final[s] = str1[s] ;
  801518:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151b:	8b 45 10             	mov    0x10(%ebp),%eax
  80151e:	01 c2                	add    %eax,%edx
  801520:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	01 c8                	add    %ecx,%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80152c:	ff 45 fc             	incl   -0x4(%ebp)
  80152f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801532:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801535:	7c e1                	jl     801518 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801537:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80153e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801545:	eb 1f                	jmp    801566 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801547:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154a:	8d 50 01             	lea    0x1(%eax),%edx
  80154d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801550:	89 c2                	mov    %eax,%edx
  801552:	8b 45 10             	mov    0x10(%ebp),%eax
  801555:	01 c2                	add    %eax,%edx
  801557:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80155a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155d:	01 c8                	add    %ecx,%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801563:	ff 45 f8             	incl   -0x8(%ebp)
  801566:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801569:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80156c:	7c d9                	jl     801547 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80156e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801571:	8b 45 10             	mov    0x10(%ebp),%eax
  801574:	01 d0                	add    %edx,%eax
  801576:	c6 00 00             	movb   $0x0,(%eax)
}
  801579:	90                   	nop
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80157f:	8b 45 14             	mov    0x14(%ebp),%eax
  801582:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801588:	8b 45 14             	mov    0x14(%ebp),%eax
  80158b:	8b 00                	mov    (%eax),%eax
  80158d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801594:	8b 45 10             	mov    0x10(%ebp),%eax
  801597:	01 d0                	add    %edx,%eax
  801599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80159f:	eb 0c                	jmp    8015ad <strsplit+0x31>
			*string++ = 0;
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	8d 50 01             	lea    0x1(%eax),%edx
  8015a7:	89 55 08             	mov    %edx,0x8(%ebp)
  8015aa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	84 c0                	test   %al,%al
  8015b4:	74 18                	je     8015ce <strsplit+0x52>
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	0f be c0             	movsbl %al,%eax
  8015be:	50                   	push   %eax
  8015bf:	ff 75 0c             	pushl  0xc(%ebp)
  8015c2:	e8 83 fa ff ff       	call   80104a <strchr>
  8015c7:	83 c4 08             	add    $0x8,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	75 d3                	jne    8015a1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	84 c0                	test   %al,%al
  8015d5:	74 5a                	je     801631 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015da:	8b 00                	mov    (%eax),%eax
  8015dc:	83 f8 0f             	cmp    $0xf,%eax
  8015df:	75 07                	jne    8015e8 <strsplit+0x6c>
		{
			return 0;
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e6:	eb 66                	jmp    80164e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015eb:	8b 00                	mov    (%eax),%eax
  8015ed:	8d 48 01             	lea    0x1(%eax),%ecx
  8015f0:	8b 55 14             	mov    0x14(%ebp),%edx
  8015f3:	89 0a                	mov    %ecx,(%edx)
  8015f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	01 c2                	add    %eax,%edx
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801606:	eb 03                	jmp    80160b <strsplit+0x8f>
			string++;
  801608:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	8a 00                	mov    (%eax),%al
  801610:	84 c0                	test   %al,%al
  801612:	74 8b                	je     80159f <strsplit+0x23>
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	0f be c0             	movsbl %al,%eax
  80161c:	50                   	push   %eax
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	e8 25 fa ff ff       	call   80104a <strchr>
  801625:	83 c4 08             	add    $0x8,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	74 dc                	je     801608 <strsplit+0x8c>
			string++;
	}
  80162c:	e9 6e ff ff ff       	jmp    80159f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801631:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801632:	8b 45 14             	mov    0x14(%ebp),%eax
  801635:	8b 00                	mov    (%eax),%eax
  801637:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801649:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80165c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801663:	eb 4a                	jmp    8016af <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801665:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	01 c2                	add    %eax,%edx
  80166d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801670:	8b 45 0c             	mov    0xc(%ebp),%eax
  801673:	01 c8                	add    %ecx,%eax
  801675:	8a 00                	mov    (%eax),%al
  801677:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801679:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167f:	01 d0                	add    %edx,%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 40                	cmp    $0x40,%al
  801685:	7e 25                	jle    8016ac <str2lower+0x5c>
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	3c 5a                	cmp    $0x5a,%al
  801693:	7f 17                	jg     8016ac <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801695:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	01 d0                	add    %edx,%eax
  80169d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a3:	01 ca                	add    %ecx,%edx
  8016a5:	8a 12                	mov    (%edx),%dl
  8016a7:	83 c2 20             	add    $0x20,%edx
  8016aa:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8016ac:	ff 45 fc             	incl   -0x4(%ebp)
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	e8 01 f8 ff ff       	call   800eb8 <strlen>
  8016b7:	83 c4 04             	add    $0x4,%esp
  8016ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016bd:	7f a6                	jg     801665 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8016bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	57                   	push   %edi
  8016c8:	56                   	push   %esi
  8016c9:	53                   	push   %ebx
  8016ca:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016dc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016df:	cd 30                	int    $0x30
  8016e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8016e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	5b                   	pop    %ebx
  8016eb:	5e                   	pop    %esi
  8016ec:	5f                   	pop    %edi
  8016ed:	5d                   	pop    %ebp
  8016ee:	c3                   	ret    

008016ef <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	6a 00                	push   $0x0
  801707:	51                   	push   %ecx
  801708:	52                   	push   %edx
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	50                   	push   %eax
  80170d:	6a 00                	push   $0x0
  80170f:	e8 b0 ff ff ff       	call   8016c4 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	90                   	nop
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_cgetc>:

int
sys_cgetc(void)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 02                	push   $0x2
  801729:	e8 96 ff ff ff       	call   8016c4 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 03                	push   $0x3
  801742:	e8 7d ff ff ff       	call   8016c4 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	90                   	nop
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 04                	push   $0x4
  80175c:	e8 63 ff ff ff       	call   8016c4 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	90                   	nop
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80176a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	52                   	push   %edx
  801777:	50                   	push   %eax
  801778:	6a 08                	push   $0x8
  80177a:	e8 45 ff ff ff       	call   8016c4 <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	56                   	push   %esi
  801788:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801789:	8b 75 18             	mov    0x18(%ebp),%esi
  80178c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	56                   	push   %esi
  801799:	53                   	push   %ebx
  80179a:	51                   	push   %ecx
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	6a 09                	push   $0x9
  80179f:	e8 20 ff ff ff       	call   8016c4 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    

008017ae <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	6a 0a                	push   $0xa
  8017be:	e8 01 ff ff ff       	call   8016c4 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	6a 0b                	push   $0xb
  8017d9:	e8 e6 fe ff ff       	call   8016c4 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 0c                	push   $0xc
  8017f2:	e8 cd fe ff ff       	call   8016c4 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 0d                	push   $0xd
  80180b:	e8 b4 fe ff ff       	call   8016c4 <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 0e                	push   $0xe
  801824:	e8 9b fe ff ff       	call   8016c4 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 0f                	push   $0xf
  80183d:	e8 82 fe ff ff       	call   8016c4 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	ff 75 08             	pushl  0x8(%ebp)
  801855:	6a 10                	push   $0x10
  801857:	e8 68 fe ff ff       	call   8016c4 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 11                	push   $0x11
  801870:	e8 4f fe ff ff       	call   8016c4 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_cputc>:

void
sys_cputc(const char c)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801887:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	50                   	push   %eax
  801894:	6a 01                	push   $0x1
  801896:	e8 29 fe ff ff       	call   8016c4 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	90                   	nop
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 14                	push   $0x14
  8018b0:	e8 0f fe ff ff       	call   8016c4 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	90                   	nop
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018c7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	6a 00                	push   $0x0
  8018d3:	51                   	push   %ecx
  8018d4:	52                   	push   %edx
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	50                   	push   %eax
  8018d9:	6a 15                	push   $0x15
  8018db:	e8 e4 fd ff ff       	call   8016c4 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	52                   	push   %edx
  8018f5:	50                   	push   %eax
  8018f6:	6a 16                	push   $0x16
  8018f8:	e8 c7 fd ff ff       	call   8016c4 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801905:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	51                   	push   %ecx
  801913:	52                   	push   %edx
  801914:	50                   	push   %eax
  801915:	6a 17                	push   $0x17
  801917:	e8 a8 fd ff ff       	call   8016c4 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	52                   	push   %edx
  801931:	50                   	push   %eax
  801932:	6a 18                	push   $0x18
  801934:	e8 8b fd ff ff       	call   8016c4 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	6a 00                	push   $0x0
  801946:	ff 75 14             	pushl  0x14(%ebp)
  801949:	ff 75 10             	pushl  0x10(%ebp)
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	50                   	push   %eax
  801950:	6a 19                	push   $0x19
  801952:	e8 6d fd ff ff       	call   8016c4 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	50                   	push   %eax
  80196b:	6a 1a                	push   $0x1a
  80196d:	e8 52 fd ff ff       	call   8016c4 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	90                   	nop
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	50                   	push   %eax
  801987:	6a 1b                	push   $0x1b
  801989:	e8 36 fd ff ff       	call   8016c4 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 05                	push   $0x5
  8019a2:	e8 1d fd ff ff       	call   8016c4 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 06                	push   $0x6
  8019bb:	e8 04 fd ff ff       	call   8016c4 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 07                	push   $0x7
  8019d4:	e8 eb fc ff ff       	call   8016c4 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_exit_env>:


void sys_exit_env(void)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 1c                	push   $0x1c
  8019ed:	e8 d2 fc ff ff       	call   8016c4 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a01:	8d 50 04             	lea    0x4(%eax),%edx
  801a04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 1d                	push   $0x1d
  801a11:	e8 ae fc ff ff       	call   8016c4 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
	return result;
  801a19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a22:	89 01                	mov    %eax,(%ecx)
  801a24:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	c9                   	leave  
  801a2b:	c2 04 00             	ret    $0x4

00801a2e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	ff 75 10             	pushl  0x10(%ebp)
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	ff 75 08             	pushl  0x8(%ebp)
  801a3e:	6a 13                	push   $0x13
  801a40:	e8 7f fc ff ff       	call   8016c4 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
	return ;
  801a48:	90                   	nop
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_rcr2>:
uint32 sys_rcr2()
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 1e                	push   $0x1e
  801a5a:	e8 65 fc ff ff       	call   8016c4 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a70:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	50                   	push   %eax
  801a7d:	6a 1f                	push   $0x1f
  801a7f:	e8 40 fc ff ff       	call   8016c4 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
	return ;
  801a87:	90                   	nop
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <rsttst>:
void rsttst()
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 21                	push   $0x21
  801a99:	e8 26 fc ff ff       	call   8016c4 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa1:	90                   	nop
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  801aad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ab0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ab3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab7:	52                   	push   %edx
  801ab8:	50                   	push   %eax
  801ab9:	ff 75 10             	pushl  0x10(%ebp)
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	ff 75 08             	pushl  0x8(%ebp)
  801ac2:	6a 20                	push   $0x20
  801ac4:	e8 fb fb ff ff       	call   8016c4 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
	return ;
  801acc:	90                   	nop
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <chktst>:
void chktst(uint32 n)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	6a 22                	push   $0x22
  801adf:	e8 e0 fb ff ff       	call   8016c4 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae7:	90                   	nop
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <inctst>:

void inctst()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 23                	push   $0x23
  801af9:	e8 c6 fb ff ff       	call   8016c4 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <gettst>:
uint32 gettst()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 24                	push   $0x24
  801b13:	e8 ac fb ff ff       	call   8016c4 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 25                	push   $0x25
  801b2c:	e8 93 fb ff ff       	call   8016c4 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
  801b34:	a3 40 71 82 00       	mov    %eax,0x827140
	return uheapPlaceStrategy ;
  801b39:	a1 40 71 82 00       	mov    0x827140,%eax
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	a3 40 71 82 00       	mov    %eax,0x827140
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	6a 26                	push   $0x26
  801b58:	e8 67 fb ff ff       	call   8016c4 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b60:	90                   	nop
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	53                   	push   %ebx
  801b76:	51                   	push   %ecx
  801b77:	52                   	push   %edx
  801b78:	50                   	push   %eax
  801b79:	6a 27                	push   $0x27
  801b7b:	e8 44 fb ff ff       	call   8016c4 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 28                	push   $0x28
  801b9b:	e8 24 fb ff ff       	call   8016c4 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ba8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	51                   	push   %ecx
  801bb4:	ff 75 10             	pushl  0x10(%ebp)
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 29                	push   $0x29
  801bbb:	e8 04 fb ff ff       	call   8016c4 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 10             	pushl  0x10(%ebp)
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	6a 12                	push   $0x12
  801bd7:	e8 e8 fa ff ff       	call   8016c4 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdf:	90                   	nop
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 2a                	push   $0x2a
  801bf5:	e8 ca fa ff ff       	call   8016c4 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
	return;
  801bfd:	90                   	nop
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 2b                	push   $0x2b
  801c0f:	e8 b0 fa ff ff       	call   8016c4 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	ff 75 0c             	pushl  0xc(%ebp)
  801c25:	ff 75 08             	pushl  0x8(%ebp)
  801c28:	6a 2d                	push   $0x2d
  801c2a:	e8 95 fa ff ff       	call   8016c4 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
	return;
  801c32:	90                   	nop
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	ff 75 0c             	pushl  0xc(%ebp)
  801c41:	ff 75 08             	pushl  0x8(%ebp)
  801c44:	6a 2c                	push   $0x2c
  801c46:	e8 79 fa ff ff       	call   8016c4 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	68 e8 28 80 00       	push   $0x8028e8
  801c5f:	68 25 01 00 00       	push   $0x125
  801c64:	68 1b 29 80 00       	push   $0x80291b
  801c69:	e8 a3 e8 ff ff       	call   800511 <_panic>
  801c6e:	66 90                	xchg   %ax,%ax

00801c70 <__udivdi3>:
  801c70:	55                   	push   %ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
  801c77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c87:	89 ca                	mov    %ecx,%edx
  801c89:	89 f8                	mov    %edi,%eax
  801c8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c8f:	85 f6                	test   %esi,%esi
  801c91:	75 2d                	jne    801cc0 <__udivdi3+0x50>
  801c93:	39 cf                	cmp    %ecx,%edi
  801c95:	77 65                	ja     801cfc <__udivdi3+0x8c>
  801c97:	89 fd                	mov    %edi,%ebp
  801c99:	85 ff                	test   %edi,%edi
  801c9b:	75 0b                	jne    801ca8 <__udivdi3+0x38>
  801c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca2:	31 d2                	xor    %edx,%edx
  801ca4:	f7 f7                	div    %edi
  801ca6:	89 c5                	mov    %eax,%ebp
  801ca8:	31 d2                	xor    %edx,%edx
  801caa:	89 c8                	mov    %ecx,%eax
  801cac:	f7 f5                	div    %ebp
  801cae:	89 c1                	mov    %eax,%ecx
  801cb0:	89 d8                	mov    %ebx,%eax
  801cb2:	f7 f5                	div    %ebp
  801cb4:	89 cf                	mov    %ecx,%edi
  801cb6:	89 fa                	mov    %edi,%edx
  801cb8:	83 c4 1c             	add    $0x1c,%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5e                   	pop    %esi
  801cbd:	5f                   	pop    %edi
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    
  801cc0:	39 ce                	cmp    %ecx,%esi
  801cc2:	77 28                	ja     801cec <__udivdi3+0x7c>
  801cc4:	0f bd fe             	bsr    %esi,%edi
  801cc7:	83 f7 1f             	xor    $0x1f,%edi
  801cca:	75 40                	jne    801d0c <__udivdi3+0x9c>
  801ccc:	39 ce                	cmp    %ecx,%esi
  801cce:	72 0a                	jb     801cda <__udivdi3+0x6a>
  801cd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cd4:	0f 87 9e 00 00 00    	ja     801d78 <__udivdi3+0x108>
  801cda:	b8 01 00 00 00       	mov    $0x1,%eax
  801cdf:	89 fa                	mov    %edi,%edx
  801ce1:	83 c4 1c             	add    $0x1c,%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5f                   	pop    %edi
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    
  801ce9:	8d 76 00             	lea    0x0(%esi),%esi
  801cec:	31 ff                	xor    %edi,%edi
  801cee:	31 c0                	xor    %eax,%eax
  801cf0:	89 fa                	mov    %edi,%edx
  801cf2:	83 c4 1c             	add    $0x1c,%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5f                   	pop    %edi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	89 d8                	mov    %ebx,%eax
  801cfe:	f7 f7                	div    %edi
  801d00:	31 ff                	xor    %edi,%edi
  801d02:	89 fa                	mov    %edi,%edx
  801d04:	83 c4 1c             	add    $0x1c,%esp
  801d07:	5b                   	pop    %ebx
  801d08:	5e                   	pop    %esi
  801d09:	5f                   	pop    %edi
  801d0a:	5d                   	pop    %ebp
  801d0b:	c3                   	ret    
  801d0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d11:	89 eb                	mov    %ebp,%ebx
  801d13:	29 fb                	sub    %edi,%ebx
  801d15:	89 f9                	mov    %edi,%ecx
  801d17:	d3 e6                	shl    %cl,%esi
  801d19:	89 c5                	mov    %eax,%ebp
  801d1b:	88 d9                	mov    %bl,%cl
  801d1d:	d3 ed                	shr    %cl,%ebp
  801d1f:	89 e9                	mov    %ebp,%ecx
  801d21:	09 f1                	or     %esi,%ecx
  801d23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d27:	89 f9                	mov    %edi,%ecx
  801d29:	d3 e0                	shl    %cl,%eax
  801d2b:	89 c5                	mov    %eax,%ebp
  801d2d:	89 d6                	mov    %edx,%esi
  801d2f:	88 d9                	mov    %bl,%cl
  801d31:	d3 ee                	shr    %cl,%esi
  801d33:	89 f9                	mov    %edi,%ecx
  801d35:	d3 e2                	shl    %cl,%edx
  801d37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3b:	88 d9                	mov    %bl,%cl
  801d3d:	d3 e8                	shr    %cl,%eax
  801d3f:	09 c2                	or     %eax,%edx
  801d41:	89 d0                	mov    %edx,%eax
  801d43:	89 f2                	mov    %esi,%edx
  801d45:	f7 74 24 0c          	divl   0xc(%esp)
  801d49:	89 d6                	mov    %edx,%esi
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	f7 e5                	mul    %ebp
  801d4f:	39 d6                	cmp    %edx,%esi
  801d51:	72 19                	jb     801d6c <__udivdi3+0xfc>
  801d53:	74 0b                	je     801d60 <__udivdi3+0xf0>
  801d55:	89 d8                	mov    %ebx,%eax
  801d57:	31 ff                	xor    %edi,%edi
  801d59:	e9 58 ff ff ff       	jmp    801cb6 <__udivdi3+0x46>
  801d5e:	66 90                	xchg   %ax,%ax
  801d60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d64:	89 f9                	mov    %edi,%ecx
  801d66:	d3 e2                	shl    %cl,%edx
  801d68:	39 c2                	cmp    %eax,%edx
  801d6a:	73 e9                	jae    801d55 <__udivdi3+0xe5>
  801d6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d6f:	31 ff                	xor    %edi,%edi
  801d71:	e9 40 ff ff ff       	jmp    801cb6 <__udivdi3+0x46>
  801d76:	66 90                	xchg   %ax,%ax
  801d78:	31 c0                	xor    %eax,%eax
  801d7a:	e9 37 ff ff ff       	jmp    801cb6 <__udivdi3+0x46>
  801d7f:	90                   	nop

00801d80 <__umoddi3>:
  801d80:	55                   	push   %ebp
  801d81:	57                   	push   %edi
  801d82:	56                   	push   %esi
  801d83:	53                   	push   %ebx
  801d84:	83 ec 1c             	sub    $0x1c,%esp
  801d87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d9f:	89 f3                	mov    %esi,%ebx
  801da1:	89 fa                	mov    %edi,%edx
  801da3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801da7:	89 34 24             	mov    %esi,(%esp)
  801daa:	85 c0                	test   %eax,%eax
  801dac:	75 1a                	jne    801dc8 <__umoddi3+0x48>
  801dae:	39 f7                	cmp    %esi,%edi
  801db0:	0f 86 a2 00 00 00    	jbe    801e58 <__umoddi3+0xd8>
  801db6:	89 c8                	mov    %ecx,%eax
  801db8:	89 f2                	mov    %esi,%edx
  801dba:	f7 f7                	div    %edi
  801dbc:	89 d0                	mov    %edx,%eax
  801dbe:	31 d2                	xor    %edx,%edx
  801dc0:	83 c4 1c             	add    $0x1c,%esp
  801dc3:	5b                   	pop    %ebx
  801dc4:	5e                   	pop    %esi
  801dc5:	5f                   	pop    %edi
  801dc6:	5d                   	pop    %ebp
  801dc7:	c3                   	ret    
  801dc8:	39 f0                	cmp    %esi,%eax
  801dca:	0f 87 ac 00 00 00    	ja     801e7c <__umoddi3+0xfc>
  801dd0:	0f bd e8             	bsr    %eax,%ebp
  801dd3:	83 f5 1f             	xor    $0x1f,%ebp
  801dd6:	0f 84 ac 00 00 00    	je     801e88 <__umoddi3+0x108>
  801ddc:	bf 20 00 00 00       	mov    $0x20,%edi
  801de1:	29 ef                	sub    %ebp,%edi
  801de3:	89 fe                	mov    %edi,%esi
  801de5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801de9:	89 e9                	mov    %ebp,%ecx
  801deb:	d3 e0                	shl    %cl,%eax
  801ded:	89 d7                	mov    %edx,%edi
  801def:	89 f1                	mov    %esi,%ecx
  801df1:	d3 ef                	shr    %cl,%edi
  801df3:	09 c7                	or     %eax,%edi
  801df5:	89 e9                	mov    %ebp,%ecx
  801df7:	d3 e2                	shl    %cl,%edx
  801df9:	89 14 24             	mov    %edx,(%esp)
  801dfc:	89 d8                	mov    %ebx,%eax
  801dfe:	d3 e0                	shl    %cl,%eax
  801e00:	89 c2                	mov    %eax,%edx
  801e02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e06:	d3 e0                	shl    %cl,%eax
  801e08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e10:	89 f1                	mov    %esi,%ecx
  801e12:	d3 e8                	shr    %cl,%eax
  801e14:	09 d0                	or     %edx,%eax
  801e16:	d3 eb                	shr    %cl,%ebx
  801e18:	89 da                	mov    %ebx,%edx
  801e1a:	f7 f7                	div    %edi
  801e1c:	89 d3                	mov    %edx,%ebx
  801e1e:	f7 24 24             	mull   (%esp)
  801e21:	89 c6                	mov    %eax,%esi
  801e23:	89 d1                	mov    %edx,%ecx
  801e25:	39 d3                	cmp    %edx,%ebx
  801e27:	0f 82 87 00 00 00    	jb     801eb4 <__umoddi3+0x134>
  801e2d:	0f 84 91 00 00 00    	je     801ec4 <__umoddi3+0x144>
  801e33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e37:	29 f2                	sub    %esi,%edx
  801e39:	19 cb                	sbb    %ecx,%ebx
  801e3b:	89 d8                	mov    %ebx,%eax
  801e3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e41:	d3 e0                	shl    %cl,%eax
  801e43:	89 e9                	mov    %ebp,%ecx
  801e45:	d3 ea                	shr    %cl,%edx
  801e47:	09 d0                	or     %edx,%eax
  801e49:	89 e9                	mov    %ebp,%ecx
  801e4b:	d3 eb                	shr    %cl,%ebx
  801e4d:	89 da                	mov    %ebx,%edx
  801e4f:	83 c4 1c             	add    $0x1c,%esp
  801e52:	5b                   	pop    %ebx
  801e53:	5e                   	pop    %esi
  801e54:	5f                   	pop    %edi
  801e55:	5d                   	pop    %ebp
  801e56:	c3                   	ret    
  801e57:	90                   	nop
  801e58:	89 fd                	mov    %edi,%ebp
  801e5a:	85 ff                	test   %edi,%edi
  801e5c:	75 0b                	jne    801e69 <__umoddi3+0xe9>
  801e5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f7                	div    %edi
  801e67:	89 c5                	mov    %eax,%ebp
  801e69:	89 f0                	mov    %esi,%eax
  801e6b:	31 d2                	xor    %edx,%edx
  801e6d:	f7 f5                	div    %ebp
  801e6f:	89 c8                	mov    %ecx,%eax
  801e71:	f7 f5                	div    %ebp
  801e73:	89 d0                	mov    %edx,%eax
  801e75:	e9 44 ff ff ff       	jmp    801dbe <__umoddi3+0x3e>
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	89 c8                	mov    %ecx,%eax
  801e7e:	89 f2                	mov    %esi,%edx
  801e80:	83 c4 1c             	add    $0x1c,%esp
  801e83:	5b                   	pop    %ebx
  801e84:	5e                   	pop    %esi
  801e85:	5f                   	pop    %edi
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    
  801e88:	3b 04 24             	cmp    (%esp),%eax
  801e8b:	72 06                	jb     801e93 <__umoddi3+0x113>
  801e8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e91:	77 0f                	ja     801ea2 <__umoddi3+0x122>
  801e93:	89 f2                	mov    %esi,%edx
  801e95:	29 f9                	sub    %edi,%ecx
  801e97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e9b:	89 14 24             	mov    %edx,(%esp)
  801e9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ea2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ea6:	8b 14 24             	mov    (%esp),%edx
  801ea9:	83 c4 1c             	add    $0x1c,%esp
  801eac:	5b                   	pop    %ebx
  801ead:	5e                   	pop    %esi
  801eae:	5f                   	pop    %edi
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    
  801eb1:	8d 76 00             	lea    0x0(%esi),%esi
  801eb4:	2b 04 24             	sub    (%esp),%eax
  801eb7:	19 fa                	sbb    %edi,%edx
  801eb9:	89 d1                	mov    %edx,%ecx
  801ebb:	89 c6                	mov    %eax,%esi
  801ebd:	e9 71 ff ff ff       	jmp    801e33 <__umoddi3+0xb3>
  801ec2:	66 90                	xchg   %ax,%ax
  801ec4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ec8:	72 ea                	jb     801eb4 <__umoddi3+0x134>
  801eca:	89 d9                	mov    %ebx,%ecx
  801ecc:	e9 62 ff ff ff       	jmp    801e33 <__umoddi3+0xb3>
