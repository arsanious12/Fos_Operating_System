
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 80 13 00 00       	call   8013b6 <libmain>
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
  800067:	e8 83 29 00 00       	call   8029ef <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 c6 29 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 2f 27 00 00       	call   8027f6 <malloc>
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
  8000df:	e8 0b 29 00 00       	call   8029ef <sys_calculate_free_frames>
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
  800125:	68 a0 3b 80 00       	push   $0x803ba0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 30 17 00 00       	call   801861 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 01 29 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 1c 3c 80 00       	push   $0x803c1c
  800150:	6a 0c                	push   $0xc
  800152:	e8 0a 17 00 00       	call   801861 <cprintf_colored>
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
  800174:	e8 76 28 00 00       	call   8029ef <sys_calculate_free_frames>
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
  8001b9:	e8 31 28 00 00       	call   8029ef <sys_calculate_free_frames>
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
  8001f8:	68 94 3c 80 00       	push   $0x803c94
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 5d 16 00 00       	call   801861 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 2e 28 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 20 3d 80 00       	push   $0x803d20
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 30 16 00 00       	call   801861 <cprintf_colored>
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
  800270:	e8 3c 2b 00 00       	call   802db1 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 98 3d 80 00       	push   $0x803d98
  80028f:	6a 0c                	push   $0xc
  800291:	e8 cb 15 00 00       	call   801861 <cprintf_colored>
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
  8002ae:	e8 3c 27 00 00       	call   8029ef <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 7f 27 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 53 25 00 00       	call   802824 <free>
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
  8002fc:	e8 39 27 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 d0 3d 80 00       	push   $0x803dd0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 42 15 00 00       	call   801861 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 c8 26 00 00       	call   8029ef <sys_calculate_free_frames>
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
  800342:	68 1c 3e 80 00       	push   $0x803e1c
  800347:	6a 0c                	push   $0xc
  800349:	e8 13 15 00 00       	call   801861 <cprintf_colored>
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
  8003a0:	e8 0c 2a 00 00       	call   802db1 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 78 3e 80 00       	push   $0x803e78
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 9b 14 00 00       	call   801861 <cprintf_colored>
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
  800416:	68 b0 3e 80 00       	push   $0x803eb0
  80041b:	6a 03                	push   $0x3
  80041d:	e8 3f 14 00 00       	call   801861 <cprintf_colored>
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
  8004df:	68 e0 3e 80 00       	push   $0x803ee0
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 76 13 00 00       	call   801861 <cprintf_colored>
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
  8005b9:	68 e0 3e 80 00       	push   $0x803ee0
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 9c 12 00 00       	call   801861 <cprintf_colored>
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
  800693:	68 e0 3e 80 00       	push   $0x803ee0
  800698:	6a 0c                	push   $0xc
  80069a:	e8 c2 11 00 00       	call   801861 <cprintf_colored>
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
  80076d:	68 e0 3e 80 00       	push   $0x803ee0
  800772:	6a 0c                	push   $0xc
  800774:	e8 e8 10 00 00       	call   801861 <cprintf_colored>
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
  800847:	68 e0 3e 80 00       	push   $0x803ee0
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 0e 10 00 00       	call   801861 <cprintf_colored>
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
  800921:	68 e0 3e 80 00       	push   $0x803ee0
  800926:	6a 0c                	push   $0xc
  800928:	e8 34 0f 00 00       	call   801861 <cprintf_colored>
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
  800a16:	68 e0 3e 80 00       	push   $0x803ee0
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 3f 0e 00 00       	call   801861 <cprintf_colored>
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
  800b14:	68 e0 3e 80 00       	push   $0x803ee0
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 41 0d 00 00       	call   801861 <cprintf_colored>
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
  800c12:	68 e0 3e 80 00       	push   $0x803ee0
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 43 0c 00 00       	call   801861 <cprintf_colored>
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
  800d10:	68 e0 3e 80 00       	push   $0x803ee0
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 45 0b 00 00       	call   801861 <cprintf_colored>
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
  800dfd:	68 e0 3e 80 00       	push   $0x803ee0
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 58 0a 00 00       	call   801861 <cprintf_colored>
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
  800eea:	68 e0 3e 80 00       	push   $0x803ee0
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 6b 09 00 00       	call   801861 <cprintf_colored>
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
  800fd7:	68 e0 3e 80 00       	push   $0x803ee0
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 7e 08 00 00       	call   801861 <cprintf_colored>
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
  800ffa:	68 32 3f 80 00       	push   $0x803f32
  800fff:	6a 03                	push   $0x3
  801001:	e8 5b 08 00 00       	call   801861 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 d0 19 00 00       	call   8029ef <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 10 1a 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
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
  801055:	e8 9c 17 00 00       	call   8027f6 <malloc>
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
  801084:	68 50 3f 80 00       	push   $0x803f50
  801089:	6a 0c                	push   $0xc
  80108b:	e8 d1 07 00 00       	call   801861 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 a2 19 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 8c 3f 80 00       	push   $0x803f8c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 a5 07 00 00       	call   801861 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 2b 19 00 00       	call   8029ef <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 fc 3f 80 00       	push   $0x803ffc
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 79 07 00 00       	call   801861 <cprintf_colored>
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
#include <user/tst_malloc_helpers.h>
extern volatile bool printStats;

void
_main(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 30             	sub    $0x30,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801107:	a1 00 52 80 00       	mov    0x805200,%eax
  80110c:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801112:	a1 00 52 80 00       	mov    0x805200,%eax
  801117:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80111d:	39 c2                	cmp    %eax,%edx
  80111f:	72 14                	jb     801135 <_main+0x36>
			panic("Please increase the WS size");
  801121:	83 ec 04             	sub    $0x4,%esp
  801124:	68 44 40 80 00       	push   $0x804044
  801129:	6a 0f                	push   $0xf
  80112b:	68 60 40 80 00       	push   $0x804060
  801130:	e8 31 04 00 00       	call   801566 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801135:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  80113c:	e8 90 1a 00 00       	call   802bd1 <sys_getparentenvid>
  801141:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int diff, expected;
	int freeFrames, usedDiskPages ;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_lock_cons();
  801144:	e8 f6 17 00 00       	call   80293f <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  801149:	e8 a1 18 00 00       	call   8029ef <sys_calculate_free_frames>
  80114e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801151:	e8 e4 18 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  801156:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = sget(parentenvID,"z");
  801159:	83 ec 08             	sub    $0x8,%esp
  80115c:	68 7b 40 80 00       	push   $0x80407b
  801161:	ff 75 f0             	pushl  -0x10(%ebp)
  801164:	e8 09 17 00 00       	call   802872 <sget>
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80116f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801172:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  801175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801178:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80117b:	74 1a                	je     801197 <_main+0x98>
  80117d:	83 ec 0c             	sub    $0xc,%esp
  801180:	ff 75 e4             	pushl  -0x1c(%ebp)
  801183:	ff 75 e0             	pushl  -0x20(%ebp)
  801186:	68 80 40 80 00       	push   $0x804080
  80118b:	6a 26                	push   $0x26
  80118d:	68 60 40 80 00       	push   $0x804060
  801192:	e8 cf 03 00 00       	call   801566 <_panic>
		expected = 1 ; /* 1 table in UH*/
  801197:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80119e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8011a1:	e8 49 18 00 00       	call   8029ef <sys_calculate_free_frames>
  8011a6:	29 c3                	sub    %eax,%ebx
  8011a8:	89 d8                	mov    %ebx,%eax
  8011aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (!inRange(diff, expected, expected + 2 /*UH Block Alloc: max of 1 page & 1 table*/))
  8011ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011b0:	83 c0 02             	add    $0x2,%eax
  8011b3:	83 ec 04             	sub    $0x4,%esp
  8011b6:	50                   	push   %eax
  8011b7:	ff 75 dc             	pushl  -0x24(%ebp)
  8011ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8011bd:	e8 76 ee ff ff       	call   800038 <inRange>
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	75 2b                	jne    8011f4 <_main+0xf5>
			panic("Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expected +2);
  8011c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011cc:	8d 58 02             	lea    0x2(%eax),%ebx
  8011cf:	8b 75 ec             	mov    -0x14(%ebp),%esi
  8011d2:	e8 18 18 00 00       	call   8029ef <sys_calculate_free_frames>
  8011d7:	29 c6                	sub    %eax,%esi
  8011d9:	89 f0                	mov    %esi,%eax
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	53                   	push   %ebx
  8011df:	ff 75 dc             	pushl  -0x24(%ebp)
  8011e2:	50                   	push   %eax
  8011e3:	68 fc 40 80 00       	push   $0x8040fc
  8011e8:	6a 2a                	push   $0x2a
  8011ea:	68 60 40 80 00       	push   $0x804060
  8011ef:	e8 72 03 00 00       	call   801566 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8011f4:	e8 41 18 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  8011f9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8011fc:	74 14                	je     801212 <_main+0x113>
		{panic("Wrong page file allocation: ");}
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	68 9a 41 80 00       	push   $0x80419a
  801206:	6a 2c                	push   $0x2c
  801208:	68 60 40 80 00       	push   $0x804060
  80120d:	e8 54 03 00 00       	call   801566 <_panic>
	}
	sys_unlock_cons();
  801212:	e8 42 17 00 00       	call   802959 <sys_unlock_cons>

	sys_lock_cons();
  801217:	e8 23 17 00 00       	call   80293f <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  80121c:	e8 ce 17 00 00       	call   8029ef <sys_calculate_free_frames>
  801221:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801224:	e8 11 18 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  801229:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = sget(parentenvID,"x");
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	68 b7 41 80 00       	push   $0x8041b7
  801234:	ff 75 f0             	pushl  -0x10(%ebp)
  801237:	e8 36 16 00 00       	call   802872 <sget>
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  801242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801245:	05 00 10 00 00       	add    $0x1000,%eax
  80124a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  80124d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801250:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801253:	74 1a                	je     80126f <_main+0x170>
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80125b:	ff 75 e0             	pushl  -0x20(%ebp)
  80125e:	68 80 40 80 00       	push   $0x804080
  801263:	6a 36                	push   $0x36
  801265:	68 60 40 80 00       	push   $0x804060
  80126a:	e8 f7 02 00 00       	call   801566 <_panic>
		expected = 0;
  80126f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  801276:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  801279:	e8 71 17 00 00       	call   8029ef <sys_calculate_free_frames>
  80127e:	29 c3                	sub    %eax,%ebx
  801280:	89 d8                	mov    %ebx,%eax
  801282:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	ff 75 dc             	pushl  -0x24(%ebp)
  80128b:	ff 75 dc             	pushl  -0x24(%ebp)
  80128e:	ff 75 d8             	pushl  -0x28(%ebp)
  801291:	e8 a2 ed ff ff       	call   800038 <inRange>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	75 24                	jne    8012c1 <_main+0x1c2>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  80129d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8012a0:	e8 4a 17 00 00       	call   8029ef <sys_calculate_free_frames>
  8012a5:	29 c3                	sub    %eax,%ebx
  8012a7:	89 d8                	mov    %ebx,%eax
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8012af:	50                   	push   %eax
  8012b0:	68 bc 41 80 00       	push   $0x8041bc
  8012b5:	6a 3a                	push   $0x3a
  8012b7:	68 60 40 80 00       	push   $0x804060
  8012bc:	e8 a5 02 00 00       	call   801566 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012c1:	e8 74 17 00 00       	call   802a3a <sys_pf_calculate_allocated_pages>
  8012c6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012c9:	74 14                	je     8012df <_main+0x1e0>
		{panic("Wrong page file allocation: ");}
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	68 9a 41 80 00       	push   $0x80419a
  8012d3:	6a 3c                	push   $0x3c
  8012d5:	68 60 40 80 00       	push   $0x804060
  8012da:	e8 87 02 00 00       	call   801566 <_panic>
	}
	sys_unlock_cons();
  8012df:	e8 75 16 00 00       	call   802959 <sys_unlock_cons>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8012e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	83 f8 0a             	cmp    $0xa,%eax
  8012ec:	74 14                	je     801302 <_main+0x203>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 54 42 80 00       	push   $0x804254
  8012f6:	6a 40                	push   $0x40
  8012f8:	68 60 40 80 00       	push   $0x804060
  8012fd:	e8 64 02 00 00       	call   801566 <_panic>

	//Edit the writable object
	*z = 50;
  801302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801305:	c7 00 32 00 00 00    	movl   $0x32,(%eax)
	if (*z != 50) panic("Get(): Shared Variable is not created or got correctly") ;
  80130b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	83 f8 32             	cmp    $0x32,%eax
  801313:	74 14                	je     801329 <_main+0x22a>
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	68 54 42 80 00       	push   $0x804254
  80131d:	6a 44                	push   $0x44
  80131f:	68 60 40 80 00       	push   $0x804060
  801324:	e8 3d 02 00 00       	call   801566 <_panic>

	inctst();
  801329:	e8 c8 19 00 00       	call   802cf6 <inctst>

	//sync with master
	while (gettst() != 5) ;
  80132e:	90                   	nop
  80132f:	e8 dc 19 00 00       	call   802d10 <gettst>
  801334:	83 f8 05             	cmp    $0x5,%eax
  801337:	75 f6                	jne    80132f <_main+0x230>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  801339:	83 ec 0c             	sub    $0xc,%esp
  80133c:	6a 06                	push   $0x6
  80133e:	e8 2d 19 00 00       	call   802c70 <sys_bypassPageFault>
  801343:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 d4             	pushl  -0x2c(%ebp)
  80134c:	68 8c 42 80 00       	push   $0x80428c
  801351:	e8 50 05 00 00       	call   8018a6 <atomic_cprintf>
  801356:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  801359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80135c:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  801362:	83 ec 0c             	sub    $0xc,%esp
  801365:	6a 00                	push   $0x0
  801367:	e8 04 19 00 00       	call   802c70 <sys_bypassPageFault>
  80136c:	83 c4 10             	add    $0x10,%esp

	inctst();
  80136f:	e8 82 19 00 00       	call   802cf6 <inctst>
	if (*x == 100)
  801374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801377:	8b 00                	mov    (%eax),%eax
  801379:	83 f8 64             	cmp    $0x64,%eax
  80137c:	75 14                	jne    801392 <_main+0x293>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	68 bc 42 80 00       	push   $0x8042bc
  801386:	6a 54                	push   $0x54
  801388:	68 60 40 80 00       	push   $0x804060
  80138d:	e8 d4 01 00 00       	call   801566 <_panic>

	cprintf_colored(TEXT_green, "Slave2 completed.\n");
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	68 03 43 80 00       	push   $0x804303
  80139a:	6a 02                	push   $0x2
  80139c:	e8 c0 04 00 00       	call   801861 <cprintf_colored>
  8013a1:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  8013a4:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  8013ab:	00 00 00 

	return;
  8013ae:	90                   	nop
}
  8013af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b2:	5b                   	pop    %ebx
  8013b3:	5e                   	pop    %esi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    

008013b6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	57                   	push   %edi
  8013ba:	56                   	push   %esi
  8013bb:	53                   	push   %ebx
  8013bc:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8013bf:	e8 f4 17 00 00       	call   802bb8 <sys_getenvindex>
  8013c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8013c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ca:	89 d0                	mov    %edx,%eax
  8013cc:	c1 e0 02             	shl    $0x2,%eax
  8013cf:	01 d0                	add    %edx,%eax
  8013d1:	c1 e0 03             	shl    $0x3,%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8013dd:	01 d0                	add    %edx,%eax
  8013df:	c1 e0 02             	shl    $0x2,%eax
  8013e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013e7:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8013ec:	a1 00 52 80 00       	mov    0x805200,%eax
  8013f1:	8a 40 20             	mov    0x20(%eax),%al
  8013f4:	84 c0                	test   %al,%al
  8013f6:	74 0d                	je     801405 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8013f8:	a1 00 52 80 00       	mov    0x805200,%eax
  8013fd:	83 c0 20             	add    $0x20,%eax
  801400:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801409:	7e 0a                	jle    801415 <libmain+0x5f>
		binaryname = argv[0];
  80140b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140e:	8b 00                	mov    (%eax),%eax
  801410:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	ff 75 08             	pushl  0x8(%ebp)
  80141e:	e8 dc fc ff ff       	call   8010ff <_main>
  801423:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801426:	a1 00 50 80 00       	mov    0x805000,%eax
  80142b:	85 c0                	test   %eax,%eax
  80142d:	0f 84 01 01 00 00    	je     801534 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801433:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801439:	bb 10 44 80 00       	mov    $0x804410,%ebx
  80143e:	ba 0e 00 00 00       	mov    $0xe,%edx
  801443:	89 c7                	mov    %eax,%edi
  801445:	89 de                	mov    %ebx,%esi
  801447:	89 d1                	mov    %edx,%ecx
  801449:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80144b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80144e:	b9 56 00 00 00       	mov    $0x56,%ecx
  801453:	b0 00                	mov    $0x0,%al
  801455:	89 d7                	mov    %edx,%edi
  801457:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801459:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801460:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	50                   	push   %eax
  801467:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80146d:	50                   	push   %eax
  80146e:	e8 7b 19 00 00       	call   802dee <sys_utilities>
  801473:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801476:	e8 c4 14 00 00       	call   80293f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	68 30 43 80 00       	push   $0x804330
  801483:	e8 ac 03 00 00       	call   801834 <cprintf>
  801488:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80148b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148e:	85 c0                	test   %eax,%eax
  801490:	74 18                	je     8014aa <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801492:	e8 75 19 00 00       	call   802e0c <sys_get_optimal_num_faults>
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	50                   	push   %eax
  80149b:	68 58 43 80 00       	push   $0x804358
  8014a0:	e8 8f 03 00 00       	call   801834 <cprintf>
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	eb 59                	jmp    801503 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014aa:	a1 00 52 80 00       	mov    0x805200,%eax
  8014af:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8014b5:	a1 00 52 80 00       	mov    0x805200,%eax
  8014ba:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	52                   	push   %edx
  8014c4:	50                   	push   %eax
  8014c5:	68 7c 43 80 00       	push   $0x80437c
  8014ca:	e8 65 03 00 00       	call   801834 <cprintf>
  8014cf:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8014d2:	a1 00 52 80 00       	mov    0x805200,%eax
  8014d7:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8014dd:	a1 00 52 80 00       	mov    0x805200,%eax
  8014e2:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8014e8:	a1 00 52 80 00       	mov    0x805200,%eax
  8014ed:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8014f3:	51                   	push   %ecx
  8014f4:	52                   	push   %edx
  8014f5:	50                   	push   %eax
  8014f6:	68 a4 43 80 00       	push   $0x8043a4
  8014fb:	e8 34 03 00 00       	call   801834 <cprintf>
  801500:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801503:	a1 00 52 80 00       	mov    0x805200,%eax
  801508:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	50                   	push   %eax
  801512:	68 fc 43 80 00       	push   $0x8043fc
  801517:	e8 18 03 00 00       	call   801834 <cprintf>
  80151c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	68 30 43 80 00       	push   $0x804330
  801527:	e8 08 03 00 00       	call   801834 <cprintf>
  80152c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80152f:	e8 25 14 00 00       	call   802959 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801534:	e8 1f 00 00 00       	call   801558 <exit>
}
  801539:	90                   	nop
  80153a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153d:	5b                   	pop    %ebx
  80153e:	5e                   	pop    %esi
  80153f:	5f                   	pop    %edi
  801540:	5d                   	pop    %ebp
  801541:	c3                   	ret    

00801542 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801548:	83 ec 0c             	sub    $0xc,%esp
  80154b:	6a 00                	push   $0x0
  80154d:	e8 32 16 00 00       	call   802b84 <sys_destroy_env>
  801552:	83 c4 10             	add    $0x10,%esp
}
  801555:	90                   	nop
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <exit>:

void
exit(void)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80155e:	e8 87 16 00 00       	call   802bea <sys_exit_env>
}
  801563:	90                   	nop
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80156c:	8d 45 10             	lea    0x10(%ebp),%eax
  80156f:	83 c0 04             	add    $0x4,%eax
  801572:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801575:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  80157a:	85 c0                	test   %eax,%eax
  80157c:	74 16                	je     801594 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80157e:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	50                   	push   %eax
  801587:	68 74 44 80 00       	push   $0x804474
  80158c:	e8 a3 02 00 00       	call   801834 <cprintf>
  801591:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801594:	a1 04 50 80 00       	mov    0x805004,%eax
  801599:	83 ec 0c             	sub    $0xc,%esp
  80159c:	ff 75 0c             	pushl  0xc(%ebp)
  80159f:	ff 75 08             	pushl  0x8(%ebp)
  8015a2:	50                   	push   %eax
  8015a3:	68 7c 44 80 00       	push   $0x80447c
  8015a8:	6a 74                	push   $0x74
  8015aa:	e8 b2 02 00 00       	call   801861 <cprintf_colored>
  8015af:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8015b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b5:	83 ec 08             	sub    $0x8,%esp
  8015b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015bb:	50                   	push   %eax
  8015bc:	e8 04 02 00 00       	call   8017c5 <vcprintf>
  8015c1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	6a 00                	push   $0x0
  8015c9:	68 a4 44 80 00       	push   $0x8044a4
  8015ce:	e8 f2 01 00 00       	call   8017c5 <vcprintf>
  8015d3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8015d6:	e8 7d ff ff ff       	call   801558 <exit>

	// should not return here
	while (1) ;
  8015db:	eb fe                	jmp    8015db <_panic+0x75>

008015dd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8015e3:	a1 00 52 80 00       	mov    0x805200,%eax
  8015e8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8015ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f1:	39 c2                	cmp    %eax,%edx
  8015f3:	74 14                	je     801609 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8015f5:	83 ec 04             	sub    $0x4,%esp
  8015f8:	68 a8 44 80 00       	push   $0x8044a8
  8015fd:	6a 26                	push   $0x26
  8015ff:	68 f4 44 80 00       	push   $0x8044f4
  801604:	e8 5d ff ff ff       	call   801566 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801609:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801610:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801617:	e9 c5 00 00 00       	jmp    8016e1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80161c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	01 d0                	add    %edx,%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	85 c0                	test   %eax,%eax
  80162f:	75 08                	jne    801639 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801631:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801634:	e9 a5 00 00 00       	jmp    8016de <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801639:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801640:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801647:	eb 69                	jmp    8016b2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801649:	a1 00 52 80 00       	mov    0x805200,%eax
  80164e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801654:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801657:	89 d0                	mov    %edx,%eax
  801659:	01 c0                	add    %eax,%eax
  80165b:	01 d0                	add    %edx,%eax
  80165d:	c1 e0 03             	shl    $0x3,%eax
  801660:	01 c8                	add    %ecx,%eax
  801662:	8a 40 04             	mov    0x4(%eax),%al
  801665:	84 c0                	test   %al,%al
  801667:	75 46                	jne    8016af <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801669:	a1 00 52 80 00       	mov    0x805200,%eax
  80166e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801674:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801677:	89 d0                	mov    %edx,%eax
  801679:	01 c0                	add    %eax,%eax
  80167b:	01 d0                	add    %edx,%eax
  80167d:	c1 e0 03             	shl    $0x3,%eax
  801680:	01 c8                	add    %ecx,%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801687:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80168a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80168f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	01 c8                	add    %ecx,%eax
  8016a0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016a2:	39 c2                	cmp    %eax,%edx
  8016a4:	75 09                	jne    8016af <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8016a6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016ad:	eb 15                	jmp    8016c4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016af:	ff 45 e8             	incl   -0x18(%ebp)
  8016b2:	a1 00 52 80 00       	mov    0x805200,%eax
  8016b7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016c0:	39 c2                	cmp    %eax,%edx
  8016c2:	77 85                	ja     801649 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016c8:	75 14                	jne    8016de <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	68 00 45 80 00       	push   $0x804500
  8016d2:	6a 3a                	push   $0x3a
  8016d4:	68 f4 44 80 00       	push   $0x8044f4
  8016d9:	e8 88 fe ff ff       	call   801566 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8016de:	ff 45 f0             	incl   -0x10(%ebp)
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8016e7:	0f 8c 2f ff ff ff    	jl     80161c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8016ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8016fb:	eb 26                	jmp    801723 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8016fd:	a1 00 52 80 00       	mov    0x805200,%eax
  801702:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801708:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80170b:	89 d0                	mov    %edx,%eax
  80170d:	01 c0                	add    %eax,%eax
  80170f:	01 d0                	add    %edx,%eax
  801711:	c1 e0 03             	shl    $0x3,%eax
  801714:	01 c8                	add    %ecx,%eax
  801716:	8a 40 04             	mov    0x4(%eax),%al
  801719:	3c 01                	cmp    $0x1,%al
  80171b:	75 03                	jne    801720 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80171d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801720:	ff 45 e0             	incl   -0x20(%ebp)
  801723:	a1 00 52 80 00       	mov    0x805200,%eax
  801728:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80172e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801731:	39 c2                	cmp    %eax,%edx
  801733:	77 c8                	ja     8016fd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801738:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80173b:	74 14                	je     801751 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	68 54 45 80 00       	push   $0x804554
  801745:	6a 44                	push   $0x44
  801747:	68 f4 44 80 00       	push   $0x8044f4
  80174c:	e8 15 fe ff ff       	call   801566 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801751:	90                   	nop
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	53                   	push   %ebx
  801758:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80175b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175e:	8b 00                	mov    (%eax),%eax
  801760:	8d 48 01             	lea    0x1(%eax),%ecx
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	89 0a                	mov    %ecx,(%edx)
  801768:	8b 55 08             	mov    0x8(%ebp),%edx
  80176b:	88 d1                	mov    %dl,%cl
  80176d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801770:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801774:	8b 45 0c             	mov    0xc(%ebp),%eax
  801777:	8b 00                	mov    (%eax),%eax
  801779:	3d ff 00 00 00       	cmp    $0xff,%eax
  80177e:	75 30                	jne    8017b0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801780:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801786:	a0 24 52 80 00       	mov    0x805224,%al
  80178b:	0f b6 c0             	movzbl %al,%eax
  80178e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801791:	8b 09                	mov    (%ecx),%ecx
  801793:	89 cb                	mov    %ecx,%ebx
  801795:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801798:	83 c1 08             	add    $0x8,%ecx
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	53                   	push   %ebx
  80179e:	51                   	push   %ecx
  80179f:	e8 57 11 00 00       	call   8028fb <sys_cputs>
  8017a4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b3:	8b 40 04             	mov    0x4(%eax),%eax
  8017b6:	8d 50 01             	lea    0x1(%eax),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017bf:	90                   	nop
  8017c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017d5:	00 00 00 
	b.cnt = 0;
  8017d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8017df:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8017ee:	50                   	push   %eax
  8017ef:	68 54 17 80 00       	push   $0x801754
  8017f4:	e8 5a 02 00 00       	call   801a53 <vprintfmt>
  8017f9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8017fc:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801802:	a0 24 52 80 00       	mov    0x805224,%al
  801807:	0f b6 c0             	movzbl %al,%eax
  80180a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801810:	52                   	push   %edx
  801811:	50                   	push   %eax
  801812:	51                   	push   %ecx
  801813:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801819:	83 c0 08             	add    $0x8,%eax
  80181c:	50                   	push   %eax
  80181d:	e8 d9 10 00 00       	call   8028fb <sys_cputs>
  801822:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801825:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  80182c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80183a:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  801841:	8d 45 0c             	lea    0xc(%ebp),%eax
  801844:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	83 ec 08             	sub    $0x8,%esp
  80184d:	ff 75 f4             	pushl  -0xc(%ebp)
  801850:	50                   	push   %eax
  801851:	e8 6f ff ff ff       	call   8017c5 <vcprintf>
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80185c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801867:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	c1 e0 08             	shl    $0x8,%eax
  801874:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  801879:	8d 45 0c             	lea    0xc(%ebp),%eax
  80187c:	83 c0 04             	add    $0x4,%eax
  80187f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	83 ec 08             	sub    $0x8,%esp
  801888:	ff 75 f4             	pushl  -0xc(%ebp)
  80188b:	50                   	push   %eax
  80188c:	e8 34 ff ff ff       	call   8017c5 <vcprintf>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801897:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  80189e:	07 00 00 

	return cnt;
  8018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8018ac:	e8 8e 10 00 00       	call   80293f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	83 ec 08             	sub    $0x8,%esp
  8018bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c0:	50                   	push   %eax
  8018c1:	e8 ff fe ff ff       	call   8017c5 <vcprintf>
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8018cc:	e8 88 10 00 00       	call   802959 <sys_unlock_cons>
	return cnt;
  8018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 14             	sub    $0x14,%esp
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8018ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018f4:	77 55                	ja     80194b <printnum+0x75>
  8018f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018f9:	72 05                	jb     801900 <printnum+0x2a>
  8018fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018fe:	77 4b                	ja     80194b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801900:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801903:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801906:	8b 45 18             	mov    0x18(%ebp),%eax
  801909:	ba 00 00 00 00       	mov    $0x0,%edx
  80190e:	52                   	push   %edx
  80190f:	50                   	push   %eax
  801910:	ff 75 f4             	pushl  -0xc(%ebp)
  801913:	ff 75 f0             	pushl  -0x10(%ebp)
  801916:	e8 09 20 00 00       	call   803924 <__udivdi3>
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	ff 75 20             	pushl  0x20(%ebp)
  801924:	53                   	push   %ebx
  801925:	ff 75 18             	pushl  0x18(%ebp)
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	e8 a1 ff ff ff       	call   8018d6 <printnum>
  801935:	83 c4 20             	add    $0x20,%esp
  801938:	eb 1a                	jmp    801954 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80193a:	83 ec 08             	sub    $0x8,%esp
  80193d:	ff 75 0c             	pushl  0xc(%ebp)
  801940:	ff 75 20             	pushl  0x20(%ebp)
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	ff d0                	call   *%eax
  801948:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80194b:	ff 4d 1c             	decl   0x1c(%ebp)
  80194e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801952:	7f e6                	jg     80193a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801954:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801957:	bb 00 00 00 00       	mov    $0x0,%ebx
  80195c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801962:	53                   	push   %ebx
  801963:	51                   	push   %ecx
  801964:	52                   	push   %edx
  801965:	50                   	push   %eax
  801966:	e8 c9 20 00 00       	call   803a34 <__umoddi3>
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	05 b4 47 80 00       	add    $0x8047b4,%eax
  801973:	8a 00                	mov    (%eax),%al
  801975:	0f be c0             	movsbl %al,%eax
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	ff 75 0c             	pushl  0xc(%ebp)
  80197e:	50                   	push   %eax
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	ff d0                	call   *%eax
  801984:	83 c4 10             	add    $0x10,%esp
}
  801987:	90                   	nop
  801988:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801990:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801994:	7e 1c                	jle    8019b2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	8b 00                	mov    (%eax),%eax
  80199b:	8d 50 08             	lea    0x8(%eax),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	89 10                	mov    %edx,(%eax)
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	8b 00                	mov    (%eax),%eax
  8019a8:	83 e8 08             	sub    $0x8,%eax
  8019ab:	8b 50 04             	mov    0x4(%eax),%edx
  8019ae:	8b 00                	mov    (%eax),%eax
  8019b0:	eb 40                	jmp    8019f2 <getuint+0x65>
	else if (lflag)
  8019b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019b6:	74 1e                	je     8019d6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	8b 00                	mov    (%eax),%eax
  8019bd:	8d 50 04             	lea    0x4(%eax),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	89 10                	mov    %edx,(%eax)
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	8b 00                	mov    (%eax),%eax
  8019ca:	83 e8 04             	sub    $0x4,%eax
  8019cd:	8b 00                	mov    (%eax),%eax
  8019cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d4:	eb 1c                	jmp    8019f2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	8b 00                	mov    (%eax),%eax
  8019db:	8d 50 04             	lea    0x4(%eax),%edx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	89 10                	mov    %edx,(%eax)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8b 00                	mov    (%eax),%eax
  8019e8:	83 e8 04             	sub    $0x4,%eax
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019fb:	7e 1c                	jle    801a19 <getint+0x25>
		return va_arg(*ap, long long);
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 50 08             	lea    0x8(%eax),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 10                	mov    %edx,(%eax)
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8b 00                	mov    (%eax),%eax
  801a0f:	83 e8 08             	sub    $0x8,%eax
  801a12:	8b 50 04             	mov    0x4(%eax),%edx
  801a15:	8b 00                	mov    (%eax),%eax
  801a17:	eb 38                	jmp    801a51 <getint+0x5d>
	else if (lflag)
  801a19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a1d:	74 1a                	je     801a39 <getint+0x45>
		return va_arg(*ap, long);
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	8b 00                	mov    (%eax),%eax
  801a24:	8d 50 04             	lea    0x4(%eax),%edx
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	89 10                	mov    %edx,(%eax)
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	8b 00                	mov    (%eax),%eax
  801a31:	83 e8 04             	sub    $0x4,%eax
  801a34:	8b 00                	mov    (%eax),%eax
  801a36:	99                   	cltd   
  801a37:	eb 18                	jmp    801a51 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	8b 00                	mov    (%eax),%eax
  801a3e:	8d 50 04             	lea    0x4(%eax),%edx
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	89 10                	mov    %edx,(%eax)
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8b 00                	mov    (%eax),%eax
  801a4b:	83 e8 04             	sub    $0x4,%eax
  801a4e:	8b 00                	mov    (%eax),%eax
  801a50:	99                   	cltd   
}
  801a51:	5d                   	pop    %ebp
  801a52:	c3                   	ret    

00801a53 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a5b:	eb 17                	jmp    801a74 <vprintfmt+0x21>
			if (ch == '\0')
  801a5d:	85 db                	test   %ebx,%ebx
  801a5f:	0f 84 c1 03 00 00    	je     801e26 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a65:	83 ec 08             	sub    $0x8,%esp
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	53                   	push   %ebx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	ff d0                	call   *%eax
  801a71:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a74:	8b 45 10             	mov    0x10(%ebp),%eax
  801a77:	8d 50 01             	lea    0x1(%eax),%edx
  801a7a:	89 55 10             	mov    %edx,0x10(%ebp)
  801a7d:	8a 00                	mov    (%eax),%al
  801a7f:	0f b6 d8             	movzbl %al,%ebx
  801a82:	83 fb 25             	cmp    $0x25,%ebx
  801a85:	75 d6                	jne    801a5d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a87:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a8b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a92:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a99:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801aa0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aaa:	8d 50 01             	lea    0x1(%eax),%edx
  801aad:	89 55 10             	mov    %edx,0x10(%ebp)
  801ab0:	8a 00                	mov    (%eax),%al
  801ab2:	0f b6 d8             	movzbl %al,%ebx
  801ab5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801ab8:	83 f8 5b             	cmp    $0x5b,%eax
  801abb:	0f 87 3d 03 00 00    	ja     801dfe <vprintfmt+0x3ab>
  801ac1:	8b 04 85 d8 47 80 00 	mov    0x8047d8(,%eax,4),%eax
  801ac8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801aca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801ace:	eb d7                	jmp    801aa7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ad0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801ad4:	eb d1                	jmp    801aa7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ad6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801add:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae0:	89 d0                	mov    %edx,%eax
  801ae2:	c1 e0 02             	shl    $0x2,%eax
  801ae5:	01 d0                	add    %edx,%eax
  801ae7:	01 c0                	add    %eax,%eax
  801ae9:	01 d8                	add    %ebx,%eax
  801aeb:	83 e8 30             	sub    $0x30,%eax
  801aee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	8a 00                	mov    (%eax),%al
  801af6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801af9:	83 fb 2f             	cmp    $0x2f,%ebx
  801afc:	7e 3e                	jle    801b3c <vprintfmt+0xe9>
  801afe:	83 fb 39             	cmp    $0x39,%ebx
  801b01:	7f 39                	jg     801b3c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b03:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b06:	eb d5                	jmp    801add <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b08:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0b:	83 c0 04             	add    $0x4,%eax
  801b0e:	89 45 14             	mov    %eax,0x14(%ebp)
  801b11:	8b 45 14             	mov    0x14(%ebp),%eax
  801b14:	83 e8 04             	sub    $0x4,%eax
  801b17:	8b 00                	mov    (%eax),%eax
  801b19:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b1c:	eb 1f                	jmp    801b3d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b22:	79 83                	jns    801aa7 <vprintfmt+0x54>
				width = 0;
  801b24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b2b:	e9 77 ff ff ff       	jmp    801aa7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b30:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b37:	e9 6b ff ff ff       	jmp    801aa7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b3c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b41:	0f 89 60 ff ff ff    	jns    801aa7 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b54:	e9 4e ff ff ff       	jmp    801aa7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b59:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b5c:	e9 46 ff ff ff       	jmp    801aa7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b61:	8b 45 14             	mov    0x14(%ebp),%eax
  801b64:	83 c0 04             	add    $0x4,%eax
  801b67:	89 45 14             	mov    %eax,0x14(%ebp)
  801b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6d:	83 e8 04             	sub    $0x4,%eax
  801b70:	8b 00                	mov    (%eax),%eax
  801b72:	83 ec 08             	sub    $0x8,%esp
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	50                   	push   %eax
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	ff d0                	call   *%eax
  801b7e:	83 c4 10             	add    $0x10,%esp
			break;
  801b81:	e9 9b 02 00 00       	jmp    801e21 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b86:	8b 45 14             	mov    0x14(%ebp),%eax
  801b89:	83 c0 04             	add    $0x4,%eax
  801b8c:	89 45 14             	mov    %eax,0x14(%ebp)
  801b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b92:	83 e8 04             	sub    $0x4,%eax
  801b95:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b97:	85 db                	test   %ebx,%ebx
  801b99:	79 02                	jns    801b9d <vprintfmt+0x14a>
				err = -err;
  801b9b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b9d:	83 fb 64             	cmp    $0x64,%ebx
  801ba0:	7f 0b                	jg     801bad <vprintfmt+0x15a>
  801ba2:	8b 34 9d 20 46 80 00 	mov    0x804620(,%ebx,4),%esi
  801ba9:	85 f6                	test   %esi,%esi
  801bab:	75 19                	jne    801bc6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801bad:	53                   	push   %ebx
  801bae:	68 c5 47 80 00       	push   $0x8047c5
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	ff 75 08             	pushl  0x8(%ebp)
  801bb9:	e8 70 02 00 00       	call   801e2e <printfmt>
  801bbe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bc1:	e9 5b 02 00 00       	jmp    801e21 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bc6:	56                   	push   %esi
  801bc7:	68 ce 47 80 00       	push   $0x8047ce
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	e8 57 02 00 00       	call   801e2e <printfmt>
  801bd7:	83 c4 10             	add    $0x10,%esp
			break;
  801bda:	e9 42 02 00 00       	jmp    801e21 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  801be2:	83 c0 04             	add    $0x4,%eax
  801be5:	89 45 14             	mov    %eax,0x14(%ebp)
  801be8:	8b 45 14             	mov    0x14(%ebp),%eax
  801beb:	83 e8 04             	sub    $0x4,%eax
  801bee:	8b 30                	mov    (%eax),%esi
  801bf0:	85 f6                	test   %esi,%esi
  801bf2:	75 05                	jne    801bf9 <vprintfmt+0x1a6>
				p = "(null)";
  801bf4:	be d1 47 80 00       	mov    $0x8047d1,%esi
			if (width > 0 && padc != '-')
  801bf9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bfd:	7e 6d                	jle    801c6c <vprintfmt+0x219>
  801bff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c03:	74 67                	je     801c6c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c08:	83 ec 08             	sub    $0x8,%esp
  801c0b:	50                   	push   %eax
  801c0c:	56                   	push   %esi
  801c0d:	e8 1e 03 00 00       	call   801f30 <strnlen>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c18:	eb 16                	jmp    801c30 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c1a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c1e:	83 ec 08             	sub    $0x8,%esp
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	50                   	push   %eax
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	ff d0                	call   *%eax
  801c2a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c2d:	ff 4d e4             	decl   -0x1c(%ebp)
  801c30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c34:	7f e4                	jg     801c1a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c36:	eb 34                	jmp    801c6c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c38:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c3c:	74 1c                	je     801c5a <vprintfmt+0x207>
  801c3e:	83 fb 1f             	cmp    $0x1f,%ebx
  801c41:	7e 05                	jle    801c48 <vprintfmt+0x1f5>
  801c43:	83 fb 7e             	cmp    $0x7e,%ebx
  801c46:	7e 12                	jle    801c5a <vprintfmt+0x207>
					putch('?', putdat);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	6a 3f                	push   $0x3f
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	ff d0                	call   *%eax
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	eb 0f                	jmp    801c69 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c5a:	83 ec 08             	sub    $0x8,%esp
  801c5d:	ff 75 0c             	pushl  0xc(%ebp)
  801c60:	53                   	push   %ebx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	ff d0                	call   *%eax
  801c66:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c69:	ff 4d e4             	decl   -0x1c(%ebp)
  801c6c:	89 f0                	mov    %esi,%eax
  801c6e:	8d 70 01             	lea    0x1(%eax),%esi
  801c71:	8a 00                	mov    (%eax),%al
  801c73:	0f be d8             	movsbl %al,%ebx
  801c76:	85 db                	test   %ebx,%ebx
  801c78:	74 24                	je     801c9e <vprintfmt+0x24b>
  801c7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c7e:	78 b8                	js     801c38 <vprintfmt+0x1e5>
  801c80:	ff 4d e0             	decl   -0x20(%ebp)
  801c83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c87:	79 af                	jns    801c38 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c89:	eb 13                	jmp    801c9e <vprintfmt+0x24b>
				putch(' ', putdat);
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	6a 20                	push   $0x20
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	ff d0                	call   *%eax
  801c98:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c9b:	ff 4d e4             	decl   -0x1c(%ebp)
  801c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ca2:	7f e7                	jg     801c8b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ca4:	e9 78 01 00 00       	jmp    801e21 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ca9:	83 ec 08             	sub    $0x8,%esp
  801cac:	ff 75 e8             	pushl  -0x18(%ebp)
  801caf:	8d 45 14             	lea    0x14(%ebp),%eax
  801cb2:	50                   	push   %eax
  801cb3:	e8 3c fd ff ff       	call   8019f4 <getint>
  801cb8:	83 c4 10             	add    $0x10,%esp
  801cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cbe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc7:	85 d2                	test   %edx,%edx
  801cc9:	79 23                	jns    801cee <vprintfmt+0x29b>
				putch('-', putdat);
  801ccb:	83 ec 08             	sub    $0x8,%esp
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	6a 2d                	push   $0x2d
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	ff d0                	call   *%eax
  801cd8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce1:	f7 d8                	neg    %eax
  801ce3:	83 d2 00             	adc    $0x0,%edx
  801ce6:	f7 da                	neg    %edx
  801ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ceb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cf5:	e9 bc 00 00 00       	jmp    801db6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cfa:	83 ec 08             	sub    $0x8,%esp
  801cfd:	ff 75 e8             	pushl  -0x18(%ebp)
  801d00:	8d 45 14             	lea    0x14(%ebp),%eax
  801d03:	50                   	push   %eax
  801d04:	e8 84 fc ff ff       	call   80198d <getuint>
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d19:	e9 98 00 00 00       	jmp    801db6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d1e:	83 ec 08             	sub    $0x8,%esp
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	6a 58                	push   $0x58
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	ff d0                	call   *%eax
  801d2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d2e:	83 ec 08             	sub    $0x8,%esp
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	6a 58                	push   $0x58
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	ff d0                	call   *%eax
  801d3b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d3e:	83 ec 08             	sub    $0x8,%esp
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	6a 58                	push   $0x58
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	ff d0                	call   *%eax
  801d4b:	83 c4 10             	add    $0x10,%esp
			break;
  801d4e:	e9 ce 00 00 00       	jmp    801e21 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d53:	83 ec 08             	sub    $0x8,%esp
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	6a 30                	push   $0x30
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	ff d0                	call   *%eax
  801d60:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	6a 78                	push   $0x78
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	ff d0                	call   *%eax
  801d70:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d73:	8b 45 14             	mov    0x14(%ebp),%eax
  801d76:	83 c0 04             	add    $0x4,%eax
  801d79:	89 45 14             	mov    %eax,0x14(%ebp)
  801d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7f:	83 e8 04             	sub    $0x4,%eax
  801d82:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d8e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d95:	eb 1f                	jmp    801db6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d97:	83 ec 08             	sub    $0x8,%esp
  801d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  801d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  801da0:	50                   	push   %eax
  801da1:	e8 e7 fb ff ff       	call   80198d <getuint>
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801daf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801db6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbd:	83 ec 04             	sub    $0x4,%esp
  801dc0:	52                   	push   %edx
  801dc1:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dc4:	50                   	push   %eax
  801dc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc8:	ff 75 f0             	pushl  -0x10(%ebp)
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	e8 00 fb ff ff       	call   8018d6 <printnum>
  801dd6:	83 c4 20             	add    $0x20,%esp
			break;
  801dd9:	eb 46                	jmp    801e21 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	ff 75 0c             	pushl  0xc(%ebp)
  801de1:	53                   	push   %ebx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	ff d0                	call   *%eax
  801de7:	83 c4 10             	add    $0x10,%esp
			break;
  801dea:	eb 35                	jmp    801e21 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801dec:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801df3:	eb 2c                	jmp    801e21 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801df5:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801dfc:	eb 23                	jmp    801e21 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801dfe:	83 ec 08             	sub    $0x8,%esp
  801e01:	ff 75 0c             	pushl  0xc(%ebp)
  801e04:	6a 25                	push   $0x25
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	ff d0                	call   *%eax
  801e0b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e0e:	ff 4d 10             	decl   0x10(%ebp)
  801e11:	eb 03                	jmp    801e16 <vprintfmt+0x3c3>
  801e13:	ff 4d 10             	decl   0x10(%ebp)
  801e16:	8b 45 10             	mov    0x10(%ebp),%eax
  801e19:	48                   	dec    %eax
  801e1a:	8a 00                	mov    (%eax),%al
  801e1c:	3c 25                	cmp    $0x25,%al
  801e1e:	75 f3                	jne    801e13 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e20:	90                   	nop
		}
	}
  801e21:	e9 35 fc ff ff       	jmp    801a5b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e26:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2a:	5b                   	pop    %ebx
  801e2b:	5e                   	pop    %esi
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    

00801e2e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e34:	8d 45 10             	lea    0x10(%ebp),%eax
  801e37:	83 c0 04             	add    $0x4,%eax
  801e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e40:	ff 75 f4             	pushl  -0xc(%ebp)
  801e43:	50                   	push   %eax
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	ff 75 08             	pushl  0x8(%ebp)
  801e4a:	e8 04 fc ff ff       	call   801a53 <vprintfmt>
  801e4f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e52:	90                   	nop
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5b:	8b 40 08             	mov    0x8(%eax),%eax
  801e5e:	8d 50 01             	lea    0x1(%eax),%edx
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6a:	8b 10                	mov    (%eax),%edx
  801e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6f:	8b 40 04             	mov    0x4(%eax),%eax
  801e72:	39 c2                	cmp    %eax,%edx
  801e74:	73 12                	jae    801e88 <sprintputch+0x33>
		*b->buf++ = ch;
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	8b 00                	mov    (%eax),%eax
  801e7b:	8d 48 01             	lea    0x1(%eax),%ecx
  801e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e81:	89 0a                	mov    %ecx,(%edx)
  801e83:	8b 55 08             	mov    0x8(%ebp),%edx
  801e86:	88 10                	mov    %dl,(%eax)
}
  801e88:	90                   	nop
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    

00801e8b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	01 d0                	add    %edx,%eax
  801ea2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ea5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801eac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eb0:	74 06                	je     801eb8 <vsnprintf+0x2d>
  801eb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eb6:	7f 07                	jg     801ebf <vsnprintf+0x34>
		return -E_INVAL;
  801eb8:	b8 03 00 00 00       	mov    $0x3,%eax
  801ebd:	eb 20                	jmp    801edf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ebf:	ff 75 14             	pushl  0x14(%ebp)
  801ec2:	ff 75 10             	pushl  0x10(%ebp)
  801ec5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ec8:	50                   	push   %eax
  801ec9:	68 55 1e 80 00       	push   $0x801e55
  801ece:	e8 80 fb ff ff       	call   801a53 <vprintfmt>
  801ed3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ee7:	8d 45 10             	lea    0x10(%ebp),%eax
  801eea:	83 c0 04             	add    $0x4,%eax
  801eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ef0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef6:	50                   	push   %eax
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	ff 75 08             	pushl  0x8(%ebp)
  801efd:	e8 89 ff ff ff       	call   801e8b <vsnprintf>
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f1a:	eb 06                	jmp    801f22 <strlen+0x15>
		n++;
  801f1c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f1f:	ff 45 08             	incl   0x8(%ebp)
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	8a 00                	mov    (%eax),%al
  801f27:	84 c0                	test   %al,%al
  801f29:	75 f1                	jne    801f1c <strlen+0xf>
		n++;
	return n;
  801f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f3d:	eb 09                	jmp    801f48 <strnlen+0x18>
		n++;
  801f3f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f42:	ff 45 08             	incl   0x8(%ebp)
  801f45:	ff 4d 0c             	decl   0xc(%ebp)
  801f48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f4c:	74 09                	je     801f57 <strnlen+0x27>
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	8a 00                	mov    (%eax),%al
  801f53:	84 c0                	test   %al,%al
  801f55:	75 e8                	jne    801f3f <strnlen+0xf>
		n++;
	return n;
  801f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f68:	90                   	nop
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	8d 50 01             	lea    0x1(%eax),%edx
  801f6f:	89 55 08             	mov    %edx,0x8(%ebp)
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f78:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f7b:	8a 12                	mov    (%edx),%dl
  801f7d:	88 10                	mov    %dl,(%eax)
  801f7f:	8a 00                	mov    (%eax),%al
  801f81:	84 c0                	test   %al,%al
  801f83:	75 e4                	jne    801f69 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f9d:	eb 1f                	jmp    801fbe <strncpy+0x34>
		*dst++ = *src;
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	8d 50 01             	lea    0x1(%eax),%edx
  801fa5:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fab:	8a 12                	mov    (%edx),%dl
  801fad:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb2:	8a 00                	mov    (%eax),%al
  801fb4:	84 c0                	test   %al,%al
  801fb6:	74 03                	je     801fbb <strncpy+0x31>
			src++;
  801fb8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fbb:	ff 45 fc             	incl   -0x4(%ebp)
  801fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc1:	3b 45 10             	cmp    0x10(%ebp),%eax
  801fc4:	72 d9                	jb     801f9f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801fd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fdb:	74 30                	je     80200d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801fdd:	eb 16                	jmp    801ff5 <strlcpy+0x2a>
			*dst++ = *src++;
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	8d 50 01             	lea    0x1(%eax),%edx
  801fe5:	89 55 08             	mov    %edx,0x8(%ebp)
  801fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801feb:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ff1:	8a 12                	mov    (%edx),%dl
  801ff3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801ff5:	ff 4d 10             	decl   0x10(%ebp)
  801ff8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ffc:	74 09                	je     802007 <strlcpy+0x3c>
  801ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802001:	8a 00                	mov    (%eax),%al
  802003:	84 c0                	test   %al,%al
  802005:	75 d8                	jne    801fdf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80200d:	8b 55 08             	mov    0x8(%ebp),%edx
  802010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802013:	29 c2                	sub    %eax,%edx
  802015:	89 d0                	mov    %edx,%eax
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80201c:	eb 06                	jmp    802024 <strcmp+0xb>
		p++, q++;
  80201e:	ff 45 08             	incl   0x8(%ebp)
  802021:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 00                	mov    (%eax),%al
  802029:	84 c0                	test   %al,%al
  80202b:	74 0e                	je     80203b <strcmp+0x22>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 10                	mov    (%eax),%dl
  802032:	8b 45 0c             	mov    0xc(%ebp),%eax
  802035:	8a 00                	mov    (%eax),%al
  802037:	38 c2                	cmp    %al,%dl
  802039:	74 e3                	je     80201e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	8a 00                	mov    (%eax),%al
  802040:	0f b6 d0             	movzbl %al,%edx
  802043:	8b 45 0c             	mov    0xc(%ebp),%eax
  802046:	8a 00                	mov    (%eax),%al
  802048:	0f b6 c0             	movzbl %al,%eax
  80204b:	29 c2                	sub    %eax,%edx
  80204d:	89 d0                	mov    %edx,%eax
}
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802054:	eb 09                	jmp    80205f <strncmp+0xe>
		n--, p++, q++;
  802056:	ff 4d 10             	decl   0x10(%ebp)
  802059:	ff 45 08             	incl   0x8(%ebp)
  80205c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80205f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802063:	74 17                	je     80207c <strncmp+0x2b>
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8a 00                	mov    (%eax),%al
  80206a:	84 c0                	test   %al,%al
  80206c:	74 0e                	je     80207c <strncmp+0x2b>
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	8a 10                	mov    (%eax),%dl
  802073:	8b 45 0c             	mov    0xc(%ebp),%eax
  802076:	8a 00                	mov    (%eax),%al
  802078:	38 c2                	cmp    %al,%dl
  80207a:	74 da                	je     802056 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80207c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802080:	75 07                	jne    802089 <strncmp+0x38>
		return 0;
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
  802087:	eb 14                	jmp    80209d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	8a 00                	mov    (%eax),%al
  80208e:	0f b6 d0             	movzbl %al,%edx
  802091:	8b 45 0c             	mov    0xc(%ebp),%eax
  802094:	8a 00                	mov    (%eax),%al
  802096:	0f b6 c0             	movzbl %al,%eax
  802099:	29 c2                	sub    %eax,%edx
  80209b:	89 d0                	mov    %edx,%eax
}
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    

0080209f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020ab:	eb 12                	jmp    8020bf <strchr+0x20>
		if (*s == c)
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8a 00                	mov    (%eax),%al
  8020b2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020b5:	75 05                	jne    8020bc <strchr+0x1d>
			return (char *) s;
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	eb 11                	jmp    8020cd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020bc:	ff 45 08             	incl   0x8(%ebp)
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	8a 00                	mov    (%eax),%al
  8020c4:	84 c0                	test   %al,%al
  8020c6:	75 e5                	jne    8020ad <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020db:	eb 0d                	jmp    8020ea <strfind+0x1b>
		if (*s == c)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8a 00                	mov    (%eax),%al
  8020e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020e5:	74 0e                	je     8020f5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020e7:	ff 45 08             	incl   0x8(%ebp)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	84 c0                	test   %al,%al
  8020f1:	75 ea                	jne    8020dd <strfind+0xe>
  8020f3:	eb 01                	jmp    8020f6 <strfind+0x27>
		if (*s == c)
			break;
  8020f5:	90                   	nop
	return (char *) s;
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802107:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80210b:	76 63                	jbe    802170 <memset+0x75>
		uint64 data_block = c;
  80210d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802110:	99                   	cltd   
  802111:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802114:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802121:	c1 e0 08             	shl    $0x8,%eax
  802124:	09 45 f0             	or     %eax,-0x10(%ebp)
  802127:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80212a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802134:	c1 e0 10             	shl    $0x10,%eax
  802137:	09 45 f0             	or     %eax,-0x10(%ebp)
  80213a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80213d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802143:	89 c2                	mov    %eax,%edx
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
  80214a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80214d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  802150:	eb 18                	jmp    80216a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802152:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802155:	8d 41 08             	lea    0x8(%ecx),%eax
  802158:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802161:	89 01                	mov    %eax,(%ecx)
  802163:	89 51 04             	mov    %edx,0x4(%ecx)
  802166:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80216a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80216e:	77 e2                	ja     802152 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  802170:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802174:	74 23                	je     802199 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802179:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80217c:	eb 0e                	jmp    80218c <memset+0x91>
			*p8++ = (uint8)c;
  80217e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802181:	8d 50 01             	lea    0x1(%eax),%edx
  802184:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80218c:	8b 45 10             	mov    0x10(%ebp),%eax
  80218f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802192:	89 55 10             	mov    %edx,0x10(%ebp)
  802195:	85 c0                	test   %eax,%eax
  802197:	75 e5                	jne    80217e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8021a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8021b0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021b4:	76 24                	jbe    8021da <memcpy+0x3c>
		while(n >= 8){
  8021b6:	eb 1c                	jmp    8021d4 <memcpy+0x36>
			*d64 = *s64;
  8021b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021bb:	8b 50 04             	mov    0x4(%eax),%edx
  8021be:	8b 00                	mov    (%eax),%eax
  8021c0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021c3:	89 01                	mov    %eax,(%ecx)
  8021c5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8021c8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8021cc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8021d0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8021d4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021d8:	77 de                	ja     8021b8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8021da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021de:	74 31                	je     802211 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8021e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8021e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8021ec:	eb 16                	jmp    802204 <memcpy+0x66>
			*d8++ = *s8++;
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	8d 50 01             	lea    0x1(%eax),%edx
  8021f4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8021f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021fd:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802200:	8a 12                	mov    (%edx),%dl
  802202:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802204:	8b 45 10             	mov    0x10(%ebp),%eax
  802207:	8d 50 ff             	lea    -0x1(%eax),%edx
  80220a:	89 55 10             	mov    %edx,0x10(%ebp)
  80220d:	85 c0                	test   %eax,%eax
  80220f:	75 dd                	jne    8021ee <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80221c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802228:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80222e:	73 50                	jae    802280 <memmove+0x6a>
  802230:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802233:	8b 45 10             	mov    0x10(%ebp),%eax
  802236:	01 d0                	add    %edx,%eax
  802238:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80223b:	76 43                	jbe    802280 <memmove+0x6a>
		s += n;
  80223d:	8b 45 10             	mov    0x10(%ebp),%eax
  802240:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802249:	eb 10                	jmp    80225b <memmove+0x45>
			*--d = *--s;
  80224b:	ff 4d f8             	decl   -0x8(%ebp)
  80224e:	ff 4d fc             	decl   -0x4(%ebp)
  802251:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802254:	8a 10                	mov    (%eax),%dl
  802256:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802259:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80225b:	8b 45 10             	mov    0x10(%ebp),%eax
  80225e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802261:	89 55 10             	mov    %edx,0x10(%ebp)
  802264:	85 c0                	test   %eax,%eax
  802266:	75 e3                	jne    80224b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802268:	eb 23                	jmp    80228d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80226a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80226d:	8d 50 01             	lea    0x1(%eax),%edx
  802270:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802273:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802276:	8d 4a 01             	lea    0x1(%edx),%ecx
  802279:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80227c:	8a 12                	mov    (%edx),%dl
  80227e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802280:	8b 45 10             	mov    0x10(%ebp),%eax
  802283:	8d 50 ff             	lea    -0x1(%eax),%edx
  802286:	89 55 10             	mov    %edx,0x10(%ebp)
  802289:	85 c0                	test   %eax,%eax
  80228b:	75 dd                	jne    80226a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80229e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8022a4:	eb 2a                	jmp    8022d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8022a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022a9:	8a 10                	mov    (%eax),%dl
  8022ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022ae:	8a 00                	mov    (%eax),%al
  8022b0:	38 c2                	cmp    %al,%dl
  8022b2:	74 16                	je     8022ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8022b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022b7:	8a 00                	mov    (%eax),%al
  8022b9:	0f b6 d0             	movzbl %al,%edx
  8022bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022bf:	8a 00                	mov    (%eax),%al
  8022c1:	0f b6 c0             	movzbl %al,%eax
  8022c4:	29 c2                	sub    %eax,%edx
  8022c6:	89 d0                	mov    %edx,%eax
  8022c8:	eb 18                	jmp    8022e2 <memcmp+0x50>
		s1++, s2++;
  8022ca:	ff 45 fc             	incl   -0x4(%ebp)
  8022cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8022d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	75 c9                	jne    8022a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8022ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f0:	01 d0                	add    %edx,%eax
  8022f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8022f5:	eb 15                	jmp    80230c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8a 00                	mov    (%eax),%al
  8022fc:	0f b6 d0             	movzbl %al,%edx
  8022ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802302:	0f b6 c0             	movzbl %al,%eax
  802305:	39 c2                	cmp    %eax,%edx
  802307:	74 0d                	je     802316 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802309:	ff 45 08             	incl   0x8(%ebp)
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802312:	72 e3                	jb     8022f7 <memfind+0x13>
  802314:	eb 01                	jmp    802317 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802316:	90                   	nop
	return (void *) s;
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802322:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802329:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802330:	eb 03                	jmp    802335 <strtol+0x19>
		s++;
  802332:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8a 00                	mov    (%eax),%al
  80233a:	3c 20                	cmp    $0x20,%al
  80233c:	74 f4                	je     802332 <strtol+0x16>
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	8a 00                	mov    (%eax),%al
  802343:	3c 09                	cmp    $0x9,%al
  802345:	74 eb                	je     802332 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	8a 00                	mov    (%eax),%al
  80234c:	3c 2b                	cmp    $0x2b,%al
  80234e:	75 05                	jne    802355 <strtol+0x39>
		s++;
  802350:	ff 45 08             	incl   0x8(%ebp)
  802353:	eb 13                	jmp    802368 <strtol+0x4c>
	else if (*s == '-')
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	8a 00                	mov    (%eax),%al
  80235a:	3c 2d                	cmp    $0x2d,%al
  80235c:	75 0a                	jne    802368 <strtol+0x4c>
		s++, neg = 1;
  80235e:	ff 45 08             	incl   0x8(%ebp)
  802361:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802368:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80236c:	74 06                	je     802374 <strtol+0x58>
  80236e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802372:	75 20                	jne    802394 <strtol+0x78>
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8a 00                	mov    (%eax),%al
  802379:	3c 30                	cmp    $0x30,%al
  80237b:	75 17                	jne    802394 <strtol+0x78>
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	40                   	inc    %eax
  802381:	8a 00                	mov    (%eax),%al
  802383:	3c 78                	cmp    $0x78,%al
  802385:	75 0d                	jne    802394 <strtol+0x78>
		s += 2, base = 16;
  802387:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80238b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802392:	eb 28                	jmp    8023bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802398:	75 15                	jne    8023af <strtol+0x93>
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	8a 00                	mov    (%eax),%al
  80239f:	3c 30                	cmp    $0x30,%al
  8023a1:	75 0c                	jne    8023af <strtol+0x93>
		s++, base = 8;
  8023a3:	ff 45 08             	incl   0x8(%ebp)
  8023a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8023ad:	eb 0d                	jmp    8023bc <strtol+0xa0>
	else if (base == 0)
  8023af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023b3:	75 07                	jne    8023bc <strtol+0xa0>
		base = 10;
  8023b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8a 00                	mov    (%eax),%al
  8023c1:	3c 2f                	cmp    $0x2f,%al
  8023c3:	7e 19                	jle    8023de <strtol+0xc2>
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	8a 00                	mov    (%eax),%al
  8023ca:	3c 39                	cmp    $0x39,%al
  8023cc:	7f 10                	jg     8023de <strtol+0xc2>
			dig = *s - '0';
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	8a 00                	mov    (%eax),%al
  8023d3:	0f be c0             	movsbl %al,%eax
  8023d6:	83 e8 30             	sub    $0x30,%eax
  8023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023dc:	eb 42                	jmp    802420 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	8a 00                	mov    (%eax),%al
  8023e3:	3c 60                	cmp    $0x60,%al
  8023e5:	7e 19                	jle    802400 <strtol+0xe4>
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	8a 00                	mov    (%eax),%al
  8023ec:	3c 7a                	cmp    $0x7a,%al
  8023ee:	7f 10                	jg     802400 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	8a 00                	mov    (%eax),%al
  8023f5:	0f be c0             	movsbl %al,%eax
  8023f8:	83 e8 57             	sub    $0x57,%eax
  8023fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fe:	eb 20                	jmp    802420 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	8a 00                	mov    (%eax),%al
  802405:	3c 40                	cmp    $0x40,%al
  802407:	7e 39                	jle    802442 <strtol+0x126>
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	8a 00                	mov    (%eax),%al
  80240e:	3c 5a                	cmp    $0x5a,%al
  802410:	7f 30                	jg     802442 <strtol+0x126>
			dig = *s - 'A' + 10;
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8a 00                	mov    (%eax),%al
  802417:	0f be c0             	movsbl %al,%eax
  80241a:	83 e8 37             	sub    $0x37,%eax
  80241d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	3b 45 10             	cmp    0x10(%ebp),%eax
  802426:	7d 19                	jge    802441 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802428:	ff 45 08             	incl   0x8(%ebp)
  80242b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80242e:	0f af 45 10          	imul   0x10(%ebp),%eax
  802432:	89 c2                	mov    %eax,%edx
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	01 d0                	add    %edx,%eax
  802439:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80243c:	e9 7b ff ff ff       	jmp    8023bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802441:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802442:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802446:	74 08                	je     802450 <strtol+0x134>
		*endptr = (char *) s;
  802448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244b:	8b 55 08             	mov    0x8(%ebp),%edx
  80244e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802450:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802454:	74 07                	je     80245d <strtol+0x141>
  802456:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802459:	f7 d8                	neg    %eax
  80245b:	eb 03                	jmp    802460 <strtol+0x144>
  80245d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <ltostr>:

void
ltostr(long value, char *str)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80246f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802476:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247a:	79 13                	jns    80248f <ltostr+0x2d>
	{
		neg = 1;
  80247c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802483:	8b 45 0c             	mov    0xc(%ebp),%eax
  802486:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802489:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80248c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802497:	99                   	cltd   
  802498:	f7 f9                	idiv   %ecx
  80249a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80249d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a0:	8d 50 01             	lea    0x1(%eax),%edx
  8024a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024a6:	89 c2                	mov    %eax,%edx
  8024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ab:	01 d0                	add    %edx,%eax
  8024ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b0:	83 c2 30             	add    $0x30,%edx
  8024b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8024b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8024bd:	f7 e9                	imul   %ecx
  8024bf:	c1 fa 02             	sar    $0x2,%edx
  8024c2:	89 c8                	mov    %ecx,%eax
  8024c4:	c1 f8 1f             	sar    $0x1f,%eax
  8024c7:	29 c2                	sub    %eax,%edx
  8024c9:	89 d0                	mov    %edx,%eax
  8024cb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8024ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024d2:	75 bb                	jne    80248f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8024d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8024db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024de:	48                   	dec    %eax
  8024df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8024e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024e6:	74 3d                	je     802525 <ltostr+0xc3>
		start = 1 ;
  8024e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8024ef:	eb 34                	jmp    802525 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8024f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f7:	01 d0                	add    %edx,%eax
  8024f9:	8a 00                	mov    (%eax),%al
  8024fb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8024fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802501:	8b 45 0c             	mov    0xc(%ebp),%eax
  802504:	01 c2                	add    %eax,%edx
  802506:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802509:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250c:	01 c8                	add    %ecx,%eax
  80250e:	8a 00                	mov    (%eax),%al
  802510:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802515:	8b 45 0c             	mov    0xc(%ebp),%eax
  802518:	01 c2                	add    %eax,%edx
  80251a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80251d:	88 02                	mov    %al,(%edx)
		start++ ;
  80251f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802522:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80252b:	7c c4                	jl     8024f1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80252d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802530:	8b 45 0c             	mov    0xc(%ebp),%eax
  802533:	01 d0                	add    %edx,%eax
  802535:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802538:	90                   	nop
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802541:	ff 75 08             	pushl  0x8(%ebp)
  802544:	e8 c4 f9 ff ff       	call   801f0d <strlen>
  802549:	83 c4 04             	add    $0x4,%esp
  80254c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80254f:	ff 75 0c             	pushl  0xc(%ebp)
  802552:	e8 b6 f9 ff ff       	call   801f0d <strlen>
  802557:	83 c4 04             	add    $0x4,%esp
  80255a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80255d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802564:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80256b:	eb 17                	jmp    802584 <strcconcat+0x49>
		final[s] = str1[s] ;
  80256d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802570:	8b 45 10             	mov    0x10(%ebp),%eax
  802573:	01 c2                	add    %eax,%edx
  802575:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	01 c8                	add    %ecx,%eax
  80257d:	8a 00                	mov    (%eax),%al
  80257f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802581:	ff 45 fc             	incl   -0x4(%ebp)
  802584:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802587:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80258a:	7c e1                	jl     80256d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80258c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802593:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80259a:	eb 1f                	jmp    8025bb <strcconcat+0x80>
		final[s++] = str2[i] ;
  80259c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80259f:	8d 50 01             	lea    0x1(%eax),%edx
  8025a2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8025a5:	89 c2                	mov    %eax,%edx
  8025a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025aa:	01 c2                	add    %eax,%edx
  8025ac:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8025af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b2:	01 c8                	add    %ecx,%eax
  8025b4:	8a 00                	mov    (%eax),%al
  8025b6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8025b8:	ff 45 f8             	incl   -0x8(%ebp)
  8025bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c1:	7c d9                	jl     80259c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8025c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c9:	01 d0                	add    %edx,%eax
  8025cb:	c6 00 00             	movb   $0x0,(%eax)
}
  8025ce:	90                   	nop
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8025d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8025d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8025dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8025f4:	eb 0c                	jmp    802602 <strsplit+0x31>
			*string++ = 0;
  8025f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f9:	8d 50 01             	lea    0x1(%eax),%edx
  8025fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8025ff:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	8a 00                	mov    (%eax),%al
  802607:	84 c0                	test   %al,%al
  802609:	74 18                	je     802623 <strsplit+0x52>
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	8a 00                	mov    (%eax),%al
  802610:	0f be c0             	movsbl %al,%eax
  802613:	50                   	push   %eax
  802614:	ff 75 0c             	pushl  0xc(%ebp)
  802617:	e8 83 fa ff ff       	call   80209f <strchr>
  80261c:	83 c4 08             	add    $0x8,%esp
  80261f:	85 c0                	test   %eax,%eax
  802621:	75 d3                	jne    8025f6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	8a 00                	mov    (%eax),%al
  802628:	84 c0                	test   %al,%al
  80262a:	74 5a                	je     802686 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80262c:	8b 45 14             	mov    0x14(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	83 f8 0f             	cmp    $0xf,%eax
  802634:	75 07                	jne    80263d <strsplit+0x6c>
		{
			return 0;
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
  80263b:	eb 66                	jmp    8026a3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80263d:	8b 45 14             	mov    0x14(%ebp),%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	8d 48 01             	lea    0x1(%eax),%ecx
  802645:	8b 55 14             	mov    0x14(%ebp),%edx
  802648:	89 0a                	mov    %ecx,(%edx)
  80264a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802651:	8b 45 10             	mov    0x10(%ebp),%eax
  802654:	01 c2                	add    %eax,%edx
  802656:	8b 45 08             	mov    0x8(%ebp),%eax
  802659:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80265b:	eb 03                	jmp    802660 <strsplit+0x8f>
			string++;
  80265d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	8a 00                	mov    (%eax),%al
  802665:	84 c0                	test   %al,%al
  802667:	74 8b                	je     8025f4 <strsplit+0x23>
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8a 00                	mov    (%eax),%al
  80266e:	0f be c0             	movsbl %al,%eax
  802671:	50                   	push   %eax
  802672:	ff 75 0c             	pushl  0xc(%ebp)
  802675:	e8 25 fa ff ff       	call   80209f <strchr>
  80267a:	83 c4 08             	add    $0x8,%esp
  80267d:	85 c0                	test   %eax,%eax
  80267f:	74 dc                	je     80265d <strsplit+0x8c>
			string++;
	}
  802681:	e9 6e ff ff ff       	jmp    8025f4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802686:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802687:	8b 45 14             	mov    0x14(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802693:	8b 45 10             	mov    0x10(%ebp),%eax
  802696:	01 d0                	add    %edx,%eax
  802698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80269e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8026b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8026b8:	eb 4a                	jmp    802704 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8026ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	01 c2                	add    %eax,%edx
  8026c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c8:	01 c8                	add    %ecx,%eax
  8026ca:	8a 00                	mov    (%eax),%al
  8026cc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8026ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d4:	01 d0                	add    %edx,%eax
  8026d6:	8a 00                	mov    (%eax),%al
  8026d8:	3c 40                	cmp    $0x40,%al
  8026da:	7e 25                	jle    802701 <str2lower+0x5c>
  8026dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	8a 00                	mov    (%eax),%al
  8026e6:	3c 5a                	cmp    $0x5a,%al
  8026e8:	7f 17                	jg     802701 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8026ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	01 d0                	add    %edx,%eax
  8026f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f8:	01 ca                	add    %ecx,%edx
  8026fa:	8a 12                	mov    (%edx),%dl
  8026fc:	83 c2 20             	add    $0x20,%edx
  8026ff:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802701:	ff 45 fc             	incl   -0x4(%ebp)
  802704:	ff 75 0c             	pushl  0xc(%ebp)
  802707:	e8 01 f8 ff ff       	call   801f0d <strlen>
  80270c:	83 c4 04             	add    $0x4,%esp
  80270f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802712:	7f a6                	jg     8026ba <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802714:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80271f:	a1 08 50 80 00       	mov    0x805008,%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	74 42                	je     80276a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802728:	83 ec 08             	sub    $0x8,%esp
  80272b:	68 00 00 00 82       	push   $0x82000000
  802730:	68 00 00 00 80       	push   $0x80000000
  802735:	e8 00 08 00 00       	call   802f3a <initialize_dynamic_allocator>
  80273a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80273d:	e8 e7 05 00 00       	call   802d29 <sys_get_uheap_strategy>
  802742:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802747:	a1 20 52 80 00       	mov    0x805220,%eax
  80274c:	05 00 10 00 00       	add    $0x1000,%eax
  802751:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802756:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  80275b:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  802760:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802767:	00 00 00 
	}
}
  80276a:	90                   	nop
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
  802770:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802781:	83 ec 08             	sub    $0x8,%esp
  802784:	68 06 04 00 00       	push   $0x406
  802789:	50                   	push   %eax
  80278a:	e8 e4 01 00 00       	call   802973 <__sys_allocate_page>
  80278f:	83 c4 10             	add    $0x10,%esp
  802792:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802799:	79 14                	jns    8027af <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	68 48 49 80 00       	push   $0x804948
  8027a3:	6a 1f                	push   $0x1f
  8027a5:	68 84 49 80 00       	push   $0x804984
  8027aa:	e8 b7 ed ff ff       	call   801566 <_panic>
	return 0;
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	50                   	push   %eax
  8027ce:	e8 e7 01 00 00       	call   8029ba <__sys_unmap_frame>
  8027d3:	83 c4 10             	add    $0x10,%esp
  8027d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8027d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027dd:	79 14                	jns    8027f3 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8027df:	83 ec 04             	sub    $0x4,%esp
  8027e2:	68 90 49 80 00       	push   $0x804990
  8027e7:	6a 2a                	push   $0x2a
  8027e9:	68 84 49 80 00       	push   $0x804984
  8027ee:	e8 73 ed ff ff       	call   801566 <_panic>
}
  8027f3:	90                   	nop
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027fc:	e8 18 ff ff ff       	call   802719 <uheap_init>
	if (size == 0) return NULL ;
  802801:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802805:	75 07                	jne    80280e <malloc+0x18>
  802807:	b8 00 00 00 00       	mov    $0x0,%eax
  80280c:	eb 14                	jmp    802822 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80280e:	83 ec 04             	sub    $0x4,%esp
  802811:	68 d0 49 80 00       	push   $0x8049d0
  802816:	6a 3e                	push   $0x3e
  802818:	68 84 49 80 00       	push   $0x804984
  80281d:	e8 44 ed ff ff       	call   801566 <_panic>
}
  802822:	c9                   	leave  
  802823:	c3                   	ret    

00802824 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802824:	55                   	push   %ebp
  802825:	89 e5                	mov    %esp,%ebp
  802827:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 f8 49 80 00       	push   $0x8049f8
  802832:	6a 49                	push   $0x49
  802834:	68 84 49 80 00       	push   $0x804984
  802839:	e8 28 ed ff ff       	call   801566 <_panic>

0080283e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
  802841:	83 ec 18             	sub    $0x18,%esp
  802844:	8b 45 10             	mov    0x10(%ebp),%eax
  802847:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80284a:	e8 ca fe ff ff       	call   802719 <uheap_init>
	if (size == 0) return NULL ;
  80284f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802853:	75 07                	jne    80285c <smalloc+0x1e>
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
  80285a:	eb 14                	jmp    802870 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80285c:	83 ec 04             	sub    $0x4,%esp
  80285f:	68 1c 4a 80 00       	push   $0x804a1c
  802864:	6a 5a                	push   $0x5a
  802866:	68 84 49 80 00       	push   $0x804984
  80286b:	e8 f6 ec ff ff       	call   801566 <_panic>
}
  802870:	c9                   	leave  
  802871:	c3                   	ret    

00802872 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
  802875:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802878:	e8 9c fe ff ff       	call   802719 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 44 4a 80 00       	push   $0x804a44
  802885:	6a 6a                	push   $0x6a
  802887:	68 84 49 80 00       	push   $0x804984
  80288c:	e8 d5 ec ff ff       	call   801566 <_panic>

00802891 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
  802894:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802897:	e8 7d fe ff ff       	call   802719 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80289c:	83 ec 04             	sub    $0x4,%esp
  80289f:	68 68 4a 80 00       	push   $0x804a68
  8028a4:	68 88 00 00 00       	push   $0x88
  8028a9:	68 84 49 80 00       	push   $0x804984
  8028ae:	e8 b3 ec ff ff       	call   801566 <_panic>

008028b3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	68 90 4a 80 00       	push   $0x804a90
  8028c1:	68 9b 00 00 00       	push   $0x9b
  8028c6:	68 84 49 80 00       	push   $0x804984
  8028cb:	e8 96 ec ff ff       	call   801566 <_panic>

008028d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
  8028d3:	57                   	push   %edi
  8028d4:	56                   	push   %esi
  8028d5:	53                   	push   %ebx
  8028d6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028e5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8028e8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8028eb:	cd 30                	int    $0x30
  8028ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8028f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8028f3:	83 c4 10             	add    $0x10,%esp
  8028f6:	5b                   	pop    %ebx
  8028f7:	5e                   	pop    %esi
  8028f8:	5f                   	pop    %edi
  8028f9:	5d                   	pop    %ebp
  8028fa:	c3                   	ret    

008028fb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8028fb:	55                   	push   %ebp
  8028fc:	89 e5                	mov    %esp,%ebp
  8028fe:	83 ec 04             	sub    $0x4,%esp
  802901:	8b 45 10             	mov    0x10(%ebp),%eax
  802904:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802907:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80290a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	6a 00                	push   $0x0
  802913:	51                   	push   %ecx
  802914:	52                   	push   %edx
  802915:	ff 75 0c             	pushl  0xc(%ebp)
  802918:	50                   	push   %eax
  802919:	6a 00                	push   $0x0
  80291b:	e8 b0 ff ff ff       	call   8028d0 <syscall>
  802920:	83 c4 18             	add    $0x18,%esp
}
  802923:	90                   	nop
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <sys_cgetc>:

int
sys_cgetc(void)
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 02                	push   $0x2
  802935:	e8 96 ff ff ff       	call   8028d0 <syscall>
  80293a:	83 c4 18             	add    $0x18,%esp
}
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    

0080293f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	6a 03                	push   $0x3
  80294e:	e8 7d ff ff ff       	call   8028d0 <syscall>
  802953:	83 c4 18             	add    $0x18,%esp
}
  802956:	90                   	nop
  802957:	c9                   	leave  
  802958:	c3                   	ret    

00802959 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802959:	55                   	push   %ebp
  80295a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	6a 04                	push   $0x4
  802968:	e8 63 ff ff ff       	call   8028d0 <syscall>
  80296d:	83 c4 18             	add    $0x18,%esp
}
  802970:	90                   	nop
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802976:	8b 55 0c             	mov    0xc(%ebp),%edx
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	52                   	push   %edx
  802983:	50                   	push   %eax
  802984:	6a 08                	push   $0x8
  802986:	e8 45 ff ff ff       	call   8028d0 <syscall>
  80298b:	83 c4 18             	add    $0x18,%esp
}
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	56                   	push   %esi
  802994:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802995:	8b 75 18             	mov    0x18(%ebp),%esi
  802998:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80299b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80299e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	56                   	push   %esi
  8029a5:	53                   	push   %ebx
  8029a6:	51                   	push   %ecx
  8029a7:	52                   	push   %edx
  8029a8:	50                   	push   %eax
  8029a9:	6a 09                	push   $0x9
  8029ab:	e8 20 ff ff ff       	call   8028d0 <syscall>
  8029b0:	83 c4 18             	add    $0x18,%esp
}
  8029b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029b6:	5b                   	pop    %ebx
  8029b7:	5e                   	pop    %esi
  8029b8:	5d                   	pop    %ebp
  8029b9:	c3                   	ret    

008029ba <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	ff 75 08             	pushl  0x8(%ebp)
  8029c8:	6a 0a                	push   $0xa
  8029ca:	e8 01 ff ff ff       	call   8028d0 <syscall>
  8029cf:	83 c4 18             	add    $0x18,%esp
}
  8029d2:	c9                   	leave  
  8029d3:	c3                   	ret    

008029d4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8029d4:	55                   	push   %ebp
  8029d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8029d7:	6a 00                	push   $0x0
  8029d9:	6a 00                	push   $0x0
  8029db:	6a 00                	push   $0x0
  8029dd:	ff 75 0c             	pushl  0xc(%ebp)
  8029e0:	ff 75 08             	pushl  0x8(%ebp)
  8029e3:	6a 0b                	push   $0xb
  8029e5:	e8 e6 fe ff ff       	call   8028d0 <syscall>
  8029ea:	83 c4 18             	add    $0x18,%esp
}
  8029ed:	c9                   	leave  
  8029ee:	c3                   	ret    

008029ef <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8029ef:	55                   	push   %ebp
  8029f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 0c                	push   $0xc
  8029fe:	e8 cd fe ff ff       	call   8028d0 <syscall>
  802a03:	83 c4 18             	add    $0x18,%esp
}
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a0b:	6a 00                	push   $0x0
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 0d                	push   $0xd
  802a17:	e8 b4 fe ff ff       	call   8028d0 <syscall>
  802a1c:	83 c4 18             	add    $0x18,%esp
}
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    

00802a21 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802a21:	55                   	push   %ebp
  802a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802a24:	6a 00                	push   $0x0
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	6a 00                	push   $0x0
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 0e                	push   $0xe
  802a30:	e8 9b fe ff ff       	call   8028d0 <syscall>
  802a35:	83 c4 18             	add    $0x18,%esp
}
  802a38:	c9                   	leave  
  802a39:	c3                   	ret    

00802a3a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802a3a:	55                   	push   %ebp
  802a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802a3d:	6a 00                	push   $0x0
  802a3f:	6a 00                	push   $0x0
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 0f                	push   $0xf
  802a49:	e8 82 fe ff ff       	call   8028d0 <syscall>
  802a4e:	83 c4 18             	add    $0x18,%esp
}
  802a51:	c9                   	leave  
  802a52:	c3                   	ret    

00802a53 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802a53:	55                   	push   %ebp
  802a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802a56:	6a 00                	push   $0x0
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	6a 00                	push   $0x0
  802a5e:	ff 75 08             	pushl  0x8(%ebp)
  802a61:	6a 10                	push   $0x10
  802a63:	e8 68 fe ff ff       	call   8028d0 <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <sys_scarce_memory>:

void sys_scarce_memory()
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 11                	push   $0x11
  802a7c:	e8 4f fe ff ff       	call   8028d0 <syscall>
  802a81:	83 c4 18             	add    $0x18,%esp
}
  802a84:	90                   	nop
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <sys_cputc>:

void
sys_cputc(const char c)
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 04             	sub    $0x4,%esp
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a93:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	50                   	push   %eax
  802aa0:	6a 01                	push   $0x1
  802aa2:	e8 29 fe ff ff       	call   8028d0 <syscall>
  802aa7:	83 c4 18             	add    $0x18,%esp
}
  802aaa:	90                   	nop
  802aab:	c9                   	leave  
  802aac:	c3                   	ret    

00802aad <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802aad:	55                   	push   %ebp
  802aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 00                	push   $0x0
  802aba:	6a 14                	push   $0x14
  802abc:	e8 0f fe ff ff       	call   8028d0 <syscall>
  802ac1:	83 c4 18             	add    $0x18,%esp
}
  802ac4:	90                   	nop
  802ac5:	c9                   	leave  
  802ac6:	c3                   	ret    

00802ac7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ac7:	55                   	push   %ebp
  802ac8:	89 e5                	mov    %esp,%ebp
  802aca:	83 ec 04             	sub    $0x4,%esp
  802acd:	8b 45 10             	mov    0x10(%ebp),%eax
  802ad0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ad3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ad6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	6a 00                	push   $0x0
  802adf:	51                   	push   %ecx
  802ae0:	52                   	push   %edx
  802ae1:	ff 75 0c             	pushl  0xc(%ebp)
  802ae4:	50                   	push   %eax
  802ae5:	6a 15                	push   $0x15
  802ae7:	e8 e4 fd ff ff       	call   8028d0 <syscall>
  802aec:	83 c4 18             	add    $0x18,%esp
}
  802aef:	c9                   	leave  
  802af0:	c3                   	ret    

00802af1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802af1:	55                   	push   %ebp
  802af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	6a 00                	push   $0x0
  802afc:	6a 00                	push   $0x0
  802afe:	6a 00                	push   $0x0
  802b00:	52                   	push   %edx
  802b01:	50                   	push   %eax
  802b02:	6a 16                	push   $0x16
  802b04:	e8 c7 fd ff ff       	call   8028d0 <syscall>
  802b09:	83 c4 18             	add    $0x18,%esp
}
  802b0c:	c9                   	leave  
  802b0d:	c3                   	ret    

00802b0e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802b0e:	55                   	push   %ebp
  802b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	51                   	push   %ecx
  802b1f:	52                   	push   %edx
  802b20:	50                   	push   %eax
  802b21:	6a 17                	push   $0x17
  802b23:	e8 a8 fd ff ff       	call   8028d0 <syscall>
  802b28:	83 c4 18             	add    $0x18,%esp
}
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	52                   	push   %edx
  802b3d:	50                   	push   %eax
  802b3e:	6a 18                	push   $0x18
  802b40:	e8 8b fd ff ff       	call   8028d0 <syscall>
  802b45:	83 c4 18             	add    $0x18,%esp
}
  802b48:	c9                   	leave  
  802b49:	c3                   	ret    

00802b4a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b4a:	55                   	push   %ebp
  802b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	6a 00                	push   $0x0
  802b52:	ff 75 14             	pushl  0x14(%ebp)
  802b55:	ff 75 10             	pushl  0x10(%ebp)
  802b58:	ff 75 0c             	pushl  0xc(%ebp)
  802b5b:	50                   	push   %eax
  802b5c:	6a 19                	push   $0x19
  802b5e:	e8 6d fd ff ff       	call   8028d0 <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
}
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

00802b68 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	50                   	push   %eax
  802b77:	6a 1a                	push   $0x1a
  802b79:	e8 52 fd ff ff       	call   8028d0 <syscall>
  802b7e:	83 c4 18             	add    $0x18,%esp
}
  802b81:	90                   	nop
  802b82:	c9                   	leave  
  802b83:	c3                   	ret    

00802b84 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	50                   	push   %eax
  802b93:	6a 1b                	push   $0x1b
  802b95:	e8 36 fd ff ff       	call   8028d0 <syscall>
  802b9a:	83 c4 18             	add    $0x18,%esp
}
  802b9d:	c9                   	leave  
  802b9e:	c3                   	ret    

00802b9f <sys_getenvid>:

int32 sys_getenvid(void)
{
  802b9f:	55                   	push   %ebp
  802ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	6a 05                	push   $0x5
  802bae:	e8 1d fd ff ff       	call   8028d0 <syscall>
  802bb3:	83 c4 18             	add    $0x18,%esp
}
  802bb6:	c9                   	leave  
  802bb7:	c3                   	ret    

00802bb8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802bbb:	6a 00                	push   $0x0
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 06                	push   $0x6
  802bc7:	e8 04 fd ff ff       	call   8028d0 <syscall>
  802bcc:	83 c4 18             	add    $0x18,%esp
}
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    

00802bd1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802bd4:	6a 00                	push   $0x0
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 07                	push   $0x7
  802be0:	e8 eb fc ff ff       	call   8028d0 <syscall>
  802be5:	83 c4 18             	add    $0x18,%esp
}
  802be8:	c9                   	leave  
  802be9:	c3                   	ret    

00802bea <sys_exit_env>:


void sys_exit_env(void)
{
  802bea:	55                   	push   %ebp
  802beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802bed:	6a 00                	push   $0x0
  802bef:	6a 00                	push   $0x0
  802bf1:	6a 00                	push   $0x0
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 1c                	push   $0x1c
  802bf9:	e8 d2 fc ff ff       	call   8028d0 <syscall>
  802bfe:	83 c4 18             	add    $0x18,%esp
}
  802c01:	90                   	nop
  802c02:	c9                   	leave  
  802c03:	c3                   	ret    

00802c04 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
  802c07:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c0d:	8d 50 04             	lea    0x4(%eax),%edx
  802c10:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c13:	6a 00                	push   $0x0
  802c15:	6a 00                	push   $0x0
  802c17:	6a 00                	push   $0x0
  802c19:	52                   	push   %edx
  802c1a:	50                   	push   %eax
  802c1b:	6a 1d                	push   $0x1d
  802c1d:	e8 ae fc ff ff       	call   8028d0 <syscall>
  802c22:	83 c4 18             	add    $0x18,%esp
	return result;
  802c25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c2e:	89 01                	mov    %eax,(%ecx)
  802c30:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	c9                   	leave  
  802c37:	c2 04 00             	ret    $0x4

00802c3a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	ff 75 10             	pushl  0x10(%ebp)
  802c44:	ff 75 0c             	pushl  0xc(%ebp)
  802c47:	ff 75 08             	pushl  0x8(%ebp)
  802c4a:	6a 13                	push   $0x13
  802c4c:	e8 7f fc ff ff       	call   8028d0 <syscall>
  802c51:	83 c4 18             	add    $0x18,%esp
	return ;
  802c54:	90                   	nop
}
  802c55:	c9                   	leave  
  802c56:	c3                   	ret    

00802c57 <sys_rcr2>:
uint32 sys_rcr2()
{
  802c57:	55                   	push   %ebp
  802c58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c5a:	6a 00                	push   $0x0
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 1e                	push   $0x1e
  802c66:	e8 65 fc ff ff       	call   8028d0 <syscall>
  802c6b:	83 c4 18             	add    $0x18,%esp
}
  802c6e:	c9                   	leave  
  802c6f:	c3                   	ret    

00802c70 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
  802c73:	83 ec 04             	sub    $0x4,%esp
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c7c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	50                   	push   %eax
  802c89:	6a 1f                	push   $0x1f
  802c8b:	e8 40 fc ff ff       	call   8028d0 <syscall>
  802c90:	83 c4 18             	add    $0x18,%esp
	return ;
  802c93:	90                   	nop
}
  802c94:	c9                   	leave  
  802c95:	c3                   	ret    

00802c96 <rsttst>:
void rsttst()
{
  802c96:	55                   	push   %ebp
  802c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c99:	6a 00                	push   $0x0
  802c9b:	6a 00                	push   $0x0
  802c9d:	6a 00                	push   $0x0
  802c9f:	6a 00                	push   $0x0
  802ca1:	6a 00                	push   $0x0
  802ca3:	6a 21                	push   $0x21
  802ca5:	e8 26 fc ff ff       	call   8028d0 <syscall>
  802caa:	83 c4 18             	add    $0x18,%esp
	return ;
  802cad:	90                   	nop
}
  802cae:	c9                   	leave  
  802caf:	c3                   	ret    

00802cb0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802cb0:	55                   	push   %ebp
  802cb1:	89 e5                	mov    %esp,%ebp
  802cb3:	83 ec 04             	sub    $0x4,%esp
  802cb6:	8b 45 14             	mov    0x14(%ebp),%eax
  802cb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802cbc:	8b 55 18             	mov    0x18(%ebp),%edx
  802cbf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802cc3:	52                   	push   %edx
  802cc4:	50                   	push   %eax
  802cc5:	ff 75 10             	pushl  0x10(%ebp)
  802cc8:	ff 75 0c             	pushl  0xc(%ebp)
  802ccb:	ff 75 08             	pushl  0x8(%ebp)
  802cce:	6a 20                	push   $0x20
  802cd0:	e8 fb fb ff ff       	call   8028d0 <syscall>
  802cd5:	83 c4 18             	add    $0x18,%esp
	return ;
  802cd8:	90                   	nop
}
  802cd9:	c9                   	leave  
  802cda:	c3                   	ret    

00802cdb <chktst>:
void chktst(uint32 n)
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802cde:	6a 00                	push   $0x0
  802ce0:	6a 00                	push   $0x0
  802ce2:	6a 00                	push   $0x0
  802ce4:	6a 00                	push   $0x0
  802ce6:	ff 75 08             	pushl  0x8(%ebp)
  802ce9:	6a 22                	push   $0x22
  802ceb:	e8 e0 fb ff ff       	call   8028d0 <syscall>
  802cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  802cf3:	90                   	nop
}
  802cf4:	c9                   	leave  
  802cf5:	c3                   	ret    

00802cf6 <inctst>:

void inctst()
{
  802cf6:	55                   	push   %ebp
  802cf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 00                	push   $0x0
  802cfd:	6a 00                	push   $0x0
  802cff:	6a 00                	push   $0x0
  802d01:	6a 00                	push   $0x0
  802d03:	6a 23                	push   $0x23
  802d05:	e8 c6 fb ff ff       	call   8028d0 <syscall>
  802d0a:	83 c4 18             	add    $0x18,%esp
	return ;
  802d0d:	90                   	nop
}
  802d0e:	c9                   	leave  
  802d0f:	c3                   	ret    

00802d10 <gettst>:
uint32 gettst()
{
  802d10:	55                   	push   %ebp
  802d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	6a 00                	push   $0x0
  802d1b:	6a 00                	push   $0x0
  802d1d:	6a 24                	push   $0x24
  802d1f:	e8 ac fb ff ff       	call   8028d0 <syscall>
  802d24:	83 c4 18             	add    $0x18,%esp
}
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d2c:	6a 00                	push   $0x0
  802d2e:	6a 00                	push   $0x0
  802d30:	6a 00                	push   $0x0
  802d32:	6a 00                	push   $0x0
  802d34:	6a 00                	push   $0x0
  802d36:	6a 25                	push   $0x25
  802d38:	e8 93 fb ff ff       	call   8028d0 <syscall>
  802d3d:	83 c4 18             	add    $0x18,%esp
  802d40:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802d45:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802d4a:	c9                   	leave  
  802d4b:	c3                   	ret    

00802d4c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d4c:	55                   	push   %ebp
  802d4d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 00                	push   $0x0
  802d5f:	ff 75 08             	pushl  0x8(%ebp)
  802d62:	6a 26                	push   $0x26
  802d64:	e8 67 fb ff ff       	call   8028d0 <syscall>
  802d69:	83 c4 18             	add    $0x18,%esp
	return ;
  802d6c:	90                   	nop
}
  802d6d:	c9                   	leave  
  802d6e:	c3                   	ret    

00802d6f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802d6f:	55                   	push   %ebp
  802d70:	89 e5                	mov    %esp,%ebp
  802d72:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802d73:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d76:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	6a 00                	push   $0x0
  802d81:	53                   	push   %ebx
  802d82:	51                   	push   %ecx
  802d83:	52                   	push   %edx
  802d84:	50                   	push   %eax
  802d85:	6a 27                	push   $0x27
  802d87:	e8 44 fb ff ff       	call   8028d0 <syscall>
  802d8c:	83 c4 18             	add    $0x18,%esp
}
  802d8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d92:	c9                   	leave  
  802d93:	c3                   	ret    

00802d94 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d94:	55                   	push   %ebp
  802d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	52                   	push   %edx
  802da4:	50                   	push   %eax
  802da5:	6a 28                	push   $0x28
  802da7:	e8 24 fb ff ff       	call   8028d0 <syscall>
  802dac:	83 c4 18             	add    $0x18,%esp
}
  802daf:	c9                   	leave  
  802db0:	c3                   	ret    

00802db1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802db1:	55                   	push   %ebp
  802db2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802db4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	6a 00                	push   $0x0
  802dbf:	51                   	push   %ecx
  802dc0:	ff 75 10             	pushl  0x10(%ebp)
  802dc3:	52                   	push   %edx
  802dc4:	50                   	push   %eax
  802dc5:	6a 29                	push   $0x29
  802dc7:	e8 04 fb ff ff       	call   8028d0 <syscall>
  802dcc:	83 c4 18             	add    $0x18,%esp
}
  802dcf:	c9                   	leave  
  802dd0:	c3                   	ret    

00802dd1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802dd1:	55                   	push   %ebp
  802dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 00                	push   $0x0
  802dd8:	ff 75 10             	pushl  0x10(%ebp)
  802ddb:	ff 75 0c             	pushl  0xc(%ebp)
  802dde:	ff 75 08             	pushl  0x8(%ebp)
  802de1:	6a 12                	push   $0x12
  802de3:	e8 e8 fa ff ff       	call   8028d0 <syscall>
  802de8:	83 c4 18             	add    $0x18,%esp
	return ;
  802deb:	90                   	nop
}
  802dec:	c9                   	leave  
  802ded:	c3                   	ret    

00802dee <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802dee:	55                   	push   %ebp
  802def:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	6a 00                	push   $0x0
  802df9:	6a 00                	push   $0x0
  802dfb:	6a 00                	push   $0x0
  802dfd:	52                   	push   %edx
  802dfe:	50                   	push   %eax
  802dff:	6a 2a                	push   $0x2a
  802e01:	e8 ca fa ff ff       	call   8028d0 <syscall>
  802e06:	83 c4 18             	add    $0x18,%esp
	return;
  802e09:	90                   	nop
}
  802e0a:	c9                   	leave  
  802e0b:	c3                   	ret    

00802e0c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802e0c:	55                   	push   %ebp
  802e0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802e0f:	6a 00                	push   $0x0
  802e11:	6a 00                	push   $0x0
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	6a 2b                	push   $0x2b
  802e1b:	e8 b0 fa ff ff       	call   8028d0 <syscall>
  802e20:	83 c4 18             	add    $0x18,%esp
}
  802e23:	c9                   	leave  
  802e24:	c3                   	ret    

00802e25 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e25:	55                   	push   %ebp
  802e26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802e28:	6a 00                	push   $0x0
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 00                	push   $0x0
  802e2e:	ff 75 0c             	pushl  0xc(%ebp)
  802e31:	ff 75 08             	pushl  0x8(%ebp)
  802e34:	6a 2d                	push   $0x2d
  802e36:	e8 95 fa ff ff       	call   8028d0 <syscall>
  802e3b:	83 c4 18             	add    $0x18,%esp
	return;
  802e3e:	90                   	nop
}
  802e3f:	c9                   	leave  
  802e40:	c3                   	ret    

00802e41 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e41:	55                   	push   %ebp
  802e42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802e44:	6a 00                	push   $0x0
  802e46:	6a 00                	push   $0x0
  802e48:	6a 00                	push   $0x0
  802e4a:	ff 75 0c             	pushl  0xc(%ebp)
  802e4d:	ff 75 08             	pushl  0x8(%ebp)
  802e50:	6a 2c                	push   $0x2c
  802e52:	e8 79 fa ff ff       	call   8028d0 <syscall>
  802e57:	83 c4 18             	add    $0x18,%esp
	return ;
  802e5a:	90                   	nop
}
  802e5b:	c9                   	leave  
  802e5c:	c3                   	ret    

00802e5d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802e5d:	55                   	push   %ebp
  802e5e:	89 e5                	mov    %esp,%ebp
  802e60:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802e63:	83 ec 04             	sub    $0x4,%esp
  802e66:	68 b4 4a 80 00       	push   $0x804ab4
  802e6b:	68 25 01 00 00       	push   $0x125
  802e70:	68 e7 4a 80 00       	push   $0x804ae7
  802e75:	e8 ec e6 ff ff       	call   801566 <_panic>

00802e7a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
  802e7d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802e80:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802e87:	72 09                	jb     802e92 <to_page_va+0x18>
  802e89:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802e90:	72 14                	jb     802ea6 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802e92:	83 ec 04             	sub    $0x4,%esp
  802e95:	68 f8 4a 80 00       	push   $0x804af8
  802e9a:	6a 15                	push   $0x15
  802e9c:	68 23 4b 80 00       	push   $0x804b23
  802ea1:	e8 c0 e6 ff ff       	call   801566 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	ba 40 52 80 00       	mov    $0x805240,%edx
  802eae:	29 d0                	sub    %edx,%eax
  802eb0:	c1 f8 02             	sar    $0x2,%eax
  802eb3:	89 c2                	mov    %eax,%edx
  802eb5:	89 d0                	mov    %edx,%eax
  802eb7:	c1 e0 02             	shl    $0x2,%eax
  802eba:	01 d0                	add    %edx,%eax
  802ebc:	c1 e0 02             	shl    $0x2,%eax
  802ebf:	01 d0                	add    %edx,%eax
  802ec1:	c1 e0 02             	shl    $0x2,%eax
  802ec4:	01 d0                	add    %edx,%eax
  802ec6:	89 c1                	mov    %eax,%ecx
  802ec8:	c1 e1 08             	shl    $0x8,%ecx
  802ecb:	01 c8                	add    %ecx,%eax
  802ecd:	89 c1                	mov    %eax,%ecx
  802ecf:	c1 e1 10             	shl    $0x10,%ecx
  802ed2:	01 c8                	add    %ecx,%eax
  802ed4:	01 c0                	add    %eax,%eax
  802ed6:	01 d0                	add    %edx,%eax
  802ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	c1 e0 0c             	shl    $0xc,%eax
  802ee1:	89 c2                	mov    %eax,%edx
  802ee3:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802ee8:	01 d0                	add    %edx,%eax
}
  802eea:	c9                   	leave  
  802eeb:	c3                   	ret    

00802eec <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802ef2:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  802efa:	29 c2                	sub    %eax,%edx
  802efc:	89 d0                	mov    %edx,%eax
  802efe:	c1 e8 0c             	shr    $0xc,%eax
  802f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802f04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f08:	78 09                	js     802f13 <to_page_info+0x27>
  802f0a:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802f11:	7e 14                	jle    802f27 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 3c 4b 80 00       	push   $0x804b3c
  802f1b:	6a 22                	push   $0x22
  802f1d:	68 23 4b 80 00       	push   $0x804b23
  802f22:	e8 3f e6 ff ff       	call   801566 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2a:	89 d0                	mov    %edx,%eax
  802f2c:	01 c0                	add    %eax,%eax
  802f2e:	01 d0                	add    %edx,%eax
  802f30:	c1 e0 02             	shl    $0x2,%eax
  802f33:	05 40 52 80 00       	add    $0x805240,%eax
}
  802f38:	c9                   	leave  
  802f39:	c3                   	ret    

00802f3a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802f3a:	55                   	push   %ebp
  802f3b:	89 e5                	mov    %esp,%ebp
  802f3d:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	05 00 00 00 02       	add    $0x2000000,%eax
  802f48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f4b:	73 16                	jae    802f63 <initialize_dynamic_allocator+0x29>
  802f4d:	68 60 4b 80 00       	push   $0x804b60
  802f52:	68 86 4b 80 00       	push   $0x804b86
  802f57:	6a 34                	push   $0x34
  802f59:	68 23 4b 80 00       	push   $0x804b23
  802f5e:	e8 03 e6 ff ff       	call   801566 <_panic>
		is_initialized = 1;
  802f63:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802f6a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f78:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802f7d:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802f84:	00 00 00 
  802f87:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802f8e:	00 00 00 
  802f91:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  802f98:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9e:	2b 45 08             	sub    0x8(%ebp),%eax
  802fa1:	c1 e8 0c             	shr    $0xc,%eax
  802fa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802fa7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802fae:	e9 c8 00 00 00       	jmp    80307b <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802fb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb6:	89 d0                	mov    %edx,%eax
  802fb8:	01 c0                	add    %eax,%eax
  802fba:	01 d0                	add    %edx,%eax
  802fbc:	c1 e0 02             	shl    $0x2,%eax
  802fbf:	05 48 52 80 00       	add    $0x805248,%eax
  802fc4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fcc:	89 d0                	mov    %edx,%eax
  802fce:	01 c0                	add    %eax,%eax
  802fd0:	01 d0                	add    %edx,%eax
  802fd2:	c1 e0 02             	shl    $0x2,%eax
  802fd5:	05 4a 52 80 00       	add    $0x80524a,%eax
  802fda:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802fdf:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802fe5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802fe8:	89 c8                	mov    %ecx,%eax
  802fea:	01 c0                	add    %eax,%eax
  802fec:	01 c8                	add    %ecx,%eax
  802fee:	c1 e0 02             	shl    $0x2,%eax
  802ff1:	05 44 52 80 00       	add    $0x805244,%eax
  802ff6:	89 10                	mov    %edx,(%eax)
  802ff8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffb:	89 d0                	mov    %edx,%eax
  802ffd:	01 c0                	add    %eax,%eax
  802fff:	01 d0                	add    %edx,%eax
  803001:	c1 e0 02             	shl    $0x2,%eax
  803004:	05 44 52 80 00       	add    $0x805244,%eax
  803009:	8b 00                	mov    (%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 1b                	je     80302a <initialize_dynamic_allocator+0xf0>
  80300f:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803015:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803018:	89 c8                	mov    %ecx,%eax
  80301a:	01 c0                	add    %eax,%eax
  80301c:	01 c8                	add    %ecx,%eax
  80301e:	c1 e0 02             	shl    $0x2,%eax
  803021:	05 40 52 80 00       	add    $0x805240,%eax
  803026:	89 02                	mov    %eax,(%edx)
  803028:	eb 16                	jmp    803040 <initialize_dynamic_allocator+0x106>
  80302a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302d:	89 d0                	mov    %edx,%eax
  80302f:	01 c0                	add    %eax,%eax
  803031:	01 d0                	add    %edx,%eax
  803033:	c1 e0 02             	shl    $0x2,%eax
  803036:	05 40 52 80 00       	add    $0x805240,%eax
  80303b:	a3 28 52 80 00       	mov    %eax,0x805228
  803040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803043:	89 d0                	mov    %edx,%eax
  803045:	01 c0                	add    %eax,%eax
  803047:	01 d0                	add    %edx,%eax
  803049:	c1 e0 02             	shl    $0x2,%eax
  80304c:	05 40 52 80 00       	add    $0x805240,%eax
  803051:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803059:	89 d0                	mov    %edx,%eax
  80305b:	01 c0                	add    %eax,%eax
  80305d:	01 d0                	add    %edx,%eax
  80305f:	c1 e0 02             	shl    $0x2,%eax
  803062:	05 40 52 80 00       	add    $0x805240,%eax
  803067:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306d:	a1 34 52 80 00       	mov    0x805234,%eax
  803072:	40                   	inc    %eax
  803073:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  803078:	ff 45 f4             	incl   -0xc(%ebp)
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803081:	0f 8c 2c ff ff ff    	jl     802fb3 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803087:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80308e:	eb 36                	jmp    8030c6 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	c1 e0 04             	shl    $0x4,%eax
  803096:	05 60 d2 81 00       	add    $0x81d260,%eax
  80309b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a4:	c1 e0 04             	shl    $0x4,%eax
  8030a7:	05 64 d2 81 00       	add    $0x81d264,%eax
  8030ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b5:	c1 e0 04             	shl    $0x4,%eax
  8030b8:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8030c3:	ff 45 f0             	incl   -0x10(%ebp)
  8030c6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8030ca:	7e c4                	jle    803090 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8030cc:	90                   	nop
  8030cd:	c9                   	leave  
  8030ce:	c3                   	ret    

008030cf <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8030cf:	55                   	push   %ebp
  8030d0:	89 e5                	mov    %esp,%ebp
  8030d2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	83 ec 0c             	sub    $0xc,%esp
  8030db:	50                   	push   %eax
  8030dc:	e8 0b fe ff ff       	call   802eec <to_page_info>
  8030e1:	83 c4 10             	add    $0x10,%esp
  8030e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 40 08             	mov    0x8(%eax),%eax
  8030ed:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8030f0:	c9                   	leave  
  8030f1:	c3                   	ret    

008030f2 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8030f2:	55                   	push   %ebp
  8030f3:	89 e5                	mov    %esp,%ebp
  8030f5:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8030f8:	83 ec 0c             	sub    $0xc,%esp
  8030fb:	ff 75 0c             	pushl  0xc(%ebp)
  8030fe:	e8 77 fd ff ff       	call   802e7a <to_page_va>
  803103:	83 c4 10             	add    $0x10,%esp
  803106:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  803109:	b8 00 10 00 00       	mov    $0x1000,%eax
  80310e:	ba 00 00 00 00       	mov    $0x0,%edx
  803113:	f7 75 08             	divl   0x8(%ebp)
  803116:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	83 ec 0c             	sub    $0xc,%esp
  80311f:	50                   	push   %eax
  803120:	e8 48 f6 ff ff       	call   80276d <get_page>
  803125:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  803128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80312e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	8b 55 0c             	mov    0xc(%ebp),%edx
  803138:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  80313c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803143:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80314a:	eb 19                	jmp    803165 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  80314c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314f:	ba 01 00 00 00       	mov    $0x1,%edx
  803154:	88 c1                	mov    %al,%cl
  803156:	d3 e2                	shl    %cl,%edx
  803158:	89 d0                	mov    %edx,%eax
  80315a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315d:	74 0e                	je     80316d <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80315f:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803162:	ff 45 f0             	incl   -0x10(%ebp)
  803165:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803169:	7e e1                	jle    80314c <split_page_to_blocks+0x5a>
  80316b:	eb 01                	jmp    80316e <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80316d:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80316e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803175:	e9 a7 00 00 00       	jmp    803221 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  80317a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317d:	0f af 45 08          	imul   0x8(%ebp),%eax
  803181:	89 c2                	mov    %eax,%edx
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	01 d0                	add    %edx,%eax
  803188:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80318b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80318f:	75 14                	jne    8031a5 <split_page_to_blocks+0xb3>
  803191:	83 ec 04             	sub    $0x4,%esp
  803194:	68 9c 4b 80 00       	push   $0x804b9c
  803199:	6a 7c                	push   $0x7c
  80319b:	68 23 4b 80 00       	push   $0x804b23
  8031a0:	e8 c1 e3 ff ff       	call   801566 <_panic>
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	c1 e0 04             	shl    $0x4,%eax
  8031ab:	05 64 d2 81 00       	add    $0x81d264,%eax
  8031b0:	8b 10                	mov    (%eax),%edx
  8031b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b5:	89 50 04             	mov    %edx,0x4(%eax)
  8031b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031bb:	8b 40 04             	mov    0x4(%eax),%eax
  8031be:	85 c0                	test   %eax,%eax
  8031c0:	74 14                	je     8031d6 <split_page_to_blocks+0xe4>
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	c1 e0 04             	shl    $0x4,%eax
  8031c8:	05 64 d2 81 00       	add    $0x81d264,%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031d2:	89 10                	mov    %edx,(%eax)
  8031d4:	eb 11                	jmp    8031e7 <split_page_to_blocks+0xf5>
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	c1 e0 04             	shl    $0x4,%eax
  8031dc:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8031e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e5:	89 02                	mov    %eax,(%edx)
  8031e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ea:	c1 e0 04             	shl    $0x4,%eax
  8031ed:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8031f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f6:	89 02                	mov    %eax,(%edx)
  8031f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	c1 e0 04             	shl    $0x4,%eax
  803207:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80320c:	8b 00                	mov    (%eax),%eax
  80320e:	8d 50 01             	lea    0x1(%eax),%edx
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	c1 e0 04             	shl    $0x4,%eax
  803217:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80321c:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80321e:	ff 45 ec             	incl   -0x14(%ebp)
  803221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803224:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  803227:	0f 82 4d ff ff ff    	jb     80317a <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80322d:	90                   	nop
  80322e:	c9                   	leave  
  80322f:	c3                   	ret    

00803230 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803230:	55                   	push   %ebp
  803231:	89 e5                	mov    %esp,%ebp
  803233:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803236:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80323d:	76 19                	jbe    803258 <alloc_block+0x28>
  80323f:	68 c0 4b 80 00       	push   $0x804bc0
  803244:	68 86 4b 80 00       	push   $0x804b86
  803249:	68 8a 00 00 00       	push   $0x8a
  80324e:	68 23 4b 80 00       	push   $0x804b23
  803253:	e8 0e e3 ff ff       	call   801566 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  803258:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80325f:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803266:	eb 19                	jmp    803281 <alloc_block+0x51>
		if((1 << i) >= size) break;
  803268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326b:	ba 01 00 00 00       	mov    $0x1,%edx
  803270:	88 c1                	mov    %al,%cl
  803272:	d3 e2                	shl    %cl,%edx
  803274:	89 d0                	mov    %edx,%eax
  803276:	3b 45 08             	cmp    0x8(%ebp),%eax
  803279:	73 0e                	jae    803289 <alloc_block+0x59>
		idx++;
  80327b:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80327e:	ff 45 f0             	incl   -0x10(%ebp)
  803281:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803285:	7e e1                	jle    803268 <alloc_block+0x38>
  803287:	eb 01                	jmp    80328a <alloc_block+0x5a>
		if((1 << i) >= size) break;
  803289:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	c1 e0 04             	shl    $0x4,%eax
  803290:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803295:	8b 00                	mov    (%eax),%eax
  803297:	85 c0                	test   %eax,%eax
  803299:	0f 84 df 00 00 00    	je     80337e <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80329f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a2:	c1 e0 04             	shl    $0x4,%eax
  8032a5:	05 60 d2 81 00       	add    $0x81d260,%eax
  8032aa:	8b 00                	mov    (%eax),%eax
  8032ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8032af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032b3:	75 17                	jne    8032cc <alloc_block+0x9c>
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	68 e1 4b 80 00       	push   $0x804be1
  8032bd:	68 9e 00 00 00       	push   $0x9e
  8032c2:	68 23 4b 80 00       	push   $0x804b23
  8032c7:	e8 9a e2 ff ff       	call   801566 <_panic>
  8032cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cf:	8b 00                	mov    (%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	74 10                	je     8032e5 <alloc_block+0xb5>
  8032d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032dd:	8b 52 04             	mov    0x4(%edx),%edx
  8032e0:	89 50 04             	mov    %edx,0x4(%eax)
  8032e3:	eb 14                	jmp    8032f9 <alloc_block+0xc9>
  8032e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e8:	8b 40 04             	mov    0x4(%eax),%eax
  8032eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ee:	c1 e2 04             	shl    $0x4,%edx
  8032f1:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8032f7:	89 02                	mov    %eax,(%edx)
  8032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fc:	8b 40 04             	mov    0x4(%eax),%eax
  8032ff:	85 c0                	test   %eax,%eax
  803301:	74 0f                	je     803312 <alloc_block+0xe2>
  803303:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803306:	8b 40 04             	mov    0x4(%eax),%eax
  803309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80330c:	8b 12                	mov    (%edx),%edx
  80330e:	89 10                	mov    %edx,(%eax)
  803310:	eb 13                	jmp    803325 <alloc_block+0xf5>
  803312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80331a:	c1 e2 04             	shl    $0x4,%edx
  80331d:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803323:	89 02                	mov    %eax,(%edx)
  803325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803331:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	c1 e0 04             	shl    $0x4,%eax
  80333e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	8d 50 ff             	lea    -0x1(%eax),%edx
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	c1 e0 04             	shl    $0x4,%eax
  80334e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803353:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803358:	83 ec 0c             	sub    $0xc,%esp
  80335b:	50                   	push   %eax
  80335c:	e8 8b fb ff ff       	call   802eec <to_page_info>
  803361:	83 c4 10             	add    $0x10,%esp
  803364:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80336e:	48                   	dec    %eax
  80336f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803372:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  803376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803379:	e9 bc 02 00 00       	jmp    80363a <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80337e:	a1 34 52 80 00       	mov    0x805234,%eax
  803383:	85 c0                	test   %eax,%eax
  803385:	0f 84 7d 02 00 00    	je     803608 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80338b:	a1 28 52 80 00       	mov    0x805228,%eax
  803390:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  803393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803397:	75 17                	jne    8033b0 <alloc_block+0x180>
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	68 e1 4b 80 00       	push   $0x804be1
  8033a1:	68 a9 00 00 00       	push   $0xa9
  8033a6:	68 23 4b 80 00       	push   $0x804b23
  8033ab:	e8 b6 e1 ff ff       	call   801566 <_panic>
  8033b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b3:	8b 00                	mov    (%eax),%eax
  8033b5:	85 c0                	test   %eax,%eax
  8033b7:	74 10                	je     8033c9 <alloc_block+0x199>
  8033b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bc:	8b 00                	mov    (%eax),%eax
  8033be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033c1:	8b 52 04             	mov    0x4(%edx),%edx
  8033c4:	89 50 04             	mov    %edx,0x4(%eax)
  8033c7:	eb 0b                	jmp    8033d4 <alloc_block+0x1a4>
  8033c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cc:	8b 40 04             	mov    0x4(%eax),%eax
  8033cf:	a3 2c 52 80 00       	mov    %eax,0x80522c
  8033d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d7:	8b 40 04             	mov    0x4(%eax),%eax
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	74 0f                	je     8033ed <alloc_block+0x1bd>
  8033de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e1:	8b 40 04             	mov    0x4(%eax),%eax
  8033e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e7:	8b 12                	mov    (%edx),%edx
  8033e9:	89 10                	mov    %edx,(%eax)
  8033eb:	eb 0a                	jmp    8033f7 <alloc_block+0x1c7>
  8033ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f0:	8b 00                	mov    (%eax),%eax
  8033f2:	a3 28 52 80 00       	mov    %eax,0x805228
  8033f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803403:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340a:	a1 34 52 80 00       	mov    0x805234,%eax
  80340f:	48                   	dec    %eax
  803410:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	83 c0 03             	add    $0x3,%eax
  80341b:	ba 01 00 00 00       	mov    $0x1,%edx
  803420:	88 c1                	mov    %al,%cl
  803422:	d3 e2                	shl    %cl,%edx
  803424:	89 d0                	mov    %edx,%eax
  803426:	83 ec 08             	sub    $0x8,%esp
  803429:	ff 75 e4             	pushl  -0x1c(%ebp)
  80342c:	50                   	push   %eax
  80342d:	e8 c0 fc ff ff       	call   8030f2 <split_page_to_blocks>
  803432:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	c1 e0 04             	shl    $0x4,%eax
  80343b:	05 60 d2 81 00       	add    $0x81d260,%eax
  803440:	8b 00                	mov    (%eax),%eax
  803442:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  803445:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803449:	75 17                	jne    803462 <alloc_block+0x232>
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	68 e1 4b 80 00       	push   $0x804be1
  803453:	68 b0 00 00 00       	push   $0xb0
  803458:	68 23 4b 80 00       	push   $0x804b23
  80345d:	e8 04 e1 ff ff       	call   801566 <_panic>
  803462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803465:	8b 00                	mov    (%eax),%eax
  803467:	85 c0                	test   %eax,%eax
  803469:	74 10                	je     80347b <alloc_block+0x24b>
  80346b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803473:	8b 52 04             	mov    0x4(%edx),%edx
  803476:	89 50 04             	mov    %edx,0x4(%eax)
  803479:	eb 14                	jmp    80348f <alloc_block+0x25f>
  80347b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80347e:	8b 40 04             	mov    0x4(%eax),%eax
  803481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803484:	c1 e2 04             	shl    $0x4,%edx
  803487:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80348d:	89 02                	mov    %eax,(%edx)
  80348f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803492:	8b 40 04             	mov    0x4(%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	74 0f                	je     8034a8 <alloc_block+0x278>
  803499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349c:	8b 40 04             	mov    0x4(%eax),%eax
  80349f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034a2:	8b 12                	mov    (%edx),%edx
  8034a4:	89 10                	mov    %edx,(%eax)
  8034a6:	eb 13                	jmp    8034bb <alloc_block+0x28b>
  8034a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b0:	c1 e2 04             	shl    $0x4,%edx
  8034b3:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8034b9:	89 02                	mov    %eax,(%edx)
  8034bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	c1 e0 04             	shl    $0x4,%eax
  8034d4:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	c1 e0 04             	shl    $0x4,%eax
  8034e4:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034e9:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8034eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ee:	83 ec 0c             	sub    $0xc,%esp
  8034f1:	50                   	push   %eax
  8034f2:	e8 f5 f9 ff ff       	call   802eec <to_page_info>
  8034f7:	83 c4 10             	add    $0x10,%esp
  8034fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8034fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803500:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803504:	48                   	dec    %eax
  803505:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803508:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80350c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80350f:	e9 26 01 00 00       	jmp    80363a <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  803514:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	c1 e0 04             	shl    $0x4,%eax
  80351d:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803522:	8b 00                	mov    (%eax),%eax
  803524:	85 c0                	test   %eax,%eax
  803526:	0f 84 dc 00 00 00    	je     803608 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352f:	c1 e0 04             	shl    $0x4,%eax
  803532:	05 60 d2 81 00       	add    $0x81d260,%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80353c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803540:	75 17                	jne    803559 <alloc_block+0x329>
  803542:	83 ec 04             	sub    $0x4,%esp
  803545:	68 e1 4b 80 00       	push   $0x804be1
  80354a:	68 be 00 00 00       	push   $0xbe
  80354f:	68 23 4b 80 00       	push   $0x804b23
  803554:	e8 0d e0 ff ff       	call   801566 <_panic>
  803559:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80355c:	8b 00                	mov    (%eax),%eax
  80355e:	85 c0                	test   %eax,%eax
  803560:	74 10                	je     803572 <alloc_block+0x342>
  803562:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803565:	8b 00                	mov    (%eax),%eax
  803567:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80356a:	8b 52 04             	mov    0x4(%edx),%edx
  80356d:	89 50 04             	mov    %edx,0x4(%eax)
  803570:	eb 14                	jmp    803586 <alloc_block+0x356>
  803572:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803575:	8b 40 04             	mov    0x4(%eax),%eax
  803578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80357b:	c1 e2 04             	shl    $0x4,%edx
  80357e:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803584:	89 02                	mov    %eax,(%edx)
  803586:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803589:	8b 40 04             	mov    0x4(%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	74 0f                	je     80359f <alloc_block+0x36f>
  803590:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803593:	8b 40 04             	mov    0x4(%eax),%eax
  803596:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803599:	8b 12                	mov    (%edx),%edx
  80359b:	89 10                	mov    %edx,(%eax)
  80359d:	eb 13                	jmp    8035b2 <alloc_block+0x382>
  80359f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a7:	c1 e2 04             	shl    $0x4,%edx
  8035aa:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8035b0:	89 02                	mov    %eax,(%edx)
  8035b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	c1 e0 04             	shl    $0x4,%eax
  8035cb:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035d0:	8b 00                	mov    (%eax),%eax
  8035d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	c1 e0 04             	shl    $0x4,%eax
  8035db:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035e0:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8035e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035e5:	83 ec 0c             	sub    $0xc,%esp
  8035e8:	50                   	push   %eax
  8035e9:	e8 fe f8 ff ff       	call   802eec <to_page_info>
  8035ee:	83 c4 10             	add    $0x10,%esp
  8035f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8035f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8035fb:	48                   	dec    %eax
  8035fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ff:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803603:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803606:	eb 32                	jmp    80363a <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803608:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80360c:	77 15                	ja     803623 <alloc_block+0x3f3>
  80360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803611:	c1 e0 04             	shl    $0x4,%eax
  803614:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803619:	8b 00                	mov    (%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	0f 84 f1 fe ff ff    	je     803514 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  803623:	83 ec 04             	sub    $0x4,%esp
  803626:	68 ff 4b 80 00       	push   $0x804bff
  80362b:	68 c8 00 00 00       	push   $0xc8
  803630:	68 23 4b 80 00       	push   $0x804b23
  803635:	e8 2c df ff ff       	call   801566 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80363a:	c9                   	leave  
  80363b:	c3                   	ret    

0080363c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80363c:	55                   	push   %ebp
  80363d:	89 e5                	mov    %esp,%ebp
  80363f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803642:	8b 55 08             	mov    0x8(%ebp),%edx
  803645:	a1 48 d2 81 00       	mov    0x81d248,%eax
  80364a:	39 c2                	cmp    %eax,%edx
  80364c:	72 0c                	jb     80365a <free_block+0x1e>
  80364e:	8b 55 08             	mov    0x8(%ebp),%edx
  803651:	a1 20 52 80 00       	mov    0x805220,%eax
  803656:	39 c2                	cmp    %eax,%edx
  803658:	72 19                	jb     803673 <free_block+0x37>
  80365a:	68 10 4c 80 00       	push   $0x804c10
  80365f:	68 86 4b 80 00       	push   $0x804b86
  803664:	68 d7 00 00 00       	push   $0xd7
  803669:	68 23 4b 80 00       	push   $0x804b23
  80366e:	e8 f3 de ff ff       	call   801566 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	83 ec 0c             	sub    $0xc,%esp
  80367f:	50                   	push   %eax
  803680:	e8 67 f8 ff ff       	call   802eec <to_page_info>
  803685:	83 c4 10             	add    $0x10,%esp
  803688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80368b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368e:	8b 40 08             	mov    0x8(%eax),%eax
  803691:	0f b7 c0             	movzwl %ax,%eax
  803694:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803697:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80369e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8036a5:	eb 19                	jmp    8036c0 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8036a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036aa:	ba 01 00 00 00       	mov    $0x1,%edx
  8036af:	88 c1                	mov    %al,%cl
  8036b1:	d3 e2                	shl    %cl,%edx
  8036b3:	89 d0                	mov    %edx,%eax
  8036b5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036b8:	74 0e                	je     8036c8 <free_block+0x8c>
	        break;
	    idx++;
  8036ba:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8036bd:	ff 45 f0             	incl   -0x10(%ebp)
  8036c0:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8036c4:	7e e1                	jle    8036a7 <free_block+0x6b>
  8036c6:	eb 01                	jmp    8036c9 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8036c8:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8036c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036cc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8036d0:	40                   	inc    %eax
  8036d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d4:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8036d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036dc:	75 17                	jne    8036f5 <free_block+0xb9>
  8036de:	83 ec 04             	sub    $0x4,%esp
  8036e1:	68 9c 4b 80 00       	push   $0x804b9c
  8036e6:	68 ee 00 00 00       	push   $0xee
  8036eb:	68 23 4b 80 00       	push   $0x804b23
  8036f0:	e8 71 de ff ff       	call   801566 <_panic>
  8036f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f8:	c1 e0 04             	shl    $0x4,%eax
  8036fb:	05 64 d2 81 00       	add    $0x81d264,%eax
  803700:	8b 10                	mov    (%eax),%edx
  803702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803705:	89 50 04             	mov    %edx,0x4(%eax)
  803708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370b:	8b 40 04             	mov    0x4(%eax),%eax
  80370e:	85 c0                	test   %eax,%eax
  803710:	74 14                	je     803726 <free_block+0xea>
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	c1 e0 04             	shl    $0x4,%eax
  803718:	05 64 d2 81 00       	add    $0x81d264,%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803722:	89 10                	mov    %edx,(%eax)
  803724:	eb 11                	jmp    803737 <free_block+0xfb>
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	c1 e0 04             	shl    $0x4,%eax
  80372c:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  803732:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803735:	89 02                	mov    %eax,(%edx)
  803737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373a:	c1 e0 04             	shl    $0x4,%eax
  80373d:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  803743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803746:	89 02                	mov    %eax,(%edx)
  803748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	c1 e0 04             	shl    $0x4,%eax
  803757:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80375c:	8b 00                	mov    (%eax),%eax
  80375e:	8d 50 01             	lea    0x1(%eax),%edx
  803761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803764:	c1 e0 04             	shl    $0x4,%eax
  803767:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80376c:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80376e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803773:	ba 00 00 00 00       	mov    $0x0,%edx
  803778:	f7 75 e0             	divl   -0x20(%ebp)
  80377b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80377e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803781:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803785:	0f b7 c0             	movzwl %ax,%eax
  803788:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80378b:	0f 85 70 01 00 00    	jne    803901 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803791:	83 ec 0c             	sub    $0xc,%esp
  803794:	ff 75 e4             	pushl  -0x1c(%ebp)
  803797:	e8 de f6 ff ff       	call   802e7a <to_page_va>
  80379c:	83 c4 10             	add    $0x10,%esp
  80379f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8037a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8037a9:	e9 b7 00 00 00       	jmp    803865 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8037ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b4:	01 d0                	add    %edx,%eax
  8037b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8037b9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037bd:	75 17                	jne    8037d6 <free_block+0x19a>
  8037bf:	83 ec 04             	sub    $0x4,%esp
  8037c2:	68 e1 4b 80 00       	push   $0x804be1
  8037c7:	68 f8 00 00 00       	push   $0xf8
  8037cc:	68 23 4b 80 00       	push   $0x804b23
  8037d1:	e8 90 dd ff ff       	call   801566 <_panic>
  8037d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	85 c0                	test   %eax,%eax
  8037dd:	74 10                	je     8037ef <free_block+0x1b3>
  8037df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037e7:	8b 52 04             	mov    0x4(%edx),%edx
  8037ea:	89 50 04             	mov    %edx,0x4(%eax)
  8037ed:	eb 14                	jmp    803803 <free_block+0x1c7>
  8037ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f2:	8b 40 04             	mov    0x4(%eax),%eax
  8037f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037f8:	c1 e2 04             	shl    $0x4,%edx
  8037fb:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803801:	89 02                	mov    %eax,(%edx)
  803803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803806:	8b 40 04             	mov    0x4(%eax),%eax
  803809:	85 c0                	test   %eax,%eax
  80380b:	74 0f                	je     80381c <free_block+0x1e0>
  80380d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803810:	8b 40 04             	mov    0x4(%eax),%eax
  803813:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803816:	8b 12                	mov    (%edx),%edx
  803818:	89 10                	mov    %edx,(%eax)
  80381a:	eb 13                	jmp    80382f <free_block+0x1f3>
  80381c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80381f:	8b 00                	mov    (%eax),%eax
  803821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803824:	c1 e2 04             	shl    $0x4,%edx
  803827:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80382d:	89 02                	mov    %eax,(%edx)
  80382f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803832:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803845:	c1 e0 04             	shl    $0x4,%eax
  803848:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803855:	c1 e0 04             	shl    $0x4,%eax
  803858:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80385d:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80385f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803862:	01 45 ec             	add    %eax,-0x14(%ebp)
  803865:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80386c:	0f 86 3c ff ff ff    	jbe    8037ae <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80387b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803884:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803888:	75 17                	jne    8038a1 <free_block+0x265>
  80388a:	83 ec 04             	sub    $0x4,%esp
  80388d:	68 9c 4b 80 00       	push   $0x804b9c
  803892:	68 fe 00 00 00       	push   $0xfe
  803897:	68 23 4b 80 00       	push   $0x804b23
  80389c:	e8 c5 dc ff ff       	call   801566 <_panic>
  8038a1:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  8038a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038aa:	89 50 04             	mov    %edx,0x4(%eax)
  8038ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b0:	8b 40 04             	mov    0x4(%eax),%eax
  8038b3:	85 c0                	test   %eax,%eax
  8038b5:	74 0c                	je     8038c3 <free_block+0x287>
  8038b7:	a1 2c 52 80 00       	mov    0x80522c,%eax
  8038bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038bf:	89 10                	mov    %edx,(%eax)
  8038c1:	eb 08                	jmp    8038cb <free_block+0x28f>
  8038c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c6:	a3 28 52 80 00       	mov    %eax,0x805228
  8038cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ce:	a3 2c 52 80 00       	mov    %eax,0x80522c
  8038d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038dc:	a1 34 52 80 00       	mov    0x805234,%eax
  8038e1:	40                   	inc    %eax
  8038e2:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8038e7:	83 ec 0c             	sub    $0xc,%esp
  8038ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038ed:	e8 88 f5 ff ff       	call   802e7a <to_page_va>
  8038f2:	83 c4 10             	add    $0x10,%esp
  8038f5:	83 ec 0c             	sub    $0xc,%esp
  8038f8:	50                   	push   %eax
  8038f9:	e8 b8 ee ff ff       	call   8027b6 <return_page>
  8038fe:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803901:	90                   	nop
  803902:	c9                   	leave  
  803903:	c3                   	ret    

00803904 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803904:	55                   	push   %ebp
  803905:	89 e5                	mov    %esp,%ebp
  803907:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80390a:	83 ec 04             	sub    $0x4,%esp
  80390d:	68 48 4c 80 00       	push   $0x804c48
  803912:	68 11 01 00 00       	push   $0x111
  803917:	68 23 4b 80 00       	push   $0x804b23
  80391c:	e8 45 dc ff ff       	call   801566 <_panic>
  803921:	66 90                	xchg   %ax,%ax
  803923:	90                   	nop

00803924 <__udivdi3>:
  803924:	55                   	push   %ebp
  803925:	57                   	push   %edi
  803926:	56                   	push   %esi
  803927:	53                   	push   %ebx
  803928:	83 ec 1c             	sub    $0x1c,%esp
  80392b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80392f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803933:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803937:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80393b:	89 ca                	mov    %ecx,%edx
  80393d:	89 f8                	mov    %edi,%eax
  80393f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803943:	85 f6                	test   %esi,%esi
  803945:	75 2d                	jne    803974 <__udivdi3+0x50>
  803947:	39 cf                	cmp    %ecx,%edi
  803949:	77 65                	ja     8039b0 <__udivdi3+0x8c>
  80394b:	89 fd                	mov    %edi,%ebp
  80394d:	85 ff                	test   %edi,%edi
  80394f:	75 0b                	jne    80395c <__udivdi3+0x38>
  803951:	b8 01 00 00 00       	mov    $0x1,%eax
  803956:	31 d2                	xor    %edx,%edx
  803958:	f7 f7                	div    %edi
  80395a:	89 c5                	mov    %eax,%ebp
  80395c:	31 d2                	xor    %edx,%edx
  80395e:	89 c8                	mov    %ecx,%eax
  803960:	f7 f5                	div    %ebp
  803962:	89 c1                	mov    %eax,%ecx
  803964:	89 d8                	mov    %ebx,%eax
  803966:	f7 f5                	div    %ebp
  803968:	89 cf                	mov    %ecx,%edi
  80396a:	89 fa                	mov    %edi,%edx
  80396c:	83 c4 1c             	add    $0x1c,%esp
  80396f:	5b                   	pop    %ebx
  803970:	5e                   	pop    %esi
  803971:	5f                   	pop    %edi
  803972:	5d                   	pop    %ebp
  803973:	c3                   	ret    
  803974:	39 ce                	cmp    %ecx,%esi
  803976:	77 28                	ja     8039a0 <__udivdi3+0x7c>
  803978:	0f bd fe             	bsr    %esi,%edi
  80397b:	83 f7 1f             	xor    $0x1f,%edi
  80397e:	75 40                	jne    8039c0 <__udivdi3+0x9c>
  803980:	39 ce                	cmp    %ecx,%esi
  803982:	72 0a                	jb     80398e <__udivdi3+0x6a>
  803984:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803988:	0f 87 9e 00 00 00    	ja     803a2c <__udivdi3+0x108>
  80398e:	b8 01 00 00 00       	mov    $0x1,%eax
  803993:	89 fa                	mov    %edi,%edx
  803995:	83 c4 1c             	add    $0x1c,%esp
  803998:	5b                   	pop    %ebx
  803999:	5e                   	pop    %esi
  80399a:	5f                   	pop    %edi
  80399b:	5d                   	pop    %ebp
  80399c:	c3                   	ret    
  80399d:	8d 76 00             	lea    0x0(%esi),%esi
  8039a0:	31 ff                	xor    %edi,%edi
  8039a2:	31 c0                	xor    %eax,%eax
  8039a4:	89 fa                	mov    %edi,%edx
  8039a6:	83 c4 1c             	add    $0x1c,%esp
  8039a9:	5b                   	pop    %ebx
  8039aa:	5e                   	pop    %esi
  8039ab:	5f                   	pop    %edi
  8039ac:	5d                   	pop    %ebp
  8039ad:	c3                   	ret    
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	89 d8                	mov    %ebx,%eax
  8039b2:	f7 f7                	div    %edi
  8039b4:	31 ff                	xor    %edi,%edi
  8039b6:	89 fa                	mov    %edi,%edx
  8039b8:	83 c4 1c             	add    $0x1c,%esp
  8039bb:	5b                   	pop    %ebx
  8039bc:	5e                   	pop    %esi
  8039bd:	5f                   	pop    %edi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
  8039c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039c5:	89 eb                	mov    %ebp,%ebx
  8039c7:	29 fb                	sub    %edi,%ebx
  8039c9:	89 f9                	mov    %edi,%ecx
  8039cb:	d3 e6                	shl    %cl,%esi
  8039cd:	89 c5                	mov    %eax,%ebp
  8039cf:	88 d9                	mov    %bl,%cl
  8039d1:	d3 ed                	shr    %cl,%ebp
  8039d3:	89 e9                	mov    %ebp,%ecx
  8039d5:	09 f1                	or     %esi,%ecx
  8039d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039db:	89 f9                	mov    %edi,%ecx
  8039dd:	d3 e0                	shl    %cl,%eax
  8039df:	89 c5                	mov    %eax,%ebp
  8039e1:	89 d6                	mov    %edx,%esi
  8039e3:	88 d9                	mov    %bl,%cl
  8039e5:	d3 ee                	shr    %cl,%esi
  8039e7:	89 f9                	mov    %edi,%ecx
  8039e9:	d3 e2                	shl    %cl,%edx
  8039eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ef:	88 d9                	mov    %bl,%cl
  8039f1:	d3 e8                	shr    %cl,%eax
  8039f3:	09 c2                	or     %eax,%edx
  8039f5:	89 d0                	mov    %edx,%eax
  8039f7:	89 f2                	mov    %esi,%edx
  8039f9:	f7 74 24 0c          	divl   0xc(%esp)
  8039fd:	89 d6                	mov    %edx,%esi
  8039ff:	89 c3                	mov    %eax,%ebx
  803a01:	f7 e5                	mul    %ebp
  803a03:	39 d6                	cmp    %edx,%esi
  803a05:	72 19                	jb     803a20 <__udivdi3+0xfc>
  803a07:	74 0b                	je     803a14 <__udivdi3+0xf0>
  803a09:	89 d8                	mov    %ebx,%eax
  803a0b:	31 ff                	xor    %edi,%edi
  803a0d:	e9 58 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a12:	66 90                	xchg   %ax,%ax
  803a14:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a18:	89 f9                	mov    %edi,%ecx
  803a1a:	d3 e2                	shl    %cl,%edx
  803a1c:	39 c2                	cmp    %eax,%edx
  803a1e:	73 e9                	jae    803a09 <__udivdi3+0xe5>
  803a20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a23:	31 ff                	xor    %edi,%edi
  803a25:	e9 40 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	31 c0                	xor    %eax,%eax
  803a2e:	e9 37 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a33:	90                   	nop

00803a34 <__umoddi3>:
  803a34:	55                   	push   %ebp
  803a35:	57                   	push   %edi
  803a36:	56                   	push   %esi
  803a37:	53                   	push   %ebx
  803a38:	83 ec 1c             	sub    $0x1c,%esp
  803a3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a53:	89 f3                	mov    %esi,%ebx
  803a55:	89 fa                	mov    %edi,%edx
  803a57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a5b:	89 34 24             	mov    %esi,(%esp)
  803a5e:	85 c0                	test   %eax,%eax
  803a60:	75 1a                	jne    803a7c <__umoddi3+0x48>
  803a62:	39 f7                	cmp    %esi,%edi
  803a64:	0f 86 a2 00 00 00    	jbe    803b0c <__umoddi3+0xd8>
  803a6a:	89 c8                	mov    %ecx,%eax
  803a6c:	89 f2                	mov    %esi,%edx
  803a6e:	f7 f7                	div    %edi
  803a70:	89 d0                	mov    %edx,%eax
  803a72:	31 d2                	xor    %edx,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	39 f0                	cmp    %esi,%eax
  803a7e:	0f 87 ac 00 00 00    	ja     803b30 <__umoddi3+0xfc>
  803a84:	0f bd e8             	bsr    %eax,%ebp
  803a87:	83 f5 1f             	xor    $0x1f,%ebp
  803a8a:	0f 84 ac 00 00 00    	je     803b3c <__umoddi3+0x108>
  803a90:	bf 20 00 00 00       	mov    $0x20,%edi
  803a95:	29 ef                	sub    %ebp,%edi
  803a97:	89 fe                	mov    %edi,%esi
  803a99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a9d:	89 e9                	mov    %ebp,%ecx
  803a9f:	d3 e0                	shl    %cl,%eax
  803aa1:	89 d7                	mov    %edx,%edi
  803aa3:	89 f1                	mov    %esi,%ecx
  803aa5:	d3 ef                	shr    %cl,%edi
  803aa7:	09 c7                	or     %eax,%edi
  803aa9:	89 e9                	mov    %ebp,%ecx
  803aab:	d3 e2                	shl    %cl,%edx
  803aad:	89 14 24             	mov    %edx,(%esp)
  803ab0:	89 d8                	mov    %ebx,%eax
  803ab2:	d3 e0                	shl    %cl,%eax
  803ab4:	89 c2                	mov    %eax,%edx
  803ab6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aba:	d3 e0                	shl    %cl,%eax
  803abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac4:	89 f1                	mov    %esi,%ecx
  803ac6:	d3 e8                	shr    %cl,%eax
  803ac8:	09 d0                	or     %edx,%eax
  803aca:	d3 eb                	shr    %cl,%ebx
  803acc:	89 da                	mov    %ebx,%edx
  803ace:	f7 f7                	div    %edi
  803ad0:	89 d3                	mov    %edx,%ebx
  803ad2:	f7 24 24             	mull   (%esp)
  803ad5:	89 c6                	mov    %eax,%esi
  803ad7:	89 d1                	mov    %edx,%ecx
  803ad9:	39 d3                	cmp    %edx,%ebx
  803adb:	0f 82 87 00 00 00    	jb     803b68 <__umoddi3+0x134>
  803ae1:	0f 84 91 00 00 00    	je     803b78 <__umoddi3+0x144>
  803ae7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803aeb:	29 f2                	sub    %esi,%edx
  803aed:	19 cb                	sbb    %ecx,%ebx
  803aef:	89 d8                	mov    %ebx,%eax
  803af1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803af5:	d3 e0                	shl    %cl,%eax
  803af7:	89 e9                	mov    %ebp,%ecx
  803af9:	d3 ea                	shr    %cl,%edx
  803afb:	09 d0                	or     %edx,%eax
  803afd:	89 e9                	mov    %ebp,%ecx
  803aff:	d3 eb                	shr    %cl,%ebx
  803b01:	89 da                	mov    %ebx,%edx
  803b03:	83 c4 1c             	add    $0x1c,%esp
  803b06:	5b                   	pop    %ebx
  803b07:	5e                   	pop    %esi
  803b08:	5f                   	pop    %edi
  803b09:	5d                   	pop    %ebp
  803b0a:	c3                   	ret    
  803b0b:	90                   	nop
  803b0c:	89 fd                	mov    %edi,%ebp
  803b0e:	85 ff                	test   %edi,%edi
  803b10:	75 0b                	jne    803b1d <__umoddi3+0xe9>
  803b12:	b8 01 00 00 00       	mov    $0x1,%eax
  803b17:	31 d2                	xor    %edx,%edx
  803b19:	f7 f7                	div    %edi
  803b1b:	89 c5                	mov    %eax,%ebp
  803b1d:	89 f0                	mov    %esi,%eax
  803b1f:	31 d2                	xor    %edx,%edx
  803b21:	f7 f5                	div    %ebp
  803b23:	89 c8                	mov    %ecx,%eax
  803b25:	f7 f5                	div    %ebp
  803b27:	89 d0                	mov    %edx,%eax
  803b29:	e9 44 ff ff ff       	jmp    803a72 <__umoddi3+0x3e>
  803b2e:	66 90                	xchg   %ax,%ax
  803b30:	89 c8                	mov    %ecx,%eax
  803b32:	89 f2                	mov    %esi,%edx
  803b34:	83 c4 1c             	add    $0x1c,%esp
  803b37:	5b                   	pop    %ebx
  803b38:	5e                   	pop    %esi
  803b39:	5f                   	pop    %edi
  803b3a:	5d                   	pop    %ebp
  803b3b:	c3                   	ret    
  803b3c:	3b 04 24             	cmp    (%esp),%eax
  803b3f:	72 06                	jb     803b47 <__umoddi3+0x113>
  803b41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b45:	77 0f                	ja     803b56 <__umoddi3+0x122>
  803b47:	89 f2                	mov    %esi,%edx
  803b49:	29 f9                	sub    %edi,%ecx
  803b4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b4f:	89 14 24             	mov    %edx,(%esp)
  803b52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b56:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b5a:	8b 14 24             	mov    (%esp),%edx
  803b5d:	83 c4 1c             	add    $0x1c,%esp
  803b60:	5b                   	pop    %ebx
  803b61:	5e                   	pop    %esi
  803b62:	5f                   	pop    %edi
  803b63:	5d                   	pop    %ebp
  803b64:	c3                   	ret    
  803b65:	8d 76 00             	lea    0x0(%esi),%esi
  803b68:	2b 04 24             	sub    (%esp),%eax
  803b6b:	19 fa                	sbb    %edi,%edx
  803b6d:	89 d1                	mov    %edx,%ecx
  803b6f:	89 c6                	mov    %eax,%esi
  803b71:	e9 71 ff ff ff       	jmp    803ae7 <__umoddi3+0xb3>
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b7c:	72 ea                	jb     803b68 <__umoddi3+0x134>
  803b7e:	89 d9                	mov    %ebx,%ecx
  803b80:	e9 62 ff ff ff       	jmp    803ae7 <__umoddi3+0xb3>
