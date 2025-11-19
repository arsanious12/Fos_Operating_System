
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 a7 13 00 00       	call   8013dd <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <inRange>:
bool allocSpaceInPageAlloc(int index, uint32 size, bool writeData, uint32 expectedNumOfTables);
bool freeSpaceInPageAlloc(int index, bool isDataWritten);
int initial_page_allocations();

int inRange(int val, int min, int max)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	return (val >= min && val <= max) ? 1 : 0;
  80003b:	8b 45 08             	mov    0x8(%ebp),%eax
  80003e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800041:	7c 0f                	jl     800052 <inRange+0x1a>
  800043:	8b 45 08             	mov    0x8(%ebp),%eax
  800046:	3b 45 10             	cmp    0x10(%ebp),%eax
  800049:	7f 07                	jg     800052 <inRange+0x1a>
  80004b:	b8 01 00 00 00       	mov    $0x1,%eax
  800050:	eb 05                	jmp    800057 <inRange+0x1f>
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800057:	5d                   	pop    %ebp
  800058:	c3                   	ret    

00800059 <allocSpaceInPageAlloc>:

bool allocSpaceInPageAlloc(int index, uint32 size, bool writeData, uint32 expectedNumOfTables)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	53                   	push   %ebx
  80005d:	83 ec 34             	sub    $0x34,%esp
	int correct = 1;
  800060:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int freeFrames = (int)sys_calculate_free_frames() ;
  800067:	e8 aa 29 00 00       	call   802a16 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 ed 29 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char *byteArr;

	//Allocate the required size
	requestedSizes[index] = size ;
  800077:	8b 45 08             	mov    0x8(%ebp),%eax
  80007a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80007d:	89 14 85 60 51 80 00 	mov    %edx,0x805160(,%eax,4)
	uint32 expectedNumOfFrames = ROUNDUP(requestedSizes[index], PAGE_SIZE) / PAGE_SIZE ;
  800084:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80008b:	8b 45 08             	mov    0x8(%ebp),%eax
  80008e:	8b 14 85 60 51 80 00 	mov    0x805160(,%eax,4),%edx
  800095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800098:	01 d0                	add    %edx,%eax
  80009a:	48                   	dec    %eax
  80009b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80009e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a6:	f7 75 e4             	divl   -0x1c(%ebp)
  8000a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ac:	29 d0                	sub    %edx,%eax
  8000ae:	c1 e8 0c             	shr    $0xc,%eax
  8000b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	{
		ptr_allocations[index] = malloc(requestedSizes[index]);
  8000b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b7:	8b 04 85 60 51 80 00 	mov    0x805160(,%eax,4),%eax
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	50                   	push   %eax
  8000c2:	e8 56 27 00 00       	call   80281d <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	89 c2                	mov    %eax,%edx
  8000cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cf:	89 14 85 20 50 80 00 	mov    %edx,0x805020(,%eax,4)
	}

	//Check allocation in RAM & Page File
	expectedNumOfFrames = expectedNumOfTables ;
  8000d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8000dc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000df:	e8 32 29 00 00       	call   802a16 <sys_calculate_free_frames>
  8000e4:	29 c3                	sub    %eax,%ebx
  8000e6:	89 d8                	mov    %ebx,%eax
  8000e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8000eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000ee:	83 c0 02             	add    $0x2,%eax
  8000f1:	89 c1                	mov    %eax,%ecx
  8000f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8000f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	51                   	push   %ecx
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	e8 34 ff ff ff       	call   800038 <inRange>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	75 29                	jne    800134 <allocSpaceInPageAlloc+0xdb>
	{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong allocation in alloc#%d: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", index, expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80010b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800115:	83 c0 02             	add    $0x2,%eax
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	ff 75 f0             	pushl  -0x10(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	68 c0 3b 80 00       	push   $0x803bc0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 57 17 00 00       	call   801888 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 28 29 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 3c 3c 80 00       	push   $0x803c3c
  800150:	6a 0c                	push   $0xc
  800152:	e8 31 17 00 00       	call   801888 <cprintf_colored>
  800157:	83 c4 10             	add    $0x10,%esp

	lastIndices[index] = (size)/sizeof(char) - 1;
  80015a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015d:	48                   	dec    %eax
  80015e:	89 c2                	mov    %eax,%edx
  800160:	8b 45 08             	mov    0x8(%ebp),%eax
  800163:	89 14 85 c0 50 80 00 	mov    %edx,0x8050c0(,%eax,4)
	if (writeData)
  80016a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016e:	0f 84 25 01 00 00    	je     800299 <allocSpaceInPageAlloc+0x240>
	{
		//Write in first & last pages
		freeFrames = sys_calculate_free_frames() ;
  800174:	e8 9d 28 00 00       	call   802a16 <sys_calculate_free_frames>
  800179:	89 45 ec             	mov    %eax,-0x14(%ebp)
		byteArr = (char *) ptr_allocations[index];
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800186:	89 45 d8             	mov    %eax,-0x28(%ebp)
		byteArr[0] = maxByte ;
  800189:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018c:	c6 00 7f             	movb   $0x7f,(%eax)
		byteArr[lastIndices[index]] = maxByte ;
  80018f:	8b 45 08             	mov    0x8(%ebp),%eax
  800192:	8b 04 85 c0 50 80 00 	mov    0x8050c0(,%eax,4),%eax
  800199:	89 c2                	mov    %eax,%edx
  80019b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80019e:	01 d0                	add    %edx,%eax
  8001a0:	c6 00 7f             	movb   $0x7f,(%eax)

		//Check allocation in RAM & Page File
		expectedNumOfFrames = 1; /*table already created in malloc due to marking the allocated pages*/ ;
  8001a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if(size > PAGE_SIZE)
  8001aa:	81 7d 0c 00 10 00 00 	cmpl   $0x1000,0xc(%ebp)
  8001b1:	76 03                	jbe    8001b6 <allocSpaceInPageAlloc+0x15d>
			expectedNumOfFrames++ ;
  8001b3:	ff 45 f0             	incl   -0x10(%ebp)

		actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8001b6:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001b9:	e8 58 28 00 00       	call   802a16 <sys_calculate_free_frames>
  8001be:	29 c3                	sub    %eax,%ebx
  8001c0:	89 d8                	mov    %ebx,%eax
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8001c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001c8:	83 c0 02             	add    $0x2,%eax
  8001cb:	89 c1                	mov    %eax,%ecx
  8001cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8001d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	51                   	push   %ecx
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	e8 5a fe ff ff       	call   800038 <inRange>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	85 c0                	test   %eax,%eax
  8001e3:	75 22                	jne    800207 <allocSpaceInPageAlloc+0x1ae>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong fault handler in alloc#%d: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", index, expectedNumOfFrames, actualNumOfFrames);}
  8001e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	68 b4 3c 80 00       	push   $0x803cb4
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 84 16 00 00       	call   801888 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 55 28 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 40 3d 80 00       	push   $0x803d40
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 57 16 00 00       	call   801888 <cprintf_colored>
  800231:	83 c4 10             	add    $0x10,%esp

		//Check WS
		uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800242:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	8b 04 85 c0 50 80 00 	mov    0x8050c0(,%eax,4),%eax
  80024f:	89 c2                	mov    %eax,%edx
  800251:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800254:	01 d0                	add    %edx,%eax
  800256:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800259:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (sys_check_WS_list(expectedVAs, expectedNumOfFrames, 0, 2) != 1)
  800264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800267:	6a 02                	push   $0x2
  800269:	6a 00                	push   $0x0
  80026b:	50                   	push   %eax
  80026c:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80026f:	50                   	push   %eax
  800270:	e8 63 2b 00 00       	call   802dd8 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 b8 3d 80 00       	push   $0x803db8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 f2 15 00 00       	call   801888 <cprintf_colored>
  800296:	83 c4 10             	add    $0x10,%esp
	}
	return correct;
  800299:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  80029c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <freeSpaceInPageAlloc>:

bool freeSpaceInPageAlloc(int index, bool isDataWritten)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 38             	sub    $0x38,%esp
	int correct = 1;
  8002a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int freeFrames = (int)sys_calculate_free_frames() ;
  8002ae:	e8 63 27 00 00       	call   802a16 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 a6 27 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 7a 25 00 00       	call   80284b <free>
  8002d1:	83 c4 10             	add    $0x10,%esp
	}

	uint32 expectedNumOfFrames = 0;
  8002d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (isDataWritten)
  8002db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8002df:	74 1b                	je     8002fc <freeSpaceInPageAlloc+0x5b>
	{
		expectedNumOfFrames = 1;
  8002e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if(requestedSizes[index] > PAGE_SIZE)
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	8b 04 85 60 51 80 00 	mov    0x805160(,%eax,4),%eax
  8002f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8002f7:	76 03                	jbe    8002fc <freeSpaceInPageAlloc+0x5b>
			expectedNumOfFrames++ ;
  8002f9:	ff 45 f0             	incl   -0x10(%ebp)
	}
	//Check allocation in RAM & Page File
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8002fc:	e8 60 27 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 f0 3d 80 00       	push   $0x803df0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 69 15 00 00       	call   801888 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 ef 26 00 00       	call   802a16 <sys_calculate_free_frames>
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	29 c2                	sub    %eax,%edx
  80032e:	89 d0                	mov    %edx,%eax
  800330:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800333:	74 1c                	je     800351 <freeSpaceInPageAlloc+0xb0>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 Wrong free in alloc#%d: WS pages in memory and/or page tables are not freed correctly\n", index);}
  800335:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	68 3c 3e 80 00       	push   $0x803e3c
  800347:	6a 0c                	push   $0xc
  800349:	e8 3a 15 00 00       	call   801888 <cprintf_colored>
  80034e:	83 c4 10             	add    $0x10,%esp

	if (isDataWritten)
  800351:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800355:	74 72                	je     8003c9 <freeSpaceInPageAlloc+0x128>
	{
		//Check WS
		char* byteArr = (char *) ptr_allocations[index];
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800367:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80036a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800372:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	8b 04 85 c0 50 80 00 	mov    0x8050c0(,%eax,4),%eax
  80037f:	89 c2                	mov    %eax,%edx
  800381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800389:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800391:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (sys_check_WS_list(notExpectedVAs, expectedNumOfFrames, 0, 3) != 1)
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	6a 03                	push   $0x3
  800399:	6a 00                	push   $0x0
  80039b:	50                   	push   %eax
  80039c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80039f:	50                   	push   %eax
  8003a0:	e8 33 2a 00 00       	call   802dd8 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 98 3e 80 00       	push   $0x803e98
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 c2 14 00 00       	call   801888 <cprintf_colored>
  8003c6:	83 c4 10             	add    $0x10,%esp
	}
	return correct;
  8003c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <initial_page_allocations>:

int initial_page_allocations()
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	53                   	push   %ebx
  8003d3:	81 ec 40 01 00 00    	sub    $0x140,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE FOR SOME
	 * IMPLEMENTATIONS TO DYNAMICALLY ALLOCATE SPECIAL DATA
	 * STRUCTURE TO MANAGE THE PAGE ALLOCATOR.
	 *********************************************************/
	uint32 expectedVA = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  8003d9:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	//malloc some spaces
	int i, freeFrames, usedDiskPages, expectedNumOfTables ;
	uint32 size = 0;
  8003e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	char* ptr;
	int sums[20] = {0};
  8003e7:	8d 95 b8 fe ff ff    	lea    -0x148(%ebp),%edx
  8003ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8003f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f7:	89 d7                	mov    %edx,%edi
  8003f9:	f3 ab                	rep stos %eax,%es:(%edi)
	totalRequestedSize = 0;
  8003fb:	c7 05 40 d2 81 00 00 	movl   $0x0,0x81d240
  800402:	00 00 00 

	int eval = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool correct ;

	correct = 1;
  80040c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//Create some areas in PAGE allocators
	cprintf_colored(TEXT_cyan,"%~\n	1.1 Create some areas in PAGE allocators\n");
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	68 d0 3e 80 00       	push   $0x803ed0
  80041b:	6a 03                	push   $0x3
  80041d:	e8 66 14 00 00       	call   801888 <cprintf_colored>
  800422:	83 c4 10             	add    $0x10,%esp
	{
		//4 MB
		allocIndex = 0;
  800425:	c7 05 4c d2 81 00 00 	movl   $0x0,0x81d24c
  80042c:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  80042f:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  800436:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	48                   	dec    %eax
  80043f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800445:	ba 00 00 00 00       	mov    $0x0,%edx
  80044a:	f7 75 e4             	divl   -0x1c(%ebp)
  80044d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800450:	29 d0                	sub    %edx,%eax
  800452:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 4*Mega - kilo;
  800455:	c7 45 e8 00 fc 3f 00 	movl   $0x3ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  80045c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  800463:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800466:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	48                   	dec    %eax
  80046c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800472:	ba 00 00 00 00       	mov    $0x0,%edx
  800477:	f7 75 dc             	divl   -0x24(%ebp)
  80047a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80047d:	29 d0                	sub    %edx,%eax
  80047f:	89 c2                	mov    %eax,%edx
  800481:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 2;
  80048d:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800494:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800497:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  80049c:	52                   	push   %edx
  80049d:	6a 01                	push   $0x1
  80049f:	ff 75 e8             	pushl  -0x18(%ebp)
  8004a2:	50                   	push   %eax
  8004a3:	e8 b1 fb ff ff       	call   800059 <allocSpaceInPageAlloc>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8004ae:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8004b3:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8004ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8004bd:	74 2f                	je     8004ee <initial_page_allocations+0x120>
  8004bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c6:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8004cb:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8004d2:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8004d7:	83 ec 0c             	sub    $0xc,%esp
  8004da:	52                   	push   %edx
  8004db:	ff 75 ec             	pushl  -0x14(%ebp)
  8004de:	50                   	push   %eax
  8004df:	68 00 3f 80 00       	push   $0x803f00
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 9d 13 00 00       	call   801888 <cprintf_colored>
  8004eb:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  8004ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8004f2:	74 04                	je     8004f8 <initial_page_allocations+0x12a>
  8004f4:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8004f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//3 MB
		allocIndex = 1;
  8004ff:	c7 05 4c d2 81 00 01 	movl   $0x1,0x81d24c
  800506:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800509:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  800510:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800513:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	48                   	dec    %eax
  800519:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80051c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051f:	ba 00 00 00 00       	mov    $0x0,%edx
  800524:	f7 75 d0             	divl   -0x30(%ebp)
  800527:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052a:	29 d0                	sub    %edx,%eax
  80052c:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 3*Mega - kilo;
  80052f:	c7 45 e8 00 fc 2f 00 	movl   $0x2ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800536:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80053d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800540:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	48                   	dec    %eax
  800546:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800549:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80054c:	ba 00 00 00 00       	mov    $0x0,%edx
  800551:	f7 75 c8             	divl   -0x38(%ebp)
  800554:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800557:	29 d0                	sub    %edx,%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 0;
  800567:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80056e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800571:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800576:	52                   	push   %edx
  800577:	6a 01                	push   $0x1
  800579:	ff 75 e8             	pushl  -0x18(%ebp)
  80057c:	50                   	push   %eax
  80057d:	e8 d7 fa ff ff       	call   800059 <allocSpaceInPageAlloc>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800588:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  80058d:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800594:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800597:	74 2f                	je     8005c8 <initial_page_allocations+0x1fa>
  800599:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a0:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8005a5:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8005ac:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	52                   	push   %edx
  8005b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	68 00 3f 80 00       	push   $0x803f00
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 c3 12 00 00       	call   801888 <cprintf_colored>
  8005c5:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  8005c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005cc:	74 04                	je     8005d2 <initial_page_allocations+0x204>
  8005ce:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8005d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//2 MB
		allocIndex = 2;
  8005d9:	c7 05 4c d2 81 00 02 	movl   $0x2,0x81d24c
  8005e0:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  8005e3:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8005ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	48                   	dec    %eax
  8005f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8005f6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	f7 75 c0             	divl   -0x40(%ebp)
  800601:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800604:	29 d0                	sub    %edx,%eax
  800606:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800609:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800610:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  800617:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80061a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80061d:	01 d0                	add    %edx,%eax
  80061f:	48                   	dec    %eax
  800620:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800623:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800626:	ba 00 00 00 00       	mov    $0x0,%edx
  80062b:	f7 75 b8             	divl   -0x48(%ebp)
  80062e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800631:	29 d0                	sub    %edx,%eax
  800633:	89 c2                	mov    %eax,%edx
  800635:	a1 40 d2 81 00       	mov    0x81d240,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 1;
  800641:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800648:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064b:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800650:	52                   	push   %edx
  800651:	6a 01                	push   $0x1
  800653:	ff 75 e8             	pushl  -0x18(%ebp)
  800656:	50                   	push   %eax
  800657:	e8 fd f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800662:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800667:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  80066e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800671:	74 2f                	je     8006a2 <initial_page_allocations+0x2d4>
  800673:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80067a:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  80067f:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800686:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  80068b:	83 ec 0c             	sub    $0xc,%esp
  80068e:	52                   	push   %edx
  80068f:	ff 75 ec             	pushl  -0x14(%ebp)
  800692:	50                   	push   %eax
  800693:	68 00 3f 80 00       	push   $0x803f00
  800698:	6a 0c                	push   $0xc
  80069a:	e8 e9 11 00 00       	call   801888 <cprintf_colored>
  80069f:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  8006a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006a6:	74 04                	je     8006ac <initial_page_allocations+0x2de>
  8006a8:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8006ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//4 MB
		allocIndex = 3;
  8006b3:	c7 05 4c d2 81 00 03 	movl   $0x3,0x81d24c
  8006ba:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  8006bd:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8006c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006ca:	01 d0                	add    %edx,%eax
  8006cc:	48                   	dec    %eax
  8006cd:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8006d0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	f7 75 b0             	divl   -0x50(%ebp)
  8006db:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006de:	29 d0                	sub    %edx,%eax
  8006e0:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 4*Mega - kilo;
  8006e3:	c7 45 e8 00 fc 3f 00 	movl   $0x3ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  8006ea:	c7 45 a8 00 10 00 00 	movl   $0x1000,-0x58(%ebp)
  8006f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8006f7:	01 d0                	add    %edx,%eax
  8006f9:	48                   	dec    %eax
  8006fa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8006fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	f7 75 a8             	divl   -0x58(%ebp)
  800708:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80070b:	29 d0                	sub    %edx,%eax
  80070d:	89 c2                	mov    %eax,%edx
  80070f:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800714:	01 d0                	add    %edx,%eax
  800716:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 1;
  80071b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800722:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800725:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  80072a:	52                   	push   %edx
  80072b:	6a 01                	push   $0x1
  80072d:	ff 75 e8             	pushl  -0x18(%ebp)
  800730:	50                   	push   %eax
  800731:	e8 23 f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80073c:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800741:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800748:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80074b:	74 2f                	je     80077c <initial_page_allocations+0x3ae>
  80074d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800754:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800759:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800760:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800765:	83 ec 0c             	sub    $0xc,%esp
  800768:	52                   	push   %edx
  800769:	ff 75 ec             	pushl  -0x14(%ebp)
  80076c:	50                   	push   %eax
  80076d:	68 00 3f 80 00       	push   $0x803f00
  800772:	6a 0c                	push   $0xc
  800774:	e8 0f 11 00 00       	call   801888 <cprintf_colored>
  800779:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  80077c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800780:	74 04                	je     800786 <initial_page_allocations+0x3b8>
  800782:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800786:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//1 MB
		allocIndex = 4;
  80078d:	c7 05 4c d2 81 00 04 	movl   $0x4,0x81d24c
  800794:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800797:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  80079e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007a1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007a4:	01 d0                	add    %edx,%eax
  8007a6:	48                   	dec    %eax
  8007a7:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8007aa:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8007ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b2:	f7 75 a0             	divl   -0x60(%ebp)
  8007b5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8007b8:	29 d0                	sub    %edx,%eax
  8007ba:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 3*kilo;
  8007bd:	c7 45 e8 00 f4 0f 00 	movl   $0xff400,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  8007c4:	c7 45 98 00 10 00 00 	movl   $0x1000,-0x68(%ebp)
  8007cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ce:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	48                   	dec    %eax
  8007d4:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8007d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	f7 75 98             	divl   -0x68(%ebp)
  8007e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e5:	29 d0                	sub    %edx,%eax
  8007e7:	89 c2                	mov    %eax,%edx
  8007e9:	a1 40 d2 81 00       	mov    0x81d240,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 0;
  8007f5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8007fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007ff:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800804:	52                   	push   %edx
  800805:	6a 01                	push   $0x1
  800807:	ff 75 e8             	pushl  -0x18(%ebp)
  80080a:	50                   	push   %eax
  80080b:	e8 49 f8 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800816:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  80081b:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800822:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800825:	74 2f                	je     800856 <initial_page_allocations+0x488>
  800827:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80082e:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800833:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  80083a:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  80083f:	83 ec 0c             	sub    $0xc,%esp
  800842:	52                   	push   %edx
  800843:	ff 75 ec             	pushl  -0x14(%ebp)
  800846:	50                   	push   %eax
  800847:	68 00 3f 80 00       	push   $0x803f00
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 35 10 00 00       	call   801888 <cprintf_colored>
  800853:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800856:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80085a:	74 04                	je     800860 <initial_page_allocations+0x492>
  80085c:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800860:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 5;
  800867:	c7 05 4c d2 81 00 05 	movl   $0x5,0x81d24c
  80086e:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800871:	c7 45 90 00 10 00 00 	movl   $0x1000,-0x70(%ebp)
  800878:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	48                   	dec    %eax
  800881:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800884:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800887:	ba 00 00 00 00       	mov    $0x0,%edx
  80088c:	f7 75 90             	divl   -0x70(%ebp)
  80088f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800892:	29 d0                	sub    %edx,%eax
  800894:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 2*kilo;
  800897:	c7 45 e8 00 f8 0f 00 	movl   $0xff800,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  80089e:	c7 45 88 00 10 00 00 	movl   $0x1000,-0x78(%ebp)
  8008a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a8:	8b 45 88             	mov    -0x78(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	48                   	dec    %eax
  8008ae:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8008b1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8008b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b9:	f7 75 88             	divl   -0x78(%ebp)
  8008bc:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8008bf:	29 d0                	sub    %edx,%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	a1 40 d2 81 00       	mov    0x81d240,%eax
  8008c8:	01 d0                	add    %edx,%eax
  8008ca:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 0;
  8008cf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8008d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008d9:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8008de:	52                   	push   %edx
  8008df:	6a 01                	push   $0x1
  8008e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e4:	50                   	push   %eax
  8008e5:	e8 6f f7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8008f0:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8008f5:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8008fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8008ff:	74 2f                	je     800930 <initial_page_allocations+0x562>
  800901:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800908:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  80090d:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800914:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800919:	83 ec 0c             	sub    $0xc,%esp
  80091c:	52                   	push   %edx
  80091d:	ff 75 ec             	pushl  -0x14(%ebp)
  800920:	50                   	push   %eax
  800921:	68 00 3f 80 00       	push   $0x803f00
  800926:	6a 0c                	push   $0xc
  800928:	e8 5b 0f 00 00       	call   801888 <cprintf_colored>
  80092d:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800930:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800934:	74 04                	je     80093a <initial_page_allocations+0x56c>
  800936:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  80093a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 6;
  800941:	c7 05 4c d2 81 00 06 	movl   $0x6,0x81d24c
  800948:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  80094b:	c7 45 80 00 10 00 00 	movl   $0x1000,-0x80(%ebp)
  800952:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800955:	8b 45 80             	mov    -0x80(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	48                   	dec    %eax
  80095b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800961:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800967:	ba 00 00 00 00       	mov    $0x0,%edx
  80096c:	f7 75 80             	divl   -0x80(%ebp)
  80096f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800975:	29 d0                	sub    %edx,%eax
  800977:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 1*kilo;
  80097a:	c7 45 e8 00 fc 0f 00 	movl   $0xffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800981:	c7 85 78 ff ff ff 00 	movl   $0x1000,-0x88(%ebp)
  800988:	10 00 00 
  80098b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80098e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800994:	01 d0                	add    %edx,%eax
  800996:	48                   	dec    %eax
  800997:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80099d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8009a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a8:	f7 b5 78 ff ff ff    	divl   -0x88(%ebp)
  8009ae:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8009b4:	29 d0                	sub    %edx,%eax
  8009b6:	89 c2                	mov    %eax,%edx
  8009b8:	a1 40 d2 81 00       	mov    0x81d240,%eax
  8009bd:	01 d0                	add    %edx,%eax
  8009bf:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 1; //since page allocator is started 1 page after the 32MB of Block Allocator
  8009c4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8009cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009ce:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8009d3:	52                   	push   %edx
  8009d4:	6a 01                	push   $0x1
  8009d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d9:	50                   	push   %eax
  8009da:	e8 7a f6 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8009e5:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8009ea:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8009f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8009f4:	74 2f                	je     800a25 <initial_page_allocations+0x657>
  8009f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009fd:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800a02:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800a09:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800a0e:	83 ec 0c             	sub    $0xc,%esp
  800a11:	52                   	push   %edx
  800a12:	ff 75 ec             	pushl  -0x14(%ebp)
  800a15:	50                   	push   %eax
  800a16:	68 00 3f 80 00       	push   $0x803f00
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 66 0e 00 00       	call   801888 <cprintf_colored>
  800a22:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800a25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a29:	74 04                	je     800a2f <initial_page_allocations+0x661>
  800a2b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800a2f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 7;
  800a36:	c7 05 4c d2 81 00 07 	movl   $0x7,0x81d24c
  800a3d:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800a40:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  800a47:	10 00 00 
  800a4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a4d:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a53:	01 d0                	add    %edx,%eax
  800a55:	48                   	dec    %eax
  800a56:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800a5c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  800a6d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a73:	29 d0                	sub    %edx,%eax
  800a75:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800a78:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800a7f:	c7 85 68 ff ff ff 00 	movl   $0x1000,-0x98(%ebp)
  800a86:	10 00 00 
  800a89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800a92:	01 d0                	add    %edx,%eax
  800a94:	48                   	dec    %eax
  800a95:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800a9b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa6:	f7 b5 68 ff ff ff    	divl   -0x98(%ebp)
  800aac:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800ab2:	29 d0                	sub    %edx,%eax
  800ab4:	89 c2                	mov    %eax,%edx
  800ab6:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800abb:	01 d0                	add    %edx,%eax
  800abd:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 0;
  800ac2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ac9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800acc:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800ad1:	52                   	push   %edx
  800ad2:	6a 01                	push   $0x1
  800ad4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	e8 7c f5 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800ae3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800ae8:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800aef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800af2:	74 2f                	je     800b23 <initial_page_allocations+0x755>
  800af4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800afb:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800b00:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800b07:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	52                   	push   %edx
  800b10:	ff 75 ec             	pushl  -0x14(%ebp)
  800b13:	50                   	push   %eax
  800b14:	68 00 3f 80 00       	push   $0x803f00
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 68 0d 00 00       	call   801888 <cprintf_colored>
  800b20:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b27:	74 04                	je     800b2d <initial_page_allocations+0x75f>
  800b29:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800b2d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 8;
  800b34:	c7 05 4c d2 81 00 08 	movl   $0x8,0x81d24c
  800b3b:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800b3e:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  800b45:	10 00 00 
  800b48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b4b:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b51:	01 d0                	add    %edx,%eax
  800b53:	48                   	dec    %eax
  800b54:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800b5a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b60:	ba 00 00 00 00       	mov    $0x0,%edx
  800b65:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  800b6b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b71:	29 d0                	sub    %edx,%eax
  800b73:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800b76:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800b7d:	c7 85 58 ff ff ff 00 	movl   $0x1000,-0xa8(%ebp)
  800b84:	10 00 00 
  800b87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b8a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b90:	01 d0                	add    %edx,%eax
  800b92:	48                   	dec    %eax
  800b93:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b99:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba4:	f7 b5 58 ff ff ff    	divl   -0xa8(%ebp)
  800baa:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800bb0:	29 d0                	sub    %edx,%eax
  800bb2:	89 c2                	mov    %eax,%edx
  800bb4:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800bb9:	01 d0                	add    %edx,%eax
  800bbb:	a3 40 d2 81 00       	mov    %eax,0x81d240
		expectedNumOfTables = 1;
  800bc0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800bc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800bca:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800bcf:	52                   	push   %edx
  800bd0:	6a 01                	push   $0x1
  800bd2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	e8 7e f4 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800be1:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800be6:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800bed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800bf0:	74 2f                	je     800c21 <initial_page_allocations+0x853>
  800bf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bf9:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800bfe:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800c05:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	52                   	push   %edx
  800c0e:	ff 75 ec             	pushl  -0x14(%ebp)
  800c11:	50                   	push   %eax
  800c12:	68 00 3f 80 00       	push   $0x803f00
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 6a 0c 00 00       	call   801888 <cprintf_colored>
  800c1e:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800c21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c25:	74 04                	je     800c2b <initial_page_allocations+0x85d>
  800c27:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800c2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//ALLOCATIONS OF KILO BYTES
		{
			//3 KB
			allocIndex = 9;
  800c32:	c7 05 4c d2 81 00 09 	movl   $0x9,0x81d24c
  800c39:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800c3c:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  800c43:	10 00 00 
  800c46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c49:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800c4f:	01 d0                	add    %edx,%eax
  800c51:	48                   	dec    %eax
  800c52:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800c58:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c63:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  800c69:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c6f:	29 d0                	sub    %edx,%eax
  800c71:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 3*kilo ;
  800c74:	c7 45 e8 00 0c 00 00 	movl   $0xc00,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800c7b:	c7 85 48 ff ff ff 00 	movl   $0x1000,-0xb8(%ebp)
  800c82:	10 00 00 
  800c85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c88:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c8e:	01 d0                	add    %edx,%eax
  800c90:	48                   	dec    %eax
  800c91:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800c97:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca2:	f7 b5 48 ff ff ff    	divl   -0xb8(%ebp)
  800ca8:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800cae:	29 d0                	sub    %edx,%eax
  800cb0:	89 c2                	mov    %eax,%edx
  800cb2:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800cb7:	01 d0                	add    %edx,%eax
  800cb9:	a3 40 d2 81 00       	mov    %eax,0x81d240
			expectedNumOfTables = 0;
  800cbe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800cc5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800cc8:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800ccd:	52                   	push   %edx
  800cce:	6a 01                	push   $0x1
  800cd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd3:	50                   	push   %eax
  800cd4:	e8 80 f3 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800cd9:	83 c4 10             	add    $0x10,%esp
  800cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800cdf:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800ce4:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800cee:	74 2f                	je     800d1f <initial_page_allocations+0x951>
  800cf0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cf7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800cfc:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800d03:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	52                   	push   %edx
  800d0c:	ff 75 ec             	pushl  -0x14(%ebp)
  800d0f:	50                   	push   %eax
  800d10:	68 00 3f 80 00       	push   $0x803f00
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 6c 0b 00 00       	call   801888 <cprintf_colored>
  800d1c:	83 c4 20             	add    $0x20,%esp

			//5 KB
			allocIndex = 10;
  800d1f:	c7 05 4c d2 81 00 0a 	movl   $0xa,0x81d24c
  800d26:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800d29:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  800d30:	10 00 00 
  800d33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d36:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d3c:	01 d0                	add    %edx,%eax
  800d3e:	48                   	dec    %eax
  800d3f:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800d45:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d50:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  800d56:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d5c:	29 d0                	sub    %edx,%eax
  800d5e:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 5*kilo ;
  800d61:	c7 45 e8 00 14 00 00 	movl   $0x1400,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800d68:	c7 85 38 ff ff ff 00 	movl   $0x1000,-0xc8(%ebp)
  800d6f:	10 00 00 
  800d72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d75:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d7b:	01 d0                	add    %edx,%eax
  800d7d:	48                   	dec    %eax
  800d7e:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d84:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8f:	f7 b5 38 ff ff ff    	divl   -0xc8(%ebp)
  800d95:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d9b:	29 d0                	sub    %edx,%eax
  800d9d:	89 c2                	mov    %eax,%edx
  800d9f:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800da4:	01 d0                	add    %edx,%eax
  800da6:	a3 40 d2 81 00       	mov    %eax,0x81d240
			expectedNumOfTables = 0;
  800dab:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800db2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800db5:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800dba:	52                   	push   %edx
  800dbb:	6a 01                	push   $0x1
  800dbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc0:	50                   	push   %eax
  800dc1:	e8 93 f2 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800dcc:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800dd1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800dd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ddb:	74 2f                	je     800e0c <initial_page_allocations+0xa3e>
  800ddd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800de4:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800de9:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800df0:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	52                   	push   %edx
  800df9:	ff 75 ec             	pushl  -0x14(%ebp)
  800dfc:	50                   	push   %eax
  800dfd:	68 00 3f 80 00       	push   $0x803f00
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 7f 0a 00 00       	call   801888 <cprintf_colored>
  800e09:	83 c4 20             	add    $0x20,%esp

			//3 KB
			allocIndex = 11;
  800e0c:	c7 05 4c d2 81 00 0b 	movl   $0xb,0x81d24c
  800e13:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800e16:	c7 85 30 ff ff ff 00 	movl   $0x1000,-0xd0(%ebp)
  800e1d:	10 00 00 
  800e20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e23:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800e29:	01 d0                	add    %edx,%eax
  800e2b:	48                   	dec    %eax
  800e2c:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800e32:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e38:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3d:	f7 b5 30 ff ff ff    	divl   -0xd0(%ebp)
  800e43:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e49:	29 d0                	sub    %edx,%eax
  800e4b:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 3*kilo ;
  800e4e:	c7 45 e8 00 0c 00 00 	movl   $0xc00,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800e55:	c7 85 28 ff ff ff 00 	movl   $0x1000,-0xd8(%ebp)
  800e5c:	10 00 00 
  800e5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e62:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e68:	01 d0                	add    %edx,%eax
  800e6a:	48                   	dec    %eax
  800e6b:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  800e71:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e77:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7c:	f7 b5 28 ff ff ff    	divl   -0xd8(%ebp)
  800e82:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e88:	29 d0                	sub    %edx,%eax
  800e8a:	89 c2                	mov    %eax,%edx
  800e8c:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800e91:	01 d0                	add    %edx,%eax
  800e93:	a3 40 d2 81 00       	mov    %eax,0x81d240
			expectedNumOfTables = 0;
  800e98:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800e9f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ea2:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800ea7:	52                   	push   %edx
  800ea8:	6a 01                	push   $0x1
  800eaa:	ff 75 e8             	pushl  -0x18(%ebp)
  800ead:	50                   	push   %eax
  800eae:	e8 a6 f1 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800eb3:	83 c4 10             	add    $0x10,%esp
  800eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800eb9:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800ebe:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800ec5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ec8:	74 2f                	je     800ef9 <initial_page_allocations+0xb2b>
  800eca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed1:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800ed6:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800edd:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800ee2:	83 ec 0c             	sub    $0xc,%esp
  800ee5:	52                   	push   %edx
  800ee6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee9:	50                   	push   %eax
  800eea:	68 00 3f 80 00       	push   $0x803f00
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 92 09 00 00       	call   801888 <cprintf_colored>
  800ef6:	83 c4 20             	add    $0x20,%esp

			//9 KB
			allocIndex = 12;
  800ef9:	c7 05 4c d2 81 00 0c 	movl   $0xc,0x81d24c
  800f00:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800f03:	c7 85 20 ff ff ff 00 	movl   $0x1000,-0xe0(%ebp)
  800f0a:	10 00 00 
  800f0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f10:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800f16:	01 d0                	add    %edx,%eax
  800f18:	48                   	dec    %eax
  800f19:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800f1f:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800f25:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2a:	f7 b5 20 ff ff ff    	divl   -0xe0(%ebp)
  800f30:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800f36:	29 d0                	sub    %edx,%eax
  800f38:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 9*kilo ;
  800f3b:	c7 45 e8 00 24 00 00 	movl   $0x2400,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800f42:	c7 85 18 ff ff ff 00 	movl   $0x1000,-0xe8(%ebp)
  800f49:	10 00 00 
  800f4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f4f:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	48                   	dec    %eax
  800f58:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f5e:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f64:	ba 00 00 00 00       	mov    $0x0,%edx
  800f69:	f7 b5 18 ff ff ff    	divl   -0xe8(%ebp)
  800f6f:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f75:	29 d0                	sub    %edx,%eax
  800f77:	89 c2                	mov    %eax,%edx
  800f79:	a1 40 d2 81 00       	mov    0x81d240,%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	a3 40 d2 81 00       	mov    %eax,0x81d240
			expectedNumOfTables = 0;
  800f85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800f8c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f8f:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800f94:	52                   	push   %edx
  800f95:	6a 01                	push   $0x1
  800f97:	ff 75 e8             	pushl  -0x18(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	e8 b9 f0 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800fa6:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800fab:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  800fb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800fb5:	74 2f                	je     800fe6 <initial_page_allocations+0xc18>
  800fb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fbe:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800fc3:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  800fca:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	52                   	push   %edx
  800fd3:	ff 75 ec             	pushl  -0x14(%ebp)
  800fd6:	50                   	push   %eax
  800fd7:	68 00 3f 80 00       	push   $0x803f00
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 a5 08 00 00       	call   801888 <cprintf_colored>
  800fe3:	83 c4 20             	add    $0x20,%esp
		}
		if (correct) eval += 15;
  800fe6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fea:	74 04                	je     800ff0 <initial_page_allocations+0xc22>
  800fec:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		correct = 1;
  800ff0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	//Insufficient space
	cprintf_colored(TEXT_cyan,"%~\n	1.2 Insufficient Space\n");
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	68 52 3f 80 00       	push   $0x803f52
  800fff:	6a 03                	push   $0x3
  801001:	e8 82 08 00 00       	call   801888 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 f7 19 00 00       	call   802a16 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 37 1a 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  80102a:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		uint32 restOfUHeap = (USER_HEAP_MAX - ACTUAL_PAGE_ALLOC_START) - (totalRequestedSize) ;
  801030:	a1 40 d2 81 00       	mov    0x81d240,%eax
  801035:	ba 00 f0 ff 1d       	mov    $0x1dfff000,%edx
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
		ptr_allocations[allocIndex] = malloc(restOfUHeap+1);
  801044:	8b 1d 4c d2 81 00    	mov    0x81d24c,%ebx
  80104a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  801050:	40                   	inc    %eax
  801051:	83 ec 0c             	sub    $0xc,%esp
  801054:	50                   	push   %eax
  801055:	e8 c3 17 00 00       	call   80281d <malloc>
  80105a:	83 c4 10             	add    $0x10,%esp
  80105d:	89 04 9d 20 50 80 00 	mov    %eax,0x805020(,%ebx,4)
		if (ptr_allocations[allocIndex] != NULL) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.1 Allocating insufficient space: should return NULL\n", allocIndex); }
  801064:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  801069:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  801070:	85 c0                	test   %eax,%eax
  801072:	74 1f                	je     801093 <initial_page_allocations+0xcc5>
  801074:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80107b:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  801080:	83 ec 04             	sub    $0x4,%esp
  801083:	50                   	push   %eax
  801084:	68 70 3f 80 00       	push   $0x803f70
  801089:	6a 0c                	push   $0xc
  80108b:	e8 f8 07 00 00       	call   801888 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 c9 19 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 ac 3f 80 00       	push   $0x803fac
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 cc 07 00 00       	call   801888 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 52 19 00 00       	call   802a16 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 1c 40 80 00       	push   $0x80401c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 a0 07 00 00       	call   801888 <cprintf_colored>
  8010e8:	83 c4 10             	add    $0x10,%esp
	}
	if (correct)	eval+=10 ;
  8010eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010ef:	74 04                	je     8010f5 <initial_page_allocations+0xd27>
  8010f1:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)

	return eval;
  8010f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5f                   	pop    %edi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    

008010ff <_main>:
#include <inc/lib.h>
#include <user/tst_malloc_helpers.h>

void
_main(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 28             	sub    $0x28,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801105:	a1 00 52 80 00       	mov    0x805200,%eax
  80110a:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801110:	a1 00 52 80 00       	mov    0x805200,%eax
  801115:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80111b:	39 c2                	cmp    %eax,%edx
  80111d:	72 14                	jb     801133 <_main+0x34>
			panic("Please increase the WS size");
  80111f:	83 ec 04             	sub    $0x4,%esp
  801122:	68 64 40 80 00       	push   $0x804064
  801127:	6a 0d                	push   $0xd
  801129:	68 80 40 80 00       	push   $0x804080
  80112e:	e8 5a 04 00 00       	call   80158d <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	68 98 40 80 00       	push   $0x804098
  80113b:	6a 0e                	push   $0xe
  80113d:	e8 46 07 00 00       	call   801888 <cprintf_colored>
  801142:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	68 cc 40 80 00       	push   $0x8040cc
  80114d:	6a 0e                	push   $0xe
  80114f:	e8 34 07 00 00       	call   801888 <cprintf_colored>
  801154:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  801157:	83 ec 08             	sub    $0x8,%esp
  80115a:	68 28 41 80 00       	push   $0x804128
  80115f:	6a 0e                	push   $0xe
  801161:	e8 22 07 00 00       	call   801888 <cprintf_colored>
  801166:	83 c4 10             	add    $0x10,%esp

	int eval = 0;
  801169:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  801170:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801177:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	int freeFrames, usedDiskPages ;

	uint32 *x, *y, *z ;
	cprintf_colored(TEXT_cyan, "\n%~STEP A: checking creation of shared object that is already exists... [35%] \n\n");
  80117e:	83 ec 08             	sub    $0x8,%esp
  801181:	68 60 41 80 00       	push   $0x804160
  801186:	6a 03                	push   $0x3
  801188:	e8 fb 06 00 00       	call   801888 <cprintf_colored>
  80118d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  801190:	83 ec 04             	sub    $0x4,%esp
  801193:	6a 01                	push   $0x1
  801195:	68 00 10 00 00       	push   $0x1000
  80119a:	68 b1 41 80 00       	push   $0x8041b1
  80119f:	e8 c1 16 00 00       	call   802865 <smalloc>
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8011aa:	e8 67 18 00 00       	call   802a16 <sys_calculate_free_frames>
  8011af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8011b2:	e8 aa 18 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  8011b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	6a 01                	push   $0x1
  8011bf:	68 00 10 00 00       	push   $0x1000
  8011c4:	68 b1 41 80 00       	push   $0x8041b1
  8011c9:	e8 97 16 00 00       	call   802865 <smalloc>
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0;
  8011d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8011d8:	74 19                	je     8011f3 <_main+0xf4>
  8011da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to create an already exists object and corresponding error is not returned!!");}
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	68 b4 41 80 00       	push   $0x8041b4
  8011e9:	6a 0c                	push   $0xc
  8011eb:	e8 98 06 00 00       	call   801888 <cprintf_colored>
  8011f0:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  8011f3:	e8 1e 18 00 00       	call   802a16 <sys_calculate_free_frames>
  8011f8:	89 c2                	mov    %eax,%edx
  8011fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011fd:	39 c2                	cmp    %eax,%edx
  8011ff:	74 19                	je     80121a <_main+0x11b>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  801201:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	68 0c 42 80 00       	push   $0x80420c
  801210:	6a 0c                	push   $0xc
  801212:	e8 71 06 00 00       	call   801888 <cprintf_colored>
  801217:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  80121a:	e8 42 18 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  80121f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801222:	74 19                	je     80123d <_main+0x13e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  801224:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80122b:	83 ec 08             	sub    $0x8,%esp
  80122e:	68 6c 42 80 00       	push   $0x80426c
  801233:	6a 0c                	push   $0xc
  801235:	e8 4e 06 00 00       	call   801888 <cprintf_colored>
  80123a:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  80123d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801241:	74 04                	je     801247 <_main+0x148>
  801243:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  801247:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking getting shared object that is NOT exists... [35%]\n\n");
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	68 8c 42 80 00       	push   $0x80428c
  801256:	6a 03                	push   $0x3
  801258:	e8 2b 06 00 00       	call   801888 <cprintf_colored>
  80125d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  801260:	a1 00 52 80 00       	mov    0x805200,%eax
  801265:	8b 40 10             	mov    0x10(%eax),%eax
  801268:	83 ec 08             	sub    $0x8,%esp
  80126b:	68 d4 42 80 00       	push   $0x8042d4
  801270:	50                   	push   %eax
  801271:	e8 23 16 00 00       	call   802899 <sget>
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	89 45 e8             	mov    %eax,-0x18(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80127c:	e8 95 17 00 00       	call   802a16 <sys_calculate_free_frames>
  801281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801284:	e8 d8 17 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  801289:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL)
  80128c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801290:	74 19                	je     8012ab <_main+0x1ac>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to get a NONE existing object and corresponding error is not returned!!");}
  801292:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801299:	83 ec 08             	sub    $0x8,%esp
  80129c:	68 d8 42 80 00       	push   $0x8042d8
  8012a1:	6a 0c                	push   $0xc
  8012a3:	e8 e0 05 00 00       	call   801888 <cprintf_colored>
  8012a8:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  8012ab:	e8 66 17 00 00       	call   802a16 <sys_calculate_free_frames>
  8012b0:	89 c2                	mov    %eax,%edx
  8012b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b5:	39 c2                	cmp    %eax,%edx
  8012b7:	74 19                	je     8012d2 <_main+0x1d3>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8012b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	68 2c 43 80 00       	push   $0x80432c
  8012c8:	6a 0c                	push   $0xc
  8012ca:	e8 b9 05 00 00       	call   801888 <cprintf_colored>
  8012cf:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012d2:	e8 8a 17 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  8012d7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8012da:	74 19                	je     8012f5 <_main+0x1f6>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  8012dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012e3:	83 ec 08             	sub    $0x8,%esp
  8012e6:	68 6c 42 80 00       	push   $0x80426c
  8012eb:	6a 0c                	push   $0xc
  8012ed:	e8 96 05 00 00       	call   801888 <cprintf_colored>
  8012f2:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  8012f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f9:	74 04                	je     8012ff <_main+0x200>
  8012fb:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  8012ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan, "\n%~STEP C: checking the creation of shared object that exceeds the SHARED area limit... [30%]\n\n");
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	68 88 43 80 00       	push   $0x804388
  80130e:	6a 03                	push   $0x3
  801310:	e8 73 05 00 00       	call   801888 <cprintf_colored>
  801315:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  801318:	e8 f9 16 00 00       	call   802a16 <sys_calculate_free_frames>
  80131d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801320:	e8 3c 17 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  801325:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  801328:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  80132d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801330:	89 45 dc             	mov    %eax,-0x24(%ebp)
		y = smalloc("y", size, 1);
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	6a 01                	push   $0x1
  801338:	ff 75 dc             	pushl  -0x24(%ebp)
  80133b:	68 e8 43 80 00       	push   $0x8043e8
  801340:	e8 20 15 00 00       	call   802865 <smalloc>
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL)
  80134b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80134f:	74 19                	je     80136a <_main+0x26b>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  801351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	68 ec 43 80 00       	push   $0x8043ec
  801360:	6a 0c                	push   $0xc
  801362:	e8 21 05 00 00       	call   801888 <cprintf_colored>
  801367:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  80136a:	e8 a7 16 00 00       	call   802a16 <sys_calculate_free_frames>
  80136f:	89 c2                	mov    %eax,%edx
  801371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801374:	39 c2                	cmp    %eax,%edx
  801376:	74 19                	je     801391 <_main+0x292>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  801378:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80137f:	83 ec 08             	sub    $0x8,%esp
  801382:	68 60 44 80 00       	push   $0x804460
  801387:	6a 0c                	push   $0xc
  801389:	e8 fa 04 00 00       	call   801888 <cprintf_colored>
  80138e:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801391:	e8 cb 16 00 00       	call   802a61 <sys_pf_calculate_allocated_pages>
  801396:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801399:	74 19                	je     8013b4 <_main+0x2b5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  80139b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013a2:	83 ec 08             	sub    $0x8,%esp
  8013a5:	68 6c 42 80 00       	push   $0x80426c
  8013aa:	6a 0c                	push   $0xc
  8013ac:	e8 d7 04 00 00       	call   801888 <cprintf_colored>
  8013b1:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  8013b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b8:	74 04                	je     8013be <_main+0x2bf>
  8013ba:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  8013be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_light_green, "%~\nTest of Shared Variables [Create & Get: Special Cases] completed. Eval = %d%%\n\n", eval);
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8013cb:	68 d4 44 80 00       	push   $0x8044d4
  8013d0:	6a 0a                	push   $0xa
  8013d2:	e8 b1 04 00 00       	call   801888 <cprintf_colored>
  8013d7:	83 c4 10             	add    $0x10,%esp

}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	57                   	push   %edi
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
  8013e3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8013e6:	e8 f4 17 00 00       	call   802bdf <sys_getenvindex>
  8013eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8013ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f1:	89 d0                	mov    %edx,%eax
  8013f3:	c1 e0 02             	shl    $0x2,%eax
  8013f6:	01 d0                	add    %edx,%eax
  8013f8:	c1 e0 03             	shl    $0x3,%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  801404:	01 d0                	add    %edx,%eax
  801406:	c1 e0 02             	shl    $0x2,%eax
  801409:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80140e:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801413:	a1 00 52 80 00       	mov    0x805200,%eax
  801418:	8a 40 20             	mov    0x20(%eax),%al
  80141b:	84 c0                	test   %al,%al
  80141d:	74 0d                	je     80142c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80141f:	a1 00 52 80 00       	mov    0x805200,%eax
  801424:	83 c0 20             	add    $0x20,%eax
  801427:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80142c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801430:	7e 0a                	jle    80143c <libmain+0x5f>
		binaryname = argv[0];
  801432:	8b 45 0c             	mov    0xc(%ebp),%eax
  801435:	8b 00                	mov    (%eax),%eax
  801437:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	ff 75 08             	pushl  0x8(%ebp)
  801445:	e8 b5 fc ff ff       	call   8010ff <_main>
  80144a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80144d:	a1 00 50 80 00       	mov    0x805000,%eax
  801452:	85 c0                	test   %eax,%eax
  801454:	0f 84 01 01 00 00    	je     80155b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80145a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801460:	bb 20 46 80 00       	mov    $0x804620,%ebx
  801465:	ba 0e 00 00 00       	mov    $0xe,%edx
  80146a:	89 c7                	mov    %eax,%edi
  80146c:	89 de                	mov    %ebx,%esi
  80146e:	89 d1                	mov    %edx,%ecx
  801470:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801472:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801475:	b9 56 00 00 00       	mov    $0x56,%ecx
  80147a:	b0 00                	mov    $0x0,%al
  80147c:	89 d7                	mov    %edx,%edi
  80147e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801480:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801487:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	50                   	push   %eax
  80148e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801494:	50                   	push   %eax
  801495:	e8 7b 19 00 00       	call   802e15 <sys_utilities>
  80149a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80149d:	e8 c4 14 00 00       	call   802966 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	68 40 45 80 00       	push   $0x804540
  8014aa:	e8 ac 03 00 00       	call   80185b <cprintf>
  8014af:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8014b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	74 18                	je     8014d1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8014b9:	e8 75 19 00 00       	call   802e33 <sys_get_optimal_num_faults>
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	50                   	push   %eax
  8014c2:	68 68 45 80 00       	push   $0x804568
  8014c7:	e8 8f 03 00 00       	call   80185b <cprintf>
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	eb 59                	jmp    80152a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014d1:	a1 00 52 80 00       	mov    0x805200,%eax
  8014d6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8014dc:	a1 00 52 80 00       	mov    0x805200,%eax
  8014e1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	52                   	push   %edx
  8014eb:	50                   	push   %eax
  8014ec:	68 8c 45 80 00       	push   $0x80458c
  8014f1:	e8 65 03 00 00       	call   80185b <cprintf>
  8014f6:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8014f9:	a1 00 52 80 00       	mov    0x805200,%eax
  8014fe:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801504:	a1 00 52 80 00       	mov    0x805200,%eax
  801509:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80150f:	a1 00 52 80 00       	mov    0x805200,%eax
  801514:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80151a:	51                   	push   %ecx
  80151b:	52                   	push   %edx
  80151c:	50                   	push   %eax
  80151d:	68 b4 45 80 00       	push   $0x8045b4
  801522:	e8 34 03 00 00       	call   80185b <cprintf>
  801527:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80152a:	a1 00 52 80 00       	mov    0x805200,%eax
  80152f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  801535:	83 ec 08             	sub    $0x8,%esp
  801538:	50                   	push   %eax
  801539:	68 0c 46 80 00       	push   $0x80460c
  80153e:	e8 18 03 00 00       	call   80185b <cprintf>
  801543:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	68 40 45 80 00       	push   $0x804540
  80154e:	e8 08 03 00 00       	call   80185b <cprintf>
  801553:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801556:	e8 25 14 00 00       	call   802980 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80155b:	e8 1f 00 00 00       	call   80157f <exit>
}
  801560:	90                   	nop
  801561:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801564:	5b                   	pop    %ebx
  801565:	5e                   	pop    %esi
  801566:	5f                   	pop    %edi
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    

00801569 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80156f:	83 ec 0c             	sub    $0xc,%esp
  801572:	6a 00                	push   $0x0
  801574:	e8 32 16 00 00       	call   802bab <sys_destroy_env>
  801579:	83 c4 10             	add    $0x10,%esp
}
  80157c:	90                   	nop
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <exit>:

void
exit(void)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801585:	e8 87 16 00 00       	call   802c11 <sys_exit_env>
}
  80158a:	90                   	nop
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801593:	8d 45 10             	lea    0x10(%ebp),%eax
  801596:	83 c0 04             	add    $0x4,%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80159c:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	74 16                	je     8015bb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015a5:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	50                   	push   %eax
  8015ae:	68 84 46 80 00       	push   $0x804684
  8015b3:	e8 a3 02 00 00       	call   80185b <cprintf>
  8015b8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8015bb:	a1 04 50 80 00       	mov    0x805004,%eax
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	ff 75 0c             	pushl  0xc(%ebp)
  8015c6:	ff 75 08             	pushl  0x8(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	68 8c 46 80 00       	push   $0x80468c
  8015cf:	6a 74                	push   $0x74
  8015d1:	e8 b2 02 00 00       	call   801888 <cprintf_colored>
  8015d6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8015d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015dc:	83 ec 08             	sub    $0x8,%esp
  8015df:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e2:	50                   	push   %eax
  8015e3:	e8 04 02 00 00       	call   8017ec <vcprintf>
  8015e8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	6a 00                	push   $0x0
  8015f0:	68 b4 46 80 00       	push   $0x8046b4
  8015f5:	e8 f2 01 00 00       	call   8017ec <vcprintf>
  8015fa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8015fd:	e8 7d ff ff ff       	call   80157f <exit>

	// should not return here
	while (1) ;
  801602:	eb fe                	jmp    801602 <_panic+0x75>

00801604 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80160a:	a1 00 52 80 00       	mov    0x805200,%eax
  80160f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801615:	8b 45 0c             	mov    0xc(%ebp),%eax
  801618:	39 c2                	cmp    %eax,%edx
  80161a:	74 14                	je     801630 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80161c:	83 ec 04             	sub    $0x4,%esp
  80161f:	68 b8 46 80 00       	push   $0x8046b8
  801624:	6a 26                	push   $0x26
  801626:	68 04 47 80 00       	push   $0x804704
  80162b:	e8 5d ff ff ff       	call   80158d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801630:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801637:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80163e:	e9 c5 00 00 00       	jmp    801708 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801646:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	01 d0                	add    %edx,%eax
  801652:	8b 00                	mov    (%eax),%eax
  801654:	85 c0                	test   %eax,%eax
  801656:	75 08                	jne    801660 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801658:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80165b:	e9 a5 00 00 00       	jmp    801705 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801660:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801667:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80166e:	eb 69                	jmp    8016d9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801670:	a1 00 52 80 00       	mov    0x805200,%eax
  801675:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80167b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80167e:	89 d0                	mov    %edx,%eax
  801680:	01 c0                	add    %eax,%eax
  801682:	01 d0                	add    %edx,%eax
  801684:	c1 e0 03             	shl    $0x3,%eax
  801687:	01 c8                	add    %ecx,%eax
  801689:	8a 40 04             	mov    0x4(%eax),%al
  80168c:	84 c0                	test   %al,%al
  80168e:	75 46                	jne    8016d6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801690:	a1 00 52 80 00       	mov    0x805200,%eax
  801695:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80169b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80169e:	89 d0                	mov    %edx,%eax
  8016a0:	01 c0                	add    %eax,%eax
  8016a2:	01 d0                	add    %edx,%eax
  8016a4:	c1 e0 03             	shl    $0x3,%eax
  8016a7:	01 c8                	add    %ecx,%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	01 c8                	add    %ecx,%eax
  8016c7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016c9:	39 c2                	cmp    %eax,%edx
  8016cb:	75 09                	jne    8016d6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8016cd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016d4:	eb 15                	jmp    8016eb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016d6:	ff 45 e8             	incl   -0x18(%ebp)
  8016d9:	a1 00 52 80 00       	mov    0x805200,%eax
  8016de:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e7:	39 c2                	cmp    %eax,%edx
  8016e9:	77 85                	ja     801670 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ef:	75 14                	jne    801705 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8016f1:	83 ec 04             	sub    $0x4,%esp
  8016f4:	68 10 47 80 00       	push   $0x804710
  8016f9:	6a 3a                	push   $0x3a
  8016fb:	68 04 47 80 00       	push   $0x804704
  801700:	e8 88 fe ff ff       	call   80158d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801705:	ff 45 f0             	incl   -0x10(%ebp)
  801708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80170e:	0f 8c 2f ff ff ff    	jl     801643 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801714:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80171b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801722:	eb 26                	jmp    80174a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801724:	a1 00 52 80 00       	mov    0x805200,%eax
  801729:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80172f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801732:	89 d0                	mov    %edx,%eax
  801734:	01 c0                	add    %eax,%eax
  801736:	01 d0                	add    %edx,%eax
  801738:	c1 e0 03             	shl    $0x3,%eax
  80173b:	01 c8                	add    %ecx,%eax
  80173d:	8a 40 04             	mov    0x4(%eax),%al
  801740:	3c 01                	cmp    $0x1,%al
  801742:	75 03                	jne    801747 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801744:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801747:	ff 45 e0             	incl   -0x20(%ebp)
  80174a:	a1 00 52 80 00       	mov    0x805200,%eax
  80174f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801758:	39 c2                	cmp    %eax,%edx
  80175a:	77 c8                	ja     801724 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80175c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801762:	74 14                	je     801778 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	68 64 47 80 00       	push   $0x804764
  80176c:	6a 44                	push   $0x44
  80176e:	68 04 47 80 00       	push   $0x804704
  801773:	e8 15 fe ff ff       	call   80158d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	53                   	push   %ebx
  80177f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	8d 48 01             	lea    0x1(%eax),%ecx
  80178a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178d:	89 0a                	mov    %ecx,(%edx)
  80178f:	8b 55 08             	mov    0x8(%ebp),%edx
  801792:	88 d1                	mov    %dl,%cl
  801794:	8b 55 0c             	mov    0xc(%ebp),%edx
  801797:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80179b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179e:	8b 00                	mov    (%eax),%eax
  8017a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017a5:	75 30                	jne    8017d7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8017a7:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  8017ad:	a0 24 52 80 00       	mov    0x805224,%al
  8017b2:	0f b6 c0             	movzbl %al,%eax
  8017b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b8:	8b 09                	mov    (%ecx),%ecx
  8017ba:	89 cb                	mov    %ecx,%ebx
  8017bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017bf:	83 c1 08             	add    $0x8,%ecx
  8017c2:	52                   	push   %edx
  8017c3:	50                   	push   %eax
  8017c4:	53                   	push   %ebx
  8017c5:	51                   	push   %ecx
  8017c6:	e8 57 11 00 00       	call   802922 <sys_cputs>
  8017cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017da:	8b 40 04             	mov    0x4(%eax),%eax
  8017dd:	8d 50 01             	lea    0x1(%eax),%edx
  8017e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017e6:	90                   	nop
  8017e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017fc:	00 00 00 
	b.cnt = 0;
  8017ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801806:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801809:	ff 75 0c             	pushl  0xc(%ebp)
  80180c:	ff 75 08             	pushl  0x8(%ebp)
  80180f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801815:	50                   	push   %eax
  801816:	68 7b 17 80 00       	push   $0x80177b
  80181b:	e8 5a 02 00 00       	call   801a7a <vprintfmt>
  801820:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801823:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801829:	a0 24 52 80 00       	mov    0x805224,%al
  80182e:	0f b6 c0             	movzbl %al,%eax
  801831:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801837:	52                   	push   %edx
  801838:	50                   	push   %eax
  801839:	51                   	push   %ecx
  80183a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801840:	83 c0 08             	add    $0x8,%eax
  801843:	50                   	push   %eax
  801844:	e8 d9 10 00 00       	call   802922 <sys_cputs>
  801849:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80184c:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  801853:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801861:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  801868:	8d 45 0c             	lea    0xc(%ebp),%eax
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	ff 75 f4             	pushl  -0xc(%ebp)
  801877:	50                   	push   %eax
  801878:	e8 6f ff ff ff       	call   8017ec <vcprintf>
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801883:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80188e:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	c1 e0 08             	shl    $0x8,%eax
  80189b:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  8018a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018a3:	83 c0 04             	add    $0x4,%eax
  8018a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ac:	83 ec 08             	sub    $0x8,%esp
  8018af:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b2:	50                   	push   %eax
  8018b3:	e8 34 ff ff ff       	call   8017ec <vcprintf>
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8018be:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  8018c5:	07 00 00 

	return cnt;
  8018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8018d3:	e8 8e 10 00 00       	call   802966 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018d8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e7:	50                   	push   %eax
  8018e8:	e8 ff fe ff ff       	call   8017ec <vcprintf>
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8018f3:	e8 88 10 00 00       	call   802980 <sys_unlock_cons>
	return cnt;
  8018f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	53                   	push   %ebx
  801901:	83 ec 14             	sub    $0x14,%esp
  801904:	8b 45 10             	mov    0x10(%ebp),%eax
  801907:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80190a:	8b 45 14             	mov    0x14(%ebp),%eax
  80190d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801910:	8b 45 18             	mov    0x18(%ebp),%eax
  801913:	ba 00 00 00 00       	mov    $0x0,%edx
  801918:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80191b:	77 55                	ja     801972 <printnum+0x75>
  80191d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801920:	72 05                	jb     801927 <printnum+0x2a>
  801922:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801925:	77 4b                	ja     801972 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801927:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80192a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80192d:	8b 45 18             	mov    0x18(%ebp),%eax
  801930:	ba 00 00 00 00       	mov    $0x0,%edx
  801935:	52                   	push   %edx
  801936:	50                   	push   %eax
  801937:	ff 75 f4             	pushl  -0xc(%ebp)
  80193a:	ff 75 f0             	pushl  -0x10(%ebp)
  80193d:	e8 06 20 00 00       	call   803948 <__udivdi3>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	ff 75 20             	pushl  0x20(%ebp)
  80194b:	53                   	push   %ebx
  80194c:	ff 75 18             	pushl  0x18(%ebp)
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	e8 a1 ff ff ff       	call   8018fd <printnum>
  80195c:	83 c4 20             	add    $0x20,%esp
  80195f:	eb 1a                	jmp    80197b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801961:	83 ec 08             	sub    $0x8,%esp
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	ff 75 20             	pushl  0x20(%ebp)
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	ff d0                	call   *%eax
  80196f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801972:	ff 4d 1c             	decl   0x1c(%ebp)
  801975:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801979:	7f e6                	jg     801961 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80197b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80197e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801989:	53                   	push   %ebx
  80198a:	51                   	push   %ecx
  80198b:	52                   	push   %edx
  80198c:	50                   	push   %eax
  80198d:	e8 c6 20 00 00       	call   803a58 <__umoddi3>
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	05 d4 49 80 00       	add    $0x8049d4,%eax
  80199a:	8a 00                	mov    (%eax),%al
  80199c:	0f be c0             	movsbl %al,%eax
  80199f:	83 ec 08             	sub    $0x8,%esp
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	50                   	push   %eax
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	ff d0                	call   *%eax
  8019ab:	83 c4 10             	add    $0x10,%esp
}
  8019ae:	90                   	nop
  8019af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019b7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019bb:	7e 1c                	jle    8019d9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8b 00                	mov    (%eax),%eax
  8019c2:	8d 50 08             	lea    0x8(%eax),%edx
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	89 10                	mov    %edx,(%eax)
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	8b 00                	mov    (%eax),%eax
  8019cf:	83 e8 08             	sub    $0x8,%eax
  8019d2:	8b 50 04             	mov    0x4(%eax),%edx
  8019d5:	8b 00                	mov    (%eax),%eax
  8019d7:	eb 40                	jmp    801a19 <getuint+0x65>
	else if (lflag)
  8019d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019dd:	74 1e                	je     8019fd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8b 00                	mov    (%eax),%eax
  8019e4:	8d 50 04             	lea    0x4(%eax),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	89 10                	mov    %edx,(%eax)
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 e8 04             	sub    $0x4,%eax
  8019f4:	8b 00                	mov    (%eax),%eax
  8019f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fb:	eb 1c                	jmp    801a19 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 50 04             	lea    0x4(%eax),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 10                	mov    %edx,(%eax)
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8b 00                	mov    (%eax),%eax
  801a0f:	83 e8 04             	sub    $0x4,%eax
  801a12:	8b 00                	mov    (%eax),%eax
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a19:	5d                   	pop    %ebp
  801a1a:	c3                   	ret    

00801a1b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a1e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a22:	7e 1c                	jle    801a40 <getint+0x25>
		return va_arg(*ap, long long);
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8b 00                	mov    (%eax),%eax
  801a29:	8d 50 08             	lea    0x8(%eax),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	89 10                	mov    %edx,(%eax)
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	8b 00                	mov    (%eax),%eax
  801a36:	83 e8 08             	sub    $0x8,%eax
  801a39:	8b 50 04             	mov    0x4(%eax),%edx
  801a3c:	8b 00                	mov    (%eax),%eax
  801a3e:	eb 38                	jmp    801a78 <getint+0x5d>
	else if (lflag)
  801a40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a44:	74 1a                	je     801a60 <getint+0x45>
		return va_arg(*ap, long);
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8b 00                	mov    (%eax),%eax
  801a4b:	8d 50 04             	lea    0x4(%eax),%edx
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	89 10                	mov    %edx,(%eax)
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	83 e8 04             	sub    $0x4,%eax
  801a5b:	8b 00                	mov    (%eax),%eax
  801a5d:	99                   	cltd   
  801a5e:	eb 18                	jmp    801a78 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8b 00                	mov    (%eax),%eax
  801a65:	8d 50 04             	lea    0x4(%eax),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	89 10                	mov    %edx,(%eax)
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8b 00                	mov    (%eax),%eax
  801a72:	83 e8 04             	sub    $0x4,%eax
  801a75:	8b 00                	mov    (%eax),%eax
  801a77:	99                   	cltd   
}
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    

00801a7a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	56                   	push   %esi
  801a7e:	53                   	push   %ebx
  801a7f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a82:	eb 17                	jmp    801a9b <vprintfmt+0x21>
			if (ch == '\0')
  801a84:	85 db                	test   %ebx,%ebx
  801a86:	0f 84 c1 03 00 00    	je     801e4d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a8c:	83 ec 08             	sub    $0x8,%esp
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	53                   	push   %ebx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	ff d0                	call   *%eax
  801a98:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9e:	8d 50 01             	lea    0x1(%eax),%edx
  801aa1:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa4:	8a 00                	mov    (%eax),%al
  801aa6:	0f b6 d8             	movzbl %al,%ebx
  801aa9:	83 fb 25             	cmp    $0x25,%ebx
  801aac:	75 d6                	jne    801a84 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801aae:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801ab2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801ab9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801ac0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ac7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ace:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad1:	8d 50 01             	lea    0x1(%eax),%edx
  801ad4:	89 55 10             	mov    %edx,0x10(%ebp)
  801ad7:	8a 00                	mov    (%eax),%al
  801ad9:	0f b6 d8             	movzbl %al,%ebx
  801adc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801adf:	83 f8 5b             	cmp    $0x5b,%eax
  801ae2:	0f 87 3d 03 00 00    	ja     801e25 <vprintfmt+0x3ab>
  801ae8:	8b 04 85 f8 49 80 00 	mov    0x8049f8(,%eax,4),%eax
  801aef:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801af1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801af5:	eb d7                	jmp    801ace <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801af7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801afb:	eb d1                	jmp    801ace <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801afd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b07:	89 d0                	mov    %edx,%eax
  801b09:	c1 e0 02             	shl    $0x2,%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	01 c0                	add    %eax,%eax
  801b10:	01 d8                	add    %ebx,%eax
  801b12:	83 e8 30             	sub    $0x30,%eax
  801b15:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b18:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1b:	8a 00                	mov    (%eax),%al
  801b1d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b20:	83 fb 2f             	cmp    $0x2f,%ebx
  801b23:	7e 3e                	jle    801b63 <vprintfmt+0xe9>
  801b25:	83 fb 39             	cmp    $0x39,%ebx
  801b28:	7f 39                	jg     801b63 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b2a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b2d:	eb d5                	jmp    801b04 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b32:	83 c0 04             	add    $0x4,%eax
  801b35:	89 45 14             	mov    %eax,0x14(%ebp)
  801b38:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3b:	83 e8 04             	sub    $0x4,%eax
  801b3e:	8b 00                	mov    (%eax),%eax
  801b40:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b43:	eb 1f                	jmp    801b64 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b49:	79 83                	jns    801ace <vprintfmt+0x54>
				width = 0;
  801b4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b52:	e9 77 ff ff ff       	jmp    801ace <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b57:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b5e:	e9 6b ff ff ff       	jmp    801ace <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b63:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b68:	0f 89 60 ff ff ff    	jns    801ace <vprintfmt+0x54>
				width = precision, precision = -1;
  801b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b74:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b7b:	e9 4e ff ff ff       	jmp    801ace <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b80:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b83:	e9 46 ff ff ff       	jmp    801ace <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b88:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8b:	83 c0 04             	add    $0x4,%eax
  801b8e:	89 45 14             	mov    %eax,0x14(%ebp)
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	83 e8 04             	sub    $0x4,%eax
  801b97:	8b 00                	mov    (%eax),%eax
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	50                   	push   %eax
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	ff d0                	call   *%eax
  801ba5:	83 c4 10             	add    $0x10,%esp
			break;
  801ba8:	e9 9b 02 00 00       	jmp    801e48 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bad:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb0:	83 c0 04             	add    $0x4,%eax
  801bb3:	89 45 14             	mov    %eax,0x14(%ebp)
  801bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb9:	83 e8 04             	sub    $0x4,%eax
  801bbc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801bbe:	85 db                	test   %ebx,%ebx
  801bc0:	79 02                	jns    801bc4 <vprintfmt+0x14a>
				err = -err;
  801bc2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801bc4:	83 fb 64             	cmp    $0x64,%ebx
  801bc7:	7f 0b                	jg     801bd4 <vprintfmt+0x15a>
  801bc9:	8b 34 9d 40 48 80 00 	mov    0x804840(,%ebx,4),%esi
  801bd0:	85 f6                	test   %esi,%esi
  801bd2:	75 19                	jne    801bed <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801bd4:	53                   	push   %ebx
  801bd5:	68 e5 49 80 00       	push   $0x8049e5
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	ff 75 08             	pushl  0x8(%ebp)
  801be0:	e8 70 02 00 00       	call   801e55 <printfmt>
  801be5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801be8:	e9 5b 02 00 00       	jmp    801e48 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bed:	56                   	push   %esi
  801bee:	68 ee 49 80 00       	push   $0x8049ee
  801bf3:	ff 75 0c             	pushl  0xc(%ebp)
  801bf6:	ff 75 08             	pushl  0x8(%ebp)
  801bf9:	e8 57 02 00 00       	call   801e55 <printfmt>
  801bfe:	83 c4 10             	add    $0x10,%esp
			break;
  801c01:	e9 42 02 00 00       	jmp    801e48 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c06:	8b 45 14             	mov    0x14(%ebp),%eax
  801c09:	83 c0 04             	add    $0x4,%eax
  801c0c:	89 45 14             	mov    %eax,0x14(%ebp)
  801c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c12:	83 e8 04             	sub    $0x4,%eax
  801c15:	8b 30                	mov    (%eax),%esi
  801c17:	85 f6                	test   %esi,%esi
  801c19:	75 05                	jne    801c20 <vprintfmt+0x1a6>
				p = "(null)";
  801c1b:	be f1 49 80 00       	mov    $0x8049f1,%esi
			if (width > 0 && padc != '-')
  801c20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c24:	7e 6d                	jle    801c93 <vprintfmt+0x219>
  801c26:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c2a:	74 67                	je     801c93 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2f:	83 ec 08             	sub    $0x8,%esp
  801c32:	50                   	push   %eax
  801c33:	56                   	push   %esi
  801c34:	e8 1e 03 00 00       	call   801f57 <strnlen>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c3f:	eb 16                	jmp    801c57 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c41:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	50                   	push   %eax
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	ff d0                	call   *%eax
  801c51:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c54:	ff 4d e4             	decl   -0x1c(%ebp)
  801c57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c5b:	7f e4                	jg     801c41 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c5d:	eb 34                	jmp    801c93 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c63:	74 1c                	je     801c81 <vprintfmt+0x207>
  801c65:	83 fb 1f             	cmp    $0x1f,%ebx
  801c68:	7e 05                	jle    801c6f <vprintfmt+0x1f5>
  801c6a:	83 fb 7e             	cmp    $0x7e,%ebx
  801c6d:	7e 12                	jle    801c81 <vprintfmt+0x207>
					putch('?', putdat);
  801c6f:	83 ec 08             	sub    $0x8,%esp
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	6a 3f                	push   $0x3f
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	ff d0                	call   *%eax
  801c7c:	83 c4 10             	add    $0x10,%esp
  801c7f:	eb 0f                	jmp    801c90 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c81:	83 ec 08             	sub    $0x8,%esp
  801c84:	ff 75 0c             	pushl  0xc(%ebp)
  801c87:	53                   	push   %ebx
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	ff d0                	call   *%eax
  801c8d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c90:	ff 4d e4             	decl   -0x1c(%ebp)
  801c93:	89 f0                	mov    %esi,%eax
  801c95:	8d 70 01             	lea    0x1(%eax),%esi
  801c98:	8a 00                	mov    (%eax),%al
  801c9a:	0f be d8             	movsbl %al,%ebx
  801c9d:	85 db                	test   %ebx,%ebx
  801c9f:	74 24                	je     801cc5 <vprintfmt+0x24b>
  801ca1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ca5:	78 b8                	js     801c5f <vprintfmt+0x1e5>
  801ca7:	ff 4d e0             	decl   -0x20(%ebp)
  801caa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cae:	79 af                	jns    801c5f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cb0:	eb 13                	jmp    801cc5 <vprintfmt+0x24b>
				putch(' ', putdat);
  801cb2:	83 ec 08             	sub    $0x8,%esp
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	6a 20                	push   $0x20
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	ff d0                	call   *%eax
  801cbf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cc2:	ff 4d e4             	decl   -0x1c(%ebp)
  801cc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cc9:	7f e7                	jg     801cb2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ccb:	e9 78 01 00 00       	jmp    801e48 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801cd0:	83 ec 08             	sub    $0x8,%esp
  801cd3:	ff 75 e8             	pushl  -0x18(%ebp)
  801cd6:	8d 45 14             	lea    0x14(%ebp),%eax
  801cd9:	50                   	push   %eax
  801cda:	e8 3c fd ff ff       	call   801a1b <getint>
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ce5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cee:	85 d2                	test   %edx,%edx
  801cf0:	79 23                	jns    801d15 <vprintfmt+0x29b>
				putch('-', putdat);
  801cf2:	83 ec 08             	sub    $0x8,%esp
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	6a 2d                	push   $0x2d
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	ff d0                	call   *%eax
  801cff:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d08:	f7 d8                	neg    %eax
  801d0a:	83 d2 00             	adc    $0x0,%edx
  801d0d:	f7 da                	neg    %edx
  801d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d15:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d1c:	e9 bc 00 00 00       	jmp    801ddd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d21:	83 ec 08             	sub    $0x8,%esp
  801d24:	ff 75 e8             	pushl  -0x18(%ebp)
  801d27:	8d 45 14             	lea    0x14(%ebp),%eax
  801d2a:	50                   	push   %eax
  801d2b:	e8 84 fc ff ff       	call   8019b4 <getuint>
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d39:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d40:	e9 98 00 00 00       	jmp    801ddd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	ff 75 0c             	pushl  0xc(%ebp)
  801d4b:	6a 58                	push   $0x58
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	ff d0                	call   *%eax
  801d52:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	ff 75 0c             	pushl  0xc(%ebp)
  801d5b:	6a 58                	push   $0x58
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	ff d0                	call   *%eax
  801d62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	ff 75 0c             	pushl  0xc(%ebp)
  801d6b:	6a 58                	push   $0x58
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	ff d0                	call   *%eax
  801d72:	83 c4 10             	add    $0x10,%esp
			break;
  801d75:	e9 ce 00 00 00       	jmp    801e48 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d7a:	83 ec 08             	sub    $0x8,%esp
  801d7d:	ff 75 0c             	pushl  0xc(%ebp)
  801d80:	6a 30                	push   $0x30
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	ff d0                	call   *%eax
  801d87:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d8a:	83 ec 08             	sub    $0x8,%esp
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	6a 78                	push   $0x78
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	ff d0                	call   *%eax
  801d97:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9d:	83 c0 04             	add    $0x4,%eax
  801da0:	89 45 14             	mov    %eax,0x14(%ebp)
  801da3:	8b 45 14             	mov    0x14(%ebp),%eax
  801da6:	83 e8 04             	sub    $0x4,%eax
  801da9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801db5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801dbc:	eb 1f                	jmp    801ddd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801dbe:	83 ec 08             	sub    $0x8,%esp
  801dc1:	ff 75 e8             	pushl  -0x18(%ebp)
  801dc4:	8d 45 14             	lea    0x14(%ebp),%eax
  801dc7:	50                   	push   %eax
  801dc8:	e8 e7 fb ff ff       	call   8019b4 <getuint>
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801dd6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801ddd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de4:	83 ec 04             	sub    $0x4,%esp
  801de7:	52                   	push   %edx
  801de8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801deb:	50                   	push   %eax
  801dec:	ff 75 f4             	pushl  -0xc(%ebp)
  801def:	ff 75 f0             	pushl  -0x10(%ebp)
  801df2:	ff 75 0c             	pushl  0xc(%ebp)
  801df5:	ff 75 08             	pushl  0x8(%ebp)
  801df8:	e8 00 fb ff ff       	call   8018fd <printnum>
  801dfd:	83 c4 20             	add    $0x20,%esp
			break;
  801e00:	eb 46                	jmp    801e48 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e02:	83 ec 08             	sub    $0x8,%esp
  801e05:	ff 75 0c             	pushl  0xc(%ebp)
  801e08:	53                   	push   %ebx
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	ff d0                	call   *%eax
  801e0e:	83 c4 10             	add    $0x10,%esp
			break;
  801e11:	eb 35                	jmp    801e48 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e13:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801e1a:	eb 2c                	jmp    801e48 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801e1c:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801e23:	eb 23                	jmp    801e48 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e25:	83 ec 08             	sub    $0x8,%esp
  801e28:	ff 75 0c             	pushl  0xc(%ebp)
  801e2b:	6a 25                	push   $0x25
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	ff d0                	call   *%eax
  801e32:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e35:	ff 4d 10             	decl   0x10(%ebp)
  801e38:	eb 03                	jmp    801e3d <vprintfmt+0x3c3>
  801e3a:	ff 4d 10             	decl   0x10(%ebp)
  801e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e40:	48                   	dec    %eax
  801e41:	8a 00                	mov    (%eax),%al
  801e43:	3c 25                	cmp    $0x25,%al
  801e45:	75 f3                	jne    801e3a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e47:	90                   	nop
		}
	}
  801e48:	e9 35 fc ff ff       	jmp    801a82 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e4d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    

00801e55 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e5b:	8d 45 10             	lea    0x10(%ebp),%eax
  801e5e:	83 c0 04             	add    $0x4,%eax
  801e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e64:	8b 45 10             	mov    0x10(%ebp),%eax
  801e67:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6a:	50                   	push   %eax
  801e6b:	ff 75 0c             	pushl  0xc(%ebp)
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	e8 04 fc ff ff       	call   801a7a <vprintfmt>
  801e76:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e79:	90                   	nop
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e82:	8b 40 08             	mov    0x8(%eax),%eax
  801e85:	8d 50 01             	lea    0x1(%eax),%edx
  801e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e91:	8b 10                	mov    (%eax),%edx
  801e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e96:	8b 40 04             	mov    0x4(%eax),%eax
  801e99:	39 c2                	cmp    %eax,%edx
  801e9b:	73 12                	jae    801eaf <sprintputch+0x33>
		*b->buf++ = ch;
  801e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea0:	8b 00                	mov    (%eax),%eax
  801ea2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea8:	89 0a                	mov    %ecx,(%edx)
  801eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  801ead:	88 10                	mov    %dl,(%eax)
}
  801eaf:	90                   	nop
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    

00801eb2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	01 d0                	add    %edx,%eax
  801ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ecc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ed3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ed7:	74 06                	je     801edf <vsnprintf+0x2d>
  801ed9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801edd:	7f 07                	jg     801ee6 <vsnprintf+0x34>
		return -E_INVAL;
  801edf:	b8 03 00 00 00       	mov    $0x3,%eax
  801ee4:	eb 20                	jmp    801f06 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ee6:	ff 75 14             	pushl  0x14(%ebp)
  801ee9:	ff 75 10             	pushl  0x10(%ebp)
  801eec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801eef:	50                   	push   %eax
  801ef0:	68 7c 1e 80 00       	push   $0x801e7c
  801ef5:	e8 80 fb ff ff       	call   801a7a <vprintfmt>
  801efa:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f00:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f0e:	8d 45 10             	lea    0x10(%ebp),%eax
  801f11:	83 c0 04             	add    $0x4,%eax
  801f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f17:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1d:	50                   	push   %eax
  801f1e:	ff 75 0c             	pushl  0xc(%ebp)
  801f21:	ff 75 08             	pushl  0x8(%ebp)
  801f24:	e8 89 ff ff ff       	call   801eb2 <vsnprintf>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f41:	eb 06                	jmp    801f49 <strlen+0x15>
		n++;
  801f43:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f46:	ff 45 08             	incl   0x8(%ebp)
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	8a 00                	mov    (%eax),%al
  801f4e:	84 c0                	test   %al,%al
  801f50:	75 f1                	jne    801f43 <strlen+0xf>
		n++;
	return n;
  801f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f64:	eb 09                	jmp    801f6f <strnlen+0x18>
		n++;
  801f66:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f69:	ff 45 08             	incl   0x8(%ebp)
  801f6c:	ff 4d 0c             	decl   0xc(%ebp)
  801f6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f73:	74 09                	je     801f7e <strnlen+0x27>
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8a 00                	mov    (%eax),%al
  801f7a:	84 c0                	test   %al,%al
  801f7c:	75 e8                	jne    801f66 <strnlen+0xf>
		n++;
	return n;
  801f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f8f:	90                   	nop
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	8d 50 01             	lea    0x1(%eax),%edx
  801f96:	89 55 08             	mov    %edx,0x8(%ebp)
  801f99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f9f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fa2:	8a 12                	mov    (%edx),%dl
  801fa4:	88 10                	mov    %dl,(%eax)
  801fa6:	8a 00                	mov    (%eax),%al
  801fa8:	84 c0                	test   %al,%al
  801faa:	75 e4                	jne    801f90 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fc4:	eb 1f                	jmp    801fe5 <strncpy+0x34>
		*dst++ = *src;
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	8d 50 01             	lea    0x1(%eax),%edx
  801fcc:	89 55 08             	mov    %edx,0x8(%ebp)
  801fcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd2:	8a 12                	mov    (%edx),%dl
  801fd4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd9:	8a 00                	mov    (%eax),%al
  801fdb:	84 c0                	test   %al,%al
  801fdd:	74 03                	je     801fe2 <strncpy+0x31>
			src++;
  801fdf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fe2:	ff 45 fc             	incl   -0x4(%ebp)
  801fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe8:	3b 45 10             	cmp    0x10(%ebp),%eax
  801feb:	72 d9                	jb     801fc6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801fed:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801ffe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802002:	74 30                	je     802034 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802004:	eb 16                	jmp    80201c <strlcpy+0x2a>
			*dst++ = *src++;
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	8d 50 01             	lea    0x1(%eax),%edx
  80200c:	89 55 08             	mov    %edx,0x8(%ebp)
  80200f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802012:	8d 4a 01             	lea    0x1(%edx),%ecx
  802015:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802018:	8a 12                	mov    (%edx),%dl
  80201a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80201c:	ff 4d 10             	decl   0x10(%ebp)
  80201f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802023:	74 09                	je     80202e <strlcpy+0x3c>
  802025:	8b 45 0c             	mov    0xc(%ebp),%eax
  802028:	8a 00                	mov    (%eax),%al
  80202a:	84 c0                	test   %al,%al
  80202c:	75 d8                	jne    802006 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802034:	8b 55 08             	mov    0x8(%ebp),%edx
  802037:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80203a:	29 c2                	sub    %eax,%edx
  80203c:	89 d0                	mov    %edx,%eax
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802043:	eb 06                	jmp    80204b <strcmp+0xb>
		p++, q++;
  802045:	ff 45 08             	incl   0x8(%ebp)
  802048:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	8a 00                	mov    (%eax),%al
  802050:	84 c0                	test   %al,%al
  802052:	74 0e                	je     802062 <strcmp+0x22>
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	8a 10                	mov    (%eax),%dl
  802059:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205c:	8a 00                	mov    (%eax),%al
  80205e:	38 c2                	cmp    %al,%dl
  802060:	74 e3                	je     802045 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	8a 00                	mov    (%eax),%al
  802067:	0f b6 d0             	movzbl %al,%edx
  80206a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206d:	8a 00                	mov    (%eax),%al
  80206f:	0f b6 c0             	movzbl %al,%eax
  802072:	29 c2                	sub    %eax,%edx
  802074:	89 d0                	mov    %edx,%eax
}
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    

00802078 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80207b:	eb 09                	jmp    802086 <strncmp+0xe>
		n--, p++, q++;
  80207d:	ff 4d 10             	decl   0x10(%ebp)
  802080:	ff 45 08             	incl   0x8(%ebp)
  802083:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802086:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208a:	74 17                	je     8020a3 <strncmp+0x2b>
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	8a 00                	mov    (%eax),%al
  802091:	84 c0                	test   %al,%al
  802093:	74 0e                	je     8020a3 <strncmp+0x2b>
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8a 10                	mov    (%eax),%dl
  80209a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	38 c2                	cmp    %al,%dl
  8020a1:	74 da                	je     80207d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8020a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020a7:	75 07                	jne    8020b0 <strncmp+0x38>
		return 0;
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	eb 14                	jmp    8020c4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	8a 00                	mov    (%eax),%al
  8020b5:	0f b6 d0             	movzbl %al,%edx
  8020b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020bb:	8a 00                	mov    (%eax),%al
  8020bd:	0f b6 c0             	movzbl %al,%eax
  8020c0:	29 c2                	sub    %eax,%edx
  8020c2:	89 d0                	mov    %edx,%eax
}
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    

008020c6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020d2:	eb 12                	jmp    8020e6 <strchr+0x20>
		if (*s == c)
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	8a 00                	mov    (%eax),%al
  8020d9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020dc:	75 05                	jne    8020e3 <strchr+0x1d>
			return (char *) s;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	eb 11                	jmp    8020f4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020e3:	ff 45 08             	incl   0x8(%ebp)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	8a 00                	mov    (%eax),%al
  8020eb:	84 c0                	test   %al,%al
  8020ed:	75 e5                	jne    8020d4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802102:	eb 0d                	jmp    802111 <strfind+0x1b>
		if (*s == c)
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	8a 00                	mov    (%eax),%al
  802109:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80210c:	74 0e                	je     80211c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80210e:	ff 45 08             	incl   0x8(%ebp)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8a 00                	mov    (%eax),%al
  802116:	84 c0                	test   %al,%al
  802118:	75 ea                	jne    802104 <strfind+0xe>
  80211a:	eb 01                	jmp    80211d <strfind+0x27>
		if (*s == c)
			break;
  80211c:	90                   	nop
	return (char *) s;
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80212e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802132:	76 63                	jbe    802197 <memset+0x75>
		uint64 data_block = c;
  802134:	8b 45 0c             	mov    0xc(%ebp),%eax
  802137:	99                   	cltd   
  802138:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80213b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80213e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802148:	c1 e0 08             	shl    $0x8,%eax
  80214b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80214e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802157:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80215b:	c1 e0 10             	shl    $0x10,%eax
  80215e:	09 45 f0             	or     %eax,-0x10(%ebp)
  802161:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216a:	89 c2                	mov    %eax,%edx
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
  802171:	09 45 f0             	or     %eax,-0x10(%ebp)
  802174:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  802177:	eb 18                	jmp    802191 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802179:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80217c:	8d 41 08             	lea    0x8(%ecx),%eax
  80217f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802188:	89 01                	mov    %eax,(%ecx)
  80218a:	89 51 04             	mov    %edx,0x4(%ecx)
  80218d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802191:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802195:	77 e2                	ja     802179 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  802197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80219b:	74 23                	je     8021c0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021a3:	eb 0e                	jmp    8021b3 <memset+0x91>
			*p8++ = (uint8)c;
  8021a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021a8:	8d 50 01             	lea    0x1(%eax),%edx
  8021ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8021b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8021bc:	85 c0                	test   %eax,%eax
  8021be:	75 e5                	jne    8021a5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8021cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8021d7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021db:	76 24                	jbe    802201 <memcpy+0x3c>
		while(n >= 8){
  8021dd:	eb 1c                	jmp    8021fb <memcpy+0x36>
			*d64 = *s64;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8b 50 04             	mov    0x4(%eax),%edx
  8021e5:	8b 00                	mov    (%eax),%eax
  8021e7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021ea:	89 01                	mov    %eax,(%ecx)
  8021ec:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8021ef:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8021f3:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8021f7:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8021fb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021ff:	77 de                	ja     8021df <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802201:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802205:	74 31                	je     802238 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80220d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802210:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802213:	eb 16                	jmp    80222b <memcpy+0x66>
			*d8++ = *s8++;
  802215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802218:	8d 50 01             	lea    0x1(%eax),%edx
  80221b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80221e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802221:	8d 4a 01             	lea    0x1(%edx),%ecx
  802224:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802227:	8a 12                	mov    (%edx),%dl
  802229:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80222b:	8b 45 10             	mov    0x10(%ebp),%eax
  80222e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802231:	89 55 10             	mov    %edx,0x10(%ebp)
  802234:	85 c0                	test   %eax,%eax
  802236:	75 dd                	jne    802215 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802243:	8b 45 0c             	mov    0xc(%ebp),%eax
  802246:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80224f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802252:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802255:	73 50                	jae    8022a7 <memmove+0x6a>
  802257:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80225a:	8b 45 10             	mov    0x10(%ebp),%eax
  80225d:	01 d0                	add    %edx,%eax
  80225f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802262:	76 43                	jbe    8022a7 <memmove+0x6a>
		s += n;
  802264:	8b 45 10             	mov    0x10(%ebp),%eax
  802267:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80226a:	8b 45 10             	mov    0x10(%ebp),%eax
  80226d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802270:	eb 10                	jmp    802282 <memmove+0x45>
			*--d = *--s;
  802272:	ff 4d f8             	decl   -0x8(%ebp)
  802275:	ff 4d fc             	decl   -0x4(%ebp)
  802278:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80227b:	8a 10                	mov    (%eax),%dl
  80227d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802280:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802282:	8b 45 10             	mov    0x10(%ebp),%eax
  802285:	8d 50 ff             	lea    -0x1(%eax),%edx
  802288:	89 55 10             	mov    %edx,0x10(%ebp)
  80228b:	85 c0                	test   %eax,%eax
  80228d:	75 e3                	jne    802272 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80228f:	eb 23                	jmp    8022b4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802291:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802294:	8d 50 01             	lea    0x1(%eax),%edx
  802297:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80229a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80229d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022a0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8022a3:	8a 12                	mov    (%edx),%dl
  8022a5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8022a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	75 dd                	jne    802291 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8022c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8022cb:	eb 2a                	jmp    8022f7 <memcmp+0x3e>
		if (*s1 != *s2)
  8022cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d0:	8a 10                	mov    (%eax),%dl
  8022d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022d5:	8a 00                	mov    (%eax),%al
  8022d7:	38 c2                	cmp    %al,%dl
  8022d9:	74 16                	je     8022f1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8022db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022de:	8a 00                	mov    (%eax),%al
  8022e0:	0f b6 d0             	movzbl %al,%edx
  8022e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022e6:	8a 00                	mov    (%eax),%al
  8022e8:	0f b6 c0             	movzbl %al,%eax
  8022eb:	29 c2                	sub    %eax,%edx
  8022ed:	89 d0                	mov    %edx,%eax
  8022ef:	eb 18                	jmp    802309 <memcmp+0x50>
		s1++, s2++;
  8022f1:	ff 45 fc             	incl   -0x4(%ebp)
  8022f4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8022f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022fd:	89 55 10             	mov    %edx,0x10(%ebp)
  802300:	85 c0                	test   %eax,%eax
  802302:	75 c9                	jne    8022cd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802311:	8b 55 08             	mov    0x8(%ebp),%edx
  802314:	8b 45 10             	mov    0x10(%ebp),%eax
  802317:	01 d0                	add    %edx,%eax
  802319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80231c:	eb 15                	jmp    802333 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8a 00                	mov    (%eax),%al
  802323:	0f b6 d0             	movzbl %al,%edx
  802326:	8b 45 0c             	mov    0xc(%ebp),%eax
  802329:	0f b6 c0             	movzbl %al,%eax
  80232c:	39 c2                	cmp    %eax,%edx
  80232e:	74 0d                	je     80233d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802330:	ff 45 08             	incl   0x8(%ebp)
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802339:	72 e3                	jb     80231e <memfind+0x13>
  80233b:	eb 01                	jmp    80233e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80233d:	90                   	nop
	return (void *) s;
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802350:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802357:	eb 03                	jmp    80235c <strtol+0x19>
		s++;
  802359:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	8a 00                	mov    (%eax),%al
  802361:	3c 20                	cmp    $0x20,%al
  802363:	74 f4                	je     802359 <strtol+0x16>
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	8a 00                	mov    (%eax),%al
  80236a:	3c 09                	cmp    $0x9,%al
  80236c:	74 eb                	je     802359 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	8a 00                	mov    (%eax),%al
  802373:	3c 2b                	cmp    $0x2b,%al
  802375:	75 05                	jne    80237c <strtol+0x39>
		s++;
  802377:	ff 45 08             	incl   0x8(%ebp)
  80237a:	eb 13                	jmp    80238f <strtol+0x4c>
	else if (*s == '-')
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	8a 00                	mov    (%eax),%al
  802381:	3c 2d                	cmp    $0x2d,%al
  802383:	75 0a                	jne    80238f <strtol+0x4c>
		s++, neg = 1;
  802385:	ff 45 08             	incl   0x8(%ebp)
  802388:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80238f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802393:	74 06                	je     80239b <strtol+0x58>
  802395:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802399:	75 20                	jne    8023bb <strtol+0x78>
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	8a 00                	mov    (%eax),%al
  8023a0:	3c 30                	cmp    $0x30,%al
  8023a2:	75 17                	jne    8023bb <strtol+0x78>
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	40                   	inc    %eax
  8023a8:	8a 00                	mov    (%eax),%al
  8023aa:	3c 78                	cmp    $0x78,%al
  8023ac:	75 0d                	jne    8023bb <strtol+0x78>
		s += 2, base = 16;
  8023ae:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8023b2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8023b9:	eb 28                	jmp    8023e3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8023bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023bf:	75 15                	jne    8023d6 <strtol+0x93>
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	8a 00                	mov    (%eax),%al
  8023c6:	3c 30                	cmp    $0x30,%al
  8023c8:	75 0c                	jne    8023d6 <strtol+0x93>
		s++, base = 8;
  8023ca:	ff 45 08             	incl   0x8(%ebp)
  8023cd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8023d4:	eb 0d                	jmp    8023e3 <strtol+0xa0>
	else if (base == 0)
  8023d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023da:	75 07                	jne    8023e3 <strtol+0xa0>
		base = 10;
  8023dc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8a 00                	mov    (%eax),%al
  8023e8:	3c 2f                	cmp    $0x2f,%al
  8023ea:	7e 19                	jle    802405 <strtol+0xc2>
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	8a 00                	mov    (%eax),%al
  8023f1:	3c 39                	cmp    $0x39,%al
  8023f3:	7f 10                	jg     802405 <strtol+0xc2>
			dig = *s - '0';
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	8a 00                	mov    (%eax),%al
  8023fa:	0f be c0             	movsbl %al,%eax
  8023fd:	83 e8 30             	sub    $0x30,%eax
  802400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802403:	eb 42                	jmp    802447 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	8a 00                	mov    (%eax),%al
  80240a:	3c 60                	cmp    $0x60,%al
  80240c:	7e 19                	jle    802427 <strtol+0xe4>
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	8a 00                	mov    (%eax),%al
  802413:	3c 7a                	cmp    $0x7a,%al
  802415:	7f 10                	jg     802427 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	8a 00                	mov    (%eax),%al
  80241c:	0f be c0             	movsbl %al,%eax
  80241f:	83 e8 57             	sub    $0x57,%eax
  802422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802425:	eb 20                	jmp    802447 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	8a 00                	mov    (%eax),%al
  80242c:	3c 40                	cmp    $0x40,%al
  80242e:	7e 39                	jle    802469 <strtol+0x126>
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8a 00                	mov    (%eax),%al
  802435:	3c 5a                	cmp    $0x5a,%al
  802437:	7f 30                	jg     802469 <strtol+0x126>
			dig = *s - 'A' + 10;
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	8a 00                	mov    (%eax),%al
  80243e:	0f be c0             	movsbl %al,%eax
  802441:	83 e8 37             	sub    $0x37,%eax
  802444:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80244d:	7d 19                	jge    802468 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80244f:	ff 45 08             	incl   0x8(%ebp)
  802452:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802455:	0f af 45 10          	imul   0x10(%ebp),%eax
  802459:	89 c2                	mov    %eax,%edx
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	01 d0                	add    %edx,%eax
  802460:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802463:	e9 7b ff ff ff       	jmp    8023e3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802468:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802469:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80246d:	74 08                	je     802477 <strtol+0x134>
		*endptr = (char *) s;
  80246f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802472:	8b 55 08             	mov    0x8(%ebp),%edx
  802475:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802477:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80247b:	74 07                	je     802484 <strtol+0x141>
  80247d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802480:	f7 d8                	neg    %eax
  802482:	eb 03                	jmp    802487 <strtol+0x144>
  802484:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <ltostr>:

void
ltostr(long value, char *str)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80248f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802496:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80249d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a1:	79 13                	jns    8024b6 <ltostr+0x2d>
	{
		neg = 1;
  8024a3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8024aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ad:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8024b0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8024b3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8024be:	99                   	cltd   
  8024bf:	f7 f9                	idiv   %ecx
  8024c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8024c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024c7:	8d 50 01             	lea    0x1(%eax),%edx
  8024ca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024cd:	89 c2                	mov    %eax,%edx
  8024cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d2:	01 d0                	add    %edx,%eax
  8024d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d7:	83 c2 30             	add    $0x30,%edx
  8024da:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8024dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024df:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8024e4:	f7 e9                	imul   %ecx
  8024e6:	c1 fa 02             	sar    $0x2,%edx
  8024e9:	89 c8                	mov    %ecx,%eax
  8024eb:	c1 f8 1f             	sar    $0x1f,%eax
  8024ee:	29 c2                	sub    %eax,%edx
  8024f0:	89 d0                	mov    %edx,%eax
  8024f2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8024f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f9:	75 bb                	jne    8024b6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8024fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802502:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802505:	48                   	dec    %eax
  802506:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802509:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80250d:	74 3d                	je     80254c <ltostr+0xc3>
		start = 1 ;
  80250f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802516:	eb 34                	jmp    80254c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802518:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251e:	01 d0                	add    %edx,%eax
  802520:	8a 00                	mov    (%eax),%al
  802522:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252b:	01 c2                	add    %eax,%edx
  80252d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802530:	8b 45 0c             	mov    0xc(%ebp),%eax
  802533:	01 c8                	add    %ecx,%eax
  802535:	8a 00                	mov    (%eax),%al
  802537:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802539:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80253c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253f:	01 c2                	add    %eax,%edx
  802541:	8a 45 eb             	mov    -0x15(%ebp),%al
  802544:	88 02                	mov    %al,(%edx)
		start++ ;
  802546:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802549:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802552:	7c c4                	jl     802518 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802554:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255a:	01 d0                	add    %edx,%eax
  80255c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80255f:	90                   	nop
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802568:	ff 75 08             	pushl  0x8(%ebp)
  80256b:	e8 c4 f9 ff ff       	call   801f34 <strlen>
  802570:	83 c4 04             	add    $0x4,%esp
  802573:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802576:	ff 75 0c             	pushl  0xc(%ebp)
  802579:	e8 b6 f9 ff ff       	call   801f34 <strlen>
  80257e:	83 c4 04             	add    $0x4,%esp
  802581:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802584:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80258b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802592:	eb 17                	jmp    8025ab <strcconcat+0x49>
		final[s] = str1[s] ;
  802594:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802597:	8b 45 10             	mov    0x10(%ebp),%eax
  80259a:	01 c2                	add    %eax,%edx
  80259c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	01 c8                	add    %ecx,%eax
  8025a4:	8a 00                	mov    (%eax),%al
  8025a6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8025a8:	ff 45 fc             	incl   -0x4(%ebp)
  8025ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025b1:	7c e1                	jl     802594 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8025b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8025ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8025c1:	eb 1f                	jmp    8025e2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8025c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c6:	8d 50 01             	lea    0x1(%eax),%edx
  8025c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8025cc:	89 c2                	mov    %eax,%edx
  8025ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d1:	01 c2                	add    %eax,%edx
  8025d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8025d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d9:	01 c8                	add    %ecx,%eax
  8025db:	8a 00                	mov    (%eax),%al
  8025dd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8025df:	ff 45 f8             	incl   -0x8(%ebp)
  8025e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025e8:	7c d9                	jl     8025c3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8025ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f0:	01 d0                	add    %edx,%eax
  8025f2:	c6 00 00             	movb   $0x0,(%eax)
}
  8025f5:	90                   	nop
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8025fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8025fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802604:	8b 45 14             	mov    0x14(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802610:	8b 45 10             	mov    0x10(%ebp),%eax
  802613:	01 d0                	add    %edx,%eax
  802615:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80261b:	eb 0c                	jmp    802629 <strsplit+0x31>
			*string++ = 0;
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	8d 50 01             	lea    0x1(%eax),%edx
  802623:	89 55 08             	mov    %edx,0x8(%ebp)
  802626:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	8a 00                	mov    (%eax),%al
  80262e:	84 c0                	test   %al,%al
  802630:	74 18                	je     80264a <strsplit+0x52>
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	8a 00                	mov    (%eax),%al
  802637:	0f be c0             	movsbl %al,%eax
  80263a:	50                   	push   %eax
  80263b:	ff 75 0c             	pushl  0xc(%ebp)
  80263e:	e8 83 fa ff ff       	call   8020c6 <strchr>
  802643:	83 c4 08             	add    $0x8,%esp
  802646:	85 c0                	test   %eax,%eax
  802648:	75 d3                	jne    80261d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	8a 00                	mov    (%eax),%al
  80264f:	84 c0                	test   %al,%al
  802651:	74 5a                	je     8026ad <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802653:	8b 45 14             	mov    0x14(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	83 f8 0f             	cmp    $0xf,%eax
  80265b:	75 07                	jne    802664 <strsplit+0x6c>
		{
			return 0;
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	eb 66                	jmp    8026ca <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802664:	8b 45 14             	mov    0x14(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	8d 48 01             	lea    0x1(%eax),%ecx
  80266c:	8b 55 14             	mov    0x14(%ebp),%edx
  80266f:	89 0a                	mov    %ecx,(%edx)
  802671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802678:	8b 45 10             	mov    0x10(%ebp),%eax
  80267b:	01 c2                	add    %eax,%edx
  80267d:	8b 45 08             	mov    0x8(%ebp),%eax
  802680:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802682:	eb 03                	jmp    802687 <strsplit+0x8f>
			string++;
  802684:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	8a 00                	mov    (%eax),%al
  80268c:	84 c0                	test   %al,%al
  80268e:	74 8b                	je     80261b <strsplit+0x23>
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	8a 00                	mov    (%eax),%al
  802695:	0f be c0             	movsbl %al,%eax
  802698:	50                   	push   %eax
  802699:	ff 75 0c             	pushl  0xc(%ebp)
  80269c:	e8 25 fa ff ff       	call   8020c6 <strchr>
  8026a1:	83 c4 08             	add    $0x8,%esp
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 dc                	je     802684 <strsplit+0x8c>
			string++;
	}
  8026a8:	e9 6e ff ff ff       	jmp    80261b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8026ad:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8026ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8026bd:	01 d0                	add    %edx,%eax
  8026bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8026c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8026d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8026df:	eb 4a                	jmp    80272b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8026e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	01 c2                	add    %eax,%edx
  8026e9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ef:	01 c8                	add    %ecx,%eax
  8026f1:	8a 00                	mov    (%eax),%al
  8026f3:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8026f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fb:	01 d0                	add    %edx,%eax
  8026fd:	8a 00                	mov    (%eax),%al
  8026ff:	3c 40                	cmp    $0x40,%al
  802701:	7e 25                	jle    802728 <str2lower+0x5c>
  802703:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802706:	8b 45 0c             	mov    0xc(%ebp),%eax
  802709:	01 d0                	add    %edx,%eax
  80270b:	8a 00                	mov    (%eax),%al
  80270d:	3c 5a                	cmp    $0x5a,%al
  80270f:	7f 17                	jg     802728 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802711:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	01 d0                	add    %edx,%eax
  802719:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80271c:	8b 55 08             	mov    0x8(%ebp),%edx
  80271f:	01 ca                	add    %ecx,%edx
  802721:	8a 12                	mov    (%edx),%dl
  802723:	83 c2 20             	add    $0x20,%edx
  802726:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802728:	ff 45 fc             	incl   -0x4(%ebp)
  80272b:	ff 75 0c             	pushl  0xc(%ebp)
  80272e:	e8 01 f8 ff ff       	call   801f34 <strlen>
  802733:	83 c4 04             	add    $0x4,%esp
  802736:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802739:	7f a6                	jg     8026e1 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80273b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80273e:	c9                   	leave  
  80273f:	c3                   	ret    

00802740 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802746:	a1 08 50 80 00       	mov    0x805008,%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 42                	je     802791 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80274f:	83 ec 08             	sub    $0x8,%esp
  802752:	68 00 00 00 82       	push   $0x82000000
  802757:	68 00 00 00 80       	push   $0x80000000
  80275c:	e8 00 08 00 00       	call   802f61 <initialize_dynamic_allocator>
  802761:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802764:	e8 e7 05 00 00       	call   802d50 <sys_get_uheap_strategy>
  802769:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80276e:	a1 20 52 80 00       	mov    0x805220,%eax
  802773:	05 00 10 00 00       	add    $0x1000,%eax
  802778:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  80277d:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  802782:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  802787:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80278e:	00 00 00 
	}
}
  802791:	90                   	nop
  802792:	c9                   	leave  
  802793:	c3                   	ret    

00802794 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027a8:	83 ec 08             	sub    $0x8,%esp
  8027ab:	68 06 04 00 00       	push   $0x406
  8027b0:	50                   	push   %eax
  8027b1:	e8 e4 01 00 00       	call   80299a <__sys_allocate_page>
  8027b6:	83 c4 10             	add    $0x10,%esp
  8027b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8027bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c0:	79 14                	jns    8027d6 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8027c2:	83 ec 04             	sub    $0x4,%esp
  8027c5:	68 68 4b 80 00       	push   $0x804b68
  8027ca:	6a 1f                	push   $0x1f
  8027cc:	68 a4 4b 80 00       	push   $0x804ba4
  8027d1:	e8 b7 ed ff ff       	call   80158d <_panic>
	return 0;
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027f1:	83 ec 0c             	sub    $0xc,%esp
  8027f4:	50                   	push   %eax
  8027f5:	e8 e7 01 00 00       	call   8029e1 <__sys_unmap_frame>
  8027fa:	83 c4 10             	add    $0x10,%esp
  8027fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802800:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802804:	79 14                	jns    80281a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	68 b0 4b 80 00       	push   $0x804bb0
  80280e:	6a 2a                	push   $0x2a
  802810:	68 a4 4b 80 00       	push   $0x804ba4
  802815:	e8 73 ed ff ff       	call   80158d <_panic>
}
  80281a:	90                   	nop
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802823:	e8 18 ff ff ff       	call   802740 <uheap_init>
	if (size == 0) return NULL ;
  802828:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80282c:	75 07                	jne    802835 <malloc+0x18>
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
  802833:	eb 14                	jmp    802849 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802835:	83 ec 04             	sub    $0x4,%esp
  802838:	68 f0 4b 80 00       	push   $0x804bf0
  80283d:	6a 3e                	push   $0x3e
  80283f:	68 a4 4b 80 00       	push   $0x804ba4
  802844:	e8 44 ed ff ff       	call   80158d <_panic>
}
  802849:	c9                   	leave  
  80284a:	c3                   	ret    

0080284b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80284b:	55                   	push   %ebp
  80284c:	89 e5                	mov    %esp,%ebp
  80284e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802851:	83 ec 04             	sub    $0x4,%esp
  802854:	68 18 4c 80 00       	push   $0x804c18
  802859:	6a 49                	push   $0x49
  80285b:	68 a4 4b 80 00       	push   $0x804ba4
  802860:	e8 28 ed ff ff       	call   80158d <_panic>

00802865 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	83 ec 18             	sub    $0x18,%esp
  80286b:	8b 45 10             	mov    0x10(%ebp),%eax
  80286e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802871:	e8 ca fe ff ff       	call   802740 <uheap_init>
	if (size == 0) return NULL ;
  802876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80287a:	75 07                	jne    802883 <smalloc+0x1e>
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
  802881:	eb 14                	jmp    802897 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	68 3c 4c 80 00       	push   $0x804c3c
  80288b:	6a 5a                	push   $0x5a
  80288d:	68 a4 4b 80 00       	push   $0x804ba4
  802892:	e8 f6 ec ff ff       	call   80158d <_panic>
}
  802897:	c9                   	leave  
  802898:	c3                   	ret    

00802899 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
  80289c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80289f:	e8 9c fe ff ff       	call   802740 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8028a4:	83 ec 04             	sub    $0x4,%esp
  8028a7:	68 64 4c 80 00       	push   $0x804c64
  8028ac:	6a 6a                	push   $0x6a
  8028ae:	68 a4 4b 80 00       	push   $0x804ba4
  8028b3:	e8 d5 ec ff ff       	call   80158d <_panic>

008028b8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028b8:	55                   	push   %ebp
  8028b9:	89 e5                	mov    %esp,%ebp
  8028bb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028be:	e8 7d fe ff ff       	call   802740 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	68 88 4c 80 00       	push   $0x804c88
  8028cb:	68 88 00 00 00       	push   $0x88
  8028d0:	68 a4 4b 80 00       	push   $0x804ba4
  8028d5:	e8 b3 ec ff ff       	call   80158d <_panic>

008028da <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 b0 4c 80 00       	push   $0x804cb0
  8028e8:	68 9b 00 00 00       	push   $0x9b
  8028ed:	68 a4 4b 80 00       	push   $0x804ba4
  8028f2:	e8 96 ec ff ff       	call   80158d <_panic>

008028f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	57                   	push   %edi
  8028fb:	56                   	push   %esi
  8028fc:	53                   	push   %ebx
  8028fd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	8b 55 0c             	mov    0xc(%ebp),%edx
  802906:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802909:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80290c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80290f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802912:	cd 30                	int    $0x30
  802914:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802917:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80291a:	83 c4 10             	add    $0x10,%esp
  80291d:	5b                   	pop    %ebx
  80291e:	5e                   	pop    %esi
  80291f:	5f                   	pop    %edi
  802920:	5d                   	pop    %ebp
  802921:	c3                   	ret    

00802922 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	83 ec 04             	sub    $0x4,%esp
  802928:	8b 45 10             	mov    0x10(%ebp),%eax
  80292b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80292e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802931:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	6a 00                	push   $0x0
  80293a:	51                   	push   %ecx
  80293b:	52                   	push   %edx
  80293c:	ff 75 0c             	pushl  0xc(%ebp)
  80293f:	50                   	push   %eax
  802940:	6a 00                	push   $0x0
  802942:	e8 b0 ff ff ff       	call   8028f7 <syscall>
  802947:	83 c4 18             	add    $0x18,%esp
}
  80294a:	90                   	nop
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <sys_cgetc>:

int
sys_cgetc(void)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802950:	6a 00                	push   $0x0
  802952:	6a 00                	push   $0x0
  802954:	6a 00                	push   $0x0
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 02                	push   $0x2
  80295c:	e8 96 ff ff ff       	call   8028f7 <syscall>
  802961:	83 c4 18             	add    $0x18,%esp
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	6a 03                	push   $0x3
  802975:	e8 7d ff ff ff       	call   8028f7 <syscall>
  80297a:	83 c4 18             	add    $0x18,%esp
}
  80297d:	90                   	nop
  80297e:	c9                   	leave  
  80297f:	c3                   	ret    

00802980 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	6a 04                	push   $0x4
  80298f:	e8 63 ff ff ff       	call   8028f7 <syscall>
  802994:	83 c4 18             	add    $0x18,%esp
}
  802997:	90                   	nop
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80299d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	52                   	push   %edx
  8029aa:	50                   	push   %eax
  8029ab:	6a 08                	push   $0x8
  8029ad:	e8 45 ff ff ff       	call   8028f7 <syscall>
  8029b2:	83 c4 18             	add    $0x18,%esp
}
  8029b5:	c9                   	leave  
  8029b6:	c3                   	ret    

008029b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8029b7:	55                   	push   %ebp
  8029b8:	89 e5                	mov    %esp,%ebp
  8029ba:	56                   	push   %esi
  8029bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8029bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8029bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	56                   	push   %esi
  8029cc:	53                   	push   %ebx
  8029cd:	51                   	push   %ecx
  8029ce:	52                   	push   %edx
  8029cf:	50                   	push   %eax
  8029d0:	6a 09                	push   $0x9
  8029d2:	e8 20 ff ff ff       	call   8028f7 <syscall>
  8029d7:	83 c4 18             	add    $0x18,%esp
}
  8029da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029dd:	5b                   	pop    %ebx
  8029de:	5e                   	pop    %esi
  8029df:	5d                   	pop    %ebp
  8029e0:	c3                   	ret    

008029e1 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8029e4:	6a 00                	push   $0x0
  8029e6:	6a 00                	push   $0x0
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	ff 75 08             	pushl  0x8(%ebp)
  8029ef:	6a 0a                	push   $0xa
  8029f1:	e8 01 ff ff ff       	call   8028f7 <syscall>
  8029f6:	83 c4 18             	add    $0x18,%esp
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	ff 75 0c             	pushl  0xc(%ebp)
  802a07:	ff 75 08             	pushl  0x8(%ebp)
  802a0a:	6a 0b                	push   $0xb
  802a0c:	e8 e6 fe ff ff       	call   8028f7 <syscall>
  802a11:	83 c4 18             	add    $0x18,%esp
}
  802a14:	c9                   	leave  
  802a15:	c3                   	ret    

00802a16 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a16:	55                   	push   %ebp
  802a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 0c                	push   $0xc
  802a25:	e8 cd fe ff ff       	call   8028f7 <syscall>
  802a2a:	83 c4 18             	add    $0x18,%esp
}
  802a2d:	c9                   	leave  
  802a2e:	c3                   	ret    

00802a2f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a2f:	55                   	push   %ebp
  802a30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a32:	6a 00                	push   $0x0
  802a34:	6a 00                	push   $0x0
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 0d                	push   $0xd
  802a3e:	e8 b4 fe ff ff       	call   8028f7 <syscall>
  802a43:	83 c4 18             	add    $0x18,%esp
}
  802a46:	c9                   	leave  
  802a47:	c3                   	ret    

00802a48 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	6a 0e                	push   $0xe
  802a57:	e8 9b fe ff ff       	call   8028f7 <syscall>
  802a5c:	83 c4 18             	add    $0x18,%esp
}
  802a5f:	c9                   	leave  
  802a60:	c3                   	ret    

00802a61 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802a64:	6a 00                	push   $0x0
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 0f                	push   $0xf
  802a70:	e8 82 fe ff ff       	call   8028f7 <syscall>
  802a75:	83 c4 18             	add    $0x18,%esp
}
  802a78:	c9                   	leave  
  802a79:	c3                   	ret    

00802a7a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	6a 00                	push   $0x0
  802a83:	6a 00                	push   $0x0
  802a85:	ff 75 08             	pushl  0x8(%ebp)
  802a88:	6a 10                	push   $0x10
  802a8a:	e8 68 fe ff ff       	call   8028f7 <syscall>
  802a8f:	83 c4 18             	add    $0x18,%esp
}
  802a92:	c9                   	leave  
  802a93:	c3                   	ret    

00802a94 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802a94:	55                   	push   %ebp
  802a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 11                	push   $0x11
  802aa3:	e8 4f fe ff ff       	call   8028f7 <syscall>
  802aa8:	83 c4 18             	add    $0x18,%esp
}
  802aab:	90                   	nop
  802aac:	c9                   	leave  
  802aad:	c3                   	ret    

00802aae <sys_cputc>:

void
sys_cputc(const char c)
{
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
  802ab1:	83 ec 04             	sub    $0x4,%esp
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802aba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	50                   	push   %eax
  802ac7:	6a 01                	push   $0x1
  802ac9:	e8 29 fe ff ff       	call   8028f7 <syscall>
  802ace:	83 c4 18             	add    $0x18,%esp
}
  802ad1:	90                   	nop
  802ad2:	c9                   	leave  
  802ad3:	c3                   	ret    

00802ad4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ad4:	55                   	push   %ebp
  802ad5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	6a 00                	push   $0x0
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 14                	push   $0x14
  802ae3:	e8 0f fe ff ff       	call   8028f7 <syscall>
  802ae8:	83 c4 18             	add    $0x18,%esp
}
  802aeb:	90                   	nop
  802aec:	c9                   	leave  
  802aed:	c3                   	ret    

00802aee <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802aee:	55                   	push   %ebp
  802aef:	89 e5                	mov    %esp,%ebp
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	8b 45 10             	mov    0x10(%ebp),%eax
  802af7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802afa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802afd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	6a 00                	push   $0x0
  802b06:	51                   	push   %ecx
  802b07:	52                   	push   %edx
  802b08:	ff 75 0c             	pushl  0xc(%ebp)
  802b0b:	50                   	push   %eax
  802b0c:	6a 15                	push   $0x15
  802b0e:	e8 e4 fd ff ff       	call   8028f7 <syscall>
  802b13:	83 c4 18             	add    $0x18,%esp
}
  802b16:	c9                   	leave  
  802b17:	c3                   	ret    

00802b18 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802b18:	55                   	push   %ebp
  802b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	6a 00                	push   $0x0
  802b23:	6a 00                	push   $0x0
  802b25:	6a 00                	push   $0x0
  802b27:	52                   	push   %edx
  802b28:	50                   	push   %eax
  802b29:	6a 16                	push   $0x16
  802b2b:	e8 c7 fd ff ff       	call   8028f7 <syscall>
  802b30:	83 c4 18             	add    $0x18,%esp
}
  802b33:	c9                   	leave  
  802b34:	c3                   	ret    

00802b35 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802b35:	55                   	push   %ebp
  802b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	51                   	push   %ecx
  802b46:	52                   	push   %edx
  802b47:	50                   	push   %eax
  802b48:	6a 17                	push   $0x17
  802b4a:	e8 a8 fd ff ff       	call   8028f7 <syscall>
  802b4f:	83 c4 18             	add    $0x18,%esp
}
  802b52:	c9                   	leave  
  802b53:	c3                   	ret    

00802b54 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802b54:	55                   	push   %ebp
  802b55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 00                	push   $0x0
  802b63:	52                   	push   %edx
  802b64:	50                   	push   %eax
  802b65:	6a 18                	push   $0x18
  802b67:	e8 8b fd ff ff       	call   8028f7 <syscall>
  802b6c:	83 c4 18             	add    $0x18,%esp
}
  802b6f:	c9                   	leave  
  802b70:	c3                   	ret    

00802b71 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b71:	55                   	push   %ebp
  802b72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	6a 00                	push   $0x0
  802b79:	ff 75 14             	pushl  0x14(%ebp)
  802b7c:	ff 75 10             	pushl  0x10(%ebp)
  802b7f:	ff 75 0c             	pushl  0xc(%ebp)
  802b82:	50                   	push   %eax
  802b83:	6a 19                	push   $0x19
  802b85:	e8 6d fd ff ff       	call   8028f7 <syscall>
  802b8a:	83 c4 18             	add    $0x18,%esp
}
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    

00802b8f <sys_run_env>:

void sys_run_env(int32 envId)
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	6a 00                	push   $0x0
  802b97:	6a 00                	push   $0x0
  802b99:	6a 00                	push   $0x0
  802b9b:	6a 00                	push   $0x0
  802b9d:	50                   	push   %eax
  802b9e:	6a 1a                	push   $0x1a
  802ba0:	e8 52 fd ff ff       	call   8028f7 <syscall>
  802ba5:	83 c4 18             	add    $0x18,%esp
}
  802ba8:	90                   	nop
  802ba9:	c9                   	leave  
  802baa:	c3                   	ret    

00802bab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802bab:	55                   	push   %ebp
  802bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 00                	push   $0x0
  802bb5:	6a 00                	push   $0x0
  802bb7:	6a 00                	push   $0x0
  802bb9:	50                   	push   %eax
  802bba:	6a 1b                	push   $0x1b
  802bbc:	e8 36 fd ff ff       	call   8028f7 <syscall>
  802bc1:	83 c4 18             	add    $0x18,%esp
}
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802bc9:	6a 00                	push   $0x0
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 00                	push   $0x0
  802bd1:	6a 00                	push   $0x0
  802bd3:	6a 05                	push   $0x5
  802bd5:	e8 1d fd ff ff       	call   8028f7 <syscall>
  802bda:	83 c4 18             	add    $0x18,%esp
}
  802bdd:	c9                   	leave  
  802bde:	c3                   	ret    

00802bdf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802bdf:	55                   	push   %ebp
  802be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	6a 00                	push   $0x0
  802be8:	6a 00                	push   $0x0
  802bea:	6a 00                	push   $0x0
  802bec:	6a 06                	push   $0x6
  802bee:	e8 04 fd ff ff       	call   8028f7 <syscall>
  802bf3:	83 c4 18             	add    $0x18,%esp
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 00                	push   $0x0
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 07                	push   $0x7
  802c07:	e8 eb fc ff ff       	call   8028f7 <syscall>
  802c0c:	83 c4 18             	add    $0x18,%esp
}
  802c0f:	c9                   	leave  
  802c10:	c3                   	ret    

00802c11 <sys_exit_env>:


void sys_exit_env(void)
{
  802c11:	55                   	push   %ebp
  802c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 1c                	push   $0x1c
  802c20:	e8 d2 fc ff ff       	call   8028f7 <syscall>
  802c25:	83 c4 18             	add    $0x18,%esp
}
  802c28:	90                   	nop
  802c29:	c9                   	leave  
  802c2a:	c3                   	ret    

00802c2b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802c2b:	55                   	push   %ebp
  802c2c:	89 e5                	mov    %esp,%ebp
  802c2e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c31:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c34:	8d 50 04             	lea    0x4(%eax),%edx
  802c37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c3a:	6a 00                	push   $0x0
  802c3c:	6a 00                	push   $0x0
  802c3e:	6a 00                	push   $0x0
  802c40:	52                   	push   %edx
  802c41:	50                   	push   %eax
  802c42:	6a 1d                	push   $0x1d
  802c44:	e8 ae fc ff ff       	call   8028f7 <syscall>
  802c49:	83 c4 18             	add    $0x18,%esp
	return result;
  802c4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c55:	89 01                	mov    %eax,(%ecx)
  802c57:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	c9                   	leave  
  802c5e:	c2 04 00             	ret    $0x4

00802c61 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c61:	55                   	push   %ebp
  802c62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	ff 75 10             	pushl  0x10(%ebp)
  802c6b:	ff 75 0c             	pushl  0xc(%ebp)
  802c6e:	ff 75 08             	pushl  0x8(%ebp)
  802c71:	6a 13                	push   $0x13
  802c73:	e8 7f fc ff ff       	call   8028f7 <syscall>
  802c78:	83 c4 18             	add    $0x18,%esp
	return ;
  802c7b:	90                   	nop
}
  802c7c:	c9                   	leave  
  802c7d:	c3                   	ret    

00802c7e <sys_rcr2>:
uint32 sys_rcr2()
{
  802c7e:	55                   	push   %ebp
  802c7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c81:	6a 00                	push   $0x0
  802c83:	6a 00                	push   $0x0
  802c85:	6a 00                	push   $0x0
  802c87:	6a 00                	push   $0x0
  802c89:	6a 00                	push   $0x0
  802c8b:	6a 1e                	push   $0x1e
  802c8d:	e8 65 fc ff ff       	call   8028f7 <syscall>
  802c92:	83 c4 18             	add    $0x18,%esp
}
  802c95:	c9                   	leave  
  802c96:	c3                   	ret    

00802c97 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802c97:	55                   	push   %ebp
  802c98:	89 e5                	mov    %esp,%ebp
  802c9a:	83 ec 04             	sub    $0x4,%esp
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ca3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ca7:	6a 00                	push   $0x0
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	50                   	push   %eax
  802cb0:	6a 1f                	push   $0x1f
  802cb2:	e8 40 fc ff ff       	call   8028f7 <syscall>
  802cb7:	83 c4 18             	add    $0x18,%esp
	return ;
  802cba:	90                   	nop
}
  802cbb:	c9                   	leave  
  802cbc:	c3                   	ret    

00802cbd <rsttst>:
void rsttst()
{
  802cbd:	55                   	push   %ebp
  802cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802cc0:	6a 00                	push   $0x0
  802cc2:	6a 00                	push   $0x0
  802cc4:	6a 00                	push   $0x0
  802cc6:	6a 00                	push   $0x0
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 21                	push   $0x21
  802ccc:	e8 26 fc ff ff       	call   8028f7 <syscall>
  802cd1:	83 c4 18             	add    $0x18,%esp
	return ;
  802cd4:	90                   	nop
}
  802cd5:	c9                   	leave  
  802cd6:	c3                   	ret    

00802cd7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802cd7:	55                   	push   %ebp
  802cd8:	89 e5                	mov    %esp,%ebp
  802cda:	83 ec 04             	sub    $0x4,%esp
  802cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  802ce0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802ce3:	8b 55 18             	mov    0x18(%ebp),%edx
  802ce6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802cea:	52                   	push   %edx
  802ceb:	50                   	push   %eax
  802cec:	ff 75 10             	pushl  0x10(%ebp)
  802cef:	ff 75 0c             	pushl  0xc(%ebp)
  802cf2:	ff 75 08             	pushl  0x8(%ebp)
  802cf5:	6a 20                	push   $0x20
  802cf7:	e8 fb fb ff ff       	call   8028f7 <syscall>
  802cfc:	83 c4 18             	add    $0x18,%esp
	return ;
  802cff:	90                   	nop
}
  802d00:	c9                   	leave  
  802d01:	c3                   	ret    

00802d02 <chktst>:
void chktst(uint32 n)
{
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d05:	6a 00                	push   $0x0
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	ff 75 08             	pushl  0x8(%ebp)
  802d10:	6a 22                	push   $0x22
  802d12:	e8 e0 fb ff ff       	call   8028f7 <syscall>
  802d17:	83 c4 18             	add    $0x18,%esp
	return ;
  802d1a:	90                   	nop
}
  802d1b:	c9                   	leave  
  802d1c:	c3                   	ret    

00802d1d <inctst>:

void inctst()
{
  802d1d:	55                   	push   %ebp
  802d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	6a 00                	push   $0x0
  802d26:	6a 00                	push   $0x0
  802d28:	6a 00                	push   $0x0
  802d2a:	6a 23                	push   $0x23
  802d2c:	e8 c6 fb ff ff       	call   8028f7 <syscall>
  802d31:	83 c4 18             	add    $0x18,%esp
	return ;
  802d34:	90                   	nop
}
  802d35:	c9                   	leave  
  802d36:	c3                   	ret    

00802d37 <gettst>:
uint32 gettst()
{
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 00                	push   $0x0
  802d3e:	6a 00                	push   $0x0
  802d40:	6a 00                	push   $0x0
  802d42:	6a 00                	push   $0x0
  802d44:	6a 24                	push   $0x24
  802d46:	e8 ac fb ff ff       	call   8028f7 <syscall>
  802d4b:	83 c4 18             	add    $0x18,%esp
}
  802d4e:	c9                   	leave  
  802d4f:	c3                   	ret    

00802d50 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 25                	push   $0x25
  802d5f:	e8 93 fb ff ff       	call   8028f7 <syscall>
  802d64:	83 c4 18             	add    $0x18,%esp
  802d67:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802d6c:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802d71:	c9                   	leave  
  802d72:	c3                   	ret    

00802d73 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d73:	55                   	push   %ebp
  802d74:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d7e:	6a 00                	push   $0x0
  802d80:	6a 00                	push   $0x0
  802d82:	6a 00                	push   $0x0
  802d84:	6a 00                	push   $0x0
  802d86:	ff 75 08             	pushl  0x8(%ebp)
  802d89:	6a 26                	push   $0x26
  802d8b:	e8 67 fb ff ff       	call   8028f7 <syscall>
  802d90:	83 c4 18             	add    $0x18,%esp
	return ;
  802d93:	90                   	nop
}
  802d94:	c9                   	leave  
  802d95:	c3                   	ret    

00802d96 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d96:	55                   	push   %ebp
  802d97:	89 e5                	mov    %esp,%ebp
  802d99:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d9a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	6a 00                	push   $0x0
  802da8:	53                   	push   %ebx
  802da9:	51                   	push   %ecx
  802daa:	52                   	push   %edx
  802dab:	50                   	push   %eax
  802dac:	6a 27                	push   $0x27
  802dae:	e8 44 fb ff ff       	call   8028f7 <syscall>
  802db3:	83 c4 18             	add    $0x18,%esp
}
  802db6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802db9:	c9                   	leave  
  802dba:	c3                   	ret    

00802dbb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802dbb:	55                   	push   %ebp
  802dbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 00                	push   $0x0
  802dc8:	6a 00                	push   $0x0
  802dca:	52                   	push   %edx
  802dcb:	50                   	push   %eax
  802dcc:	6a 28                	push   $0x28
  802dce:	e8 24 fb ff ff       	call   8028f7 <syscall>
  802dd3:	83 c4 18             	add    $0x18,%esp
}
  802dd6:	c9                   	leave  
  802dd7:	c3                   	ret    

00802dd8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802dd8:	55                   	push   %ebp
  802dd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802ddb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	6a 00                	push   $0x0
  802de6:	51                   	push   %ecx
  802de7:	ff 75 10             	pushl  0x10(%ebp)
  802dea:	52                   	push   %edx
  802deb:	50                   	push   %eax
  802dec:	6a 29                	push   $0x29
  802dee:	e8 04 fb ff ff       	call   8028f7 <syscall>
  802df3:	83 c4 18             	add    $0x18,%esp
}
  802df6:	c9                   	leave  
  802df7:	c3                   	ret    

00802df8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802df8:	55                   	push   %ebp
  802df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802dfb:	6a 00                	push   $0x0
  802dfd:	6a 00                	push   $0x0
  802dff:	ff 75 10             	pushl  0x10(%ebp)
  802e02:	ff 75 0c             	pushl  0xc(%ebp)
  802e05:	ff 75 08             	pushl  0x8(%ebp)
  802e08:	6a 12                	push   $0x12
  802e0a:	e8 e8 fa ff ff       	call   8028f7 <syscall>
  802e0f:	83 c4 18             	add    $0x18,%esp
	return ;
  802e12:	90                   	nop
}
  802e13:	c9                   	leave  
  802e14:	c3                   	ret    

00802e15 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802e15:	55                   	push   %ebp
  802e16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	6a 00                	push   $0x0
  802e20:	6a 00                	push   $0x0
  802e22:	6a 00                	push   $0x0
  802e24:	52                   	push   %edx
  802e25:	50                   	push   %eax
  802e26:	6a 2a                	push   $0x2a
  802e28:	e8 ca fa ff ff       	call   8028f7 <syscall>
  802e2d:	83 c4 18             	add    $0x18,%esp
	return;
  802e30:	90                   	nop
}
  802e31:	c9                   	leave  
  802e32:	c3                   	ret    

00802e33 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802e33:	55                   	push   %ebp
  802e34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802e36:	6a 00                	push   $0x0
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 00                	push   $0x0
  802e3c:	6a 00                	push   $0x0
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 2b                	push   $0x2b
  802e42:	e8 b0 fa ff ff       	call   8028f7 <syscall>
  802e47:	83 c4 18             	add    $0x18,%esp
}
  802e4a:	c9                   	leave  
  802e4b:	c3                   	ret    

00802e4c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e4c:	55                   	push   %ebp
  802e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802e4f:	6a 00                	push   $0x0
  802e51:	6a 00                	push   $0x0
  802e53:	6a 00                	push   $0x0
  802e55:	ff 75 0c             	pushl  0xc(%ebp)
  802e58:	ff 75 08             	pushl  0x8(%ebp)
  802e5b:	6a 2d                	push   $0x2d
  802e5d:	e8 95 fa ff ff       	call   8028f7 <syscall>
  802e62:	83 c4 18             	add    $0x18,%esp
	return;
  802e65:	90                   	nop
}
  802e66:	c9                   	leave  
  802e67:	c3                   	ret    

00802e68 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e68:	55                   	push   %ebp
  802e69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802e6b:	6a 00                	push   $0x0
  802e6d:	6a 00                	push   $0x0
  802e6f:	6a 00                	push   $0x0
  802e71:	ff 75 0c             	pushl  0xc(%ebp)
  802e74:	ff 75 08             	pushl  0x8(%ebp)
  802e77:	6a 2c                	push   $0x2c
  802e79:	e8 79 fa ff ff       	call   8028f7 <syscall>
  802e7e:	83 c4 18             	add    $0x18,%esp
	return ;
  802e81:	90                   	nop
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	68 d4 4c 80 00       	push   $0x804cd4
  802e92:	68 25 01 00 00       	push   $0x125
  802e97:	68 07 4d 80 00       	push   $0x804d07
  802e9c:	e8 ec e6 ff ff       	call   80158d <_panic>

00802ea1 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802ea1:	55                   	push   %ebp
  802ea2:	89 e5                	mov    %esp,%ebp
  802ea4:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802ea7:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802eae:	72 09                	jb     802eb9 <to_page_va+0x18>
  802eb0:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802eb7:	72 14                	jb     802ecd <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802eb9:	83 ec 04             	sub    $0x4,%esp
  802ebc:	68 18 4d 80 00       	push   $0x804d18
  802ec1:	6a 15                	push   $0x15
  802ec3:	68 43 4d 80 00       	push   $0x804d43
  802ec8:	e8 c0 e6 ff ff       	call   80158d <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	ba 40 52 80 00       	mov    $0x805240,%edx
  802ed5:	29 d0                	sub    %edx,%eax
  802ed7:	c1 f8 02             	sar    $0x2,%eax
  802eda:	89 c2                	mov    %eax,%edx
  802edc:	89 d0                	mov    %edx,%eax
  802ede:	c1 e0 02             	shl    $0x2,%eax
  802ee1:	01 d0                	add    %edx,%eax
  802ee3:	c1 e0 02             	shl    $0x2,%eax
  802ee6:	01 d0                	add    %edx,%eax
  802ee8:	c1 e0 02             	shl    $0x2,%eax
  802eeb:	01 d0                	add    %edx,%eax
  802eed:	89 c1                	mov    %eax,%ecx
  802eef:	c1 e1 08             	shl    $0x8,%ecx
  802ef2:	01 c8                	add    %ecx,%eax
  802ef4:	89 c1                	mov    %eax,%ecx
  802ef6:	c1 e1 10             	shl    $0x10,%ecx
  802ef9:	01 c8                	add    %ecx,%eax
  802efb:	01 c0                	add    %eax,%eax
  802efd:	01 d0                	add    %edx,%eax
  802eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	c1 e0 0c             	shl    $0xc,%eax
  802f08:	89 c2                	mov    %eax,%edx
  802f0a:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802f0f:	01 d0                	add    %edx,%eax
}
  802f11:	c9                   	leave  
  802f12:	c3                   	ret    

00802f13 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802f13:	55                   	push   %ebp
  802f14:	89 e5                	mov    %esp,%ebp
  802f16:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802f19:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f21:	29 c2                	sub    %eax,%edx
  802f23:	89 d0                	mov    %edx,%eax
  802f25:	c1 e8 0c             	shr    $0xc,%eax
  802f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802f2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2f:	78 09                	js     802f3a <to_page_info+0x27>
  802f31:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802f38:	7e 14                	jle    802f4e <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802f3a:	83 ec 04             	sub    $0x4,%esp
  802f3d:	68 5c 4d 80 00       	push   $0x804d5c
  802f42:	6a 22                	push   $0x22
  802f44:	68 43 4d 80 00       	push   $0x804d43
  802f49:	e8 3f e6 ff ff       	call   80158d <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f51:	89 d0                	mov    %edx,%eax
  802f53:	01 c0                	add    %eax,%eax
  802f55:	01 d0                	add    %edx,%eax
  802f57:	c1 e0 02             	shl    $0x2,%eax
  802f5a:	05 40 52 80 00       	add    $0x805240,%eax
}
  802f5f:	c9                   	leave  
  802f60:	c3                   	ret    

00802f61 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802f61:	55                   	push   %ebp
  802f62:	89 e5                	mov    %esp,%ebp
  802f64:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	05 00 00 00 02       	add    $0x2000000,%eax
  802f6f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f72:	73 16                	jae    802f8a <initialize_dynamic_allocator+0x29>
  802f74:	68 80 4d 80 00       	push   $0x804d80
  802f79:	68 a6 4d 80 00       	push   $0x804da6
  802f7e:	6a 34                	push   $0x34
  802f80:	68 43 4d 80 00       	push   $0x804d43
  802f85:	e8 03 e6 ff ff       	call   80158d <_panic>
		is_initialized = 1;
  802f8a:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802f91:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9f:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802fa4:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802fab:	00 00 00 
  802fae:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802fb5:	00 00 00 
  802fb8:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  802fbf:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc5:	2b 45 08             	sub    0x8(%ebp),%eax
  802fc8:	c1 e8 0c             	shr    $0xc,%eax
  802fcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802fce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802fd5:	e9 c8 00 00 00       	jmp    8030a2 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdd:	89 d0                	mov    %edx,%eax
  802fdf:	01 c0                	add    %eax,%eax
  802fe1:	01 d0                	add    %edx,%eax
  802fe3:	c1 e0 02             	shl    $0x2,%eax
  802fe6:	05 48 52 80 00       	add    $0x805248,%eax
  802feb:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff3:	89 d0                	mov    %edx,%eax
  802ff5:	01 c0                	add    %eax,%eax
  802ff7:	01 d0                	add    %edx,%eax
  802ff9:	c1 e0 02             	shl    $0x2,%eax
  802ffc:	05 4a 52 80 00       	add    $0x80524a,%eax
  803001:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803006:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  80300c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80300f:	89 c8                	mov    %ecx,%eax
  803011:	01 c0                	add    %eax,%eax
  803013:	01 c8                	add    %ecx,%eax
  803015:	c1 e0 02             	shl    $0x2,%eax
  803018:	05 44 52 80 00       	add    $0x805244,%eax
  80301d:	89 10                	mov    %edx,(%eax)
  80301f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803022:	89 d0                	mov    %edx,%eax
  803024:	01 c0                	add    %eax,%eax
  803026:	01 d0                	add    %edx,%eax
  803028:	c1 e0 02             	shl    $0x2,%eax
  80302b:	05 44 52 80 00       	add    $0x805244,%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 1b                	je     803051 <initialize_dynamic_allocator+0xf0>
  803036:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  80303c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80303f:	89 c8                	mov    %ecx,%eax
  803041:	01 c0                	add    %eax,%eax
  803043:	01 c8                	add    %ecx,%eax
  803045:	c1 e0 02             	shl    $0x2,%eax
  803048:	05 40 52 80 00       	add    $0x805240,%eax
  80304d:	89 02                	mov    %eax,(%edx)
  80304f:	eb 16                	jmp    803067 <initialize_dynamic_allocator+0x106>
  803051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803054:	89 d0                	mov    %edx,%eax
  803056:	01 c0                	add    %eax,%eax
  803058:	01 d0                	add    %edx,%eax
  80305a:	c1 e0 02             	shl    $0x2,%eax
  80305d:	05 40 52 80 00       	add    $0x805240,%eax
  803062:	a3 28 52 80 00       	mov    %eax,0x805228
  803067:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306a:	89 d0                	mov    %edx,%eax
  80306c:	01 c0                	add    %eax,%eax
  80306e:	01 d0                	add    %edx,%eax
  803070:	c1 e0 02             	shl    $0x2,%eax
  803073:	05 40 52 80 00       	add    $0x805240,%eax
  803078:	a3 2c 52 80 00       	mov    %eax,0x80522c
  80307d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803080:	89 d0                	mov    %edx,%eax
  803082:	01 c0                	add    %eax,%eax
  803084:	01 d0                	add    %edx,%eax
  803086:	c1 e0 02             	shl    $0x2,%eax
  803089:	05 40 52 80 00       	add    $0x805240,%eax
  80308e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803094:	a1 34 52 80 00       	mov    0x805234,%eax
  803099:	40                   	inc    %eax
  80309a:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  80309f:	ff 45 f4             	incl   -0xc(%ebp)
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8030a8:	0f 8c 2c ff ff ff    	jl     802fda <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8030ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8030b5:	eb 36                	jmp    8030ed <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	c1 e0 04             	shl    $0x4,%eax
  8030bd:	05 60 d2 81 00       	add    $0x81d260,%eax
  8030c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cb:	c1 e0 04             	shl    $0x4,%eax
  8030ce:	05 64 d2 81 00       	add    $0x81d264,%eax
  8030d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	c1 e0 04             	shl    $0x4,%eax
  8030df:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8030ea:	ff 45 f0             	incl   -0x10(%ebp)
  8030ed:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8030f1:	7e c4                	jle    8030b7 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8030f3:	90                   	nop
  8030f4:	c9                   	leave  
  8030f5:	c3                   	ret    

008030f6 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
  8030f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	83 ec 0c             	sub    $0xc,%esp
  803102:	50                   	push   %eax
  803103:	e8 0b fe ff ff       	call   802f13 <to_page_info>
  803108:	83 c4 10             	add    $0x10,%esp
  80310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 40 08             	mov    0x8(%eax),%eax
  803114:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803117:	c9                   	leave  
  803118:	c3                   	ret    

00803119 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  803119:	55                   	push   %ebp
  80311a:	89 e5                	mov    %esp,%ebp
  80311c:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  80311f:	83 ec 0c             	sub    $0xc,%esp
  803122:	ff 75 0c             	pushl  0xc(%ebp)
  803125:	e8 77 fd ff ff       	call   802ea1 <to_page_va>
  80312a:	83 c4 10             	add    $0x10,%esp
  80312d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  803130:	b8 00 10 00 00       	mov    $0x1000,%eax
  803135:	ba 00 00 00 00       	mov    $0x0,%edx
  80313a:	f7 75 08             	divl   0x8(%ebp)
  80313d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  803140:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803143:	83 ec 0c             	sub    $0xc,%esp
  803146:	50                   	push   %eax
  803147:	e8 48 f6 ff ff       	call   802794 <get_page>
  80314c:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  80314f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803152:	8b 55 0c             	mov    0xc(%ebp),%edx
  803155:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80315f:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  803163:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80316a:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803171:	eb 19                	jmp    80318c <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  803173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803176:	ba 01 00 00 00       	mov    $0x1,%edx
  80317b:	88 c1                	mov    %al,%cl
  80317d:	d3 e2                	shl    %cl,%edx
  80317f:	89 d0                	mov    %edx,%eax
  803181:	3b 45 08             	cmp    0x8(%ebp),%eax
  803184:	74 0e                	je     803194 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  803186:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803189:	ff 45 f0             	incl   -0x10(%ebp)
  80318c:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803190:	7e e1                	jle    803173 <split_page_to_blocks+0x5a>
  803192:	eb 01                	jmp    803195 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  803194:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  803195:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80319c:	e9 a7 00 00 00       	jmp    803248 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8031a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a4:	0f af 45 08          	imul   0x8(%ebp),%eax
  8031a8:	89 c2                	mov    %eax,%edx
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	01 d0                	add    %edx,%eax
  8031af:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8031b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031b6:	75 14                	jne    8031cc <split_page_to_blocks+0xb3>
  8031b8:	83 ec 04             	sub    $0x4,%esp
  8031bb:	68 bc 4d 80 00       	push   $0x804dbc
  8031c0:	6a 7c                	push   $0x7c
  8031c2:	68 43 4d 80 00       	push   $0x804d43
  8031c7:	e8 c1 e3 ff ff       	call   80158d <_panic>
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	c1 e0 04             	shl    $0x4,%eax
  8031d2:	05 64 d2 81 00       	add    $0x81d264,%eax
  8031d7:	8b 10                	mov    (%eax),%edx
  8031d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031dc:	89 50 04             	mov    %edx,0x4(%eax)
  8031df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e2:	8b 40 04             	mov    0x4(%eax),%eax
  8031e5:	85 c0                	test   %eax,%eax
  8031e7:	74 14                	je     8031fd <split_page_to_blocks+0xe4>
  8031e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ec:	c1 e0 04             	shl    $0x4,%eax
  8031ef:	05 64 d2 81 00       	add    $0x81d264,%eax
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031f9:	89 10                	mov    %edx,(%eax)
  8031fb:	eb 11                	jmp    80320e <split_page_to_blocks+0xf5>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	c1 e0 04             	shl    $0x4,%eax
  803203:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  803209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320c:	89 02                	mov    %eax,(%edx)
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	c1 e0 04             	shl    $0x4,%eax
  803214:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  80321a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321d:	89 02                	mov    %eax,(%edx)
  80321f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	c1 e0 04             	shl    $0x4,%eax
  80322e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	8d 50 01             	lea    0x1(%eax),%edx
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	c1 e0 04             	shl    $0x4,%eax
  80323e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803243:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  803245:	ff 45 ec             	incl   -0x14(%ebp)
  803248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80324e:	0f 82 4d ff ff ff    	jb     8031a1 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  803254:	90                   	nop
  803255:	c9                   	leave  
  803256:	c3                   	ret    

00803257 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803257:	55                   	push   %ebp
  803258:	89 e5                	mov    %esp,%ebp
  80325a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80325d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803264:	76 19                	jbe    80327f <alloc_block+0x28>
  803266:	68 e0 4d 80 00       	push   $0x804de0
  80326b:	68 a6 4d 80 00       	push   $0x804da6
  803270:	68 8a 00 00 00       	push   $0x8a
  803275:	68 43 4d 80 00       	push   $0x804d43
  80327a:	e8 0e e3 ff ff       	call   80158d <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  80327f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  803286:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80328d:	eb 19                	jmp    8032a8 <alloc_block+0x51>
		if((1 << i) >= size) break;
  80328f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803292:	ba 01 00 00 00       	mov    $0x1,%edx
  803297:	88 c1                	mov    %al,%cl
  803299:	d3 e2                	shl    %cl,%edx
  80329b:	89 d0                	mov    %edx,%eax
  80329d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032a0:	73 0e                	jae    8032b0 <alloc_block+0x59>
		idx++;
  8032a2:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8032a5:	ff 45 f0             	incl   -0x10(%ebp)
  8032a8:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8032ac:	7e e1                	jle    80328f <alloc_block+0x38>
  8032ae:	eb 01                	jmp    8032b1 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8032b0:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	c1 e0 04             	shl    $0x4,%eax
  8032b7:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	85 c0                	test   %eax,%eax
  8032c0:	0f 84 df 00 00 00    	je     8033a5 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c9:	c1 e0 04             	shl    $0x4,%eax
  8032cc:	05 60 d2 81 00       	add    $0x81d260,%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8032d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032da:	75 17                	jne    8032f3 <alloc_block+0x9c>
  8032dc:	83 ec 04             	sub    $0x4,%esp
  8032df:	68 01 4e 80 00       	push   $0x804e01
  8032e4:	68 9e 00 00 00       	push   $0x9e
  8032e9:	68 43 4d 80 00       	push   $0x804d43
  8032ee:	e8 9a e2 ff ff       	call   80158d <_panic>
  8032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	74 10                	je     80330c <alloc_block+0xb5>
  8032fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ff:	8b 00                	mov    (%eax),%eax
  803301:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803304:	8b 52 04             	mov    0x4(%edx),%edx
  803307:	89 50 04             	mov    %edx,0x4(%eax)
  80330a:	eb 14                	jmp    803320 <alloc_block+0xc9>
  80330c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330f:	8b 40 04             	mov    0x4(%eax),%eax
  803312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803315:	c1 e2 04             	shl    $0x4,%edx
  803318:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80331e:	89 02                	mov    %eax,(%edx)
  803320:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	85 c0                	test   %eax,%eax
  803328:	74 0f                	je     803339 <alloc_block+0xe2>
  80332a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332d:	8b 40 04             	mov    0x4(%eax),%eax
  803330:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803333:	8b 12                	mov    (%edx),%edx
  803335:	89 10                	mov    %edx,(%eax)
  803337:	eb 13                	jmp    80334c <alloc_block+0xf5>
  803339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333c:	8b 00                	mov    (%eax),%eax
  80333e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803341:	c1 e2 04             	shl    $0x4,%edx
  803344:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80334a:	89 02                	mov    %eax,(%edx)
  80334c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803358:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	c1 e0 04             	shl    $0x4,%eax
  803365:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	c1 e0 04             	shl    $0x4,%eax
  803375:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80337a:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80337c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337f:	83 ec 0c             	sub    $0xc,%esp
  803382:	50                   	push   %eax
  803383:	e8 8b fb ff ff       	call   802f13 <to_page_info>
  803388:	83 c4 10             	add    $0x10,%esp
  80338b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80338e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803391:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803395:	48                   	dec    %eax
  803396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803399:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80339d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a0:	e9 bc 02 00 00       	jmp    803661 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8033a5:	a1 34 52 80 00       	mov    0x805234,%eax
  8033aa:	85 c0                	test   %eax,%eax
  8033ac:	0f 84 7d 02 00 00    	je     80362f <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8033b2:	a1 28 52 80 00       	mov    0x805228,%eax
  8033b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8033ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033be:	75 17                	jne    8033d7 <alloc_block+0x180>
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	68 01 4e 80 00       	push   $0x804e01
  8033c8:	68 a9 00 00 00       	push   $0xa9
  8033cd:	68 43 4d 80 00       	push   $0x804d43
  8033d2:	e8 b6 e1 ff ff       	call   80158d <_panic>
  8033d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033da:	8b 00                	mov    (%eax),%eax
  8033dc:	85 c0                	test   %eax,%eax
  8033de:	74 10                	je     8033f0 <alloc_block+0x199>
  8033e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e8:	8b 52 04             	mov    0x4(%edx),%edx
  8033eb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ee:	eb 0b                	jmp    8033fb <alloc_block+0x1a4>
  8033f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f3:	8b 40 04             	mov    0x4(%eax),%eax
  8033f6:	a3 2c 52 80 00       	mov    %eax,0x80522c
  8033fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fe:	8b 40 04             	mov    0x4(%eax),%eax
  803401:	85 c0                	test   %eax,%eax
  803403:	74 0f                	je     803414 <alloc_block+0x1bd>
  803405:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803408:	8b 40 04             	mov    0x4(%eax),%eax
  80340b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80340e:	8b 12                	mov    (%edx),%edx
  803410:	89 10                	mov    %edx,(%eax)
  803412:	eb 0a                	jmp    80341e <alloc_block+0x1c7>
  803414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803417:	8b 00                	mov    (%eax),%eax
  803419:	a3 28 52 80 00       	mov    %eax,0x805228
  80341e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803421:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803431:	a1 34 52 80 00       	mov    0x805234,%eax
  803436:	48                   	dec    %eax
  803437:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343f:	83 c0 03             	add    $0x3,%eax
  803442:	ba 01 00 00 00       	mov    $0x1,%edx
  803447:	88 c1                	mov    %al,%cl
  803449:	d3 e2                	shl    %cl,%edx
  80344b:	89 d0                	mov    %edx,%eax
  80344d:	83 ec 08             	sub    $0x8,%esp
  803450:	ff 75 e4             	pushl  -0x1c(%ebp)
  803453:	50                   	push   %eax
  803454:	e8 c0 fc ff ff       	call   803119 <split_page_to_blocks>
  803459:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	c1 e0 04             	shl    $0x4,%eax
  803462:	05 60 d2 81 00       	add    $0x81d260,%eax
  803467:	8b 00                	mov    (%eax),%eax
  803469:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80346c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803470:	75 17                	jne    803489 <alloc_block+0x232>
  803472:	83 ec 04             	sub    $0x4,%esp
  803475:	68 01 4e 80 00       	push   $0x804e01
  80347a:	68 b0 00 00 00       	push   $0xb0
  80347f:	68 43 4d 80 00       	push   $0x804d43
  803484:	e8 04 e1 ff ff       	call   80158d <_panic>
  803489:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	85 c0                	test   %eax,%eax
  803490:	74 10                	je     8034a2 <alloc_block+0x24b>
  803492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80349a:	8b 52 04             	mov    0x4(%edx),%edx
  80349d:	89 50 04             	mov    %edx,0x4(%eax)
  8034a0:	eb 14                	jmp    8034b6 <alloc_block+0x25f>
  8034a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ab:	c1 e2 04             	shl    $0x4,%edx
  8034ae:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8034b4:	89 02                	mov    %eax,(%edx)
  8034b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b9:	8b 40 04             	mov    0x4(%eax),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	74 0f                	je     8034cf <alloc_block+0x278>
  8034c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c3:	8b 40 04             	mov    0x4(%eax),%eax
  8034c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034c9:	8b 12                	mov    (%edx),%edx
  8034cb:	89 10                	mov    %edx,(%eax)
  8034cd:	eb 13                	jmp    8034e2 <alloc_block+0x28b>
  8034cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d2:	8b 00                	mov    (%eax),%eax
  8034d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d7:	c1 e2 04             	shl    $0x4,%edx
  8034da:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8034e0:	89 02                	mov    %eax,(%edx)
  8034e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f8:	c1 e0 04             	shl    $0x4,%eax
  8034fb:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	8d 50 ff             	lea    -0x1(%eax),%edx
  803505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803508:	c1 e0 04             	shl    $0x4,%eax
  80350b:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803510:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803515:	83 ec 0c             	sub    $0xc,%esp
  803518:	50                   	push   %eax
  803519:	e8 f5 f9 ff ff       	call   802f13 <to_page_info>
  80351e:	83 c4 10             	add    $0x10,%esp
  803521:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  803524:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803527:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80352b:	48                   	dec    %eax
  80352c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80352f:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803536:	e9 26 01 00 00       	jmp    803661 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80353b:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803541:	c1 e0 04             	shl    $0x4,%eax
  803544:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	85 c0                	test   %eax,%eax
  80354d:	0f 84 dc 00 00 00    	je     80362f <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803556:	c1 e0 04             	shl    $0x4,%eax
  803559:	05 60 d2 81 00       	add    $0x81d260,%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  803563:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803567:	75 17                	jne    803580 <alloc_block+0x329>
  803569:	83 ec 04             	sub    $0x4,%esp
  80356c:	68 01 4e 80 00       	push   $0x804e01
  803571:	68 be 00 00 00       	push   $0xbe
  803576:	68 43 4d 80 00       	push   $0x804d43
  80357b:	e8 0d e0 ff ff       	call   80158d <_panic>
  803580:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	85 c0                	test   %eax,%eax
  803587:	74 10                	je     803599 <alloc_block+0x342>
  803589:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803591:	8b 52 04             	mov    0x4(%edx),%edx
  803594:	89 50 04             	mov    %edx,0x4(%eax)
  803597:	eb 14                	jmp    8035ad <alloc_block+0x356>
  803599:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80359c:	8b 40 04             	mov    0x4(%eax),%eax
  80359f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a2:	c1 e2 04             	shl    $0x4,%edx
  8035a5:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8035ab:	89 02                	mov    %eax,(%edx)
  8035ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035b0:	8b 40 04             	mov    0x4(%eax),%eax
  8035b3:	85 c0                	test   %eax,%eax
  8035b5:	74 0f                	je     8035c6 <alloc_block+0x36f>
  8035b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035ba:	8b 40 04             	mov    0x4(%eax),%eax
  8035bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035c0:	8b 12                	mov    (%edx),%edx
  8035c2:	89 10                	mov    %edx,(%eax)
  8035c4:	eb 13                	jmp    8035d9 <alloc_block+0x382>
  8035c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035c9:	8b 00                	mov    (%eax),%eax
  8035cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ce:	c1 e2 04             	shl    $0x4,%edx
  8035d1:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8035d7:	89 02                	mov    %eax,(%edx)
  8035d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ef:	c1 e0 04             	shl    $0x4,%eax
  8035f2:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035f7:	8b 00                	mov    (%eax),%eax
  8035f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ff:	c1 e0 04             	shl    $0x4,%eax
  803602:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803607:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803609:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80360c:	83 ec 0c             	sub    $0xc,%esp
  80360f:	50                   	push   %eax
  803610:	e8 fe f8 ff ff       	call   802f13 <to_page_info>
  803615:	83 c4 10             	add    $0x10,%esp
  803618:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80361b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803622:	48                   	dec    %eax
  803623:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803626:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80362a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80362d:	eb 32                	jmp    803661 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80362f:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803633:	77 15                	ja     80364a <alloc_block+0x3f3>
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	c1 e0 04             	shl    $0x4,%eax
  80363b:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803640:	8b 00                	mov    (%eax),%eax
  803642:	85 c0                	test   %eax,%eax
  803644:	0f 84 f1 fe ff ff    	je     80353b <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80364a:	83 ec 04             	sub    $0x4,%esp
  80364d:	68 1f 4e 80 00       	push   $0x804e1f
  803652:	68 c8 00 00 00       	push   $0xc8
  803657:	68 43 4d 80 00       	push   $0x804d43
  80365c:	e8 2c df ff ff       	call   80158d <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  803661:	c9                   	leave  
  803662:	c3                   	ret    

00803663 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803663:	55                   	push   %ebp
  803664:	89 e5                	mov    %esp,%ebp
  803666:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803669:	8b 55 08             	mov    0x8(%ebp),%edx
  80366c:	a1 48 d2 81 00       	mov    0x81d248,%eax
  803671:	39 c2                	cmp    %eax,%edx
  803673:	72 0c                	jb     803681 <free_block+0x1e>
  803675:	8b 55 08             	mov    0x8(%ebp),%edx
  803678:	a1 20 52 80 00       	mov    0x805220,%eax
  80367d:	39 c2                	cmp    %eax,%edx
  80367f:	72 19                	jb     80369a <free_block+0x37>
  803681:	68 30 4e 80 00       	push   $0x804e30
  803686:	68 a6 4d 80 00       	push   $0x804da6
  80368b:	68 d7 00 00 00       	push   $0xd7
  803690:	68 43 4d 80 00       	push   $0x804d43
  803695:	e8 f3 de ff ff       	call   80158d <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	83 ec 0c             	sub    $0xc,%esp
  8036a6:	50                   	push   %eax
  8036a7:	e8 67 f8 ff ff       	call   802f13 <to_page_info>
  8036ac:	83 c4 10             	add    $0x10,%esp
  8036af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8036b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b5:	8b 40 08             	mov    0x8(%eax),%eax
  8036b8:	0f b7 c0             	movzwl %ax,%eax
  8036bb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8036be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8036c5:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8036cc:	eb 19                	jmp    8036e7 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8036ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d1:	ba 01 00 00 00       	mov    $0x1,%edx
  8036d6:	88 c1                	mov    %al,%cl
  8036d8:	d3 e2                	shl    %cl,%edx
  8036da:	89 d0                	mov    %edx,%eax
  8036dc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036df:	74 0e                	je     8036ef <free_block+0x8c>
	        break;
	    idx++;
  8036e1:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8036e4:	ff 45 f0             	incl   -0x10(%ebp)
  8036e7:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8036eb:	7e e1                	jle    8036ce <free_block+0x6b>
  8036ed:	eb 01                	jmp    8036f0 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8036ef:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8036f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8036f7:	40                   	inc    %eax
  8036f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fb:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8036ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803703:	75 17                	jne    80371c <free_block+0xb9>
  803705:	83 ec 04             	sub    $0x4,%esp
  803708:	68 bc 4d 80 00       	push   $0x804dbc
  80370d:	68 ee 00 00 00       	push   $0xee
  803712:	68 43 4d 80 00       	push   $0x804d43
  803717:	e8 71 de ff ff       	call   80158d <_panic>
  80371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371f:	c1 e0 04             	shl    $0x4,%eax
  803722:	05 64 d2 81 00       	add    $0x81d264,%eax
  803727:	8b 10                	mov    (%eax),%edx
  803729:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372c:	89 50 04             	mov    %edx,0x4(%eax)
  80372f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803732:	8b 40 04             	mov    0x4(%eax),%eax
  803735:	85 c0                	test   %eax,%eax
  803737:	74 14                	je     80374d <free_block+0xea>
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	c1 e0 04             	shl    $0x4,%eax
  80373f:	05 64 d2 81 00       	add    $0x81d264,%eax
  803744:	8b 00                	mov    (%eax),%eax
  803746:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803749:	89 10                	mov    %edx,(%eax)
  80374b:	eb 11                	jmp    80375e <free_block+0xfb>
  80374d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803750:	c1 e0 04             	shl    $0x4,%eax
  803753:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  803759:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375c:	89 02                	mov    %eax,(%edx)
  80375e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803761:	c1 e0 04             	shl    $0x4,%eax
  803764:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  80376a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376d:	89 02                	mov    %eax,(%edx)
  80376f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377b:	c1 e0 04             	shl    $0x4,%eax
  80377e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	8d 50 01             	lea    0x1(%eax),%edx
  803788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378b:	c1 e0 04             	shl    $0x4,%eax
  80378e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803793:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  803795:	b8 00 10 00 00       	mov    $0x1000,%eax
  80379a:	ba 00 00 00 00       	mov    $0x0,%edx
  80379f:	f7 75 e0             	divl   -0x20(%ebp)
  8037a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8037a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037ac:	0f b7 c0             	movzwl %ax,%eax
  8037af:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8037b2:	0f 85 70 01 00 00    	jne    803928 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8037b8:	83 ec 0c             	sub    $0xc,%esp
  8037bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037be:	e8 de f6 ff ff       	call   802ea1 <to_page_va>
  8037c3:	83 c4 10             	add    $0x10,%esp
  8037c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8037c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8037d0:	e9 b7 00 00 00       	jmp    80388c <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8037d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037db:	01 d0                	add    %edx,%eax
  8037dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8037e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037e4:	75 17                	jne    8037fd <free_block+0x19a>
  8037e6:	83 ec 04             	sub    $0x4,%esp
  8037e9:	68 01 4e 80 00       	push   $0x804e01
  8037ee:	68 f8 00 00 00       	push   $0xf8
  8037f3:	68 43 4d 80 00       	push   $0x804d43
  8037f8:	e8 90 dd ff ff       	call   80158d <_panic>
  8037fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803800:	8b 00                	mov    (%eax),%eax
  803802:	85 c0                	test   %eax,%eax
  803804:	74 10                	je     803816 <free_block+0x1b3>
  803806:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803809:	8b 00                	mov    (%eax),%eax
  80380b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80380e:	8b 52 04             	mov    0x4(%edx),%edx
  803811:	89 50 04             	mov    %edx,0x4(%eax)
  803814:	eb 14                	jmp    80382a <free_block+0x1c7>
  803816:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803819:	8b 40 04             	mov    0x4(%eax),%eax
  80381c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80381f:	c1 e2 04             	shl    $0x4,%edx
  803822:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803828:	89 02                	mov    %eax,(%edx)
  80382a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80382d:	8b 40 04             	mov    0x4(%eax),%eax
  803830:	85 c0                	test   %eax,%eax
  803832:	74 0f                	je     803843 <free_block+0x1e0>
  803834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803837:	8b 40 04             	mov    0x4(%eax),%eax
  80383a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80383d:	8b 12                	mov    (%edx),%edx
  80383f:	89 10                	mov    %edx,(%eax)
  803841:	eb 13                	jmp    803856 <free_block+0x1f3>
  803843:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803846:	8b 00                	mov    (%eax),%eax
  803848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80384b:	c1 e2 04             	shl    $0x4,%edx
  80384e:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803854:	89 02                	mov    %eax,(%edx)
  803856:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80385f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386c:	c1 e0 04             	shl    $0x4,%eax
  80386f:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	8d 50 ff             	lea    -0x1(%eax),%edx
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	c1 e0 04             	shl    $0x4,%eax
  80387f:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803884:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803889:	01 45 ec             	add    %eax,-0x14(%ebp)
  80388c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803893:	0f 86 3c ff ff ff    	jbe    8037d5 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  803899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389c:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8038a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a5:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8038ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038af:	75 17                	jne    8038c8 <free_block+0x265>
  8038b1:	83 ec 04             	sub    $0x4,%esp
  8038b4:	68 bc 4d 80 00       	push   $0x804dbc
  8038b9:	68 fe 00 00 00       	push   $0xfe
  8038be:	68 43 4d 80 00       	push   $0x804d43
  8038c3:	e8 c5 dc ff ff       	call   80158d <_panic>
  8038c8:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  8038ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d1:	89 50 04             	mov    %edx,0x4(%eax)
  8038d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d7:	8b 40 04             	mov    0x4(%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	74 0c                	je     8038ea <free_block+0x287>
  8038de:	a1 2c 52 80 00       	mov    0x80522c,%eax
  8038e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e6:	89 10                	mov    %edx,(%eax)
  8038e8:	eb 08                	jmp    8038f2 <free_block+0x28f>
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	a3 28 52 80 00       	mov    %eax,0x805228
  8038f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f5:	a3 2c 52 80 00       	mov    %eax,0x80522c
  8038fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803903:	a1 34 52 80 00       	mov    0x805234,%eax
  803908:	40                   	inc    %eax
  803909:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80390e:	83 ec 0c             	sub    $0xc,%esp
  803911:	ff 75 e4             	pushl  -0x1c(%ebp)
  803914:	e8 88 f5 ff ff       	call   802ea1 <to_page_va>
  803919:	83 c4 10             	add    $0x10,%esp
  80391c:	83 ec 0c             	sub    $0xc,%esp
  80391f:	50                   	push   %eax
  803920:	e8 b8 ee ff ff       	call   8027dd <return_page>
  803925:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803928:	90                   	nop
  803929:	c9                   	leave  
  80392a:	c3                   	ret    

0080392b <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80392b:	55                   	push   %ebp
  80392c:	89 e5                	mov    %esp,%ebp
  80392e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803931:	83 ec 04             	sub    $0x4,%esp
  803934:	68 68 4e 80 00       	push   $0x804e68
  803939:	68 11 01 00 00       	push   $0x111
  80393e:	68 43 4d 80 00       	push   $0x804d43
  803943:	e8 45 dc ff ff       	call   80158d <_panic>

00803948 <__udivdi3>:
  803948:	55                   	push   %ebp
  803949:	57                   	push   %edi
  80394a:	56                   	push   %esi
  80394b:	53                   	push   %ebx
  80394c:	83 ec 1c             	sub    $0x1c,%esp
  80394f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803953:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803957:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80395b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80395f:	89 ca                	mov    %ecx,%edx
  803961:	89 f8                	mov    %edi,%eax
  803963:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803967:	85 f6                	test   %esi,%esi
  803969:	75 2d                	jne    803998 <__udivdi3+0x50>
  80396b:	39 cf                	cmp    %ecx,%edi
  80396d:	77 65                	ja     8039d4 <__udivdi3+0x8c>
  80396f:	89 fd                	mov    %edi,%ebp
  803971:	85 ff                	test   %edi,%edi
  803973:	75 0b                	jne    803980 <__udivdi3+0x38>
  803975:	b8 01 00 00 00       	mov    $0x1,%eax
  80397a:	31 d2                	xor    %edx,%edx
  80397c:	f7 f7                	div    %edi
  80397e:	89 c5                	mov    %eax,%ebp
  803980:	31 d2                	xor    %edx,%edx
  803982:	89 c8                	mov    %ecx,%eax
  803984:	f7 f5                	div    %ebp
  803986:	89 c1                	mov    %eax,%ecx
  803988:	89 d8                	mov    %ebx,%eax
  80398a:	f7 f5                	div    %ebp
  80398c:	89 cf                	mov    %ecx,%edi
  80398e:	89 fa                	mov    %edi,%edx
  803990:	83 c4 1c             	add    $0x1c,%esp
  803993:	5b                   	pop    %ebx
  803994:	5e                   	pop    %esi
  803995:	5f                   	pop    %edi
  803996:	5d                   	pop    %ebp
  803997:	c3                   	ret    
  803998:	39 ce                	cmp    %ecx,%esi
  80399a:	77 28                	ja     8039c4 <__udivdi3+0x7c>
  80399c:	0f bd fe             	bsr    %esi,%edi
  80399f:	83 f7 1f             	xor    $0x1f,%edi
  8039a2:	75 40                	jne    8039e4 <__udivdi3+0x9c>
  8039a4:	39 ce                	cmp    %ecx,%esi
  8039a6:	72 0a                	jb     8039b2 <__udivdi3+0x6a>
  8039a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039ac:	0f 87 9e 00 00 00    	ja     803a50 <__udivdi3+0x108>
  8039b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b7:	89 fa                	mov    %edi,%edx
  8039b9:	83 c4 1c             	add    $0x1c,%esp
  8039bc:	5b                   	pop    %ebx
  8039bd:	5e                   	pop    %esi
  8039be:	5f                   	pop    %edi
  8039bf:	5d                   	pop    %ebp
  8039c0:	c3                   	ret    
  8039c1:	8d 76 00             	lea    0x0(%esi),%esi
  8039c4:	31 ff                	xor    %edi,%edi
  8039c6:	31 c0                	xor    %eax,%eax
  8039c8:	89 fa                	mov    %edi,%edx
  8039ca:	83 c4 1c             	add    $0x1c,%esp
  8039cd:	5b                   	pop    %ebx
  8039ce:	5e                   	pop    %esi
  8039cf:	5f                   	pop    %edi
  8039d0:	5d                   	pop    %ebp
  8039d1:	c3                   	ret    
  8039d2:	66 90                	xchg   %ax,%ax
  8039d4:	89 d8                	mov    %ebx,%eax
  8039d6:	f7 f7                	div    %edi
  8039d8:	31 ff                	xor    %edi,%edi
  8039da:	89 fa                	mov    %edi,%edx
  8039dc:	83 c4 1c             	add    $0x1c,%esp
  8039df:	5b                   	pop    %ebx
  8039e0:	5e                   	pop    %esi
  8039e1:	5f                   	pop    %edi
  8039e2:	5d                   	pop    %ebp
  8039e3:	c3                   	ret    
  8039e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039e9:	89 eb                	mov    %ebp,%ebx
  8039eb:	29 fb                	sub    %edi,%ebx
  8039ed:	89 f9                	mov    %edi,%ecx
  8039ef:	d3 e6                	shl    %cl,%esi
  8039f1:	89 c5                	mov    %eax,%ebp
  8039f3:	88 d9                	mov    %bl,%cl
  8039f5:	d3 ed                	shr    %cl,%ebp
  8039f7:	89 e9                	mov    %ebp,%ecx
  8039f9:	09 f1                	or     %esi,%ecx
  8039fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039ff:	89 f9                	mov    %edi,%ecx
  803a01:	d3 e0                	shl    %cl,%eax
  803a03:	89 c5                	mov    %eax,%ebp
  803a05:	89 d6                	mov    %edx,%esi
  803a07:	88 d9                	mov    %bl,%cl
  803a09:	d3 ee                	shr    %cl,%esi
  803a0b:	89 f9                	mov    %edi,%ecx
  803a0d:	d3 e2                	shl    %cl,%edx
  803a0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a13:	88 d9                	mov    %bl,%cl
  803a15:	d3 e8                	shr    %cl,%eax
  803a17:	09 c2                	or     %eax,%edx
  803a19:	89 d0                	mov    %edx,%eax
  803a1b:	89 f2                	mov    %esi,%edx
  803a1d:	f7 74 24 0c          	divl   0xc(%esp)
  803a21:	89 d6                	mov    %edx,%esi
  803a23:	89 c3                	mov    %eax,%ebx
  803a25:	f7 e5                	mul    %ebp
  803a27:	39 d6                	cmp    %edx,%esi
  803a29:	72 19                	jb     803a44 <__udivdi3+0xfc>
  803a2b:	74 0b                	je     803a38 <__udivdi3+0xf0>
  803a2d:	89 d8                	mov    %ebx,%eax
  803a2f:	31 ff                	xor    %edi,%edi
  803a31:	e9 58 ff ff ff       	jmp    80398e <__udivdi3+0x46>
  803a36:	66 90                	xchg   %ax,%ax
  803a38:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a3c:	89 f9                	mov    %edi,%ecx
  803a3e:	d3 e2                	shl    %cl,%edx
  803a40:	39 c2                	cmp    %eax,%edx
  803a42:	73 e9                	jae    803a2d <__udivdi3+0xe5>
  803a44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a47:	31 ff                	xor    %edi,%edi
  803a49:	e9 40 ff ff ff       	jmp    80398e <__udivdi3+0x46>
  803a4e:	66 90                	xchg   %ax,%ax
  803a50:	31 c0                	xor    %eax,%eax
  803a52:	e9 37 ff ff ff       	jmp    80398e <__udivdi3+0x46>
  803a57:	90                   	nop

00803a58 <__umoddi3>:
  803a58:	55                   	push   %ebp
  803a59:	57                   	push   %edi
  803a5a:	56                   	push   %esi
  803a5b:	53                   	push   %ebx
  803a5c:	83 ec 1c             	sub    $0x1c,%esp
  803a5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a77:	89 f3                	mov    %esi,%ebx
  803a79:	89 fa                	mov    %edi,%edx
  803a7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a7f:	89 34 24             	mov    %esi,(%esp)
  803a82:	85 c0                	test   %eax,%eax
  803a84:	75 1a                	jne    803aa0 <__umoddi3+0x48>
  803a86:	39 f7                	cmp    %esi,%edi
  803a88:	0f 86 a2 00 00 00    	jbe    803b30 <__umoddi3+0xd8>
  803a8e:	89 c8                	mov    %ecx,%eax
  803a90:	89 f2                	mov    %esi,%edx
  803a92:	f7 f7                	div    %edi
  803a94:	89 d0                	mov    %edx,%eax
  803a96:	31 d2                	xor    %edx,%edx
  803a98:	83 c4 1c             	add    $0x1c,%esp
  803a9b:	5b                   	pop    %ebx
  803a9c:	5e                   	pop    %esi
  803a9d:	5f                   	pop    %edi
  803a9e:	5d                   	pop    %ebp
  803a9f:	c3                   	ret    
  803aa0:	39 f0                	cmp    %esi,%eax
  803aa2:	0f 87 ac 00 00 00    	ja     803b54 <__umoddi3+0xfc>
  803aa8:	0f bd e8             	bsr    %eax,%ebp
  803aab:	83 f5 1f             	xor    $0x1f,%ebp
  803aae:	0f 84 ac 00 00 00    	je     803b60 <__umoddi3+0x108>
  803ab4:	bf 20 00 00 00       	mov    $0x20,%edi
  803ab9:	29 ef                	sub    %ebp,%edi
  803abb:	89 fe                	mov    %edi,%esi
  803abd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ac1:	89 e9                	mov    %ebp,%ecx
  803ac3:	d3 e0                	shl    %cl,%eax
  803ac5:	89 d7                	mov    %edx,%edi
  803ac7:	89 f1                	mov    %esi,%ecx
  803ac9:	d3 ef                	shr    %cl,%edi
  803acb:	09 c7                	or     %eax,%edi
  803acd:	89 e9                	mov    %ebp,%ecx
  803acf:	d3 e2                	shl    %cl,%edx
  803ad1:	89 14 24             	mov    %edx,(%esp)
  803ad4:	89 d8                	mov    %ebx,%eax
  803ad6:	d3 e0                	shl    %cl,%eax
  803ad8:	89 c2                	mov    %eax,%edx
  803ada:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ade:	d3 e0                	shl    %cl,%eax
  803ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ae4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ae8:	89 f1                	mov    %esi,%ecx
  803aea:	d3 e8                	shr    %cl,%eax
  803aec:	09 d0                	or     %edx,%eax
  803aee:	d3 eb                	shr    %cl,%ebx
  803af0:	89 da                	mov    %ebx,%edx
  803af2:	f7 f7                	div    %edi
  803af4:	89 d3                	mov    %edx,%ebx
  803af6:	f7 24 24             	mull   (%esp)
  803af9:	89 c6                	mov    %eax,%esi
  803afb:	89 d1                	mov    %edx,%ecx
  803afd:	39 d3                	cmp    %edx,%ebx
  803aff:	0f 82 87 00 00 00    	jb     803b8c <__umoddi3+0x134>
  803b05:	0f 84 91 00 00 00    	je     803b9c <__umoddi3+0x144>
  803b0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b0f:	29 f2                	sub    %esi,%edx
  803b11:	19 cb                	sbb    %ecx,%ebx
  803b13:	89 d8                	mov    %ebx,%eax
  803b15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b19:	d3 e0                	shl    %cl,%eax
  803b1b:	89 e9                	mov    %ebp,%ecx
  803b1d:	d3 ea                	shr    %cl,%edx
  803b1f:	09 d0                	or     %edx,%eax
  803b21:	89 e9                	mov    %ebp,%ecx
  803b23:	d3 eb                	shr    %cl,%ebx
  803b25:	89 da                	mov    %ebx,%edx
  803b27:	83 c4 1c             	add    $0x1c,%esp
  803b2a:	5b                   	pop    %ebx
  803b2b:	5e                   	pop    %esi
  803b2c:	5f                   	pop    %edi
  803b2d:	5d                   	pop    %ebp
  803b2e:	c3                   	ret    
  803b2f:	90                   	nop
  803b30:	89 fd                	mov    %edi,%ebp
  803b32:	85 ff                	test   %edi,%edi
  803b34:	75 0b                	jne    803b41 <__umoddi3+0xe9>
  803b36:	b8 01 00 00 00       	mov    $0x1,%eax
  803b3b:	31 d2                	xor    %edx,%edx
  803b3d:	f7 f7                	div    %edi
  803b3f:	89 c5                	mov    %eax,%ebp
  803b41:	89 f0                	mov    %esi,%eax
  803b43:	31 d2                	xor    %edx,%edx
  803b45:	f7 f5                	div    %ebp
  803b47:	89 c8                	mov    %ecx,%eax
  803b49:	f7 f5                	div    %ebp
  803b4b:	89 d0                	mov    %edx,%eax
  803b4d:	e9 44 ff ff ff       	jmp    803a96 <__umoddi3+0x3e>
  803b52:	66 90                	xchg   %ax,%ax
  803b54:	89 c8                	mov    %ecx,%eax
  803b56:	89 f2                	mov    %esi,%edx
  803b58:	83 c4 1c             	add    $0x1c,%esp
  803b5b:	5b                   	pop    %ebx
  803b5c:	5e                   	pop    %esi
  803b5d:	5f                   	pop    %edi
  803b5e:	5d                   	pop    %ebp
  803b5f:	c3                   	ret    
  803b60:	3b 04 24             	cmp    (%esp),%eax
  803b63:	72 06                	jb     803b6b <__umoddi3+0x113>
  803b65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b69:	77 0f                	ja     803b7a <__umoddi3+0x122>
  803b6b:	89 f2                	mov    %esi,%edx
  803b6d:	29 f9                	sub    %edi,%ecx
  803b6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b73:	89 14 24             	mov    %edx,(%esp)
  803b76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b7e:	8b 14 24             	mov    (%esp),%edx
  803b81:	83 c4 1c             	add    $0x1c,%esp
  803b84:	5b                   	pop    %ebx
  803b85:	5e                   	pop    %esi
  803b86:	5f                   	pop    %edi
  803b87:	5d                   	pop    %ebp
  803b88:	c3                   	ret    
  803b89:	8d 76 00             	lea    0x0(%esi),%esi
  803b8c:	2b 04 24             	sub    (%esp),%eax
  803b8f:	19 fa                	sbb    %edi,%edx
  803b91:	89 d1                	mov    %edx,%ecx
  803b93:	89 c6                	mov    %eax,%esi
  803b95:	e9 71 ff ff ff       	jmp    803b0b <__umoddi3+0xb3>
  803b9a:	66 90                	xchg   %ax,%ax
  803b9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ba0:	72 ea                	jb     803b8c <__umoddi3+0x134>
  803ba2:	89 d9                	mov    %ebx,%ecx
  803ba4:	e9 62 ff ff ff       	jmp    803b0b <__umoddi3+0xb3>
