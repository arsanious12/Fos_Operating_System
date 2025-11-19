
obj/user/tst_page_replacement_optimal_2:     file format elf32-i386


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
  800031:	e8 c9 02 00 00       	call   8002ff <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 expectedRefStream[EXPECTED_REF_CNT] = {
		0xeebf1000, 0xeebfb000, 0xeebfc000, 0xeebf2000, 0xeebf3000, 0xeebf4000,
		0xeebf5000, 0xeebf6000, 0xeebf7000, 0xeebf8000, 0xeebf9000, 0xeebfa000
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c c1 00 00    	sub    $0xc10c,%esp
	char __arr__[PAGE_SIZE*12];

	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

	int freePages = sys_calculate_free_frames();
  800044:	e8 38 17 00 00       	call   801781 <sys_calculate_free_frames>
  800049:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80004c:	e8 7b 17 00 00       	call   8017cc <sys_pf_calculate_allocated_pages>
  800051:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800054:	c6 85 cb df ff ff 61 	movb   $0x61,-0x2035(%ebp)

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  80005b:	8a 85 cb ef ff ff    	mov    -0x1035(%ebp),%al
  800061:	88 45 d7             	mov    %al,-0x29(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800064:	8a 45 cb             	mov    -0x35(%ebp),%al
  800067:	88 45 d6             	mov    %al,-0x2a(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80006a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800071:	eb 29                	jmp    80009c <_main+0x64>
	{
		__arr__[i] = -1 ;
  800073:	8d 95 cc 3f ff ff    	lea    -0xc034(%ebp),%edx
  800079:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  800081:	a1 00 30 80 00       	mov    0x803000,%eax
  800086:	8a 00                	mov    (%eax),%al
  800088:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *__ptr2__ ;
  80008b:	a1 04 30 80 00       	mov    0x803004,%eax
  800090:	8a 00                	mov    (%eax),%al
  800092:	88 45 e6             	mov    %al,-0x1a(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800095:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  80009c:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  8000a3:	7e ce                	jle    800073 <_main+0x3b>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  8000a5:	83 ec 08             	sub    $0x8,%esp
  8000a8:	68 80 1e 80 00       	push   $0x801e80
  8000ad:	6a 03                	push   $0x3
  8000af:	e8 f6 06 00 00       	call   8007aa <cprintf_colored>
  8000b4:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000b7:	a1 00 30 80 00       	mov    0x803000,%eax
  8000bc:	8a 00                	mov    (%eax),%al
  8000be:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 99 1e 80 00       	push   $0x801e99
  8000cb:	6a 31                	push   $0x31
  8000cd:	68 a8 1e 80 00       	push   $0x801ea8
  8000d2:	e8 d8 03 00 00       	call   8004af <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000d7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000dc:	8a 00                	mov    (%eax),%al
  8000de:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  8000e1:	74 14                	je     8000f7 <_main+0xbf>
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	68 99 1e 80 00       	push   $0x801e99
  8000eb:	6a 32                	push   $0x32
  8000ed:	68 a8 1e 80 00       	push   $0x801ea8
  8000f2:	e8 b8 03 00 00       	call   8004af <_panic>
		if(__arr__[PAGE_SIZE*10-1] != 'a') panic("test failed!");
  8000f7:	8a 85 cb df ff ff    	mov    -0x2035(%ebp),%al
  8000fd:	3c 61                	cmp    $0x61,%al
  8000ff:	74 14                	je     800115 <_main+0xdd>
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	68 99 1e 80 00       	push   $0x801e99
  800109:	6a 33                	push   $0x33
  80010b:	68 a8 1e 80 00       	push   $0x801ea8
  800110:	e8 9a 03 00 00       	call   8004af <_panic>
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800115:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80011c:	eb 2c                	jmp    80014a <_main+0x112>
		{
			if(__arr__[i] != -1) panic("test failed!");
  80011e:	8d 95 cc 3f ff ff    	lea    -0xc034(%ebp),%edx
  800124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800127:	01 d0                	add    %edx,%eax
  800129:	8a 00                	mov    (%eax),%al
  80012b:	3c ff                	cmp    $0xff,%al
  80012d:	74 14                	je     800143 <_main+0x10b>
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	68 99 1e 80 00       	push   $0x801e99
  800137:	6a 36                	push   $0x36
  800139:	68 a8 1e 80 00       	push   $0x801ea8
  80013e:	e8 6c 03 00 00       	call   8004af <_panic>
	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
	{
		if (garbage4 != *__ptr__) panic("test failed!");
		if (garbage5 != *__ptr2__) panic("test failed!");
		if(__arr__[PAGE_SIZE*10-1] != 'a') panic("test failed!");
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800143:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  80014a:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800151:	7e cb                	jle    80011e <_main+0xe6>
		{
			if(__arr__[i] != -1) panic("test failed!");
		}
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking EXPECTED REFERENCE STREAM... \n");
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	68 d0 1e 80 00       	push   $0x801ed0
  80015b:	6a 03                	push   $0x3
  80015d:	e8 48 06 00 00       	call   8007aa <cprintf_colored>
  800162:	83 c4 10             	add    $0x10,%esp
	{
		char separator[2] = "@";
  800165:	66 c7 85 c6 3f ff ff 	movw   $0x40,-0xc03a(%ebp)
  80016c:	40 00 
		char checkRefStreamCmd[100] = "__CheckRefStream@";
  80016e:	8d 85 ea 3e ff ff    	lea    -0xc116(%ebp),%eax
  800174:	bb 51 20 80 00       	mov    $0x802051,%ebx
  800179:	ba 12 00 00 00       	mov    $0x12,%edx
  80017e:	89 c7                	mov    %eax,%edi
  800180:	89 de                	mov    %ebx,%esi
  800182:	89 d1                	mov    %edx,%ecx
  800184:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800186:	8d 95 fc 3e ff ff    	lea    -0xc104(%ebp),%edx
  80018c:	b9 52 00 00 00       	mov    $0x52,%ecx
  800191:	b0 00                	mov    $0x0,%al
  800193:	89 d7                	mov    %edx,%edi
  800195:	f3 aa                	rep stos %al,%es:(%edi)
		char token[20] ;
		char cmdWithCnt[100] ;
		ltostr(EXPECTED_REF_CNT, token);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001a0:	50                   	push   %eax
  8001a1:	6a 0c                	push   $0xc
  8001a3:	e8 03 12 00 00       	call   8013ab <ltostr>
  8001a8:	83 c4 10             	add    $0x10,%esp
		strcconcat(checkRefStreamCmd, token, cmdWithCnt);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	8d 85 ea 3e ff ff    	lea    -0xc116(%ebp),%eax
  8001c2:	50                   	push   %eax
  8001c3:	e8 bc 12 00 00       	call   801484 <strcconcat>
  8001c8:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	8d 85 c6 3f ff ff    	lea    -0xc03a(%ebp),%eax
  8001db:	50                   	push   %eax
  8001dc:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 9c 12 00 00       	call   801484 <strcconcat>
  8001e8:	83 c4 10             	add    $0x10,%esp
		ltostr((uint32)&expectedRefStream, token);
  8001eb:	ba 20 30 80 00       	mov    $0x803020,%edx
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	52                   	push   %edx
  8001fb:	e8 ab 11 00 00       	call   8013ab <ltostr>
  800200:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, token, cmdWithCnt);
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  800213:	50                   	push   %eax
  800214:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80021a:	50                   	push   %eax
  80021b:	e8 64 12 00 00       	call   801484 <strcconcat>
  800220:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80022c:	50                   	push   %eax
  80022d:	8d 85 c6 3f ff ff    	lea    -0xc03a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80023a:	50                   	push   %eax
  80023b:	e8 44 12 00 00       	call   801484 <strcconcat>
  800240:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("%~Ref Command = %s\n", cmdWithCnt);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80024c:	50                   	push   %eax
  80024d:	68 fb 1e 80 00       	push   $0x801efb
  800252:	e8 98 05 00 00       	call   8007ef <atomic_cprintf>
  800257:	83 c4 10             	add    $0x10,%esp

		sys_utilities(cmdWithCnt, (uint32)&found);
  80025a:	8d 85 c8 3f ff ff    	lea    -0xc038(%ebp),%eax
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	50                   	push   %eax
  800264:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80026a:	50                   	push   %eax
  80026b:	e8 10 19 00 00       	call   801b80 <sys_utilities>
  800270:	83 c4 10             	add    $0x10,%esp

		//if (found != 1) panic("OPTIMAL alg. failed.. unexpected page reference stream!");
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	68 10 1f 80 00       	push   $0x801f10
  80027b:	6a 03                	push   $0x3
  80027d:	e8 28 05 00 00       	call   8007aa <cprintf_colored>
  800282:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800285:	e8 42 15 00 00       	call   8017cc <sys_pf_calculate_allocated_pages>
  80028a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80028d:	74 14                	je     8002a3 <_main+0x26b>
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 40 1f 80 00       	push   $0x801f40
  800297:	6a 4e                	push   $0x4e
  800299:	68 a8 1e 80 00       	push   $0x801ea8
  80029e:	e8 0c 02 00 00       	call   8004af <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8002a3:	e8 d9 14 00 00       	call   801781 <sys_calculate_free_frames>
  8002a8:	89 c3                	mov    %eax,%ebx
  8002aa:	e8 eb 14 00 00       	call   80179a <sys_calculate_modified_frames>
  8002af:	01 d8                	add    %ebx,%eax
  8002b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int expectedNumOfFrames = 11;
  8002b4:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)
		if( (freePages - freePagesAfter) != expectedNumOfFrames)
  8002bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002be:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8002c4:	74 1e                	je     8002e4 <_main+0x2ac>
			panic("Unexpected number of allocated frames in RAM. Expected = %d, Actual = %d", expectedNumOfFrames, (freePages - freePagesAfter));
  8002c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	50                   	push   %eax
  8002d0:	ff 75 cc             	pushl  -0x34(%ebp)
  8002d3:	68 ac 1f 80 00       	push   $0x801fac
  8002d8:	6a 53                	push   $0x53
  8002da:	68 a8 1e 80 00       	push   $0x801ea8
  8002df:	e8 cb 01 00 00       	call   8004af <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #2 [OPTIMAL Alg.] is completed successfully.\n");
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	68 f8 1f 80 00       	push   $0x801ff8
  8002ec:	6a 0a                	push   $0xa
  8002ee:	e8 b7 04 00 00       	call   8007aa <cprintf_colored>
  8002f3:	83 c4 10             	add    $0x10,%esp
	return;
  8002f6:	90                   	nop
}
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	57                   	push   %edi
  800303:	56                   	push   %esi
  800304:	53                   	push   %ebx
  800305:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800308:	e8 3d 16 00 00       	call   80194a <sys_getenvindex>
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800310:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800313:	89 d0                	mov    %edx,%eax
  800315:	c1 e0 02             	shl    $0x2,%eax
  800318:	01 d0                	add    %edx,%eax
  80031a:	c1 e0 03             	shl    $0x3,%eax
  80031d:	01 d0                	add    %edx,%eax
  80031f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800326:	01 d0                	add    %edx,%eax
  800328:	c1 e0 02             	shl    $0x2,%eax
  80032b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800330:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800335:	a1 60 30 80 00       	mov    0x803060,%eax
  80033a:	8a 40 20             	mov    0x20(%eax),%al
  80033d:	84 c0                	test   %al,%al
  80033f:	74 0d                	je     80034e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800341:	a1 60 30 80 00       	mov    0x803060,%eax
  800346:	83 c0 20             	add    $0x20,%eax
  800349:	a3 54 30 80 00       	mov    %eax,0x803054

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80034e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800352:	7e 0a                	jle    80035e <libmain+0x5f>
		binaryname = argv[0];
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	a3 54 30 80 00       	mov    %eax,0x803054

	// call user main routine
	_main(argc, argv);
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 0c             	pushl  0xc(%ebp)
  800364:	ff 75 08             	pushl  0x8(%ebp)
  800367:	e8 cc fc ff ff       	call   800038 <_main>
  80036c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80036f:	a1 50 30 80 00       	mov    0x803050,%eax
  800374:	85 c0                	test   %eax,%eax
  800376:	0f 84 01 01 00 00    	je     80047d <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80037c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800382:	bb b0 21 80 00       	mov    $0x8021b0,%ebx
  800387:	ba 0e 00 00 00       	mov    $0xe,%edx
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	89 de                	mov    %ebx,%esi
  800390:	89 d1                	mov    %edx,%ecx
  800392:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800394:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800397:	b9 56 00 00 00       	mov    $0x56,%ecx
  80039c:	b0 00                	mov    $0x0,%al
  80039e:	89 d7                	mov    %edx,%edi
  8003a0:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003ac:	83 ec 08             	sub    $0x8,%esp
  8003af:	50                   	push   %eax
  8003b0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003b6:	50                   	push   %eax
  8003b7:	e8 c4 17 00 00       	call   801b80 <sys_utilities>
  8003bc:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003bf:	e8 0d 13 00 00       	call   8016d1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003c4:	83 ec 0c             	sub    $0xc,%esp
  8003c7:	68 d0 20 80 00       	push   $0x8020d0
  8003cc:	e8 ac 03 00 00       	call   80077d <cprintf>
  8003d1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d7:	85 c0                	test   %eax,%eax
  8003d9:	74 18                	je     8003f3 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003db:	e8 be 17 00 00       	call   801b9e <sys_get_optimal_num_faults>
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	50                   	push   %eax
  8003e4:	68 f8 20 80 00       	push   $0x8020f8
  8003e9:	e8 8f 03 00 00       	call   80077d <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	eb 59                	jmp    80044c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f3:	a1 60 30 80 00       	mov    0x803060,%eax
  8003f8:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003fe:	a1 60 30 80 00       	mov    0x803060,%eax
  800403:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	52                   	push   %edx
  80040d:	50                   	push   %eax
  80040e:	68 1c 21 80 00       	push   $0x80211c
  800413:	e8 65 03 00 00       	call   80077d <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80041b:	a1 60 30 80 00       	mov    0x803060,%eax
  800420:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800426:	a1 60 30 80 00       	mov    0x803060,%eax
  80042b:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800431:	a1 60 30 80 00       	mov    0x803060,%eax
  800436:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80043c:	51                   	push   %ecx
  80043d:	52                   	push   %edx
  80043e:	50                   	push   %eax
  80043f:	68 44 21 80 00       	push   $0x802144
  800444:	e8 34 03 00 00       	call   80077d <cprintf>
  800449:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044c:	a1 60 30 80 00       	mov    0x803060,%eax
  800451:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	50                   	push   %eax
  80045b:	68 9c 21 80 00       	push   $0x80219c
  800460:	e8 18 03 00 00       	call   80077d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800468:	83 ec 0c             	sub    $0xc,%esp
  80046b:	68 d0 20 80 00       	push   $0x8020d0
  800470:	e8 08 03 00 00       	call   80077d <cprintf>
  800475:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800478:	e8 6e 12 00 00       	call   8016eb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80047d:	e8 1f 00 00 00       	call   8004a1 <exit>
}
  800482:	90                   	nop
  800483:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800486:	5b                   	pop    %ebx
  800487:	5e                   	pop    %esi
  800488:	5f                   	pop    %edi
  800489:	5d                   	pop    %ebp
  80048a:	c3                   	ret    

0080048b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800491:	83 ec 0c             	sub    $0xc,%esp
  800494:	6a 00                	push   $0x0
  800496:	e8 7b 14 00 00       	call   801916 <sys_destroy_env>
  80049b:	83 c4 10             	add    $0x10,%esp
}
  80049e:	90                   	nop
  80049f:	c9                   	leave  
  8004a0:	c3                   	ret    

008004a1 <exit>:

void
exit(void)
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004a7:	e8 d0 14 00 00       	call   80197c <sys_exit_env>
}
  8004ac:	90                   	nop
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    

008004af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004af:	55                   	push   %ebp
  8004b0:	89 e5                	mov    %esp,%ebp
  8004b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b8:	83 c0 04             	add    $0x4,%eax
  8004bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004be:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	74 16                	je     8004dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004c7:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	50                   	push   %eax
  8004d0:	68 14 22 80 00       	push   $0x802214
  8004d5:	e8 a3 02 00 00       	call   80077d <cprintf>
  8004da:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004dd:	a1 54 30 80 00       	mov    0x803054,%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	50                   	push   %eax
  8004ec:	68 1c 22 80 00       	push   $0x80221c
  8004f1:	6a 74                	push   $0x74
  8004f3:	e8 b2 02 00 00       	call   8007aa <cprintf_colored>
  8004f8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	ff 75 f4             	pushl  -0xc(%ebp)
  800504:	50                   	push   %eax
  800505:	e8 04 02 00 00       	call   80070e <vcprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	6a 00                	push   $0x0
  800512:	68 44 22 80 00       	push   $0x802244
  800517:	e8 f2 01 00 00       	call   80070e <vcprintf>
  80051c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80051f:	e8 7d ff ff ff       	call   8004a1 <exit>

	// should not return here
	while (1) ;
  800524:	eb fe                	jmp    800524 <_panic+0x75>

00800526 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80052c:	a1 60 30 80 00       	mov    0x803060,%eax
  800531:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053a:	39 c2                	cmp    %eax,%edx
  80053c:	74 14                	je     800552 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80053e:	83 ec 04             	sub    $0x4,%esp
  800541:	68 48 22 80 00       	push   $0x802248
  800546:	6a 26                	push   $0x26
  800548:	68 94 22 80 00       	push   $0x802294
  80054d:	e8 5d ff ff ff       	call   8004af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800552:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800559:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800560:	e9 c5 00 00 00       	jmp    80062a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	01 d0                	add    %edx,%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	85 c0                	test   %eax,%eax
  800578:	75 08                	jne    800582 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80057a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80057d:	e9 a5 00 00 00       	jmp    800627 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800582:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800589:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800590:	eb 69                	jmp    8005fb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800592:	a1 60 30 80 00       	mov    0x803060,%eax
  800597:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80059d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a0:	89 d0                	mov    %edx,%eax
  8005a2:	01 c0                	add    %eax,%eax
  8005a4:	01 d0                	add    %edx,%eax
  8005a6:	c1 e0 03             	shl    $0x3,%eax
  8005a9:	01 c8                	add    %ecx,%eax
  8005ab:	8a 40 04             	mov    0x4(%eax),%al
  8005ae:	84 c0                	test   %al,%al
  8005b0:	75 46                	jne    8005f8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b2:	a1 60 30 80 00       	mov    0x803060,%eax
  8005b7:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	01 c0                	add    %eax,%eax
  8005c4:	01 d0                	add    %edx,%eax
  8005c6:	c1 e0 03             	shl    $0x3,%eax
  8005c9:	01 c8                	add    %ecx,%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005d8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	01 c8                	add    %ecx,%eax
  8005e9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005eb:	39 c2                	cmp    %eax,%edx
  8005ed:	75 09                	jne    8005f8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005ef:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005f6:	eb 15                	jmp    80060d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f8:	ff 45 e8             	incl   -0x18(%ebp)
  8005fb:	a1 60 30 80 00       	mov    0x803060,%eax
  800600:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800606:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800609:	39 c2                	cmp    %eax,%edx
  80060b:	77 85                	ja     800592 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800611:	75 14                	jne    800627 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 a0 22 80 00       	push   $0x8022a0
  80061b:	6a 3a                	push   $0x3a
  80061d:	68 94 22 80 00       	push   $0x802294
  800622:	e8 88 fe ff ff       	call   8004af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800627:	ff 45 f0             	incl   -0x10(%ebp)
  80062a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800630:	0f 8c 2f ff ff ff    	jl     800565 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800636:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800644:	eb 26                	jmp    80066c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800646:	a1 60 30 80 00       	mov    0x803060,%eax
  80064b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800651:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800654:	89 d0                	mov    %edx,%eax
  800656:	01 c0                	add    %eax,%eax
  800658:	01 d0                	add    %edx,%eax
  80065a:	c1 e0 03             	shl    $0x3,%eax
  80065d:	01 c8                	add    %ecx,%eax
  80065f:	8a 40 04             	mov    0x4(%eax),%al
  800662:	3c 01                	cmp    $0x1,%al
  800664:	75 03                	jne    800669 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800666:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800669:	ff 45 e0             	incl   -0x20(%ebp)
  80066c:	a1 60 30 80 00       	mov    0x803060,%eax
  800671:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800677:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067a:	39 c2                	cmp    %eax,%edx
  80067c:	77 c8                	ja     800646 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800681:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800684:	74 14                	je     80069a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	68 f4 22 80 00       	push   $0x8022f4
  80068e:	6a 44                	push   $0x44
  800690:	68 94 22 80 00       	push   $0x802294
  800695:	e8 15 fe ff ff       	call   8004af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80069a:	90                   	nop
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	53                   	push   %ebx
  8006a1:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	89 0a                	mov    %ecx,(%edx)
  8006b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b4:	88 d1                	mov    %dl,%cl
  8006b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c7:	75 30                	jne    8006f9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006c9:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  8006cf:	a0 84 30 80 00       	mov    0x803084,%al
  8006d4:	0f b6 c0             	movzbl %al,%eax
  8006d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006da:	8b 09                	mov    (%ecx),%ecx
  8006dc:	89 cb                	mov    %ecx,%ebx
  8006de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006e1:	83 c1 08             	add    $0x8,%ecx
  8006e4:	52                   	push   %edx
  8006e5:	50                   	push   %eax
  8006e6:	53                   	push   %ebx
  8006e7:	51                   	push   %ecx
  8006e8:	e8 a0 0f 00 00       	call   80168d <sys_cputs>
  8006ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fc:	8b 40 04             	mov    0x4(%eax),%eax
  8006ff:	8d 50 01             	lea    0x1(%eax),%edx
  800702:	8b 45 0c             	mov    0xc(%ebp),%eax
  800705:	89 50 04             	mov    %edx,0x4(%eax)
}
  800708:	90                   	nop
  800709:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070c:	c9                   	leave  
  80070d:	c3                   	ret    

0080070e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800717:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80071e:	00 00 00 
	b.cnt = 0;
  800721:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800728:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	ff 75 08             	pushl  0x8(%ebp)
  800731:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	68 9d 06 80 00       	push   $0x80069d
  80073d:	e8 5a 02 00 00       	call   80099c <vprintfmt>
  800742:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800745:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  80074b:	a0 84 30 80 00       	mov    0x803084,%al
  800750:	0f b6 c0             	movzbl %al,%eax
  800753:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800759:	52                   	push   %edx
  80075a:	50                   	push   %eax
  80075b:	51                   	push   %ecx
  80075c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800762:	83 c0 08             	add    $0x8,%eax
  800765:	50                   	push   %eax
  800766:	e8 22 0f 00 00       	call   80168d <sys_cputs>
  80076b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80076e:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  800775:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    

0080077d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800783:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  80078a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 f4             	pushl  -0xc(%ebp)
  800799:	50                   	push   %eax
  80079a:	e8 6f ff ff ff       	call   80070e <vcprintf>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007b0:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	c1 e0 08             	shl    $0x8,%eax
  8007bd:	a3 5c b1 81 00       	mov    %eax,0x81b15c
	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	e8 34 ff ff ff       	call   80070e <vcprintf>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007e0:	c7 05 5c b1 81 00 00 	movl   $0x700,0x81b15c
  8007e7:	07 00 00 

	return cnt;
  8007ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    

008007ef <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007f5:	e8 d7 0e 00 00       	call   8016d1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	50                   	push   %eax
  80080a:	e8 ff fe ff ff       	call   80070e <vcprintf>
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800815:	e8 d1 0e 00 00       	call   8016eb <sys_unlock_cons>
	return cnt;
  80081a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80081d:	c9                   	leave  
  80081e:	c3                   	ret    

0080081f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	53                   	push   %ebx
  800823:	83 ec 14             	sub    $0x14,%esp
  800826:	8b 45 10             	mov    0x10(%ebp),%eax
  800829:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800832:	8b 45 18             	mov    0x18(%ebp),%eax
  800835:	ba 00 00 00 00       	mov    $0x0,%edx
  80083a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80083d:	77 55                	ja     800894 <printnum+0x75>
  80083f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800842:	72 05                	jb     800849 <printnum+0x2a>
  800844:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800847:	77 4b                	ja     800894 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800849:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80084c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80084f:	8b 45 18             	mov    0x18(%ebp),%eax
  800852:	ba 00 00 00 00       	mov    $0x0,%edx
  800857:	52                   	push   %edx
  800858:	50                   	push   %eax
  800859:	ff 75 f4             	pushl  -0xc(%ebp)
  80085c:	ff 75 f0             	pushl  -0x10(%ebp)
  80085f:	e8 a8 13 00 00       	call   801c0c <__udivdi3>
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	83 ec 04             	sub    $0x4,%esp
  80086a:	ff 75 20             	pushl  0x20(%ebp)
  80086d:	53                   	push   %ebx
  80086e:	ff 75 18             	pushl  0x18(%ebp)
  800871:	52                   	push   %edx
  800872:	50                   	push   %eax
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	ff 75 08             	pushl  0x8(%ebp)
  800879:	e8 a1 ff ff ff       	call   80081f <printnum>
  80087e:	83 c4 20             	add    $0x20,%esp
  800881:	eb 1a                	jmp    80089d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 20             	pushl  0x20(%ebp)
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	ff d0                	call   *%eax
  800891:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800894:	ff 4d 1c             	decl   0x1c(%ebp)
  800897:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80089b:	7f e6                	jg     800883 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80089d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ab:	53                   	push   %ebx
  8008ac:	51                   	push   %ecx
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	e8 68 14 00 00       	call   801d1c <__umoddi3>
  8008b4:	83 c4 10             	add    $0x10,%esp
  8008b7:	05 54 25 80 00       	add    $0x802554,%eax
  8008bc:	8a 00                	mov    (%eax),%al
  8008be:	0f be c0             	movsbl %al,%eax
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
}
  8008d0:	90                   	nop
  8008d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d4:	c9                   	leave  
  8008d5:	c3                   	ret    

008008d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dd:	7e 1c                	jle    8008fb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 08             	lea    0x8(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 08             	sub    $0x8,%eax
  8008f4:	8b 50 04             	mov    0x4(%eax),%edx
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	eb 40                	jmp    80093b <getuint+0x65>
	else if (lflag)
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	74 1e                	je     80091f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
  80091d:	eb 1c                	jmp    80093b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	8d 50 04             	lea    0x4(%eax),%edx
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	89 10                	mov    %edx,(%eax)
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	83 e8 04             	sub    $0x4,%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800940:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800944:	7e 1c                	jle    800962 <getint+0x25>
		return va_arg(*ap, long long);
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	8d 50 08             	lea    0x8(%eax),%edx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 10                	mov    %edx,(%eax)
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	83 e8 08             	sub    $0x8,%eax
  80095b:	8b 50 04             	mov    0x4(%eax),%edx
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	eb 38                	jmp    80099a <getint+0x5d>
	else if (lflag)
  800962:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800966:	74 1a                	je     800982 <getint+0x45>
		return va_arg(*ap, long);
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	8d 50 04             	lea    0x4(%eax),%edx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	89 10                	mov    %edx,(%eax)
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	83 e8 04             	sub    $0x4,%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	99                   	cltd   
  800980:	eb 18                	jmp    80099a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	8d 50 04             	lea    0x4(%eax),%edx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 10                	mov    %edx,(%eax)
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	99                   	cltd   
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	56                   	push   %esi
  8009a0:	53                   	push   %ebx
  8009a1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a4:	eb 17                	jmp    8009bd <vprintfmt+0x21>
			if (ch == '\0')
  8009a6:	85 db                	test   %ebx,%ebx
  8009a8:	0f 84 c1 03 00 00    	je     800d6f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	53                   	push   %ebx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	ff d0                	call   *%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c0:	8d 50 01             	lea    0x1(%eax),%edx
  8009c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c6:	8a 00                	mov    (%eax),%al
  8009c8:	0f b6 d8             	movzbl %al,%ebx
  8009cb:	83 fb 25             	cmp    $0x25,%ebx
  8009ce:	75 d6                	jne    8009a6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f3:	8d 50 01             	lea    0x1(%eax),%edx
  8009f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f9:	8a 00                	mov    (%eax),%al
  8009fb:	0f b6 d8             	movzbl %al,%ebx
  8009fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a01:	83 f8 5b             	cmp    $0x5b,%eax
  800a04:	0f 87 3d 03 00 00    	ja     800d47 <vprintfmt+0x3ab>
  800a0a:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  800a11:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a13:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a17:	eb d7                	jmp    8009f0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a19:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a1d:	eb d1                	jmp    8009f0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a29:	89 d0                	mov    %edx,%eax
  800a2b:	c1 e0 02             	shl    $0x2,%eax
  800a2e:	01 d0                	add    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d8                	add    %ebx,%eax
  800a34:	83 e8 30             	sub    $0x30,%eax
  800a37:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3d:	8a 00                	mov    (%eax),%al
  800a3f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a42:	83 fb 2f             	cmp    $0x2f,%ebx
  800a45:	7e 3e                	jle    800a85 <vprintfmt+0xe9>
  800a47:	83 fb 39             	cmp    $0x39,%ebx
  800a4a:	7f 39                	jg     800a85 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a4f:	eb d5                	jmp    800a26 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a51:	8b 45 14             	mov    0x14(%ebp),%eax
  800a54:	83 c0 04             	add    $0x4,%eax
  800a57:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	83 e8 04             	sub    $0x4,%eax
  800a60:	8b 00                	mov    (%eax),%eax
  800a62:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a65:	eb 1f                	jmp    800a86 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	79 83                	jns    8009f0 <vprintfmt+0x54>
				width = 0;
  800a6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a74:	e9 77 ff ff ff       	jmp    8009f0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a79:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a80:	e9 6b ff ff ff       	jmp    8009f0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a85:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8a:	0f 89 60 ff ff ff    	jns    8009f0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a96:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a9d:	e9 4e ff ff ff       	jmp    8009f0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aa2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aa5:	e9 46 ff ff ff       	jmp    8009f0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	83 c0 04             	add    $0x4,%eax
  800ab0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 e8 04             	sub    $0x4,%eax
  800ab9:	8b 00                	mov    (%eax),%eax
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	50                   	push   %eax
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			break;
  800aca:	e9 9b 02 00 00       	jmp    800d6a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	83 e8 04             	sub    $0x4,%eax
  800ade:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ae0:	85 db                	test   %ebx,%ebx
  800ae2:	79 02                	jns    800ae6 <vprintfmt+0x14a>
				err = -err;
  800ae4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ae6:	83 fb 64             	cmp    $0x64,%ebx
  800ae9:	7f 0b                	jg     800af6 <vprintfmt+0x15a>
  800aeb:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  800af2:	85 f6                	test   %esi,%esi
  800af4:	75 19                	jne    800b0f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800af6:	53                   	push   %ebx
  800af7:	68 65 25 80 00       	push   $0x802565
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 08             	pushl  0x8(%ebp)
  800b02:	e8 70 02 00 00       	call   800d77 <printfmt>
  800b07:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b0a:	e9 5b 02 00 00       	jmp    800d6a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b0f:	56                   	push   %esi
  800b10:	68 6e 25 80 00       	push   $0x80256e
  800b15:	ff 75 0c             	pushl  0xc(%ebp)
  800b18:	ff 75 08             	pushl  0x8(%ebp)
  800b1b:	e8 57 02 00 00       	call   800d77 <printfmt>
  800b20:	83 c4 10             	add    $0x10,%esp
			break;
  800b23:	e9 42 02 00 00       	jmp    800d6a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	83 c0 04             	add    $0x4,%eax
  800b2e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b31:	8b 45 14             	mov    0x14(%ebp),%eax
  800b34:	83 e8 04             	sub    $0x4,%eax
  800b37:	8b 30                	mov    (%eax),%esi
  800b39:	85 f6                	test   %esi,%esi
  800b3b:	75 05                	jne    800b42 <vprintfmt+0x1a6>
				p = "(null)";
  800b3d:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  800b42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b46:	7e 6d                	jle    800bb5 <vprintfmt+0x219>
  800b48:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b4c:	74 67                	je     800bb5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	50                   	push   %eax
  800b55:	56                   	push   %esi
  800b56:	e8 1e 03 00 00       	call   800e79 <strnlen>
  800b5b:	83 c4 10             	add    $0x10,%esp
  800b5e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b61:	eb 16                	jmp    800b79 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b63:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b76:	ff 4d e4             	decl   -0x1c(%ebp)
  800b79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7d:	7f e4                	jg     800b63 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7f:	eb 34                	jmp    800bb5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b81:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b85:	74 1c                	je     800ba3 <vprintfmt+0x207>
  800b87:	83 fb 1f             	cmp    $0x1f,%ebx
  800b8a:	7e 05                	jle    800b91 <vprintfmt+0x1f5>
  800b8c:	83 fb 7e             	cmp    $0x7e,%ebx
  800b8f:	7e 12                	jle    800ba3 <vprintfmt+0x207>
					putch('?', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 3f                	push   $0x3f
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	eb 0f                	jmp    800bb2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	53                   	push   %ebx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb5:	89 f0                	mov    %esi,%eax
  800bb7:	8d 70 01             	lea    0x1(%eax),%esi
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f be d8             	movsbl %al,%ebx
  800bbf:	85 db                	test   %ebx,%ebx
  800bc1:	74 24                	je     800be7 <vprintfmt+0x24b>
  800bc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc7:	78 b8                	js     800b81 <vprintfmt+0x1e5>
  800bc9:	ff 4d e0             	decl   -0x20(%ebp)
  800bcc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd0:	79 af                	jns    800b81 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd2:	eb 13                	jmp    800be7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bd4:	83 ec 08             	sub    $0x8,%esp
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	6a 20                	push   $0x20
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	ff d0                	call   *%eax
  800be1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be4:	ff 4d e4             	decl   -0x1c(%ebp)
  800be7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800beb:	7f e7                	jg     800bd4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bed:	e9 78 01 00 00       	jmp    800d6a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfb:	50                   	push   %eax
  800bfc:	e8 3c fd ff ff       	call   80093d <getint>
  800c01:	83 c4 10             	add    $0x10,%esp
  800c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c10:	85 d2                	test   %edx,%edx
  800c12:	79 23                	jns    800c37 <vprintfmt+0x29b>
				putch('-', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 2d                	push   $0x2d
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2a:	f7 d8                	neg    %eax
  800c2c:	83 d2 00             	adc    $0x0,%edx
  800c2f:	f7 da                	neg    %edx
  800c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c37:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3e:	e9 bc 00 00 00       	jmp    800cff <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c43:	83 ec 08             	sub    $0x8,%esp
  800c46:	ff 75 e8             	pushl  -0x18(%ebp)
  800c49:	8d 45 14             	lea    0x14(%ebp),%eax
  800c4c:	50                   	push   %eax
  800c4d:	e8 84 fc ff ff       	call   8008d6 <getuint>
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c5b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c62:	e9 98 00 00 00       	jmp    800cff <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	6a 58                	push   $0x58
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	ff d0                	call   *%eax
  800c74:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	6a 58                	push   $0x58
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	6a 58                	push   $0x58
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
			break;
  800c97:	e9 ce 00 00 00       	jmp    800d6a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	6a 30                	push   $0x30
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	ff d0                	call   *%eax
  800ca9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cac:	83 ec 08             	sub    $0x8,%esp
  800caf:	ff 75 0c             	pushl  0xc(%ebp)
  800cb2:	6a 78                	push   $0x78
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	ff d0                	call   *%eax
  800cb9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbf:	83 c0 04             	add    $0x4,%eax
  800cc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc8:	83 e8 04             	sub    $0x4,%eax
  800ccb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cd7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cde:	eb 1f                	jmp    800cff <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ce6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce9:	50                   	push   %eax
  800cea:	e8 e7 fb ff ff       	call   8008d6 <getuint>
  800cef:	83 c4 10             	add    $0x10,%esp
  800cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cf8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cff:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d06:	83 ec 04             	sub    $0x4,%esp
  800d09:	52                   	push   %edx
  800d0a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d0d:	50                   	push   %eax
  800d0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d11:	ff 75 f0             	pushl  -0x10(%ebp)
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 00 fb ff ff       	call   80081f <printnum>
  800d1f:	83 c4 20             	add    $0x20,%esp
			break;
  800d22:	eb 46                	jmp    800d6a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	ff 75 0c             	pushl  0xc(%ebp)
  800d2a:	53                   	push   %ebx
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	ff d0                	call   *%eax
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	eb 35                	jmp    800d6a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d35:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  800d3c:	eb 2c                	jmp    800d6a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d3e:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  800d45:	eb 23                	jmp    800d6a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d47:	83 ec 08             	sub    $0x8,%esp
  800d4a:	ff 75 0c             	pushl  0xc(%ebp)
  800d4d:	6a 25                	push   $0x25
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d57:	ff 4d 10             	decl   0x10(%ebp)
  800d5a:	eb 03                	jmp    800d5f <vprintfmt+0x3c3>
  800d5c:	ff 4d 10             	decl   0x10(%ebp)
  800d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d62:	48                   	dec    %eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	3c 25                	cmp    $0x25,%al
  800d67:	75 f3                	jne    800d5c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d69:	90                   	nop
		}
	}
  800d6a:	e9 35 fc ff ff       	jmp    8009a4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d6f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    

00800d77 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d7d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8c:	50                   	push   %eax
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	ff 75 08             	pushl  0x8(%ebp)
  800d93:	e8 04 fc ff ff       	call   80099c <vprintfmt>
  800d98:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d9b:	90                   	nop
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8b 40 08             	mov    0x8(%eax),%eax
  800da7:	8d 50 01             	lea    0x1(%eax),%edx
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	8b 10                	mov    (%eax),%edx
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	8b 40 04             	mov    0x4(%eax),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	73 12                	jae    800dd1 <sprintputch+0x33>
		*b->buf++ = ch;
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	8b 00                	mov    (%eax),%eax
  800dc4:	8d 48 01             	lea    0x1(%eax),%ecx
  800dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dca:	89 0a                	mov    %ecx,(%edx)
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	88 10                	mov    %dl,(%eax)
}
  800dd1:	90                   	nop
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	01 d0                	add    %edx,%eax
  800deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800df5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df9:	74 06                	je     800e01 <vsnprintf+0x2d>
  800dfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dff:	7f 07                	jg     800e08 <vsnprintf+0x34>
		return -E_INVAL;
  800e01:	b8 03 00 00 00       	mov    $0x3,%eax
  800e06:	eb 20                	jmp    800e28 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e08:	ff 75 14             	pushl  0x14(%ebp)
  800e0b:	ff 75 10             	pushl  0x10(%ebp)
  800e0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e11:	50                   	push   %eax
  800e12:	68 9e 0d 80 00       	push   $0x800d9e
  800e17:	e8 80 fb ff ff       	call   80099c <vprintfmt>
  800e1c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e22:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e28:	c9                   	leave  
  800e29:	c3                   	ret    

00800e2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e30:	8d 45 10             	lea    0x10(%ebp),%eax
  800e33:	83 c0 04             	add    $0x4,%eax
  800e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3f:	50                   	push   %eax
  800e40:	ff 75 0c             	pushl  0xc(%ebp)
  800e43:	ff 75 08             	pushl  0x8(%ebp)
  800e46:	e8 89 ff ff ff       	call   800dd4 <vsnprintf>
  800e4b:	83 c4 10             	add    $0x10,%esp
  800e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e63:	eb 06                	jmp    800e6b <strlen+0x15>
		n++;
  800e65:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e68:	ff 45 08             	incl   0x8(%ebp)
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	84 c0                	test   %al,%al
  800e72:	75 f1                	jne    800e65 <strlen+0xf>
		n++;
	return n;
  800e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e86:	eb 09                	jmp    800e91 <strnlen+0x18>
		n++;
  800e88:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e8b:	ff 45 08             	incl   0x8(%ebp)
  800e8e:	ff 4d 0c             	decl   0xc(%ebp)
  800e91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e95:	74 09                	je     800ea0 <strnlen+0x27>
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e8                	jne    800e88 <strnlen+0xf>
		n++;
	return n;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eb1:	90                   	nop
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	84 c0                	test   %al,%al
  800ecc:	75 e4                	jne    800eb2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    

00800ed3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800edf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee6:	eb 1f                	jmp    800f07 <strncpy+0x34>
		*dst++ = *src;
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8d 50 01             	lea    0x1(%eax),%edx
  800eee:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef4:	8a 12                	mov    (%edx),%dl
  800ef6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	84 c0                	test   %al,%al
  800eff:	74 03                	je     800f04 <strncpy+0x31>
			src++;
  800f01:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f04:	ff 45 fc             	incl   -0x4(%ebp)
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f0d:	72 d9                	jb     800ee8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f24:	74 30                	je     800f56 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f26:	eb 16                	jmp    800f3e <strlcpy+0x2a>
			*dst++ = *src++;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8d 50 01             	lea    0x1(%eax),%edx
  800f2e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f37:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f3a:	8a 12                	mov    (%edx),%dl
  800f3c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f3e:	ff 4d 10             	decl   0x10(%ebp)
  800f41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f45:	74 09                	je     800f50 <strlcpy+0x3c>
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	84 c0                	test   %al,%al
  800f4e:	75 d8                	jne    800f28 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5c:	29 c2                	sub    %eax,%edx
  800f5e:	89 d0                	mov    %edx,%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f65:	eb 06                	jmp    800f6d <strcmp+0xb>
		p++, q++;
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	84 c0                	test   %al,%al
  800f74:	74 0e                	je     800f84 <strcmp+0x22>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 10                	mov    (%eax),%dl
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	38 c2                	cmp    %al,%dl
  800f82:	74 e3                	je     800f67 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f b6 d0             	movzbl %al,%edx
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	29 c2                	sub    %eax,%edx
  800f96:	89 d0                	mov    %edx,%eax
}
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f9d:	eb 09                	jmp    800fa8 <strncmp+0xe>
		n--, p++, q++;
  800f9f:	ff 4d 10             	decl   0x10(%ebp)
  800fa2:	ff 45 08             	incl   0x8(%ebp)
  800fa5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	74 17                	je     800fc5 <strncmp+0x2b>
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	84 c0                	test   %al,%al
  800fb5:	74 0e                	je     800fc5 <strncmp+0x2b>
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 10                	mov    (%eax),%dl
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	38 c2                	cmp    %al,%dl
  800fc3:	74 da                	je     800f9f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc9:	75 07                	jne    800fd2 <strncmp+0x38>
		return 0;
  800fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd0:	eb 14                	jmp    800fe6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f b6 d0             	movzbl %al,%edx
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	0f b6 c0             	movzbl %al,%eax
  800fe2:	29 c2                	sub    %eax,%edx
  800fe4:	89 d0                	mov    %edx,%eax
}
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 04             	sub    $0x4,%esp
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff4:	eb 12                	jmp    801008 <strchr+0x20>
		if (*s == c)
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ffe:	75 05                	jne    801005 <strchr+0x1d>
			return (char *) s;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	eb 11                	jmp    801016 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801005:	ff 45 08             	incl   0x8(%ebp)
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	84 c0                	test   %al,%al
  80100f:	75 e5                	jne    800ff6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801011:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801024:	eb 0d                	jmp    801033 <strfind+0x1b>
		if (*s == c)
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80102e:	74 0e                	je     80103e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801030:	ff 45 08             	incl   0x8(%ebp)
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	84 c0                	test   %al,%al
  80103a:	75 ea                	jne    801026 <strfind+0xe>
  80103c:	eb 01                	jmp    80103f <strfind+0x27>
		if (*s == c)
			break;
  80103e:	90                   	nop
	return (char *) s;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801050:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801054:	76 63                	jbe    8010b9 <memset+0x75>
		uint64 data_block = c;
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	99                   	cltd   
  80105a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801066:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80106a:	c1 e0 08             	shl    $0x8,%eax
  80106d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801070:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801079:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80107d:	c1 e0 10             	shl    $0x10,%eax
  801080:	09 45 f0             	or     %eax,-0x10(%ebp)
  801083:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108c:	89 c2                	mov    %eax,%edx
  80108e:	b8 00 00 00 00       	mov    $0x0,%eax
  801093:	09 45 f0             	or     %eax,-0x10(%ebp)
  801096:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801099:	eb 18                	jmp    8010b3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80109b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80109e:	8d 41 08             	lea    0x8(%ecx),%eax
  8010a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010aa:	89 01                	mov    %eax,(%ecx)
  8010ac:	89 51 04             	mov    %edx,0x4(%ecx)
  8010af:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010b3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b7:	77 e2                	ja     80109b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	74 23                	je     8010e2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010c5:	eb 0e                	jmp    8010d5 <memset+0x91>
			*p8++ = (uint8)c;
  8010c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ca:	8d 50 01             	lea    0x1(%eax),%edx
  8010cd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010db:	89 55 10             	mov    %edx,0x10(%ebp)
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	75 e5                	jne    8010c7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010f9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fd:	76 24                	jbe    801123 <memcpy+0x3c>
		while(n >= 8){
  8010ff:	eb 1c                	jmp    80111d <memcpy+0x36>
			*d64 = *s64;
  801101:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801104:	8b 50 04             	mov    0x4(%eax),%edx
  801107:	8b 00                	mov    (%eax),%eax
  801109:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80110c:	89 01                	mov    %eax,(%ecx)
  80110e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801111:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801115:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801119:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80111d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801121:	77 de                	ja     801101 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801123:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801127:	74 31                	je     80115a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80112f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801132:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801135:	eb 16                	jmp    80114d <memcpy+0x66>
			*d8++ = *s8++;
  801137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113a:	8d 50 01             	lea    0x1(%eax),%edx
  80113d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8d 4a 01             	lea    0x1(%edx),%ecx
  801146:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801149:	8a 12                	mov    (%edx),%dl
  80114b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80114d:	8b 45 10             	mov    0x10(%ebp),%eax
  801150:	8d 50 ff             	lea    -0x1(%eax),%edx
  801153:	89 55 10             	mov    %edx,0x10(%ebp)
  801156:	85 c0                	test   %eax,%eax
  801158:	75 dd                	jne    801137 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801165:	8b 45 0c             	mov    0xc(%ebp),%eax
  801168:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801171:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801174:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801177:	73 50                	jae    8011c9 <memmove+0x6a>
  801179:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	01 d0                	add    %edx,%eax
  801181:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801184:	76 43                	jbe    8011c9 <memmove+0x6a>
		s += n;
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801192:	eb 10                	jmp    8011a4 <memmove+0x45>
			*--d = *--s;
  801194:	ff 4d f8             	decl   -0x8(%ebp)
  801197:	ff 4d fc             	decl   -0x4(%ebp)
  80119a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119d:	8a 10                	mov    (%eax),%dl
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	75 e3                	jne    801194 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011b1:	eb 23                	jmp    8011d6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b6:	8d 50 01             	lea    0x1(%eax),%edx
  8011b9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011c5:	8a 12                	mov    (%edx),%dl
  8011c7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	75 dd                	jne    8011b3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011ed:	eb 2a                	jmp    801219 <memcmp+0x3e>
		if (*s1 != *s2)
  8011ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f2:	8a 10                	mov    (%eax),%dl
  8011f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	38 c2                	cmp    %al,%dl
  8011fb:	74 16                	je     801213 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	0f b6 d0             	movzbl %al,%edx
  801205:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	0f b6 c0             	movzbl %al,%eax
  80120d:	29 c2                	sub    %eax,%edx
  80120f:	89 d0                	mov    %edx,%eax
  801211:	eb 18                	jmp    80122b <memcmp+0x50>
		s1++, s2++;
  801213:	ff 45 fc             	incl   -0x4(%ebp)
  801216:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801219:	8b 45 10             	mov    0x10(%ebp),%eax
  80121c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80121f:	89 55 10             	mov    %edx,0x10(%ebp)
  801222:	85 c0                	test   %eax,%eax
  801224:	75 c9                	jne    8011ef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122b:	c9                   	leave  
  80122c:	c3                   	ret    

0080122d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 d0                	add    %edx,%eax
  80123b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80123e:	eb 15                	jmp    801255 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f b6 d0             	movzbl %al,%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	0f b6 c0             	movzbl %al,%eax
  80124e:	39 c2                	cmp    %eax,%edx
  801250:	74 0d                	je     80125f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801252:	ff 45 08             	incl   0x8(%ebp)
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80125b:	72 e3                	jb     801240 <memfind+0x13>
  80125d:	eb 01                	jmp    801260 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80125f:	90                   	nop
	return (void *) s;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801279:	eb 03                	jmp    80127e <strtol+0x19>
		s++;
  80127b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 20                	cmp    $0x20,%al
  801285:	74 f4                	je     80127b <strtol+0x16>
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 09                	cmp    $0x9,%al
  80128e:	74 eb                	je     80127b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	3c 2b                	cmp    $0x2b,%al
  801297:	75 05                	jne    80129e <strtol+0x39>
		s++;
  801299:	ff 45 08             	incl   0x8(%ebp)
  80129c:	eb 13                	jmp    8012b1 <strtol+0x4c>
	else if (*s == '-')
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	3c 2d                	cmp    $0x2d,%al
  8012a5:	75 0a                	jne    8012b1 <strtol+0x4c>
		s++, neg = 1;
  8012a7:	ff 45 08             	incl   0x8(%ebp)
  8012aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b5:	74 06                	je     8012bd <strtol+0x58>
  8012b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012bb:	75 20                	jne    8012dd <strtol+0x78>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 30                	cmp    $0x30,%al
  8012c4:	75 17                	jne    8012dd <strtol+0x78>
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	40                   	inc    %eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3c 78                	cmp    $0x78,%al
  8012ce:	75 0d                	jne    8012dd <strtol+0x78>
		s += 2, base = 16;
  8012d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012db:	eb 28                	jmp    801305 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e1:	75 15                	jne    8012f8 <strtol+0x93>
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	3c 30                	cmp    $0x30,%al
  8012ea:	75 0c                	jne    8012f8 <strtol+0x93>
		s++, base = 8;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012f6:	eb 0d                	jmp    801305 <strtol+0xa0>
	else if (base == 0)
  8012f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012fc:	75 07                	jne    801305 <strtol+0xa0>
		base = 10;
  8012fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	3c 2f                	cmp    $0x2f,%al
  80130c:	7e 19                	jle    801327 <strtol+0xc2>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	3c 39                	cmp    $0x39,%al
  801315:	7f 10                	jg     801327 <strtol+0xc2>
			dig = *s - '0';
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	83 e8 30             	sub    $0x30,%eax
  801322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801325:	eb 42                	jmp    801369 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	3c 60                	cmp    $0x60,%al
  80132e:	7e 19                	jle    801349 <strtol+0xe4>
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	3c 7a                	cmp    $0x7a,%al
  801337:	7f 10                	jg     801349 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	0f be c0             	movsbl %al,%eax
  801341:	83 e8 57             	sub    $0x57,%eax
  801344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801347:	eb 20                	jmp    801369 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	3c 40                	cmp    $0x40,%al
  801350:	7e 39                	jle    80138b <strtol+0x126>
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	3c 5a                	cmp    $0x5a,%al
  801359:	7f 30                	jg     80138b <strtol+0x126>
			dig = *s - 'A' + 10;
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8a 00                	mov    (%eax),%al
  801360:	0f be c0             	movsbl %al,%eax
  801363:	83 e8 37             	sub    $0x37,%eax
  801366:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80136f:	7d 19                	jge    80138a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801371:	ff 45 08             	incl   0x8(%ebp)
  801374:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801377:	0f af 45 10          	imul   0x10(%ebp),%eax
  80137b:	89 c2                	mov    %eax,%edx
  80137d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801380:	01 d0                	add    %edx,%eax
  801382:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801385:	e9 7b ff ff ff       	jmp    801305 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80138a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80138b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80138f:	74 08                	je     801399 <strtol+0x134>
		*endptr = (char *) s;
  801391:	8b 45 0c             	mov    0xc(%ebp),%eax
  801394:	8b 55 08             	mov    0x8(%ebp),%edx
  801397:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801399:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80139d:	74 07                	je     8013a6 <strtol+0x141>
  80139f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a2:	f7 d8                	neg    %eax
  8013a4:	eb 03                	jmp    8013a9 <strtol+0x144>
  8013a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <ltostr>:

void
ltostr(long value, char *str)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c3:	79 13                	jns    8013d8 <ltostr+0x2d>
	{
		neg = 1;
  8013c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013e0:	99                   	cltd   
  8013e1:	f7 f9                	idiv   %ecx
  8013e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e9:	8d 50 01             	lea    0x1(%eax),%edx
  8013ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013ef:	89 c2                	mov    %eax,%edx
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013f9:	83 c2 30             	add    $0x30,%edx
  8013fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801401:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801406:	f7 e9                	imul   %ecx
  801408:	c1 fa 02             	sar    $0x2,%edx
  80140b:	89 c8                	mov    %ecx,%eax
  80140d:	c1 f8 1f             	sar    $0x1f,%eax
  801410:	29 c2                	sub    %eax,%edx
  801412:	89 d0                	mov    %edx,%eax
  801414:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801417:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80141b:	75 bb                	jne    8013d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801424:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801427:	48                   	dec    %eax
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142f:	74 3d                	je     80146e <ltostr+0xc3>
		start = 1 ;
  801431:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801438:	eb 34                	jmp    80146e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80143a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801447:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	01 c2                	add    %eax,%edx
  80144f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801452:	8b 45 0c             	mov    0xc(%ebp),%eax
  801455:	01 c8                	add    %ecx,%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801461:	01 c2                	add    %eax,%edx
  801463:	8a 45 eb             	mov    -0x15(%ebp),%al
  801466:	88 02                	mov    %al,(%edx)
		start++ ;
  801468:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801471:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801474:	7c c4                	jl     80143a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801476:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801481:	90                   	nop
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80148a:	ff 75 08             	pushl  0x8(%ebp)
  80148d:	e8 c4 f9 ff ff       	call   800e56 <strlen>
  801492:	83 c4 04             	add    $0x4,%esp
  801495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801498:	ff 75 0c             	pushl  0xc(%ebp)
  80149b:	e8 b6 f9 ff ff       	call   800e56 <strlen>
  8014a0:	83 c4 04             	add    $0x4,%esp
  8014a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b4:	eb 17                	jmp    8014cd <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 c2                	add    %eax,%edx
  8014be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	01 c8                	add    %ecx,%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ca:	ff 45 fc             	incl   -0x4(%ebp)
  8014cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d3:	7c e1                	jl     8014b6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e3:	eb 1f                	jmp    801504 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ee:	89 c2                	mov    %eax,%edx
  8014f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f3:	01 c2                	add    %eax,%edx
  8014f5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	01 c8                	add    %ecx,%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801501:	ff 45 f8             	incl   -0x8(%ebp)
  801504:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801507:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80150a:	7c d9                	jl     8014e5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150f:	8b 45 10             	mov    0x10(%ebp),%eax
  801512:	01 d0                	add    %edx,%eax
  801514:	c6 00 00             	movb   $0x0,(%eax)
}
  801517:	90                   	nop
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151d:	8b 45 14             	mov    0x14(%ebp),%eax
  801520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801526:	8b 45 14             	mov    0x14(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801532:	8b 45 10             	mov    0x10(%ebp),%eax
  801535:	01 d0                	add    %edx,%eax
  801537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153d:	eb 0c                	jmp    80154b <strsplit+0x31>
			*string++ = 0;
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8d 50 01             	lea    0x1(%eax),%edx
  801545:	89 55 08             	mov    %edx,0x8(%ebp)
  801548:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	84 c0                	test   %al,%al
  801552:	74 18                	je     80156c <strsplit+0x52>
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	0f be c0             	movsbl %al,%eax
  80155c:	50                   	push   %eax
  80155d:	ff 75 0c             	pushl  0xc(%ebp)
  801560:	e8 83 fa ff ff       	call   800fe8 <strchr>
  801565:	83 c4 08             	add    $0x8,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	75 d3                	jne    80153f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	84 c0                	test   %al,%al
  801573:	74 5a                	je     8015cf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801575:	8b 45 14             	mov    0x14(%ebp),%eax
  801578:	8b 00                	mov    (%eax),%eax
  80157a:	83 f8 0f             	cmp    $0xf,%eax
  80157d:	75 07                	jne    801586 <strsplit+0x6c>
		{
			return 0;
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
  801584:	eb 66                	jmp    8015ec <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801586:	8b 45 14             	mov    0x14(%ebp),%eax
  801589:	8b 00                	mov    (%eax),%eax
  80158b:	8d 48 01             	lea    0x1(%eax),%ecx
  80158e:	8b 55 14             	mov    0x14(%ebp),%edx
  801591:	89 0a                	mov    %ecx,(%edx)
  801593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80159a:	8b 45 10             	mov    0x10(%ebp),%eax
  80159d:	01 c2                	add    %eax,%edx
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a4:	eb 03                	jmp    8015a9 <strsplit+0x8f>
			string++;
  8015a6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	84 c0                	test   %al,%al
  8015b0:	74 8b                	je     80153d <strsplit+0x23>
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	0f be c0             	movsbl %al,%eax
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	e8 25 fa ff ff       	call   800fe8 <strchr>
  8015c3:	83 c4 08             	add    $0x8,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	74 dc                	je     8015a6 <strsplit+0x8c>
			string++;
	}
  8015ca:	e9 6e ff ff ff       	jmp    80153d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015cf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801601:	eb 4a                	jmp    80164d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	01 c2                	add    %eax,%edx
  80160b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80160e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801611:	01 c8                	add    %ecx,%eax
  801613:	8a 00                	mov    (%eax),%al
  801615:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801617:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	3c 40                	cmp    $0x40,%al
  801623:	7e 25                	jle    80164a <str2lower+0x5c>
  801625:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	3c 5a                	cmp    $0x5a,%al
  801631:	7f 17                	jg     80164a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801633:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	01 d0                	add    %edx,%eax
  80163b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80163e:	8b 55 08             	mov    0x8(%ebp),%edx
  801641:	01 ca                	add    %ecx,%edx
  801643:	8a 12                	mov    (%edx),%dl
  801645:	83 c2 20             	add    $0x20,%edx
  801648:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80164a:	ff 45 fc             	incl   -0x4(%ebp)
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	e8 01 f8 ff ff       	call   800e56 <strlen>
  801655:	83 c4 04             	add    $0x4,%esp
  801658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80165b:	7f a6                	jg     801603 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	57                   	push   %edi
  801666:	56                   	push   %esi
  801667:	53                   	push   %ebx
  801668:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801671:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801674:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801677:	8b 7d 18             	mov    0x18(%ebp),%edi
  80167a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80167d:	cd 30                	int    $0x30
  80167f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801682:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	5b                   	pop    %ebx
  801689:	5e                   	pop    %esi
  80168a:	5f                   	pop    %edi
  80168b:	5d                   	pop    %ebp
  80168c:	c3                   	ret    

0080168d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	8b 45 10             	mov    0x10(%ebp),%eax
  801696:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801699:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80169c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	51                   	push   %ecx
  8016a6:	52                   	push   %edx
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	50                   	push   %eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	e8 b0 ff ff ff       	call   801662 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	90                   	nop
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 02                	push   $0x2
  8016c7:	e8 96 ff ff ff       	call   801662 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 03                	push   $0x3
  8016e0:	e8 7d ff ff ff       	call   801662 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	90                   	nop
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 04                	push   $0x4
  8016fa:	e8 63 ff ff ff       	call   801662 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801708:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	52                   	push   %edx
  801715:	50                   	push   %eax
  801716:	6a 08                	push   $0x8
  801718:	e8 45 ff ff ff       	call   801662 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	56                   	push   %esi
  801726:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801727:	8b 75 18             	mov    0x18(%ebp),%esi
  80172a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801730:	8b 55 0c             	mov    0xc(%ebp),%edx
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	51                   	push   %ecx
  801739:	52                   	push   %edx
  80173a:	50                   	push   %eax
  80173b:	6a 09                	push   $0x9
  80173d:	e8 20 ff ff ff       	call   801662 <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    

0080174c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	ff 75 08             	pushl  0x8(%ebp)
  80175a:	6a 0a                	push   $0xa
  80175c:	e8 01 ff ff ff       	call   801662 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	ff 75 08             	pushl  0x8(%ebp)
  801775:	6a 0b                	push   $0xb
  801777:	e8 e6 fe ff ff       	call   801662 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 0c                	push   $0xc
  801790:	e8 cd fe ff ff       	call   801662 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 0d                	push   $0xd
  8017a9:	e8 b4 fe ff ff       	call   801662 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 0e                	push   $0xe
  8017c2:	e8 9b fe ff ff       	call   801662 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 0f                	push   $0xf
  8017db:	e8 82 fe ff ff       	call   801662 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	6a 10                	push   $0x10
  8017f5:	e8 68 fe ff ff       	call   801662 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 11                	push   $0x11
  80180e:	e8 4f fe ff ff       	call   801662 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	90                   	nop
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_cputc>:

void
sys_cputc(const char c)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 04             	sub    $0x4,%esp
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801825:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	50                   	push   %eax
  801832:	6a 01                	push   $0x1
  801834:	e8 29 fe ff ff       	call   801662 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	90                   	nop
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 14                	push   $0x14
  80184e:	e8 0f fe ff ff       	call   801662 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	90                   	nop
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	8b 45 10             	mov    0x10(%ebp),%eax
  801862:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801865:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801868:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	51                   	push   %ecx
  801872:	52                   	push   %edx
  801873:	ff 75 0c             	pushl  0xc(%ebp)
  801876:	50                   	push   %eax
  801877:	6a 15                	push   $0x15
  801879:	e8 e4 fd ff ff       	call   801662 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801886:	8b 55 0c             	mov    0xc(%ebp),%edx
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 16                	push   $0x16
  801896:	e8 c7 fd ff ff       	call   801662 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	51                   	push   %ecx
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 17                	push   $0x17
  8018b5:	e8 a8 fd ff ff       	call   801662 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	52                   	push   %edx
  8018cf:	50                   	push   %eax
  8018d0:	6a 18                	push   $0x18
  8018d2:	e8 8b fd ff ff       	call   801662 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	ff 75 14             	pushl  0x14(%ebp)
  8018e7:	ff 75 10             	pushl  0x10(%ebp)
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	50                   	push   %eax
  8018ee:	6a 19                	push   $0x19
  8018f0:	e8 6d fd ff ff       	call   801662 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	50                   	push   %eax
  801909:	6a 1a                	push   $0x1a
  80190b:	e8 52 fd ff ff       	call   801662 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	50                   	push   %eax
  801925:	6a 1b                	push   $0x1b
  801927:	e8 36 fd ff ff       	call   801662 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 05                	push   $0x5
  801940:	e8 1d fd ff ff       	call   801662 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 06                	push   $0x6
  801959:	e8 04 fd ff ff       	call   801662 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 07                	push   $0x7
  801972:	e8 eb fc ff ff       	call   801662 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_exit_env>:


void sys_exit_env(void)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 1c                	push   $0x1c
  80198b:	e8 d2 fc ff ff       	call   801662 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	90                   	nop
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80199c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80199f:	8d 50 04             	lea    0x4(%eax),%edx
  8019a2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	52                   	push   %edx
  8019ac:	50                   	push   %eax
  8019ad:	6a 1d                	push   $0x1d
  8019af:	e8 ae fc ff ff       	call   801662 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return result;
  8019b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c0:	89 01                	mov    %eax,(%ecx)
  8019c2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	c9                   	leave  
  8019c9:	c2 04 00             	ret    $0x4

008019cc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 10             	pushl  0x10(%ebp)
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	ff 75 08             	pushl  0x8(%ebp)
  8019dc:	6a 13                	push   $0x13
  8019de:	e8 7f fc ff ff       	call   801662 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e6:	90                   	nop
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 1e                	push   $0x1e
  8019f8:	e8 65 fc ff ff       	call   801662 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a0e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	50                   	push   %eax
  801a1b:	6a 1f                	push   $0x1f
  801a1d:	e8 40 fc ff ff       	call   801662 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
	return ;
  801a25:	90                   	nop
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <rsttst>:
void rsttst()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 21                	push   $0x21
  801a37:	e8 26 fc ff ff       	call   801662 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a4e:	8b 55 18             	mov    0x18(%ebp),%edx
  801a51:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	ff 75 10             	pushl  0x10(%ebp)
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	ff 75 08             	pushl  0x8(%ebp)
  801a60:	6a 20                	push   $0x20
  801a62:	e8 fb fb ff ff       	call   801662 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6a:	90                   	nop
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <chktst>:
void chktst(uint32 n)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 22                	push   $0x22
  801a7d:	e8 e0 fb ff ff       	call   801662 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
	return ;
  801a85:	90                   	nop
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <inctst>:

void inctst()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 23                	push   $0x23
  801a97:	e8 c6 fb ff ff       	call   801662 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <gettst>:
uint32 gettst()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 24                	push   $0x24
  801ab1:	e8 ac fb ff ff       	call   801662 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 25                	push   $0x25
  801aca:	e8 93 fb ff ff       	call   801662 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
  801ad2:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	return uheapPlaceStrategy ;
  801ad7:	a1 a0 b0 81 00       	mov    0x81b0a0,%eax
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	6a 26                	push   $0x26
  801af6:	e8 67 fb ff ff       	call   801662 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
	return ;
  801afe:	90                   	nop
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	53                   	push   %ebx
  801b14:	51                   	push   %ecx
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 27                	push   $0x27
  801b19:	e8 44 fb ff ff       	call   801662 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 28                	push   $0x28
  801b39:	e8 24 fb ff ff       	call   801662 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b46:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	51                   	push   %ecx
  801b52:	ff 75 10             	pushl  0x10(%ebp)
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 29                	push   $0x29
  801b59:	e8 04 fb ff ff       	call   801662 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	ff 75 10             	pushl  0x10(%ebp)
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	ff 75 08             	pushl  0x8(%ebp)
  801b73:	6a 12                	push   $0x12
  801b75:	e8 e8 fa ff ff       	call   801662 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7d:	90                   	nop
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	52                   	push   %edx
  801b90:	50                   	push   %eax
  801b91:	6a 2a                	push   $0x2a
  801b93:	e8 ca fa ff ff       	call   801662 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
	return;
  801b9b:	90                   	nop
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 2b                	push   $0x2b
  801bad:	e8 b0 fa ff ff       	call   801662 <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	6a 2d                	push   $0x2d
  801bc8:	e8 95 fa ff ff       	call   801662 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
	return;
  801bd0:	90                   	nop
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	ff 75 08             	pushl  0x8(%ebp)
  801be2:	6a 2c                	push   $0x2c
  801be4:	e8 79 fa ff ff       	call   801662 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bec:	90                   	nop
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	68 e8 26 80 00       	push   $0x8026e8
  801bfd:	68 25 01 00 00       	push   $0x125
  801c02:	68 1b 27 80 00       	push   $0x80271b
  801c07:	e8 a3 e8 ff ff       	call   8004af <_panic>

00801c0c <__udivdi3>:
  801c0c:	55                   	push   %ebp
  801c0d:	57                   	push   %edi
  801c0e:	56                   	push   %esi
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 1c             	sub    $0x1c,%esp
  801c13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c23:	89 ca                	mov    %ecx,%edx
  801c25:	89 f8                	mov    %edi,%eax
  801c27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c2b:	85 f6                	test   %esi,%esi
  801c2d:	75 2d                	jne    801c5c <__udivdi3+0x50>
  801c2f:	39 cf                	cmp    %ecx,%edi
  801c31:	77 65                	ja     801c98 <__udivdi3+0x8c>
  801c33:	89 fd                	mov    %edi,%ebp
  801c35:	85 ff                	test   %edi,%edi
  801c37:	75 0b                	jne    801c44 <__udivdi3+0x38>
  801c39:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3e:	31 d2                	xor    %edx,%edx
  801c40:	f7 f7                	div    %edi
  801c42:	89 c5                	mov    %eax,%ebp
  801c44:	31 d2                	xor    %edx,%edx
  801c46:	89 c8                	mov    %ecx,%eax
  801c48:	f7 f5                	div    %ebp
  801c4a:	89 c1                	mov    %eax,%ecx
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	f7 f5                	div    %ebp
  801c50:	89 cf                	mov    %ecx,%edi
  801c52:	89 fa                	mov    %edi,%edx
  801c54:	83 c4 1c             	add    $0x1c,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
  801c5c:	39 ce                	cmp    %ecx,%esi
  801c5e:	77 28                	ja     801c88 <__udivdi3+0x7c>
  801c60:	0f bd fe             	bsr    %esi,%edi
  801c63:	83 f7 1f             	xor    $0x1f,%edi
  801c66:	75 40                	jne    801ca8 <__udivdi3+0x9c>
  801c68:	39 ce                	cmp    %ecx,%esi
  801c6a:	72 0a                	jb     801c76 <__udivdi3+0x6a>
  801c6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c70:	0f 87 9e 00 00 00    	ja     801d14 <__udivdi3+0x108>
  801c76:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7b:	89 fa                	mov    %edi,%edx
  801c7d:	83 c4 1c             	add    $0x1c,%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5e                   	pop    %esi
  801c82:	5f                   	pop    %edi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    
  801c85:	8d 76 00             	lea    0x0(%esi),%esi
  801c88:	31 ff                	xor    %edi,%edi
  801c8a:	31 c0                	xor    %eax,%eax
  801c8c:	89 fa                	mov    %edi,%edx
  801c8e:	83 c4 1c             	add    $0x1c,%esp
  801c91:	5b                   	pop    %ebx
  801c92:	5e                   	pop    %esi
  801c93:	5f                   	pop    %edi
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	f7 f7                	div    %edi
  801c9c:	31 ff                	xor    %edi,%edi
  801c9e:	89 fa                	mov    %edi,%edx
  801ca0:	83 c4 1c             	add    $0x1c,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5e                   	pop    %esi
  801ca5:	5f                   	pop    %edi
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    
  801ca8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cad:	89 eb                	mov    %ebp,%ebx
  801caf:	29 fb                	sub    %edi,%ebx
  801cb1:	89 f9                	mov    %edi,%ecx
  801cb3:	d3 e6                	shl    %cl,%esi
  801cb5:	89 c5                	mov    %eax,%ebp
  801cb7:	88 d9                	mov    %bl,%cl
  801cb9:	d3 ed                	shr    %cl,%ebp
  801cbb:	89 e9                	mov    %ebp,%ecx
  801cbd:	09 f1                	or     %esi,%ecx
  801cbf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cc3:	89 f9                	mov    %edi,%ecx
  801cc5:	d3 e0                	shl    %cl,%eax
  801cc7:	89 c5                	mov    %eax,%ebp
  801cc9:	89 d6                	mov    %edx,%esi
  801ccb:	88 d9                	mov    %bl,%cl
  801ccd:	d3 ee                	shr    %cl,%esi
  801ccf:	89 f9                	mov    %edi,%ecx
  801cd1:	d3 e2                	shl    %cl,%edx
  801cd3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cd7:	88 d9                	mov    %bl,%cl
  801cd9:	d3 e8                	shr    %cl,%eax
  801cdb:	09 c2                	or     %eax,%edx
  801cdd:	89 d0                	mov    %edx,%eax
  801cdf:	89 f2                	mov    %esi,%edx
  801ce1:	f7 74 24 0c          	divl   0xc(%esp)
  801ce5:	89 d6                	mov    %edx,%esi
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	f7 e5                	mul    %ebp
  801ceb:	39 d6                	cmp    %edx,%esi
  801ced:	72 19                	jb     801d08 <__udivdi3+0xfc>
  801cef:	74 0b                	je     801cfc <__udivdi3+0xf0>
  801cf1:	89 d8                	mov    %ebx,%eax
  801cf3:	31 ff                	xor    %edi,%edi
  801cf5:	e9 58 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d00:	89 f9                	mov    %edi,%ecx
  801d02:	d3 e2                	shl    %cl,%edx
  801d04:	39 c2                	cmp    %eax,%edx
  801d06:	73 e9                	jae    801cf1 <__udivdi3+0xe5>
  801d08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d0b:	31 ff                	xor    %edi,%edi
  801d0d:	e9 40 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	31 c0                	xor    %eax,%eax
  801d16:	e9 37 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801d1b:	90                   	nop

00801d1c <__umoddi3>:
  801d1c:	55                   	push   %ebp
  801d1d:	57                   	push   %edi
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
  801d20:	83 ec 1c             	sub    $0x1c,%esp
  801d23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d3b:	89 f3                	mov    %esi,%ebx
  801d3d:	89 fa                	mov    %edi,%edx
  801d3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d43:	89 34 24             	mov    %esi,(%esp)
  801d46:	85 c0                	test   %eax,%eax
  801d48:	75 1a                	jne    801d64 <__umoddi3+0x48>
  801d4a:	39 f7                	cmp    %esi,%edi
  801d4c:	0f 86 a2 00 00 00    	jbe    801df4 <__umoddi3+0xd8>
  801d52:	89 c8                	mov    %ecx,%eax
  801d54:	89 f2                	mov    %esi,%edx
  801d56:	f7 f7                	div    %edi
  801d58:	89 d0                	mov    %edx,%eax
  801d5a:	31 d2                	xor    %edx,%edx
  801d5c:	83 c4 1c             	add    $0x1c,%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5f                   	pop    %edi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    
  801d64:	39 f0                	cmp    %esi,%eax
  801d66:	0f 87 ac 00 00 00    	ja     801e18 <__umoddi3+0xfc>
  801d6c:	0f bd e8             	bsr    %eax,%ebp
  801d6f:	83 f5 1f             	xor    $0x1f,%ebp
  801d72:	0f 84 ac 00 00 00    	je     801e24 <__umoddi3+0x108>
  801d78:	bf 20 00 00 00       	mov    $0x20,%edi
  801d7d:	29 ef                	sub    %ebp,%edi
  801d7f:	89 fe                	mov    %edi,%esi
  801d81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d85:	89 e9                	mov    %ebp,%ecx
  801d87:	d3 e0                	shl    %cl,%eax
  801d89:	89 d7                	mov    %edx,%edi
  801d8b:	89 f1                	mov    %esi,%ecx
  801d8d:	d3 ef                	shr    %cl,%edi
  801d8f:	09 c7                	or     %eax,%edi
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 e2                	shl    %cl,%edx
  801d95:	89 14 24             	mov    %edx,(%esp)
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	d3 e0                	shl    %cl,%eax
  801d9c:	89 c2                	mov    %eax,%edx
  801d9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da2:	d3 e0                	shl    %cl,%eax
  801da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dac:	89 f1                	mov    %esi,%ecx
  801dae:	d3 e8                	shr    %cl,%eax
  801db0:	09 d0                	or     %edx,%eax
  801db2:	d3 eb                	shr    %cl,%ebx
  801db4:	89 da                	mov    %ebx,%edx
  801db6:	f7 f7                	div    %edi
  801db8:	89 d3                	mov    %edx,%ebx
  801dba:	f7 24 24             	mull   (%esp)
  801dbd:	89 c6                	mov    %eax,%esi
  801dbf:	89 d1                	mov    %edx,%ecx
  801dc1:	39 d3                	cmp    %edx,%ebx
  801dc3:	0f 82 87 00 00 00    	jb     801e50 <__umoddi3+0x134>
  801dc9:	0f 84 91 00 00 00    	je     801e60 <__umoddi3+0x144>
  801dcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dd3:	29 f2                	sub    %esi,%edx
  801dd5:	19 cb                	sbb    %ecx,%ebx
  801dd7:	89 d8                	mov    %ebx,%eax
  801dd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ddd:	d3 e0                	shl    %cl,%eax
  801ddf:	89 e9                	mov    %ebp,%ecx
  801de1:	d3 ea                	shr    %cl,%edx
  801de3:	09 d0                	or     %edx,%eax
  801de5:	89 e9                	mov    %ebp,%ecx
  801de7:	d3 eb                	shr    %cl,%ebx
  801de9:	89 da                	mov    %ebx,%edx
  801deb:	83 c4 1c             	add    $0x1c,%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5f                   	pop    %edi
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    
  801df3:	90                   	nop
  801df4:	89 fd                	mov    %edi,%ebp
  801df6:	85 ff                	test   %edi,%edi
  801df8:	75 0b                	jne    801e05 <__umoddi3+0xe9>
  801dfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801dff:	31 d2                	xor    %edx,%edx
  801e01:	f7 f7                	div    %edi
  801e03:	89 c5                	mov    %eax,%ebp
  801e05:	89 f0                	mov    %esi,%eax
  801e07:	31 d2                	xor    %edx,%edx
  801e09:	f7 f5                	div    %ebp
  801e0b:	89 c8                	mov    %ecx,%eax
  801e0d:	f7 f5                	div    %ebp
  801e0f:	89 d0                	mov    %edx,%eax
  801e11:	e9 44 ff ff ff       	jmp    801d5a <__umoddi3+0x3e>
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	89 c8                	mov    %ecx,%eax
  801e1a:	89 f2                	mov    %esi,%edx
  801e1c:	83 c4 1c             	add    $0x1c,%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
  801e24:	3b 04 24             	cmp    (%esp),%eax
  801e27:	72 06                	jb     801e2f <__umoddi3+0x113>
  801e29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e2d:	77 0f                	ja     801e3e <__umoddi3+0x122>
  801e2f:	89 f2                	mov    %esi,%edx
  801e31:	29 f9                	sub    %edi,%ecx
  801e33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e37:	89 14 24             	mov    %edx,(%esp)
  801e3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e42:	8b 14 24             	mov    (%esp),%edx
  801e45:	83 c4 1c             	add    $0x1c,%esp
  801e48:	5b                   	pop    %ebx
  801e49:	5e                   	pop    %esi
  801e4a:	5f                   	pop    %edi
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    
  801e4d:	8d 76 00             	lea    0x0(%esi),%esi
  801e50:	2b 04 24             	sub    (%esp),%eax
  801e53:	19 fa                	sbb    %edi,%edx
  801e55:	89 d1                	mov    %edx,%ecx
  801e57:	89 c6                	mov    %eax,%esi
  801e59:	e9 71 ff ff ff       	jmp    801dcf <__umoddi3+0xb3>
  801e5e:	66 90                	xchg   %ax,%ax
  801e60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e64:	72 ea                	jb     801e50 <__umoddi3+0x134>
  801e66:	89 d9                	mov    %ebx,%ecx
  801e68:	e9 62 ff ff ff       	jmp    801dcf <__umoddi3+0xb3>
