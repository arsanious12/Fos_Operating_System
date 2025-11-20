
obj/user/tst_page_replacement_optimal_1:     file format elf32-i386


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
  800031:	e8 99 02 00 00       	call   8002cf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x806000, 0x807000, 0x808000, 0x800000, 0x803000, 0x801000, 0xeebfd000, 0x804000, 0x809000,
		0x80a000, 0x80b000, 0x80c000, 0x827000, 0x802000, 0x800000, 0x803000, 0xeebfd000, 0x801000,
		0x827000
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  800044:	6a 01                	push   $0x1
  800046:	68 00 00 80 00       	push   $0x800000
  80004b:	6a 0b                	push   $0xb
  80004d:	68 20 30 80 00       	push   $0x803020
  800052:	e8 bc 1a 00 00       	call   801b13 <sys_check_WS_list>
  800057:	83 c4 10             	add    $0x10,%esp
  80005a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  80005d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800060:	83 f8 01             	cmp    $0x1,%eax
  800063:	74 14                	je     800079 <_main+0x41>
  800065:	83 ec 04             	sub    $0x4,%esp
  800068:	68 40 1e 80 00       	push   $0x801e40
  80006d:	6a 1e                	push   $0x1e
  80006f:	68 b4 1e 80 00       	push   $0x801eb4
  800074:	e8 06 04 00 00       	call   80047f <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800079:	e8 d3 16 00 00       	call   801751 <sys_calculate_free_frames>
  80007e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800081:	e8 16 17 00 00       	call   80179c <sys_pf_calculate_allocated_pages>
  800086:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800089:	c6 05 1f d1 80 00 61 	movb   $0x61,0x80d11f

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800090:	a0 1f e1 80 00       	mov    0x80e11f,%al
  800095:	88 45 db             	mov    %al,-0x25(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800098:	a0 1f f1 80 00       	mov    0x80f11f,%al
  80009d:	88 45 da             	mov    %al,-0x26(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000a7:	eb 26                	jmp    8000cf <_main+0x97>
	{
		__arr__[i] = -1 ;
  8000a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ac:	05 20 31 80 00       	add    $0x803120,%eax
  8000b1:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  8000b4:	a1 00 30 80 00       	mov    0x803000,%eax
  8000b9:	8a 00                	mov    (%eax),%al
  8000bb:	88 45 d9             	mov    %al,-0x27(%ebp)
		garbage5 = *__ptr2__ ;
  8000be:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c3:	8a 00                	mov    (%eax),%al
  8000c5:	88 45 d8             	mov    %al,-0x28(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c8:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8000cf:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  8000d6:	7e d1                	jle    8000a9 <_main+0x71>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking INITIAL WS... \n");
  8000d8:	83 ec 08             	sub    $0x8,%esp
  8000db:	68 da 1e 80 00       	push   $0x801eda
  8000e0:	6a 03                	push   $0x3
  8000e2:	e8 93 06 00 00       	call   80077a <cprintf_colored>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  8000ea:	6a 01                	push   $0x1
  8000ec:	68 00 00 80 00       	push   $0x800000
  8000f1:	6a 0b                	push   $0xb
  8000f3:	68 20 30 80 00       	push   $0x803020
  8000f8:	e8 16 1a 00 00       	call   801b13 <sys_check_WS_list>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (found != 1) panic("OPTIMAL alg. failed.. the initial working set is changed while it's not expected to");
  800103:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800106:	83 f8 01             	cmp    $0x1,%eax
  800109:	74 14                	je     80011f <_main+0xe7>
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	68 f8 1e 80 00       	push   $0x801ef8
  800113:	6a 41                	push   $0x41
  800115:	68 b4 1e 80 00       	push   $0x801eb4
  80011a:	e8 60 03 00 00       	call   80047f <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking EXPECTED REFERENCE STREAM... \n");
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	68 4c 1f 80 00       	push   $0x801f4c
  800127:	6a 03                	push   $0x3
  800129:	e8 4c 06 00 00       	call   80077a <cprintf_colored>
  80012e:	83 c4 10             	add    $0x10,%esp
	{
		char separator[2] = "@";
  800131:	66 c7 45 ca 40 00    	movw   $0x40,-0x36(%ebp)
		char checkRefStreamCmd[100] = "__CheckRefStream@";
  800137:	8d 85 ee fe ff ff    	lea    -0x112(%ebp),%eax
  80013d:	bb 05 21 80 00       	mov    $0x802105,%ebx
  800142:	ba 12 00 00 00       	mov    $0x12,%edx
  800147:	89 c7                	mov    %eax,%edi
  800149:	89 de                	mov    %ebx,%esi
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80014f:	8d 95 00 ff ff ff    	lea    -0x100(%ebp),%edx
  800155:	b9 52 00 00 00       	mov    $0x52,%ecx
  80015a:	b0 00                	mov    $0x0,%al
  80015c:	89 d7                	mov    %edx,%edi
  80015e:	f3 aa                	rep stos %al,%es:(%edi)
		char token[20] ;
		char cmdWithCnt[100] ;
		ltostr(EXPECTED_REF_CNT, token);
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800166:	50                   	push   %eax
  800167:	6a 1c                	push   $0x1c
  800169:	e8 0d 12 00 00       	call   80137b <ltostr>
  80016e:	83 c4 10             	add    $0x10,%esp
		strcconcat(checkRefStreamCmd, token, cmdWithCnt);
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  80017e:	50                   	push   %eax
  80017f:	8d 85 ee fe ff ff    	lea    -0x112(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	e8 c9 12 00 00       	call   801454 <strcconcat>
  80018b:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  800197:	50                   	push   %eax
  800198:	8d 45 ca             	lea    -0x36(%ebp),%eax
  80019b:	50                   	push   %eax
  80019c:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001a2:	50                   	push   %eax
  8001a3:	e8 ac 12 00 00       	call   801454 <strcconcat>
  8001a8:	83 c4 10             	add    $0x10,%esp
		ltostr((uint32)&expectedRefStream, token);
  8001ab:	ba 60 30 80 00       	mov    $0x803060,%edx
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	52                   	push   %edx
  8001b8:	e8 be 11 00 00       	call   80137b <ltostr>
  8001bd:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, token, cmdWithCnt);
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  8001cd:	50                   	push   %eax
  8001ce:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	e8 7a 12 00 00       	call   801454 <strcconcat>
  8001da:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	8d 45 ca             	lea    -0x36(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001f1:	50                   	push   %eax
  8001f2:	e8 5d 12 00 00       	call   801454 <strcconcat>
  8001f7:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("%~Ref Command = %s\n", cmdWithCnt);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  800203:	50                   	push   %eax
  800204:	68 77 1f 80 00       	push   $0x801f77
  800209:	e8 b1 05 00 00       	call   8007bf <atomic_cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp

		sys_utilities(cmdWithCnt, (uint32)&found);
  800211:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	e8 2c 19 00 00       	call   801b50 <sys_utilities>
  800224:	83 c4 10             	add    $0x10,%esp

		if (found != 1) panic("OPTIMAL alg. failed.. unexpected page reference stream!");
  800227:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80022a:	83 f8 01             	cmp    $0x1,%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 8c 1f 80 00       	push   $0x801f8c
  800237:	6a 54                	push   $0x54
  800239:	68 b4 1e 80 00       	push   $0x801eb4
  80023e:	e8 3c 02 00 00       	call   80047f <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	68 c4 1f 80 00       	push   $0x801fc4
  80024b:	6a 03                	push   $0x3
  80024d:	e8 28 05 00 00       	call   80077a <cprintf_colored>
  800252:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800255:	e8 42 15 00 00       	call   80179c <sys_pf_calculate_allocated_pages>
  80025a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80025d:	74 14                	je     800273 <_main+0x23b>
  80025f:	83 ec 04             	sub    $0x4,%esp
  800262:	68 f4 1f 80 00       	push   $0x801ff4
  800267:	6a 58                	push   $0x58
  800269:	68 b4 1e 80 00       	push   $0x801eb4
  80026e:	e8 0c 02 00 00       	call   80047f <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800273:	e8 d9 14 00 00       	call   801751 <sys_calculate_free_frames>
  800278:	89 c3                	mov    %eax,%ebx
  80027a:	e8 eb 14 00 00       	call   80176a <sys_calculate_modified_frames>
  80027f:	01 d8                	add    %ebx,%eax
  800281:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int expectedNumOfFrames = 7;
  800284:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		if( (freePages - freePagesAfter) != expectedNumOfFrames)
  80028b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800291:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800294:	74 1e                	je     8002b4 <_main+0x27c>
			panic("Unexpected number of allocated frames in RAM. Expected = %d, Actual = %d", expectedNumOfFrames, (freePages - freePagesAfter));
  800296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800299:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	50                   	push   %eax
  8002a0:	ff 75 d0             	pushl  -0x30(%ebp)
  8002a3:	68 60 20 80 00       	push   $0x802060
  8002a8:	6a 5d                	push   $0x5d
  8002aa:	68 b4 1e 80 00       	push   $0x801eb4
  8002af:	e8 cb 01 00 00       	call   80047f <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #1 [OPTIMAL Alg.] is completed successfully.\n");
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	68 ac 20 80 00       	push   $0x8020ac
  8002bc:	6a 0a                	push   $0xa
  8002be:	e8 b7 04 00 00       	call   80077a <cprintf_colored>
  8002c3:	83 c4 10             	add    $0x10,%esp
	return;
  8002c6:	90                   	nop
}
  8002c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ca:	5b                   	pop    %ebx
  8002cb:	5e                   	pop    %esi
  8002cc:	5f                   	pop    %edi
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	57                   	push   %edi
  8002d3:	56                   	push   %esi
  8002d4:	53                   	push   %ebx
  8002d5:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002d8:	e8 3d 16 00 00       	call   80191a <sys_getenvindex>
  8002dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	c1 e0 02             	shl    $0x2,%eax
  8002e8:	01 d0                	add    %edx,%eax
  8002ea:	c1 e0 03             	shl    $0x3,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002f6:	01 d0                	add    %edx,%eax
  8002f8:	c1 e0 02             	shl    $0x2,%eax
  8002fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800300:	a3 e0 30 80 00       	mov    %eax,0x8030e0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800305:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80030a:	8a 40 20             	mov    0x20(%eax),%al
  80030d:	84 c0                	test   %al,%al
  80030f:	74 0d                	je     80031e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800311:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800316:	83 c0 20             	add    $0x20,%eax
  800319:	a3 d4 30 80 00       	mov    %eax,0x8030d4

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800322:	7e 0a                	jle    80032e <libmain+0x5f>
		binaryname = argv[0];
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
  800327:	8b 00                	mov    (%eax),%eax
  800329:	a3 d4 30 80 00       	mov    %eax,0x8030d4

	// call user main routine
	_main(argc, argv);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 0c             	pushl  0xc(%ebp)
  800334:	ff 75 08             	pushl  0x8(%ebp)
  800337:	e8 fc fc ff ff       	call   800038 <_main>
  80033c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80033f:	a1 d0 30 80 00       	mov    0x8030d0,%eax
  800344:	85 c0                	test   %eax,%eax
  800346:	0f 84 01 01 00 00    	je     80044d <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80034c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800352:	bb 64 22 80 00       	mov    $0x802264,%ebx
  800357:	ba 0e 00 00 00       	mov    $0xe,%edx
  80035c:	89 c7                	mov    %eax,%edi
  80035e:	89 de                	mov    %ebx,%esi
  800360:	89 d1                	mov    %edx,%ecx
  800362:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800364:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800367:	b9 56 00 00 00       	mov    $0x56,%ecx
  80036c:	b0 00                	mov    $0x0,%al
  80036e:	89 d7                	mov    %edx,%edi
  800370:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800372:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800379:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	50                   	push   %eax
  800380:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	e8 c4 17 00 00       	call   801b50 <sys_utilities>
  80038c:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80038f:	e8 0d 13 00 00       	call   8016a1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800394:	83 ec 0c             	sub    $0xc,%esp
  800397:	68 84 21 80 00       	push   $0x802184
  80039c:	e8 ac 03 00 00       	call   80074d <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	74 18                	je     8003c3 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ab:	e8 be 17 00 00       	call   801b6e <sys_get_optimal_num_faults>
  8003b0:	83 ec 08             	sub    $0x8,%esp
  8003b3:	50                   	push   %eax
  8003b4:	68 ac 21 80 00       	push   $0x8021ac
  8003b9:	e8 8f 03 00 00       	call   80074d <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
  8003c1:	eb 59                	jmp    80041c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003c3:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003c8:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003ce:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003d3:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	52                   	push   %edx
  8003dd:	50                   	push   %eax
  8003de:	68 d0 21 80 00       	push   $0x8021d0
  8003e3:	e8 65 03 00 00       	call   80074d <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003eb:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003f0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003f6:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003fb:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800401:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800406:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80040c:	51                   	push   %ecx
  80040d:	52                   	push   %edx
  80040e:	50                   	push   %eax
  80040f:	68 f8 21 80 00       	push   $0x8021f8
  800414:	e8 34 03 00 00       	call   80074d <cprintf>
  800419:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80041c:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800421:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	50                   	push   %eax
  80042b:	68 50 22 80 00       	push   $0x802250
  800430:	e8 18 03 00 00       	call   80074d <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800438:	83 ec 0c             	sub    $0xc,%esp
  80043b:	68 84 21 80 00       	push   $0x802184
  800440:	e8 08 03 00 00       	call   80074d <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800448:	e8 6e 12 00 00       	call   8016bb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80044d:	e8 1f 00 00 00       	call   800471 <exit>
}
  800452:	90                   	nop
  800453:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800456:	5b                   	pop    %ebx
  800457:	5e                   	pop    %esi
  800458:	5f                   	pop    %edi
  800459:	5d                   	pop    %ebp
  80045a:	c3                   	ret    

0080045b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800461:	83 ec 0c             	sub    $0xc,%esp
  800464:	6a 00                	push   $0x0
  800466:	e8 7b 14 00 00       	call   8018e6 <sys_destroy_env>
  80046b:	83 c4 10             	add    $0x10,%esp
}
  80046e:	90                   	nop
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <exit>:

void
exit(void)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800477:	e8 d0 14 00 00       	call   80194c <sys_exit_env>
}
  80047c:	90                   	nop
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800485:	8d 45 10             	lea    0x10(%ebp),%eax
  800488:	83 c0 04             	add    $0x4,%eax
  80048b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80048e:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  800493:	85 c0                	test   %eax,%eax
  800495:	74 16                	je     8004ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800497:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	50                   	push   %eax
  8004a0:	68 c8 22 80 00       	push   $0x8022c8
  8004a5:	e8 a3 02 00 00       	call   80074d <cprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004ad:	a1 d4 30 80 00       	mov    0x8030d4,%eax
  8004b2:	83 ec 0c             	sub    $0xc,%esp
  8004b5:	ff 75 0c             	pushl  0xc(%ebp)
  8004b8:	ff 75 08             	pushl  0x8(%ebp)
  8004bb:	50                   	push   %eax
  8004bc:	68 d0 22 80 00       	push   $0x8022d0
  8004c1:	6a 74                	push   $0x74
  8004c3:	e8 b2 02 00 00       	call   80077a <cprintf_colored>
  8004c8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d4:	50                   	push   %eax
  8004d5:	e8 04 02 00 00       	call   8006de <vcprintf>
  8004da:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	6a 00                	push   $0x0
  8004e2:	68 f8 22 80 00       	push   $0x8022f8
  8004e7:	e8 f2 01 00 00       	call   8006de <vcprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ef:	e8 7d ff ff ff       	call   800471 <exit>

	// should not return here
	while (1) ;
  8004f4:	eb fe                	jmp    8004f4 <_panic+0x75>

008004f6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004fc:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800501:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050a:	39 c2                	cmp    %eax,%edx
  80050c:	74 14                	je     800522 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80050e:	83 ec 04             	sub    $0x4,%esp
  800511:	68 fc 22 80 00       	push   $0x8022fc
  800516:	6a 26                	push   $0x26
  800518:	68 48 23 80 00       	push   $0x802348
  80051d:	e8 5d ff ff ff       	call   80047f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800522:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800529:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800530:	e9 c5 00 00 00       	jmp    8005fa <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800538:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	01 d0                	add    %edx,%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	85 c0                	test   %eax,%eax
  800548:	75 08                	jne    800552 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80054a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80054d:	e9 a5 00 00 00       	jmp    8005f7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800552:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800559:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800560:	eb 69                	jmp    8005cb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800562:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800567:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80056d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800570:	89 d0                	mov    %edx,%eax
  800572:	01 c0                	add    %eax,%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	c1 e0 03             	shl    $0x3,%eax
  800579:	01 c8                	add    %ecx,%eax
  80057b:	8a 40 04             	mov    0x4(%eax),%al
  80057e:	84 c0                	test   %al,%al
  800580:	75 46                	jne    8005c8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800582:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800587:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80058d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 03             	shl    $0x3,%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	01 c8                	add    %ecx,%eax
  8005b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005bb:	39 c2                	cmp    %eax,%edx
  8005bd:	75 09                	jne    8005c8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005c6:	eb 15                	jmp    8005dd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c8:	ff 45 e8             	incl   -0x18(%ebp)
  8005cb:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8005d0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d9:	39 c2                	cmp    %eax,%edx
  8005db:	77 85                	ja     800562 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005e1:	75 14                	jne    8005f7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005e3:	83 ec 04             	sub    $0x4,%esp
  8005e6:	68 54 23 80 00       	push   $0x802354
  8005eb:	6a 3a                	push   $0x3a
  8005ed:	68 48 23 80 00       	push   $0x802348
  8005f2:	e8 88 fe ff ff       	call   80047f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005f7:	ff 45 f0             	incl   -0x10(%ebp)
  8005fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800600:	0f 8c 2f ff ff ff    	jl     800535 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800606:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800614:	eb 26                	jmp    80063c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800616:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80061b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800621:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800624:	89 d0                	mov    %edx,%eax
  800626:	01 c0                	add    %eax,%eax
  800628:	01 d0                	add    %edx,%eax
  80062a:	c1 e0 03             	shl    $0x3,%eax
  80062d:	01 c8                	add    %ecx,%eax
  80062f:	8a 40 04             	mov    0x4(%eax),%al
  800632:	3c 01                	cmp    $0x1,%al
  800634:	75 03                	jne    800639 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800636:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800639:	ff 45 e0             	incl   -0x20(%ebp)
  80063c:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800641:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064a:	39 c2                	cmp    %eax,%edx
  80064c:	77 c8                	ja     800616 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80064e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800651:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800654:	74 14                	je     80066a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800656:	83 ec 04             	sub    $0x4,%esp
  800659:	68 a8 23 80 00       	push   $0x8023a8
  80065e:	6a 44                	push   $0x44
  800660:	68 48 23 80 00       	push   $0x802348
  800665:	e8 15 fe ff ff       	call   80047f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80066a:	90                   	nop
  80066b:	c9                   	leave  
  80066c:	c3                   	ret    

0080066d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
  800670:	53                   	push   %ebx
  800671:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800674:	8b 45 0c             	mov    0xc(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	8d 48 01             	lea    0x1(%eax),%ecx
  80067c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067f:	89 0a                	mov    %ecx,(%edx)
  800681:	8b 55 08             	mov    0x8(%ebp),%edx
  800684:	88 d1                	mov    %dl,%cl
  800686:	8b 55 0c             	mov    0xc(%ebp),%edx
  800689:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	3d ff 00 00 00       	cmp    $0xff,%eax
  800697:	75 30                	jne    8006c9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800699:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  80069f:	a0 04 31 80 00       	mov    0x803104,%al
  8006a4:	0f b6 c0             	movzbl %al,%eax
  8006a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006aa:	8b 09                	mov    (%ecx),%ecx
  8006ac:	89 cb                	mov    %ecx,%ebx
  8006ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b1:	83 c1 08             	add    $0x8,%ecx
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	53                   	push   %ebx
  8006b7:	51                   	push   %ecx
  8006b8:	e8 a0 0f 00 00       	call   80165d <sys_cputs>
  8006bd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	8b 40 04             	mov    0x4(%eax),%eax
  8006cf:	8d 50 01             	lea    0x1(%eax),%edx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d8:	90                   	nop
  8006d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006dc:	c9                   	leave  
  8006dd:	c3                   	ret    

008006de <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006de:	55                   	push   %ebp
  8006df:	89 e5                	mov    %esp,%ebp
  8006e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ee:	00 00 00 
	b.cnt = 0;
  8006f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006f8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	ff 75 08             	pushl  0x8(%ebp)
  800701:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800707:	50                   	push   %eax
  800708:	68 6d 06 80 00       	push   $0x80066d
  80070d:	e8 5a 02 00 00       	call   80096c <vprintfmt>
  800712:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800715:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  80071b:	a0 04 31 80 00       	mov    0x803104,%al
  800720:	0f b6 c0             	movzbl %al,%eax
  800723:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800729:	52                   	push   %edx
  80072a:	50                   	push   %eax
  80072b:	51                   	push   %ecx
  80072c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800732:	83 c0 08             	add    $0x8,%eax
  800735:	50                   	push   %eax
  800736:	e8 22 0f 00 00       	call   80165d <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073e:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
	return b.cnt;
  800745:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800753:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 f4             	pushl  -0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	e8 6f ff ff ff       	call   8006de <vcprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800780:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	curTextClr = (textClr << 8) ; //set text color by the given value
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	c1 e0 08             	shl    $0x8,%eax
  80078d:	a3 fc 71 82 00       	mov    %eax,0x8271fc
	va_start(ap, fmt);
  800792:	8d 45 0c             	lea    0xc(%ebp),%eax
  800795:	83 c0 04             	add    $0x4,%eax
  800798:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a4:	50                   	push   %eax
  8007a5:	e8 34 ff ff ff       	call   8006de <vcprintf>
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007b0:	c7 05 fc 71 82 00 00 	movl   $0x700,0x8271fc
  8007b7:	07 00 00 

	return cnt;
  8007ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007bd:	c9                   	leave  
  8007be:	c3                   	ret    

008007bf <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007c5:	e8 d7 0e 00 00       	call   8016a1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ca:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d9:	50                   	push   %eax
  8007da:	e8 ff fe ff ff       	call   8006de <vcprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007e5:	e8 d1 0e 00 00       	call   8016bb <sys_unlock_cons>
	return cnt;
  8007ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    

008007ef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	53                   	push   %ebx
  8007f3:	83 ec 14             	sub    $0x14,%esp
  8007f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800802:	8b 45 18             	mov    0x18(%ebp),%eax
  800805:	ba 00 00 00 00       	mov    $0x0,%edx
  80080a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080d:	77 55                	ja     800864 <printnum+0x75>
  80080f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800812:	72 05                	jb     800819 <printnum+0x2a>
  800814:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800817:	77 4b                	ja     800864 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800819:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80081c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80081f:	8b 45 18             	mov    0x18(%ebp),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	52                   	push   %edx
  800828:	50                   	push   %eax
  800829:	ff 75 f4             	pushl  -0xc(%ebp)
  80082c:	ff 75 f0             	pushl  -0x10(%ebp)
  80082f:	e8 a8 13 00 00       	call   801bdc <__udivdi3>
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	ff 75 20             	pushl  0x20(%ebp)
  80083d:	53                   	push   %ebx
  80083e:	ff 75 18             	pushl  0x18(%ebp)
  800841:	52                   	push   %edx
  800842:	50                   	push   %eax
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	ff 75 08             	pushl  0x8(%ebp)
  800849:	e8 a1 ff ff ff       	call   8007ef <printnum>
  80084e:	83 c4 20             	add    $0x20,%esp
  800851:	eb 1a                	jmp    80086d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	ff 75 20             	pushl  0x20(%ebp)
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	ff d0                	call   *%eax
  800861:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800864:	ff 4d 1c             	decl   0x1c(%ebp)
  800867:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80086b:	7f e6                	jg     800853 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80086d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800870:	bb 00 00 00 00       	mov    $0x0,%ebx
  800875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087b:	53                   	push   %ebx
  80087c:	51                   	push   %ecx
  80087d:	52                   	push   %edx
  80087e:	50                   	push   %eax
  80087f:	e8 68 14 00 00       	call   801cec <__umoddi3>
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	05 14 26 80 00       	add    $0x802614,%eax
  80088c:	8a 00                	mov    (%eax),%al
  80088e:	0f be c0             	movsbl %al,%eax
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	50                   	push   %eax
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	ff d0                	call   *%eax
  80089d:	83 c4 10             	add    $0x10,%esp
}
  8008a0:	90                   	nop
  8008a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ad:	7e 1c                	jle    8008cb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	8d 50 08             	lea    0x8(%eax),%edx
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	89 10                	mov    %edx,(%eax)
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	83 e8 08             	sub    $0x8,%eax
  8008c4:	8b 50 04             	mov    0x4(%eax),%edx
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	eb 40                	jmp    80090b <getuint+0x65>
	else if (lflag)
  8008cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008cf:	74 1e                	je     8008ef <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 04             	lea    0x4(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ed:	eb 1c                	jmp    80090b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 50 04             	lea    0x4(%eax),%edx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	89 10                	mov    %edx,(%eax)
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	83 e8 04             	sub    $0x4,%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80090b:	5d                   	pop    %ebp
  80090c:	c3                   	ret    

0080090d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800910:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800914:	7e 1c                	jle    800932 <getint+0x25>
		return va_arg(*ap, long long);
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	8d 50 08             	lea    0x8(%eax),%edx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	89 10                	mov    %edx,(%eax)
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	83 e8 08             	sub    $0x8,%eax
  80092b:	8b 50 04             	mov    0x4(%eax),%edx
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	eb 38                	jmp    80096a <getint+0x5d>
	else if (lflag)
  800932:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800936:	74 1a                	je     800952 <getint+0x45>
		return va_arg(*ap, long);
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	8d 50 04             	lea    0x4(%eax),%edx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	89 10                	mov    %edx,(%eax)
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	83 e8 04             	sub    $0x4,%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	99                   	cltd   
  800950:	eb 18                	jmp    80096a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	8d 50 04             	lea    0x4(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	89 10                	mov    %edx,(%eax)
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	83 e8 04             	sub    $0x4,%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	99                   	cltd   
}
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	56                   	push   %esi
  800970:	53                   	push   %ebx
  800971:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800974:	eb 17                	jmp    80098d <vprintfmt+0x21>
			if (ch == '\0')
  800976:	85 db                	test   %ebx,%ebx
  800978:	0f 84 c1 03 00 00    	je     800d3f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098d:	8b 45 10             	mov    0x10(%ebp),%eax
  800990:	8d 50 01             	lea    0x1(%eax),%edx
  800993:	89 55 10             	mov    %edx,0x10(%ebp)
  800996:	8a 00                	mov    (%eax),%al
  800998:	0f b6 d8             	movzbl %al,%ebx
  80099b:	83 fb 25             	cmp    $0x25,%ebx
  80099e:	75 d6                	jne    800976 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c3:	8d 50 01             	lea    0x1(%eax),%edx
  8009c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c9:	8a 00                	mov    (%eax),%al
  8009cb:	0f b6 d8             	movzbl %al,%ebx
  8009ce:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009d1:	83 f8 5b             	cmp    $0x5b,%eax
  8009d4:	0f 87 3d 03 00 00    	ja     800d17 <vprintfmt+0x3ab>
  8009da:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  8009e1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009e3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009e7:	eb d7                	jmp    8009c0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ed:	eb d1                	jmp    8009c0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f9:	89 d0                	mov    %edx,%eax
  8009fb:	c1 e0 02             	shl    $0x2,%eax
  8009fe:	01 d0                	add    %edx,%eax
  800a00:	01 c0                	add    %eax,%eax
  800a02:	01 d8                	add    %ebx,%eax
  800a04:	83 e8 30             	sub    $0x30,%eax
  800a07:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0d:	8a 00                	mov    (%eax),%al
  800a0f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a12:	83 fb 2f             	cmp    $0x2f,%ebx
  800a15:	7e 3e                	jle    800a55 <vprintfmt+0xe9>
  800a17:	83 fb 39             	cmp    $0x39,%ebx
  800a1a:	7f 39                	jg     800a55 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a1f:	eb d5                	jmp    8009f6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	83 c0 04             	add    $0x4,%eax
  800a27:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	83 e8 04             	sub    $0x4,%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a35:	eb 1f                	jmp    800a56 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3b:	79 83                	jns    8009c0 <vprintfmt+0x54>
				width = 0;
  800a3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a44:	e9 77 ff ff ff       	jmp    8009c0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a49:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a50:	e9 6b ff ff ff       	jmp    8009c0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a55:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5a:	0f 89 60 ff ff ff    	jns    8009c0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a66:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a6d:	e9 4e ff ff ff       	jmp    8009c0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a72:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a75:	e9 46 ff ff ff       	jmp    8009c0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 c0 04             	add    $0x4,%eax
  800a80:	89 45 14             	mov    %eax,0x14(%ebp)
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	83 e8 04             	sub    $0x4,%eax
  800a89:	8b 00                	mov    (%eax),%eax
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 0c             	pushl  0xc(%ebp)
  800a91:	50                   	push   %eax
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	ff d0                	call   *%eax
  800a97:	83 c4 10             	add    $0x10,%esp
			break;
  800a9a:	e9 9b 02 00 00       	jmp    800d3a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa2:	83 c0 04             	add    $0x4,%eax
  800aa5:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aab:	83 e8 04             	sub    $0x4,%eax
  800aae:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab0:	85 db                	test   %ebx,%ebx
  800ab2:	79 02                	jns    800ab6 <vprintfmt+0x14a>
				err = -err;
  800ab4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab6:	83 fb 64             	cmp    $0x64,%ebx
  800ab9:	7f 0b                	jg     800ac6 <vprintfmt+0x15a>
  800abb:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800ac2:	85 f6                	test   %esi,%esi
  800ac4:	75 19                	jne    800adf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac6:	53                   	push   %ebx
  800ac7:	68 25 26 80 00       	push   $0x802625
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	ff 75 08             	pushl  0x8(%ebp)
  800ad2:	e8 70 02 00 00       	call   800d47 <printfmt>
  800ad7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ada:	e9 5b 02 00 00       	jmp    800d3a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800adf:	56                   	push   %esi
  800ae0:	68 2e 26 80 00       	push   $0x80262e
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 57 02 00 00       	call   800d47 <printfmt>
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	e9 42 02 00 00       	jmp    800d3a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af8:	8b 45 14             	mov    0x14(%ebp),%eax
  800afb:	83 c0 04             	add    $0x4,%eax
  800afe:	89 45 14             	mov    %eax,0x14(%ebp)
  800b01:	8b 45 14             	mov    0x14(%ebp),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 30                	mov    (%eax),%esi
  800b09:	85 f6                	test   %esi,%esi
  800b0b:	75 05                	jne    800b12 <vprintfmt+0x1a6>
				p = "(null)";
  800b0d:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7e 6d                	jle    800b85 <vprintfmt+0x219>
  800b18:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b1c:	74 67                	je     800b85 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b21:	83 ec 08             	sub    $0x8,%esp
  800b24:	50                   	push   %eax
  800b25:	56                   	push   %esi
  800b26:	e8 1e 03 00 00       	call   800e49 <strnlen>
  800b2b:	83 c4 10             	add    $0x10,%esp
  800b2e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b31:	eb 16                	jmp    800b49 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b33:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	ff d0                	call   *%eax
  800b43:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b46:	ff 4d e4             	decl   -0x1c(%ebp)
  800b49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4d:	7f e4                	jg     800b33 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4f:	eb 34                	jmp    800b85 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b51:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b55:	74 1c                	je     800b73 <vprintfmt+0x207>
  800b57:	83 fb 1f             	cmp    $0x1f,%ebx
  800b5a:	7e 05                	jle    800b61 <vprintfmt+0x1f5>
  800b5c:	83 fb 7e             	cmp    $0x7e,%ebx
  800b5f:	7e 12                	jle    800b73 <vprintfmt+0x207>
					putch('?', putdat);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	6a 3f                	push   $0x3f
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	ff d0                	call   *%eax
  800b6e:	83 c4 10             	add    $0x10,%esp
  800b71:	eb 0f                	jmp    800b82 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	53                   	push   %ebx
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	ff d0                	call   *%eax
  800b7f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b82:	ff 4d e4             	decl   -0x1c(%ebp)
  800b85:	89 f0                	mov    %esi,%eax
  800b87:	8d 70 01             	lea    0x1(%eax),%esi
  800b8a:	8a 00                	mov    (%eax),%al
  800b8c:	0f be d8             	movsbl %al,%ebx
  800b8f:	85 db                	test   %ebx,%ebx
  800b91:	74 24                	je     800bb7 <vprintfmt+0x24b>
  800b93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b97:	78 b8                	js     800b51 <vprintfmt+0x1e5>
  800b99:	ff 4d e0             	decl   -0x20(%ebp)
  800b9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba0:	79 af                	jns    800b51 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba2:	eb 13                	jmp    800bb7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	6a 20                	push   $0x20
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	ff d0                	call   *%eax
  800bb1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbb:	7f e7                	jg     800ba4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bbd:	e9 78 01 00 00       	jmp    800d3a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcb:	50                   	push   %eax
  800bcc:	e8 3c fd ff ff       	call   80090d <getint>
  800bd1:	83 c4 10             	add    $0x10,%esp
  800bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be0:	85 d2                	test   %edx,%edx
  800be2:	79 23                	jns    800c07 <vprintfmt+0x29b>
				putch('-', putdat);
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	6a 2d                	push   $0x2d
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfa:	f7 d8                	neg    %eax
  800bfc:	83 d2 00             	adc    $0x0,%edx
  800bff:	f7 da                	neg    %edx
  800c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c07:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0e:	e9 bc 00 00 00       	jmp    800ccf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 e8             	pushl  -0x18(%ebp)
  800c19:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1c:	50                   	push   %eax
  800c1d:	e8 84 fc ff ff       	call   8008a6 <getuint>
  800c22:	83 c4 10             	add    $0x10,%esp
  800c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c2b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c32:	e9 98 00 00 00       	jmp    800ccf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 58                	push   $0x58
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 0c             	pushl  0xc(%ebp)
  800c4d:	6a 58                	push   $0x58
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	ff d0                	call   *%eax
  800c54:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	6a 58                	push   $0x58
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	ff d0                	call   *%eax
  800c64:	83 c4 10             	add    $0x10,%esp
			break;
  800c67:	e9 ce 00 00 00       	jmp    800d3a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 0c             	pushl  0xc(%ebp)
  800c72:	6a 30                	push   $0x30
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	ff d0                	call   *%eax
  800c79:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	6a 78                	push   $0x78
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	ff d0                	call   *%eax
  800c89:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8f:	83 c0 04             	add    $0x4,%eax
  800c92:	89 45 14             	mov    %eax,0x14(%ebp)
  800c95:	8b 45 14             	mov    0x14(%ebp),%eax
  800c98:	83 e8 04             	sub    $0x4,%eax
  800c9b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ca7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cae:	eb 1f                	jmp    800ccf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb6:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb9:	50                   	push   %eax
  800cba:	e8 e7 fb ff ff       	call   8008a6 <getuint>
  800cbf:	83 c4 10             	add    $0x10,%esp
  800cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ccf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd6:	83 ec 04             	sub    $0x4,%esp
  800cd9:	52                   	push   %edx
  800cda:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cdd:	50                   	push   %eax
  800cde:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce4:	ff 75 0c             	pushl  0xc(%ebp)
  800ce7:	ff 75 08             	pushl  0x8(%ebp)
  800cea:	e8 00 fb ff ff       	call   8007ef <printnum>
  800cef:	83 c4 20             	add    $0x20,%esp
			break;
  800cf2:	eb 46                	jmp    800d3a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	53                   	push   %ebx
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	ff d0                	call   *%eax
  800d00:	83 c4 10             	add    $0x10,%esp
			break;
  800d03:	eb 35                	jmp    800d3a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d05:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
			break;
  800d0c:	eb 2c                	jmp    800d3a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d0e:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
			break;
  800d15:	eb 23                	jmp    800d3a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	6a 25                	push   $0x25
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	ff d0                	call   *%eax
  800d24:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d27:	ff 4d 10             	decl   0x10(%ebp)
  800d2a:	eb 03                	jmp    800d2f <vprintfmt+0x3c3>
  800d2c:	ff 4d 10             	decl   0x10(%ebp)
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	48                   	dec    %eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	3c 25                	cmp    $0x25,%al
  800d37:	75 f3                	jne    800d2c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d39:	90                   	nop
		}
	}
  800d3a:	e9 35 fc ff ff       	jmp    800974 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d3f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d50:	83 c0 04             	add    $0x4,%eax
  800d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5c:	50                   	push   %eax
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	ff 75 08             	pushl  0x8(%ebp)
  800d63:	e8 04 fc ff ff       	call   80096c <vprintfmt>
  800d68:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6b:	90                   	nop
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	8b 40 08             	mov    0x8(%eax),%eax
  800d77:	8d 50 01             	lea    0x1(%eax),%edx
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8b 10                	mov    (%eax),%edx
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8b 40 04             	mov    0x4(%eax),%eax
  800d8b:	39 c2                	cmp    %eax,%edx
  800d8d:	73 12                	jae    800da1 <sprintputch+0x33>
		*b->buf++ = ch;
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8b 00                	mov    (%eax),%eax
  800d94:	8d 48 01             	lea    0x1(%eax),%ecx
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	89 0a                	mov    %ecx,(%edx)
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	88 10                	mov    %dl,(%eax)
}
  800da1:	90                   	nop
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	01 d0                	add    %edx,%eax
  800dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc9:	74 06                	je     800dd1 <vsnprintf+0x2d>
  800dcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcf:	7f 07                	jg     800dd8 <vsnprintf+0x34>
		return -E_INVAL;
  800dd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd6:	eb 20                	jmp    800df8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd8:	ff 75 14             	pushl  0x14(%ebp)
  800ddb:	ff 75 10             	pushl  0x10(%ebp)
  800dde:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de1:	50                   	push   %eax
  800de2:	68 6e 0d 80 00       	push   $0x800d6e
  800de7:	e8 80 fb ff ff       	call   80096c <vprintfmt>
  800dec:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e00:	8d 45 10             	lea    0x10(%ebp),%eax
  800e03:	83 c0 04             	add    $0x4,%eax
  800e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0f:	50                   	push   %eax
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	ff 75 08             	pushl  0x8(%ebp)
  800e16:	e8 89 ff ff ff       	call   800da4 <vsnprintf>
  800e1b:	83 c4 10             	add    $0x10,%esp
  800e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e33:	eb 06                	jmp    800e3b <strlen+0x15>
		n++;
  800e35:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e38:	ff 45 08             	incl   0x8(%ebp)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 f1                	jne    800e35 <strlen+0xf>
		n++;
	return n;
  800e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e56:	eb 09                	jmp    800e61 <strnlen+0x18>
		n++;
  800e58:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5b:	ff 45 08             	incl   0x8(%ebp)
  800e5e:	ff 4d 0c             	decl   0xc(%ebp)
  800e61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e65:	74 09                	je     800e70 <strnlen+0x27>
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	84 c0                	test   %al,%al
  800e6e:	75 e8                	jne    800e58 <strnlen+0xf>
		n++;
	return n;
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e73:	c9                   	leave  
  800e74:	c3                   	ret    

00800e75 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e81:	90                   	nop
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8d 50 01             	lea    0x1(%eax),%edx
  800e88:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e94:	8a 12                	mov    (%edx),%dl
  800e96:	88 10                	mov    %dl,(%eax)
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 e4                	jne    800e82 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb6:	eb 1f                	jmp    800ed7 <strncpy+0x34>
		*dst++ = *src;
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8d 50 01             	lea    0x1(%eax),%edx
  800ebe:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	84 c0                	test   %al,%al
  800ecf:	74 03                	je     800ed4 <strncpy+0x31>
			src++;
  800ed1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edd:	72 d9                	jb     800eb8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef4:	74 30                	je     800f26 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef6:	eb 16                	jmp    800f0e <strlcpy+0x2a>
			*dst++ = *src++;
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 08             	mov    %edx,0x8(%ebp)
  800f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f0e:	ff 4d 10             	decl   0x10(%ebp)
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 09                	je     800f20 <strlcpy+0x3c>
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	75 d8                	jne    800ef8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2c:	29 c2                	sub    %eax,%edx
  800f2e:	89 d0                	mov    %edx,%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f35:	eb 06                	jmp    800f3d <strcmp+0xb>
		p++, q++;
  800f37:	ff 45 08             	incl   0x8(%ebp)
  800f3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	84 c0                	test   %al,%al
  800f44:	74 0e                	je     800f54 <strcmp+0x22>
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 e3                	je     800f37 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
}
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6d:	eb 09                	jmp    800f78 <strncmp+0xe>
		n--, p++, q++;
  800f6f:	ff 4d 10             	decl   0x10(%ebp)
  800f72:	ff 45 08             	incl   0x8(%ebp)
  800f75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7c:	74 17                	je     800f95 <strncmp+0x2b>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	84 c0                	test   %al,%al
  800f85:	74 0e                	je     800f95 <strncmp+0x2b>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 10                	mov    (%eax),%dl
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	38 c2                	cmp    %al,%dl
  800f93:	74 da                	je     800f6f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f99:	75 07                	jne    800fa2 <strncmp+0x38>
		return 0;
  800f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa0:	eb 14                	jmp    800fb6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	0f b6 d0             	movzbl %al,%edx
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f b6 c0             	movzbl %al,%eax
  800fb2:	29 c2                	sub    %eax,%edx
  800fb4:	89 d0                	mov    %edx,%eax
}
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 04             	sub    $0x4,%esp
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc4:	eb 12                	jmp    800fd8 <strchr+0x20>
		if (*s == c)
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fce:	75 05                	jne    800fd5 <strchr+0x1d>
			return (char *) s;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	eb 11                	jmp    800fe6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd5:	ff 45 08             	incl   0x8(%ebp)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	75 e5                	jne    800fc6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 04             	sub    $0x4,%esp
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff4:	eb 0d                	jmp    801003 <strfind+0x1b>
		if (*s == c)
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ffe:	74 0e                	je     80100e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801000:	ff 45 08             	incl   0x8(%ebp)
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	84 c0                	test   %al,%al
  80100a:	75 ea                	jne    800ff6 <strfind+0xe>
  80100c:	eb 01                	jmp    80100f <strfind+0x27>
		if (*s == c)
			break;
  80100e:	90                   	nop
	return (char *) s;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801020:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801024:	76 63                	jbe    801089 <memset+0x75>
		uint64 data_block = c;
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	99                   	cltd   
  80102a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801036:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80103a:	c1 e0 08             	shl    $0x8,%eax
  80103d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801040:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801049:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80104d:	c1 e0 10             	shl    $0x10,%eax
  801050:	09 45 f0             	or     %eax,-0x10(%ebp)
  801053:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801059:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105c:	89 c2                	mov    %eax,%edx
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
  801063:	09 45 f0             	or     %eax,-0x10(%ebp)
  801066:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801069:	eb 18                	jmp    801083 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80106b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80106e:	8d 41 08             	lea    0x8(%ecx),%eax
  801071:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107a:	89 01                	mov    %eax,(%ecx)
  80107c:	89 51 04             	mov    %edx,0x4(%ecx)
  80107f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801083:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801087:	77 e2                	ja     80106b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801089:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80108d:	74 23                	je     8010b2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801092:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801095:	eb 0e                	jmp    8010a5 <memset+0x91>
			*p8++ = (uint8)c;
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	75 e5                	jne    801097 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b5:	c9                   	leave  
  8010b6:	c3                   	ret    

008010b7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010c9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010cd:	76 24                	jbe    8010f3 <memcpy+0x3c>
		while(n >= 8){
  8010cf:	eb 1c                	jmp    8010ed <memcpy+0x36>
			*d64 = *s64;
  8010d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d4:	8b 50 04             	mov    0x4(%eax),%edx
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010dc:	89 01                	mov    %eax,(%ecx)
  8010de:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010e1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010e5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010e9:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010ed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f1:	77 de                	ja     8010d1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f7:	74 31                	je     80112a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801102:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801105:	eb 16                	jmp    80111d <memcpy+0x66>
			*d8++ = *s8++;
  801107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110a:	8d 50 01             	lea    0x1(%eax),%edx
  80110d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801113:	8d 4a 01             	lea    0x1(%edx),%ecx
  801116:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801119:	8a 12                	mov    (%edx),%dl
  80111b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80111d:	8b 45 10             	mov    0x10(%ebp),%eax
  801120:	8d 50 ff             	lea    -0x1(%eax),%edx
  801123:	89 55 10             	mov    %edx,0x10(%ebp)
  801126:	85 c0                	test   %eax,%eax
  801128:	75 dd                	jne    801107 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801135:	8b 45 0c             	mov    0xc(%ebp),%eax
  801138:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801144:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801147:	73 50                	jae    801199 <memmove+0x6a>
  801149:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114c:	8b 45 10             	mov    0x10(%ebp),%eax
  80114f:	01 d0                	add    %edx,%eax
  801151:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801154:	76 43                	jbe    801199 <memmove+0x6a>
		s += n;
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801162:	eb 10                	jmp    801174 <memmove+0x45>
			*--d = *--s;
  801164:	ff 4d f8             	decl   -0x8(%ebp)
  801167:	ff 4d fc             	decl   -0x4(%ebp)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 10                	mov    (%eax),%dl
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117a:	89 55 10             	mov    %edx,0x10(%ebp)
  80117d:	85 c0                	test   %eax,%eax
  80117f:	75 e3                	jne    801164 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801181:	eb 23                	jmp    8011a6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	8d 50 01             	lea    0x1(%eax),%edx
  801189:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801192:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801195:	8a 12                	mov    (%edx),%dl
  801197:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119f:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	75 dd                	jne    801183 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011bd:	eb 2a                	jmp    8011e9 <memcmp+0x3e>
		if (*s1 != *s2)
  8011bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c2:	8a 10                	mov    (%eax),%dl
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	38 c2                	cmp    %al,%dl
  8011cb:	74 16                	je     8011e3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	0f b6 d0             	movzbl %al,%edx
  8011d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	0f b6 c0             	movzbl %al,%eax
  8011dd:	29 c2                	sub    %eax,%edx
  8011df:	89 d0                	mov    %edx,%eax
  8011e1:	eb 18                	jmp    8011fb <memcmp+0x50>
		s1++, s2++;
  8011e3:	ff 45 fc             	incl   -0x4(%ebp)
  8011e6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	75 c9                	jne    8011bf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801203:	8b 55 08             	mov    0x8(%ebp),%edx
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	01 d0                	add    %edx,%eax
  80120b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80120e:	eb 15                	jmp    801225 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f b6 d0             	movzbl %al,%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	0f b6 c0             	movzbl %al,%eax
  80121e:	39 c2                	cmp    %eax,%edx
  801220:	74 0d                	je     80122f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80122b:	72 e3                	jb     801210 <memfind+0x13>
  80122d:	eb 01                	jmp    801230 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80122f:	90                   	nop
	return (void *) s;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80123b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801242:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801249:	eb 03                	jmp    80124e <strtol+0x19>
		s++;
  80124b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 20                	cmp    $0x20,%al
  801255:	74 f4                	je     80124b <strtol+0x16>
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 09                	cmp    $0x9,%al
  80125e:	74 eb                	je     80124b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	3c 2b                	cmp    $0x2b,%al
  801267:	75 05                	jne    80126e <strtol+0x39>
		s++;
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	eb 13                	jmp    801281 <strtol+0x4c>
	else if (*s == '-')
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	3c 2d                	cmp    $0x2d,%al
  801275:	75 0a                	jne    801281 <strtol+0x4c>
		s++, neg = 1;
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801281:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801285:	74 06                	je     80128d <strtol+0x58>
  801287:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80128b:	75 20                	jne    8012ad <strtol+0x78>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	3c 30                	cmp    $0x30,%al
  801294:	75 17                	jne    8012ad <strtol+0x78>
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	40                   	inc    %eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3c 78                	cmp    $0x78,%al
  80129e:	75 0d                	jne    8012ad <strtol+0x78>
		s += 2, base = 16;
  8012a0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012a4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ab:	eb 28                	jmp    8012d5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b1:	75 15                	jne    8012c8 <strtol+0x93>
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	3c 30                	cmp    $0x30,%al
  8012ba:	75 0c                	jne    8012c8 <strtol+0x93>
		s++, base = 8;
  8012bc:	ff 45 08             	incl   0x8(%ebp)
  8012bf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012c6:	eb 0d                	jmp    8012d5 <strtol+0xa0>
	else if (base == 0)
  8012c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cc:	75 07                	jne    8012d5 <strtol+0xa0>
		base = 10;
  8012ce:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	3c 2f                	cmp    $0x2f,%al
  8012dc:	7e 19                	jle    8012f7 <strtol+0xc2>
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	3c 39                	cmp    $0x39,%al
  8012e5:	7f 10                	jg     8012f7 <strtol+0xc2>
			dig = *s - '0';
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	0f be c0             	movsbl %al,%eax
  8012ef:	83 e8 30             	sub    $0x30,%eax
  8012f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f5:	eb 42                	jmp    801339 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	3c 60                	cmp    $0x60,%al
  8012fe:	7e 19                	jle    801319 <strtol+0xe4>
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	3c 7a                	cmp    $0x7a,%al
  801307:	7f 10                	jg     801319 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	0f be c0             	movsbl %al,%eax
  801311:	83 e8 57             	sub    $0x57,%eax
  801314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801317:	eb 20                	jmp    801339 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	3c 40                	cmp    $0x40,%al
  801320:	7e 39                	jle    80135b <strtol+0x126>
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	3c 5a                	cmp    $0x5a,%al
  801329:	7f 30                	jg     80135b <strtol+0x126>
			dig = *s - 'A' + 10;
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	0f be c0             	movsbl %al,%eax
  801333:	83 e8 37             	sub    $0x37,%eax
  801336:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80133f:	7d 19                	jge    80135a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801341:	ff 45 08             	incl   0x8(%ebp)
  801344:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801347:	0f af 45 10          	imul   0x10(%ebp),%eax
  80134b:	89 c2                	mov    %eax,%edx
  80134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801350:	01 d0                	add    %edx,%eax
  801352:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801355:	e9 7b ff ff ff       	jmp    8012d5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80135a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80135b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80135f:	74 08                	je     801369 <strtol+0x134>
		*endptr = (char *) s;
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	8b 55 08             	mov    0x8(%ebp),%edx
  801367:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801369:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80136d:	74 07                	je     801376 <strtol+0x141>
  80136f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801372:	f7 d8                	neg    %eax
  801374:	eb 03                	jmp    801379 <strtol+0x144>
  801376:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <ltostr>:

void
ltostr(long value, char *str)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801381:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801388:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80138f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801393:	79 13                	jns    8013a8 <ltostr+0x2d>
	{
		neg = 1;
  801395:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013a2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013a5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b0:	99                   	cltd   
  8013b1:	f7 f9                	idiv   %ecx
  8013b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b9:	8d 50 01             	lea    0x1(%eax),%edx
  8013bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013bf:	89 c2                	mov    %eax,%edx
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	01 d0                	add    %edx,%eax
  8013c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c9:	83 c2 30             	add    $0x30,%edx
  8013cc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013d6:	f7 e9                	imul   %ecx
  8013d8:	c1 fa 02             	sar    $0x2,%edx
  8013db:	89 c8                	mov    %ecx,%eax
  8013dd:	c1 f8 1f             	sar    $0x1f,%eax
  8013e0:	29 c2                	sub    %eax,%edx
  8013e2:	89 d0                	mov    %edx,%eax
  8013e4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013eb:	75 bb                	jne    8013a8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f7:	48                   	dec    %eax
  8013f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ff:	74 3d                	je     80143e <ltostr+0xc3>
		start = 1 ;
  801401:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801408:	eb 34                	jmp    80143e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80140a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	01 c2                	add    %eax,%edx
  80141f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	01 c8                	add    %ecx,%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80142b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	01 c2                	add    %eax,%edx
  801433:	8a 45 eb             	mov    -0x15(%ebp),%al
  801436:	88 02                	mov    %al,(%edx)
		start++ ;
  801438:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80143b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80143e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801441:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801444:	7c c4                	jl     80140a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801446:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 d0                	add    %edx,%eax
  80144e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80145a:	ff 75 08             	pushl  0x8(%ebp)
  80145d:	e8 c4 f9 ff ff       	call   800e26 <strlen>
  801462:	83 c4 04             	add    $0x4,%esp
  801465:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 b6 f9 ff ff       	call   800e26 <strlen>
  801470:	83 c4 04             	add    $0x4,%esp
  801473:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801476:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80147d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801484:	eb 17                	jmp    80149d <strcconcat+0x49>
		final[s] = str1[s] ;
  801486:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801489:	8b 45 10             	mov    0x10(%ebp),%eax
  80148c:	01 c2                	add    %eax,%edx
  80148e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	01 c8                	add    %ecx,%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80149a:	ff 45 fc             	incl   -0x4(%ebp)
  80149d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014a3:	7c e1                	jl     801486 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014b3:	eb 1f                	jmp    8014d4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b8:	8d 50 01             	lea    0x1(%eax),%edx
  8014bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014be:	89 c2                	mov    %eax,%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 c8                	add    %ecx,%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014d1:	ff 45 f8             	incl   -0x8(%ebp)
  8014d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014da:	7c d9                	jl     8014b5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014df:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e2:	01 d0                	add    %edx,%eax
  8014e4:	c6 00 00             	movb   $0x0,(%eax)
}
  8014e7:	90                   	nop
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80150d:	eb 0c                	jmp    80151b <strsplit+0x31>
			*string++ = 0;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 08             	mov    %edx,0x8(%ebp)
  801518:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	74 18                	je     80153c <strsplit+0x52>
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	0f be c0             	movsbl %al,%eax
  80152c:	50                   	push   %eax
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	e8 83 fa ff ff       	call   800fb8 <strchr>
  801535:	83 c4 08             	add    $0x8,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	75 d3                	jne    80150f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	84 c0                	test   %al,%al
  801543:	74 5a                	je     80159f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801545:	8b 45 14             	mov    0x14(%ebp),%eax
  801548:	8b 00                	mov    (%eax),%eax
  80154a:	83 f8 0f             	cmp    $0xf,%eax
  80154d:	75 07                	jne    801556 <strsplit+0x6c>
		{
			return 0;
  80154f:	b8 00 00 00 00       	mov    $0x0,%eax
  801554:	eb 66                	jmp    8015bc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801556:	8b 45 14             	mov    0x14(%ebp),%eax
  801559:	8b 00                	mov    (%eax),%eax
  80155b:	8d 48 01             	lea    0x1(%eax),%ecx
  80155e:	8b 55 14             	mov    0x14(%ebp),%edx
  801561:	89 0a                	mov    %ecx,(%edx)
  801563:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	01 c2                	add    %eax,%edx
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801574:	eb 03                	jmp    801579 <strsplit+0x8f>
			string++;
  801576:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	84 c0                	test   %al,%al
  801580:	74 8b                	je     80150d <strsplit+0x23>
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	0f be c0             	movsbl %al,%eax
  80158a:	50                   	push   %eax
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	e8 25 fa ff ff       	call   800fb8 <strchr>
  801593:	83 c4 08             	add    $0x8,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	74 dc                	je     801576 <strsplit+0x8c>
			string++;
	}
  80159a:	e9 6e ff ff ff       	jmp    80150d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80159f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a3:	8b 00                	mov    (%eax),%eax
  8015a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8015af:	01 d0                	add    %edx,%eax
  8015b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d1:	eb 4a                	jmp    80161d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	01 c2                	add    %eax,%edx
  8015db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 c8                	add    %ecx,%eax
  8015e3:	8a 00                	mov    (%eax),%al
  8015e5:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	01 d0                	add    %edx,%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	3c 40                	cmp    $0x40,%al
  8015f3:	7e 25                	jle    80161a <str2lower+0x5c>
  8015f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fb:	01 d0                	add    %edx,%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 5a                	cmp    $0x5a,%al
  801601:	7f 17                	jg     80161a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	01 d0                	add    %edx,%eax
  80160b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80160e:	8b 55 08             	mov    0x8(%ebp),%edx
  801611:	01 ca                	add    %ecx,%edx
  801613:	8a 12                	mov    (%edx),%dl
  801615:	83 c2 20             	add    $0x20,%edx
  801618:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80161a:	ff 45 fc             	incl   -0x4(%ebp)
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	e8 01 f8 ff ff       	call   800e26 <strlen>
  801625:	83 c4 04             	add    $0x4,%esp
  801628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80162b:	7f a6                	jg     8015d3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80162d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	57                   	push   %edi
  801636:	56                   	push   %esi
  801637:	53                   	push   %ebx
  801638:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801641:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801644:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801647:	8b 7d 18             	mov    0x18(%ebp),%edi
  80164a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80164d:	cd 30                	int    $0x30
  80164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801652:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	5b                   	pop    %ebx
  801659:	5e                   	pop    %esi
  80165a:	5f                   	pop    %edi
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    

0080165d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801669:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80166c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	6a 00                	push   $0x0
  801675:	51                   	push   %ecx
  801676:	52                   	push   %edx
  801677:	ff 75 0c             	pushl  0xc(%ebp)
  80167a:	50                   	push   %eax
  80167b:	6a 00                	push   $0x0
  80167d:	e8 b0 ff ff ff       	call   801632 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_cgetc>:

int
sys_cgetc(void)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 02                	push   $0x2
  801697:	e8 96 ff ff ff       	call   801632 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 03                	push   $0x3
  8016b0:	e8 7d ff ff ff       	call   801632 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	90                   	nop
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 04                	push   $0x4
  8016ca:	e8 63 ff ff ff       	call   801632 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	90                   	nop
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	6a 08                	push   $0x8
  8016e8:	e8 45 ff ff ff       	call   801632 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	56                   	push   %esi
  8016f6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016f7:	8b 75 18             	mov    0x18(%ebp),%esi
  8016fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	51                   	push   %ecx
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	6a 09                	push   $0x9
  80170d:	e8 20 ff ff ff       	call   801632 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	ff 75 08             	pushl  0x8(%ebp)
  80172a:	6a 0a                	push   $0xa
  80172c:	e8 01 ff ff ff       	call   801632 <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	ff 75 0c             	pushl  0xc(%ebp)
  801742:	ff 75 08             	pushl  0x8(%ebp)
  801745:	6a 0b                	push   $0xb
  801747:	e8 e6 fe ff ff       	call   801632 <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 0c                	push   $0xc
  801760:	e8 cd fe ff ff       	call   801632 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 0d                	push   $0xd
  801779:	e8 b4 fe ff ff       	call   801632 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 0e                	push   $0xe
  801792:	e8 9b fe ff ff       	call   801632 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 0f                	push   $0xf
  8017ab:	e8 82 fe ff ff       	call   801632 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	6a 10                	push   $0x10
  8017c5:	e8 68 fe ff ff       	call   801632 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 11                	push   $0x11
  8017de:	e8 4f fe ff ff       	call   801632 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	90                   	nop
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	50                   	push   %eax
  801802:	6a 01                	push   $0x1
  801804:	e8 29 fe ff ff       	call   801632 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	90                   	nop
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 14                	push   $0x14
  80181e:	e8 0f fe ff ff       	call   801632 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	90                   	nop
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	8b 45 10             	mov    0x10(%ebp),%eax
  801832:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801835:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801838:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	6a 00                	push   $0x0
  801841:	51                   	push   %ecx
  801842:	52                   	push   %edx
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	50                   	push   %eax
  801847:	6a 15                	push   $0x15
  801849:	e8 e4 fd ff ff       	call   801632 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	52                   	push   %edx
  801863:	50                   	push   %eax
  801864:	6a 16                	push   $0x16
  801866:	e8 c7 fd ff ff       	call   801632 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801873:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	51                   	push   %ecx
  801881:	52                   	push   %edx
  801882:	50                   	push   %eax
  801883:	6a 17                	push   $0x17
  801885:	e8 a8 fd ff ff       	call   801632 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	6a 18                	push   $0x18
  8018a2:	e8 8b fd ff ff       	call   801632 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	ff 75 14             	pushl  0x14(%ebp)
  8018b7:	ff 75 10             	pushl  0x10(%ebp)
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	50                   	push   %eax
  8018be:	6a 19                	push   $0x19
  8018c0:	e8 6d fd ff ff       	call   801632 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	50                   	push   %eax
  8018d9:	6a 1a                	push   $0x1a
  8018db:	e8 52 fd ff ff       	call   801632 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	50                   	push   %eax
  8018f5:	6a 1b                	push   $0x1b
  8018f7:	e8 36 fd ff ff       	call   801632 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 05                	push   $0x5
  801910:	e8 1d fd ff ff       	call   801632 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 06                	push   $0x6
  801929:	e8 04 fd ff ff       	call   801632 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 07                	push   $0x7
  801942:	e8 eb fc ff ff       	call   801632 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_exit_env>:


void sys_exit_env(void)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 1c                	push   $0x1c
  80195b:	e8 d2 fc ff ff       	call   801632 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	90                   	nop
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80196c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196f:	8d 50 04             	lea    0x4(%eax),%edx
  801972:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 1d                	push   $0x1d
  80197f:	e8 ae fc ff ff       	call   801632 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
	return result;
  801987:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80198a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80198d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801990:	89 01                	mov    %eax,(%ecx)
  801992:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	c9                   	leave  
  801999:	c2 04 00             	ret    $0x4

0080199c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 10             	pushl  0x10(%ebp)
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 13                	push   $0x13
  8019ae:	e8 7f fc ff ff       	call   801632 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b6:	90                   	nop
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 1e                	push   $0x1e
  8019c8:	e8 65 fc ff ff       	call   801632 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019de:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	50                   	push   %eax
  8019eb:	6a 1f                	push   $0x1f
  8019ed:	e8 40 fc ff ff       	call   801632 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f5:	90                   	nop
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <rsttst>:
void rsttst()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 21                	push   $0x21
  801a07:	e8 26 fc ff ff       	call   801632 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0f:	90                   	nop
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 04             	sub    $0x4,%esp
  801a18:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a1e:	8b 55 18             	mov    0x18(%ebp),%edx
  801a21:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a25:	52                   	push   %edx
  801a26:	50                   	push   %eax
  801a27:	ff 75 10             	pushl  0x10(%ebp)
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	ff 75 08             	pushl  0x8(%ebp)
  801a30:	6a 20                	push   $0x20
  801a32:	e8 fb fb ff ff       	call   801632 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3a:	90                   	nop
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <chktst>:
void chktst(uint32 n)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	ff 75 08             	pushl  0x8(%ebp)
  801a4b:	6a 22                	push   $0x22
  801a4d:	e8 e0 fb ff ff       	call   801632 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
	return ;
  801a55:	90                   	nop
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <inctst>:

void inctst()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 23                	push   $0x23
  801a67:	e8 c6 fb ff ff       	call   801632 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6f:	90                   	nop
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <gettst>:
uint32 gettst()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 24                	push   $0x24
  801a81:	e8 ac fb ff ff       	call   801632 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 25                	push   $0x25
  801a9a:	e8 93 fb ff ff       	call   801632 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
  801aa2:	a3 40 71 82 00       	mov    %eax,0x827140
	return uheapPlaceStrategy ;
  801aa7:	a1 40 71 82 00       	mov    0x827140,%eax
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	a3 40 71 82 00       	mov    %eax,0x827140
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	6a 26                	push   $0x26
  801ac6:	e8 67 fb ff ff       	call   801632 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ace:	90                   	nop
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ad5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	53                   	push   %ebx
  801ae4:	51                   	push   %ecx
  801ae5:	52                   	push   %edx
  801ae6:	50                   	push   %eax
  801ae7:	6a 27                	push   $0x27
  801ae9:	e8 44 fb ff ff       	call   801632 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	52                   	push   %edx
  801b06:	50                   	push   %eax
  801b07:	6a 28                	push   $0x28
  801b09:	e8 24 fb ff ff       	call   801632 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b16:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	51                   	push   %ecx
  801b22:	ff 75 10             	pushl  0x10(%ebp)
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	6a 29                	push   $0x29
  801b29:	e8 04 fb ff ff       	call   801632 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 10             	pushl  0x10(%ebp)
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	ff 75 08             	pushl  0x8(%ebp)
  801b43:	6a 12                	push   $0x12
  801b45:	e8 e8 fa ff ff       	call   801632 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4d:	90                   	nop
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	6a 2a                	push   $0x2a
  801b63:	e8 ca fa ff ff       	call   801632 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
	return;
  801b6b:	90                   	nop
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 2b                	push   $0x2b
  801b7d:	e8 b0 fa ff ff       	call   801632 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	6a 2d                	push   $0x2d
  801b98:	e8 95 fa ff ff       	call   801632 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
	return;
  801ba0:	90                   	nop
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	ff 75 0c             	pushl  0xc(%ebp)
  801baf:	ff 75 08             	pushl  0x8(%ebp)
  801bb2:	6a 2c                	push   $0x2c
  801bb4:	e8 79 fa ff ff       	call   801632 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbc:	90                   	nop
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	68 a8 27 80 00       	push   $0x8027a8
  801bcd:	68 25 01 00 00       	push   $0x125
  801bd2:	68 db 27 80 00       	push   $0x8027db
  801bd7:	e8 a3 e8 ff ff       	call   80047f <_panic>

00801bdc <__udivdi3>:
  801bdc:	55                   	push   %ebp
  801bdd:	57                   	push   %edi
  801bde:	56                   	push   %esi
  801bdf:	53                   	push   %ebx
  801be0:	83 ec 1c             	sub    $0x1c,%esp
  801be3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801be7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801beb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bf3:	89 ca                	mov    %ecx,%edx
  801bf5:	89 f8                	mov    %edi,%eax
  801bf7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bfb:	85 f6                	test   %esi,%esi
  801bfd:	75 2d                	jne    801c2c <__udivdi3+0x50>
  801bff:	39 cf                	cmp    %ecx,%edi
  801c01:	77 65                	ja     801c68 <__udivdi3+0x8c>
  801c03:	89 fd                	mov    %edi,%ebp
  801c05:	85 ff                	test   %edi,%edi
  801c07:	75 0b                	jne    801c14 <__udivdi3+0x38>
  801c09:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0e:	31 d2                	xor    %edx,%edx
  801c10:	f7 f7                	div    %edi
  801c12:	89 c5                	mov    %eax,%ebp
  801c14:	31 d2                	xor    %edx,%edx
  801c16:	89 c8                	mov    %ecx,%eax
  801c18:	f7 f5                	div    %ebp
  801c1a:	89 c1                	mov    %eax,%ecx
  801c1c:	89 d8                	mov    %ebx,%eax
  801c1e:	f7 f5                	div    %ebp
  801c20:	89 cf                	mov    %ecx,%edi
  801c22:	89 fa                	mov    %edi,%edx
  801c24:	83 c4 1c             	add    $0x1c,%esp
  801c27:	5b                   	pop    %ebx
  801c28:	5e                   	pop    %esi
  801c29:	5f                   	pop    %edi
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    
  801c2c:	39 ce                	cmp    %ecx,%esi
  801c2e:	77 28                	ja     801c58 <__udivdi3+0x7c>
  801c30:	0f bd fe             	bsr    %esi,%edi
  801c33:	83 f7 1f             	xor    $0x1f,%edi
  801c36:	75 40                	jne    801c78 <__udivdi3+0x9c>
  801c38:	39 ce                	cmp    %ecx,%esi
  801c3a:	72 0a                	jb     801c46 <__udivdi3+0x6a>
  801c3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c40:	0f 87 9e 00 00 00    	ja     801ce4 <__udivdi3+0x108>
  801c46:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4b:	89 fa                	mov    %edi,%edx
  801c4d:	83 c4 1c             	add    $0x1c,%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5e                   	pop    %esi
  801c52:	5f                   	pop    %edi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    
  801c55:	8d 76 00             	lea    0x0(%esi),%esi
  801c58:	31 ff                	xor    %edi,%edi
  801c5a:	31 c0                	xor    %eax,%eax
  801c5c:	89 fa                	mov    %edi,%edx
  801c5e:	83 c4 1c             	add    $0x1c,%esp
  801c61:	5b                   	pop    %ebx
  801c62:	5e                   	pop    %esi
  801c63:	5f                   	pop    %edi
  801c64:	5d                   	pop    %ebp
  801c65:	c3                   	ret    
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	89 d8                	mov    %ebx,%eax
  801c6a:	f7 f7                	div    %edi
  801c6c:	31 ff                	xor    %edi,%edi
  801c6e:	89 fa                	mov    %edi,%edx
  801c70:	83 c4 1c             	add    $0x1c,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5f                   	pop    %edi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
  801c78:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c7d:	89 eb                	mov    %ebp,%ebx
  801c7f:	29 fb                	sub    %edi,%ebx
  801c81:	89 f9                	mov    %edi,%ecx
  801c83:	d3 e6                	shl    %cl,%esi
  801c85:	89 c5                	mov    %eax,%ebp
  801c87:	88 d9                	mov    %bl,%cl
  801c89:	d3 ed                	shr    %cl,%ebp
  801c8b:	89 e9                	mov    %ebp,%ecx
  801c8d:	09 f1                	or     %esi,%ecx
  801c8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c93:	89 f9                	mov    %edi,%ecx
  801c95:	d3 e0                	shl    %cl,%eax
  801c97:	89 c5                	mov    %eax,%ebp
  801c99:	89 d6                	mov    %edx,%esi
  801c9b:	88 d9                	mov    %bl,%cl
  801c9d:	d3 ee                	shr    %cl,%esi
  801c9f:	89 f9                	mov    %edi,%ecx
  801ca1:	d3 e2                	shl    %cl,%edx
  801ca3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca7:	88 d9                	mov    %bl,%cl
  801ca9:	d3 e8                	shr    %cl,%eax
  801cab:	09 c2                	or     %eax,%edx
  801cad:	89 d0                	mov    %edx,%eax
  801caf:	89 f2                	mov    %esi,%edx
  801cb1:	f7 74 24 0c          	divl   0xc(%esp)
  801cb5:	89 d6                	mov    %edx,%esi
  801cb7:	89 c3                	mov    %eax,%ebx
  801cb9:	f7 e5                	mul    %ebp
  801cbb:	39 d6                	cmp    %edx,%esi
  801cbd:	72 19                	jb     801cd8 <__udivdi3+0xfc>
  801cbf:	74 0b                	je     801ccc <__udivdi3+0xf0>
  801cc1:	89 d8                	mov    %ebx,%eax
  801cc3:	31 ff                	xor    %edi,%edi
  801cc5:	e9 58 ff ff ff       	jmp    801c22 <__udivdi3+0x46>
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cd0:	89 f9                	mov    %edi,%ecx
  801cd2:	d3 e2                	shl    %cl,%edx
  801cd4:	39 c2                	cmp    %eax,%edx
  801cd6:	73 e9                	jae    801cc1 <__udivdi3+0xe5>
  801cd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cdb:	31 ff                	xor    %edi,%edi
  801cdd:	e9 40 ff ff ff       	jmp    801c22 <__udivdi3+0x46>
  801ce2:	66 90                	xchg   %ax,%ax
  801ce4:	31 c0                	xor    %eax,%eax
  801ce6:	e9 37 ff ff ff       	jmp    801c22 <__udivdi3+0x46>
  801ceb:	90                   	nop

00801cec <__umoddi3>:
  801cec:	55                   	push   %ebp
  801ced:	57                   	push   %edi
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 1c             	sub    $0x1c,%esp
  801cf3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cf7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d0b:	89 f3                	mov    %esi,%ebx
  801d0d:	89 fa                	mov    %edi,%edx
  801d0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d13:	89 34 24             	mov    %esi,(%esp)
  801d16:	85 c0                	test   %eax,%eax
  801d18:	75 1a                	jne    801d34 <__umoddi3+0x48>
  801d1a:	39 f7                	cmp    %esi,%edi
  801d1c:	0f 86 a2 00 00 00    	jbe    801dc4 <__umoddi3+0xd8>
  801d22:	89 c8                	mov    %ecx,%eax
  801d24:	89 f2                	mov    %esi,%edx
  801d26:	f7 f7                	div    %edi
  801d28:	89 d0                	mov    %edx,%eax
  801d2a:	31 d2                	xor    %edx,%edx
  801d2c:	83 c4 1c             	add    $0x1c,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5f                   	pop    %edi
  801d32:	5d                   	pop    %ebp
  801d33:	c3                   	ret    
  801d34:	39 f0                	cmp    %esi,%eax
  801d36:	0f 87 ac 00 00 00    	ja     801de8 <__umoddi3+0xfc>
  801d3c:	0f bd e8             	bsr    %eax,%ebp
  801d3f:	83 f5 1f             	xor    $0x1f,%ebp
  801d42:	0f 84 ac 00 00 00    	je     801df4 <__umoddi3+0x108>
  801d48:	bf 20 00 00 00       	mov    $0x20,%edi
  801d4d:	29 ef                	sub    %ebp,%edi
  801d4f:	89 fe                	mov    %edi,%esi
  801d51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d55:	89 e9                	mov    %ebp,%ecx
  801d57:	d3 e0                	shl    %cl,%eax
  801d59:	89 d7                	mov    %edx,%edi
  801d5b:	89 f1                	mov    %esi,%ecx
  801d5d:	d3 ef                	shr    %cl,%edi
  801d5f:	09 c7                	or     %eax,%edi
  801d61:	89 e9                	mov    %ebp,%ecx
  801d63:	d3 e2                	shl    %cl,%edx
  801d65:	89 14 24             	mov    %edx,(%esp)
  801d68:	89 d8                	mov    %ebx,%eax
  801d6a:	d3 e0                	shl    %cl,%eax
  801d6c:	89 c2                	mov    %eax,%edx
  801d6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d72:	d3 e0                	shl    %cl,%eax
  801d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d78:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d7c:	89 f1                	mov    %esi,%ecx
  801d7e:	d3 e8                	shr    %cl,%eax
  801d80:	09 d0                	or     %edx,%eax
  801d82:	d3 eb                	shr    %cl,%ebx
  801d84:	89 da                	mov    %ebx,%edx
  801d86:	f7 f7                	div    %edi
  801d88:	89 d3                	mov    %edx,%ebx
  801d8a:	f7 24 24             	mull   (%esp)
  801d8d:	89 c6                	mov    %eax,%esi
  801d8f:	89 d1                	mov    %edx,%ecx
  801d91:	39 d3                	cmp    %edx,%ebx
  801d93:	0f 82 87 00 00 00    	jb     801e20 <__umoddi3+0x134>
  801d99:	0f 84 91 00 00 00    	je     801e30 <__umoddi3+0x144>
  801d9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801da3:	29 f2                	sub    %esi,%edx
  801da5:	19 cb                	sbb    %ecx,%ebx
  801da7:	89 d8                	mov    %ebx,%eax
  801da9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801dad:	d3 e0                	shl    %cl,%eax
  801daf:	89 e9                	mov    %ebp,%ecx
  801db1:	d3 ea                	shr    %cl,%edx
  801db3:	09 d0                	or     %edx,%eax
  801db5:	89 e9                	mov    %ebp,%ecx
  801db7:	d3 eb                	shr    %cl,%ebx
  801db9:	89 da                	mov    %ebx,%edx
  801dbb:	83 c4 1c             	add    $0x1c,%esp
  801dbe:	5b                   	pop    %ebx
  801dbf:	5e                   	pop    %esi
  801dc0:	5f                   	pop    %edi
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    
  801dc3:	90                   	nop
  801dc4:	89 fd                	mov    %edi,%ebp
  801dc6:	85 ff                	test   %edi,%edi
  801dc8:	75 0b                	jne    801dd5 <__umoddi3+0xe9>
  801dca:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcf:	31 d2                	xor    %edx,%edx
  801dd1:	f7 f7                	div    %edi
  801dd3:	89 c5                	mov    %eax,%ebp
  801dd5:	89 f0                	mov    %esi,%eax
  801dd7:	31 d2                	xor    %edx,%edx
  801dd9:	f7 f5                	div    %ebp
  801ddb:	89 c8                	mov    %ecx,%eax
  801ddd:	f7 f5                	div    %ebp
  801ddf:	89 d0                	mov    %edx,%eax
  801de1:	e9 44 ff ff ff       	jmp    801d2a <__umoddi3+0x3e>
  801de6:	66 90                	xchg   %ax,%ax
  801de8:	89 c8                	mov    %ecx,%eax
  801dea:	89 f2                	mov    %esi,%edx
  801dec:	83 c4 1c             	add    $0x1c,%esp
  801def:	5b                   	pop    %ebx
  801df0:	5e                   	pop    %esi
  801df1:	5f                   	pop    %edi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    
  801df4:	3b 04 24             	cmp    (%esp),%eax
  801df7:	72 06                	jb     801dff <__umoddi3+0x113>
  801df9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dfd:	77 0f                	ja     801e0e <__umoddi3+0x122>
  801dff:	89 f2                	mov    %esi,%edx
  801e01:	29 f9                	sub    %edi,%ecx
  801e03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e07:	89 14 24             	mov    %edx,(%esp)
  801e0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e12:	8b 14 24             	mov    (%esp),%edx
  801e15:	83 c4 1c             	add    $0x1c,%esp
  801e18:	5b                   	pop    %ebx
  801e19:	5e                   	pop    %esi
  801e1a:	5f                   	pop    %edi
  801e1b:	5d                   	pop    %ebp
  801e1c:	c3                   	ret    
  801e1d:	8d 76 00             	lea    0x0(%esi),%esi
  801e20:	2b 04 24             	sub    (%esp),%eax
  801e23:	19 fa                	sbb    %edi,%edx
  801e25:	89 d1                	mov    %edx,%ecx
  801e27:	89 c6                	mov    %eax,%esi
  801e29:	e9 71 ff ff ff       	jmp    801d9f <__umoddi3+0xb3>
  801e2e:	66 90                	xchg   %ax,%ax
  801e30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e34:	72 ea                	jb     801e20 <__umoddi3+0x134>
  801e36:	89 d9                	mov    %ebx,%ecx
  801e38:	e9 62 ff ff ff       	jmp    801d9f <__umoddi3+0xb3>
