
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
  800044:	e8 4d 17 00 00       	call   801796 <sys_calculate_free_frames>
  800049:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80004c:	e8 90 17 00 00       	call   8017e1 <sys_pf_calculate_allocated_pages>
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
  8000a8:	68 a0 1e 80 00       	push   $0x801ea0
  8000ad:	6a 03                	push   $0x3
  8000af:	e8 0b 07 00 00       	call   8007bf <cprintf_colored>
  8000b4:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000b7:	a1 00 30 80 00       	mov    0x803000,%eax
  8000bc:	8a 00                	mov    (%eax),%al
  8000be:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 b9 1e 80 00       	push   $0x801eb9
  8000cb:	6a 31                	push   $0x31
  8000cd:	68 c8 1e 80 00       	push   $0x801ec8
  8000d2:	e8 ed 03 00 00       	call   8004c4 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000d7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000dc:	8a 00                	mov    (%eax),%al
  8000de:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  8000e1:	74 14                	je     8000f7 <_main+0xbf>
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	68 b9 1e 80 00       	push   $0x801eb9
  8000eb:	6a 32                	push   $0x32
  8000ed:	68 c8 1e 80 00       	push   $0x801ec8
  8000f2:	e8 cd 03 00 00       	call   8004c4 <_panic>
		if(__arr__[PAGE_SIZE*10-1] != 'a') panic("test failed!");
  8000f7:	8a 85 cb df ff ff    	mov    -0x2035(%ebp),%al
  8000fd:	3c 61                	cmp    $0x61,%al
  8000ff:	74 14                	je     800115 <_main+0xdd>
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	68 b9 1e 80 00       	push   $0x801eb9
  800109:	6a 33                	push   $0x33
  80010b:	68 c8 1e 80 00       	push   $0x801ec8
  800110:	e8 af 03 00 00       	call   8004c4 <_panic>
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
  800132:	68 b9 1e 80 00       	push   $0x801eb9
  800137:	6a 36                	push   $0x36
  800139:	68 c8 1e 80 00       	push   $0x801ec8
  80013e:	e8 81 03 00 00       	call   8004c4 <_panic>
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
  800156:	68 f0 1e 80 00       	push   $0x801ef0
  80015b:	6a 03                	push   $0x3
  80015d:	e8 5d 06 00 00       	call   8007bf <cprintf_colored>
  800162:	83 c4 10             	add    $0x10,%esp
	{
		char separator[2] = "@";
  800165:	66 c7 85 c6 3f ff ff 	movw   $0x40,-0xc03a(%ebp)
  80016c:	40 00 
		char checkRefStreamCmd[100] = "__CheckRefStream@";
  80016e:	8d 85 ea 3e ff ff    	lea    -0xc116(%ebp),%eax
  800174:	bb 71 20 80 00       	mov    $0x802071,%ebx
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
  8001a3:	e8 18 12 00 00       	call   8013c0 <ltostr>
  8001a8:	83 c4 10             	add    $0x10,%esp
		strcconcat(checkRefStreamCmd, token, cmdWithCnt);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	8d 85 ea 3e ff ff    	lea    -0xc116(%ebp),%eax
  8001c2:	50                   	push   %eax
  8001c3:	e8 d1 12 00 00       	call   801499 <strcconcat>
  8001c8:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	8d 85 c6 3f ff ff    	lea    -0xc03a(%ebp),%eax
  8001db:	50                   	push   %eax
  8001dc:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 b1 12 00 00       	call   801499 <strcconcat>
  8001e8:	83 c4 10             	add    $0x10,%esp
		ltostr((uint32)&expectedRefStream, token);
  8001eb:	ba 20 30 80 00       	mov    $0x803020,%edx
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	52                   	push   %edx
  8001fb:	e8 c0 11 00 00       	call   8013c0 <ltostr>
  800200:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, token, cmdWithCnt);
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  800213:	50                   	push   %eax
  800214:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80021a:	50                   	push   %eax
  80021b:	e8 79 12 00 00       	call   801499 <strcconcat>
  800220:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80022c:	50                   	push   %eax
  80022d:	8d 85 c6 3f ff ff    	lea    -0xc03a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80023a:	50                   	push   %eax
  80023b:	e8 59 12 00 00       	call   801499 <strcconcat>
  800240:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("%~Ref Command = %s\n", cmdWithCnt);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80024c:	50                   	push   %eax
  80024d:	68 1b 1f 80 00       	push   $0x801f1b
  800252:	e8 ad 05 00 00       	call   800804 <atomic_cprintf>
  800257:	83 c4 10             	add    $0x10,%esp

		sys_utilities(cmdWithCnt, (uint32)&found);
  80025a:	8d 85 c8 3f ff ff    	lea    -0xc038(%ebp),%eax
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	50                   	push   %eax
  800264:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80026a:	50                   	push   %eax
  80026b:	e8 25 19 00 00       	call   801b95 <sys_utilities>
  800270:	83 c4 10             	add    $0x10,%esp

		//if (found != 1) panic("OPTIMAL alg. failed.. unexpected page reference stream!");
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	68 30 1f 80 00       	push   $0x801f30
  80027b:	6a 03                	push   $0x3
  80027d:	e8 3d 05 00 00       	call   8007bf <cprintf_colored>
  800282:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800285:	e8 57 15 00 00       	call   8017e1 <sys_pf_calculate_allocated_pages>
  80028a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80028d:	74 14                	je     8002a3 <_main+0x26b>
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 60 1f 80 00       	push   $0x801f60
  800297:	6a 4e                	push   $0x4e
  800299:	68 c8 1e 80 00       	push   $0x801ec8
  80029e:	e8 21 02 00 00       	call   8004c4 <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8002a3:	e8 ee 14 00 00       	call   801796 <sys_calculate_free_frames>
  8002a8:	89 c3                	mov    %eax,%ebx
  8002aa:	e8 00 15 00 00       	call   8017af <sys_calculate_modified_frames>
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
  8002d3:	68 cc 1f 80 00       	push   $0x801fcc
  8002d8:	6a 53                	push   $0x53
  8002da:	68 c8 1e 80 00       	push   $0x801ec8
  8002df:	e8 e0 01 00 00       	call   8004c4 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #2 [OPTIMAL Alg.] is completed successfully.\n");
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	68 18 20 80 00       	push   $0x802018
  8002ec:	6a 0a                	push   $0xa
  8002ee:	e8 cc 04 00 00       	call   8007bf <cprintf_colored>
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
  800308:	e8 52 16 00 00       	call   80195f <sys_getenvindex>
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800310:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800313:	89 d0                	mov    %edx,%eax
  800315:	c1 e0 06             	shl    $0x6,%eax
  800318:	29 d0                	sub    %edx,%eax
  80031a:	c1 e0 02             	shl    $0x2,%eax
  80031d:	01 d0                	add    %edx,%eax
  80031f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800326:	01 c8                	add    %ecx,%eax
  800328:	c1 e0 03             	shl    $0x3,%eax
  80032b:	01 d0                	add    %edx,%eax
  80032d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800334:	29 c2                	sub    %eax,%edx
  800336:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80033d:	89 c2                	mov    %eax,%edx
  80033f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800345:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80034a:	a1 60 30 80 00       	mov    0x803060,%eax
  80034f:	8a 40 20             	mov    0x20(%eax),%al
  800352:	84 c0                	test   %al,%al
  800354:	74 0d                	je     800363 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800356:	a1 60 30 80 00       	mov    0x803060,%eax
  80035b:	83 c0 20             	add    $0x20,%eax
  80035e:	a3 54 30 80 00       	mov    %eax,0x803054

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800367:	7e 0a                	jle    800373 <libmain+0x74>
		binaryname = argv[0];
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	8b 00                	mov    (%eax),%eax
  80036e:	a3 54 30 80 00       	mov    %eax,0x803054

	// call user main routine
	_main(argc, argv);
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 b7 fc ff ff       	call   800038 <_main>
  800381:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800384:	a1 50 30 80 00       	mov    0x803050,%eax
  800389:	85 c0                	test   %eax,%eax
  80038b:	0f 84 01 01 00 00    	je     800492 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800391:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800397:	bb d0 21 80 00       	mov    $0x8021d0,%ebx
  80039c:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	89 de                	mov    %ebx,%esi
  8003a5:	89 d1                	mov    %edx,%ecx
  8003a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003a9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003ac:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003b1:	b0 00                	mov    $0x0,%al
  8003b3:	89 d7                	mov    %edx,%edi
  8003b5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	50                   	push   %eax
  8003c5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003cb:	50                   	push   %eax
  8003cc:	e8 c4 17 00 00       	call   801b95 <sys_utilities>
  8003d1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003d4:	e8 0d 13 00 00       	call   8016e6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	68 f0 20 80 00       	push   $0x8020f0
  8003e1:	e8 ac 03 00 00       	call   800792 <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ec:	85 c0                	test   %eax,%eax
  8003ee:	74 18                	je     800408 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003f0:	e8 be 17 00 00       	call   801bb3 <sys_get_optimal_num_faults>
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	50                   	push   %eax
  8003f9:	68 18 21 80 00       	push   $0x802118
  8003fe:	e8 8f 03 00 00       	call   800792 <cprintf>
  800403:	83 c4 10             	add    $0x10,%esp
  800406:	eb 59                	jmp    800461 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800408:	a1 60 30 80 00       	mov    0x803060,%eax
  80040d:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800413:	a1 60 30 80 00       	mov    0x803060,%eax
  800418:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	52                   	push   %edx
  800422:	50                   	push   %eax
  800423:	68 3c 21 80 00       	push   $0x80213c
  800428:	e8 65 03 00 00       	call   800792 <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800430:	a1 60 30 80 00       	mov    0x803060,%eax
  800435:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80043b:	a1 60 30 80 00       	mov    0x803060,%eax
  800440:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800446:	a1 60 30 80 00       	mov    0x803060,%eax
  80044b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800451:	51                   	push   %ecx
  800452:	52                   	push   %edx
  800453:	50                   	push   %eax
  800454:	68 64 21 80 00       	push   $0x802164
  800459:	e8 34 03 00 00       	call   800792 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800461:	a1 60 30 80 00       	mov    0x803060,%eax
  800466:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	50                   	push   %eax
  800470:	68 bc 21 80 00       	push   $0x8021bc
  800475:	e8 18 03 00 00       	call   800792 <cprintf>
  80047a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80047d:	83 ec 0c             	sub    $0xc,%esp
  800480:	68 f0 20 80 00       	push   $0x8020f0
  800485:	e8 08 03 00 00       	call   800792 <cprintf>
  80048a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80048d:	e8 6e 12 00 00       	call   801700 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800492:	e8 1f 00 00 00       	call   8004b6 <exit>
}
  800497:	90                   	nop
  800498:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80049b:	5b                   	pop    %ebx
  80049c:	5e                   	pop    %esi
  80049d:	5f                   	pop    %edi
  80049e:	5d                   	pop    %ebp
  80049f:	c3                   	ret    

008004a0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	6a 00                	push   $0x0
  8004ab:	e8 7b 14 00 00       	call   80192b <sys_destroy_env>
  8004b0:	83 c4 10             	add    $0x10,%esp
}
  8004b3:	90                   	nop
  8004b4:	c9                   	leave  
  8004b5:	c3                   	ret    

008004b6 <exit>:

void
exit(void)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004bc:	e8 d0 14 00 00       	call   801991 <sys_exit_env>
}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8004cd:	83 c0 04             	add    $0x4,%eax
  8004d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004d3:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8004d8:	85 c0                	test   %eax,%eax
  8004da:	74 16                	je     8004f2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004dc:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	50                   	push   %eax
  8004e5:	68 34 22 80 00       	push   $0x802234
  8004ea:	e8 a3 02 00 00       	call   800792 <cprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004f2:	a1 54 30 80 00       	mov    0x803054,%eax
  8004f7:	83 ec 0c             	sub    $0xc,%esp
  8004fa:	ff 75 0c             	pushl  0xc(%ebp)
  8004fd:	ff 75 08             	pushl  0x8(%ebp)
  800500:	50                   	push   %eax
  800501:	68 3c 22 80 00       	push   $0x80223c
  800506:	6a 74                	push   $0x74
  800508:	e8 b2 02 00 00       	call   8007bf <cprintf_colored>
  80050d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800510:	8b 45 10             	mov    0x10(%ebp),%eax
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	ff 75 f4             	pushl  -0xc(%ebp)
  800519:	50                   	push   %eax
  80051a:	e8 04 02 00 00       	call   800723 <vcprintf>
  80051f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	6a 00                	push   $0x0
  800527:	68 64 22 80 00       	push   $0x802264
  80052c:	e8 f2 01 00 00       	call   800723 <vcprintf>
  800531:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800534:	e8 7d ff ff ff       	call   8004b6 <exit>

	// should not return here
	while (1) ;
  800539:	eb fe                	jmp    800539 <_panic+0x75>

0080053b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
  80053e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800541:	a1 60 30 80 00       	mov    0x803060,%eax
  800546:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	74 14                	je     800567 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	68 68 22 80 00       	push   $0x802268
  80055b:	6a 26                	push   $0x26
  80055d:	68 b4 22 80 00       	push   $0x8022b4
  800562:	e8 5d ff ff ff       	call   8004c4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800567:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80056e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800575:	e9 c5 00 00 00       	jmp    80063f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	85 c0                	test   %eax,%eax
  80058d:	75 08                	jne    800597 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80058f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800592:	e9 a5 00 00 00       	jmp    80063c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800597:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80059e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a5:	eb 69                	jmp    800610 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005a7:	a1 60 30 80 00       	mov    0x803060,%eax
  8005ac:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b5:	89 d0                	mov    %edx,%eax
  8005b7:	01 c0                	add    %eax,%eax
  8005b9:	01 d0                	add    %edx,%eax
  8005bb:	c1 e0 03             	shl    $0x3,%eax
  8005be:	01 c8                	add    %ecx,%eax
  8005c0:	8a 40 04             	mov    0x4(%eax),%al
  8005c3:	84 c0                	test   %al,%al
  8005c5:	75 46                	jne    80060d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c7:	a1 60 30 80 00       	mov    0x803060,%eax
  8005cc:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	01 c0                	add    %eax,%eax
  8005d9:	01 d0                	add    %edx,%eax
  8005db:	c1 e0 03             	shl    $0x3,%eax
  8005de:	01 c8                	add    %ecx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ed:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	01 c8                	add    %ecx,%eax
  8005fe:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800600:	39 c2                	cmp    %eax,%edx
  800602:	75 09                	jne    80060d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800604:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80060b:	eb 15                	jmp    800622 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060d:	ff 45 e8             	incl   -0x18(%ebp)
  800610:	a1 60 30 80 00       	mov    0x803060,%eax
  800615:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80061b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80061e:	39 c2                	cmp    %eax,%edx
  800620:	77 85                	ja     8005a7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800622:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800626:	75 14                	jne    80063c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800628:	83 ec 04             	sub    $0x4,%esp
  80062b:	68 c0 22 80 00       	push   $0x8022c0
  800630:	6a 3a                	push   $0x3a
  800632:	68 b4 22 80 00       	push   $0x8022b4
  800637:	e8 88 fe ff ff       	call   8004c4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80063c:	ff 45 f0             	incl   -0x10(%ebp)
  80063f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800642:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800645:	0f 8c 2f ff ff ff    	jl     80057a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80064b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800652:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800659:	eb 26                	jmp    800681 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80065b:	a1 60 30 80 00       	mov    0x803060,%eax
  800660:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800666:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	01 c0                	add    %eax,%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	c1 e0 03             	shl    $0x3,%eax
  800672:	01 c8                	add    %ecx,%eax
  800674:	8a 40 04             	mov    0x4(%eax),%al
  800677:	3c 01                	cmp    $0x1,%al
  800679:	75 03                	jne    80067e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80067b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80067e:	ff 45 e0             	incl   -0x20(%ebp)
  800681:	a1 60 30 80 00       	mov    0x803060,%eax
  800686:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80068c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068f:	39 c2                	cmp    %eax,%edx
  800691:	77 c8                	ja     80065b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800696:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800699:	74 14                	je     8006af <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80069b:	83 ec 04             	sub    $0x4,%esp
  80069e:	68 14 23 80 00       	push   $0x802314
  8006a3:	6a 44                	push   $0x44
  8006a5:	68 b4 22 80 00       	push   $0x8022b4
  8006aa:	e8 15 fe ff ff       	call   8004c4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006af:	90                   	nop
  8006b0:	c9                   	leave  
  8006b1:	c3                   	ret    

008006b2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
  8006b5:	53                   	push   %ebx
  8006b6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c4:	89 0a                	mov    %ecx,(%edx)
  8006c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c9:	88 d1                	mov    %dl,%cl
  8006cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ce:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006dc:	75 30                	jne    80070e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006de:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  8006e4:	a0 84 30 80 00       	mov    0x803084,%al
  8006e9:	0f b6 c0             	movzbl %al,%eax
  8006ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ef:	8b 09                	mov    (%ecx),%ecx
  8006f1:	89 cb                	mov    %ecx,%ebx
  8006f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006f6:	83 c1 08             	add    $0x8,%ecx
  8006f9:	52                   	push   %edx
  8006fa:	50                   	push   %eax
  8006fb:	53                   	push   %ebx
  8006fc:	51                   	push   %ecx
  8006fd:	e8 a0 0f 00 00       	call   8016a2 <sys_cputs>
  800702:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800705:	8b 45 0c             	mov    0xc(%ebp),%eax
  800708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800711:	8b 40 04             	mov    0x4(%eax),%eax
  800714:	8d 50 01             	lea    0x1(%eax),%edx
  800717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071d:	90                   	nop
  80071e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800721:	c9                   	leave  
  800722:	c3                   	ret    

00800723 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80072c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800733:	00 00 00 
	b.cnt = 0;
  800736:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80073d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	ff 75 08             	pushl  0x8(%ebp)
  800746:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	68 b2 06 80 00       	push   $0x8006b2
  800752:	e8 5a 02 00 00       	call   8009b1 <vprintfmt>
  800757:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80075a:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  800760:	a0 84 30 80 00       	mov    0x803084,%al
  800765:	0f b6 c0             	movzbl %al,%eax
  800768:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	51                   	push   %ecx
  800771:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800777:	83 c0 08             	add    $0x8,%eax
  80077a:	50                   	push   %eax
  80077b:	e8 22 0f 00 00       	call   8016a2 <sys_cputs>
  800780:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800783:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  80078a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800798:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  80079f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ae:	50                   	push   %eax
  8007af:	e8 6f ff ff ff       	call   800723 <vcprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007bd:	c9                   	leave  
  8007be:	c3                   	ret    

008007bf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007c5:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	c1 e0 08             	shl    $0x8,%eax
  8007d2:	a3 5c b1 81 00       	mov    %eax,0x81b15c
	va_start(ap, fmt);
  8007d7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007da:	83 c0 04             	add    $0x4,%eax
  8007dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	e8 34 ff ff ff       	call   800723 <vcprintf>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007f5:	c7 05 5c b1 81 00 00 	movl   $0x700,0x81b15c
  8007fc:	07 00 00 

	return cnt;
  8007ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800802:	c9                   	leave  
  800803:	c3                   	ret    

00800804 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80080a:	e8 d7 0e 00 00       	call   8016e6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80080f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800812:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 f4             	pushl  -0xc(%ebp)
  80081e:	50                   	push   %eax
  80081f:	e8 ff fe ff ff       	call   800723 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80082a:	e8 d1 0e 00 00       	call   801700 <sys_unlock_cons>
	return cnt;
  80082f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	53                   	push   %ebx
  800838:	83 ec 14             	sub    $0x14,%esp
  80083b:	8b 45 10             	mov    0x10(%ebp),%eax
  80083e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800847:	8b 45 18             	mov    0x18(%ebp),%eax
  80084a:	ba 00 00 00 00       	mov    $0x0,%edx
  80084f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800852:	77 55                	ja     8008a9 <printnum+0x75>
  800854:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800857:	72 05                	jb     80085e <printnum+0x2a>
  800859:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80085c:	77 4b                	ja     8008a9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80085e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800861:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800864:	8b 45 18             	mov    0x18(%ebp),%eax
  800867:	ba 00 00 00 00       	mov    $0x0,%edx
  80086c:	52                   	push   %edx
  80086d:	50                   	push   %eax
  80086e:	ff 75 f4             	pushl  -0xc(%ebp)
  800871:	ff 75 f0             	pushl  -0x10(%ebp)
  800874:	e8 ab 13 00 00       	call   801c24 <__udivdi3>
  800879:	83 c4 10             	add    $0x10,%esp
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	ff 75 20             	pushl  0x20(%ebp)
  800882:	53                   	push   %ebx
  800883:	ff 75 18             	pushl  0x18(%ebp)
  800886:	52                   	push   %edx
  800887:	50                   	push   %eax
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	ff 75 08             	pushl  0x8(%ebp)
  80088e:	e8 a1 ff ff ff       	call   800834 <printnum>
  800893:	83 c4 20             	add    $0x20,%esp
  800896:	eb 1a                	jmp    8008b2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	ff 75 20             	pushl  0x20(%ebp)
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	ff d0                	call   *%eax
  8008a6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a9:	ff 4d 1c             	decl   0x1c(%ebp)
  8008ac:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008b0:	7f e6                	jg     800898 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c0:	53                   	push   %ebx
  8008c1:	51                   	push   %ecx
  8008c2:	52                   	push   %edx
  8008c3:	50                   	push   %eax
  8008c4:	e8 6b 14 00 00       	call   801d34 <__umoddi3>
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	05 74 25 80 00       	add    $0x802574,%eax
  8008d1:	8a 00                	mov    (%eax),%al
  8008d3:	0f be c0             	movsbl %al,%eax
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	50                   	push   %eax
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	ff d0                	call   *%eax
  8008e2:	83 c4 10             	add    $0x10,%esp
}
  8008e5:	90                   	nop
  8008e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e9:	c9                   	leave  
  8008ea:	c3                   	ret    

008008eb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f2:	7e 1c                	jle    800910 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	8d 50 08             	lea    0x8(%eax),%edx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	89 10                	mov    %edx,(%eax)
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	83 e8 08             	sub    $0x8,%eax
  800909:	8b 50 04             	mov    0x4(%eax),%edx
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	eb 40                	jmp    800950 <getuint+0x65>
	else if (lflag)
  800910:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800914:	74 1e                	je     800934 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	8d 50 04             	lea    0x4(%eax),%edx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	89 10                	mov    %edx,(%eax)
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	83 e8 04             	sub    $0x4,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	ba 00 00 00 00       	mov    $0x0,%edx
  800932:	eb 1c                	jmp    800950 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 04             	lea    0x4(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 04             	sub    $0x4,%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800955:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800959:	7e 1c                	jle    800977 <getint+0x25>
		return va_arg(*ap, long long);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 08             	lea    0x8(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 08             	sub    $0x8,%eax
  800970:	8b 50 04             	mov    0x4(%eax),%edx
  800973:	8b 00                	mov    (%eax),%eax
  800975:	eb 38                	jmp    8009af <getint+0x5d>
	else if (lflag)
  800977:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097b:	74 1a                	je     800997 <getint+0x45>
		return va_arg(*ap, long);
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	8d 50 04             	lea    0x4(%eax),%edx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	89 10                	mov    %edx,(%eax)
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	83 e8 04             	sub    $0x4,%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	99                   	cltd   
  800995:	eb 18                	jmp    8009af <getint+0x5d>
	else
		return va_arg(*ap, int);
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	8d 50 04             	lea    0x4(%eax),%edx
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	89 10                	mov    %edx,(%eax)
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 e8 04             	sub    $0x4,%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	99                   	cltd   
}
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b9:	eb 17                	jmp    8009d2 <vprintfmt+0x21>
			if (ch == '\0')
  8009bb:	85 db                	test   %ebx,%ebx
  8009bd:	0f 84 c1 03 00 00    	je     800d84 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	53                   	push   %ebx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d5:	8d 50 01             	lea    0x1(%eax),%edx
  8009d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8009db:	8a 00                	mov    (%eax),%al
  8009dd:	0f b6 d8             	movzbl %al,%ebx
  8009e0:	83 fb 25             	cmp    $0x25,%ebx
  8009e3:	75 d6                	jne    8009bb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009e9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009fe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a05:	8b 45 10             	mov    0x10(%ebp),%eax
  800a08:	8d 50 01             	lea    0x1(%eax),%edx
  800a0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	0f b6 d8             	movzbl %al,%ebx
  800a13:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a16:	83 f8 5b             	cmp    $0x5b,%eax
  800a19:	0f 87 3d 03 00 00    	ja     800d5c <vprintfmt+0x3ab>
  800a1f:	8b 04 85 98 25 80 00 	mov    0x802598(,%eax,4),%eax
  800a26:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a28:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a2c:	eb d7                	jmp    800a05 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a2e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a32:	eb d1                	jmp    800a05 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a34:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a3e:	89 d0                	mov    %edx,%eax
  800a40:	c1 e0 02             	shl    $0x2,%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	01 c0                	add    %eax,%eax
  800a47:	01 d8                	add    %ebx,%eax
  800a49:	83 e8 30             	sub    $0x30,%eax
  800a4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a52:	8a 00                	mov    (%eax),%al
  800a54:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a57:	83 fb 2f             	cmp    $0x2f,%ebx
  800a5a:	7e 3e                	jle    800a9a <vprintfmt+0xe9>
  800a5c:	83 fb 39             	cmp    $0x39,%ebx
  800a5f:	7f 39                	jg     800a9a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a61:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a64:	eb d5                	jmp    800a3b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	83 c0 04             	add    $0x4,%eax
  800a6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	83 e8 04             	sub    $0x4,%eax
  800a75:	8b 00                	mov    (%eax),%eax
  800a77:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a7a:	eb 1f                	jmp    800a9b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a80:	79 83                	jns    800a05 <vprintfmt+0x54>
				width = 0;
  800a82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a89:	e9 77 ff ff ff       	jmp    800a05 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a8e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a95:	e9 6b ff ff ff       	jmp    800a05 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a9a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9f:	0f 89 60 ff ff ff    	jns    800a05 <vprintfmt+0x54>
				width = precision, precision = -1;
  800aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ab2:	e9 4e ff ff ff       	jmp    800a05 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ab7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aba:	e9 46 ff ff ff       	jmp    800a05 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	83 c0 04             	add    $0x4,%eax
  800ac5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  800acb:	83 e8 04             	sub    $0x4,%eax
  800ace:	8b 00                	mov    (%eax),%eax
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	50                   	push   %eax
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
			break;
  800adf:	e9 9b 02 00 00       	jmp    800d7f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 c0 04             	add    $0x4,%eax
  800aea:	89 45 14             	mov    %eax,0x14(%ebp)
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	83 e8 04             	sub    $0x4,%eax
  800af3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800af5:	85 db                	test   %ebx,%ebx
  800af7:	79 02                	jns    800afb <vprintfmt+0x14a>
				err = -err;
  800af9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800afb:	83 fb 64             	cmp    $0x64,%ebx
  800afe:	7f 0b                	jg     800b0b <vprintfmt+0x15a>
  800b00:	8b 34 9d e0 23 80 00 	mov    0x8023e0(,%ebx,4),%esi
  800b07:	85 f6                	test   %esi,%esi
  800b09:	75 19                	jne    800b24 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b0b:	53                   	push   %ebx
  800b0c:	68 85 25 80 00       	push   $0x802585
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	ff 75 08             	pushl  0x8(%ebp)
  800b17:	e8 70 02 00 00       	call   800d8c <printfmt>
  800b1c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b1f:	e9 5b 02 00 00       	jmp    800d7f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b24:	56                   	push   %esi
  800b25:	68 8e 25 80 00       	push   $0x80258e
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 57 02 00 00       	call   800d8c <printfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
			break;
  800b38:	e9 42 02 00 00       	jmp    800d7f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	83 c0 04             	add    $0x4,%eax
  800b43:	89 45 14             	mov    %eax,0x14(%ebp)
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 30                	mov    (%eax),%esi
  800b4e:	85 f6                	test   %esi,%esi
  800b50:	75 05                	jne    800b57 <vprintfmt+0x1a6>
				p = "(null)";
  800b52:	be 91 25 80 00       	mov    $0x802591,%esi
			if (width > 0 && padc != '-')
  800b57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5b:	7e 6d                	jle    800bca <vprintfmt+0x219>
  800b5d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b61:	74 67                	je     800bca <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	50                   	push   %eax
  800b6a:	56                   	push   %esi
  800b6b:	e8 1e 03 00 00       	call   800e8e <strnlen>
  800b70:	83 c4 10             	add    $0x10,%esp
  800b73:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b76:	eb 16                	jmp    800b8e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b78:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	50                   	push   %eax
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	ff d0                	call   *%eax
  800b88:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b92:	7f e4                	jg     800b78 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b94:	eb 34                	jmp    800bca <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b96:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b9a:	74 1c                	je     800bb8 <vprintfmt+0x207>
  800b9c:	83 fb 1f             	cmp    $0x1f,%ebx
  800b9f:	7e 05                	jle    800ba6 <vprintfmt+0x1f5>
  800ba1:	83 fb 7e             	cmp    $0x7e,%ebx
  800ba4:	7e 12                	jle    800bb8 <vprintfmt+0x207>
					putch('?', putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	6a 3f                	push   $0x3f
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	eb 0f                	jmp    800bc7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	53                   	push   %ebx
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc7:	ff 4d e4             	decl   -0x1c(%ebp)
  800bca:	89 f0                	mov    %esi,%eax
  800bcc:	8d 70 01             	lea    0x1(%eax),%esi
  800bcf:	8a 00                	mov    (%eax),%al
  800bd1:	0f be d8             	movsbl %al,%ebx
  800bd4:	85 db                	test   %ebx,%ebx
  800bd6:	74 24                	je     800bfc <vprintfmt+0x24b>
  800bd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bdc:	78 b8                	js     800b96 <vprintfmt+0x1e5>
  800bde:	ff 4d e0             	decl   -0x20(%ebp)
  800be1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be5:	79 af                	jns    800b96 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be7:	eb 13                	jmp    800bfc <vprintfmt+0x24b>
				putch(' ', putdat);
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 0c             	pushl  0xc(%ebp)
  800bef:	6a 20                	push   $0x20
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	ff d0                	call   *%eax
  800bf6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c00:	7f e7                	jg     800be9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c02:	e9 78 01 00 00       	jmp    800d7f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c10:	50                   	push   %eax
  800c11:	e8 3c fd ff ff       	call   800952 <getint>
  800c16:	83 c4 10             	add    $0x10,%esp
  800c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c25:	85 d2                	test   %edx,%edx
  800c27:	79 23                	jns    800c4c <vprintfmt+0x29b>
				putch('-', putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	6a 2d                	push   $0x2d
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3f:	f7 d8                	neg    %eax
  800c41:	83 d2 00             	adc    $0x0,%edx
  800c44:	f7 da                	neg    %edx
  800c46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c4c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c53:	e9 bc 00 00 00       	jmp    800d14 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800c61:	50                   	push   %eax
  800c62:	e8 84 fc ff ff       	call   8008eb <getuint>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c77:	e9 98 00 00 00       	jmp    800d14 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	6a 58                	push   $0x58
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	ff d0                	call   *%eax
  800c89:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	6a 58                	push   $0x58
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	ff d0                	call   *%eax
  800c99:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	6a 58                	push   $0x58
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	ff d0                	call   *%eax
  800ca9:	83 c4 10             	add    $0x10,%esp
			break;
  800cac:	e9 ce 00 00 00       	jmp    800d7f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	6a 30                	push   $0x30
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	ff d0                	call   *%eax
  800cbe:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	6a 78                	push   $0x78
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	ff d0                	call   *%eax
  800cce:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd4:	83 c0 04             	add    $0x4,%eax
  800cd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	83 e8 04             	sub    $0x4,%eax
  800ce0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cf3:	eb 1f                	jmp    800d14 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 e8             	pushl  -0x18(%ebp)
  800cfb:	8d 45 14             	lea    0x14(%ebp),%eax
  800cfe:	50                   	push   %eax
  800cff:	e8 e7 fb ff ff       	call   8008eb <getuint>
  800d04:	83 c4 10             	add    $0x10,%esp
  800d07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d0d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d14:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1b:	83 ec 04             	sub    $0x4,%esp
  800d1e:	52                   	push   %edx
  800d1f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d22:	50                   	push   %eax
  800d23:	ff 75 f4             	pushl  -0xc(%ebp)
  800d26:	ff 75 f0             	pushl  -0x10(%ebp)
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	ff 75 08             	pushl  0x8(%ebp)
  800d2f:	e8 00 fb ff ff       	call   800834 <printnum>
  800d34:	83 c4 20             	add    $0x20,%esp
			break;
  800d37:	eb 46                	jmp    800d7f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d39:	83 ec 08             	sub    $0x8,%esp
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	53                   	push   %ebx
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	ff d0                	call   *%eax
  800d45:	83 c4 10             	add    $0x10,%esp
			break;
  800d48:	eb 35                	jmp    800d7f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d4a:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  800d51:	eb 2c                	jmp    800d7f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d53:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  800d5a:	eb 23                	jmp    800d7f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d5c:	83 ec 08             	sub    $0x8,%esp
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	6a 25                	push   $0x25
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	ff d0                	call   *%eax
  800d69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d6c:	ff 4d 10             	decl   0x10(%ebp)
  800d6f:	eb 03                	jmp    800d74 <vprintfmt+0x3c3>
  800d71:	ff 4d 10             	decl   0x10(%ebp)
  800d74:	8b 45 10             	mov    0x10(%ebp),%eax
  800d77:	48                   	dec    %eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	3c 25                	cmp    $0x25,%al
  800d7c:	75 f3                	jne    800d71 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d7e:	90                   	nop
		}
	}
  800d7f:	e9 35 fc ff ff       	jmp    8009b9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d92:	8d 45 10             	lea    0x10(%ebp),%eax
  800d95:	83 c0 04             	add    $0x4,%eax
  800d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800da1:	50                   	push   %eax
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 04 fc ff ff       	call   8009b1 <vprintfmt>
  800dad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800db0:	90                   	nop
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	8b 40 08             	mov    0x8(%eax),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8b 10                	mov    (%eax),%edx
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	8b 40 04             	mov    0x4(%eax),%eax
  800dd0:	39 c2                	cmp    %eax,%edx
  800dd2:	73 12                	jae    800de6 <sprintputch+0x33>
		*b->buf++ = ch;
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8b 00                	mov    (%eax),%eax
  800dd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800ddc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddf:	89 0a                	mov    %ecx,(%edx)
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	88 10                	mov    %dl,(%eax)
}
  800de6:	90                   	nop
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	01 d0                	add    %edx,%eax
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0e:	74 06                	je     800e16 <vsnprintf+0x2d>
  800e10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e14:	7f 07                	jg     800e1d <vsnprintf+0x34>
		return -E_INVAL;
  800e16:	b8 03 00 00 00       	mov    $0x3,%eax
  800e1b:	eb 20                	jmp    800e3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e1d:	ff 75 14             	pushl  0x14(%ebp)
  800e20:	ff 75 10             	pushl  0x10(%ebp)
  800e23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e26:	50                   	push   %eax
  800e27:	68 b3 0d 80 00       	push   $0x800db3
  800e2c:	e8 80 fb ff ff       	call   8009b1 <vprintfmt>
  800e31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e45:	8d 45 10             	lea    0x10(%ebp),%eax
  800e48:	83 c0 04             	add    $0x4,%eax
  800e4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	ff 75 f4             	pushl  -0xc(%ebp)
  800e54:	50                   	push   %eax
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	ff 75 08             	pushl  0x8(%ebp)
  800e5b:	e8 89 ff ff ff       	call   800de9 <vsnprintf>
  800e60:	83 c4 10             	add    $0x10,%esp
  800e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e69:	c9                   	leave  
  800e6a:	c3                   	ret    

00800e6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e78:	eb 06                	jmp    800e80 <strlen+0x15>
		n++;
  800e7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7d:	ff 45 08             	incl   0x8(%ebp)
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	84 c0                	test   %al,%al
  800e87:	75 f1                	jne    800e7a <strlen+0xf>
		n++;
	return n;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9b:	eb 09                	jmp    800ea6 <strnlen+0x18>
		n++;
  800e9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	ff 4d 0c             	decl   0xc(%ebp)
  800ea6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eaa:	74 09                	je     800eb5 <strnlen+0x27>
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	84 c0                	test   %al,%al
  800eb3:	75 e8                	jne    800e9d <strnlen+0xf>
		n++;
	return n;
  800eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb8:	c9                   	leave  
  800eb9:	c3                   	ret    

00800eba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ec6:	90                   	nop
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8d 50 01             	lea    0x1(%eax),%edx
  800ecd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed9:	8a 12                	mov    (%edx),%dl
  800edb:	88 10                	mov    %dl,(%eax)
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 e4                	jne    800ec7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ef4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800efb:	eb 1f                	jmp    800f1c <strncpy+0x34>
		*dst++ = *src;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8d 50 01             	lea    0x1(%eax),%edx
  800f03:	89 55 08             	mov    %edx,0x8(%ebp)
  800f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f09:	8a 12                	mov    (%edx),%dl
  800f0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	84 c0                	test   %al,%al
  800f14:	74 03                	je     800f19 <strncpy+0x31>
			src++;
  800f16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f19:	ff 45 fc             	incl   -0x4(%ebp)
  800f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f22:	72 d9                	jb     800efd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f39:	74 30                	je     800f6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f3b:	eb 16                	jmp    800f53 <strlcpy+0x2a>
			*dst++ = *src++;
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8d 50 01             	lea    0x1(%eax),%edx
  800f43:	89 55 08             	mov    %edx,0x8(%ebp)
  800f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f4f:	8a 12                	mov    (%edx),%dl
  800f51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f53:	ff 4d 10             	decl   0x10(%ebp)
  800f56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5a:	74 09                	je     800f65 <strlcpy+0x3c>
  800f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	84 c0                	test   %al,%al
  800f63:	75 d8                	jne    800f3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f71:	29 c2                	sub    %eax,%edx
  800f73:	89 d0                	mov    %edx,%eax
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f7a:	eb 06                	jmp    800f82 <strcmp+0xb>
		p++, q++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	84 c0                	test   %al,%al
  800f89:	74 0e                	je     800f99 <strcmp+0x22>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 10                	mov    (%eax),%dl
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	38 c2                	cmp    %al,%dl
  800f97:	74 e3                	je     800f7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f b6 d0             	movzbl %al,%edx
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	0f b6 c0             	movzbl %al,%eax
  800fa9:	29 c2                	sub    %eax,%edx
  800fab:	89 d0                	mov    %edx,%eax
}
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fb2:	eb 09                	jmp    800fbd <strncmp+0xe>
		n--, p++, q++;
  800fb4:	ff 4d 10             	decl   0x10(%ebp)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc1:	74 17                	je     800fda <strncmp+0x2b>
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	84 c0                	test   %al,%al
  800fca:	74 0e                	je     800fda <strncmp+0x2b>
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 10                	mov    (%eax),%dl
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	38 c2                	cmp    %al,%dl
  800fd8:	74 da                	je     800fb4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fde:	75 07                	jne    800fe7 <strncmp+0x38>
		return 0;
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	eb 14                	jmp    800ffb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f b6 d0             	movzbl %al,%edx
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 c0             	movzbl %al,%eax
  800ff7:	29 c2                	sub    %eax,%edx
  800ff9:	89 d0                	mov    %edx,%eax
}
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 04             	sub    $0x4,%esp
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801009:	eb 12                	jmp    80101d <strchr+0x20>
		if (*s == c)
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801013:	75 05                	jne    80101a <strchr+0x1d>
			return (char *) s;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	eb 11                	jmp    80102b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80101a:	ff 45 08             	incl   0x8(%ebp)
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	84 c0                	test   %al,%al
  801024:	75 e5                	jne    80100b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 04             	sub    $0x4,%esp
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801039:	eb 0d                	jmp    801048 <strfind+0x1b>
		if (*s == c)
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801043:	74 0e                	je     801053 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801045:	ff 45 08             	incl   0x8(%ebp)
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	84 c0                	test   %al,%al
  80104f:	75 ea                	jne    80103b <strfind+0xe>
  801051:	eb 01                	jmp    801054 <strfind+0x27>
		if (*s == c)
			break;
  801053:	90                   	nop
	return (char *) s;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801065:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801069:	76 63                	jbe    8010ce <memset+0x75>
		uint64 data_block = c;
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	99                   	cltd   
  80106f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801072:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80107f:	c1 e0 08             	shl    $0x8,%eax
  801082:	09 45 f0             	or     %eax,-0x10(%ebp)
  801085:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801092:	c1 e0 10             	shl    $0x10,%eax
  801095:	09 45 f0             	or     %eax,-0x10(%ebp)
  801098:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80109b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a1:	89 c2                	mov    %eax,%edx
  8010a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010ab:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010ae:	eb 18                	jmp    8010c8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b3:	8d 41 08             	lea    0x8(%ecx),%eax
  8010b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bf:	89 01                	mov    %eax,(%ecx)
  8010c1:	89 51 04             	mov    %edx,0x4(%ecx)
  8010c4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010c8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010cc:	77 e2                	ja     8010b0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d2:	74 23                	je     8010f7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010da:	eb 0e                	jmp    8010ea <memset+0x91>
			*p8++ = (uint8)c;
  8010dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010df:	8d 50 01             	lea    0x1(%eax),%edx
  8010e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	75 e5                	jne    8010dc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80110e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801112:	76 24                	jbe    801138 <memcpy+0x3c>
		while(n >= 8){
  801114:	eb 1c                	jmp    801132 <memcpy+0x36>
			*d64 = *s64;
  801116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801119:	8b 50 04             	mov    0x4(%eax),%edx
  80111c:	8b 00                	mov    (%eax),%eax
  80111e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801121:	89 01                	mov    %eax,(%ecx)
  801123:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801126:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80112a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80112e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801132:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801136:	77 de                	ja     801116 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801138:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113c:	74 31                	je     80116f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80113e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801141:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801144:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801147:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80114a:	eb 16                	jmp    801162 <memcpy+0x66>
			*d8++ = *s8++;
  80114c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114f:	8d 50 01             	lea    0x1(%eax),%edx
  801152:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801158:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80115e:	8a 12                	mov    (%edx),%dl
  801160:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	8d 50 ff             	lea    -0x1(%eax),%edx
  801168:	89 55 10             	mov    %edx,0x10(%ebp)
  80116b:	85 c0                	test   %eax,%eax
  80116d:	75 dd                	jne    80114c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80117a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801189:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80118c:	73 50                	jae    8011de <memmove+0x6a>
  80118e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	01 d0                	add    %edx,%eax
  801196:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801199:	76 43                	jbe    8011de <memmove+0x6a>
		s += n;
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011a7:	eb 10                	jmp    8011b9 <memmove+0x45>
			*--d = *--s;
  8011a9:	ff 4d f8             	decl   -0x8(%ebp)
  8011ac:	ff 4d fc             	decl   -0x4(%ebp)
  8011af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b2:	8a 10                	mov    (%eax),%dl
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	75 e3                	jne    8011a9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011c6:	eb 23                	jmp    8011eb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cb:	8d 50 01             	lea    0x1(%eax),%edx
  8011ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011da:	8a 12                	mov    (%edx),%dl
  8011dc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	75 dd                	jne    8011c8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801202:	eb 2a                	jmp    80122e <memcmp+0x3e>
		if (*s1 != *s2)
  801204:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801207:	8a 10                	mov    (%eax),%dl
  801209:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	38 c2                	cmp    %al,%dl
  801210:	74 16                	je     801228 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801212:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	0f b6 d0             	movzbl %al,%edx
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f b6 c0             	movzbl %al,%eax
  801222:	29 c2                	sub    %eax,%edx
  801224:	89 d0                	mov    %edx,%eax
  801226:	eb 18                	jmp    801240 <memcmp+0x50>
		s1++, s2++;
  801228:	ff 45 fc             	incl   -0x4(%ebp)
  80122b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80122e:	8b 45 10             	mov    0x10(%ebp),%eax
  801231:	8d 50 ff             	lea    -0x1(%eax),%edx
  801234:	89 55 10             	mov    %edx,0x10(%ebp)
  801237:	85 c0                	test   %eax,%eax
  801239:	75 c9                	jne    801204 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80123b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801248:	8b 55 08             	mov    0x8(%ebp),%edx
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	01 d0                	add    %edx,%eax
  801250:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801253:	eb 15                	jmp    80126a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 d0             	movzbl %al,%edx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	0f b6 c0             	movzbl %al,%eax
  801263:	39 c2                	cmp    %eax,%edx
  801265:	74 0d                	je     801274 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801270:	72 e3                	jb     801255 <memfind+0x13>
  801272:	eb 01                	jmp    801275 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801274:	90                   	nop
	return (void *) s;
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801280:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801287:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80128e:	eb 03                	jmp    801293 <strtol+0x19>
		s++;
  801290:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	3c 20                	cmp    $0x20,%al
  80129a:	74 f4                	je     801290 <strtol+0x16>
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	8a 00                	mov    (%eax),%al
  8012a1:	3c 09                	cmp    $0x9,%al
  8012a3:	74 eb                	je     801290 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	3c 2b                	cmp    $0x2b,%al
  8012ac:	75 05                	jne    8012b3 <strtol+0x39>
		s++;
  8012ae:	ff 45 08             	incl   0x8(%ebp)
  8012b1:	eb 13                	jmp    8012c6 <strtol+0x4c>
	else if (*s == '-')
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	3c 2d                	cmp    $0x2d,%al
  8012ba:	75 0a                	jne    8012c6 <strtol+0x4c>
		s++, neg = 1;
  8012bc:	ff 45 08             	incl   0x8(%ebp)
  8012bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ca:	74 06                	je     8012d2 <strtol+0x58>
  8012cc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012d0:	75 20                	jne    8012f2 <strtol+0x78>
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	3c 30                	cmp    $0x30,%al
  8012d9:	75 17                	jne    8012f2 <strtol+0x78>
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	40                   	inc    %eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	3c 78                	cmp    $0x78,%al
  8012e3:	75 0d                	jne    8012f2 <strtol+0x78>
		s += 2, base = 16;
  8012e5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012e9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012f0:	eb 28                	jmp    80131a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f6:	75 15                	jne    80130d <strtol+0x93>
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	3c 30                	cmp    $0x30,%al
  8012ff:	75 0c                	jne    80130d <strtol+0x93>
		s++, base = 8;
  801301:	ff 45 08             	incl   0x8(%ebp)
  801304:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80130b:	eb 0d                	jmp    80131a <strtol+0xa0>
	else if (base == 0)
  80130d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801311:	75 07                	jne    80131a <strtol+0xa0>
		base = 10;
  801313:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3c 2f                	cmp    $0x2f,%al
  801321:	7e 19                	jle    80133c <strtol+0xc2>
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 39                	cmp    $0x39,%al
  80132a:	7f 10                	jg     80133c <strtol+0xc2>
			dig = *s - '0';
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	0f be c0             	movsbl %al,%eax
  801334:	83 e8 30             	sub    $0x30,%eax
  801337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133a:	eb 42                	jmp    80137e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	3c 60                	cmp    $0x60,%al
  801343:	7e 19                	jle    80135e <strtol+0xe4>
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	3c 7a                	cmp    $0x7a,%al
  80134c:	7f 10                	jg     80135e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	0f be c0             	movsbl %al,%eax
  801356:	83 e8 57             	sub    $0x57,%eax
  801359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80135c:	eb 20                	jmp    80137e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	3c 40                	cmp    $0x40,%al
  801365:	7e 39                	jle    8013a0 <strtol+0x126>
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	3c 5a                	cmp    $0x5a,%al
  80136e:	7f 30                	jg     8013a0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	83 e8 37             	sub    $0x37,%eax
  80137b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801381:	3b 45 10             	cmp    0x10(%ebp),%eax
  801384:	7d 19                	jge    80139f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801386:	ff 45 08             	incl   0x8(%ebp)
  801389:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801390:	89 c2                	mov    %eax,%edx
  801392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801395:	01 d0                	add    %edx,%eax
  801397:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80139a:	e9 7b ff ff ff       	jmp    80131a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80139f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a4:	74 08                	je     8013ae <strtol+0x134>
		*endptr = (char *) s;
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b2:	74 07                	je     8013bb <strtol+0x141>
  8013b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b7:	f7 d8                	neg    %eax
  8013b9:	eb 03                	jmp    8013be <strtol+0x144>
  8013bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <ltostr>:

void
ltostr(long value, char *str)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d8:	79 13                	jns    8013ed <ltostr+0x2d>
	{
		neg = 1;
  8013da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013e7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013f5:	99                   	cltd   
  8013f6:	f7 f9                	idiv   %ecx
  8013f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	8d 50 01             	lea    0x1(%eax),%edx
  801401:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801404:	89 c2                	mov    %eax,%edx
  801406:	8b 45 0c             	mov    0xc(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80140e:	83 c2 30             	add    $0x30,%edx
  801411:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801413:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801416:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80141b:	f7 e9                	imul   %ecx
  80141d:	c1 fa 02             	sar    $0x2,%edx
  801420:	89 c8                	mov    %ecx,%eax
  801422:	c1 f8 1f             	sar    $0x1f,%eax
  801425:	29 c2                	sub    %eax,%edx
  801427:	89 d0                	mov    %edx,%eax
  801429:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80142c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801430:	75 bb                	jne    8013ed <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143c:	48                   	dec    %eax
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801440:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801444:	74 3d                	je     801483 <ltostr+0xc3>
		start = 1 ;
  801446:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80144d:	eb 34                	jmp    801483 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80144f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801452:	8b 45 0c             	mov    0xc(%ebp),%eax
  801455:	01 d0                	add    %edx,%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80145c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801462:	01 c2                	add    %eax,%edx
  801464:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	01 c8                	add    %ecx,%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801470:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	8a 45 eb             	mov    -0x15(%ebp),%al
  80147b:	88 02                	mov    %al,(%edx)
		start++ ;
  80147d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801480:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801486:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801489:	7c c4                	jl     80144f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80148b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80148e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801491:	01 d0                	add    %edx,%eax
  801493:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801496:	90                   	nop
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80149f:	ff 75 08             	pushl  0x8(%ebp)
  8014a2:	e8 c4 f9 ff ff       	call   800e6b <strlen>
  8014a7:	83 c4 04             	add    $0x4,%esp
  8014aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	e8 b6 f9 ff ff       	call   800e6b <strlen>
  8014b5:	83 c4 04             	add    $0x4,%esp
  8014b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c9:	eb 17                	jmp    8014e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d1:	01 c2                	add    %eax,%edx
  8014d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	01 c8                	add    %ecx,%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014df:	ff 45 fc             	incl   -0x4(%ebp)
  8014e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014e8:	7c e1                	jl     8014cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014f8:	eb 1f                	jmp    801519 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fd:	8d 50 01             	lea    0x1(%eax),%edx
  801500:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801503:	89 c2                	mov    %eax,%edx
  801505:	8b 45 10             	mov    0x10(%ebp),%eax
  801508:	01 c2                	add    %eax,%edx
  80150a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	01 c8                	add    %ecx,%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801516:	ff 45 f8             	incl   -0x8(%ebp)
  801519:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80151f:	7c d9                	jl     8014fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801521:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801524:	8b 45 10             	mov    0x10(%ebp),%eax
  801527:	01 d0                	add    %edx,%eax
  801529:	c6 00 00             	movb   $0x0,(%eax)
}
  80152c:	90                   	nop
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80153b:	8b 45 14             	mov    0x14(%ebp),%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	01 d0                	add    %edx,%eax
  80154c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801552:	eb 0c                	jmp    801560 <strsplit+0x31>
			*string++ = 0;
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8d 50 01             	lea    0x1(%eax),%edx
  80155a:	89 55 08             	mov    %edx,0x8(%ebp)
  80155d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8a 00                	mov    (%eax),%al
  801565:	84 c0                	test   %al,%al
  801567:	74 18                	je     801581 <strsplit+0x52>
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	0f be c0             	movsbl %al,%eax
  801571:	50                   	push   %eax
  801572:	ff 75 0c             	pushl  0xc(%ebp)
  801575:	e8 83 fa ff ff       	call   800ffd <strchr>
  80157a:	83 c4 08             	add    $0x8,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	75 d3                	jne    801554 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	84 c0                	test   %al,%al
  801588:	74 5a                	je     8015e4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80158a:	8b 45 14             	mov    0x14(%ebp),%eax
  80158d:	8b 00                	mov    (%eax),%eax
  80158f:	83 f8 0f             	cmp    $0xf,%eax
  801592:	75 07                	jne    80159b <strsplit+0x6c>
		{
			return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
  801599:	eb 66                	jmp    801601 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80159b:	8b 45 14             	mov    0x14(%ebp),%eax
  80159e:	8b 00                	mov    (%eax),%eax
  8015a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8015a3:	8b 55 14             	mov    0x14(%ebp),%edx
  8015a6:	89 0a                	mov    %ecx,(%edx)
  8015a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	01 c2                	add    %eax,%edx
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b9:	eb 03                	jmp    8015be <strsplit+0x8f>
			string++;
  8015bb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	84 c0                	test   %al,%al
  8015c5:	74 8b                	je     801552 <strsplit+0x23>
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	0f be c0             	movsbl %al,%eax
  8015cf:	50                   	push   %eax
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	e8 25 fa ff ff       	call   800ffd <strchr>
  8015d8:	83 c4 08             	add    $0x8,%esp
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	74 dc                	je     8015bb <strsplit+0x8c>
			string++;
	}
  8015df:	e9 6e ff ff ff       	jmp    801552 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015e4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e8:	8b 00                	mov    (%eax),%eax
  8015ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f4:	01 d0                	add    %edx,%eax
  8015f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80160f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801616:	eb 4a                	jmp    801662 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801618:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	01 c2                	add    %eax,%edx
  801620:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	01 c8                	add    %ecx,%eax
  801628:	8a 00                	mov    (%eax),%al
  80162a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80162c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801632:	01 d0                	add    %edx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	3c 40                	cmp    $0x40,%al
  801638:	7e 25                	jle    80165f <str2lower+0x5c>
  80163a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 d0                	add    %edx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	3c 5a                	cmp    $0x5a,%al
  801646:	7f 17                	jg     80165f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801648:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	01 d0                	add    %edx,%eax
  801650:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801653:	8b 55 08             	mov    0x8(%ebp),%edx
  801656:	01 ca                	add    %ecx,%edx
  801658:	8a 12                	mov    (%edx),%dl
  80165a:	83 c2 20             	add    $0x20,%edx
  80165d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80165f:	ff 45 fc             	incl   -0x4(%ebp)
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	e8 01 f8 ff ff       	call   800e6b <strlen>
  80166a:	83 c4 04             	add    $0x4,%esp
  80166d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801670:	7f a6                	jg     801618 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	57                   	push   %edi
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
  80167d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8b 55 0c             	mov    0xc(%ebp),%edx
  801686:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801689:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80168f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801692:	cd 30                	int    $0x30
  801694:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801697:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5e                   	pop    %esi
  80169f:	5f                   	pop    %edi
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    

008016a2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 04             	sub    $0x4,%esp
  8016a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	51                   	push   %ecx
  8016bb:	52                   	push   %edx
  8016bc:	ff 75 0c             	pushl  0xc(%ebp)
  8016bf:	50                   	push   %eax
  8016c0:	6a 00                	push   $0x0
  8016c2:	e8 b0 ff ff ff       	call   801677 <syscall>
  8016c7:	83 c4 18             	add    $0x18,%esp
}
  8016ca:	90                   	nop
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 02                	push   $0x2
  8016dc:	e8 96 ff ff ff       	call   801677 <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 03                	push   $0x3
  8016f5:	e8 7d ff ff ff       	call   801677 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	90                   	nop
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 04                	push   $0x4
  80170f:	e8 63 ff ff ff       	call   801677 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	90                   	nop
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80171d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	52                   	push   %edx
  80172a:	50                   	push   %eax
  80172b:	6a 08                	push   $0x8
  80172d:	e8 45 ff ff ff       	call   801677 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	56                   	push   %esi
  80173b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80173c:	8b 75 18             	mov    0x18(%ebp),%esi
  80173f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801742:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	56                   	push   %esi
  80174c:	53                   	push   %ebx
  80174d:	51                   	push   %ecx
  80174e:	52                   	push   %edx
  80174f:	50                   	push   %eax
  801750:	6a 09                	push   $0x9
  801752:	e8 20 ff ff ff       	call   801677 <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5e                   	pop    %esi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    

00801761 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	6a 0a                	push   $0xa
  801771:	e8 01 ff ff ff       	call   801677 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	ff 75 08             	pushl  0x8(%ebp)
  80178a:	6a 0b                	push   $0xb
  80178c:	e8 e6 fe ff ff       	call   801677 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 0c                	push   $0xc
  8017a5:	e8 cd fe ff ff       	call   801677 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 0d                	push   $0xd
  8017be:	e8 b4 fe ff ff       	call   801677 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 0e                	push   $0xe
  8017d7:	e8 9b fe ff ff       	call   801677 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 0f                	push   $0xf
  8017f0:	e8 82 fe ff ff       	call   801677 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	6a 10                	push   $0x10
  80180a:	e8 68 fe ff ff       	call   801677 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 11                	push   $0x11
  801823:	e8 4f fe ff ff       	call   801677 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	90                   	nop
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_cputc>:

void
sys_cputc(const char c)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80183a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	50                   	push   %eax
  801847:	6a 01                	push   $0x1
  801849:	e8 29 fe ff ff       	call   801677 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	90                   	nop
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 14                	push   $0x14
  801863:	e8 0f fe ff ff       	call   801677 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	90                   	nop
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 04             	sub    $0x4,%esp
  801874:	8b 45 10             	mov    0x10(%ebp),%eax
  801877:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80187a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80187d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	51                   	push   %ecx
  801887:	52                   	push   %edx
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	50                   	push   %eax
  80188c:	6a 15                	push   $0x15
  80188e:	e8 e4 fd ff ff       	call   801677 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	52                   	push   %edx
  8018a8:	50                   	push   %eax
  8018a9:	6a 16                	push   $0x16
  8018ab:	e8 c7 fd ff ff       	call   801677 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	51                   	push   %ecx
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	6a 17                	push   $0x17
  8018ca:	e8 a8 fd ff ff       	call   801677 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	52                   	push   %edx
  8018e4:	50                   	push   %eax
  8018e5:	6a 18                	push   $0x18
  8018e7:	e8 8b fd ff ff       	call   801677 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	ff 75 14             	pushl  0x14(%ebp)
  8018fc:	ff 75 10             	pushl  0x10(%ebp)
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	50                   	push   %eax
  801903:	6a 19                	push   $0x19
  801905:	e8 6d fd ff ff       	call   801677 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	50                   	push   %eax
  80191e:	6a 1a                	push   $0x1a
  801920:	e8 52 fd ff ff       	call   801677 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	90                   	nop
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	50                   	push   %eax
  80193a:	6a 1b                	push   $0x1b
  80193c:	e8 36 fd ff ff       	call   801677 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 05                	push   $0x5
  801955:	e8 1d fd ff ff       	call   801677 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 06                	push   $0x6
  80196e:	e8 04 fd ff ff       	call   801677 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 07                	push   $0x7
  801987:	e8 eb fc ff ff       	call   801677 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_exit_env>:


void sys_exit_env(void)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 1c                	push   $0x1c
  8019a0:	e8 d2 fc ff ff       	call   801677 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	90                   	nop
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b4:	8d 50 04             	lea    0x4(%eax),%edx
  8019b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	6a 1d                	push   $0x1d
  8019c4:	e8 ae fc ff ff       	call   801677 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
	return result;
  8019cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d5:	89 01                	mov    %eax,(%ecx)
  8019d7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	c9                   	leave  
  8019de:	c2 04 00             	ret    $0x4

008019e1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	ff 75 10             	pushl  0x10(%ebp)
  8019eb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	6a 13                	push   $0x13
  8019f3:	e8 7f fc ff ff       	call   801677 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fb:	90                   	nop
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_rcr2>:
uint32 sys_rcr2()
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 1e                	push   $0x1e
  801a0d:	e8 65 fc ff ff       	call   801677 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a23:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	50                   	push   %eax
  801a30:	6a 1f                	push   $0x1f
  801a32:	e8 40 fc ff ff       	call   801677 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3a:	90                   	nop
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <rsttst>:
void rsttst()
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 21                	push   $0x21
  801a4c:	e8 26 fc ff ff       	call   801677 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
	return ;
  801a54:	90                   	nop
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a63:	8b 55 18             	mov    0x18(%ebp),%edx
  801a66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6a:	52                   	push   %edx
  801a6b:	50                   	push   %eax
  801a6c:	ff 75 10             	pushl  0x10(%ebp)
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	6a 20                	push   $0x20
  801a77:	e8 fb fb ff ff       	call   801677 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7f:	90                   	nop
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <chktst>:
void chktst(uint32 n)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	ff 75 08             	pushl  0x8(%ebp)
  801a90:	6a 22                	push   $0x22
  801a92:	e8 e0 fb ff ff       	call   801677 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9a:	90                   	nop
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <inctst>:

void inctst()
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 23                	push   $0x23
  801aac:	e8 c6 fb ff ff       	call   801677 <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab4:	90                   	nop
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <gettst>:
uint32 gettst()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 24                	push   $0x24
  801ac6:	e8 ac fb ff ff       	call   801677 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 25                	push   $0x25
  801adf:	e8 93 fb ff ff       	call   801677 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
  801ae7:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	return uheapPlaceStrategy ;
  801aec:	a1 a0 b0 81 00       	mov    0x81b0a0,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	ff 75 08             	pushl  0x8(%ebp)
  801b09:	6a 26                	push   $0x26
  801b0b:	e8 67 fb ff ff       	call   801677 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
	return ;
  801b13:	90                   	nop
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	53                   	push   %ebx
  801b29:	51                   	push   %ecx
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 27                	push   $0x27
  801b2e:	e8 44 fb ff ff       	call   801677 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 28                	push   $0x28
  801b4e:	e8 24 fb ff ff       	call   801677 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	51                   	push   %ecx
  801b67:	ff 75 10             	pushl  0x10(%ebp)
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	6a 29                	push   $0x29
  801b6e:	e8 04 fb ff ff       	call   801677 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 10             	pushl  0x10(%ebp)
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	ff 75 08             	pushl  0x8(%ebp)
  801b88:	6a 12                	push   $0x12
  801b8a:	e8 e8 fa ff ff       	call   801677 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b92:	90                   	nop
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	52                   	push   %edx
  801ba5:	50                   	push   %eax
  801ba6:	6a 2a                	push   $0x2a
  801ba8:	e8 ca fa ff ff       	call   801677 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
	return;
  801bb0:	90                   	nop
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 2b                	push   $0x2b
  801bc2:	e8 b0 fa ff ff       	call   801677 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	6a 2d                	push   $0x2d
  801bdd:	e8 95 fa ff ff       	call   801677 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
	return;
  801be5:	90                   	nop
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	ff 75 08             	pushl  0x8(%ebp)
  801bf7:	6a 2c                	push   $0x2c
  801bf9:	e8 79 fa ff ff       	call   801677 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801c01:	90                   	nop
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	68 08 27 80 00       	push   $0x802708
  801c12:	68 25 01 00 00       	push   $0x125
  801c17:	68 3b 27 80 00       	push   $0x80273b
  801c1c:	e8 a3 e8 ff ff       	call   8004c4 <_panic>
  801c21:	66 90                	xchg   %ax,%ax
  801c23:	90                   	nop

00801c24 <__udivdi3>:
  801c24:	55                   	push   %ebp
  801c25:	57                   	push   %edi
  801c26:	56                   	push   %esi
  801c27:	53                   	push   %ebx
  801c28:	83 ec 1c             	sub    $0x1c,%esp
  801c2b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c2f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c3b:	89 ca                	mov    %ecx,%edx
  801c3d:	89 f8                	mov    %edi,%eax
  801c3f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c43:	85 f6                	test   %esi,%esi
  801c45:	75 2d                	jne    801c74 <__udivdi3+0x50>
  801c47:	39 cf                	cmp    %ecx,%edi
  801c49:	77 65                	ja     801cb0 <__udivdi3+0x8c>
  801c4b:	89 fd                	mov    %edi,%ebp
  801c4d:	85 ff                	test   %edi,%edi
  801c4f:	75 0b                	jne    801c5c <__udivdi3+0x38>
  801c51:	b8 01 00 00 00       	mov    $0x1,%eax
  801c56:	31 d2                	xor    %edx,%edx
  801c58:	f7 f7                	div    %edi
  801c5a:	89 c5                	mov    %eax,%ebp
  801c5c:	31 d2                	xor    %edx,%edx
  801c5e:	89 c8                	mov    %ecx,%eax
  801c60:	f7 f5                	div    %ebp
  801c62:	89 c1                	mov    %eax,%ecx
  801c64:	89 d8                	mov    %ebx,%eax
  801c66:	f7 f5                	div    %ebp
  801c68:	89 cf                	mov    %ecx,%edi
  801c6a:	89 fa                	mov    %edi,%edx
  801c6c:	83 c4 1c             	add    $0x1c,%esp
  801c6f:	5b                   	pop    %ebx
  801c70:	5e                   	pop    %esi
  801c71:	5f                   	pop    %edi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    
  801c74:	39 ce                	cmp    %ecx,%esi
  801c76:	77 28                	ja     801ca0 <__udivdi3+0x7c>
  801c78:	0f bd fe             	bsr    %esi,%edi
  801c7b:	83 f7 1f             	xor    $0x1f,%edi
  801c7e:	75 40                	jne    801cc0 <__udivdi3+0x9c>
  801c80:	39 ce                	cmp    %ecx,%esi
  801c82:	72 0a                	jb     801c8e <__udivdi3+0x6a>
  801c84:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c88:	0f 87 9e 00 00 00    	ja     801d2c <__udivdi3+0x108>
  801c8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c93:	89 fa                	mov    %edi,%edx
  801c95:	83 c4 1c             	add    $0x1c,%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5e                   	pop    %esi
  801c9a:	5f                   	pop    %edi
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    
  801c9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ca0:	31 ff                	xor    %edi,%edi
  801ca2:	31 c0                	xor    %eax,%eax
  801ca4:	89 fa                	mov    %edi,%edx
  801ca6:	83 c4 1c             	add    $0x1c,%esp
  801ca9:	5b                   	pop    %ebx
  801caa:	5e                   	pop    %esi
  801cab:	5f                   	pop    %edi
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    
  801cae:	66 90                	xchg   %ax,%ax
  801cb0:	89 d8                	mov    %ebx,%eax
  801cb2:	f7 f7                	div    %edi
  801cb4:	31 ff                	xor    %edi,%edi
  801cb6:	89 fa                	mov    %edi,%edx
  801cb8:	83 c4 1c             	add    $0x1c,%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5e                   	pop    %esi
  801cbd:	5f                   	pop    %edi
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    
  801cc0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cc5:	89 eb                	mov    %ebp,%ebx
  801cc7:	29 fb                	sub    %edi,%ebx
  801cc9:	89 f9                	mov    %edi,%ecx
  801ccb:	d3 e6                	shl    %cl,%esi
  801ccd:	89 c5                	mov    %eax,%ebp
  801ccf:	88 d9                	mov    %bl,%cl
  801cd1:	d3 ed                	shr    %cl,%ebp
  801cd3:	89 e9                	mov    %ebp,%ecx
  801cd5:	09 f1                	or     %esi,%ecx
  801cd7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cdb:	89 f9                	mov    %edi,%ecx
  801cdd:	d3 e0                	shl    %cl,%eax
  801cdf:	89 c5                	mov    %eax,%ebp
  801ce1:	89 d6                	mov    %edx,%esi
  801ce3:	88 d9                	mov    %bl,%cl
  801ce5:	d3 ee                	shr    %cl,%esi
  801ce7:	89 f9                	mov    %edi,%ecx
  801ce9:	d3 e2                	shl    %cl,%edx
  801ceb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cef:	88 d9                	mov    %bl,%cl
  801cf1:	d3 e8                	shr    %cl,%eax
  801cf3:	09 c2                	or     %eax,%edx
  801cf5:	89 d0                	mov    %edx,%eax
  801cf7:	89 f2                	mov    %esi,%edx
  801cf9:	f7 74 24 0c          	divl   0xc(%esp)
  801cfd:	89 d6                	mov    %edx,%esi
  801cff:	89 c3                	mov    %eax,%ebx
  801d01:	f7 e5                	mul    %ebp
  801d03:	39 d6                	cmp    %edx,%esi
  801d05:	72 19                	jb     801d20 <__udivdi3+0xfc>
  801d07:	74 0b                	je     801d14 <__udivdi3+0xf0>
  801d09:	89 d8                	mov    %ebx,%eax
  801d0b:	31 ff                	xor    %edi,%edi
  801d0d:	e9 58 ff ff ff       	jmp    801c6a <__udivdi3+0x46>
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d18:	89 f9                	mov    %edi,%ecx
  801d1a:	d3 e2                	shl    %cl,%edx
  801d1c:	39 c2                	cmp    %eax,%edx
  801d1e:	73 e9                	jae    801d09 <__udivdi3+0xe5>
  801d20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d23:	31 ff                	xor    %edi,%edi
  801d25:	e9 40 ff ff ff       	jmp    801c6a <__udivdi3+0x46>
  801d2a:	66 90                	xchg   %ax,%ax
  801d2c:	31 c0                	xor    %eax,%eax
  801d2e:	e9 37 ff ff ff       	jmp    801c6a <__udivdi3+0x46>
  801d33:	90                   	nop

00801d34 <__umoddi3>:
  801d34:	55                   	push   %ebp
  801d35:	57                   	push   %edi
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 1c             	sub    $0x1c,%esp
  801d3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d53:	89 f3                	mov    %esi,%ebx
  801d55:	89 fa                	mov    %edi,%edx
  801d57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d5b:	89 34 24             	mov    %esi,(%esp)
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	75 1a                	jne    801d7c <__umoddi3+0x48>
  801d62:	39 f7                	cmp    %esi,%edi
  801d64:	0f 86 a2 00 00 00    	jbe    801e0c <__umoddi3+0xd8>
  801d6a:	89 c8                	mov    %ecx,%eax
  801d6c:	89 f2                	mov    %esi,%edx
  801d6e:	f7 f7                	div    %edi
  801d70:	89 d0                	mov    %edx,%eax
  801d72:	31 d2                	xor    %edx,%edx
  801d74:	83 c4 1c             	add    $0x1c,%esp
  801d77:	5b                   	pop    %ebx
  801d78:	5e                   	pop    %esi
  801d79:	5f                   	pop    %edi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    
  801d7c:	39 f0                	cmp    %esi,%eax
  801d7e:	0f 87 ac 00 00 00    	ja     801e30 <__umoddi3+0xfc>
  801d84:	0f bd e8             	bsr    %eax,%ebp
  801d87:	83 f5 1f             	xor    $0x1f,%ebp
  801d8a:	0f 84 ac 00 00 00    	je     801e3c <__umoddi3+0x108>
  801d90:	bf 20 00 00 00       	mov    $0x20,%edi
  801d95:	29 ef                	sub    %ebp,%edi
  801d97:	89 fe                	mov    %edi,%esi
  801d99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d9d:	89 e9                	mov    %ebp,%ecx
  801d9f:	d3 e0                	shl    %cl,%eax
  801da1:	89 d7                	mov    %edx,%edi
  801da3:	89 f1                	mov    %esi,%ecx
  801da5:	d3 ef                	shr    %cl,%edi
  801da7:	09 c7                	or     %eax,%edi
  801da9:	89 e9                	mov    %ebp,%ecx
  801dab:	d3 e2                	shl    %cl,%edx
  801dad:	89 14 24             	mov    %edx,(%esp)
  801db0:	89 d8                	mov    %ebx,%eax
  801db2:	d3 e0                	shl    %cl,%eax
  801db4:	89 c2                	mov    %eax,%edx
  801db6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dba:	d3 e0                	shl    %cl,%eax
  801dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dc4:	89 f1                	mov    %esi,%ecx
  801dc6:	d3 e8                	shr    %cl,%eax
  801dc8:	09 d0                	or     %edx,%eax
  801dca:	d3 eb                	shr    %cl,%ebx
  801dcc:	89 da                	mov    %ebx,%edx
  801dce:	f7 f7                	div    %edi
  801dd0:	89 d3                	mov    %edx,%ebx
  801dd2:	f7 24 24             	mull   (%esp)
  801dd5:	89 c6                	mov    %eax,%esi
  801dd7:	89 d1                	mov    %edx,%ecx
  801dd9:	39 d3                	cmp    %edx,%ebx
  801ddb:	0f 82 87 00 00 00    	jb     801e68 <__umoddi3+0x134>
  801de1:	0f 84 91 00 00 00    	je     801e78 <__umoddi3+0x144>
  801de7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801deb:	29 f2                	sub    %esi,%edx
  801ded:	19 cb                	sbb    %ecx,%ebx
  801def:	89 d8                	mov    %ebx,%eax
  801df1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801df5:	d3 e0                	shl    %cl,%eax
  801df7:	89 e9                	mov    %ebp,%ecx
  801df9:	d3 ea                	shr    %cl,%edx
  801dfb:	09 d0                	or     %edx,%eax
  801dfd:	89 e9                	mov    %ebp,%ecx
  801dff:	d3 eb                	shr    %cl,%ebx
  801e01:	89 da                	mov    %ebx,%edx
  801e03:	83 c4 1c             	add    $0x1c,%esp
  801e06:	5b                   	pop    %ebx
  801e07:	5e                   	pop    %esi
  801e08:	5f                   	pop    %edi
  801e09:	5d                   	pop    %ebp
  801e0a:	c3                   	ret    
  801e0b:	90                   	nop
  801e0c:	89 fd                	mov    %edi,%ebp
  801e0e:	85 ff                	test   %edi,%edi
  801e10:	75 0b                	jne    801e1d <__umoddi3+0xe9>
  801e12:	b8 01 00 00 00       	mov    $0x1,%eax
  801e17:	31 d2                	xor    %edx,%edx
  801e19:	f7 f7                	div    %edi
  801e1b:	89 c5                	mov    %eax,%ebp
  801e1d:	89 f0                	mov    %esi,%eax
  801e1f:	31 d2                	xor    %edx,%edx
  801e21:	f7 f5                	div    %ebp
  801e23:	89 c8                	mov    %ecx,%eax
  801e25:	f7 f5                	div    %ebp
  801e27:	89 d0                	mov    %edx,%eax
  801e29:	e9 44 ff ff ff       	jmp    801d72 <__umoddi3+0x3e>
  801e2e:	66 90                	xchg   %ax,%ax
  801e30:	89 c8                	mov    %ecx,%eax
  801e32:	89 f2                	mov    %esi,%edx
  801e34:	83 c4 1c             	add    $0x1c,%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    
  801e3c:	3b 04 24             	cmp    (%esp),%eax
  801e3f:	72 06                	jb     801e47 <__umoddi3+0x113>
  801e41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e45:	77 0f                	ja     801e56 <__umoddi3+0x122>
  801e47:	89 f2                	mov    %esi,%edx
  801e49:	29 f9                	sub    %edi,%ecx
  801e4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e4f:	89 14 24             	mov    %edx,(%esp)
  801e52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e56:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e5a:	8b 14 24             	mov    (%esp),%edx
  801e5d:	83 c4 1c             	add    $0x1c,%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5e                   	pop    %esi
  801e62:	5f                   	pop    %edi
  801e63:	5d                   	pop    %ebp
  801e64:	c3                   	ret    
  801e65:	8d 76 00             	lea    0x0(%esi),%esi
  801e68:	2b 04 24             	sub    (%esp),%eax
  801e6b:	19 fa                	sbb    %edi,%edx
  801e6d:	89 d1                	mov    %edx,%ecx
  801e6f:	89 c6                	mov    %eax,%esi
  801e71:	e9 71 ff ff ff       	jmp    801de7 <__umoddi3+0xb3>
  801e76:	66 90                	xchg   %ax,%ax
  801e78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e7c:	72 ea                	jb     801e68 <__umoddi3+0x134>
  801e7e:	89 d9                	mov    %ebx,%ecx
  801e80:	e9 62 ff ff ff       	jmp    801de7 <__umoddi3+0xb3>
