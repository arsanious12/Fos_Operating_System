
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 cf 07 00 00       	call   800805 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_lock_cons();
  80004c:	e8 5a 1f 00 00       	call   801fab <sys_lock_cons>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 00 32 80 00       	push   $0x803200
  800060:	e8 0c 13 00 00       	call   801371 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 0d 19 00 00       	call   801988 <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 d2 1d 00 00       	call   801e62 <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 40 80 00       	mov    0x804024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 a5 1f 00 00       	call   80205b <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 b7 1f 00 00       	call   802074 <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 20 32 80 00       	push   $0x803220
  8000e7:	e8 ac 0b 00 00       	call   800c98 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 43 32 80 00       	push   $0x803243
  8000f7:	e8 9c 0b 00 00       	call   800c98 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 51 32 80 00       	push   $0x803251
  800107:	e8 8c 0b 00 00       	call   800c98 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 60 32 80 00       	push   $0x803260
  800117:	e8 7c 0b 00 00       	call   800c98 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 70 32 80 00       	push   $0x803270
  800127:	e8 6c 0b 00 00       	call   800c98 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 b4 06 00 00       	call   8007e8 <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 85 06 00 00       	call   8007c9 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 78 06 00 00       	call   8007c9 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_unlock_cons();
  800166:	e8 5a 1e 00 00       	call   801fc5 <sys_unlock_cons>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 05 05 00 00       	call   800691 <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 23 05 00 00       	call   8006c2 <InitializeIdentical>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 45 05 00 00       	call   8006f7 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 32 05 00 00       	call   8006f7 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 00 03 00 00       	call   8004d6 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 00 04 00 00       	call   8005e7 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 7c 32 80 00       	push   $0x80327c
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 9e 32 80 00       	push   $0x80329e
  800202:	e8 c3 07 00 00       	call   8009ca <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 bc 32 80 00       	push   $0x8032bc
  80020f:	e8 84 0a 00 00       	call   800c98 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 f0 32 80 00       	push   $0x8032f0
  80021f:	e8 74 0a 00 00       	call   800c98 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 24 33 80 00       	push   $0x803324
  80022f:	e8 64 0a 00 00       	call   800c98 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 56 33 80 00       	push   $0x803356
  80023f:	e8 54 0a 00 00       	call   800c98 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 3e 1c 00 00       	call   801e90 <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 6c 33 80 00       	push   $0x80336c
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 9e 32 80 00       	push   $0x80329e
  800282:	e8 43 07 00 00       	call   8009ca <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 40 80 00       	mov    0x804024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 bb 1d 00 00       	call   80205b <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 cd 1d 00 00       	call   802074 <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 bc 33 80 00       	push   $0x8033bc
  8002c5:	68 e1 33 80 00       	push   $0x8033e1
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 9e 32 80 00       	push   $0x80329e
  8002d1:	e8 f4 06 00 00       	call   8009ca <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 6c 33 80 00       	push   $0x80336c
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 9e 32 80 00       	push   $0x80329e
  8002fa:	e8 cb 06 00 00       	call   8009ca <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 40 80 00       	mov    0x804024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 43 1d 00 00       	call   80205b <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 55 1d 00 00       	call   802074 <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 bc 33 80 00       	push   $0x8033bc
  80033d:	68 e1 33 80 00       	push   $0x8033e1
  800342:	6a 77                	push   $0x77
  800344:	68 9e 32 80 00       	push   $0x80329e
  800349:	e8 7c 06 00 00       	call   8009ca <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 6c 33 80 00       	push   $0x80336c
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 9e 32 80 00       	push   $0x80329e
  800372:	e8 53 06 00 00       	call   8009ca <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 40 80 00       	mov    0x804024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 cb 1c 00 00       	call   80205b <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 dd 1c 00 00       	call   802074 <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 bc 33 80 00       	push   $0x8033bc
  8003b1:	68 e1 33 80 00       	push   $0x8033e1
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 9e 32 80 00       	push   $0x80329e
  8003c0:	e8 05 06 00 00       	call   8009ca <_panic>
		}
		///========================================================================
	sys_lock_cons();
  8003c5:	e8 e1 1b 00 00       	call   801fab <sys_lock_cons>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 f6 33 80 00       	push   $0x8033f6
  8003d8:	e8 bb 08 00 00       	call   800c98 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 03 04 00 00       	call   8007e8 <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d4 03 00 00       	call   8007c9 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c7 03 00 00       	call   8007c9 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 ba 03 00 00       	call   8007c9 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_unlock_cons();
  80041e:	e8 a2 1b 00 00       	call   801fc5 <sys_unlock_cons>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 14 34 80 00       	push   $0x803414
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 9e 32 80 00       	push   $0x80329e
  8004b5:	e8 10 05 00 00       	call   8009ca <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c9:	39 c2                	cmp    %eax,%edx
  8004cb:	0f 87 78 ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004d1:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004df:	48                   	dec    %eax
  8004e0:	50                   	push   %eax
  8004e1:	6a 00                	push   $0x0
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	ff 75 08             	pushl  0x8(%ebp)
  8004e9:	e8 06 00 00 00       	call   8004f4 <QSort>
  8004ee:	83 c4 10             	add    $0x10,%esp
}
  8004f1:	90                   	nop
  8004f2:	c9                   	leave  
  8004f3:	c3                   	ret    

008004f4 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800500:	0f 8d de 00 00 00    	jge    8005e4 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800506:	8b 45 10             	mov    0x10(%ebp),%eax
  800509:	40                   	inc    %eax
  80050a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800513:	e9 80 00 00 00       	jmp    800598 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800518:	ff 45 f4             	incl   -0xc(%ebp)
  80051b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800521:	7f 2b                	jg     80054e <QSort+0x5a>
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	8b 10                	mov    (%eax),%edx
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	39 c2                	cmp    %eax,%edx
  800547:	7d cf                	jge    800518 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800549:	eb 03                	jmp    80054e <QSort+0x5a>
  80054b:	ff 4d f0             	decl   -0x10(%ebp)
  80054e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800551:	3b 45 10             	cmp    0x10(%ebp),%eax
  800554:	7e 26                	jle    80057c <QSort+0x88>
  800556:	8b 45 10             	mov    0x10(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 d0                	add    %edx,%eax
  800565:	8b 10                	mov    (%eax),%edx
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	01 c8                	add    %ecx,%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	39 c2                	cmp    %eax,%edx
  80057a:	7e cf                	jle    80054b <QSort+0x57>

		if (i <= j)
  80057c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800582:	7f 14                	jg     800598 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800584:	83 ec 04             	sub    $0x4,%esp
  800587:	ff 75 f0             	pushl  -0x10(%ebp)
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	ff 75 08             	pushl  0x8(%ebp)
  800590:	e8 a9 00 00 00       	call   80063e <Swap>
  800595:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80059b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059e:	0f 8e 77 ff ff ff    	jle    80051b <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8005aa:	ff 75 10             	pushl  0x10(%ebp)
  8005ad:	ff 75 08             	pushl  0x8(%ebp)
  8005b0:	e8 89 00 00 00       	call   80063e <Swap>
  8005b5:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bb:	48                   	dec    %eax
  8005bc:	50                   	push   %eax
  8005bd:	ff 75 10             	pushl  0x10(%ebp)
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 29 ff ff ff       	call   8004f4 <QSort>
  8005cb:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005ce:	ff 75 14             	pushl  0x14(%ebp)
  8005d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	e8 15 ff ff ff       	call   8004f4 <QSort>
  8005df:	83 c4 10             	add    $0x10,%esp
  8005e2:	eb 01                	jmp    8005e5 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e4:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005fb:	eb 33                	jmp    800630 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 10                	mov    (%eax),%edx
  80060e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800611:	40                   	inc    %eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7e 09                	jle    80062d <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80062b:	eb 0c                	jmp    800639 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062d:	ff 45 f8             	incl   -0x8(%ebp)
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	48                   	dec    %eax
  800634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800637:	7f c4                	jg     8005fd <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800639:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	01 d0                	add    %edx,%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	01 c2                	add    %eax,%edx
  800667:	8b 45 10             	mov    0x10(%ebp),%eax
  80066a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	01 c8                	add    %ecx,%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	01 c2                	add    %eax,%edx
  800689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80068c:	89 02                	mov    %eax,(%edx)
}
  80068e:	90                   	nop
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800697:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069e:	eb 17                	jmp    8006b7 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	01 c2                	add    %eax,%edx
  8006af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b2:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b4:	ff 45 fc             	incl   -0x4(%ebp)
  8006b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006bd:	7c e1                	jl     8006a0 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bf:	90                   	nop
  8006c0:	c9                   	leave  
  8006c1:	c3                   	ret    

008006c2 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cf:	eb 1b                	jmp    8006ec <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	01 c2                	add    %eax,%edx
  8006e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e3:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e6:	48                   	dec    %eax
  8006e7:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e9:	ff 45 fc             	incl   -0x4(%ebp)
  8006ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006f2:	7c dd                	jl     8006d1 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f4:	90                   	nop
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    

008006f7 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800700:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800705:	f7 e9                	imul   %ecx
  800707:	c1 f9 1f             	sar    $0x1f,%ecx
  80070a:	89 d0                	mov    %edx,%eax
  80070c:	29 c8                	sub    %ecx,%eax
  80070e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800711:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800718:	eb 1e                	jmp    800738 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80071a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80072a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072d:	99                   	cltd   
  80072e:	f7 7d f8             	idivl  -0x8(%ebp)
  800731:	89 d0                	mov    %edx,%eax
  800733:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800735:	ff 45 fc             	incl   -0x4(%ebp)
  800738:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80073b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073e:	7c da                	jl     80071a <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800749:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800750:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800757:	eb 42                	jmp    80079b <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075c:	99                   	cltd   
  80075d:	f7 7d f0             	idivl  -0x10(%ebp)
  800760:	89 d0                	mov    %edx,%eax
  800762:	85 c0                	test   %eax,%eax
  800764:	75 10                	jne    800776 <PrintElements+0x33>
			cprintf("\n");
  800766:	83 ec 0c             	sub    $0xc,%esp
  800769:	68 42 34 80 00       	push   $0x803442
  80076e:	e8 25 05 00 00       	call   800c98 <cprintf>
  800773:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800779:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	50                   	push   %eax
  80078b:	68 44 34 80 00       	push   $0x803444
  800790:	e8 03 05 00 00       	call   800c98 <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800798:	ff 45 f4             	incl   -0xc(%ebp)
  80079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079e:	48                   	dec    %eax
  80079f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8007a2:	7f b5                	jg     800759 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	50                   	push   %eax
  8007b9:	68 49 34 80 00       	push   $0x803449
  8007be:	e8 d5 04 00 00       	call   800c98 <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp

}
  8007c6:	90                   	nop
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d9:	83 ec 0c             	sub    $0xc,%esp
  8007dc:	50                   	push   %eax
  8007dd:	e8 11 19 00 00       	call   8020f3 <sys_cputc>
  8007e2:	83 c4 10             	add    $0x10,%esp
}
  8007e5:	90                   	nop
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <getchar>:


int
getchar(void)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8007ee:	e8 9f 17 00 00       	call   801f92 <sys_cgetc>
  8007f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    

008007fb <iscons>:

int iscons(int fdnum)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	57                   	push   %edi
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80080e:	e8 11 1a 00 00       	call   802224 <sys_getenvindex>
  800813:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800816:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800819:	89 d0                	mov    %edx,%eax
  80081b:	c1 e0 06             	shl    $0x6,%eax
  80081e:	29 d0                	sub    %edx,%eax
  800820:	c1 e0 02             	shl    $0x2,%eax
  800823:	01 d0                	add    %edx,%eax
  800825:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80082c:	01 c8                	add    %ecx,%eax
  80082e:	c1 e0 03             	shl    $0x3,%eax
  800831:	01 d0                	add    %edx,%eax
  800833:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80083a:	29 c2                	sub    %eax,%edx
  80083c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800843:	89 c2                	mov    %eax,%edx
  800845:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80084b:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800850:	a1 24 40 80 00       	mov    0x804024,%eax
  800855:	8a 40 20             	mov    0x20(%eax),%al
  800858:	84 c0                	test   %al,%al
  80085a:	74 0d                	je     800869 <libmain+0x64>
		binaryname = myEnv->prog_name;
  80085c:	a1 24 40 80 00       	mov    0x804024,%eax
  800861:	83 c0 20             	add    $0x20,%eax
  800864:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800869:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80086d:	7e 0a                	jle    800879 <libmain+0x74>
		binaryname = argv[0];
  80086f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 0c             	pushl  0xc(%ebp)
  80087f:	ff 75 08             	pushl  0x8(%ebp)
  800882:	e8 b1 f7 ff ff       	call   800038 <_main>
  800887:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80088a:	a1 00 40 80 00       	mov    0x804000,%eax
  80088f:	85 c0                	test   %eax,%eax
  800891:	0f 84 01 01 00 00    	je     800998 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800897:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80089d:	bb 48 35 80 00       	mov    $0x803548,%ebx
  8008a2:	ba 0e 00 00 00       	mov    $0xe,%edx
  8008a7:	89 c7                	mov    %eax,%edi
  8008a9:	89 de                	mov    %ebx,%esi
  8008ab:	89 d1                	mov    %edx,%ecx
  8008ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8008af:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8008b2:	b9 56 00 00 00       	mov    $0x56,%ecx
  8008b7:	b0 00                	mov    $0x0,%al
  8008b9:	89 d7                	mov    %edx,%edi
  8008bb:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8008bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8008c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	50                   	push   %eax
  8008cb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8008d1:	50                   	push   %eax
  8008d2:	e8 83 1b 00 00       	call   80245a <sys_utilities>
  8008d7:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8008da:	e8 cc 16 00 00       	call   801fab <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8008df:	83 ec 0c             	sub    $0xc,%esp
  8008e2:	68 68 34 80 00       	push   $0x803468
  8008e7:	e8 ac 03 00 00       	call   800c98 <cprintf>
  8008ec:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8008ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f2:	85 c0                	test   %eax,%eax
  8008f4:	74 18                	je     80090e <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8008f6:	e8 7d 1b 00 00       	call   802478 <sys_get_optimal_num_faults>
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	50                   	push   %eax
  8008ff:	68 90 34 80 00       	push   $0x803490
  800904:	e8 8f 03 00 00       	call   800c98 <cprintf>
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	eb 59                	jmp    800967 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80090e:	a1 24 40 80 00       	mov    0x804024,%eax
  800913:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800919:	a1 24 40 80 00       	mov    0x804024,%eax
  80091e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	52                   	push   %edx
  800928:	50                   	push   %eax
  800929:	68 b4 34 80 00       	push   $0x8034b4
  80092e:	e8 65 03 00 00       	call   800c98 <cprintf>
  800933:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800936:	a1 24 40 80 00       	mov    0x804024,%eax
  80093b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800941:	a1 24 40 80 00       	mov    0x804024,%eax
  800946:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80094c:	a1 24 40 80 00       	mov    0x804024,%eax
  800951:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800957:	51                   	push   %ecx
  800958:	52                   	push   %edx
  800959:	50                   	push   %eax
  80095a:	68 dc 34 80 00       	push   $0x8034dc
  80095f:	e8 34 03 00 00       	call   800c98 <cprintf>
  800964:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800967:	a1 24 40 80 00       	mov    0x804024,%eax
  80096c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	50                   	push   %eax
  800976:	68 34 35 80 00       	push   $0x803534
  80097b:	e8 18 03 00 00       	call   800c98 <cprintf>
  800980:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800983:	83 ec 0c             	sub    $0xc,%esp
  800986:	68 68 34 80 00       	push   $0x803468
  80098b:	e8 08 03 00 00       	call   800c98 <cprintf>
  800990:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800993:	e8 2d 16 00 00       	call   801fc5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800998:	e8 1f 00 00 00       	call   8009bc <exit>
}
  80099d:	90                   	nop
  80099e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a1:	5b                   	pop    %ebx
  8009a2:	5e                   	pop    %esi
  8009a3:	5f                   	pop    %edi
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8009ac:	83 ec 0c             	sub    $0xc,%esp
  8009af:	6a 00                	push   $0x0
  8009b1:	e8 3a 18 00 00       	call   8021f0 <sys_destroy_env>
  8009b6:	83 c4 10             	add    $0x10,%esp
}
  8009b9:	90                   	nop
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <exit>:

void
exit(void)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8009c2:	e8 8f 18 00 00       	call   802256 <sys_exit_env>
}
  8009c7:	90                   	nop
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009d0:	8d 45 10             	lea    0x10(%ebp),%eax
  8009d3:	83 c0 04             	add    $0x4,%eax
  8009d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009d9:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8009de:	85 c0                	test   %eax,%eax
  8009e0:	74 16                	je     8009f8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009e2:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	50                   	push   %eax
  8009eb:	68 ac 35 80 00       	push   $0x8035ac
  8009f0:	e8 a3 02 00 00       	call   800c98 <cprintf>
  8009f5:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8009f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8009fd:	83 ec 0c             	sub    $0xc,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	ff 75 08             	pushl  0x8(%ebp)
  800a06:	50                   	push   %eax
  800a07:	68 b4 35 80 00       	push   $0x8035b4
  800a0c:	6a 74                	push   $0x74
  800a0e:	e8 b2 02 00 00       	call   800cc5 <cprintf_colored>
  800a13:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800a16:	8b 45 10             	mov    0x10(%ebp),%eax
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1f:	50                   	push   %eax
  800a20:	e8 04 02 00 00       	call   800c29 <vcprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	6a 00                	push   $0x0
  800a2d:	68 dc 35 80 00       	push   $0x8035dc
  800a32:	e8 f2 01 00 00       	call   800c29 <vcprintf>
  800a37:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a3a:	e8 7d ff ff ff       	call   8009bc <exit>

	// should not return here
	while (1) ;
  800a3f:	eb fe                	jmp    800a3f <_panic+0x75>

00800a41 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a47:	a1 24 40 80 00       	mov    0x804024,%eax
  800a4c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	39 c2                	cmp    %eax,%edx
  800a57:	74 14                	je     800a6d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a59:	83 ec 04             	sub    $0x4,%esp
  800a5c:	68 e0 35 80 00       	push   $0x8035e0
  800a61:	6a 26                	push   $0x26
  800a63:	68 2c 36 80 00       	push   $0x80362c
  800a68:	e8 5d ff ff ff       	call   8009ca <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a7b:	e9 c5 00 00 00       	jmp    800b45 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	01 d0                	add    %edx,%eax
  800a8f:	8b 00                	mov    (%eax),%eax
  800a91:	85 c0                	test   %eax,%eax
  800a93:	75 08                	jne    800a9d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a95:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a98:	e9 a5 00 00 00       	jmp    800b42 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a9d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800aab:	eb 69                	jmp    800b16 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800aad:	a1 24 40 80 00       	mov    0x804024,%eax
  800ab2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800ab8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	01 c0                	add    %eax,%eax
  800abf:	01 d0                	add    %edx,%eax
  800ac1:	c1 e0 03             	shl    $0x3,%eax
  800ac4:	01 c8                	add    %ecx,%eax
  800ac6:	8a 40 04             	mov    0x4(%eax),%al
  800ac9:	84 c0                	test   %al,%al
  800acb:	75 46                	jne    800b13 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800acd:	a1 24 40 80 00       	mov    0x804024,%eax
  800ad2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800ad8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800adb:	89 d0                	mov    %edx,%eax
  800add:	01 c0                	add    %eax,%eax
  800adf:	01 d0                	add    %edx,%eax
  800ae1:	c1 e0 03             	shl    $0x3,%eax
  800ae4:	01 c8                	add    %ecx,%eax
  800ae6:	8b 00                	mov    (%eax),%eax
  800ae8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800aeb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800aee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	01 c8                	add    %ecx,%eax
  800b04:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b06:	39 c2                	cmp    %eax,%edx
  800b08:	75 09                	jne    800b13 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800b0a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b11:	eb 15                	jmp    800b28 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b13:	ff 45 e8             	incl   -0x18(%ebp)
  800b16:	a1 24 40 80 00       	mov    0x804024,%eax
  800b1b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b24:	39 c2                	cmp    %eax,%edx
  800b26:	77 85                	ja     800aad <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b2c:	75 14                	jne    800b42 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800b2e:	83 ec 04             	sub    $0x4,%esp
  800b31:	68 38 36 80 00       	push   $0x803638
  800b36:	6a 3a                	push   $0x3a
  800b38:	68 2c 36 80 00       	push   $0x80362c
  800b3d:	e8 88 fe ff ff       	call   8009ca <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b42:	ff 45 f0             	incl   -0x10(%ebp)
  800b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b4b:	0f 8c 2f ff ff ff    	jl     800a80 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b58:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b5f:	eb 26                	jmp    800b87 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b61:	a1 24 40 80 00       	mov    0x804024,%eax
  800b66:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800b6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b6f:	89 d0                	mov    %edx,%eax
  800b71:	01 c0                	add    %eax,%eax
  800b73:	01 d0                	add    %edx,%eax
  800b75:	c1 e0 03             	shl    $0x3,%eax
  800b78:	01 c8                	add    %ecx,%eax
  800b7a:	8a 40 04             	mov    0x4(%eax),%al
  800b7d:	3c 01                	cmp    $0x1,%al
  800b7f:	75 03                	jne    800b84 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800b81:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b84:	ff 45 e0             	incl   -0x20(%ebp)
  800b87:	a1 24 40 80 00       	mov    0x804024,%eax
  800b8c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b95:	39 c2                	cmp    %eax,%edx
  800b97:	77 c8                	ja     800b61 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b9c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b9f:	74 14                	je     800bb5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800ba1:	83 ec 04             	sub    $0x4,%esp
  800ba4:	68 8c 36 80 00       	push   $0x80368c
  800ba9:	6a 44                	push   $0x44
  800bab:	68 2c 36 80 00       	push   $0x80362c
  800bb0:	e8 15 fe ff ff       	call   8009ca <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800bb5:	90                   	nop
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	53                   	push   %ebx
  800bbc:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bca:	89 0a                	mov    %ecx,(%edx)
  800bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcf:	88 d1                	mov    %dl,%cl
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	8b 00                	mov    (%eax),%eax
  800bdd:	3d ff 00 00 00       	cmp    $0xff,%eax
  800be2:	75 30                	jne    800c14 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800be4:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800bea:	a0 44 40 80 00       	mov    0x804044,%al
  800bef:	0f b6 c0             	movzbl %al,%eax
  800bf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf5:	8b 09                	mov    (%ecx),%ecx
  800bf7:	89 cb                	mov    %ecx,%ebx
  800bf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfc:	83 c1 08             	add    $0x8,%ecx
  800bff:	52                   	push   %edx
  800c00:	50                   	push   %eax
  800c01:	53                   	push   %ebx
  800c02:	51                   	push   %ecx
  800c03:	e8 5f 13 00 00       	call   801f67 <sys_cputs>
  800c08:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	8b 40 04             	mov    0x4(%eax),%eax
  800c1a:	8d 50 01             	lea    0x1(%eax),%edx
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c23:	90                   	nop
  800c24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c32:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c39:	00 00 00 
	b.cnt = 0;
  800c3c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c43:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	ff 75 08             	pushl  0x8(%ebp)
  800c4c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c52:	50                   	push   %eax
  800c53:	68 b8 0b 80 00       	push   $0x800bb8
  800c58:	e8 5a 02 00 00       	call   800eb7 <vprintfmt>
  800c5d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c60:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800c66:	a0 44 40 80 00       	mov    0x804044,%al
  800c6b:	0f b6 c0             	movzbl %al,%eax
  800c6e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c74:	52                   	push   %edx
  800c75:	50                   	push   %eax
  800c76:	51                   	push   %ecx
  800c77:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c7d:	83 c0 08             	add    $0x8,%eax
  800c80:	50                   	push   %eax
  800c81:	e8 e1 12 00 00       	call   801f67 <sys_cputs>
  800c86:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c89:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800c90:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c9e:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800ca5:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb4:	50                   	push   %eax
  800cb5:	e8 6f ff ff ff       	call   800c29 <vcprintf>
  800cba:	83 c4 10             	add    $0x10,%esp
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ccb:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	c1 e0 08             	shl    $0x8,%eax
  800cd8:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800cdd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ce0:	83 c0 04             	add    $0x4,%eax
  800ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 f4             	pushl  -0xc(%ebp)
  800cef:	50                   	push   %eax
  800cf0:	e8 34 ff ff ff       	call   800c29 <vcprintf>
  800cf5:	83 c4 10             	add    $0x10,%esp
  800cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800cfb:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800d02:	07 00 00 

	return cnt;
  800d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d10:	e8 96 12 00 00       	call   801fab <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d15:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	83 ec 08             	sub    $0x8,%esp
  800d21:	ff 75 f4             	pushl  -0xc(%ebp)
  800d24:	50                   	push   %eax
  800d25:	e8 ff fe ff ff       	call   800c29 <vcprintf>
  800d2a:	83 c4 10             	add    $0x10,%esp
  800d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d30:	e8 90 12 00 00       	call   801fc5 <sys_unlock_cons>
	return cnt;
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d38:	c9                   	leave  
  800d39:	c3                   	ret    

00800d3a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	53                   	push   %ebx
  800d3e:	83 ec 14             	sub    $0x14,%esp
  800d41:	8b 45 10             	mov    0x10(%ebp),%eax
  800d44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d47:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d58:	77 55                	ja     800daf <printnum+0x75>
  800d5a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d5d:	72 05                	jb     800d64 <printnum+0x2a>
  800d5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d62:	77 4b                	ja     800daf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d64:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d67:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d6a:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d72:	52                   	push   %edx
  800d73:	50                   	push   %eax
  800d74:	ff 75 f4             	pushl  -0xc(%ebp)
  800d77:	ff 75 f0             	pushl  -0x10(%ebp)
  800d7a:	e8 11 22 00 00       	call   802f90 <__udivdi3>
  800d7f:	83 c4 10             	add    $0x10,%esp
  800d82:	83 ec 04             	sub    $0x4,%esp
  800d85:	ff 75 20             	pushl  0x20(%ebp)
  800d88:	53                   	push   %ebx
  800d89:	ff 75 18             	pushl  0x18(%ebp)
  800d8c:	52                   	push   %edx
  800d8d:	50                   	push   %eax
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	ff 75 08             	pushl  0x8(%ebp)
  800d94:	e8 a1 ff ff ff       	call   800d3a <printnum>
  800d99:	83 c4 20             	add    $0x20,%esp
  800d9c:	eb 1a                	jmp    800db8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9e:	83 ec 08             	sub    $0x8,%esp
  800da1:	ff 75 0c             	pushl  0xc(%ebp)
  800da4:	ff 75 20             	pushl  0x20(%ebp)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	ff d0                	call   *%eax
  800dac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800daf:	ff 4d 1c             	decl   0x1c(%ebp)
  800db2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800db6:	7f e6                	jg     800d9e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc6:	53                   	push   %ebx
  800dc7:	51                   	push   %ecx
  800dc8:	52                   	push   %edx
  800dc9:	50                   	push   %eax
  800dca:	e8 d1 22 00 00       	call   8030a0 <__umoddi3>
  800dcf:	83 c4 10             	add    $0x10,%esp
  800dd2:	05 f4 38 80 00       	add    $0x8038f4,%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f be c0             	movsbl %al,%eax
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	50                   	push   %eax
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	ff d0                	call   *%eax
  800de8:	83 c4 10             	add    $0x10,%esp
}
  800deb:	90                   	nop
  800dec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df8:	7e 1c                	jle    800e16 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	8d 50 08             	lea    0x8(%eax),%edx
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 10                	mov    %edx,(%eax)
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	83 e8 08             	sub    $0x8,%eax
  800e0f:	8b 50 04             	mov    0x4(%eax),%edx
  800e12:	8b 00                	mov    (%eax),%eax
  800e14:	eb 40                	jmp    800e56 <getuint+0x65>
	else if (lflag)
  800e16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1a:	74 1e                	je     800e3a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8b 00                	mov    (%eax),%eax
  800e21:	8d 50 04             	lea    0x4(%eax),%edx
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 10                	mov    %edx,(%eax)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8b 00                	mov    (%eax),%eax
  800e2e:	83 e8 04             	sub    $0x4,%eax
  800e31:	8b 00                	mov    (%eax),%eax
  800e33:	ba 00 00 00 00       	mov    $0x0,%edx
  800e38:	eb 1c                	jmp    800e56 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8b 00                	mov    (%eax),%eax
  800e3f:	8d 50 04             	lea    0x4(%eax),%edx
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	89 10                	mov    %edx,(%eax)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8b 00                	mov    (%eax),%eax
  800e4c:	83 e8 04             	sub    $0x4,%eax
  800e4f:	8b 00                	mov    (%eax),%eax
  800e51:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e5b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e5f:	7e 1c                	jle    800e7d <getint+0x25>
		return va_arg(*ap, long long);
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8b 00                	mov    (%eax),%eax
  800e66:	8d 50 08             	lea    0x8(%eax),%edx
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 10                	mov    %edx,(%eax)
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8b 00                	mov    (%eax),%eax
  800e73:	83 e8 08             	sub    $0x8,%eax
  800e76:	8b 50 04             	mov    0x4(%eax),%edx
  800e79:	8b 00                	mov    (%eax),%eax
  800e7b:	eb 38                	jmp    800eb5 <getint+0x5d>
	else if (lflag)
  800e7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e81:	74 1a                	je     800e9d <getint+0x45>
		return va_arg(*ap, long);
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8b 00                	mov    (%eax),%eax
  800e88:	8d 50 04             	lea    0x4(%eax),%edx
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 10                	mov    %edx,(%eax)
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	83 e8 04             	sub    $0x4,%eax
  800e98:	8b 00                	mov    (%eax),%eax
  800e9a:	99                   	cltd   
  800e9b:	eb 18                	jmp    800eb5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8b 00                	mov    (%eax),%eax
  800ea2:	8d 50 04             	lea    0x4(%eax),%edx
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	89 10                	mov    %edx,(%eax)
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8b 00                	mov    (%eax),%eax
  800eaf:	83 e8 04             	sub    $0x4,%eax
  800eb2:	8b 00                	mov    (%eax),%eax
  800eb4:	99                   	cltd   
}
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
  800ebc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebf:	eb 17                	jmp    800ed8 <vprintfmt+0x21>
			if (ch == '\0')
  800ec1:	85 db                	test   %ebx,%ebx
  800ec3:	0f 84 c1 03 00 00    	je     80128a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	53                   	push   %ebx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	8d 50 01             	lea    0x1(%eax),%edx
  800ede:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f b6 d8             	movzbl %al,%ebx
  800ee6:	83 fb 25             	cmp    $0x25,%ebx
  800ee9:	75 d6                	jne    800ec1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800eeb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ef6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800efd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f04:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0e:	8d 50 01             	lea    0x1(%eax),%edx
  800f11:	89 55 10             	mov    %edx,0x10(%ebp)
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f b6 d8             	movzbl %al,%ebx
  800f19:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f1c:	83 f8 5b             	cmp    $0x5b,%eax
  800f1f:	0f 87 3d 03 00 00    	ja     801262 <vprintfmt+0x3ab>
  800f25:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  800f2c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f2e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f32:	eb d7                	jmp    800f0b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f34:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f38:	eb d1                	jmp    800f0b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f3a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f44:	89 d0                	mov    %edx,%eax
  800f46:	c1 e0 02             	shl    $0x2,%eax
  800f49:	01 d0                	add    %edx,%eax
  800f4b:	01 c0                	add    %eax,%eax
  800f4d:	01 d8                	add    %ebx,%eax
  800f4f:	83 e8 30             	sub    $0x30,%eax
  800f52:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f55:	8b 45 10             	mov    0x10(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f5d:	83 fb 2f             	cmp    $0x2f,%ebx
  800f60:	7e 3e                	jle    800fa0 <vprintfmt+0xe9>
  800f62:	83 fb 39             	cmp    $0x39,%ebx
  800f65:	7f 39                	jg     800fa0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f67:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f6a:	eb d5                	jmp    800f41 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 c0 04             	add    $0x4,%eax
  800f72:	89 45 14             	mov    %eax,0x14(%ebp)
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	83 e8 04             	sub    $0x4,%eax
  800f7b:	8b 00                	mov    (%eax),%eax
  800f7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f80:	eb 1f                	jmp    800fa1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f86:	79 83                	jns    800f0b <vprintfmt+0x54>
				width = 0;
  800f88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f8f:	e9 77 ff ff ff       	jmp    800f0b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f94:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f9b:	e9 6b ff ff ff       	jmp    800f0b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fa0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fa1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa5:	0f 89 60 ff ff ff    	jns    800f0b <vprintfmt+0x54>
				width = precision, precision = -1;
  800fab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fb1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fb8:	e9 4e ff ff ff       	jmp    800f0b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fbd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fc0:	e9 46 ff ff ff       	jmp    800f0b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 c0 04             	add    $0x4,%eax
  800fcb:	89 45 14             	mov    %eax,0x14(%ebp)
  800fce:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd1:	83 e8 04             	sub    $0x4,%eax
  800fd4:	8b 00                	mov    (%eax),%eax
  800fd6:	83 ec 08             	sub    $0x8,%esp
  800fd9:	ff 75 0c             	pushl  0xc(%ebp)
  800fdc:	50                   	push   %eax
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	ff d0                	call   *%eax
  800fe2:	83 c4 10             	add    $0x10,%esp
			break;
  800fe5:	e9 9b 02 00 00       	jmp    801285 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fea:	8b 45 14             	mov    0x14(%ebp),%eax
  800fed:	83 c0 04             	add    $0x4,%eax
  800ff0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff6:	83 e8 04             	sub    $0x4,%eax
  800ff9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ffb:	85 db                	test   %ebx,%ebx
  800ffd:	79 02                	jns    801001 <vprintfmt+0x14a>
				err = -err;
  800fff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801001:	83 fb 64             	cmp    $0x64,%ebx
  801004:	7f 0b                	jg     801011 <vprintfmt+0x15a>
  801006:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  80100d:	85 f6                	test   %esi,%esi
  80100f:	75 19                	jne    80102a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801011:	53                   	push   %ebx
  801012:	68 05 39 80 00       	push   $0x803905
  801017:	ff 75 0c             	pushl  0xc(%ebp)
  80101a:	ff 75 08             	pushl  0x8(%ebp)
  80101d:	e8 70 02 00 00       	call   801292 <printfmt>
  801022:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801025:	e9 5b 02 00 00       	jmp    801285 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80102a:	56                   	push   %esi
  80102b:	68 0e 39 80 00       	push   $0x80390e
  801030:	ff 75 0c             	pushl  0xc(%ebp)
  801033:	ff 75 08             	pushl  0x8(%ebp)
  801036:	e8 57 02 00 00       	call   801292 <printfmt>
  80103b:	83 c4 10             	add    $0x10,%esp
			break;
  80103e:	e9 42 02 00 00       	jmp    801285 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801043:	8b 45 14             	mov    0x14(%ebp),%eax
  801046:	83 c0 04             	add    $0x4,%eax
  801049:	89 45 14             	mov    %eax,0x14(%ebp)
  80104c:	8b 45 14             	mov    0x14(%ebp),%eax
  80104f:	83 e8 04             	sub    $0x4,%eax
  801052:	8b 30                	mov    (%eax),%esi
  801054:	85 f6                	test   %esi,%esi
  801056:	75 05                	jne    80105d <vprintfmt+0x1a6>
				p = "(null)";
  801058:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  80105d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801061:	7e 6d                	jle    8010d0 <vprintfmt+0x219>
  801063:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801067:	74 67                	je     8010d0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801069:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	50                   	push   %eax
  801070:	56                   	push   %esi
  801071:	e8 26 05 00 00       	call   80159c <strnlen>
  801076:	83 c4 10             	add    $0x10,%esp
  801079:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80107c:	eb 16                	jmp    801094 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80107e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801082:	83 ec 08             	sub    $0x8,%esp
  801085:	ff 75 0c             	pushl  0xc(%ebp)
  801088:	50                   	push   %eax
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801091:	ff 4d e4             	decl   -0x1c(%ebp)
  801094:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801098:	7f e4                	jg     80107e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80109a:	eb 34                	jmp    8010d0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80109c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010a0:	74 1c                	je     8010be <vprintfmt+0x207>
  8010a2:	83 fb 1f             	cmp    $0x1f,%ebx
  8010a5:	7e 05                	jle    8010ac <vprintfmt+0x1f5>
  8010a7:	83 fb 7e             	cmp    $0x7e,%ebx
  8010aa:	7e 12                	jle    8010be <vprintfmt+0x207>
					putch('?', putdat);
  8010ac:	83 ec 08             	sub    $0x8,%esp
  8010af:	ff 75 0c             	pushl  0xc(%ebp)
  8010b2:	6a 3f                	push   $0x3f
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	ff d0                	call   *%eax
  8010b9:	83 c4 10             	add    $0x10,%esp
  8010bc:	eb 0f                	jmp    8010cd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	ff 75 0c             	pushl  0xc(%ebp)
  8010c4:	53                   	push   %ebx
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	ff d0                	call   *%eax
  8010ca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010cd:	ff 4d e4             	decl   -0x1c(%ebp)
  8010d0:	89 f0                	mov    %esi,%eax
  8010d2:	8d 70 01             	lea    0x1(%eax),%esi
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f be d8             	movsbl %al,%ebx
  8010da:	85 db                	test   %ebx,%ebx
  8010dc:	74 24                	je     801102 <vprintfmt+0x24b>
  8010de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e2:	78 b8                	js     80109c <vprintfmt+0x1e5>
  8010e4:	ff 4d e0             	decl   -0x20(%ebp)
  8010e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010eb:	79 af                	jns    80109c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010ed:	eb 13                	jmp    801102 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ef:	83 ec 08             	sub    $0x8,%esp
  8010f2:	ff 75 0c             	pushl  0xc(%ebp)
  8010f5:	6a 20                	push   $0x20
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	ff d0                	call   *%eax
  8010fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010ff:	ff 4d e4             	decl   -0x1c(%ebp)
  801102:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801106:	7f e7                	jg     8010ef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801108:	e9 78 01 00 00       	jmp    801285 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	ff 75 e8             	pushl  -0x18(%ebp)
  801113:	8d 45 14             	lea    0x14(%ebp),%eax
  801116:	50                   	push   %eax
  801117:	e8 3c fd ff ff       	call   800e58 <getint>
  80111c:	83 c4 10             	add    $0x10,%esp
  80111f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801122:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112b:	85 d2                	test   %edx,%edx
  80112d:	79 23                	jns    801152 <vprintfmt+0x29b>
				putch('-', putdat);
  80112f:	83 ec 08             	sub    $0x8,%esp
  801132:	ff 75 0c             	pushl  0xc(%ebp)
  801135:	6a 2d                	push   $0x2d
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	ff d0                	call   *%eax
  80113c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80113f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801142:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801145:	f7 d8                	neg    %eax
  801147:	83 d2 00             	adc    $0x0,%edx
  80114a:	f7 da                	neg    %edx
  80114c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801152:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801159:	e9 bc 00 00 00       	jmp    80121a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80115e:	83 ec 08             	sub    $0x8,%esp
  801161:	ff 75 e8             	pushl  -0x18(%ebp)
  801164:	8d 45 14             	lea    0x14(%ebp),%eax
  801167:	50                   	push   %eax
  801168:	e8 84 fc ff ff       	call   800df1 <getuint>
  80116d:	83 c4 10             	add    $0x10,%esp
  801170:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801173:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801176:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117d:	e9 98 00 00 00       	jmp    80121a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801182:	83 ec 08             	sub    $0x8,%esp
  801185:	ff 75 0c             	pushl  0xc(%ebp)
  801188:	6a 58                	push   $0x58
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	ff d0                	call   *%eax
  80118f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801192:	83 ec 08             	sub    $0x8,%esp
  801195:	ff 75 0c             	pushl  0xc(%ebp)
  801198:	6a 58                	push   $0x58
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	ff d0                	call   *%eax
  80119f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	6a 58                	push   $0x58
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	ff d0                	call   *%eax
  8011af:	83 c4 10             	add    $0x10,%esp
			break;
  8011b2:	e9 ce 00 00 00       	jmp    801285 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 0c             	pushl  0xc(%ebp)
  8011bd:	6a 30                	push   $0x30
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011c7:	83 ec 08             	sub    $0x8,%esp
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	6a 78                	push   $0x78
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011da:	83 c0 04             	add    $0x4,%eax
  8011dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 e8 04             	sub    $0x4,%eax
  8011e6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011f2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011f9:	eb 1f                	jmp    80121a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011fb:	83 ec 08             	sub    $0x8,%esp
  8011fe:	ff 75 e8             	pushl  -0x18(%ebp)
  801201:	8d 45 14             	lea    0x14(%ebp),%eax
  801204:	50                   	push   %eax
  801205:	e8 e7 fb ff ff       	call   800df1 <getuint>
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801210:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801213:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80121a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80121e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801221:	83 ec 04             	sub    $0x4,%esp
  801224:	52                   	push   %edx
  801225:	ff 75 e4             	pushl  -0x1c(%ebp)
  801228:	50                   	push   %eax
  801229:	ff 75 f4             	pushl  -0xc(%ebp)
  80122c:	ff 75 f0             	pushl  -0x10(%ebp)
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	ff 75 08             	pushl  0x8(%ebp)
  801235:	e8 00 fb ff ff       	call   800d3a <printnum>
  80123a:	83 c4 20             	add    $0x20,%esp
			break;
  80123d:	eb 46                	jmp    801285 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80123f:	83 ec 08             	sub    $0x8,%esp
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	53                   	push   %ebx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	ff d0                	call   *%eax
  80124b:	83 c4 10             	add    $0x10,%esp
			break;
  80124e:	eb 35                	jmp    801285 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801250:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801257:	eb 2c                	jmp    801285 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801259:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801260:	eb 23                	jmp    801285 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801262:	83 ec 08             	sub    $0x8,%esp
  801265:	ff 75 0c             	pushl  0xc(%ebp)
  801268:	6a 25                	push   $0x25
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	ff d0                	call   *%eax
  80126f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801272:	ff 4d 10             	decl   0x10(%ebp)
  801275:	eb 03                	jmp    80127a <vprintfmt+0x3c3>
  801277:	ff 4d 10             	decl   0x10(%ebp)
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	48                   	dec    %eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	3c 25                	cmp    $0x25,%al
  801282:	75 f3                	jne    801277 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801284:	90                   	nop
		}
	}
  801285:	e9 35 fc ff ff       	jmp    800ebf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80128a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80128b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801298:	8d 45 10             	lea    0x10(%ebp),%eax
  80129b:	83 c0 04             	add    $0x4,%eax
  80129e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8012a7:	50                   	push   %eax
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	ff 75 08             	pushl  0x8(%ebp)
  8012ae:	e8 04 fc ff ff       	call   800eb7 <vprintfmt>
  8012b3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012b6:	90                   	nop
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 40 08             	mov    0x8(%eax),%eax
  8012c2:	8d 50 01             	lea    0x1(%eax),%edx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8b 10                	mov    (%eax),%edx
  8012d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d3:	8b 40 04             	mov    0x4(%eax),%eax
  8012d6:	39 c2                	cmp    %eax,%edx
  8012d8:	73 12                	jae    8012ec <sprintputch+0x33>
		*b->buf++ = ch;
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e5:	89 0a                	mov    %ecx,(%edx)
  8012e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ea:	88 10                	mov    %dl,(%eax)
}
  8012ec:	90                   	nop
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	01 d0                	add    %edx,%eax
  801306:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801309:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801314:	74 06                	je     80131c <vsnprintf+0x2d>
  801316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131a:	7f 07                	jg     801323 <vsnprintf+0x34>
		return -E_INVAL;
  80131c:	b8 03 00 00 00       	mov    $0x3,%eax
  801321:	eb 20                	jmp    801343 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801323:	ff 75 14             	pushl  0x14(%ebp)
  801326:	ff 75 10             	pushl  0x10(%ebp)
  801329:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80132c:	50                   	push   %eax
  80132d:	68 b9 12 80 00       	push   $0x8012b9
  801332:	e8 80 fb ff ff       	call   800eb7 <vprintfmt>
  801337:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80133a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80133d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801340:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80134b:	8d 45 10             	lea    0x10(%ebp),%eax
  80134e:	83 c0 04             	add    $0x4,%eax
  801351:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	ff 75 f4             	pushl  -0xc(%ebp)
  80135a:	50                   	push   %eax
  80135b:	ff 75 0c             	pushl  0xc(%ebp)
  80135e:	ff 75 08             	pushl  0x8(%ebp)
  801361:	e8 89 ff ff ff       	call   8012ef <vsnprintf>
  801366:	83 c4 10             	add    $0x10,%esp
  801369:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80136c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80137b:	74 13                	je     801390 <readline+0x1f>
		cprintf("%s", prompt);
  80137d:	83 ec 08             	sub    $0x8,%esp
  801380:	ff 75 08             	pushl  0x8(%ebp)
  801383:	68 88 3a 80 00       	push   $0x803a88
  801388:	e8 0b f9 ff ff       	call   800c98 <cprintf>
  80138d:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801397:	83 ec 0c             	sub    $0xc,%esp
  80139a:	6a 00                	push   $0x0
  80139c:	e8 5a f4 ff ff       	call   8007fb <iscons>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8013a7:	e8 3c f4 ff ff       	call   8007e8 <getchar>
  8013ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013b3:	79 22                	jns    8013d7 <readline+0x66>
			if (c != -E_EOF)
  8013b5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013b9:	0f 84 ad 00 00 00    	je     80146c <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013bf:	83 ec 08             	sub    $0x8,%esp
  8013c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c5:	68 8b 3a 80 00       	push   $0x803a8b
  8013ca:	e8 c9 f8 ff ff       	call   800c98 <cprintf>
  8013cf:	83 c4 10             	add    $0x10,%esp
			break;
  8013d2:	e9 95 00 00 00       	jmp    80146c <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013d7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013db:	7e 34                	jle    801411 <readline+0xa0>
  8013dd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013e4:	7f 2b                	jg     801411 <readline+0xa0>
			if (echoing)
  8013e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ea:	74 0e                	je     8013fa <readline+0x89>
				cputchar(c);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f2:	e8 d2 f3 ff ff       	call   8007c9 <cputchar>
  8013f7:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fd:	8d 50 01             	lea    0x1(%eax),%edx
  801400:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801403:	89 c2                	mov    %eax,%edx
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	01 d0                	add    %edx,%eax
  80140a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80140d:	88 10                	mov    %dl,(%eax)
  80140f:	eb 56                	jmp    801467 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801411:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801415:	75 1f                	jne    801436 <readline+0xc5>
  801417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80141b:	7e 19                	jle    801436 <readline+0xc5>
			if (echoing)
  80141d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801421:	74 0e                	je     801431 <readline+0xc0>
				cputchar(c);
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	ff 75 ec             	pushl  -0x14(%ebp)
  801429:	e8 9b f3 ff ff       	call   8007c9 <cputchar>
  80142e:	83 c4 10             	add    $0x10,%esp

			i--;
  801431:	ff 4d f4             	decl   -0xc(%ebp)
  801434:	eb 31                	jmp    801467 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801436:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80143a:	74 0a                	je     801446 <readline+0xd5>
  80143c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801440:	0f 85 61 ff ff ff    	jne    8013a7 <readline+0x36>
			if (echoing)
  801446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80144a:	74 0e                	je     80145a <readline+0xe9>
				cputchar(c);
  80144c:	83 ec 0c             	sub    $0xc,%esp
  80144f:	ff 75 ec             	pushl  -0x14(%ebp)
  801452:	e8 72 f3 ff ff       	call   8007c9 <cputchar>
  801457:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80145a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801465:	eb 06                	jmp    80146d <readline+0xfc>
		}
	}
  801467:	e9 3b ff ff ff       	jmp    8013a7 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80146c:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80146d:	90                   	nop
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801476:	e8 30 0b 00 00       	call   801fab <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80147b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80147f:	74 13                	je     801494 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 08             	pushl  0x8(%ebp)
  801487:	68 88 3a 80 00       	push   $0x803a88
  80148c:	e8 07 f8 ff ff       	call   800c98 <cprintf>
  801491:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801494:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80149b:	83 ec 0c             	sub    $0xc,%esp
  80149e:	6a 00                	push   $0x0
  8014a0:	e8 56 f3 ff ff       	call   8007fb <iscons>
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8014ab:	e8 38 f3 ff ff       	call   8007e8 <getchar>
  8014b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8014b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014b7:	79 22                	jns    8014db <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014b9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014bd:	0f 84 ad 00 00 00    	je     801570 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8014c9:	68 8b 3a 80 00       	push   $0x803a8b
  8014ce:	e8 c5 f7 ff ff       	call   800c98 <cprintf>
  8014d3:	83 c4 10             	add    $0x10,%esp
				break;
  8014d6:	e9 95 00 00 00       	jmp    801570 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014db:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014df:	7e 34                	jle    801515 <atomic_readline+0xa5>
  8014e1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014e8:	7f 2b                	jg     801515 <atomic_readline+0xa5>
				if (echoing)
  8014ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014ee:	74 0e                	je     8014fe <atomic_readline+0x8e>
					cputchar(c);
  8014f0:	83 ec 0c             	sub    $0xc,%esp
  8014f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8014f6:	e8 ce f2 ff ff       	call   8007c9 <cputchar>
  8014fb:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8014fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801501:	8d 50 01             	lea    0x1(%eax),%edx
  801504:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801507:	89 c2                	mov    %eax,%edx
  801509:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150c:	01 d0                	add    %edx,%eax
  80150e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801511:	88 10                	mov    %dl,(%eax)
  801513:	eb 56                	jmp    80156b <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801515:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801519:	75 1f                	jne    80153a <atomic_readline+0xca>
  80151b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80151f:	7e 19                	jle    80153a <atomic_readline+0xca>
				if (echoing)
  801521:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801525:	74 0e                	je     801535 <atomic_readline+0xc5>
					cputchar(c);
  801527:	83 ec 0c             	sub    $0xc,%esp
  80152a:	ff 75 ec             	pushl  -0x14(%ebp)
  80152d:	e8 97 f2 ff ff       	call   8007c9 <cputchar>
  801532:	83 c4 10             	add    $0x10,%esp
				i--;
  801535:	ff 4d f4             	decl   -0xc(%ebp)
  801538:	eb 31                	jmp    80156b <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80153a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80153e:	74 0a                	je     80154a <atomic_readline+0xda>
  801540:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801544:	0f 85 61 ff ff ff    	jne    8014ab <atomic_readline+0x3b>
				if (echoing)
  80154a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80154e:	74 0e                	je     80155e <atomic_readline+0xee>
					cputchar(c);
  801550:	83 ec 0c             	sub    $0xc,%esp
  801553:	ff 75 ec             	pushl  -0x14(%ebp)
  801556:	e8 6e f2 ff ff       	call   8007c9 <cputchar>
  80155b:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80155e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 d0                	add    %edx,%eax
  801566:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801569:	eb 06                	jmp    801571 <atomic_readline+0x101>
			}
		}
  80156b:	e9 3b ff ff ff       	jmp    8014ab <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801570:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801571:	e8 4f 0a 00 00       	call   801fc5 <sys_unlock_cons>
}
  801576:	90                   	nop
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80157f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801586:	eb 06                	jmp    80158e <strlen+0x15>
		n++;
  801588:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158b:	ff 45 08             	incl   0x8(%ebp)
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	84 c0                	test   %al,%al
  801595:	75 f1                	jne    801588 <strlen+0xf>
		n++;
	return n;
  801597:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015a9:	eb 09                	jmp    8015b4 <strnlen+0x18>
		n++;
  8015ab:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015ae:	ff 45 08             	incl   0x8(%ebp)
  8015b1:	ff 4d 0c             	decl   0xc(%ebp)
  8015b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b8:	74 09                	je     8015c3 <strnlen+0x27>
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	8a 00                	mov    (%eax),%al
  8015bf:	84 c0                	test   %al,%al
  8015c1:	75 e8                	jne    8015ab <strnlen+0xf>
		n++;
	return n;
  8015c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d4:	90                   	nop
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8d 50 01             	lea    0x1(%eax),%edx
  8015db:	89 55 08             	mov    %edx,0x8(%ebp)
  8015de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e7:	8a 12                	mov    (%edx),%dl
  8015e9:	88 10                	mov    %dl,(%eax)
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	84 c0                	test   %al,%al
  8015ef:	75 e4                	jne    8015d5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801609:	eb 1f                	jmp    80162a <strncpy+0x34>
		*dst++ = *src;
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 08             	mov    %edx,0x8(%ebp)
  801614:	8b 55 0c             	mov    0xc(%ebp),%edx
  801617:	8a 12                	mov    (%edx),%dl
  801619:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	84 c0                	test   %al,%al
  801622:	74 03                	je     801627 <strncpy+0x31>
			src++;
  801624:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801627:	ff 45 fc             	incl   -0x4(%ebp)
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801630:	72 d9                	jb     80160b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801632:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801643:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801647:	74 30                	je     801679 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801649:	eb 16                	jmp    801661 <strlcpy+0x2a>
			*dst++ = *src++;
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8d 50 01             	lea    0x1(%eax),%edx
  801651:	89 55 08             	mov    %edx,0x8(%ebp)
  801654:	8b 55 0c             	mov    0xc(%ebp),%edx
  801657:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165d:	8a 12                	mov    (%edx),%dl
  80165f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801661:	ff 4d 10             	decl   0x10(%ebp)
  801664:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801668:	74 09                	je     801673 <strlcpy+0x3c>
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	75 d8                	jne    80164b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801679:	8b 55 08             	mov    0x8(%ebp),%edx
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167f:	29 c2                	sub    %eax,%edx
  801681:	89 d0                	mov    %edx,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801688:	eb 06                	jmp    801690 <strcmp+0xb>
		p++, q++;
  80168a:	ff 45 08             	incl   0x8(%ebp)
  80168d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	74 0e                	je     8016a7 <strcmp+0x22>
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8a 10                	mov    (%eax),%dl
  80169e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a1:	8a 00                	mov    (%eax),%al
  8016a3:	38 c2                	cmp    %al,%dl
  8016a5:	74 e3                	je     80168a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	8a 00                	mov    (%eax),%al
  8016ac:	0f b6 d0             	movzbl %al,%edx
  8016af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	0f b6 c0             	movzbl %al,%eax
  8016b7:	29 c2                	sub    %eax,%edx
  8016b9:	89 d0                	mov    %edx,%eax
}
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    

008016bd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c0:	eb 09                	jmp    8016cb <strncmp+0xe>
		n--, p++, q++;
  8016c2:	ff 4d 10             	decl   0x10(%ebp)
  8016c5:	ff 45 08             	incl   0x8(%ebp)
  8016c8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 17                	je     8016e8 <strncmp+0x2b>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	74 0e                	je     8016e8 <strncmp+0x2b>
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 10                	mov    (%eax),%dl
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	38 c2                	cmp    %al,%dl
  8016e6:	74 da                	je     8016c2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ec:	75 07                	jne    8016f5 <strncmp+0x38>
		return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	eb 14                	jmp    801709 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	0f b6 d0             	movzbl %al,%edx
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f b6 c0             	movzbl %al,%eax
  801705:	29 c2                	sub    %eax,%edx
  801707:	89 d0                	mov    %edx,%eax
}
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    

0080170b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	8b 45 0c             	mov    0xc(%ebp),%eax
  801714:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801717:	eb 12                	jmp    80172b <strchr+0x20>
		if (*s == c)
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801721:	75 05                	jne    801728 <strchr+0x1d>
			return (char *) s;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	eb 11                	jmp    801739 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8a 00                	mov    (%eax),%al
  801730:	84 c0                	test   %al,%al
  801732:	75 e5                	jne    801719 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801747:	eb 0d                	jmp    801756 <strfind+0x1b>
		if (*s == c)
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801751:	74 0e                	je     801761 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801753:	ff 45 08             	incl   0x8(%ebp)
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	84 c0                	test   %al,%al
  80175d:	75 ea                	jne    801749 <strfind+0xe>
  80175f:	eb 01                	jmp    801762 <strfind+0x27>
		if (*s == c)
			break;
  801761:	90                   	nop
	return (char *) s;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801773:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801777:	76 63                	jbe    8017dc <memset+0x75>
		uint64 data_block = c;
  801779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177c:	99                   	cltd   
  80177d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801780:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801789:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80178d:	c1 e0 08             	shl    $0x8,%eax
  801790:	09 45 f0             	or     %eax,-0x10(%ebp)
  801793:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8017a0:	c1 e0 10             	shl    $0x10,%eax
  8017a3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017a6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8017a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017af:	89 c2                	mov    %eax,%edx
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017b9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017bc:	eb 18                	jmp    8017d6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c1:	8d 41 08             	lea    0x8(%ecx),%eax
  8017c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cd:	89 01                	mov    %eax,(%ecx)
  8017cf:	89 51 04             	mov    %edx,0x4(%ecx)
  8017d2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017d6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017da:	77 e2                	ja     8017be <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e0:	74 23                	je     801805 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017e8:	eb 0e                	jmp    8017f8 <memset+0x91>
			*p8++ = (uint8)c;
  8017ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ed:	8d 50 01             	lea    0x1(%eax),%edx
  8017f0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8017f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801801:	85 c0                	test   %eax,%eax
  801803:	75 e5                	jne    8017ea <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80181c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801820:	76 24                	jbe    801846 <memcpy+0x3c>
		while(n >= 8){
  801822:	eb 1c                	jmp    801840 <memcpy+0x36>
			*d64 = *s64;
  801824:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801827:	8b 50 04             	mov    0x4(%eax),%edx
  80182a:	8b 00                	mov    (%eax),%eax
  80182c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80182f:	89 01                	mov    %eax,(%ecx)
  801831:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801834:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801838:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80183c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801840:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801844:	77 de                	ja     801824 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801846:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80184a:	74 31                	je     80187d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801852:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801855:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801858:	eb 16                	jmp    801870 <memcpy+0x66>
			*d8++ = *s8++;
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	8d 50 01             	lea    0x1(%eax),%edx
  801860:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801866:	8d 4a 01             	lea    0x1(%edx),%ecx
  801869:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80186c:	8a 12                	mov    (%edx),%dl
  80186e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801870:	8b 45 10             	mov    0x10(%ebp),%eax
  801873:	8d 50 ff             	lea    -0x1(%eax),%edx
  801876:	89 55 10             	mov    %edx,0x10(%ebp)
  801879:	85 c0                	test   %eax,%eax
  80187b:	75 dd                	jne    80185a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801894:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801897:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80189a:	73 50                	jae    8018ec <memmove+0x6a>
  80189c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189f:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a2:	01 d0                	add    %edx,%eax
  8018a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018a7:	76 43                	jbe    8018ec <memmove+0x6a>
		s += n;
  8018a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018af:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018b5:	eb 10                	jmp    8018c7 <memmove+0x45>
			*--d = *--s;
  8018b7:	ff 4d f8             	decl   -0x8(%ebp)
  8018ba:	ff 4d fc             	decl   -0x4(%ebp)
  8018bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c0:	8a 10                	mov    (%eax),%dl
  8018c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	75 e3                	jne    8018b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018d4:	eb 23                	jmp    8018f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d9:	8d 50 01             	lea    0x1(%eax),%edx
  8018dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018e8:	8a 12                	mov    (%edx),%dl
  8018ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	75 dd                	jne    8018d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80190a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801910:	eb 2a                	jmp    80193c <memcmp+0x3e>
		if (*s1 != *s2)
  801912:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801915:	8a 10                	mov    (%eax),%dl
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	8a 00                	mov    (%eax),%al
  80191c:	38 c2                	cmp    %al,%dl
  80191e:	74 16                	je     801936 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801920:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801923:	8a 00                	mov    (%eax),%al
  801925:	0f b6 d0             	movzbl %al,%edx
  801928:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192b:	8a 00                	mov    (%eax),%al
  80192d:	0f b6 c0             	movzbl %al,%eax
  801930:	29 c2                	sub    %eax,%edx
  801932:	89 d0                	mov    %edx,%eax
  801934:	eb 18                	jmp    80194e <memcmp+0x50>
		s1++, s2++;
  801936:	ff 45 fc             	incl   -0x4(%ebp)
  801939:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80193c:	8b 45 10             	mov    0x10(%ebp),%eax
  80193f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801942:	89 55 10             	mov    %edx,0x10(%ebp)
  801945:	85 c0                	test   %eax,%eax
  801947:	75 c9                	jne    801912 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801949:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801956:	8b 55 08             	mov    0x8(%ebp),%edx
  801959:	8b 45 10             	mov    0x10(%ebp),%eax
  80195c:	01 d0                	add    %edx,%eax
  80195e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801961:	eb 15                	jmp    801978 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	8a 00                	mov    (%eax),%al
  801968:	0f b6 d0             	movzbl %al,%edx
  80196b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196e:	0f b6 c0             	movzbl %al,%eax
  801971:	39 c2                	cmp    %eax,%edx
  801973:	74 0d                	je     801982 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801975:	ff 45 08             	incl   0x8(%ebp)
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80197e:	72 e3                	jb     801963 <memfind+0x13>
  801980:	eb 01                	jmp    801983 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801982:	90                   	nop
	return (void *) s;
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80198e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801995:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80199c:	eb 03                	jmp    8019a1 <strtol+0x19>
		s++;
  80199e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	8a 00                	mov    (%eax),%al
  8019a6:	3c 20                	cmp    $0x20,%al
  8019a8:	74 f4                	je     80199e <strtol+0x16>
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	3c 09                	cmp    $0x9,%al
  8019b1:	74 eb                	je     80199e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	8a 00                	mov    (%eax),%al
  8019b8:	3c 2b                	cmp    $0x2b,%al
  8019ba:	75 05                	jne    8019c1 <strtol+0x39>
		s++;
  8019bc:	ff 45 08             	incl   0x8(%ebp)
  8019bf:	eb 13                	jmp    8019d4 <strtol+0x4c>
	else if (*s == '-')
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	8a 00                	mov    (%eax),%al
  8019c6:	3c 2d                	cmp    $0x2d,%al
  8019c8:	75 0a                	jne    8019d4 <strtol+0x4c>
		s++, neg = 1;
  8019ca:	ff 45 08             	incl   0x8(%ebp)
  8019cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d8:	74 06                	je     8019e0 <strtol+0x58>
  8019da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019de:	75 20                	jne    801a00 <strtol+0x78>
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 30                	cmp    $0x30,%al
  8019e7:	75 17                	jne    801a00 <strtol+0x78>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	40                   	inc    %eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	3c 78                	cmp    $0x78,%al
  8019f1:	75 0d                	jne    801a00 <strtol+0x78>
		s += 2, base = 16;
  8019f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019fe:	eb 28                	jmp    801a28 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a04:	75 15                	jne    801a1b <strtol+0x93>
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	8a 00                	mov    (%eax),%al
  801a0b:	3c 30                	cmp    $0x30,%al
  801a0d:	75 0c                	jne    801a1b <strtol+0x93>
		s++, base = 8;
  801a0f:	ff 45 08             	incl   0x8(%ebp)
  801a12:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a19:	eb 0d                	jmp    801a28 <strtol+0xa0>
	else if (base == 0)
  801a1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a1f:	75 07                	jne    801a28 <strtol+0xa0>
		base = 10;
  801a21:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8a 00                	mov    (%eax),%al
  801a2d:	3c 2f                	cmp    $0x2f,%al
  801a2f:	7e 19                	jle    801a4a <strtol+0xc2>
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	8a 00                	mov    (%eax),%al
  801a36:	3c 39                	cmp    $0x39,%al
  801a38:	7f 10                	jg     801a4a <strtol+0xc2>
			dig = *s - '0';
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8a 00                	mov    (%eax),%al
  801a3f:	0f be c0             	movsbl %al,%eax
  801a42:	83 e8 30             	sub    $0x30,%eax
  801a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a48:	eb 42                	jmp    801a8c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	8a 00                	mov    (%eax),%al
  801a4f:	3c 60                	cmp    $0x60,%al
  801a51:	7e 19                	jle    801a6c <strtol+0xe4>
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8a 00                	mov    (%eax),%al
  801a58:	3c 7a                	cmp    $0x7a,%al
  801a5a:	7f 10                	jg     801a6c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	8a 00                	mov    (%eax),%al
  801a61:	0f be c0             	movsbl %al,%eax
  801a64:	83 e8 57             	sub    $0x57,%eax
  801a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a6a:	eb 20                	jmp    801a8c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8a 00                	mov    (%eax),%al
  801a71:	3c 40                	cmp    $0x40,%al
  801a73:	7e 39                	jle    801aae <strtol+0x126>
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	8a 00                	mov    (%eax),%al
  801a7a:	3c 5a                	cmp    $0x5a,%al
  801a7c:	7f 30                	jg     801aae <strtol+0x126>
			dig = *s - 'A' + 10;
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	8a 00                	mov    (%eax),%al
  801a83:	0f be c0             	movsbl %al,%eax
  801a86:	83 e8 37             	sub    $0x37,%eax
  801a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a92:	7d 19                	jge    801aad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a94:	ff 45 08             	incl   0x8(%ebp)
  801a97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a9a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a9e:	89 c2                	mov    %eax,%edx
  801aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801aa8:	e9 7b ff ff ff       	jmp    801a28 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801aad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801aae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ab2:	74 08                	je     801abc <strtol+0x134>
		*endptr = (char *) s;
  801ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab7:	8b 55 08             	mov    0x8(%ebp),%edx
  801aba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801abc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac0:	74 07                	je     801ac9 <strtol+0x141>
  801ac2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac5:	f7 d8                	neg    %eax
  801ac7:	eb 03                	jmp    801acc <strtol+0x144>
  801ac9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <ltostr>:

void
ltostr(long value, char *str)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ad4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801adb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ae6:	79 13                	jns    801afb <ltostr+0x2d>
	{
		neg = 1;
  801ae8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801af5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801af8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b03:	99                   	cltd   
  801b04:	f7 f9                	idiv   %ecx
  801b06:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0c:	8d 50 01             	lea    0x1(%eax),%edx
  801b0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b12:	89 c2                	mov    %eax,%edx
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b1c:	83 c2 30             	add    $0x30,%edx
  801b1f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b24:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b29:	f7 e9                	imul   %ecx
  801b2b:	c1 fa 02             	sar    $0x2,%edx
  801b2e:	89 c8                	mov    %ecx,%eax
  801b30:	c1 f8 1f             	sar    $0x1f,%eax
  801b33:	29 c2                	sub    %eax,%edx
  801b35:	89 d0                	mov    %edx,%eax
  801b37:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b3e:	75 bb                	jne    801afb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4a:	48                   	dec    %eax
  801b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b52:	74 3d                	je     801b91 <ltostr+0xc3>
		start = 1 ;
  801b54:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b5b:	eb 34                	jmp    801b91 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b63:	01 d0                	add    %edx,%eax
  801b65:	8a 00                	mov    (%eax),%al
  801b67:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b70:	01 c2                	add    %eax,%edx
  801b72:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b78:	01 c8                	add    %ecx,%eax
  801b7a:	8a 00                	mov    (%eax),%al
  801b7c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b84:	01 c2                	add    %eax,%edx
  801b86:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b89:	88 02                	mov    %al,(%edx)
		start++ ;
  801b8b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b8e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b94:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b97:	7c c4                	jl     801b5d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b99:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9f:	01 d0                	add    %edx,%eax
  801ba1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801ba4:	90                   	nop
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	e8 c4 f9 ff ff       	call   801579 <strlen>
  801bb5:	83 c4 04             	add    $0x4,%esp
  801bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	e8 b6 f9 ff ff       	call   801579 <strlen>
  801bc3:	83 c4 04             	add    $0x4,%esp
  801bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801bc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bd7:	eb 17                	jmp    801bf0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdf:	01 c2                	add    %eax,%edx
  801be1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	01 c8                	add    %ecx,%eax
  801be9:	8a 00                	mov    (%eax),%al
  801beb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bed:	ff 45 fc             	incl   -0x4(%ebp)
  801bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bf3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bf6:	7c e1                	jl     801bd9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bf8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c06:	eb 1f                	jmp    801c27 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c0b:	8d 50 01             	lea    0x1(%eax),%edx
  801c0e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c11:	89 c2                	mov    %eax,%edx
  801c13:	8b 45 10             	mov    0x10(%ebp),%eax
  801c16:	01 c2                	add    %eax,%edx
  801c18:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1e:	01 c8                	add    %ecx,%eax
  801c20:	8a 00                	mov    (%eax),%al
  801c22:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c24:	ff 45 f8             	incl   -0x8(%ebp)
  801c27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c2a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c2d:	7c d9                	jl     801c08 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c32:	8b 45 10             	mov    0x10(%ebp),%eax
  801c35:	01 d0                	add    %edx,%eax
  801c37:	c6 00 00             	movb   $0x0,(%eax)
}
  801c3a:	90                   	nop
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c40:	8b 45 14             	mov    0x14(%ebp),%eax
  801c43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c49:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4c:	8b 00                	mov    (%eax),%eax
  801c4e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c55:	8b 45 10             	mov    0x10(%ebp),%eax
  801c58:	01 d0                	add    %edx,%eax
  801c5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c60:	eb 0c                	jmp    801c6e <strsplit+0x31>
			*string++ = 0;
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8d 50 01             	lea    0x1(%eax),%edx
  801c68:	89 55 08             	mov    %edx,0x8(%ebp)
  801c6b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	8a 00                	mov    (%eax),%al
  801c73:	84 c0                	test   %al,%al
  801c75:	74 18                	je     801c8f <strsplit+0x52>
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	8a 00                	mov    (%eax),%al
  801c7c:	0f be c0             	movsbl %al,%eax
  801c7f:	50                   	push   %eax
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	e8 83 fa ff ff       	call   80170b <strchr>
  801c88:	83 c4 08             	add    $0x8,%esp
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	75 d3                	jne    801c62 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	8a 00                	mov    (%eax),%al
  801c94:	84 c0                	test   %al,%al
  801c96:	74 5a                	je     801cf2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c98:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9b:	8b 00                	mov    (%eax),%eax
  801c9d:	83 f8 0f             	cmp    $0xf,%eax
  801ca0:	75 07                	jne    801ca9 <strsplit+0x6c>
		{
			return 0;
  801ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca7:	eb 66                	jmp    801d0f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cac:	8b 00                	mov    (%eax),%eax
  801cae:	8d 48 01             	lea    0x1(%eax),%ecx
  801cb1:	8b 55 14             	mov    0x14(%ebp),%edx
  801cb4:	89 0a                	mov    %ecx,(%edx)
  801cb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc0:	01 c2                	add    %eax,%edx
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cc7:	eb 03                	jmp    801ccc <strsplit+0x8f>
			string++;
  801cc9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8a 00                	mov    (%eax),%al
  801cd1:	84 c0                	test   %al,%al
  801cd3:	74 8b                	je     801c60 <strsplit+0x23>
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	8a 00                	mov    (%eax),%al
  801cda:	0f be c0             	movsbl %al,%eax
  801cdd:	50                   	push   %eax
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	e8 25 fa ff ff       	call   80170b <strchr>
  801ce6:	83 c4 08             	add    $0x8,%esp
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	74 dc                	je     801cc9 <strsplit+0x8c>
			string++;
	}
  801ced:	e9 6e ff ff ff       	jmp    801c60 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cf2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cf3:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf6:	8b 00                	mov    (%eax),%eax
  801cf8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cff:	8b 45 10             	mov    0x10(%ebp),%eax
  801d02:	01 d0                	add    %edx,%eax
  801d04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d0a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d24:	eb 4a                	jmp    801d70 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d26:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	01 c2                	add    %eax,%edx
  801d2e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d34:	01 c8                	add    %ecx,%eax
  801d36:	8a 00                	mov    (%eax),%al
  801d38:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d40:	01 d0                	add    %edx,%eax
  801d42:	8a 00                	mov    (%eax),%al
  801d44:	3c 40                	cmp    $0x40,%al
  801d46:	7e 25                	jle    801d6d <str2lower+0x5c>
  801d48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4e:	01 d0                	add    %edx,%eax
  801d50:	8a 00                	mov    (%eax),%al
  801d52:	3c 5a                	cmp    $0x5a,%al
  801d54:	7f 17                	jg     801d6d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	01 d0                	add    %edx,%eax
  801d5e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d61:	8b 55 08             	mov    0x8(%ebp),%edx
  801d64:	01 ca                	add    %ecx,%edx
  801d66:	8a 12                	mov    (%edx),%dl
  801d68:	83 c2 20             	add    $0x20,%edx
  801d6b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d6d:	ff 45 fc             	incl   -0x4(%ebp)
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	e8 01 f8 ff ff       	call   801579 <strlen>
  801d78:	83 c4 04             	add    $0x4,%esp
  801d7b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d7e:	7f a6                	jg     801d26 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801d8b:	a1 08 40 80 00       	mov    0x804008,%eax
  801d90:	85 c0                	test   %eax,%eax
  801d92:	74 42                	je     801dd6 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	68 00 00 00 82       	push   $0x82000000
  801d9c:	68 00 00 00 80       	push   $0x80000000
  801da1:	e8 00 08 00 00       	call   8025a6 <initialize_dynamic_allocator>
  801da6:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801da9:	e8 e7 05 00 00       	call   802395 <sys_get_uheap_strategy>
  801dae:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801db3:	a1 40 40 80 00       	mov    0x804040,%eax
  801db8:	05 00 10 00 00       	add    $0x1000,%eax
  801dbd:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801dc2:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801dc7:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801dcc:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801dd3:	00 00 00 
	}
}
  801dd6:	90                   	nop
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	68 06 04 00 00       	push   $0x406
  801df5:	50                   	push   %eax
  801df6:	e8 e4 01 00 00       	call   801fdf <__sys_allocate_page>
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e05:	79 14                	jns    801e1b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	68 9c 3a 80 00       	push   $0x803a9c
  801e0f:	6a 1f                	push   $0x1f
  801e11:	68 d8 3a 80 00       	push   $0x803ad8
  801e16:	e8 af eb ff ff       	call   8009ca <_panic>
	return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	50                   	push   %eax
  801e3a:	e8 e7 01 00 00       	call   802026 <__sys_unmap_frame>
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e49:	79 14                	jns    801e5f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801e4b:	83 ec 04             	sub    $0x4,%esp
  801e4e:	68 e4 3a 80 00       	push   $0x803ae4
  801e53:	6a 2a                	push   $0x2a
  801e55:	68 d8 3a 80 00       	push   $0x803ad8
  801e5a:	e8 6b eb ff ff       	call   8009ca <_panic>
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e68:	e8 18 ff ff ff       	call   801d85 <uheap_init>
	if (size == 0) return NULL ;
  801e6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e71:	75 07                	jne    801e7a <malloc+0x18>
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
  801e78:	eb 14                	jmp    801e8e <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	68 24 3b 80 00       	push   $0x803b24
  801e82:	6a 3e                	push   $0x3e
  801e84:	68 d8 3a 80 00       	push   $0x803ad8
  801e89:	e8 3c eb ff ff       	call   8009ca <_panic>
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	68 4c 3b 80 00       	push   $0x803b4c
  801e9e:	6a 49                	push   $0x49
  801ea0:	68 d8 3a 80 00       	push   $0x803ad8
  801ea5:	e8 20 eb ff ff       	call   8009ca <_panic>

00801eaa <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 18             	sub    $0x18,%esp
  801eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb3:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801eb6:	e8 ca fe ff ff       	call   801d85 <uheap_init>
	if (size == 0) return NULL ;
  801ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ebf:	75 07                	jne    801ec8 <smalloc+0x1e>
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec6:	eb 14                	jmp    801edc <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	68 70 3b 80 00       	push   $0x803b70
  801ed0:	6a 5a                	push   $0x5a
  801ed2:	68 d8 3a 80 00       	push   $0x803ad8
  801ed7:	e8 ee ea ff ff       	call   8009ca <_panic>
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ee4:	e8 9c fe ff ff       	call   801d85 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	68 98 3b 80 00       	push   $0x803b98
  801ef1:	6a 6a                	push   $0x6a
  801ef3:	68 d8 3a 80 00       	push   $0x803ad8
  801ef8:	e8 cd ea ff ff       	call   8009ca <_panic>

00801efd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f03:	e8 7d fe ff ff       	call   801d85 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	68 bc 3b 80 00       	push   $0x803bbc
  801f10:	68 88 00 00 00       	push   $0x88
  801f15:	68 d8 3a 80 00       	push   $0x803ad8
  801f1a:	e8 ab ea ff ff       	call   8009ca <_panic>

00801f1f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	68 e4 3b 80 00       	push   $0x803be4
  801f2d:	68 9b 00 00 00       	push   $0x9b
  801f32:	68 d8 3a 80 00       	push   $0x803ad8
  801f37:	e8 8e ea ff ff       	call   8009ca <_panic>

00801f3c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	57                   	push   %edi
  801f40:	56                   	push   %esi
  801f41:	53                   	push   %ebx
  801f42:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f51:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f54:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f57:	cd 30                	int    $0x30
  801f59:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	5b                   	pop    %ebx
  801f63:	5e                   	pop    %esi
  801f64:	5f                   	pop    %edi
  801f65:	5d                   	pop    %ebp
  801f66:	c3                   	ret    

00801f67 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801f73:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f76:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	6a 00                	push   $0x0
  801f7f:	51                   	push   %ecx
  801f80:	52                   	push   %edx
  801f81:	ff 75 0c             	pushl  0xc(%ebp)
  801f84:	50                   	push   %eax
  801f85:	6a 00                	push   $0x0
  801f87:	e8 b0 ff ff ff       	call   801f3c <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	90                   	nop
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 02                	push   $0x2
  801fa1:	e8 96 ff ff ff       	call   801f3c <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_lock_cons>:

void sys_lock_cons(void)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 03                	push   $0x3
  801fba:	e8 7d ff ff ff       	call   801f3c <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
}
  801fc2:	90                   	nop
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 04                	push   $0x4
  801fd4:	e8 63 ff ff ff       	call   801f3c <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	90                   	nop
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	52                   	push   %edx
  801fef:	50                   	push   %eax
  801ff0:	6a 08                	push   $0x8
  801ff2:	e8 45 ff ff ff       	call   801f3c <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	56                   	push   %esi
  802000:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802001:	8b 75 18             	mov    0x18(%ebp),%esi
  802004:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802007:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80200a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	56                   	push   %esi
  802011:	53                   	push   %ebx
  802012:	51                   	push   %ecx
  802013:	52                   	push   %edx
  802014:	50                   	push   %eax
  802015:	6a 09                	push   $0x9
  802017:	e8 20 ff ff ff       	call   801f3c <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802022:	5b                   	pop    %ebx
  802023:	5e                   	pop    %esi
  802024:	5d                   	pop    %ebp
  802025:	c3                   	ret    

00802026 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	ff 75 08             	pushl  0x8(%ebp)
  802034:	6a 0a                	push   $0xa
  802036:	e8 01 ff ff ff       	call   801f3c <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	ff 75 0c             	pushl  0xc(%ebp)
  80204c:	ff 75 08             	pushl  0x8(%ebp)
  80204f:	6a 0b                	push   $0xb
  802051:	e8 e6 fe ff ff       	call   801f3c <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 0c                	push   $0xc
  80206a:	e8 cd fe ff ff       	call   801f3c <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 0d                	push   $0xd
  802083:	e8 b4 fe ff ff       	call   801f3c <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 0e                	push   $0xe
  80209c:	e8 9b fe ff ff       	call   801f3c <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 0f                	push   $0xf
  8020b5:	e8 82 fe ff ff       	call   801f3c <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	ff 75 08             	pushl  0x8(%ebp)
  8020cd:	6a 10                	push   $0x10
  8020cf:	e8 68 fe ff ff       	call   801f3c <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 11                	push   $0x11
  8020e8:	e8 4f fe ff ff       	call   801f3c <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
}
  8020f0:	90                   	nop
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	50                   	push   %eax
  80210c:	6a 01                	push   $0x1
  80210e:	e8 29 fe ff ff       	call   801f3c <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	90                   	nop
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 14                	push   $0x14
  802128:	e8 0f fe ff ff       	call   801f3c <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	90                   	nop
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	8b 45 10             	mov    0x10(%ebp),%eax
  80213c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80213f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802142:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	6a 00                	push   $0x0
  80214b:	51                   	push   %ecx
  80214c:	52                   	push   %edx
  80214d:	ff 75 0c             	pushl  0xc(%ebp)
  802150:	50                   	push   %eax
  802151:	6a 15                	push   $0x15
  802153:	e8 e4 fd ff ff       	call   801f3c <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802160:	8b 55 0c             	mov    0xc(%ebp),%edx
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	52                   	push   %edx
  80216d:	50                   	push   %eax
  80216e:	6a 16                	push   $0x16
  802170:	e8 c7 fd ff ff       	call   801f3c <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80217d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802180:	8b 55 0c             	mov    0xc(%ebp),%edx
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	51                   	push   %ecx
  80218b:	52                   	push   %edx
  80218c:	50                   	push   %eax
  80218d:	6a 17                	push   $0x17
  80218f:	e8 a8 fd ff ff       	call   801f3c <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80219c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	52                   	push   %edx
  8021a9:	50                   	push   %eax
  8021aa:	6a 18                	push   $0x18
  8021ac:	e8 8b fd ff ff       	call   801f3c <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	6a 00                	push   $0x0
  8021be:	ff 75 14             	pushl  0x14(%ebp)
  8021c1:	ff 75 10             	pushl  0x10(%ebp)
  8021c4:	ff 75 0c             	pushl  0xc(%ebp)
  8021c7:	50                   	push   %eax
  8021c8:	6a 19                	push   $0x19
  8021ca:	e8 6d fd ff ff       	call   801f3c <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	50                   	push   %eax
  8021e3:	6a 1a                	push   $0x1a
  8021e5:	e8 52 fd ff ff       	call   801f3c <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
}
  8021ed:	90                   	nop
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	50                   	push   %eax
  8021ff:	6a 1b                	push   $0x1b
  802201:	e8 36 fd ff ff       	call   801f3c <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 05                	push   $0x5
  80221a:	e8 1d fd ff ff       	call   801f3c <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 06                	push   $0x6
  802233:	e8 04 fd ff ff       	call   801f3c <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 07                	push   $0x7
  80224c:	e8 eb fc ff ff       	call   801f3c <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_exit_env>:


void sys_exit_env(void)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 1c                	push   $0x1c
  802265:	e8 d2 fc ff ff       	call   801f3c <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	90                   	nop
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802276:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802279:	8d 50 04             	lea    0x4(%eax),%edx
  80227c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	52                   	push   %edx
  802286:	50                   	push   %eax
  802287:	6a 1d                	push   $0x1d
  802289:	e8 ae fc ff ff       	call   801f3c <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
	return result;
  802291:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802294:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802297:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80229a:	89 01                	mov    %eax,(%ecx)
  80229c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	c9                   	leave  
  8022a3:	c2 04 00             	ret    $0x4

008022a6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	ff 75 10             	pushl  0x10(%ebp)
  8022b0:	ff 75 0c             	pushl  0xc(%ebp)
  8022b3:	ff 75 08             	pushl  0x8(%ebp)
  8022b6:	6a 13                	push   $0x13
  8022b8:	e8 7f fc ff ff       	call   801f3c <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c0:	90                   	nop
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 1e                	push   $0x1e
  8022d2:	e8 65 fc ff ff       	call   801f3c <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022e8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	50                   	push   %eax
  8022f5:	6a 1f                	push   $0x1f
  8022f7:	e8 40 fc ff ff       	call   801f3c <syscall>
  8022fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ff:	90                   	nop
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <rsttst>:
void rsttst()
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 21                	push   $0x21
  802311:	e8 26 fc ff ff       	call   801f3c <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
	return ;
  802319:	90                   	nop
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 04             	sub    $0x4,%esp
  802322:	8b 45 14             	mov    0x14(%ebp),%eax
  802325:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802328:	8b 55 18             	mov    0x18(%ebp),%edx
  80232b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80232f:	52                   	push   %edx
  802330:	50                   	push   %eax
  802331:	ff 75 10             	pushl  0x10(%ebp)
  802334:	ff 75 0c             	pushl  0xc(%ebp)
  802337:	ff 75 08             	pushl  0x8(%ebp)
  80233a:	6a 20                	push   $0x20
  80233c:	e8 fb fb ff ff       	call   801f3c <syscall>
  802341:	83 c4 18             	add    $0x18,%esp
	return ;
  802344:	90                   	nop
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <chktst>:
void chktst(uint32 n)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	ff 75 08             	pushl  0x8(%ebp)
  802355:	6a 22                	push   $0x22
  802357:	e8 e0 fb ff ff       	call   801f3c <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
	return ;
  80235f:	90                   	nop
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <inctst>:

void inctst()
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 23                	push   $0x23
  802371:	e8 c6 fb ff ff       	call   801f3c <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
	return ;
  802379:	90                   	nop
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <gettst>:
uint32 gettst()
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 24                	push   $0x24
  80238b:	e8 ac fb ff ff       	call   801f3c <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 25                	push   $0x25
  8023a4:	e8 93 fb ff ff       	call   801f3c <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
  8023ac:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8023b1:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	ff 75 08             	pushl  0x8(%ebp)
  8023ce:	6a 26                	push   $0x26
  8023d0:	e8 67 fb ff ff       	call   801f3c <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d8:	90                   	nop
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	6a 00                	push   $0x0
  8023ed:	53                   	push   %ebx
  8023ee:	51                   	push   %ecx
  8023ef:	52                   	push   %edx
  8023f0:	50                   	push   %eax
  8023f1:	6a 27                	push   $0x27
  8023f3:	e8 44 fb ff ff       	call   801f3c <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802403:	8b 55 0c             	mov    0xc(%ebp),%edx
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	52                   	push   %edx
  802410:	50                   	push   %eax
  802411:	6a 28                	push   $0x28
  802413:	e8 24 fb ff ff       	call   801f3c <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802420:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802423:	8b 55 0c             	mov    0xc(%ebp),%edx
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	51                   	push   %ecx
  80242c:	ff 75 10             	pushl  0x10(%ebp)
  80242f:	52                   	push   %edx
  802430:	50                   	push   %eax
  802431:	6a 29                	push   $0x29
  802433:	e8 04 fb ff ff       	call   801f3c <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	ff 75 10             	pushl  0x10(%ebp)
  802447:	ff 75 0c             	pushl  0xc(%ebp)
  80244a:	ff 75 08             	pushl  0x8(%ebp)
  80244d:	6a 12                	push   $0x12
  80244f:	e8 e8 fa ff ff       	call   801f3c <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
	return ;
  802457:	90                   	nop
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80245d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	52                   	push   %edx
  80246a:	50                   	push   %eax
  80246b:	6a 2a                	push   $0x2a
  80246d:	e8 ca fa ff ff       	call   801f3c <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
	return;
  802475:	90                   	nop
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 2b                	push   $0x2b
  802487:	e8 b0 fa ff ff       	call   801f3c <syscall>
  80248c:	83 c4 18             	add    $0x18,%esp
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	ff 75 0c             	pushl  0xc(%ebp)
  80249d:	ff 75 08             	pushl  0x8(%ebp)
  8024a0:	6a 2d                	push   $0x2d
  8024a2:	e8 95 fa ff ff       	call   801f3c <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
	return;
  8024aa:	90                   	nop
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	ff 75 0c             	pushl  0xc(%ebp)
  8024b9:	ff 75 08             	pushl  0x8(%ebp)
  8024bc:	6a 2c                	push   $0x2c
  8024be:	e8 79 fa ff ff       	call   801f3c <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c6:	90                   	nop
}
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	68 08 3c 80 00       	push   $0x803c08
  8024d7:	68 25 01 00 00       	push   $0x125
  8024dc:	68 3b 3c 80 00       	push   $0x803c3b
  8024e1:	e8 e4 e4 ff ff       	call   8009ca <_panic>

008024e6 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8024ec:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  8024f3:	72 09                	jb     8024fe <to_page_va+0x18>
  8024f5:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  8024fc:	72 14                	jb     802512 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	68 4c 3c 80 00       	push   $0x803c4c
  802506:	6a 15                	push   $0x15
  802508:	68 77 3c 80 00       	push   $0x803c77
  80250d:	e8 b8 e4 ff ff       	call   8009ca <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	ba 60 40 80 00       	mov    $0x804060,%edx
  80251a:	29 d0                	sub    %edx,%eax
  80251c:	c1 f8 02             	sar    $0x2,%eax
  80251f:	89 c2                	mov    %eax,%edx
  802521:	89 d0                	mov    %edx,%eax
  802523:	c1 e0 02             	shl    $0x2,%eax
  802526:	01 d0                	add    %edx,%eax
  802528:	c1 e0 02             	shl    $0x2,%eax
  80252b:	01 d0                	add    %edx,%eax
  80252d:	c1 e0 02             	shl    $0x2,%eax
  802530:	01 d0                	add    %edx,%eax
  802532:	89 c1                	mov    %eax,%ecx
  802534:	c1 e1 08             	shl    $0x8,%ecx
  802537:	01 c8                	add    %ecx,%eax
  802539:	89 c1                	mov    %eax,%ecx
  80253b:	c1 e1 10             	shl    $0x10,%ecx
  80253e:	01 c8                	add    %ecx,%eax
  802540:	01 c0                	add    %eax,%eax
  802542:	01 d0                	add    %edx,%eax
  802544:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	c1 e0 0c             	shl    $0xc,%eax
  80254d:	89 c2                	mov    %eax,%edx
  80254f:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802554:	01 d0                	add    %edx,%eax
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80255e:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802563:	8b 55 08             	mov    0x8(%ebp),%edx
  802566:	29 c2                	sub    %eax,%edx
  802568:	89 d0                	mov    %edx,%eax
  80256a:	c1 e8 0c             	shr    $0xc,%eax
  80256d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802574:	78 09                	js     80257f <to_page_info+0x27>
  802576:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80257d:	7e 14                	jle    802593 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	68 90 3c 80 00       	push   $0x803c90
  802587:	6a 22                	push   $0x22
  802589:	68 77 3c 80 00       	push   $0x803c77
  80258e:	e8 37 e4 ff ff       	call   8009ca <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802593:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802596:	89 d0                	mov    %edx,%eax
  802598:	01 c0                	add    %eax,%eax
  80259a:	01 d0                	add    %edx,%eax
  80259c:	c1 e0 02             	shl    $0x2,%eax
  80259f:	05 60 40 80 00       	add    $0x804060,%eax
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	05 00 00 00 02       	add    $0x2000000,%eax
  8025b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025b7:	73 16                	jae    8025cf <initialize_dynamic_allocator+0x29>
  8025b9:	68 b4 3c 80 00       	push   $0x803cb4
  8025be:	68 da 3c 80 00       	push   $0x803cda
  8025c3:	6a 34                	push   $0x34
  8025c5:	68 77 3c 80 00       	push   $0x803c77
  8025ca:	e8 fb e3 ff ff       	call   8009ca <_panic>
		is_initialized = 1;
  8025cf:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8025d6:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  8025e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e4:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  8025e9:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  8025f0:	00 00 00 
  8025f3:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8025fa:	00 00 00 
  8025fd:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802604:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260a:	2b 45 08             	sub    0x8(%ebp),%eax
  80260d:	c1 e8 0c             	shr    $0xc,%eax
  802610:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80261a:	e9 c8 00 00 00       	jmp    8026e7 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  80261f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802622:	89 d0                	mov    %edx,%eax
  802624:	01 c0                	add    %eax,%eax
  802626:	01 d0                	add    %edx,%eax
  802628:	c1 e0 02             	shl    $0x2,%eax
  80262b:	05 68 40 80 00       	add    $0x804068,%eax
  802630:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802638:	89 d0                	mov    %edx,%eax
  80263a:	01 c0                	add    %eax,%eax
  80263c:	01 d0                	add    %edx,%eax
  80263e:	c1 e0 02             	shl    $0x2,%eax
  802641:	05 6a 40 80 00       	add    $0x80406a,%eax
  802646:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80264b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802651:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802654:	89 c8                	mov    %ecx,%eax
  802656:	01 c0                	add    %eax,%eax
  802658:	01 c8                	add    %ecx,%eax
  80265a:	c1 e0 02             	shl    $0x2,%eax
  80265d:	05 64 40 80 00       	add    $0x804064,%eax
  802662:	89 10                	mov    %edx,(%eax)
  802664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802667:	89 d0                	mov    %edx,%eax
  802669:	01 c0                	add    %eax,%eax
  80266b:	01 d0                	add    %edx,%eax
  80266d:	c1 e0 02             	shl    $0x2,%eax
  802670:	05 64 40 80 00       	add    $0x804064,%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	74 1b                	je     802696 <initialize_dynamic_allocator+0xf0>
  80267b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802681:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802684:	89 c8                	mov    %ecx,%eax
  802686:	01 c0                	add    %eax,%eax
  802688:	01 c8                	add    %ecx,%eax
  80268a:	c1 e0 02             	shl    $0x2,%eax
  80268d:	05 60 40 80 00       	add    $0x804060,%eax
  802692:	89 02                	mov    %eax,(%edx)
  802694:	eb 16                	jmp    8026ac <initialize_dynamic_allocator+0x106>
  802696:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802699:	89 d0                	mov    %edx,%eax
  80269b:	01 c0                	add    %eax,%eax
  80269d:	01 d0                	add    %edx,%eax
  80269f:	c1 e0 02             	shl    $0x2,%eax
  8026a2:	05 60 40 80 00       	add    $0x804060,%eax
  8026a7:	a3 48 40 80 00       	mov    %eax,0x804048
  8026ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026af:	89 d0                	mov    %edx,%eax
  8026b1:	01 c0                	add    %eax,%eax
  8026b3:	01 d0                	add    %edx,%eax
  8026b5:	c1 e0 02             	shl    $0x2,%eax
  8026b8:	05 60 40 80 00       	add    $0x804060,%eax
  8026bd:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8026c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c5:	89 d0                	mov    %edx,%eax
  8026c7:	01 c0                	add    %eax,%eax
  8026c9:	01 d0                	add    %edx,%eax
  8026cb:	c1 e0 02             	shl    $0x2,%eax
  8026ce:	05 60 40 80 00       	add    $0x804060,%eax
  8026d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d9:	a1 54 40 80 00       	mov    0x804054,%eax
  8026de:	40                   	inc    %eax
  8026df:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8026e4:	ff 45 f4             	incl   -0xc(%ebp)
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026ed:	0f 8c 2c ff ff ff    	jl     80261f <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8026f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8026fa:	eb 36                	jmp    802732 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8026fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ff:	c1 e0 04             	shl    $0x4,%eax
  802702:	05 80 c0 81 00       	add    $0x81c080,%eax
  802707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802710:	c1 e0 04             	shl    $0x4,%eax
  802713:	05 84 c0 81 00       	add    $0x81c084,%eax
  802718:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802721:	c1 e0 04             	shl    $0x4,%eax
  802724:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80272f:	ff 45 f0             	incl   -0x10(%ebp)
  802732:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802736:	7e c4                	jle    8026fc <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802738:	90                   	nop
  802739:	c9                   	leave  
  80273a:	c3                   	ret    

0080273b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
  80273e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	83 ec 0c             	sub    $0xc,%esp
  802747:	50                   	push   %eax
  802748:	e8 0b fe ff ff       	call   802558 <to_page_info>
  80274d:	83 c4 10             	add    $0x10,%esp
  802750:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 08             	mov    0x8(%eax),%eax
  802759:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802764:	83 ec 0c             	sub    $0xc,%esp
  802767:	ff 75 0c             	pushl  0xc(%ebp)
  80276a:	e8 77 fd ff ff       	call   8024e6 <to_page_va>
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802775:	b8 00 10 00 00       	mov    $0x1000,%eax
  80277a:	ba 00 00 00 00       	mov    $0x0,%edx
  80277f:	f7 75 08             	divl   0x8(%ebp)
  802782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802788:	83 ec 0c             	sub    $0xc,%esp
  80278b:	50                   	push   %eax
  80278c:	e8 48 f6 ff ff       	call   801dd9 <get_page>
  802791:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802797:	8b 55 0c             	mov    0xc(%ebp),%edx
  80279a:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a4:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8027a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8027af:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8027b6:	eb 19                	jmp    8027d1 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8027b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bb:	ba 01 00 00 00       	mov    $0x1,%edx
  8027c0:	88 c1                	mov    %al,%cl
  8027c2:	d3 e2                	shl    %cl,%edx
  8027c4:	89 d0                	mov    %edx,%eax
  8027c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c9:	74 0e                	je     8027d9 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8027cb:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8027ce:	ff 45 f0             	incl   -0x10(%ebp)
  8027d1:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8027d5:	7e e1                	jle    8027b8 <split_page_to_blocks+0x5a>
  8027d7:	eb 01                	jmp    8027da <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8027d9:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8027da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8027e1:	e9 a7 00 00 00       	jmp    80288d <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8027e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e9:	0f af 45 08          	imul   0x8(%ebp),%eax
  8027ed:	89 c2                	mov    %eax,%edx
  8027ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f2:	01 d0                	add    %edx,%eax
  8027f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8027f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027fb:	75 14                	jne    802811 <split_page_to_blocks+0xb3>
  8027fd:	83 ec 04             	sub    $0x4,%esp
  802800:	68 f0 3c 80 00       	push   $0x803cf0
  802805:	6a 7c                	push   $0x7c
  802807:	68 77 3c 80 00       	push   $0x803c77
  80280c:	e8 b9 e1 ff ff       	call   8009ca <_panic>
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	c1 e0 04             	shl    $0x4,%eax
  802817:	05 84 c0 81 00       	add    $0x81c084,%eax
  80281c:	8b 10                	mov    (%eax),%edx
  80281e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802821:	89 50 04             	mov    %edx,0x4(%eax)
  802824:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802827:	8b 40 04             	mov    0x4(%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 14                	je     802842 <split_page_to_blocks+0xe4>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	c1 e0 04             	shl    $0x4,%eax
  802834:	05 84 c0 81 00       	add    $0x81c084,%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	eb 11                	jmp    802853 <split_page_to_blocks+0xf5>
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	c1 e0 04             	shl    $0x4,%eax
  802848:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80284e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802851:	89 02                	mov    %eax,(%edx)
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	c1 e0 04             	shl    $0x4,%eax
  802859:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80285f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802862:	89 02                	mov    %eax,(%edx)
  802864:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802867:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	c1 e0 04             	shl    $0x4,%eax
  802873:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	8d 50 01             	lea    0x1(%eax),%edx
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	c1 e0 04             	shl    $0x4,%eax
  802883:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802888:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80288a:	ff 45 ec             	incl   -0x14(%ebp)
  80288d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802890:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802893:	0f 82 4d ff ff ff    	jb     8027e6 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802899:	90                   	nop
  80289a:	c9                   	leave  
  80289b:	c3                   	ret    

0080289c <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80289c:	55                   	push   %ebp
  80289d:	89 e5                	mov    %esp,%ebp
  80289f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8028a2:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8028a9:	76 19                	jbe    8028c4 <alloc_block+0x28>
  8028ab:	68 14 3d 80 00       	push   $0x803d14
  8028b0:	68 da 3c 80 00       	push   $0x803cda
  8028b5:	68 8a 00 00 00       	push   $0x8a
  8028ba:	68 77 3c 80 00       	push   $0x803c77
  8028bf:	e8 06 e1 ff ff       	call   8009ca <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8028c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8028cb:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8028d2:	eb 19                	jmp    8028ed <alloc_block+0x51>
		if((1 << i) >= size) break;
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8028dc:	88 c1                	mov    %al,%cl
  8028de:	d3 e2                	shl    %cl,%edx
  8028e0:	89 d0                	mov    %edx,%eax
  8028e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e5:	73 0e                	jae    8028f5 <alloc_block+0x59>
		idx++;
  8028e7:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8028ea:	ff 45 f0             	incl   -0x10(%ebp)
  8028ed:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8028f1:	7e e1                	jle    8028d4 <alloc_block+0x38>
  8028f3:	eb 01                	jmp    8028f6 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8028f5:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	c1 e0 04             	shl    $0x4,%eax
  8028fc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	85 c0                	test   %eax,%eax
  802905:	0f 84 df 00 00 00    	je     8029ea <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	c1 e0 04             	shl    $0x4,%eax
  802911:	05 80 c0 81 00       	add    $0x81c080,%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80291b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80291f:	75 17                	jne    802938 <alloc_block+0x9c>
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	68 35 3d 80 00       	push   $0x803d35
  802929:	68 9e 00 00 00       	push   $0x9e
  80292e:	68 77 3c 80 00       	push   $0x803c77
  802933:	e8 92 e0 ff ff       	call   8009ca <_panic>
  802938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 10                	je     802951 <alloc_block+0xb5>
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802949:	8b 52 04             	mov    0x4(%edx),%edx
  80294c:	89 50 04             	mov    %edx,0x4(%eax)
  80294f:	eb 14                	jmp    802965 <alloc_block+0xc9>
  802951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295a:	c1 e2 04             	shl    $0x4,%edx
  80295d:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802963:	89 02                	mov    %eax,(%edx)
  802965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	74 0f                	je     80297e <alloc_block+0xe2>
  80296f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802978:	8b 12                	mov    (%edx),%edx
  80297a:	89 10                	mov    %edx,(%eax)
  80297c:	eb 13                	jmp    802991 <alloc_block+0xf5>
  80297e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802986:	c1 e2 04             	shl    $0x4,%edx
  802989:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80298f:	89 02                	mov    %eax,(%edx)
  802991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802994:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	c1 e0 04             	shl    $0x4,%eax
  8029aa:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	c1 e0 04             	shl    $0x4,%eax
  8029ba:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029bf:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8029c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c4:	83 ec 0c             	sub    $0xc,%esp
  8029c7:	50                   	push   %eax
  8029c8:	e8 8b fb ff ff       	call   802558 <to_page_info>
  8029cd:	83 c4 10             	add    $0x10,%esp
  8029d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8029d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8029da:	48                   	dec    %eax
  8029db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029de:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	e9 bc 02 00 00       	jmp    802ca6 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8029ea:	a1 54 40 80 00       	mov    0x804054,%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	0f 84 7d 02 00 00    	je     802c74 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8029f7:	a1 48 40 80 00       	mov    0x804048,%eax
  8029fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8029ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a03:	75 17                	jne    802a1c <alloc_block+0x180>
  802a05:	83 ec 04             	sub    $0x4,%esp
  802a08:	68 35 3d 80 00       	push   $0x803d35
  802a0d:	68 a9 00 00 00       	push   $0xa9
  802a12:	68 77 3c 80 00       	push   $0x803c77
  802a17:	e8 ae df ff ff       	call   8009ca <_panic>
  802a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	74 10                	je     802a35 <alloc_block+0x199>
  802a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a2d:	8b 52 04             	mov    0x4(%edx),%edx
  802a30:	89 50 04             	mov    %edx,0x4(%eax)
  802a33:	eb 0b                	jmp    802a40 <alloc_block+0x1a4>
  802a35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a38:	8b 40 04             	mov    0x4(%eax),%eax
  802a3b:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	74 0f                	je     802a59 <alloc_block+0x1bd>
  802a4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a53:	8b 12                	mov    (%edx),%edx
  802a55:	89 10                	mov    %edx,(%eax)
  802a57:	eb 0a                	jmp    802a63 <alloc_block+0x1c7>
  802a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	a3 48 40 80 00       	mov    %eax,0x804048
  802a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a76:	a1 54 40 80 00       	mov    0x804054,%eax
  802a7b:	48                   	dec    %eax
  802a7c:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	83 c0 03             	add    $0x3,%eax
  802a87:	ba 01 00 00 00       	mov    $0x1,%edx
  802a8c:	88 c1                	mov    %al,%cl
  802a8e:	d3 e2                	shl    %cl,%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	83 ec 08             	sub    $0x8,%esp
  802a95:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a98:	50                   	push   %eax
  802a99:	e8 c0 fc ff ff       	call   80275e <split_page_to_blocks>
  802a9e:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	c1 e0 04             	shl    $0x4,%eax
  802aa7:	05 80 c0 81 00       	add    $0x81c080,%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802ab1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ab5:	75 17                	jne    802ace <alloc_block+0x232>
  802ab7:	83 ec 04             	sub    $0x4,%esp
  802aba:	68 35 3d 80 00       	push   $0x803d35
  802abf:	68 b0 00 00 00       	push   $0xb0
  802ac4:	68 77 3c 80 00       	push   $0x803c77
  802ac9:	e8 fc de ff ff       	call   8009ca <_panic>
  802ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	85 c0                	test   %eax,%eax
  802ad5:	74 10                	je     802ae7 <alloc_block+0x24b>
  802ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802adf:	8b 52 04             	mov    0x4(%edx),%edx
  802ae2:	89 50 04             	mov    %edx,0x4(%eax)
  802ae5:	eb 14                	jmp    802afb <alloc_block+0x25f>
  802ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af0:	c1 e2 04             	shl    $0x4,%edx
  802af3:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802af9:	89 02                	mov    %eax,(%edx)
  802afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 0f                	je     802b14 <alloc_block+0x278>
  802b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b0e:	8b 12                	mov    (%edx),%edx
  802b10:	89 10                	mov    %edx,(%eax)
  802b12:	eb 13                	jmp    802b27 <alloc_block+0x28b>
  802b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1c:	c1 e2 04             	shl    $0x4,%edx
  802b1f:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802b25:	89 02                	mov    %eax,(%edx)
  802b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	c1 e0 04             	shl    $0x4,%eax
  802b40:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	c1 e0 04             	shl    $0x4,%eax
  802b50:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b55:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802b57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5a:	83 ec 0c             	sub    $0xc,%esp
  802b5d:	50                   	push   %eax
  802b5e:	e8 f5 f9 ff ff       	call   802558 <to_page_info>
  802b63:	83 c4 10             	add    $0x10,%esp
  802b66:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802b69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b6c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b70:	48                   	dec    %eax
  802b71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b74:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802b78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7b:	e9 26 01 00 00       	jmp    802ca6 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802b80:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	c1 e0 04             	shl    $0x4,%eax
  802b89:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	0f 84 dc 00 00 00    	je     802c74 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	c1 e0 04             	shl    $0x4,%eax
  802b9e:	05 80 c0 81 00       	add    $0x81c080,%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802ba8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802bac:	75 17                	jne    802bc5 <alloc_block+0x329>
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	68 35 3d 80 00       	push   $0x803d35
  802bb6:	68 be 00 00 00       	push   $0xbe
  802bbb:	68 77 3c 80 00       	push   $0x803c77
  802bc0:	e8 05 de ff ff       	call   8009ca <_panic>
  802bc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 10                	je     802bde <alloc_block+0x342>
  802bce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802bd6:	8b 52 04             	mov    0x4(%edx),%edx
  802bd9:	89 50 04             	mov    %edx,0x4(%eax)
  802bdc:	eb 14                	jmp    802bf2 <alloc_block+0x356>
  802bde:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802be1:	8b 40 04             	mov    0x4(%eax),%eax
  802be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be7:	c1 e2 04             	shl    $0x4,%edx
  802bea:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802bf0:	89 02                	mov    %eax,(%edx)
  802bf2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 0f                	je     802c0b <alloc_block+0x36f>
  802bfc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bff:	8b 40 04             	mov    0x4(%eax),%eax
  802c02:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c05:	8b 12                	mov    (%edx),%edx
  802c07:	89 10                	mov    %edx,(%eax)
  802c09:	eb 13                	jmp    802c1e <alloc_block+0x382>
  802c0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c13:	c1 e2 04             	shl    $0x4,%edx
  802c16:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802c1c:	89 02                	mov    %eax,(%edx)
  802c1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	c1 e0 04             	shl    $0x4,%eax
  802c37:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	c1 e0 04             	shl    $0x4,%eax
  802c47:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c4c:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802c4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c51:	83 ec 0c             	sub    $0xc,%esp
  802c54:	50                   	push   %eax
  802c55:	e8 fe f8 ff ff       	call   802558 <to_page_info>
  802c5a:	83 c4 10             	add    $0x10,%esp
  802c5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802c60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c63:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802c67:	48                   	dec    %eax
  802c68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c6b:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802c6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c72:	eb 32                	jmp    802ca6 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802c74:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802c78:	77 15                	ja     802c8f <alloc_block+0x3f3>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	c1 e0 04             	shl    $0x4,%eax
  802c80:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	0f 84 f1 fe ff ff    	je     802b80 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802c8f:	83 ec 04             	sub    $0x4,%esp
  802c92:	68 53 3d 80 00       	push   $0x803d53
  802c97:	68 c8 00 00 00       	push   $0xc8
  802c9c:	68 77 3c 80 00       	push   $0x803c77
  802ca1:	e8 24 dd ff ff       	call   8009ca <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802ca6:	c9                   	leave  
  802ca7:	c3                   	ret    

00802ca8 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802ca8:	55                   	push   %ebp
  802ca9:	89 e5                	mov    %esp,%ebp
  802cab:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802cae:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb1:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802cb6:	39 c2                	cmp    %eax,%edx
  802cb8:	72 0c                	jb     802cc6 <free_block+0x1e>
  802cba:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbd:	a1 40 40 80 00       	mov    0x804040,%eax
  802cc2:	39 c2                	cmp    %eax,%edx
  802cc4:	72 19                	jb     802cdf <free_block+0x37>
  802cc6:	68 64 3d 80 00       	push   $0x803d64
  802ccb:	68 da 3c 80 00       	push   $0x803cda
  802cd0:	68 d7 00 00 00       	push   $0xd7
  802cd5:	68 77 3c 80 00       	push   $0x803c77
  802cda:	e8 eb dc ff ff       	call   8009ca <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	83 ec 0c             	sub    $0xc,%esp
  802ceb:	50                   	push   %eax
  802cec:	e8 67 f8 ff ff       	call   802558 <to_page_info>
  802cf1:	83 c4 10             	add    $0x10,%esp
  802cf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfa:	8b 40 08             	mov    0x8(%eax),%eax
  802cfd:	0f b7 c0             	movzwl %ax,%eax
  802d00:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802d03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802d0a:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802d11:	eb 19                	jmp    802d2c <free_block+0x84>
	    if ((1 << i) == blk_size)
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	ba 01 00 00 00       	mov    $0x1,%edx
  802d1b:	88 c1                	mov    %al,%cl
  802d1d:	d3 e2                	shl    %cl,%edx
  802d1f:	89 d0                	mov    %edx,%eax
  802d21:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d24:	74 0e                	je     802d34 <free_block+0x8c>
	        break;
	    idx++;
  802d26:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802d29:	ff 45 f0             	incl   -0x10(%ebp)
  802d2c:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802d30:	7e e1                	jle    802d13 <free_block+0x6b>
  802d32:	eb 01                	jmp    802d35 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802d34:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d38:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802d3c:	40                   	inc    %eax
  802d3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d40:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802d44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d48:	75 17                	jne    802d61 <free_block+0xb9>
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	68 f0 3c 80 00       	push   $0x803cf0
  802d52:	68 ee 00 00 00       	push   $0xee
  802d57:	68 77 3c 80 00       	push   $0x803c77
  802d5c:	e8 69 dc ff ff       	call   8009ca <_panic>
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	c1 e0 04             	shl    $0x4,%eax
  802d67:	05 84 c0 81 00       	add    $0x81c084,%eax
  802d6c:	8b 10                	mov    (%eax),%edx
  802d6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	74 14                	je     802d92 <free_block+0xea>
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	c1 e0 04             	shl    $0x4,%eax
  802d84:	05 84 c0 81 00       	add    $0x81c084,%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d8e:	89 10                	mov    %edx,(%eax)
  802d90:	eb 11                	jmp    802da3 <free_block+0xfb>
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	c1 e0 04             	shl    $0x4,%eax
  802d98:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da1:	89 02                	mov    %eax,(%edx)
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	c1 e0 04             	shl    $0x4,%eax
  802da9:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802daf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db2:	89 02                	mov    %eax,(%edx)
  802db4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	c1 e0 04             	shl    $0x4,%eax
  802dc3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	8d 50 01             	lea    0x1(%eax),%edx
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	c1 e0 04             	shl    $0x4,%eax
  802dd3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802dd8:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802dda:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  802de4:	f7 75 e0             	divl   -0x20(%ebp)
  802de7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ded:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802df1:	0f b7 c0             	movzwl %ax,%eax
  802df4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802df7:	0f 85 70 01 00 00    	jne    802f6d <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802dfd:	83 ec 0c             	sub    $0xc,%esp
  802e00:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e03:	e8 de f6 ff ff       	call   8024e6 <to_page_va>
  802e08:	83 c4 10             	add    $0x10,%esp
  802e0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802e0e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802e15:	e9 b7 00 00 00       	jmp    802ed1 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802e1a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e20:	01 d0                	add    %edx,%eax
  802e22:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802e25:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e29:	75 17                	jne    802e42 <free_block+0x19a>
  802e2b:	83 ec 04             	sub    $0x4,%esp
  802e2e:	68 35 3d 80 00       	push   $0x803d35
  802e33:	68 f8 00 00 00       	push   $0xf8
  802e38:	68 77 3c 80 00       	push   $0x803c77
  802e3d:	e8 88 db ff ff       	call   8009ca <_panic>
  802e42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 10                	je     802e5b <free_block+0x1b3>
  802e4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e53:	8b 52 04             	mov    0x4(%edx),%edx
  802e56:	89 50 04             	mov    %edx,0x4(%eax)
  802e59:	eb 14                	jmp    802e6f <free_block+0x1c7>
  802e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e5e:	8b 40 04             	mov    0x4(%eax),%eax
  802e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e64:	c1 e2 04             	shl    $0x4,%edx
  802e67:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802e6d:	89 02                	mov    %eax,(%edx)
  802e6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 0f                	je     802e88 <free_block+0x1e0>
  802e79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e7c:	8b 40 04             	mov    0x4(%eax),%eax
  802e7f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e82:	8b 12                	mov    (%edx),%edx
  802e84:	89 10                	mov    %edx,(%eax)
  802e86:	eb 13                	jmp    802e9b <free_block+0x1f3>
  802e88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e90:	c1 e2 04             	shl    $0x4,%edx
  802e93:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802e99:	89 02                	mov    %eax,(%edx)
  802e9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	c1 e0 04             	shl    $0x4,%eax
  802eb4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	8d 50 ff             	lea    -0x1(%eax),%edx
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	c1 e0 04             	shl    $0x4,%eax
  802ec4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802ec9:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802ecb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ece:	01 45 ec             	add    %eax,-0x14(%ebp)
  802ed1:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ed8:	0f 86 3c ff ff ff    	jbe    802e1a <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802ede:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee1:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eea:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802ef0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ef4:	75 17                	jne    802f0d <free_block+0x265>
  802ef6:	83 ec 04             	sub    $0x4,%esp
  802ef9:	68 f0 3c 80 00       	push   $0x803cf0
  802efe:	68 fe 00 00 00       	push   $0xfe
  802f03:	68 77 3c 80 00       	push   $0x803c77
  802f08:	e8 bd da ff ff       	call   8009ca <_panic>
  802f0d:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f16:	89 50 04             	mov    %edx,0x4(%eax)
  802f19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1c:	8b 40 04             	mov    0x4(%eax),%eax
  802f1f:	85 c0                	test   %eax,%eax
  802f21:	74 0c                	je     802f2f <free_block+0x287>
  802f23:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f2b:	89 10                	mov    %edx,(%eax)
  802f2d:	eb 08                	jmp    802f37 <free_block+0x28f>
  802f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f32:	a3 48 40 80 00       	mov    %eax,0x804048
  802f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3a:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f48:	a1 54 40 80 00       	mov    0x804054,%eax
  802f4d:	40                   	inc    %eax
  802f4e:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802f53:	83 ec 0c             	sub    $0xc,%esp
  802f56:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f59:	e8 88 f5 ff ff       	call   8024e6 <to_page_va>
  802f5e:	83 c4 10             	add    $0x10,%esp
  802f61:	83 ec 0c             	sub    $0xc,%esp
  802f64:	50                   	push   %eax
  802f65:	e8 b8 ee ff ff       	call   801e22 <return_page>
  802f6a:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802f6d:	90                   	nop
  802f6e:	c9                   	leave  
  802f6f:	c3                   	ret    

00802f70 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802f70:	55                   	push   %ebp
  802f71:	89 e5                	mov    %esp,%ebp
  802f73:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802f76:	83 ec 04             	sub    $0x4,%esp
  802f79:	68 9c 3d 80 00       	push   $0x803d9c
  802f7e:	68 11 01 00 00       	push   $0x111
  802f83:	68 77 3c 80 00       	push   $0x803c77
  802f88:	e8 3d da ff ff       	call   8009ca <_panic>
  802f8d:	66 90                	xchg   %ax,%ax
  802f8f:	90                   	nop

00802f90 <__udivdi3>:
  802f90:	55                   	push   %ebp
  802f91:	57                   	push   %edi
  802f92:	56                   	push   %esi
  802f93:	53                   	push   %ebx
  802f94:	83 ec 1c             	sub    $0x1c,%esp
  802f97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fa3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fa7:	89 ca                	mov    %ecx,%edx
  802fa9:	89 f8                	mov    %edi,%eax
  802fab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802faf:	85 f6                	test   %esi,%esi
  802fb1:	75 2d                	jne    802fe0 <__udivdi3+0x50>
  802fb3:	39 cf                	cmp    %ecx,%edi
  802fb5:	77 65                	ja     80301c <__udivdi3+0x8c>
  802fb7:	89 fd                	mov    %edi,%ebp
  802fb9:	85 ff                	test   %edi,%edi
  802fbb:	75 0b                	jne    802fc8 <__udivdi3+0x38>
  802fbd:	b8 01 00 00 00       	mov    $0x1,%eax
  802fc2:	31 d2                	xor    %edx,%edx
  802fc4:	f7 f7                	div    %edi
  802fc6:	89 c5                	mov    %eax,%ebp
  802fc8:	31 d2                	xor    %edx,%edx
  802fca:	89 c8                	mov    %ecx,%eax
  802fcc:	f7 f5                	div    %ebp
  802fce:	89 c1                	mov    %eax,%ecx
  802fd0:	89 d8                	mov    %ebx,%eax
  802fd2:	f7 f5                	div    %ebp
  802fd4:	89 cf                	mov    %ecx,%edi
  802fd6:	89 fa                	mov    %edi,%edx
  802fd8:	83 c4 1c             	add    $0x1c,%esp
  802fdb:	5b                   	pop    %ebx
  802fdc:	5e                   	pop    %esi
  802fdd:	5f                   	pop    %edi
  802fde:	5d                   	pop    %ebp
  802fdf:	c3                   	ret    
  802fe0:	39 ce                	cmp    %ecx,%esi
  802fe2:	77 28                	ja     80300c <__udivdi3+0x7c>
  802fe4:	0f bd fe             	bsr    %esi,%edi
  802fe7:	83 f7 1f             	xor    $0x1f,%edi
  802fea:	75 40                	jne    80302c <__udivdi3+0x9c>
  802fec:	39 ce                	cmp    %ecx,%esi
  802fee:	72 0a                	jb     802ffa <__udivdi3+0x6a>
  802ff0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ff4:	0f 87 9e 00 00 00    	ja     803098 <__udivdi3+0x108>
  802ffa:	b8 01 00 00 00       	mov    $0x1,%eax
  802fff:	89 fa                	mov    %edi,%edx
  803001:	83 c4 1c             	add    $0x1c,%esp
  803004:	5b                   	pop    %ebx
  803005:	5e                   	pop    %esi
  803006:	5f                   	pop    %edi
  803007:	5d                   	pop    %ebp
  803008:	c3                   	ret    
  803009:	8d 76 00             	lea    0x0(%esi),%esi
  80300c:	31 ff                	xor    %edi,%edi
  80300e:	31 c0                	xor    %eax,%eax
  803010:	89 fa                	mov    %edi,%edx
  803012:	83 c4 1c             	add    $0x1c,%esp
  803015:	5b                   	pop    %ebx
  803016:	5e                   	pop    %esi
  803017:	5f                   	pop    %edi
  803018:	5d                   	pop    %ebp
  803019:	c3                   	ret    
  80301a:	66 90                	xchg   %ax,%ax
  80301c:	89 d8                	mov    %ebx,%eax
  80301e:	f7 f7                	div    %edi
  803020:	31 ff                	xor    %edi,%edi
  803022:	89 fa                	mov    %edi,%edx
  803024:	83 c4 1c             	add    $0x1c,%esp
  803027:	5b                   	pop    %ebx
  803028:	5e                   	pop    %esi
  803029:	5f                   	pop    %edi
  80302a:	5d                   	pop    %ebp
  80302b:	c3                   	ret    
  80302c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803031:	89 eb                	mov    %ebp,%ebx
  803033:	29 fb                	sub    %edi,%ebx
  803035:	89 f9                	mov    %edi,%ecx
  803037:	d3 e6                	shl    %cl,%esi
  803039:	89 c5                	mov    %eax,%ebp
  80303b:	88 d9                	mov    %bl,%cl
  80303d:	d3 ed                	shr    %cl,%ebp
  80303f:	89 e9                	mov    %ebp,%ecx
  803041:	09 f1                	or     %esi,%ecx
  803043:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803047:	89 f9                	mov    %edi,%ecx
  803049:	d3 e0                	shl    %cl,%eax
  80304b:	89 c5                	mov    %eax,%ebp
  80304d:	89 d6                	mov    %edx,%esi
  80304f:	88 d9                	mov    %bl,%cl
  803051:	d3 ee                	shr    %cl,%esi
  803053:	89 f9                	mov    %edi,%ecx
  803055:	d3 e2                	shl    %cl,%edx
  803057:	8b 44 24 08          	mov    0x8(%esp),%eax
  80305b:	88 d9                	mov    %bl,%cl
  80305d:	d3 e8                	shr    %cl,%eax
  80305f:	09 c2                	or     %eax,%edx
  803061:	89 d0                	mov    %edx,%eax
  803063:	89 f2                	mov    %esi,%edx
  803065:	f7 74 24 0c          	divl   0xc(%esp)
  803069:	89 d6                	mov    %edx,%esi
  80306b:	89 c3                	mov    %eax,%ebx
  80306d:	f7 e5                	mul    %ebp
  80306f:	39 d6                	cmp    %edx,%esi
  803071:	72 19                	jb     80308c <__udivdi3+0xfc>
  803073:	74 0b                	je     803080 <__udivdi3+0xf0>
  803075:	89 d8                	mov    %ebx,%eax
  803077:	31 ff                	xor    %edi,%edi
  803079:	e9 58 ff ff ff       	jmp    802fd6 <__udivdi3+0x46>
  80307e:	66 90                	xchg   %ax,%ax
  803080:	8b 54 24 08          	mov    0x8(%esp),%edx
  803084:	89 f9                	mov    %edi,%ecx
  803086:	d3 e2                	shl    %cl,%edx
  803088:	39 c2                	cmp    %eax,%edx
  80308a:	73 e9                	jae    803075 <__udivdi3+0xe5>
  80308c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80308f:	31 ff                	xor    %edi,%edi
  803091:	e9 40 ff ff ff       	jmp    802fd6 <__udivdi3+0x46>
  803096:	66 90                	xchg   %ax,%ax
  803098:	31 c0                	xor    %eax,%eax
  80309a:	e9 37 ff ff ff       	jmp    802fd6 <__udivdi3+0x46>
  80309f:	90                   	nop

008030a0 <__umoddi3>:
  8030a0:	55                   	push   %ebp
  8030a1:	57                   	push   %edi
  8030a2:	56                   	push   %esi
  8030a3:	53                   	push   %ebx
  8030a4:	83 ec 1c             	sub    $0x1c,%esp
  8030a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030bf:	89 f3                	mov    %esi,%ebx
  8030c1:	89 fa                	mov    %edi,%edx
  8030c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030c7:	89 34 24             	mov    %esi,(%esp)
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	75 1a                	jne    8030e8 <__umoddi3+0x48>
  8030ce:	39 f7                	cmp    %esi,%edi
  8030d0:	0f 86 a2 00 00 00    	jbe    803178 <__umoddi3+0xd8>
  8030d6:	89 c8                	mov    %ecx,%eax
  8030d8:	89 f2                	mov    %esi,%edx
  8030da:	f7 f7                	div    %edi
  8030dc:	89 d0                	mov    %edx,%eax
  8030de:	31 d2                	xor    %edx,%edx
  8030e0:	83 c4 1c             	add    $0x1c,%esp
  8030e3:	5b                   	pop    %ebx
  8030e4:	5e                   	pop    %esi
  8030e5:	5f                   	pop    %edi
  8030e6:	5d                   	pop    %ebp
  8030e7:	c3                   	ret    
  8030e8:	39 f0                	cmp    %esi,%eax
  8030ea:	0f 87 ac 00 00 00    	ja     80319c <__umoddi3+0xfc>
  8030f0:	0f bd e8             	bsr    %eax,%ebp
  8030f3:	83 f5 1f             	xor    $0x1f,%ebp
  8030f6:	0f 84 ac 00 00 00    	je     8031a8 <__umoddi3+0x108>
  8030fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803101:	29 ef                	sub    %ebp,%edi
  803103:	89 fe                	mov    %edi,%esi
  803105:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803109:	89 e9                	mov    %ebp,%ecx
  80310b:	d3 e0                	shl    %cl,%eax
  80310d:	89 d7                	mov    %edx,%edi
  80310f:	89 f1                	mov    %esi,%ecx
  803111:	d3 ef                	shr    %cl,%edi
  803113:	09 c7                	or     %eax,%edi
  803115:	89 e9                	mov    %ebp,%ecx
  803117:	d3 e2                	shl    %cl,%edx
  803119:	89 14 24             	mov    %edx,(%esp)
  80311c:	89 d8                	mov    %ebx,%eax
  80311e:	d3 e0                	shl    %cl,%eax
  803120:	89 c2                	mov    %eax,%edx
  803122:	8b 44 24 08          	mov    0x8(%esp),%eax
  803126:	d3 e0                	shl    %cl,%eax
  803128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80312c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803130:	89 f1                	mov    %esi,%ecx
  803132:	d3 e8                	shr    %cl,%eax
  803134:	09 d0                	or     %edx,%eax
  803136:	d3 eb                	shr    %cl,%ebx
  803138:	89 da                	mov    %ebx,%edx
  80313a:	f7 f7                	div    %edi
  80313c:	89 d3                	mov    %edx,%ebx
  80313e:	f7 24 24             	mull   (%esp)
  803141:	89 c6                	mov    %eax,%esi
  803143:	89 d1                	mov    %edx,%ecx
  803145:	39 d3                	cmp    %edx,%ebx
  803147:	0f 82 87 00 00 00    	jb     8031d4 <__umoddi3+0x134>
  80314d:	0f 84 91 00 00 00    	je     8031e4 <__umoddi3+0x144>
  803153:	8b 54 24 04          	mov    0x4(%esp),%edx
  803157:	29 f2                	sub    %esi,%edx
  803159:	19 cb                	sbb    %ecx,%ebx
  80315b:	89 d8                	mov    %ebx,%eax
  80315d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803161:	d3 e0                	shl    %cl,%eax
  803163:	89 e9                	mov    %ebp,%ecx
  803165:	d3 ea                	shr    %cl,%edx
  803167:	09 d0                	or     %edx,%eax
  803169:	89 e9                	mov    %ebp,%ecx
  80316b:	d3 eb                	shr    %cl,%ebx
  80316d:	89 da                	mov    %ebx,%edx
  80316f:	83 c4 1c             	add    $0x1c,%esp
  803172:	5b                   	pop    %ebx
  803173:	5e                   	pop    %esi
  803174:	5f                   	pop    %edi
  803175:	5d                   	pop    %ebp
  803176:	c3                   	ret    
  803177:	90                   	nop
  803178:	89 fd                	mov    %edi,%ebp
  80317a:	85 ff                	test   %edi,%edi
  80317c:	75 0b                	jne    803189 <__umoddi3+0xe9>
  80317e:	b8 01 00 00 00       	mov    $0x1,%eax
  803183:	31 d2                	xor    %edx,%edx
  803185:	f7 f7                	div    %edi
  803187:	89 c5                	mov    %eax,%ebp
  803189:	89 f0                	mov    %esi,%eax
  80318b:	31 d2                	xor    %edx,%edx
  80318d:	f7 f5                	div    %ebp
  80318f:	89 c8                	mov    %ecx,%eax
  803191:	f7 f5                	div    %ebp
  803193:	89 d0                	mov    %edx,%eax
  803195:	e9 44 ff ff ff       	jmp    8030de <__umoddi3+0x3e>
  80319a:	66 90                	xchg   %ax,%ax
  80319c:	89 c8                	mov    %ecx,%eax
  80319e:	89 f2                	mov    %esi,%edx
  8031a0:	83 c4 1c             	add    $0x1c,%esp
  8031a3:	5b                   	pop    %ebx
  8031a4:	5e                   	pop    %esi
  8031a5:	5f                   	pop    %edi
  8031a6:	5d                   	pop    %ebp
  8031a7:	c3                   	ret    
  8031a8:	3b 04 24             	cmp    (%esp),%eax
  8031ab:	72 06                	jb     8031b3 <__umoddi3+0x113>
  8031ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031b1:	77 0f                	ja     8031c2 <__umoddi3+0x122>
  8031b3:	89 f2                	mov    %esi,%edx
  8031b5:	29 f9                	sub    %edi,%ecx
  8031b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031bb:	89 14 24             	mov    %edx,(%esp)
  8031be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031c6:	8b 14 24             	mov    (%esp),%edx
  8031c9:	83 c4 1c             	add    $0x1c,%esp
  8031cc:	5b                   	pop    %ebx
  8031cd:	5e                   	pop    %esi
  8031ce:	5f                   	pop    %edi
  8031cf:	5d                   	pop    %ebp
  8031d0:	c3                   	ret    
  8031d1:	8d 76 00             	lea    0x0(%esi),%esi
  8031d4:	2b 04 24             	sub    (%esp),%eax
  8031d7:	19 fa                	sbb    %edi,%edx
  8031d9:	89 d1                	mov    %edx,%ecx
  8031db:	89 c6                	mov    %eax,%esi
  8031dd:	e9 71 ff ff ff       	jmp    803153 <__umoddi3+0xb3>
  8031e2:	66 90                	xchg   %ax,%ax
  8031e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031e8:	72 ea                	jb     8031d4 <__umoddi3+0x134>
  8031ea:	89 d9                	mov    %ebx,%ecx
  8031ec:	e9 62 ff ff ff       	jmp    803153 <__umoddi3+0xb3>
