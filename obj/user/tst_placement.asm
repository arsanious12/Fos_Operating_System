
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 d5 05 00 00       	call   80060b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/,	//Stack
		0x81b000 /*for the text color variable*/} ;


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 84 00 00 01    	sub    $0x1000084,%esp
#if USE_KHEAP
	//	cprintf_colored(TEXT_cyan,"envID = %d\n",envID);

	char arr[PAGE_SIZE*1024*4];
	bool found ;
	cprintf_colored(TEXT_cyan,"STEP 0: checking Initial WS entries ...\n");
  800042:	83 ec 08             	sub    $0x8,%esp
  800045:	68 80 21 80 00       	push   $0x802180
  80004a:	6a 03                	push   $0x3
  80004c:	e8 65 0a 00 00       	call   800ab6 <cprintf_colored>
  800051:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedInitialVAs, 15, 0, 1);
  800054:	6a 01                	push   $0x1
  800056:	6a 00                	push   $0x0
  800058:	6a 0f                	push   $0xf
  80005a:	68 00 30 80 00       	push   $0x803000
  80005f:	e8 eb 1d 00 00       	call   801e4f <sys_check_WS_list>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80006a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80006e:	74 14                	je     800084 <_main+0x4c>
  800070:	83 ec 04             	sub    $0x4,%esp
  800073:	68 ac 21 80 00       	push   $0x8021ac
  800078:	6a 17                	push   $0x17
  80007a:	68 ed 21 80 00       	push   $0x8021ed
  80007f:	e8 37 07 00 00       	call   8007bb <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800084:	a1 60 30 80 00       	mov    0x803060,%eax
  800089:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
  80008f:	85 c0                	test   %eax,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 04 22 80 00       	push   $0x802204
  80009b:	6a 1b                	push   $0x1b
  80009d:	68 ed 21 80 00       	push   $0x8021ed
  8000a2:	e8 14 07 00 00       	call   8007bb <_panic>
		/*====================================*/
	}
	int eval = 0;
  8000a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan,"\nSTEP 1: checking USER KERNEL STACK... [20%]\n");
  8000b5:	83 ec 08             	sub    $0x8,%esp
  8000b8:	68 44 22 80 00       	push   $0x802244
  8000bd:	6a 03                	push   $0x3
  8000bf:	e8 f2 09 00 00       	call   800ab6 <cprintf_colored>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 stackIsCorrect;
		sys_utilities("__CheckUserKernStack__", (uint32)(&stackIsCorrect));
  8000c7:	8d 85 d8 ff ff fe    	lea    -0x1000028(%ebp),%eax
  8000cd:	83 ec 08             	sub    $0x8,%esp
  8000d0:	50                   	push   %eax
  8000d1:	68 72 22 80 00       	push   $0x802272
  8000d6:	e8 b1 1d 00 00       	call   801e8c <sys_utilities>
  8000db:	83 c4 10             	add    $0x10,%esp
		if (!stackIsCorrect)
  8000de:	8b 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%eax
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	75 19                	jne    800101 <_main+0xc9>
		{
			is_correct = 0;
  8000e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf_colored(TEXT_TESTERR_CLR,"User Kernel Stack is not set correctly\n");
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	68 8c 22 80 00       	push   $0x80228c
  8000f7:	6a 0c                	push   $0xc
  8000f9:	e8 b8 09 00 00       	call   800ab6 <cprintf_colored>
  8000fe:	83 c4 10             	add    $0x10,%esp
		}
	}
	if (is_correct) eval += 20;
  800101:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800105:	74 04                	je     80010b <_main+0xd3>
  800107:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

	cprintf_colored(TEXT_cyan,"\nSTEP 2: checking PLACEMENT...\n");
  80010b:	83 ec 08             	sub    $0x8,%esp
  80010e:	68 b4 22 80 00       	push   $0x8022b4
  800113:	6a 03                	push   $0x3
  800115:	e8 9c 09 00 00       	call   800ab6 <cprintf_colored>
  80011a:	83 c4 10             	add    $0x10,%esp
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80011d:	e8 b6 19 00 00       	call   801ad8 <sys_pf_calculate_allocated_pages>
  800122:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int freePages = sys_calculate_free_frames();
  800125:	e8 63 19 00 00       	call   801a8d <sys_calculate_free_frames>
  80012a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		//2 stack pages & page table
		int i=PAGE_SIZE*1024;
  80012d:	c7 45 ec 00 00 40 00 	movl   $0x400000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800134:	eb 11                	jmp    800147 <_main+0x10f>
		{
			arr[i] = 1;
  800136:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80013c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80013f:	01 d0                	add    %edx,%eax
  800141:	c6 00 01             	movb   $0x1,(%eax)
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		int freePages = sys_calculate_free_frames();
		//2 stack pages & page table
		int i=PAGE_SIZE*1024;
		for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800144:	ff 45 ec             	incl   -0x14(%ebp)
  800147:	81 7d ec 00 10 40 00 	cmpl   $0x401000,-0x14(%ebp)
  80014e:	7e e6                	jle    800136 <_main+0xfe>
		{
			arr[i] = 1;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*2;
  800150:	c7 45 ec 00 00 80 00 	movl   $0x800000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800157:	eb 11                	jmp    80016a <_main+0x132>
		{
			arr[i] = 2;
  800159:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80015f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800162:	01 d0                	add    %edx,%eax
  800164:	c6 00 02             	movb   $0x2,(%eax)
			arr[i] = 1;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*2;
		for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800167:	ff 45 ec             	incl   -0x14(%ebp)
  80016a:	81 7d ec 00 10 80 00 	cmpl   $0x801000,-0x14(%ebp)
  800171:	7e e6                	jle    800159 <_main+0x121>
		{
			arr[i] = 2;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*3;
  800173:	c7 45 ec 00 00 c0 00 	movl   $0xc00000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*3 + PAGE_SIZE);i++)
  80017a:	eb 11                	jmp    80018d <_main+0x155>
		{
			arr[i] = 3;
  80017c:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	c6 00 03             	movb   $0x3,(%eax)
			arr[i] = 2;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3 + PAGE_SIZE);i++)
  80018a:	ff 45 ec             	incl   -0x14(%ebp)
  80018d:	81 7d ec 00 10 c0 00 	cmpl   $0xc01000,-0x14(%ebp)
  800194:	7e e6                	jle    80017c <_main+0x144>
		{
			arr[i] = 3;
		}

		is_correct = 1;
  800196:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		cprintf_colored(TEXT_cyan,"	STEP A: checking PLACEMENT fault handling... [30%] \n");
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	68 d4 22 80 00       	push   $0x8022d4
  8001a5:	6a 03                	push   $0x3
  8001a7:	e8 0a 09 00 00       	call   800ab6 <cprintf_colored>
  8001ac:	83 c4 10             	add    $0x10,%esp
		{
			if( arr[PAGE_SIZE*1024] !=  1)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001af:	8a 85 dc ff 3f ff    	mov    -0xc00024(%ebp),%al
  8001b5:	3c 01                	cmp    $0x1,%al
  8001b7:	74 19                	je     8001d2 <_main+0x19a>
  8001b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	68 0c 23 80 00       	push   $0x80230c
  8001c8:	6a 0c                	push   $0xc
  8001ca:	e8 e7 08 00 00       	call   800ab6 <cprintf_colored>
  8001cf:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1025] !=  1)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001d2:	8a 85 dc 0f 40 ff    	mov    -0xbff024(%ebp),%al
  8001d8:	3c 01                	cmp    $0x1,%al
  8001da:	74 19                	je     8001f5 <_main+0x1bd>
  8001dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	68 0c 23 80 00       	push   $0x80230c
  8001eb:	6a 0c                	push   $0xc
  8001ed:	e8 c4 08 00 00       	call   800ab6 <cprintf_colored>
  8001f2:	83 c4 10             	add    $0x10,%esp

			if( arr[PAGE_SIZE*1024*2] !=  2)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001f5:	8a 85 dc ff 7f ff    	mov    -0x800024(%ebp),%al
  8001fb:	3c 02                	cmp    $0x2,%al
  8001fd:	74 19                	je     800218 <_main+0x1e0>
  8001ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800206:	83 ec 08             	sub    $0x8,%esp
  800209:	68 0c 23 80 00       	push   $0x80230c
  80020e:	6a 0c                	push   $0xc
  800210:	e8 a1 08 00 00       	call   800ab6 <cprintf_colored>
  800215:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  2)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  800218:	8a 85 dc 0f 80 ff    	mov    -0x7ff024(%ebp),%al
  80021e:	3c 02                	cmp    $0x2,%al
  800220:	74 19                	je     80023b <_main+0x203>
  800222:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	68 0c 23 80 00       	push   $0x80230c
  800231:	6a 0c                	push   $0xc
  800233:	e8 7e 08 00 00       	call   800ab6 <cprintf_colored>
  800238:	83 c4 10             	add    $0x10,%esp

			if( arr[PAGE_SIZE*1024*3] !=  3)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  80023b:	8a 85 dc ff bf ff    	mov    -0x400024(%ebp),%al
  800241:	3c 03                	cmp    $0x3,%al
  800243:	74 19                	je     80025e <_main+0x226>
  800245:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	68 0c 23 80 00       	push   $0x80230c
  800254:	6a 0c                	push   $0xc
  800256:	e8 5b 08 00 00       	call   800ab6 <cprintf_colored>
  80025b:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  3)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  80025e:	8a 85 dc 0f c0 ff    	mov    -0x3ff024(%ebp),%al
  800264:	3c 03                	cmp    $0x3,%al
  800266:	74 19                	je     800281 <_main+0x249>
  800268:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	68 0c 23 80 00       	push   $0x80230c
  800277:	6a 0c                	push   $0xc
  800279:	e8 38 08 00 00       	call   800ab6 <cprintf_colored>
  80027e:	83 c4 10             	add    $0x10,%esp

			if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf_colored(TEXT_cyan,"new stack pages should NOT be written to Page File until evicted as victim\n");}
  800281:	e8 52 18 00 00       	call   801ad8 <sys_pf_calculate_allocated_pages>
  800286:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800289:	74 19                	je     8002a4 <_main+0x26c>
  80028b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	68 2c 23 80 00       	push   $0x80232c
  80029a:	6a 03                	push   $0x3
  80029c:	e8 15 08 00 00       	call   800ab6 <cprintf_colored>
  8002a1:	83 c4 10             	add    $0x10,%esp

			int expected = 6 /*pages*/ + 3 /*tables*/;
  8002a4:	c7 45 dc 09 00 00 00 	movl   $0x9,-0x24(%ebp)
			if( (freePages - sys_calculate_free_frames() ) != expected )
  8002ab:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8002ae:	e8 da 17 00 00       	call   801a8d <sys_calculate_free_frames>
  8002b3:	29 c3                	sub    %eax,%ebx
  8002b5:	89 da                	mov    %ebx,%edx
  8002b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ba:	39 c2                	cmp    %eax,%edx
  8002bc:	74 26                	je     8002e4 <_main+0x2ac>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));}
  8002be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002c5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8002c8:	e8 c0 17 00 00       	call   801a8d <sys_calculate_free_frames>
  8002cd:	29 c3                	sub    %eax,%ebx
  8002cf:	89 d8                	mov    %ebx,%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d5:	68 78 23 80 00       	push   $0x802378
  8002da:	6a 0c                	push   $0xc
  8002dc:	e8 d5 07 00 00       	call   800ab6 <cprintf_colored>
  8002e1:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan,"	STEP A finished: PLACEMENT fault handling !\n\n\n");
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	68 c0 23 80 00       	push   $0x8023c0
  8002ec:	6a 03                	push   $0x3
  8002ee:	e8 c3 07 00 00       	call   800ab6 <cprintf_colored>
  8002f3:	83 c4 10             	add    $0x10,%esp

		if (is_correct)
  8002f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002fa:	74 04                	je     800300 <_main+0x2c8>
		{
			eval += 30;
  8002fc:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
		is_correct = 1;
  800300:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		cprintf_colored(TEXT_cyan,"	STEP B: checking WS entries... [30%]\n");
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	68 f0 23 80 00       	push   $0x8023f0
  80030f:	6a 03                	push   $0x3
  800311:	e8 a0 07 00 00       	call   800ab6 <cprintf_colored>
  800316:	83 c4 10             	add    $0x10,%esp
		{
			uint32 expectedPages[21] ;
			{
				expectedPages[0] = 0x800000 ;
  800319:	c7 85 80 ff ff fe 00 	movl   $0x800000,-0x1000080(%ebp)
  800320:	00 80 00 
				expectedPages[1] = 0x801000 ;
  800323:	c7 85 84 ff ff fe 00 	movl   $0x801000,-0x100007c(%ebp)
  80032a:	10 80 00 
				expectedPages[2] = 0x802000 ;
  80032d:	c7 85 88 ff ff fe 00 	movl   $0x802000,-0x1000078(%ebp)
  800334:	20 80 00 
				expectedPages[3] = 0x803000 ;
  800337:	c7 85 8c ff ff fe 00 	movl   $0x803000,-0x1000074(%ebp)
  80033e:	30 80 00 
				expectedPages[4] = 0x804000 ;
  800341:	c7 85 90 ff ff fe 00 	movl   $0x804000,-0x1000070(%ebp)
  800348:	40 80 00 
				expectedPages[5] = 0x805000 ;
  80034b:	c7 85 94 ff ff fe 00 	movl   $0x805000,-0x100006c(%ebp)
  800352:	50 80 00 
				expectedPages[6] = 0x806000 ;
  800355:	c7 85 98 ff ff fe 00 	movl   $0x806000,-0x1000068(%ebp)
  80035c:	60 80 00 
				expectedPages[7] = 0x807000 ;
  80035f:	c7 85 9c ff ff fe 00 	movl   $0x807000,-0x1000064(%ebp)
  800366:	70 80 00 
				expectedPages[8] = 0x808000 ;
  800369:	c7 85 a0 ff ff fe 00 	movl   $0x808000,-0x1000060(%ebp)
  800370:	80 80 00 
				expectedPages[9] = 0x809000 ;
  800373:	c7 85 a4 ff ff fe 00 	movl   $0x809000,-0x100005c(%ebp)
  80037a:	90 80 00 
				expectedPages[10] = 0x80a000 ;
  80037d:	c7 85 a8 ff ff fe 00 	movl   $0x80a000,-0x1000058(%ebp)
  800384:	a0 80 00 
				expectedPages[11] = 0x80b000 ;
  800387:	c7 85 ac ff ff fe 00 	movl   $0x80b000,-0x1000054(%ebp)
  80038e:	b0 80 00 
				expectedPages[12] = 0xeebfd000 ;
  800391:	c7 85 b0 ff ff fe 00 	movl   $0xeebfd000,-0x1000050(%ebp)
  800398:	d0 bf ee 
				expectedPages[13] = 0xedbfd000 ;
  80039b:	c7 85 b4 ff ff fe 00 	movl   $0xedbfd000,-0x100004c(%ebp)
  8003a2:	d0 bf ed 
				expectedPages[14] = 0x81b000 ;
  8003a5:	c7 85 b8 ff ff fe 00 	movl   $0x81b000,-0x1000048(%ebp)
  8003ac:	b0 81 00 
				expectedPages[15] = 0xedffd000 ;
  8003af:	c7 85 bc ff ff fe 00 	movl   $0xedffd000,-0x1000044(%ebp)
  8003b6:	d0 ff ed 
				expectedPages[16] = 0xedffe000 ;
  8003b9:	c7 85 c0 ff ff fe 00 	movl   $0xedffe000,-0x1000040(%ebp)
  8003c0:	e0 ff ed 
				expectedPages[17] = 0xee3fd000 ;
  8003c3:	c7 85 c4 ff ff fe 00 	movl   $0xee3fd000,-0x100003c(%ebp)
  8003ca:	d0 3f ee 
				expectedPages[18] = 0xee3fe000 ;
  8003cd:	c7 85 c8 ff ff fe 00 	movl   $0xee3fe000,-0x1000038(%ebp)
  8003d4:	e0 3f ee 
				expectedPages[19] = 0xee7fd000 ;
  8003d7:	c7 85 cc ff ff fe 00 	movl   $0xee7fd000,-0x1000034(%ebp)
  8003de:	d0 7f ee 
				expectedPages[20] = 0xee7fe000 ;
  8003e1:	c7 85 d0 ff ff fe 00 	movl   $0xee7fe000,-0x1000030(%ebp)
  8003e8:	e0 7f ee 
			}
			found = sys_check_WS_list(expectedPages, 21, 0, 1);
  8003eb:	6a 01                	push   $0x1
  8003ed:	6a 00                	push   $0x0
  8003ef:	6a 15                	push   $0x15
  8003f1:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8003f7:	50                   	push   %eax
  8003f8:	e8 52 1a 00 00       	call   801e4f <sys_check_WS_list>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (found != 1)
  800403:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800407:	74 19                	je     800422 <_main+0x3ea>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800409:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	68 18 24 80 00       	push   $0x802418
  800418:	6a 0c                	push   $0xc
  80041a:	e8 97 06 00 00       	call   800ab6 <cprintf_colored>
  80041f:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan,"	STEP B finished: WS entries test \n\n\n");
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	68 6c 24 80 00       	push   $0x80246c
  80042a:	6a 03                	push   $0x3
  80042c:	e8 85 06 00 00       	call   800ab6 <cprintf_colored>
  800431:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800434:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800438:	74 04                	je     80043e <_main+0x406>
		{
			eval += 30;
  80043a:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
		is_correct = 1;
  80043e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		cprintf_colored(TEXT_cyan,"	STEP C: checking working sets WHEN BECOMES FULL... [20%]\n");
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	68 94 24 80 00       	push   $0x802494
  80044d:	6a 03                	push   $0x3
  80044f:	e8 62 06 00 00       	call   800ab6 <cprintf_colored>
  800454:	83 c4 10             	add    $0x10,%esp
		{
			/*NO NEED FOR THIS IF REPL IS "LRU"*/
			if(myEnv->page_last_WS_element != NULL)
  800457:	a1 60 30 80 00       	mov    0x803060,%eax
  80045c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
  800462:	85 c0                	test   %eax,%eax
  800464:	74 19                	je     80047f <_main+0x447>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}
  800466:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	68 d0 24 80 00       	push   $0x8024d0
  800475:	6a 0c                	push   $0xc
  800477:	e8 3a 06 00 00       	call   800ab6 <cprintf_colored>
  80047c:	83 c4 10             	add    $0x10,%esp

			//1 stack page
			i=PAGE_SIZE*1024*3 + 2*PAGE_SIZE;
  80047f:	c7 45 ec 00 20 c0 00 	movl   $0xc02000,-0x14(%ebp)
			arr[i] = 4;
  800486:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80048c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048f:	01 d0                	add    %edx,%eax
  800491:	c6 00 04             	movb   $0x4,(%eax)

			if( arr[i] != 4)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  800494:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	8a 00                	mov    (%eax),%al
  8004a1:	3c 04                	cmp    $0x4,%al
  8004a3:	74 19                	je     8004be <_main+0x486>
  8004a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	68 0c 23 80 00       	push   $0x80230c
  8004b4:	6a 0c                	push   $0xc
  8004b6:	e8 fb 05 00 00       	call   800ab6 <cprintf_colored>
  8004bb:	83 c4 10             	add    $0x10,%esp
			//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
			//				0x800000,0x801000,0x802000,0x803000,
			//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0xee7fd000};
			uint32 expectedPages[22] ;
			{
				expectedPages[0] = 0x800000 ;
  8004be:	c7 85 80 ff ff fe 00 	movl   $0x800000,-0x1000080(%ebp)
  8004c5:	00 80 00 
				expectedPages[1] = 0x801000 ;
  8004c8:	c7 85 84 ff ff fe 00 	movl   $0x801000,-0x100007c(%ebp)
  8004cf:	10 80 00 
				expectedPages[2] = 0x802000 ;
  8004d2:	c7 85 88 ff ff fe 00 	movl   $0x802000,-0x1000078(%ebp)
  8004d9:	20 80 00 
				expectedPages[3] = 0x803000 ;
  8004dc:	c7 85 8c ff ff fe 00 	movl   $0x803000,-0x1000074(%ebp)
  8004e3:	30 80 00 
				expectedPages[4] = 0x804000 ;
  8004e6:	c7 85 90 ff ff fe 00 	movl   $0x804000,-0x1000070(%ebp)
  8004ed:	40 80 00 
				expectedPages[5] = 0x805000 ;
  8004f0:	c7 85 94 ff ff fe 00 	movl   $0x805000,-0x100006c(%ebp)
  8004f7:	50 80 00 
				expectedPages[6] = 0x806000 ;
  8004fa:	c7 85 98 ff ff fe 00 	movl   $0x806000,-0x1000068(%ebp)
  800501:	60 80 00 
				expectedPages[7] = 0x807000 ;
  800504:	c7 85 9c ff ff fe 00 	movl   $0x807000,-0x1000064(%ebp)
  80050b:	70 80 00 
				expectedPages[8] = 0x808000 ;
  80050e:	c7 85 a0 ff ff fe 00 	movl   $0x808000,-0x1000060(%ebp)
  800515:	80 80 00 
				expectedPages[9] = 0x809000 ;
  800518:	c7 85 a4 ff ff fe 00 	movl   $0x809000,-0x100005c(%ebp)
  80051f:	90 80 00 
				expectedPages[10] = 0x80a000 ;
  800522:	c7 85 a8 ff ff fe 00 	movl   $0x80a000,-0x1000058(%ebp)
  800529:	a0 80 00 
				expectedPages[11] = 0x80b000 ;
  80052c:	c7 85 ac ff ff fe 00 	movl   $0x80b000,-0x1000054(%ebp)
  800533:	b0 80 00 
				expectedPages[12] = 0xeebfd000 ;
  800536:	c7 85 b0 ff ff fe 00 	movl   $0xeebfd000,-0x1000050(%ebp)
  80053d:	d0 bf ee 
				expectedPages[13] = 0xedbfd000 ;
  800540:	c7 85 b4 ff ff fe 00 	movl   $0xedbfd000,-0x100004c(%ebp)
  800547:	d0 bf ed 
				expectedPages[14] = 0x81b000 ;
  80054a:	c7 85 b8 ff ff fe 00 	movl   $0x81b000,-0x1000048(%ebp)
  800551:	b0 81 00 
				expectedPages[15] = 0xedffd000 ;
  800554:	c7 85 bc ff ff fe 00 	movl   $0xedffd000,-0x1000044(%ebp)
  80055b:	d0 ff ed 
				expectedPages[16] = 0xedffe000 ;
  80055e:	c7 85 c0 ff ff fe 00 	movl   $0xedffe000,-0x1000040(%ebp)
  800565:	e0 ff ed 
				expectedPages[17] = 0xee3fd000 ;
  800568:	c7 85 c4 ff ff fe 00 	movl   $0xee3fd000,-0x100003c(%ebp)
  80056f:	d0 3f ee 
				expectedPages[18] = 0xee3fe000 ;
  800572:	c7 85 c8 ff ff fe 00 	movl   $0xee3fe000,-0x1000038(%ebp)
  800579:	e0 3f ee 
				expectedPages[19] = 0xee7fd000 ;
  80057c:	c7 85 cc ff ff fe 00 	movl   $0xee7fd000,-0x1000034(%ebp)
  800583:	d0 7f ee 
				expectedPages[20] = 0xee7fe000 ;
  800586:	c7 85 d0 ff ff fe 00 	movl   $0xee7fe000,-0x1000030(%ebp)
  80058d:	e0 7f ee 
				expectedPages[21] = 0xee7ff000 ;
  800590:	c7 85 d4 ff ff fe 00 	movl   $0xee7ff000,-0x100002c(%ebp)
  800597:	f0 7f ee 
			}
			found = sys_check_WS_list(expectedPages, 22, 0x800000, 1);
  80059a:	6a 01                	push   $0x1
  80059c:	68 00 00 80 00       	push   $0x800000
  8005a1:	6a 16                	push   $0x16
  8005a3:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8005a9:	50                   	push   %eax
  8005aa:	e8 a0 18 00 00       	call   801e4f <sys_check_WS_list>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (found != 1)
  8005b5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8005b9:	74 19                	je     8005d4 <_main+0x59c>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  8005bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	68 18 24 80 00       	push   $0x802418
  8005ca:	6a 0c                	push   $0xc
  8005cc:	e8 e5 04 00 00       	call   800ab6 <cprintf_colored>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan, "	STEP C finished: WS is FULL now\n\n\n");
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	68 28 25 80 00       	push   $0x802528
  8005dc:	6a 03                	push   $0x3
  8005de:	e8 d3 04 00 00       	call   800ab6 <cprintf_colored>
  8005e3:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  8005e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005ea:	74 04                	je     8005f0 <_main+0x5b8>
		{
			eval += 20;
  8005ec:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
		}
	}
	cprintf_colored(TEXT_light_green, "%~\nTest of KERNEL STACK & PAGE PLACEMENT completed. Eval = %d%\n\n", eval);
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	68 4c 25 80 00       	push   $0x80254c
  8005fb:	6a 0a                	push   $0xa
  8005fd:	e8 b4 04 00 00       	call   800ab6 <cprintf_colored>
  800602:	83 c4 10             	add    $0x10,%esp

	return;
  800605:	90                   	nop
#endif
}
  800606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800609:	c9                   	leave  
  80060a:	c3                   	ret    

0080060b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	57                   	push   %edi
  80060f:	56                   	push   %esi
  800610:	53                   	push   %ebx
  800611:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800614:	e8 3d 16 00 00       	call   801c56 <sys_getenvindex>
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80061c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80061f:	89 d0                	mov    %edx,%eax
  800621:	c1 e0 02             	shl    $0x2,%eax
  800624:	01 d0                	add    %edx,%eax
  800626:	c1 e0 03             	shl    $0x3,%eax
  800629:	01 d0                	add    %edx,%eax
  80062b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800632:	01 d0                	add    %edx,%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80063c:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800641:	a1 60 30 80 00       	mov    0x803060,%eax
  800646:	8a 40 20             	mov    0x20(%eax),%al
  800649:	84 c0                	test   %al,%al
  80064b:	74 0d                	je     80065a <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80064d:	a1 60 30 80 00       	mov    0x803060,%eax
  800652:	83 c0 20             	add    $0x20,%eax
  800655:	a3 40 30 80 00       	mov    %eax,0x803040

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80065a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065e:	7e 0a                	jle    80066a <libmain+0x5f>
		binaryname = argv[0];
  800660:	8b 45 0c             	mov    0xc(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	a3 40 30 80 00       	mov    %eax,0x803040

	// call user main routine
	_main(argc, argv);
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	ff 75 0c             	pushl  0xc(%ebp)
  800670:	ff 75 08             	pushl  0x8(%ebp)
  800673:	e8 c0 f9 ff ff       	call   800038 <_main>
  800678:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80067b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800680:	85 c0                	test   %eax,%eax
  800682:	0f 84 01 01 00 00    	je     800789 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800688:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80068e:	bb 88 26 80 00       	mov    $0x802688,%ebx
  800693:	ba 0e 00 00 00       	mov    $0xe,%edx
  800698:	89 c7                	mov    %eax,%edi
  80069a:	89 de                	mov    %ebx,%esi
  80069c:	89 d1                	mov    %edx,%ecx
  80069e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006a0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006a3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006a8:	b0 00                	mov    $0x0,%al
  8006aa:	89 d7                	mov    %edx,%edi
  8006ac:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	50                   	push   %eax
  8006bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006c2:	50                   	push   %eax
  8006c3:	e8 c4 17 00 00       	call   801e8c <sys_utilities>
  8006c8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006cb:	e8 0d 13 00 00       	call   8019dd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006d0:	83 ec 0c             	sub    $0xc,%esp
  8006d3:	68 a8 25 80 00       	push   $0x8025a8
  8006d8:	e8 ac 03 00 00       	call   800a89 <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 18                	je     8006ff <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006e7:	e8 be 17 00 00       	call   801eaa <sys_get_optimal_num_faults>
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 d0 25 80 00       	push   $0x8025d0
  8006f5:	e8 8f 03 00 00       	call   800a89 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	eb 59                	jmp    800758 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ff:	a1 60 30 80 00       	mov    0x803060,%eax
  800704:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80070a:	a1 60 30 80 00       	mov    0x803060,%eax
  80070f:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800715:	83 ec 04             	sub    $0x4,%esp
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	68 f4 25 80 00       	push   $0x8025f4
  80071f:	e8 65 03 00 00       	call   800a89 <cprintf>
  800724:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800727:	a1 60 30 80 00       	mov    0x803060,%eax
  80072c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800732:	a1 60 30 80 00       	mov    0x803060,%eax
  800737:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80073d:	a1 60 30 80 00       	mov    0x803060,%eax
  800742:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800748:	51                   	push   %ecx
  800749:	52                   	push   %edx
  80074a:	50                   	push   %eax
  80074b:	68 1c 26 80 00       	push   $0x80261c
  800750:	e8 34 03 00 00       	call   800a89 <cprintf>
  800755:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800758:	a1 60 30 80 00       	mov    0x803060,%eax
  80075d:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	50                   	push   %eax
  800767:	68 74 26 80 00       	push   $0x802674
  80076c:	e8 18 03 00 00       	call   800a89 <cprintf>
  800771:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	68 a8 25 80 00       	push   $0x8025a8
  80077c:	e8 08 03 00 00       	call   800a89 <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800784:	e8 6e 12 00 00       	call   8019f7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800789:	e8 1f 00 00 00       	call   8007ad <exit>
}
  80078e:	90                   	nop
  80078f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800792:	5b                   	pop    %ebx
  800793:	5e                   	pop    %esi
  800794:	5f                   	pop    %edi
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079d:	83 ec 0c             	sub    $0xc,%esp
  8007a0:	6a 00                	push   $0x0
  8007a2:	e8 7b 14 00 00       	call   801c22 <sys_destroy_env>
  8007a7:	83 c4 10             	add    $0x10,%esp
}
  8007aa:	90                   	nop
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <exit>:

void
exit(void)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b3:	e8 d0 14 00 00       	call   801c88 <sys_exit_env>
}
  8007b8:	90                   	nop
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c4:	83 c0 04             	add    $0x4,%eax
  8007c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007ca:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	74 16                	je     8007e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d3:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	50                   	push   %eax
  8007dc:	68 ec 26 80 00       	push   $0x8026ec
  8007e1:	e8 a3 02 00 00       	call   800a89 <cprintf>
  8007e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007e9:	a1 40 30 80 00       	mov    0x803040,%eax
  8007ee:	83 ec 0c             	sub    $0xc,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	ff 75 08             	pushl  0x8(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	68 f4 26 80 00       	push   $0x8026f4
  8007fd:	6a 74                	push   $0x74
  8007ff:	e8 b2 02 00 00       	call   800ab6 <cprintf_colored>
  800804:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 f4             	pushl  -0xc(%ebp)
  800810:	50                   	push   %eax
  800811:	e8 04 02 00 00       	call   800a1a <vcprintf>
  800816:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	6a 00                	push   $0x0
  80081e:	68 1c 27 80 00       	push   $0x80271c
  800823:	e8 f2 01 00 00       	call   800a1a <vcprintf>
  800828:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80082b:	e8 7d ff ff ff       	call   8007ad <exit>

	// should not return here
	while (1) ;
  800830:	eb fe                	jmp    800830 <_panic+0x75>

00800832 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800838:	a1 60 30 80 00       	mov    0x803060,%eax
  80083d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800843:	8b 45 0c             	mov    0xc(%ebp),%eax
  800846:	39 c2                	cmp    %eax,%edx
  800848:	74 14                	je     80085e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80084a:	83 ec 04             	sub    $0x4,%esp
  80084d:	68 20 27 80 00       	push   $0x802720
  800852:	6a 26                	push   $0x26
  800854:	68 6c 27 80 00       	push   $0x80276c
  800859:	e8 5d ff ff ff       	call   8007bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80085e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800865:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80086c:	e9 c5 00 00 00       	jmp    800936 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800874:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	85 c0                	test   %eax,%eax
  800884:	75 08                	jne    80088e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800886:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800889:	e9 a5 00 00 00       	jmp    800933 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80088e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800895:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80089c:	eb 69                	jmp    800907 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80089e:	a1 60 30 80 00       	mov    0x803060,%eax
  8008a3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ac:	89 d0                	mov    %edx,%eax
  8008ae:	01 c0                	add    %eax,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	c1 e0 03             	shl    $0x3,%eax
  8008b5:	01 c8                	add    %ecx,%eax
  8008b7:	8a 40 04             	mov    0x4(%eax),%al
  8008ba:	84 c0                	test   %al,%al
  8008bc:	75 46                	jne    800904 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008be:	a1 60 30 80 00       	mov    0x803060,%eax
  8008c3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008cc:	89 d0                	mov    %edx,%eax
  8008ce:	01 c0                	add    %eax,%eax
  8008d0:	01 d0                	add    %edx,%eax
  8008d2:	c1 e0 03             	shl    $0x3,%eax
  8008d5:	01 c8                	add    %ecx,%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	01 c8                	add    %ecx,%eax
  8008f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f7:	39 c2                	cmp    %eax,%edx
  8008f9:	75 09                	jne    800904 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800902:	eb 15                	jmp    800919 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800904:	ff 45 e8             	incl   -0x18(%ebp)
  800907:	a1 60 30 80 00       	mov    0x803060,%eax
  80090c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800912:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800915:	39 c2                	cmp    %eax,%edx
  800917:	77 85                	ja     80089e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800919:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80091d:	75 14                	jne    800933 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80091f:	83 ec 04             	sub    $0x4,%esp
  800922:	68 78 27 80 00       	push   $0x802778
  800927:	6a 3a                	push   $0x3a
  800929:	68 6c 27 80 00       	push   $0x80276c
  80092e:	e8 88 fe ff ff       	call   8007bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800933:	ff 45 f0             	incl   -0x10(%ebp)
  800936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800939:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80093c:	0f 8c 2f ff ff ff    	jl     800871 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800942:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800949:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800950:	eb 26                	jmp    800978 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800952:	a1 60 30 80 00       	mov    0x803060,%eax
  800957:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80095d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800960:	89 d0                	mov    %edx,%eax
  800962:	01 c0                	add    %eax,%eax
  800964:	01 d0                	add    %edx,%eax
  800966:	c1 e0 03             	shl    $0x3,%eax
  800969:	01 c8                	add    %ecx,%eax
  80096b:	8a 40 04             	mov    0x4(%eax),%al
  80096e:	3c 01                	cmp    $0x1,%al
  800970:	75 03                	jne    800975 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800972:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800975:	ff 45 e0             	incl   -0x20(%ebp)
  800978:	a1 60 30 80 00       	mov    0x803060,%eax
  80097d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800983:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800986:	39 c2                	cmp    %eax,%edx
  800988:	77 c8                	ja     800952 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80098a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800990:	74 14                	je     8009a6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800992:	83 ec 04             	sub    $0x4,%esp
  800995:	68 cc 27 80 00       	push   $0x8027cc
  80099a:	6a 44                	push   $0x44
  80099c:	68 6c 27 80 00       	push   $0x80276c
  8009a1:	e8 15 fe ff ff       	call   8007bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009a6:	90                   	nop
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	53                   	push   %ebx
  8009ad:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8009b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bb:	89 0a                	mov    %ecx,(%edx)
  8009bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c0:	88 d1                	mov    %dl,%cl
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009d3:	75 30                	jne    800a05 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009d5:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  8009db:	a0 84 30 80 00       	mov    0x803084,%al
  8009e0:	0f b6 c0             	movzbl %al,%eax
  8009e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e6:	8b 09                	mov    (%ecx),%ecx
  8009e8:	89 cb                	mov    %ecx,%ebx
  8009ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ed:	83 c1 08             	add    $0x8,%ecx
  8009f0:	52                   	push   %edx
  8009f1:	50                   	push   %eax
  8009f2:	53                   	push   %ebx
  8009f3:	51                   	push   %ecx
  8009f4:	e8 a0 0f 00 00       	call   801999 <sys_cputs>
  8009f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a08:	8b 40 04             	mov    0x4(%eax),%eax
  800a0b:	8d 50 01             	lea    0x1(%eax),%edx
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a11:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a14:	90                   	nop
  800a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a23:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a2a:	00 00 00 
	b.cnt = 0;
  800a2d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a34:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	ff 75 08             	pushl  0x8(%ebp)
  800a3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a43:	50                   	push   %eax
  800a44:	68 a9 09 80 00       	push   $0x8009a9
  800a49:	e8 5a 02 00 00       	call   800ca8 <vprintfmt>
  800a4e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a51:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  800a57:	a0 84 30 80 00       	mov    0x803084,%al
  800a5c:	0f b6 c0             	movzbl %al,%eax
  800a5f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a65:	52                   	push   %edx
  800a66:	50                   	push   %eax
  800a67:	51                   	push   %ecx
  800a68:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a6e:	83 c0 08             	add    $0x8,%eax
  800a71:	50                   	push   %eax
  800a72:	e8 22 0f 00 00       	call   801999 <sys_cputs>
  800a77:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a7a:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  800a81:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    

00800a89 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a8f:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  800a96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	e8 6f ff ff ff       	call   800a1a <vcprintf>
  800aab:	83 c4 10             	add    $0x10,%esp
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab4:	c9                   	leave  
  800ab5:	c3                   	ret    

00800ab6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800abc:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	c1 e0 08             	shl    $0x8,%eax
  800ac9:	a3 5c b1 81 00       	mov    %eax,0x81b15c
	va_start(ap, fmt);
  800ace:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae0:	50                   	push   %eax
  800ae1:	e8 34 ff ff ff       	call   800a1a <vcprintf>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800aec:	c7 05 5c b1 81 00 00 	movl   $0x700,0x81b15c
  800af3:	07 00 00 

	return cnt;
  800af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af9:	c9                   	leave  
  800afa:	c3                   	ret    

00800afb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b01:	e8 d7 0e 00 00       	call   8019dd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b06:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 f4             	pushl  -0xc(%ebp)
  800b15:	50                   	push   %eax
  800b16:	e8 ff fe ff ff       	call   800a1a <vcprintf>
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b21:	e8 d1 0e 00 00       	call   8019f7 <sys_unlock_cons>
	return cnt;
  800b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	53                   	push   %ebx
  800b2f:	83 ec 14             	sub    $0x14,%esp
  800b32:	8b 45 10             	mov    0x10(%ebp),%eax
  800b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b3e:	8b 45 18             	mov    0x18(%ebp),%eax
  800b41:	ba 00 00 00 00       	mov    $0x0,%edx
  800b46:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b49:	77 55                	ja     800ba0 <printnum+0x75>
  800b4b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b4e:	72 05                	jb     800b55 <printnum+0x2a>
  800b50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b53:	77 4b                	ja     800ba0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b55:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b58:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b5b:	8b 45 18             	mov    0x18(%ebp),%eax
  800b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b63:	52                   	push   %edx
  800b64:	50                   	push   %eax
  800b65:	ff 75 f4             	pushl  -0xc(%ebp)
  800b68:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6b:	e8 a8 13 00 00       	call   801f18 <__udivdi3>
  800b70:	83 c4 10             	add    $0x10,%esp
  800b73:	83 ec 04             	sub    $0x4,%esp
  800b76:	ff 75 20             	pushl  0x20(%ebp)
  800b79:	53                   	push   %ebx
  800b7a:	ff 75 18             	pushl  0x18(%ebp)
  800b7d:	52                   	push   %edx
  800b7e:	50                   	push   %eax
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	ff 75 08             	pushl  0x8(%ebp)
  800b85:	e8 a1 ff ff ff       	call   800b2b <printnum>
  800b8a:	83 c4 20             	add    $0x20,%esp
  800b8d:	eb 1a                	jmp    800ba9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	ff 75 20             	pushl  0x20(%ebp)
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ba0:	ff 4d 1c             	decl   0x1c(%ebp)
  800ba3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ba7:	7f e6                	jg     800b8f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ba9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb7:	53                   	push   %ebx
  800bb8:	51                   	push   %ecx
  800bb9:	52                   	push   %edx
  800bba:	50                   	push   %eax
  800bbb:	e8 68 14 00 00       	call   802028 <__umoddi3>
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	05 34 2a 80 00       	add    $0x802a34,%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	0f be c0             	movsbl %al,%eax
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	50                   	push   %eax
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	ff d0                	call   *%eax
  800bd9:	83 c4 10             	add    $0x10,%esp
}
  800bdc:	90                   	nop
  800bdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800be5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800be9:	7e 1c                	jle    800c07 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 08             	lea    0x8(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 08             	sub    $0x8,%eax
  800c00:	8b 50 04             	mov    0x4(%eax),%edx
  800c03:	8b 00                	mov    (%eax),%eax
  800c05:	eb 40                	jmp    800c47 <getuint+0x65>
	else if (lflag)
  800c07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0b:	74 1e                	je     800c2b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 50 04             	lea    0x4(%eax),%edx
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	89 10                	mov    %edx,(%eax)
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8b 00                	mov    (%eax),%eax
  800c1f:	83 e8 04             	sub    $0x4,%eax
  800c22:	8b 00                	mov    (%eax),%eax
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	eb 1c                	jmp    800c47 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	8d 50 04             	lea    0x4(%eax),%edx
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 10                	mov    %edx,(%eax)
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 00                	mov    (%eax),%eax
  800c3d:	83 e8 04             	sub    $0x4,%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c4c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c50:	7e 1c                	jle    800c6e <getint+0x25>
		return va_arg(*ap, long long);
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	8d 50 08             	lea    0x8(%eax),%edx
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	89 10                	mov    %edx,(%eax)
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 00                	mov    (%eax),%eax
  800c64:	83 e8 08             	sub    $0x8,%eax
  800c67:	8b 50 04             	mov    0x4(%eax),%edx
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	eb 38                	jmp    800ca6 <getint+0x5d>
	else if (lflag)
  800c6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c72:	74 1a                	je     800c8e <getint+0x45>
		return va_arg(*ap, long);
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8b 00                	mov    (%eax),%eax
  800c79:	8d 50 04             	lea    0x4(%eax),%edx
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 10                	mov    %edx,(%eax)
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8b 00                	mov    (%eax),%eax
  800c86:	83 e8 04             	sub    $0x4,%eax
  800c89:	8b 00                	mov    (%eax),%eax
  800c8b:	99                   	cltd   
  800c8c:	eb 18                	jmp    800ca6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8b 00                	mov    (%eax),%eax
  800c93:	8d 50 04             	lea    0x4(%eax),%edx
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	89 10                	mov    %edx,(%eax)
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	83 e8 04             	sub    $0x4,%eax
  800ca3:	8b 00                	mov    (%eax),%eax
  800ca5:	99                   	cltd   
}
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	56                   	push   %esi
  800cac:	53                   	push   %ebx
  800cad:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb0:	eb 17                	jmp    800cc9 <vprintfmt+0x21>
			if (ch == '\0')
  800cb2:	85 db                	test   %ebx,%ebx
  800cb4:	0f 84 c1 03 00 00    	je     80107b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	53                   	push   %ebx
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	ff d0                	call   *%eax
  800cc6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccc:	8d 50 01             	lea    0x1(%eax),%edx
  800ccf:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	0f b6 d8             	movzbl %al,%ebx
  800cd7:	83 fb 25             	cmp    $0x25,%ebx
  800cda:	75 d6                	jne    800cb2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cdc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ce0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ce7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cf5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 10             	mov    %edx,0x10(%ebp)
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	0f b6 d8             	movzbl %al,%ebx
  800d0a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d0d:	83 f8 5b             	cmp    $0x5b,%eax
  800d10:	0f 87 3d 03 00 00    	ja     801053 <vprintfmt+0x3ab>
  800d16:	8b 04 85 58 2a 80 00 	mov    0x802a58(,%eax,4),%eax
  800d1d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d1f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d23:	eb d7                	jmp    800cfc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d25:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d29:	eb d1                	jmp    800cfc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d35:	89 d0                	mov    %edx,%eax
  800d37:	c1 e0 02             	shl    $0x2,%eax
  800d3a:	01 d0                	add    %edx,%eax
  800d3c:	01 c0                	add    %eax,%eax
  800d3e:	01 d8                	add    %ebx,%eax
  800d40:	83 e8 30             	sub    $0x30,%eax
  800d43:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d46:	8b 45 10             	mov    0x10(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d4e:	83 fb 2f             	cmp    $0x2f,%ebx
  800d51:	7e 3e                	jle    800d91 <vprintfmt+0xe9>
  800d53:	83 fb 39             	cmp    $0x39,%ebx
  800d56:	7f 39                	jg     800d91 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d58:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d5b:	eb d5                	jmp    800d32 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d71:	eb 1f                	jmp    800d92 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d77:	79 83                	jns    800cfc <vprintfmt+0x54>
				width = 0;
  800d79:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d80:	e9 77 ff ff ff       	jmp    800cfc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d85:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d8c:	e9 6b ff ff ff       	jmp    800cfc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d91:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d96:	0f 89 60 ff ff ff    	jns    800cfc <vprintfmt+0x54>
				width = precision, precision = -1;
  800d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800da2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800da9:	e9 4e ff ff ff       	jmp    800cfc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dae:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800db1:	e9 46 ff ff ff       	jmp    800cfc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800db6:	8b 45 14             	mov    0x14(%ebp),%eax
  800db9:	83 c0 04             	add    $0x4,%eax
  800dbc:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc2:	83 e8 04             	sub    $0x4,%eax
  800dc5:	8b 00                	mov    (%eax),%eax
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	ff 75 0c             	pushl  0xc(%ebp)
  800dcd:	50                   	push   %eax
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	ff d0                	call   *%eax
  800dd3:	83 c4 10             	add    $0x10,%esp
			break;
  800dd6:	e9 9b 02 00 00       	jmp    801076 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ddb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dde:	83 c0 04             	add    $0x4,%eax
  800de1:	89 45 14             	mov    %eax,0x14(%ebp)
  800de4:	8b 45 14             	mov    0x14(%ebp),%eax
  800de7:	83 e8 04             	sub    $0x4,%eax
  800dea:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dec:	85 db                	test   %ebx,%ebx
  800dee:	79 02                	jns    800df2 <vprintfmt+0x14a>
				err = -err;
  800df0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800df2:	83 fb 64             	cmp    $0x64,%ebx
  800df5:	7f 0b                	jg     800e02 <vprintfmt+0x15a>
  800df7:	8b 34 9d a0 28 80 00 	mov    0x8028a0(,%ebx,4),%esi
  800dfe:	85 f6                	test   %esi,%esi
  800e00:	75 19                	jne    800e1b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e02:	53                   	push   %ebx
  800e03:	68 45 2a 80 00       	push   $0x802a45
  800e08:	ff 75 0c             	pushl  0xc(%ebp)
  800e0b:	ff 75 08             	pushl  0x8(%ebp)
  800e0e:	e8 70 02 00 00       	call   801083 <printfmt>
  800e13:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e16:	e9 5b 02 00 00       	jmp    801076 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e1b:	56                   	push   %esi
  800e1c:	68 4e 2a 80 00       	push   $0x802a4e
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	ff 75 08             	pushl  0x8(%ebp)
  800e27:	e8 57 02 00 00       	call   801083 <printfmt>
  800e2c:	83 c4 10             	add    $0x10,%esp
			break;
  800e2f:	e9 42 02 00 00       	jmp    801076 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e34:	8b 45 14             	mov    0x14(%ebp),%eax
  800e37:	83 c0 04             	add    $0x4,%eax
  800e3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e40:	83 e8 04             	sub    $0x4,%eax
  800e43:	8b 30                	mov    (%eax),%esi
  800e45:	85 f6                	test   %esi,%esi
  800e47:	75 05                	jne    800e4e <vprintfmt+0x1a6>
				p = "(null)";
  800e49:	be 51 2a 80 00       	mov    $0x802a51,%esi
			if (width > 0 && padc != '-')
  800e4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e52:	7e 6d                	jle    800ec1 <vprintfmt+0x219>
  800e54:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e58:	74 67                	je     800ec1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	50                   	push   %eax
  800e61:	56                   	push   %esi
  800e62:	e8 1e 03 00 00       	call   801185 <strnlen>
  800e67:	83 c4 10             	add    $0x10,%esp
  800e6a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e6d:	eb 16                	jmp    800e85 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e6f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e73:	83 ec 08             	sub    $0x8,%esp
  800e76:	ff 75 0c             	pushl  0xc(%ebp)
  800e79:	50                   	push   %eax
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	ff d0                	call   *%eax
  800e7f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e82:	ff 4d e4             	decl   -0x1c(%ebp)
  800e85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e89:	7f e4                	jg     800e6f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8b:	eb 34                	jmp    800ec1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e91:	74 1c                	je     800eaf <vprintfmt+0x207>
  800e93:	83 fb 1f             	cmp    $0x1f,%ebx
  800e96:	7e 05                	jle    800e9d <vprintfmt+0x1f5>
  800e98:	83 fb 7e             	cmp    $0x7e,%ebx
  800e9b:	7e 12                	jle    800eaf <vprintfmt+0x207>
					putch('?', putdat);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	6a 3f                	push   $0x3f
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	ff d0                	call   *%eax
  800eaa:	83 c4 10             	add    $0x10,%esp
  800ead:	eb 0f                	jmp    800ebe <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eaf:	83 ec 08             	sub    $0x8,%esp
  800eb2:	ff 75 0c             	pushl  0xc(%ebp)
  800eb5:	53                   	push   %ebx
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	ff d0                	call   *%eax
  800ebb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebe:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec1:	89 f0                	mov    %esi,%eax
  800ec3:	8d 70 01             	lea    0x1(%eax),%esi
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f be d8             	movsbl %al,%ebx
  800ecb:	85 db                	test   %ebx,%ebx
  800ecd:	74 24                	je     800ef3 <vprintfmt+0x24b>
  800ecf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ed3:	78 b8                	js     800e8d <vprintfmt+0x1e5>
  800ed5:	ff 4d e0             	decl   -0x20(%ebp)
  800ed8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800edc:	79 af                	jns    800e8d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ede:	eb 13                	jmp    800ef3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	ff 75 0c             	pushl  0xc(%ebp)
  800ee6:	6a 20                	push   $0x20
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	ff d0                	call   *%eax
  800eed:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ef3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef7:	7f e7                	jg     800ee0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ef9:	e9 78 01 00 00       	jmp    801076 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800efe:	83 ec 08             	sub    $0x8,%esp
  800f01:	ff 75 e8             	pushl  -0x18(%ebp)
  800f04:	8d 45 14             	lea    0x14(%ebp),%eax
  800f07:	50                   	push   %eax
  800f08:	e8 3c fd ff ff       	call   800c49 <getint>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1c:	85 d2                	test   %edx,%edx
  800f1e:	79 23                	jns    800f43 <vprintfmt+0x29b>
				putch('-', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 2d                	push   $0x2d
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f36:	f7 d8                	neg    %eax
  800f38:	83 d2 00             	adc    $0x0,%edx
  800f3b:	f7 da                	neg    %edx
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f43:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f4a:	e9 bc 00 00 00       	jmp    80100b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 e8             	pushl  -0x18(%ebp)
  800f55:	8d 45 14             	lea    0x14(%ebp),%eax
  800f58:	50                   	push   %eax
  800f59:	e8 84 fc ff ff       	call   800be2 <getuint>
  800f5e:	83 c4 10             	add    $0x10,%esp
  800f61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f6e:	e9 98 00 00 00       	jmp    80100b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	ff 75 0c             	pushl  0xc(%ebp)
  800f79:	6a 58                	push   $0x58
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	ff d0                	call   *%eax
  800f80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f83:	83 ec 08             	sub    $0x8,%esp
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	6a 58                	push   $0x58
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	ff d0                	call   *%eax
  800f90:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f93:	83 ec 08             	sub    $0x8,%esp
  800f96:	ff 75 0c             	pushl  0xc(%ebp)
  800f99:	6a 58                	push   $0x58
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	ff d0                	call   *%eax
  800fa0:	83 c4 10             	add    $0x10,%esp
			break;
  800fa3:	e9 ce 00 00 00       	jmp    801076 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	ff 75 0c             	pushl  0xc(%ebp)
  800fae:	6a 30                	push   $0x30
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	ff d0                	call   *%eax
  800fb5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 78                	push   $0x78
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	83 c0 04             	add    $0x4,%eax
  800fce:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd4:	83 e8 04             	sub    $0x4,%eax
  800fd7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fe3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fea:	eb 1f                	jmp    80100b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fec:	83 ec 08             	sub    $0x8,%esp
  800fef:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff5:	50                   	push   %eax
  800ff6:	e8 e7 fb ff ff       	call   800be2 <getuint>
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801001:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801004:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80100b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80100f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801012:	83 ec 04             	sub    $0x4,%esp
  801015:	52                   	push   %edx
  801016:	ff 75 e4             	pushl  -0x1c(%ebp)
  801019:	50                   	push   %eax
  80101a:	ff 75 f4             	pushl  -0xc(%ebp)
  80101d:	ff 75 f0             	pushl  -0x10(%ebp)
  801020:	ff 75 0c             	pushl  0xc(%ebp)
  801023:	ff 75 08             	pushl  0x8(%ebp)
  801026:	e8 00 fb ff ff       	call   800b2b <printnum>
  80102b:	83 c4 20             	add    $0x20,%esp
			break;
  80102e:	eb 46                	jmp    801076 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	53                   	push   %ebx
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	ff d0                	call   *%eax
  80103c:	83 c4 10             	add    $0x10,%esp
			break;
  80103f:	eb 35                	jmp    801076 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801041:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  801048:	eb 2c                	jmp    801076 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80104a:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  801051:	eb 23                	jmp    801076 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801053:	83 ec 08             	sub    $0x8,%esp
  801056:	ff 75 0c             	pushl  0xc(%ebp)
  801059:	6a 25                	push   $0x25
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	ff d0                	call   *%eax
  801060:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801063:	ff 4d 10             	decl   0x10(%ebp)
  801066:	eb 03                	jmp    80106b <vprintfmt+0x3c3>
  801068:	ff 4d 10             	decl   0x10(%ebp)
  80106b:	8b 45 10             	mov    0x10(%ebp),%eax
  80106e:	48                   	dec    %eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 25                	cmp    $0x25,%al
  801073:	75 f3                	jne    801068 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801075:	90                   	nop
		}
	}
  801076:	e9 35 fc ff ff       	jmp    800cb0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80107b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80107c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801089:	8d 45 10             	lea    0x10(%ebp),%eax
  80108c:	83 c0 04             	add    $0x4,%eax
  80108f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801092:	8b 45 10             	mov    0x10(%ebp),%eax
  801095:	ff 75 f4             	pushl  -0xc(%ebp)
  801098:	50                   	push   %eax
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	ff 75 08             	pushl  0x8(%ebp)
  80109f:	e8 04 fc ff ff       	call   800ca8 <vprintfmt>
  8010a4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010a7:	90                   	nop
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	8b 40 08             	mov    0x8(%eax),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bf:	8b 10                	mov    (%eax),%edx
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8b 40 04             	mov    0x4(%eax),%eax
  8010c7:	39 c2                	cmp    %eax,%edx
  8010c9:	73 12                	jae    8010dd <sprintputch+0x33>
		*b->buf++ = ch;
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	8b 00                	mov    (%eax),%eax
  8010d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8010d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d6:	89 0a                	mov    %ecx,(%edx)
  8010d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010db:	88 10                	mov    %dl,(%eax)
}
  8010dd:	90                   	nop
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	01 d0                	add    %edx,%eax
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801101:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801105:	74 06                	je     80110d <vsnprintf+0x2d>
  801107:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80110b:	7f 07                	jg     801114 <vsnprintf+0x34>
		return -E_INVAL;
  80110d:	b8 03 00 00 00       	mov    $0x3,%eax
  801112:	eb 20                	jmp    801134 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801114:	ff 75 14             	pushl  0x14(%ebp)
  801117:	ff 75 10             	pushl  0x10(%ebp)
  80111a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80111d:	50                   	push   %eax
  80111e:	68 aa 10 80 00       	push   $0x8010aa
  801123:	e8 80 fb ff ff       	call   800ca8 <vprintfmt>
  801128:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80112b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80112e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801131:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80113c:	8d 45 10             	lea    0x10(%ebp),%eax
  80113f:	83 c0 04             	add    $0x4,%eax
  801142:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	ff 75 f4             	pushl  -0xc(%ebp)
  80114b:	50                   	push   %eax
  80114c:	ff 75 0c             	pushl  0xc(%ebp)
  80114f:	ff 75 08             	pushl  0x8(%ebp)
  801152:	e8 89 ff ff ff       	call   8010e0 <vsnprintf>
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80115d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801168:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80116f:	eb 06                	jmp    801177 <strlen+0x15>
		n++;
  801171:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801174:	ff 45 08             	incl   0x8(%ebp)
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	84 c0                	test   %al,%al
  80117e:	75 f1                	jne    801171 <strlen+0xf>
		n++;
	return n;
  801180:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801183:	c9                   	leave  
  801184:	c3                   	ret    

00801185 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80118b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801192:	eb 09                	jmp    80119d <strnlen+0x18>
		n++;
  801194:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801197:	ff 45 08             	incl   0x8(%ebp)
  80119a:	ff 4d 0c             	decl   0xc(%ebp)
  80119d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a1:	74 09                	je     8011ac <strnlen+0x27>
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	84 c0                	test   %al,%al
  8011aa:	75 e8                	jne    801194 <strnlen+0xf>
		n++;
	return n;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011bd:	90                   	nop
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8d 50 01             	lea    0x1(%eax),%edx
  8011c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d0:	8a 12                	mov    (%edx),%dl
  8011d2:	88 10                	mov    %dl,(%eax)
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	84 c0                	test   %al,%al
  8011d8:	75 e4                	jne    8011be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f2:	eb 1f                	jmp    801213 <strncpy+0x34>
		*dst++ = *src;
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8d 50 01             	lea    0x1(%eax),%edx
  8011fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8011fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801200:	8a 12                	mov    (%edx),%dl
  801202:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	84 c0                	test   %al,%al
  80120b:	74 03                	je     801210 <strncpy+0x31>
			src++;
  80120d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801210:	ff 45 fc             	incl   -0x4(%ebp)
  801213:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801216:	3b 45 10             	cmp    0x10(%ebp),%eax
  801219:	72 d9                	jb     8011f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	74 30                	je     801262 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801232:	eb 16                	jmp    80124a <strlcpy+0x2a>
			*dst++ = *src++;
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8d 50 01             	lea    0x1(%eax),%edx
  80123a:	89 55 08             	mov    %edx,0x8(%ebp)
  80123d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801240:	8d 4a 01             	lea    0x1(%edx),%ecx
  801243:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801246:	8a 12                	mov    (%edx),%dl
  801248:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80124a:	ff 4d 10             	decl   0x10(%ebp)
  80124d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801251:	74 09                	je     80125c <strlcpy+0x3c>
  801253:	8b 45 0c             	mov    0xc(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	84 c0                	test   %al,%al
  80125a:	75 d8                	jne    801234 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801262:	8b 55 08             	mov    0x8(%ebp),%edx
  801265:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801268:	29 c2                	sub    %eax,%edx
  80126a:	89 d0                	mov    %edx,%eax
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801271:	eb 06                	jmp    801279 <strcmp+0xb>
		p++, q++;
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 0e                	je     801290 <strcmp+0x22>
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 10                	mov    (%eax),%dl
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	38 c2                	cmp    %al,%dl
  80128e:	74 e3                	je     801273 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	0f b6 d0             	movzbl %al,%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	0f b6 c0             	movzbl %al,%eax
  8012a0:	29 c2                	sub    %eax,%edx
  8012a2:	89 d0                	mov    %edx,%eax
}
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    

008012a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012a9:	eb 09                	jmp    8012b4 <strncmp+0xe>
		n--, p++, q++;
  8012ab:	ff 4d 10             	decl   0x10(%ebp)
  8012ae:	ff 45 08             	incl   0x8(%ebp)
  8012b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b8:	74 17                	je     8012d1 <strncmp+0x2b>
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	84 c0                	test   %al,%al
  8012c1:	74 0e                	je     8012d1 <strncmp+0x2b>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 10                	mov    (%eax),%dl
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	38 c2                	cmp    %al,%dl
  8012cf:	74 da                	je     8012ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d5:	75 07                	jne    8012de <strncmp+0x38>
		return 0;
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dc:	eb 14                	jmp    8012f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	0f b6 d0             	movzbl %al,%edx
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	0f b6 c0             	movzbl %al,%eax
  8012ee:	29 c2                	sub    %eax,%edx
  8012f0:	89 d0                	mov    %edx,%eax
}
  8012f2:	5d                   	pop    %ebp
  8012f3:	c3                   	ret    

008012f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801300:	eb 12                	jmp    801314 <strchr+0x20>
		if (*s == c)
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	8a 00                	mov    (%eax),%al
  801307:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80130a:	75 05                	jne    801311 <strchr+0x1d>
			return (char *) s;
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	eb 11                	jmp    801322 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801311:	ff 45 08             	incl   0x8(%ebp)
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	84 c0                	test   %al,%al
  80131b:	75 e5                	jne    801302 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80131d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 04             	sub    $0x4,%esp
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801330:	eb 0d                	jmp    80133f <strfind+0x1b>
		if (*s == c)
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80133a:	74 0e                	je     80134a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80133c:	ff 45 08             	incl   0x8(%ebp)
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	84 c0                	test   %al,%al
  801346:	75 ea                	jne    801332 <strfind+0xe>
  801348:	eb 01                	jmp    80134b <strfind+0x27>
		if (*s == c)
			break;
  80134a:	90                   	nop
	return (char *) s;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80135c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801360:	76 63                	jbe    8013c5 <memset+0x75>
		uint64 data_block = c;
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	99                   	cltd   
  801366:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801369:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80136c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801372:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801376:	c1 e0 08             	shl    $0x8,%eax
  801379:	09 45 f0             	or     %eax,-0x10(%ebp)
  80137c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80137f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801385:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801389:	c1 e0 10             	shl    $0x10,%eax
  80138c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80138f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801398:	89 c2                	mov    %eax,%edx
  80139a:	b8 00 00 00 00       	mov    $0x0,%eax
  80139f:	09 45 f0             	or     %eax,-0x10(%ebp)
  8013a2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8013a5:	eb 18                	jmp    8013bf <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8013a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013aa:	8d 41 08             	lea    0x8(%ecx),%eax
  8013ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b6:	89 01                	mov    %eax,(%ecx)
  8013b8:	89 51 04             	mov    %edx,0x4(%ecx)
  8013bb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8013bf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013c3:	77 e2                	ja     8013a7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8013c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c9:	74 23                	je     8013ee <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8013cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013d1:	eb 0e                	jmp    8013e1 <memset+0x91>
			*p8++ = (uint8)c;
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	8d 50 01             	lea    0x1(%eax),%edx
  8013d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013df:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8013e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	75 e5                	jne    8013d3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801405:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801409:	76 24                	jbe    80142f <memcpy+0x3c>
		while(n >= 8){
  80140b:	eb 1c                	jmp    801429 <memcpy+0x36>
			*d64 = *s64;
  80140d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801410:	8b 50 04             	mov    0x4(%eax),%edx
  801413:	8b 00                	mov    (%eax),%eax
  801415:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801418:	89 01                	mov    %eax,(%ecx)
  80141a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80141d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801421:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801425:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801429:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80142d:	77 de                	ja     80140d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80142f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801433:	74 31                	je     801466 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801438:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80143b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801441:	eb 16                	jmp    801459 <memcpy+0x66>
			*d8++ = *s8++;
  801443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801446:	8d 50 01             	lea    0x1(%eax),%edx
  801449:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80144c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801452:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801455:	8a 12                	mov    (%edx),%dl
  801457:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801459:	8b 45 10             	mov    0x10(%ebp),%eax
  80145c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80145f:	89 55 10             	mov    %edx,0x10(%ebp)
  801462:	85 c0                	test   %eax,%eax
  801464:	75 dd                	jne    801443 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80147d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801480:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801483:	73 50                	jae    8014d5 <memmove+0x6a>
  801485:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	01 d0                	add    %edx,%eax
  80148d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801490:	76 43                	jbe    8014d5 <memmove+0x6a>
		s += n;
  801492:	8b 45 10             	mov    0x10(%ebp),%eax
  801495:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801498:	8b 45 10             	mov    0x10(%ebp),%eax
  80149b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80149e:	eb 10                	jmp    8014b0 <memmove+0x45>
			*--d = *--s;
  8014a0:	ff 4d f8             	decl   -0x8(%ebp)
  8014a3:	ff 4d fc             	decl   -0x4(%ebp)
  8014a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a9:	8a 10                	mov    (%eax),%dl
  8014ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ae:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	75 e3                	jne    8014a0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014bd:	eb 23                	jmp    8014e2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c2:	8d 50 01             	lea    0x1(%eax),%edx
  8014c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014d1:	8a 12                	mov    (%edx),%dl
  8014d3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014db:	89 55 10             	mov    %edx,0x10(%ebp)
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	75 dd                	jne    8014bf <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014f9:	eb 2a                	jmp    801525 <memcmp+0x3e>
		if (*s1 != *s2)
  8014fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fe:	8a 10                	mov    (%eax),%dl
  801500:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801503:	8a 00                	mov    (%eax),%al
  801505:	38 c2                	cmp    %al,%dl
  801507:	74 16                	je     80151f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801509:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80150c:	8a 00                	mov    (%eax),%al
  80150e:	0f b6 d0             	movzbl %al,%edx
  801511:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	0f b6 c0             	movzbl %al,%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
  80151d:	eb 18                	jmp    801537 <memcmp+0x50>
		s1++, s2++;
  80151f:	ff 45 fc             	incl   -0x4(%ebp)
  801522:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801525:	8b 45 10             	mov    0x10(%ebp),%eax
  801528:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152b:	89 55 10             	mov    %edx,0x10(%ebp)
  80152e:	85 c0                	test   %eax,%eax
  801530:	75 c9                	jne    8014fb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80153f:	8b 55 08             	mov    0x8(%ebp),%edx
  801542:	8b 45 10             	mov    0x10(%ebp),%eax
  801545:	01 d0                	add    %edx,%eax
  801547:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80154a:	eb 15                	jmp    801561 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f b6 d0             	movzbl %al,%edx
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	0f b6 c0             	movzbl %al,%eax
  80155a:	39 c2                	cmp    %eax,%edx
  80155c:	74 0d                	je     80156b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80155e:	ff 45 08             	incl   0x8(%ebp)
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801567:	72 e3                	jb     80154c <memfind+0x13>
  801569:	eb 01                	jmp    80156c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80156b:	90                   	nop
	return (void *) s;
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801577:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80157e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801585:	eb 03                	jmp    80158a <strtol+0x19>
		s++;
  801587:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	3c 20                	cmp    $0x20,%al
  801591:	74 f4                	je     801587 <strtol+0x16>
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	3c 09                	cmp    $0x9,%al
  80159a:	74 eb                	je     801587 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	3c 2b                	cmp    $0x2b,%al
  8015a3:	75 05                	jne    8015aa <strtol+0x39>
		s++;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
  8015a8:	eb 13                	jmp    8015bd <strtol+0x4c>
	else if (*s == '-')
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	3c 2d                	cmp    $0x2d,%al
  8015b1:	75 0a                	jne    8015bd <strtol+0x4c>
		s++, neg = 1;
  8015b3:	ff 45 08             	incl   0x8(%ebp)
  8015b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c1:	74 06                	je     8015c9 <strtol+0x58>
  8015c3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015c7:	75 20                	jne    8015e9 <strtol+0x78>
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8a 00                	mov    (%eax),%al
  8015ce:	3c 30                	cmp    $0x30,%al
  8015d0:	75 17                	jne    8015e9 <strtol+0x78>
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	40                   	inc    %eax
  8015d6:	8a 00                	mov    (%eax),%al
  8015d8:	3c 78                	cmp    $0x78,%al
  8015da:	75 0d                	jne    8015e9 <strtol+0x78>
		s += 2, base = 16;
  8015dc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015e0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015e7:	eb 28                	jmp    801611 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ed:	75 15                	jne    801604 <strtol+0x93>
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	3c 30                	cmp    $0x30,%al
  8015f6:	75 0c                	jne    801604 <strtol+0x93>
		s++, base = 8;
  8015f8:	ff 45 08             	incl   0x8(%ebp)
  8015fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801602:	eb 0d                	jmp    801611 <strtol+0xa0>
	else if (base == 0)
  801604:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801608:	75 07                	jne    801611 <strtol+0xa0>
		base = 10;
  80160a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	3c 2f                	cmp    $0x2f,%al
  801618:	7e 19                	jle    801633 <strtol+0xc2>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 39                	cmp    $0x39,%al
  801621:	7f 10                	jg     801633 <strtol+0xc2>
			dig = *s - '0';
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	0f be c0             	movsbl %al,%eax
  80162b:	83 e8 30             	sub    $0x30,%eax
  80162e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801631:	eb 42                	jmp    801675 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 60                	cmp    $0x60,%al
  80163a:	7e 19                	jle    801655 <strtol+0xe4>
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	3c 7a                	cmp    $0x7a,%al
  801643:	7f 10                	jg     801655 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	8a 00                	mov    (%eax),%al
  80164a:	0f be c0             	movsbl %al,%eax
  80164d:	83 e8 57             	sub    $0x57,%eax
  801650:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801653:	eb 20                	jmp    801675 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 40                	cmp    $0x40,%al
  80165c:	7e 39                	jle    801697 <strtol+0x126>
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8a 00                	mov    (%eax),%al
  801663:	3c 5a                	cmp    $0x5a,%al
  801665:	7f 30                	jg     801697 <strtol+0x126>
			dig = *s - 'A' + 10;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8a 00                	mov    (%eax),%al
  80166c:	0f be c0             	movsbl %al,%eax
  80166f:	83 e8 37             	sub    $0x37,%eax
  801672:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801678:	3b 45 10             	cmp    0x10(%ebp),%eax
  80167b:	7d 19                	jge    801696 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80167d:	ff 45 08             	incl   0x8(%ebp)
  801680:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801683:	0f af 45 10          	imul   0x10(%ebp),%eax
  801687:	89 c2                	mov    %eax,%edx
  801689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168c:	01 d0                	add    %edx,%eax
  80168e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801691:	e9 7b ff ff ff       	jmp    801611 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801696:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169b:	74 08                	je     8016a5 <strtol+0x134>
		*endptr = (char *) s;
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016a9:	74 07                	je     8016b2 <strtol+0x141>
  8016ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ae:	f7 d8                	neg    %eax
  8016b0:	eb 03                	jmp    8016b5 <strtol+0x144>
  8016b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <ltostr>:

void
ltostr(long value, char *str)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cf:	79 13                	jns    8016e4 <ltostr+0x2d>
	{
		neg = 1;
  8016d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016db:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016de:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016e1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016ec:	99                   	cltd   
  8016ed:	f7 f9                	idiv   %ecx
  8016ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f5:	8d 50 01             	lea    0x1(%eax),%edx
  8016f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016fb:	89 c2                	mov    %eax,%edx
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	01 d0                	add    %edx,%eax
  801702:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801705:	83 c2 30             	add    $0x30,%edx
  801708:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80170a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801712:	f7 e9                	imul   %ecx
  801714:	c1 fa 02             	sar    $0x2,%edx
  801717:	89 c8                	mov    %ecx,%eax
  801719:	c1 f8 1f             	sar    $0x1f,%eax
  80171c:	29 c2                	sub    %eax,%edx
  80171e:	89 d0                	mov    %edx,%eax
  801720:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801723:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801727:	75 bb                	jne    8016e4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801729:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801730:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801733:	48                   	dec    %eax
  801734:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801737:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80173b:	74 3d                	je     80177a <ltostr+0xc3>
		start = 1 ;
  80173d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801744:	eb 34                	jmp    80177a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174c:	01 d0                	add    %edx,%eax
  80174e:	8a 00                	mov    (%eax),%al
  801750:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	01 c2                	add    %eax,%edx
  80175b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80175e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801761:	01 c8                	add    %ecx,%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801767:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80176a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176d:	01 c2                	add    %eax,%edx
  80176f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801772:	88 02                	mov    %al,(%edx)
		start++ ;
  801774:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801777:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80177a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801780:	7c c4                	jl     801746 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801782:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801796:	ff 75 08             	pushl  0x8(%ebp)
  801799:	e8 c4 f9 ff ff       	call   801162 <strlen>
  80179e:	83 c4 04             	add    $0x4,%esp
  8017a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	e8 b6 f9 ff ff       	call   801162 <strlen>
  8017ac:	83 c4 04             	add    $0x4,%esp
  8017af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017c0:	eb 17                	jmp    8017d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c8:	01 c2                	add    %eax,%edx
  8017ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	01 c8                	add    %ecx,%eax
  8017d2:	8a 00                	mov    (%eax),%al
  8017d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017d6:	ff 45 fc             	incl   -0x4(%ebp)
  8017d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017df:	7c e1                	jl     8017c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017ef:	eb 1f                	jmp    801810 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f4:	8d 50 01             	lea    0x1(%eax),%edx
  8017f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017fa:	89 c2                	mov    %eax,%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80180d:	ff 45 f8             	incl   -0x8(%ebp)
  801810:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801813:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801816:	7c d9                	jl     8017f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801818:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181b:	8b 45 10             	mov    0x10(%ebp),%eax
  80181e:	01 d0                	add    %edx,%eax
  801820:	c6 00 00             	movb   $0x0,(%eax)
}
  801823:	90                   	nop
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801829:	8b 45 14             	mov    0x14(%ebp),%eax
  80182c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801832:	8b 45 14             	mov    0x14(%ebp),%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	01 d0                	add    %edx,%eax
  801843:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801849:	eb 0c                	jmp    801857 <strsplit+0x31>
			*string++ = 0;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	8d 50 01             	lea    0x1(%eax),%edx
  801851:	89 55 08             	mov    %edx,0x8(%ebp)
  801854:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	84 c0                	test   %al,%al
  80185e:	74 18                	je     801878 <strsplit+0x52>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	0f be c0             	movsbl %al,%eax
  801868:	50                   	push   %eax
  801869:	ff 75 0c             	pushl  0xc(%ebp)
  80186c:	e8 83 fa ff ff       	call   8012f4 <strchr>
  801871:	83 c4 08             	add    $0x8,%esp
  801874:	85 c0                	test   %eax,%eax
  801876:	75 d3                	jne    80184b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	8a 00                	mov    (%eax),%al
  80187d:	84 c0                	test   %al,%al
  80187f:	74 5a                	je     8018db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801881:	8b 45 14             	mov    0x14(%ebp),%eax
  801884:	8b 00                	mov    (%eax),%eax
  801886:	83 f8 0f             	cmp    $0xf,%eax
  801889:	75 07                	jne    801892 <strsplit+0x6c>
		{
			return 0;
  80188b:	b8 00 00 00 00       	mov    $0x0,%eax
  801890:	eb 66                	jmp    8018f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801892:	8b 45 14             	mov    0x14(%ebp),%eax
  801895:	8b 00                	mov    (%eax),%eax
  801897:	8d 48 01             	lea    0x1(%eax),%ecx
  80189a:	8b 55 14             	mov    0x14(%ebp),%edx
  80189d:	89 0a                	mov    %ecx,(%edx)
  80189f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	01 c2                	add    %eax,%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018b0:	eb 03                	jmp    8018b5 <strsplit+0x8f>
			string++;
  8018b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	84 c0                	test   %al,%al
  8018bc:	74 8b                	je     801849 <strsplit+0x23>
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	0f be c0             	movsbl %al,%eax
  8018c6:	50                   	push   %eax
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	e8 25 fa ff ff       	call   8012f4 <strchr>
  8018cf:	83 c4 08             	add    $0x8,%esp
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	74 dc                	je     8018b2 <strsplit+0x8c>
			string++;
	}
  8018d6:	e9 6e ff ff ff       	jmp    801849 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018df:	8b 00                	mov    (%eax),%eax
  8018e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	01 d0                	add    %edx,%eax
  8018ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801906:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80190d:	eb 4a                	jmp    801959 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80190f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	01 c2                	add    %eax,%edx
  801917:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80191a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191d:	01 c8                	add    %ecx,%eax
  80191f:	8a 00                	mov    (%eax),%al
  801921:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801923:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801926:	8b 45 0c             	mov    0xc(%ebp),%eax
  801929:	01 d0                	add    %edx,%eax
  80192b:	8a 00                	mov    (%eax),%al
  80192d:	3c 40                	cmp    $0x40,%al
  80192f:	7e 25                	jle    801956 <str2lower+0x5c>
  801931:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801934:	8b 45 0c             	mov    0xc(%ebp),%eax
  801937:	01 d0                	add    %edx,%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 5a                	cmp    $0x5a,%al
  80193d:	7f 17                	jg     801956 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80193f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80194a:	8b 55 08             	mov    0x8(%ebp),%edx
  80194d:	01 ca                	add    %ecx,%edx
  80194f:	8a 12                	mov    (%edx),%dl
  801951:	83 c2 20             	add    $0x20,%edx
  801954:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801956:	ff 45 fc             	incl   -0x4(%ebp)
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	e8 01 f8 ff ff       	call   801162 <strlen>
  801961:	83 c4 04             	add    $0x4,%esp
  801964:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801967:	7f a6                	jg     80190f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801969:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	57                   	push   %edi
  801972:	56                   	push   %esi
  801973:	53                   	push   %ebx
  801974:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801980:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801983:	8b 7d 18             	mov    0x18(%ebp),%edi
  801986:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801989:	cd 30                	int    $0x30
  80198b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5f                   	pop    %edi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    

00801999 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8019a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	51                   	push   %ecx
  8019b2:	52                   	push   %edx
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	50                   	push   %eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	e8 b0 ff ff ff       	call   80196e <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	90                   	nop
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 02                	push   $0x2
  8019d3:	e8 96 ff ff ff       	call   80196e <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 03                	push   $0x3
  8019ec:	e8 7d ff ff ff       	call   80196e <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	90                   	nop
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 04                	push   $0x4
  801a06:	e8 63 ff ff ff       	call   80196e <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	90                   	nop
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	52                   	push   %edx
  801a21:	50                   	push   %eax
  801a22:	6a 08                	push   $0x8
  801a24:	e8 45 ff ff ff       	call   80196e <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	56                   	push   %esi
  801a32:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a33:	8b 75 18             	mov    0x18(%ebp),%esi
  801a36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	56                   	push   %esi
  801a43:	53                   	push   %ebx
  801a44:	51                   	push   %ecx
  801a45:	52                   	push   %edx
  801a46:	50                   	push   %eax
  801a47:	6a 09                	push   $0x9
  801a49:	e8 20 ff ff ff       	call   80196e <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a54:	5b                   	pop    %ebx
  801a55:	5e                   	pop    %esi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	6a 0a                	push   $0xa
  801a68:	e8 01 ff ff ff       	call   80196e <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	ff 75 08             	pushl  0x8(%ebp)
  801a81:	6a 0b                	push   $0xb
  801a83:	e8 e6 fe ff ff       	call   80196e <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 0c                	push   $0xc
  801a9c:	e8 cd fe ff ff       	call   80196e <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 0d                	push   $0xd
  801ab5:	e8 b4 fe ff ff       	call   80196e <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 0e                	push   $0xe
  801ace:	e8 9b fe ff ff       	call   80196e <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 0f                	push   $0xf
  801ae7:	e8 82 fe ff ff       	call   80196e <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	ff 75 08             	pushl  0x8(%ebp)
  801aff:	6a 10                	push   $0x10
  801b01:	e8 68 fe ff ff       	call   80196e <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 11                	push   $0x11
  801b1a:	e8 4f fe ff ff       	call   80196e <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	90                   	nop
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	83 ec 04             	sub    $0x4,%esp
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b31:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	50                   	push   %eax
  801b3e:	6a 01                	push   $0x1
  801b40:	e8 29 fe ff ff       	call   80196e <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	90                   	nop
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 14                	push   $0x14
  801b5a:	e8 0f fe ff ff       	call   80196e <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	90                   	nop
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b71:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b74:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	51                   	push   %ecx
  801b7e:	52                   	push   %edx
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	50                   	push   %eax
  801b83:	6a 15                	push   $0x15
  801b85:	e8 e4 fd ff ff       	call   80196e <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	52                   	push   %edx
  801b9f:	50                   	push   %eax
  801ba0:	6a 16                	push   $0x16
  801ba2:	e8 c7 fd ff ff       	call   80196e <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801baf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	51                   	push   %ecx
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 17                	push   $0x17
  801bc1:	e8 a8 fd ff ff       	call   80196e <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	52                   	push   %edx
  801bdb:	50                   	push   %eax
  801bdc:	6a 18                	push   $0x18
  801bde:	e8 8b fd ff ff       	call   80196e <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	6a 00                	push   $0x0
  801bf0:	ff 75 14             	pushl  0x14(%ebp)
  801bf3:	ff 75 10             	pushl  0x10(%ebp)
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	50                   	push   %eax
  801bfa:	6a 19                	push   $0x19
  801bfc:	e8 6d fd ff ff       	call   80196e <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	50                   	push   %eax
  801c15:	6a 1a                	push   $0x1a
  801c17:	e8 52 fd ff ff       	call   80196e <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	90                   	nop
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	50                   	push   %eax
  801c31:	6a 1b                	push   $0x1b
  801c33:	e8 36 fd ff ff       	call   80196e <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 05                	push   $0x5
  801c4c:	e8 1d fd ff ff       	call   80196e <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 06                	push   $0x6
  801c65:	e8 04 fd ff ff       	call   80196e <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 07                	push   $0x7
  801c7e:	e8 eb fc ff ff       	call   80196e <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_exit_env>:


void sys_exit_env(void)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 1c                	push   $0x1c
  801c97:	e8 d2 fc ff ff       	call   80196e <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	90                   	nop
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cab:	8d 50 04             	lea    0x4(%eax),%edx
  801cae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	6a 1d                	push   $0x1d
  801cbb:	e8 ae fc ff ff       	call   80196e <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ccc:	89 01                	mov    %eax,(%ecx)
  801cce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	c9                   	leave  
  801cd5:	c2 04 00             	ret    $0x4

00801cd8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	ff 75 10             	pushl  0x10(%ebp)
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	ff 75 08             	pushl  0x8(%ebp)
  801ce8:	6a 13                	push   $0x13
  801cea:	e8 7f fc ff ff       	call   80196e <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf2:	90                   	nop
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 1e                	push   $0x1e
  801d04:	e8 65 fc ff ff       	call   80196e <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 04             	sub    $0x4,%esp
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d1a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	50                   	push   %eax
  801d27:	6a 1f                	push   $0x1f
  801d29:	e8 40 fc ff ff       	call   80196e <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <rsttst>:
void rsttst()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 21                	push   $0x21
  801d43:	e8 26 fc ff ff       	call   80196e <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4b:	90                   	nop
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	8b 45 14             	mov    0x14(%ebp),%eax
  801d57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d5a:	8b 55 18             	mov    0x18(%ebp),%edx
  801d5d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d61:	52                   	push   %edx
  801d62:	50                   	push   %eax
  801d63:	ff 75 10             	pushl  0x10(%ebp)
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	ff 75 08             	pushl  0x8(%ebp)
  801d6c:	6a 20                	push   $0x20
  801d6e:	e8 fb fb ff ff       	call   80196e <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
	return ;
  801d76:	90                   	nop
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <chktst>:
void chktst(uint32 n)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	ff 75 08             	pushl  0x8(%ebp)
  801d87:	6a 22                	push   $0x22
  801d89:	e8 e0 fb ff ff       	call   80196e <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d91:	90                   	nop
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <inctst>:

void inctst()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 23                	push   $0x23
  801da3:	e8 c6 fb ff ff       	call   80196e <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dab:	90                   	nop
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <gettst>:
uint32 gettst()
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 24                	push   $0x24
  801dbd:	e8 ac fb ff ff       	call   80196e <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 25                	push   $0x25
  801dd6:	e8 93 fb ff ff       	call   80196e <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
  801dde:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	return uheapPlaceStrategy ;
  801de3:	a1 a0 b0 81 00       	mov    0x81b0a0,%eax
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 26                	push   $0x26
  801e02:	e8 67 fb ff ff       	call   80196e <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	6a 00                	push   $0x0
  801e1f:	53                   	push   %ebx
  801e20:	51                   	push   %ecx
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	6a 27                	push   $0x27
  801e25:	e8 44 fb ff ff       	call   80196e <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 28                	push   $0x28
  801e45:	e8 24 fb ff ff       	call   80196e <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e52:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	6a 00                	push   $0x0
  801e5d:	51                   	push   %ecx
  801e5e:	ff 75 10             	pushl  0x10(%ebp)
  801e61:	52                   	push   %edx
  801e62:	50                   	push   %eax
  801e63:	6a 29                	push   $0x29
  801e65:	e8 04 fb ff ff       	call   80196e <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	ff 75 10             	pushl  0x10(%ebp)
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	ff 75 08             	pushl  0x8(%ebp)
  801e7f:	6a 12                	push   $0x12
  801e81:	e8 e8 fa ff ff       	call   80196e <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
	return ;
  801e89:	90                   	nop
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	52                   	push   %edx
  801e9c:	50                   	push   %eax
  801e9d:	6a 2a                	push   $0x2a
  801e9f:	e8 ca fa ff ff       	call   80196e <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
	return;
  801ea7:	90                   	nop
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 2b                	push   $0x2b
  801eb9:	e8 b0 fa ff ff       	call   80196e <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	ff 75 0c             	pushl  0xc(%ebp)
  801ecf:	ff 75 08             	pushl  0x8(%ebp)
  801ed2:	6a 2d                	push   $0x2d
  801ed4:	e8 95 fa ff ff       	call   80196e <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
	return;
  801edc:	90                   	nop
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	ff 75 0c             	pushl  0xc(%ebp)
  801eeb:	ff 75 08             	pushl  0x8(%ebp)
  801eee:	6a 2c                	push   $0x2c
  801ef0:	e8 79 fa ff ff       	call   80196e <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef8:	90                   	nop
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	68 c8 2b 80 00       	push   $0x802bc8
  801f09:	68 25 01 00 00       	push   $0x125
  801f0e:	68 fb 2b 80 00       	push   $0x802bfb
  801f13:	e8 a3 e8 ff ff       	call   8007bb <_panic>

00801f18 <__udivdi3>:
  801f18:	55                   	push   %ebp
  801f19:	57                   	push   %edi
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
  801f1c:	83 ec 1c             	sub    $0x1c,%esp
  801f1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f2f:	89 ca                	mov    %ecx,%edx
  801f31:	89 f8                	mov    %edi,%eax
  801f33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f37:	85 f6                	test   %esi,%esi
  801f39:	75 2d                	jne    801f68 <__udivdi3+0x50>
  801f3b:	39 cf                	cmp    %ecx,%edi
  801f3d:	77 65                	ja     801fa4 <__udivdi3+0x8c>
  801f3f:	89 fd                	mov    %edi,%ebp
  801f41:	85 ff                	test   %edi,%edi
  801f43:	75 0b                	jne    801f50 <__udivdi3+0x38>
  801f45:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4a:	31 d2                	xor    %edx,%edx
  801f4c:	f7 f7                	div    %edi
  801f4e:	89 c5                	mov    %eax,%ebp
  801f50:	31 d2                	xor    %edx,%edx
  801f52:	89 c8                	mov    %ecx,%eax
  801f54:	f7 f5                	div    %ebp
  801f56:	89 c1                	mov    %eax,%ecx
  801f58:	89 d8                	mov    %ebx,%eax
  801f5a:	f7 f5                	div    %ebp
  801f5c:	89 cf                	mov    %ecx,%edi
  801f5e:	89 fa                	mov    %edi,%edx
  801f60:	83 c4 1c             	add    $0x1c,%esp
  801f63:	5b                   	pop    %ebx
  801f64:	5e                   	pop    %esi
  801f65:	5f                   	pop    %edi
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    
  801f68:	39 ce                	cmp    %ecx,%esi
  801f6a:	77 28                	ja     801f94 <__udivdi3+0x7c>
  801f6c:	0f bd fe             	bsr    %esi,%edi
  801f6f:	83 f7 1f             	xor    $0x1f,%edi
  801f72:	75 40                	jne    801fb4 <__udivdi3+0x9c>
  801f74:	39 ce                	cmp    %ecx,%esi
  801f76:	72 0a                	jb     801f82 <__udivdi3+0x6a>
  801f78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f7c:	0f 87 9e 00 00 00    	ja     802020 <__udivdi3+0x108>
  801f82:	b8 01 00 00 00       	mov    $0x1,%eax
  801f87:	89 fa                	mov    %edi,%edx
  801f89:	83 c4 1c             	add    $0x1c,%esp
  801f8c:	5b                   	pop    %ebx
  801f8d:	5e                   	pop    %esi
  801f8e:	5f                   	pop    %edi
  801f8f:	5d                   	pop    %ebp
  801f90:	c3                   	ret    
  801f91:	8d 76 00             	lea    0x0(%esi),%esi
  801f94:	31 ff                	xor    %edi,%edi
  801f96:	31 c0                	xor    %eax,%eax
  801f98:	89 fa                	mov    %edi,%edx
  801f9a:	83 c4 1c             	add    $0x1c,%esp
  801f9d:	5b                   	pop    %ebx
  801f9e:	5e                   	pop    %esi
  801f9f:	5f                   	pop    %edi
  801fa0:	5d                   	pop    %ebp
  801fa1:	c3                   	ret    
  801fa2:	66 90                	xchg   %ax,%ax
  801fa4:	89 d8                	mov    %ebx,%eax
  801fa6:	f7 f7                	div    %edi
  801fa8:	31 ff                	xor    %edi,%edi
  801faa:	89 fa                	mov    %edi,%edx
  801fac:	83 c4 1c             	add    $0x1c,%esp
  801faf:	5b                   	pop    %ebx
  801fb0:	5e                   	pop    %esi
  801fb1:	5f                   	pop    %edi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    
  801fb4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fb9:	89 eb                	mov    %ebp,%ebx
  801fbb:	29 fb                	sub    %edi,%ebx
  801fbd:	89 f9                	mov    %edi,%ecx
  801fbf:	d3 e6                	shl    %cl,%esi
  801fc1:	89 c5                	mov    %eax,%ebp
  801fc3:	88 d9                	mov    %bl,%cl
  801fc5:	d3 ed                	shr    %cl,%ebp
  801fc7:	89 e9                	mov    %ebp,%ecx
  801fc9:	09 f1                	or     %esi,%ecx
  801fcb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fcf:	89 f9                	mov    %edi,%ecx
  801fd1:	d3 e0                	shl    %cl,%eax
  801fd3:	89 c5                	mov    %eax,%ebp
  801fd5:	89 d6                	mov    %edx,%esi
  801fd7:	88 d9                	mov    %bl,%cl
  801fd9:	d3 ee                	shr    %cl,%esi
  801fdb:	89 f9                	mov    %edi,%ecx
  801fdd:	d3 e2                	shl    %cl,%edx
  801fdf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fe3:	88 d9                	mov    %bl,%cl
  801fe5:	d3 e8                	shr    %cl,%eax
  801fe7:	09 c2                	or     %eax,%edx
  801fe9:	89 d0                	mov    %edx,%eax
  801feb:	89 f2                	mov    %esi,%edx
  801fed:	f7 74 24 0c          	divl   0xc(%esp)
  801ff1:	89 d6                	mov    %edx,%esi
  801ff3:	89 c3                	mov    %eax,%ebx
  801ff5:	f7 e5                	mul    %ebp
  801ff7:	39 d6                	cmp    %edx,%esi
  801ff9:	72 19                	jb     802014 <__udivdi3+0xfc>
  801ffb:	74 0b                	je     802008 <__udivdi3+0xf0>
  801ffd:	89 d8                	mov    %ebx,%eax
  801fff:	31 ff                	xor    %edi,%edi
  802001:	e9 58 ff ff ff       	jmp    801f5e <__udivdi3+0x46>
  802006:	66 90                	xchg   %ax,%ax
  802008:	8b 54 24 08          	mov    0x8(%esp),%edx
  80200c:	89 f9                	mov    %edi,%ecx
  80200e:	d3 e2                	shl    %cl,%edx
  802010:	39 c2                	cmp    %eax,%edx
  802012:	73 e9                	jae    801ffd <__udivdi3+0xe5>
  802014:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802017:	31 ff                	xor    %edi,%edi
  802019:	e9 40 ff ff ff       	jmp    801f5e <__udivdi3+0x46>
  80201e:	66 90                	xchg   %ax,%ax
  802020:	31 c0                	xor    %eax,%eax
  802022:	e9 37 ff ff ff       	jmp    801f5e <__udivdi3+0x46>
  802027:	90                   	nop

00802028 <__umoddi3>:
  802028:	55                   	push   %ebp
  802029:	57                   	push   %edi
  80202a:	56                   	push   %esi
  80202b:	53                   	push   %ebx
  80202c:	83 ec 1c             	sub    $0x1c,%esp
  80202f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802033:	8b 74 24 34          	mov    0x34(%esp),%esi
  802037:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80203b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80203f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802043:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802047:	89 f3                	mov    %esi,%ebx
  802049:	89 fa                	mov    %edi,%edx
  80204b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80204f:	89 34 24             	mov    %esi,(%esp)
  802052:	85 c0                	test   %eax,%eax
  802054:	75 1a                	jne    802070 <__umoddi3+0x48>
  802056:	39 f7                	cmp    %esi,%edi
  802058:	0f 86 a2 00 00 00    	jbe    802100 <__umoddi3+0xd8>
  80205e:	89 c8                	mov    %ecx,%eax
  802060:	89 f2                	mov    %esi,%edx
  802062:	f7 f7                	div    %edi
  802064:	89 d0                	mov    %edx,%eax
  802066:	31 d2                	xor    %edx,%edx
  802068:	83 c4 1c             	add    $0x1c,%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	5f                   	pop    %edi
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    
  802070:	39 f0                	cmp    %esi,%eax
  802072:	0f 87 ac 00 00 00    	ja     802124 <__umoddi3+0xfc>
  802078:	0f bd e8             	bsr    %eax,%ebp
  80207b:	83 f5 1f             	xor    $0x1f,%ebp
  80207e:	0f 84 ac 00 00 00    	je     802130 <__umoddi3+0x108>
  802084:	bf 20 00 00 00       	mov    $0x20,%edi
  802089:	29 ef                	sub    %ebp,%edi
  80208b:	89 fe                	mov    %edi,%esi
  80208d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802091:	89 e9                	mov    %ebp,%ecx
  802093:	d3 e0                	shl    %cl,%eax
  802095:	89 d7                	mov    %edx,%edi
  802097:	89 f1                	mov    %esi,%ecx
  802099:	d3 ef                	shr    %cl,%edi
  80209b:	09 c7                	or     %eax,%edi
  80209d:	89 e9                	mov    %ebp,%ecx
  80209f:	d3 e2                	shl    %cl,%edx
  8020a1:	89 14 24             	mov    %edx,(%esp)
  8020a4:	89 d8                	mov    %ebx,%eax
  8020a6:	d3 e0                	shl    %cl,%eax
  8020a8:	89 c2                	mov    %eax,%edx
  8020aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020ae:	d3 e0                	shl    %cl,%eax
  8020b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020b8:	89 f1                	mov    %esi,%ecx
  8020ba:	d3 e8                	shr    %cl,%eax
  8020bc:	09 d0                	or     %edx,%eax
  8020be:	d3 eb                	shr    %cl,%ebx
  8020c0:	89 da                	mov    %ebx,%edx
  8020c2:	f7 f7                	div    %edi
  8020c4:	89 d3                	mov    %edx,%ebx
  8020c6:	f7 24 24             	mull   (%esp)
  8020c9:	89 c6                	mov    %eax,%esi
  8020cb:	89 d1                	mov    %edx,%ecx
  8020cd:	39 d3                	cmp    %edx,%ebx
  8020cf:	0f 82 87 00 00 00    	jb     80215c <__umoddi3+0x134>
  8020d5:	0f 84 91 00 00 00    	je     80216c <__umoddi3+0x144>
  8020db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020df:	29 f2                	sub    %esi,%edx
  8020e1:	19 cb                	sbb    %ecx,%ebx
  8020e3:	89 d8                	mov    %ebx,%eax
  8020e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020e9:	d3 e0                	shl    %cl,%eax
  8020eb:	89 e9                	mov    %ebp,%ecx
  8020ed:	d3 ea                	shr    %cl,%edx
  8020ef:	09 d0                	or     %edx,%eax
  8020f1:	89 e9                	mov    %ebp,%ecx
  8020f3:	d3 eb                	shr    %cl,%ebx
  8020f5:	89 da                	mov    %ebx,%edx
  8020f7:	83 c4 1c             	add    $0x1c,%esp
  8020fa:	5b                   	pop    %ebx
  8020fb:	5e                   	pop    %esi
  8020fc:	5f                   	pop    %edi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    
  8020ff:	90                   	nop
  802100:	89 fd                	mov    %edi,%ebp
  802102:	85 ff                	test   %edi,%edi
  802104:	75 0b                	jne    802111 <__umoddi3+0xe9>
  802106:	b8 01 00 00 00       	mov    $0x1,%eax
  80210b:	31 d2                	xor    %edx,%edx
  80210d:	f7 f7                	div    %edi
  80210f:	89 c5                	mov    %eax,%ebp
  802111:	89 f0                	mov    %esi,%eax
  802113:	31 d2                	xor    %edx,%edx
  802115:	f7 f5                	div    %ebp
  802117:	89 c8                	mov    %ecx,%eax
  802119:	f7 f5                	div    %ebp
  80211b:	89 d0                	mov    %edx,%eax
  80211d:	e9 44 ff ff ff       	jmp    802066 <__umoddi3+0x3e>
  802122:	66 90                	xchg   %ax,%ax
  802124:	89 c8                	mov    %ecx,%eax
  802126:	89 f2                	mov    %esi,%edx
  802128:	83 c4 1c             	add    $0x1c,%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5e                   	pop    %esi
  80212d:	5f                   	pop    %edi
  80212e:	5d                   	pop    %ebp
  80212f:	c3                   	ret    
  802130:	3b 04 24             	cmp    (%esp),%eax
  802133:	72 06                	jb     80213b <__umoddi3+0x113>
  802135:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802139:	77 0f                	ja     80214a <__umoddi3+0x122>
  80213b:	89 f2                	mov    %esi,%edx
  80213d:	29 f9                	sub    %edi,%ecx
  80213f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802143:	89 14 24             	mov    %edx,(%esp)
  802146:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80214a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80214e:	8b 14 24             	mov    (%esp),%edx
  802151:	83 c4 1c             	add    $0x1c,%esp
  802154:	5b                   	pop    %ebx
  802155:	5e                   	pop    %esi
  802156:	5f                   	pop    %edi
  802157:	5d                   	pop    %ebp
  802158:	c3                   	ret    
  802159:	8d 76 00             	lea    0x0(%esi),%esi
  80215c:	2b 04 24             	sub    (%esp),%eax
  80215f:	19 fa                	sbb    %edi,%edx
  802161:	89 d1                	mov    %edx,%ecx
  802163:	89 c6                	mov    %eax,%esi
  802165:	e9 71 ff ff ff       	jmp    8020db <__umoddi3+0xb3>
  80216a:	66 90                	xchg   %ax,%ax
  80216c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802170:	72 ea                	jb     80215c <__umoddi3+0x134>
  802172:	89 d9                	mov    %ebx,%ecx
  802174:	e9 62 ff ff ff       	jmp    8020db <__umoddi3+0xb3>
