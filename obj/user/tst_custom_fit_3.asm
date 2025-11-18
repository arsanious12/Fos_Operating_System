
obj/user/tst_custom_fit_3:     file format elf32-i386


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
  800031:	e8 f0 10 00 00       	call   801126 <libmain>
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
  800067:	e8 08 27 00 00       	call   802774 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 4b 27 00 00       	call   8027bf <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 b4 24 00 00       	call   80257b <malloc>
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
  8000df:	e8 90 26 00 00       	call   802774 <sys_calculate_free_frames>
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
  800125:	68 20 39 80 00       	push   $0x803920
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 b5 14 00 00       	call   8015e6 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 86 26 00 00       	call   8027bf <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 39 80 00       	push   $0x80399c
  800150:	6a 0c                	push   $0xc
  800152:	e8 8f 14 00 00       	call   8015e6 <cprintf_colored>
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
  800174:	e8 fb 25 00 00       	call   802774 <sys_calculate_free_frames>
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
  8001b9:	e8 b6 25 00 00       	call   802774 <sys_calculate_free_frames>
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
  8001f8:	68 14 3a 80 00       	push   $0x803a14
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 e2 13 00 00       	call   8015e6 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 b3 25 00 00       	call   8027bf <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 3a 80 00       	push   $0x803aa0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 b5 13 00 00       	call   8015e6 <cprintf_colored>
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
  800270:	e8 c1 28 00 00       	call   802b36 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 3b 80 00       	push   $0x803b18
  80028f:	6a 0c                	push   $0xc
  800291:	e8 50 13 00 00       	call   8015e6 <cprintf_colored>
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
  8002ae:	e8 c1 24 00 00       	call   802774 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 04 25 00 00       	call   8027bf <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 d8 22 00 00       	call   8025a9 <free>
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
  8002fc:	e8 be 24 00 00       	call   8027bf <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 3b 80 00       	push   $0x803b50
  800318:	6a 0c                	push   $0xc
  80031a:	e8 c7 12 00 00       	call   8015e6 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 4d 24 00 00       	call   802774 <sys_calculate_free_frames>
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
  800342:	68 9c 3b 80 00       	push   $0x803b9c
  800347:	6a 0c                	push   $0xc
  800349:	e8 98 12 00 00       	call   8015e6 <cprintf_colored>
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
  8003a0:	e8 91 27 00 00       	call   802b36 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 f8 3b 80 00       	push   $0x803bf8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 20 12 00 00       	call   8015e6 <cprintf_colored>
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
  800416:	68 30 3c 80 00       	push   $0x803c30
  80041b:	6a 03                	push   $0x3
  80041d:	e8 c4 11 00 00       	call   8015e6 <cprintf_colored>
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
  8004df:	68 60 3c 80 00       	push   $0x803c60
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 fb 10 00 00       	call   8015e6 <cprintf_colored>
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
  8005b9:	68 60 3c 80 00       	push   $0x803c60
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 21 10 00 00       	call   8015e6 <cprintf_colored>
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
  800693:	68 60 3c 80 00       	push   $0x803c60
  800698:	6a 0c                	push   $0xc
  80069a:	e8 47 0f 00 00       	call   8015e6 <cprintf_colored>
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
  80076d:	68 60 3c 80 00       	push   $0x803c60
  800772:	6a 0c                	push   $0xc
  800774:	e8 6d 0e 00 00       	call   8015e6 <cprintf_colored>
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
  800847:	68 60 3c 80 00       	push   $0x803c60
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 93 0d 00 00       	call   8015e6 <cprintf_colored>
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
  800921:	68 60 3c 80 00       	push   $0x803c60
  800926:	6a 0c                	push   $0xc
  800928:	e8 b9 0c 00 00       	call   8015e6 <cprintf_colored>
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
  800a16:	68 60 3c 80 00       	push   $0x803c60
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 c4 0b 00 00       	call   8015e6 <cprintf_colored>
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
  800b14:	68 60 3c 80 00       	push   $0x803c60
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 c6 0a 00 00       	call   8015e6 <cprintf_colored>
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
  800c12:	68 60 3c 80 00       	push   $0x803c60
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 c8 09 00 00       	call   8015e6 <cprintf_colored>
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
  800d10:	68 60 3c 80 00       	push   $0x803c60
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 ca 08 00 00       	call   8015e6 <cprintf_colored>
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
  800dfd:	68 60 3c 80 00       	push   $0x803c60
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 dd 07 00 00       	call   8015e6 <cprintf_colored>
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
  800eea:	68 60 3c 80 00       	push   $0x803c60
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 f0 06 00 00       	call   8015e6 <cprintf_colored>
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
  800fd7:	68 60 3c 80 00       	push   $0x803c60
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 03 06 00 00       	call   8015e6 <cprintf_colored>
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
  800ffa:	68 b2 3c 80 00       	push   $0x803cb2
  800fff:	6a 03                	push   $0x3
  801001:	e8 e0 05 00 00       	call   8015e6 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 55 17 00 00       	call   802774 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 95 17 00 00       	call   8027bf <sys_pf_calculate_allocated_pages>
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
  801055:	e8 21 15 00 00       	call   80257b <malloc>
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
  801084:	68 d0 3c 80 00       	push   $0x803cd0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 56 05 00 00       	call   8015e6 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 27 17 00 00       	call   8027bf <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 0c 3d 80 00       	push   $0x803d0c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 2a 05 00 00       	call   8015e6 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 b0 16 00 00       	call   802774 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 7c 3d 80 00       	push   $0x803d7c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 fe 04 00 00       	call   8015e6 <cprintf_colored>
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
/* *********************************************************** */
#include <inc/lib.h>
#include <user/tst_malloc_helpers.h>

void _main(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 58             	sub    $0x58,%esp
	sys_set_uheap_strategy(UHP_PLACE_CUSTOMFIT);
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	6a 05                	push   $0x5
  80110a:	e8 c2 19 00 00       	call   802ad1 <sys_set_uheap_strategy>
  80110f:	83 c4 10             	add    $0x10,%esp
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
			panic("Please increase the WS size");
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
  801112:	83 ec 04             	sub    $0x4,%esp
  801115:	68 c4 3d 80 00       	push   $0x803dc4
  80111a:	6a 1a                	push   $0x1a
  80111c:	68 f5 3d 80 00       	push   $0x803df5
  801121:	e8 c5 01 00 00       	call   8012eb <_panic>

00801126 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	57                   	push   %edi
  80112a:	56                   	push   %esi
  80112b:	53                   	push   %ebx
  80112c:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80112f:	e8 09 18 00 00       	call   80293d <sys_getenvindex>
  801134:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801137:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80113a:	89 d0                	mov    %edx,%eax
  80113c:	c1 e0 06             	shl    $0x6,%eax
  80113f:	29 d0                	sub    %edx,%eax
  801141:	c1 e0 02             	shl    $0x2,%eax
  801144:	01 d0                	add    %edx,%eax
  801146:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80114d:	01 c8                	add    %ecx,%eax
  80114f:	c1 e0 03             	shl    $0x3,%eax
  801152:	01 d0                	add    %edx,%eax
  801154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80115b:	29 c2                	sub    %eax,%edx
  80115d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  801164:	89 c2                	mov    %eax,%edx
  801166:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80116c:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801171:	a1 00 52 80 00       	mov    0x805200,%eax
  801176:	8a 40 20             	mov    0x20(%eax),%al
  801179:	84 c0                	test   %al,%al
  80117b:	74 0d                	je     80118a <libmain+0x64>
		binaryname = myEnv->prog_name;
  80117d:	a1 00 52 80 00       	mov    0x805200,%eax
  801182:	83 c0 20             	add    $0x20,%eax
  801185:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80118a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118e:	7e 0a                	jle    80119a <libmain+0x74>
		binaryname = argv[0];
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	8b 00                	mov    (%eax),%eax
  801195:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80119a:	83 ec 08             	sub    $0x8,%esp
  80119d:	ff 75 0c             	pushl  0xc(%ebp)
  8011a0:	ff 75 08             	pushl  0x8(%ebp)
  8011a3:	e8 57 ff ff ff       	call   8010ff <_main>
  8011a8:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8011ab:	a1 00 50 80 00       	mov    0x805000,%eax
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	0f 84 01 01 00 00    	je     8012b9 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8011b8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011be:	bb 08 3f 80 00       	mov    $0x803f08,%ebx
  8011c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8011c8:	89 c7                	mov    %eax,%edi
  8011ca:	89 de                	mov    %ebx,%esi
  8011cc:	89 d1                	mov    %edx,%ecx
  8011ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8011d0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8011d3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8011d8:	b0 00                	mov    $0x0,%al
  8011da:	89 d7                	mov    %edx,%edi
  8011dc:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8011de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8011e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	50                   	push   %eax
  8011ec:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	e8 7b 19 00 00       	call   802b73 <sys_utilities>
  8011f8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8011fb:	e8 c4 14 00 00       	call   8026c4 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801200:	83 ec 0c             	sub    $0xc,%esp
  801203:	68 28 3e 80 00       	push   $0x803e28
  801208:	e8 ac 03 00 00       	call   8015b9 <cprintf>
  80120d:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801210:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801213:	85 c0                	test   %eax,%eax
  801215:	74 18                	je     80122f <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801217:	e8 75 19 00 00       	call   802b91 <sys_get_optimal_num_faults>
  80121c:	83 ec 08             	sub    $0x8,%esp
  80121f:	50                   	push   %eax
  801220:	68 50 3e 80 00       	push   $0x803e50
  801225:	e8 8f 03 00 00       	call   8015b9 <cprintf>
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	eb 59                	jmp    801288 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80122f:	a1 00 52 80 00       	mov    0x805200,%eax
  801234:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80123a:	a1 00 52 80 00       	mov    0x805200,%eax
  80123f:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  801245:	83 ec 04             	sub    $0x4,%esp
  801248:	52                   	push   %edx
  801249:	50                   	push   %eax
  80124a:	68 74 3e 80 00       	push   $0x803e74
  80124f:	e8 65 03 00 00       	call   8015b9 <cprintf>
  801254:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801257:	a1 00 52 80 00       	mov    0x805200,%eax
  80125c:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  801262:	a1 00 52 80 00       	mov    0x805200,%eax
  801267:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80126d:	a1 00 52 80 00       	mov    0x805200,%eax
  801272:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  801278:	51                   	push   %ecx
  801279:	52                   	push   %edx
  80127a:	50                   	push   %eax
  80127b:	68 9c 3e 80 00       	push   $0x803e9c
  801280:	e8 34 03 00 00       	call   8015b9 <cprintf>
  801285:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801288:	a1 00 52 80 00       	mov    0x805200,%eax
  80128d:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	50                   	push   %eax
  801297:	68 f4 3e 80 00       	push   $0x803ef4
  80129c:	e8 18 03 00 00       	call   8015b9 <cprintf>
  8012a1:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8012a4:	83 ec 0c             	sub    $0xc,%esp
  8012a7:	68 28 3e 80 00       	push   $0x803e28
  8012ac:	e8 08 03 00 00       	call   8015b9 <cprintf>
  8012b1:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8012b4:	e8 25 14 00 00       	call   8026de <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8012b9:	e8 1f 00 00 00       	call   8012dd <exit>
}
  8012be:	90                   	nop
  8012bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    

008012c7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8012cd:	83 ec 0c             	sub    $0xc,%esp
  8012d0:	6a 00                	push   $0x0
  8012d2:	e8 32 16 00 00       	call   802909 <sys_destroy_env>
  8012d7:	83 c4 10             	add    $0x10,%esp
}
  8012da:	90                   	nop
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <exit>:

void
exit(void)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012e3:	e8 87 16 00 00       	call   80296f <sys_exit_env>
}
  8012e8:	90                   	nop
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8012f4:	83 c0 04             	add    $0x4,%eax
  8012f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012fa:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 16                	je     801319 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801303:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  801308:	83 ec 08             	sub    $0x8,%esp
  80130b:	50                   	push   %eax
  80130c:	68 6c 3f 80 00       	push   $0x803f6c
  801311:	e8 a3 02 00 00       	call   8015b9 <cprintf>
  801316:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801319:	a1 04 50 80 00       	mov    0x805004,%eax
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	ff 75 0c             	pushl  0xc(%ebp)
  801324:	ff 75 08             	pushl  0x8(%ebp)
  801327:	50                   	push   %eax
  801328:	68 74 3f 80 00       	push   $0x803f74
  80132d:	6a 74                	push   $0x74
  80132f:	e8 b2 02 00 00       	call   8015e6 <cprintf_colored>
  801334:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801337:	8b 45 10             	mov    0x10(%ebp),%eax
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	ff 75 f4             	pushl  -0xc(%ebp)
  801340:	50                   	push   %eax
  801341:	e8 04 02 00 00       	call   80154a <vcprintf>
  801346:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	6a 00                	push   $0x0
  80134e:	68 9c 3f 80 00       	push   $0x803f9c
  801353:	e8 f2 01 00 00       	call   80154a <vcprintf>
  801358:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80135b:	e8 7d ff ff ff       	call   8012dd <exit>

	// should not return here
	while (1) ;
  801360:	eb fe                	jmp    801360 <_panic+0x75>

00801362 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801368:	a1 00 52 80 00       	mov    0x805200,%eax
  80136d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	39 c2                	cmp    %eax,%edx
  801378:	74 14                	je     80138e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80137a:	83 ec 04             	sub    $0x4,%esp
  80137d:	68 a0 3f 80 00       	push   $0x803fa0
  801382:	6a 26                	push   $0x26
  801384:	68 ec 3f 80 00       	push   $0x803fec
  801389:	e8 5d ff ff ff       	call   8012eb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80138e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801395:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80139c:	e9 c5 00 00 00       	jmp    801466 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8013a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	01 d0                	add    %edx,%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	75 08                	jne    8013be <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8013b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8013b9:	e9 a5 00 00 00       	jmp    801463 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8013be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013cc:	eb 69                	jmp    801437 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8013ce:	a1 00 52 80 00       	mov    0x805200,%eax
  8013d3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8013d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013dc:	89 d0                	mov    %edx,%eax
  8013de:	01 c0                	add    %eax,%eax
  8013e0:	01 d0                	add    %edx,%eax
  8013e2:	c1 e0 03             	shl    $0x3,%eax
  8013e5:	01 c8                	add    %ecx,%eax
  8013e7:	8a 40 04             	mov    0x4(%eax),%al
  8013ea:	84 c0                	test   %al,%al
  8013ec:	75 46                	jne    801434 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013ee:	a1 00 52 80 00       	mov    0x805200,%eax
  8013f3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8013f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	01 c0                	add    %eax,%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	c1 e0 03             	shl    $0x3,%eax
  801405:	01 c8                	add    %ecx,%eax
  801407:	8b 00                	mov    (%eax),%eax
  801409:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80140c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80140f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801414:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801419:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	01 c8                	add    %ecx,%eax
  801425:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801427:	39 c2                	cmp    %eax,%edx
  801429:	75 09                	jne    801434 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80142b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801432:	eb 15                	jmp    801449 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801434:	ff 45 e8             	incl   -0x18(%ebp)
  801437:	a1 00 52 80 00       	mov    0x805200,%eax
  80143c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801445:	39 c2                	cmp    %eax,%edx
  801447:	77 85                	ja     8013ce <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801449:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80144d:	75 14                	jne    801463 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	68 f8 3f 80 00       	push   $0x803ff8
  801457:	6a 3a                	push   $0x3a
  801459:	68 ec 3f 80 00       	push   $0x803fec
  80145e:	e8 88 fe ff ff       	call   8012eb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801463:	ff 45 f0             	incl   -0x10(%ebp)
  801466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801469:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80146c:	0f 8c 2f ff ff ff    	jl     8013a1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801472:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801480:	eb 26                	jmp    8014a8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801482:	a1 00 52 80 00       	mov    0x805200,%eax
  801487:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80148d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801490:	89 d0                	mov    %edx,%eax
  801492:	01 c0                	add    %eax,%eax
  801494:	01 d0                	add    %edx,%eax
  801496:	c1 e0 03             	shl    $0x3,%eax
  801499:	01 c8                	add    %ecx,%eax
  80149b:	8a 40 04             	mov    0x4(%eax),%al
  80149e:	3c 01                	cmp    $0x1,%al
  8014a0:	75 03                	jne    8014a5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8014a2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014a5:	ff 45 e0             	incl   -0x20(%ebp)
  8014a8:	a1 00 52 80 00       	mov    0x805200,%eax
  8014ad:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8014b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b6:	39 c2                	cmp    %eax,%edx
  8014b8:	77 c8                	ja     801482 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8014ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8014c0:	74 14                	je     8014d6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	68 4c 40 80 00       	push   $0x80404c
  8014ca:	6a 44                	push   $0x44
  8014cc:	68 ec 3f 80 00       	push   $0x803fec
  8014d1:	e8 15 fe ff ff       	call   8012eb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8014d6:	90                   	nop
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	53                   	push   %ebx
  8014dd:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 00                	mov    (%eax),%eax
  8014e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8014e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014eb:	89 0a                	mov    %ecx,(%edx)
  8014ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f0:	88 d1                	mov    %dl,%cl
  8014f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fc:	8b 00                	mov    (%eax),%eax
  8014fe:	3d ff 00 00 00       	cmp    $0xff,%eax
  801503:	75 30                	jne    801535 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801505:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  80150b:	a0 24 52 80 00       	mov    0x805224,%al
  801510:	0f b6 c0             	movzbl %al,%eax
  801513:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801516:	8b 09                	mov    (%ecx),%ecx
  801518:	89 cb                	mov    %ecx,%ebx
  80151a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80151d:	83 c1 08             	add    $0x8,%ecx
  801520:	52                   	push   %edx
  801521:	50                   	push   %eax
  801522:	53                   	push   %ebx
  801523:	51                   	push   %ecx
  801524:	e8 57 11 00 00       	call   802680 <sys_cputs>
  801529:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80152c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801535:	8b 45 0c             	mov    0xc(%ebp),%eax
  801538:	8b 40 04             	mov    0x4(%eax),%eax
  80153b:	8d 50 01             	lea    0x1(%eax),%edx
  80153e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801541:	89 50 04             	mov    %edx,0x4(%eax)
}
  801544:	90                   	nop
  801545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801553:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80155a:	00 00 00 
	b.cnt = 0;
  80155d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801564:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801567:	ff 75 0c             	pushl  0xc(%ebp)
  80156a:	ff 75 08             	pushl  0x8(%ebp)
  80156d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801573:	50                   	push   %eax
  801574:	68 d9 14 80 00       	push   $0x8014d9
  801579:	e8 5a 02 00 00       	call   8017d8 <vprintfmt>
  80157e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801581:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801587:	a0 24 52 80 00       	mov    0x805224,%al
  80158c:	0f b6 c0             	movzbl %al,%eax
  80158f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801595:	52                   	push   %edx
  801596:	50                   	push   %eax
  801597:	51                   	push   %ecx
  801598:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80159e:	83 c0 08             	add    $0x8,%eax
  8015a1:	50                   	push   %eax
  8015a2:	e8 d9 10 00 00       	call   802680 <sys_cputs>
  8015a7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8015aa:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  8015b1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015bf:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  8015c6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	83 ec 08             	sub    $0x8,%esp
  8015d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d5:	50                   	push   %eax
  8015d6:	e8 6f ff ff ff       	call   80154a <vcprintf>
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8015e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015ec:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	c1 e0 08             	shl    $0x8,%eax
  8015f9:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  8015fe:	8d 45 0c             	lea    0xc(%ebp),%eax
  801601:	83 c0 04             	add    $0x4,%eax
  801604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	ff 75 f4             	pushl  -0xc(%ebp)
  801610:	50                   	push   %eax
  801611:	e8 34 ff ff ff       	call   80154a <vcprintf>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80161c:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  801623:	07 00 00 

	return cnt;
  801626:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801631:	e8 8e 10 00 00       	call   8026c4 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801636:	8d 45 0c             	lea    0xc(%ebp),%eax
  801639:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	83 ec 08             	sub    $0x8,%esp
  801642:	ff 75 f4             	pushl  -0xc(%ebp)
  801645:	50                   	push   %eax
  801646:	e8 ff fe ff ff       	call   80154a <vcprintf>
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801651:	e8 88 10 00 00       	call   8026de <sys_unlock_cons>
	return cnt;
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	53                   	push   %ebx
  80165f:	83 ec 14             	sub    $0x14,%esp
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801668:	8b 45 14             	mov    0x14(%ebp),%eax
  80166b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80166e:	8b 45 18             	mov    0x18(%ebp),%eax
  801671:	ba 00 00 00 00       	mov    $0x0,%edx
  801676:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801679:	77 55                	ja     8016d0 <printnum+0x75>
  80167b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80167e:	72 05                	jb     801685 <printnum+0x2a>
  801680:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801683:	77 4b                	ja     8016d0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801685:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801688:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80168b:	8b 45 18             	mov    0x18(%ebp),%eax
  80168e:	ba 00 00 00 00       	mov    $0x0,%edx
  801693:	52                   	push   %edx
  801694:	50                   	push   %eax
  801695:	ff 75 f4             	pushl  -0xc(%ebp)
  801698:	ff 75 f0             	pushl  -0x10(%ebp)
  80169b:	e8 08 20 00 00       	call   8036a8 <__udivdi3>
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	ff 75 20             	pushl  0x20(%ebp)
  8016a9:	53                   	push   %ebx
  8016aa:	ff 75 18             	pushl  0x18(%ebp)
  8016ad:	52                   	push   %edx
  8016ae:	50                   	push   %eax
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	e8 a1 ff ff ff       	call   80165b <printnum>
  8016ba:	83 c4 20             	add    $0x20,%esp
  8016bd:	eb 1a                	jmp    8016d9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	ff 75 20             	pushl  0x20(%ebp)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	ff d0                	call   *%eax
  8016cd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016d0:	ff 4d 1c             	decl   0x1c(%ebp)
  8016d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8016d7:	7f e6                	jg     8016bf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016d9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8016dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e7:	53                   	push   %ebx
  8016e8:	51                   	push   %ecx
  8016e9:	52                   	push   %edx
  8016ea:	50                   	push   %eax
  8016eb:	e8 c8 20 00 00       	call   8037b8 <__umoddi3>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	05 b4 42 80 00       	add    $0x8042b4,%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	0f be c0             	movsbl %al,%eax
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	50                   	push   %eax
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	ff d0                	call   *%eax
  801709:	83 c4 10             	add    $0x10,%esp
}
  80170c:	90                   	nop
  80170d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801715:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801719:	7e 1c                	jle    801737 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8b 00                	mov    (%eax),%eax
  801720:	8d 50 08             	lea    0x8(%eax),%edx
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	89 10                	mov    %edx,(%eax)
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	8b 00                	mov    (%eax),%eax
  80172d:	83 e8 08             	sub    $0x8,%eax
  801730:	8b 50 04             	mov    0x4(%eax),%edx
  801733:	8b 00                	mov    (%eax),%eax
  801735:	eb 40                	jmp    801777 <getuint+0x65>
	else if (lflag)
  801737:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80173b:	74 1e                	je     80175b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8b 00                	mov    (%eax),%eax
  801742:	8d 50 04             	lea    0x4(%eax),%edx
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	89 10                	mov    %edx,(%eax)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8b 00                	mov    (%eax),%eax
  80174f:	83 e8 04             	sub    $0x4,%eax
  801752:	8b 00                	mov    (%eax),%eax
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	eb 1c                	jmp    801777 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8b 00                	mov    (%eax),%eax
  801760:	8d 50 04             	lea    0x4(%eax),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	89 10                	mov    %edx,(%eax)
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8b 00                	mov    (%eax),%eax
  80176d:	83 e8 04             	sub    $0x4,%eax
  801770:	8b 00                	mov    (%eax),%eax
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    

00801779 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80177c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801780:	7e 1c                	jle    80179e <getint+0x25>
		return va_arg(*ap, long long);
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	8d 50 08             	lea    0x8(%eax),%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 10                	mov    %edx,(%eax)
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 00                	mov    (%eax),%eax
  801794:	83 e8 08             	sub    $0x8,%eax
  801797:	8b 50 04             	mov    0x4(%eax),%edx
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	eb 38                	jmp    8017d6 <getint+0x5d>
	else if (lflag)
  80179e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a2:	74 1a                	je     8017be <getint+0x45>
		return va_arg(*ap, long);
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	8d 50 04             	lea    0x4(%eax),%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 10                	mov    %edx,(%eax)
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8b 00                	mov    (%eax),%eax
  8017b6:	83 e8 04             	sub    $0x4,%eax
  8017b9:	8b 00                	mov    (%eax),%eax
  8017bb:	99                   	cltd   
  8017bc:	eb 18                	jmp    8017d6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8b 00                	mov    (%eax),%eax
  8017c3:	8d 50 04             	lea    0x4(%eax),%edx
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	89 10                	mov    %edx,(%eax)
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8b 00                	mov    (%eax),%eax
  8017d0:	83 e8 04             	sub    $0x4,%eax
  8017d3:	8b 00                	mov    (%eax),%eax
  8017d5:	99                   	cltd   
}
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    

008017d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	56                   	push   %esi
  8017dc:	53                   	push   %ebx
  8017dd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017e0:	eb 17                	jmp    8017f9 <vprintfmt+0x21>
			if (ch == '\0')
  8017e2:	85 db                	test   %ebx,%ebx
  8017e4:	0f 84 c1 03 00 00    	je     801bab <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	53                   	push   %ebx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	ff d0                	call   *%eax
  8017f6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fc:	8d 50 01             	lea    0x1(%eax),%edx
  8017ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801802:	8a 00                	mov    (%eax),%al
  801804:	0f b6 d8             	movzbl %al,%ebx
  801807:	83 fb 25             	cmp    $0x25,%ebx
  80180a:	75 d6                	jne    8017e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80180c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801810:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801817:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80181e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801825:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80182c:	8b 45 10             	mov    0x10(%ebp),%eax
  80182f:	8d 50 01             	lea    0x1(%eax),%edx
  801832:	89 55 10             	mov    %edx,0x10(%ebp)
  801835:	8a 00                	mov    (%eax),%al
  801837:	0f b6 d8             	movzbl %al,%ebx
  80183a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80183d:	83 f8 5b             	cmp    $0x5b,%eax
  801840:	0f 87 3d 03 00 00    	ja     801b83 <vprintfmt+0x3ab>
  801846:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
  80184d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80184f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801853:	eb d7                	jmp    80182c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801855:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801859:	eb d1                	jmp    80182c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80185b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801862:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801865:	89 d0                	mov    %edx,%eax
  801867:	c1 e0 02             	shl    $0x2,%eax
  80186a:	01 d0                	add    %edx,%eax
  80186c:	01 c0                	add    %eax,%eax
  80186e:	01 d8                	add    %ebx,%eax
  801870:	83 e8 30             	sub    $0x30,%eax
  801873:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801876:	8b 45 10             	mov    0x10(%ebp),%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80187e:	83 fb 2f             	cmp    $0x2f,%ebx
  801881:	7e 3e                	jle    8018c1 <vprintfmt+0xe9>
  801883:	83 fb 39             	cmp    $0x39,%ebx
  801886:	7f 39                	jg     8018c1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801888:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80188b:	eb d5                	jmp    801862 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80188d:	8b 45 14             	mov    0x14(%ebp),%eax
  801890:	83 c0 04             	add    $0x4,%eax
  801893:	89 45 14             	mov    %eax,0x14(%ebp)
  801896:	8b 45 14             	mov    0x14(%ebp),%eax
  801899:	83 e8 04             	sub    $0x4,%eax
  80189c:	8b 00                	mov    (%eax),%eax
  80189e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8018a1:	eb 1f                	jmp    8018c2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8018a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018a7:	79 83                	jns    80182c <vprintfmt+0x54>
				width = 0;
  8018a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8018b0:	e9 77 ff ff ff       	jmp    80182c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8018b5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8018bc:	e9 6b ff ff ff       	jmp    80182c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8018c1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8018c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018c6:	0f 89 60 ff ff ff    	jns    80182c <vprintfmt+0x54>
				width = precision, precision = -1;
  8018cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8018d9:	e9 4e ff ff ff       	jmp    80182c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8018de:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8018e1:	e9 46 ff ff ff       	jmp    80182c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8018e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e9:	83 c0 04             	add    $0x4,%eax
  8018ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8018ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f2:	83 e8 04             	sub    $0x4,%eax
  8018f5:	8b 00                	mov    (%eax),%eax
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	ff d0                	call   *%eax
  801903:	83 c4 10             	add    $0x10,%esp
			break;
  801906:	e9 9b 02 00 00       	jmp    801ba6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80190b:	8b 45 14             	mov    0x14(%ebp),%eax
  80190e:	83 c0 04             	add    $0x4,%eax
  801911:	89 45 14             	mov    %eax,0x14(%ebp)
  801914:	8b 45 14             	mov    0x14(%ebp),%eax
  801917:	83 e8 04             	sub    $0x4,%eax
  80191a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80191c:	85 db                	test   %ebx,%ebx
  80191e:	79 02                	jns    801922 <vprintfmt+0x14a>
				err = -err;
  801920:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801922:	83 fb 64             	cmp    $0x64,%ebx
  801925:	7f 0b                	jg     801932 <vprintfmt+0x15a>
  801927:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  80192e:	85 f6                	test   %esi,%esi
  801930:	75 19                	jne    80194b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801932:	53                   	push   %ebx
  801933:	68 c5 42 80 00       	push   $0x8042c5
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	e8 70 02 00 00       	call   801bb3 <printfmt>
  801943:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801946:	e9 5b 02 00 00       	jmp    801ba6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80194b:	56                   	push   %esi
  80194c:	68 ce 42 80 00       	push   $0x8042ce
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	e8 57 02 00 00       	call   801bb3 <printfmt>
  80195c:	83 c4 10             	add    $0x10,%esp
			break;
  80195f:	e9 42 02 00 00       	jmp    801ba6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801964:	8b 45 14             	mov    0x14(%ebp),%eax
  801967:	83 c0 04             	add    $0x4,%eax
  80196a:	89 45 14             	mov    %eax,0x14(%ebp)
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	83 e8 04             	sub    $0x4,%eax
  801973:	8b 30                	mov    (%eax),%esi
  801975:	85 f6                	test   %esi,%esi
  801977:	75 05                	jne    80197e <vprintfmt+0x1a6>
				p = "(null)";
  801979:	be d1 42 80 00       	mov    $0x8042d1,%esi
			if (width > 0 && padc != '-')
  80197e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801982:	7e 6d                	jle    8019f1 <vprintfmt+0x219>
  801984:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801988:	74 67                	je     8019f1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80198a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80198d:	83 ec 08             	sub    $0x8,%esp
  801990:	50                   	push   %eax
  801991:	56                   	push   %esi
  801992:	e8 1e 03 00 00       	call   801cb5 <strnlen>
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80199d:	eb 16                	jmp    8019b5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80199f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	50                   	push   %eax
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	ff d0                	call   *%eax
  8019af:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8019b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8019b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019b9:	7f e4                	jg     80199f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019bb:	eb 34                	jmp    8019f1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8019bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019c1:	74 1c                	je     8019df <vprintfmt+0x207>
  8019c3:	83 fb 1f             	cmp    $0x1f,%ebx
  8019c6:	7e 05                	jle    8019cd <vprintfmt+0x1f5>
  8019c8:	83 fb 7e             	cmp    $0x7e,%ebx
  8019cb:	7e 12                	jle    8019df <vprintfmt+0x207>
					putch('?', putdat);
  8019cd:	83 ec 08             	sub    $0x8,%esp
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	6a 3f                	push   $0x3f
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	ff d0                	call   *%eax
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	eb 0f                	jmp    8019ee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	53                   	push   %ebx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	ff d0                	call   *%eax
  8019eb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019ee:	ff 4d e4             	decl   -0x1c(%ebp)
  8019f1:	89 f0                	mov    %esi,%eax
  8019f3:	8d 70 01             	lea    0x1(%eax),%esi
  8019f6:	8a 00                	mov    (%eax),%al
  8019f8:	0f be d8             	movsbl %al,%ebx
  8019fb:	85 db                	test   %ebx,%ebx
  8019fd:	74 24                	je     801a23 <vprintfmt+0x24b>
  8019ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a03:	78 b8                	js     8019bd <vprintfmt+0x1e5>
  801a05:	ff 4d e0             	decl   -0x20(%ebp)
  801a08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a0c:	79 af                	jns    8019bd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a0e:	eb 13                	jmp    801a23 <vprintfmt+0x24b>
				putch(' ', putdat);
  801a10:	83 ec 08             	sub    $0x8,%esp
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	6a 20                	push   $0x20
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	ff d0                	call   *%eax
  801a1d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a20:	ff 4d e4             	decl   -0x1c(%ebp)
  801a23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a27:	7f e7                	jg     801a10 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801a29:	e9 78 01 00 00       	jmp    801ba6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	ff 75 e8             	pushl  -0x18(%ebp)
  801a34:	8d 45 14             	lea    0x14(%ebp),%eax
  801a37:	50                   	push   %eax
  801a38:	e8 3c fd ff ff       	call   801779 <getint>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4c:	85 d2                	test   %edx,%edx
  801a4e:	79 23                	jns    801a73 <vprintfmt+0x29b>
				putch('-', putdat);
  801a50:	83 ec 08             	sub    $0x8,%esp
  801a53:	ff 75 0c             	pushl  0xc(%ebp)
  801a56:	6a 2d                	push   $0x2d
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	ff d0                	call   *%eax
  801a5d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a66:	f7 d8                	neg    %eax
  801a68:	83 d2 00             	adc    $0x0,%edx
  801a6b:	f7 da                	neg    %edx
  801a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801a73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a7a:	e9 bc 00 00 00       	jmp    801b3b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	ff 75 e8             	pushl  -0x18(%ebp)
  801a85:	8d 45 14             	lea    0x14(%ebp),%eax
  801a88:	50                   	push   %eax
  801a89:	e8 84 fc ff ff       	call   801712 <getuint>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a9e:	e9 98 00 00 00       	jmp    801b3b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801aa3:	83 ec 08             	sub    $0x8,%esp
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	6a 58                	push   $0x58
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	ff d0                	call   *%eax
  801ab0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ab3:	83 ec 08             	sub    $0x8,%esp
  801ab6:	ff 75 0c             	pushl  0xc(%ebp)
  801ab9:	6a 58                	push   $0x58
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	ff d0                	call   *%eax
  801ac0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ac3:	83 ec 08             	sub    $0x8,%esp
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	6a 58                	push   $0x58
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	ff d0                	call   *%eax
  801ad0:	83 c4 10             	add    $0x10,%esp
			break;
  801ad3:	e9 ce 00 00 00       	jmp    801ba6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801ad8:	83 ec 08             	sub    $0x8,%esp
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	6a 30                	push   $0x30
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	ff d0                	call   *%eax
  801ae5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	6a 78                	push   $0x78
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	ff d0                	call   *%eax
  801af5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801af8:	8b 45 14             	mov    0x14(%ebp),%eax
  801afb:	83 c0 04             	add    $0x4,%eax
  801afe:	89 45 14             	mov    %eax,0x14(%ebp)
  801b01:	8b 45 14             	mov    0x14(%ebp),%eax
  801b04:	83 e8 04             	sub    $0x4,%eax
  801b07:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801b13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801b1a:	eb 1f                	jmp    801b3b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801b1c:	83 ec 08             	sub    $0x8,%esp
  801b1f:	ff 75 e8             	pushl  -0x18(%ebp)
  801b22:	8d 45 14             	lea    0x14(%ebp),%eax
  801b25:	50                   	push   %eax
  801b26:	e8 e7 fb ff ff       	call   801712 <getuint>
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801b34:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801b3b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	52                   	push   %edx
  801b46:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b49:	50                   	push   %eax
  801b4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801b50:	ff 75 0c             	pushl  0xc(%ebp)
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 00 fb ff ff       	call   80165b <printnum>
  801b5b:	83 c4 20             	add    $0x20,%esp
			break;
  801b5e:	eb 46                	jmp    801ba6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801b60:	83 ec 08             	sub    $0x8,%esp
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	53                   	push   %ebx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	ff d0                	call   *%eax
  801b6c:	83 c4 10             	add    $0x10,%esp
			break;
  801b6f:	eb 35                	jmp    801ba6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801b71:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801b78:	eb 2c                	jmp    801ba6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801b7a:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801b81:	eb 23                	jmp    801ba6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	6a 25                	push   $0x25
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	ff d0                	call   *%eax
  801b90:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b93:	ff 4d 10             	decl   0x10(%ebp)
  801b96:	eb 03                	jmp    801b9b <vprintfmt+0x3c3>
  801b98:	ff 4d 10             	decl   0x10(%ebp)
  801b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9e:	48                   	dec    %eax
  801b9f:	8a 00                	mov    (%eax),%al
  801ba1:	3c 25                	cmp    $0x25,%al
  801ba3:	75 f3                	jne    801b98 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801ba5:	90                   	nop
		}
	}
  801ba6:	e9 35 fc ff ff       	jmp    8017e0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801bab:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    

00801bb3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801bb9:	8d 45 10             	lea    0x10(%ebp),%eax
  801bbc:	83 c0 04             	add    $0x4,%eax
  801bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc8:	50                   	push   %eax
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	ff 75 08             	pushl  0x8(%ebp)
  801bcf:	e8 04 fc ff ff       	call   8017d8 <vprintfmt>
  801bd4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801bd7:	90                   	nop
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be0:	8b 40 08             	mov    0x8(%eax),%eax
  801be3:	8d 50 01             	lea    0x1(%eax),%edx
  801be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bef:	8b 10                	mov    (%eax),%edx
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	8b 40 04             	mov    0x4(%eax),%eax
  801bf7:	39 c2                	cmp    %eax,%edx
  801bf9:	73 12                	jae    801c0d <sprintputch+0x33>
		*b->buf++ = ch;
  801bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfe:	8b 00                	mov    (%eax),%eax
  801c00:	8d 48 01             	lea    0x1(%eax),%ecx
  801c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c06:	89 0a                	mov    %ecx,(%edx)
  801c08:	8b 55 08             	mov    0x8(%ebp),%edx
  801c0b:	88 10                	mov    %dl,(%eax)
}
  801c0d:	90                   	nop
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    

00801c10 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	01 d0                	add    %edx,%eax
  801c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c35:	74 06                	je     801c3d <vsnprintf+0x2d>
  801c37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c3b:	7f 07                	jg     801c44 <vsnprintf+0x34>
		return -E_INVAL;
  801c3d:	b8 03 00 00 00       	mov    $0x3,%eax
  801c42:	eb 20                	jmp    801c64 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c44:	ff 75 14             	pushl  0x14(%ebp)
  801c47:	ff 75 10             	pushl  0x10(%ebp)
  801c4a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c4d:	50                   	push   %eax
  801c4e:	68 da 1b 80 00       	push   $0x801bda
  801c53:	e8 80 fb ff ff       	call   8017d8 <vprintfmt>
  801c58:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c6c:	8d 45 10             	lea    0x10(%ebp),%eax
  801c6f:	83 c0 04             	add    $0x4,%eax
  801c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801c75:	8b 45 10             	mov    0x10(%ebp),%eax
  801c78:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7b:	50                   	push   %eax
  801c7c:	ff 75 0c             	pushl  0xc(%ebp)
  801c7f:	ff 75 08             	pushl  0x8(%ebp)
  801c82:	e8 89 ff ff ff       	call   801c10 <vsnprintf>
  801c87:	83 c4 10             	add    $0x10,%esp
  801c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801c98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c9f:	eb 06                	jmp    801ca7 <strlen+0x15>
		n++;
  801ca1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ca4:	ff 45 08             	incl   0x8(%ebp)
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	84 c0                	test   %al,%al
  801cae:	75 f1                	jne    801ca1 <strlen+0xf>
		n++;
	return n;
  801cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cc2:	eb 09                	jmp    801ccd <strnlen+0x18>
		n++;
  801cc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cc7:	ff 45 08             	incl   0x8(%ebp)
  801cca:	ff 4d 0c             	decl   0xc(%ebp)
  801ccd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cd1:	74 09                	je     801cdc <strnlen+0x27>
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	8a 00                	mov    (%eax),%al
  801cd8:	84 c0                	test   %al,%al
  801cda:	75 e8                	jne    801cc4 <strnlen+0xf>
		n++;
	return n;
  801cdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801ced:	90                   	nop
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	8d 50 01             	lea    0x1(%eax),%edx
  801cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  801cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfa:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cfd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d00:	8a 12                	mov    (%edx),%dl
  801d02:	88 10                	mov    %dl,(%eax)
  801d04:	8a 00                	mov    (%eax),%al
  801d06:	84 c0                	test   %al,%al
  801d08:	75 e4                	jne    801cee <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801d1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d22:	eb 1f                	jmp    801d43 <strncpy+0x34>
		*dst++ = *src;
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	8d 50 01             	lea    0x1(%eax),%edx
  801d2a:	89 55 08             	mov    %edx,0x8(%ebp)
  801d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d30:	8a 12                	mov    (%edx),%dl
  801d32:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d37:	8a 00                	mov    (%eax),%al
  801d39:	84 c0                	test   %al,%al
  801d3b:	74 03                	je     801d40 <strncpy+0x31>
			src++;
  801d3d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d40:	ff 45 fc             	incl   -0x4(%ebp)
  801d43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d46:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d49:	72 d9                	jb     801d24 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801d4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801d5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d60:	74 30                	je     801d92 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801d62:	eb 16                	jmp    801d7a <strlcpy+0x2a>
			*dst++ = *src++;
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	8d 50 01             	lea    0x1(%eax),%edx
  801d6a:	89 55 08             	mov    %edx,0x8(%ebp)
  801d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d70:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d73:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d76:	8a 12                	mov    (%edx),%dl
  801d78:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801d7a:	ff 4d 10             	decl   0x10(%ebp)
  801d7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d81:	74 09                	je     801d8c <strlcpy+0x3c>
  801d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d86:	8a 00                	mov    (%eax),%al
  801d88:	84 c0                	test   %al,%al
  801d8a:	75 d8                	jne    801d64 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d92:	8b 55 08             	mov    0x8(%ebp),%edx
  801d95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d98:	29 c2                	sub    %eax,%edx
  801d9a:	89 d0                	mov    %edx,%eax
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801da1:	eb 06                	jmp    801da9 <strcmp+0xb>
		p++, q++;
  801da3:	ff 45 08             	incl   0x8(%ebp)
  801da6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	8a 00                	mov    (%eax),%al
  801dae:	84 c0                	test   %al,%al
  801db0:	74 0e                	je     801dc0 <strcmp+0x22>
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	8a 10                	mov    (%eax),%dl
  801db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dba:	8a 00                	mov    (%eax),%al
  801dbc:	38 c2                	cmp    %al,%dl
  801dbe:	74 e3                	je     801da3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	8a 00                	mov    (%eax),%al
  801dc5:	0f b6 d0             	movzbl %al,%edx
  801dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcb:	8a 00                	mov    (%eax),%al
  801dcd:	0f b6 c0             	movzbl %al,%eax
  801dd0:	29 c2                	sub    %eax,%edx
  801dd2:	89 d0                	mov    %edx,%eax
}
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    

00801dd6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801dd9:	eb 09                	jmp    801de4 <strncmp+0xe>
		n--, p++, q++;
  801ddb:	ff 4d 10             	decl   0x10(%ebp)
  801dde:	ff 45 08             	incl   0x8(%ebp)
  801de1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801de4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801de8:	74 17                	je     801e01 <strncmp+0x2b>
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	8a 00                	mov    (%eax),%al
  801def:	84 c0                	test   %al,%al
  801df1:	74 0e                	je     801e01 <strncmp+0x2b>
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	8a 10                	mov    (%eax),%dl
  801df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfb:	8a 00                	mov    (%eax),%al
  801dfd:	38 c2                	cmp    %al,%dl
  801dff:	74 da                	je     801ddb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e05:	75 07                	jne    801e0e <strncmp+0x38>
		return 0;
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	eb 14                	jmp    801e22 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	8a 00                	mov    (%eax),%al
  801e13:	0f b6 d0             	movzbl %al,%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	8a 00                	mov    (%eax),%al
  801e1b:	0f b6 c0             	movzbl %al,%eax
  801e1e:	29 c2                	sub    %eax,%edx
  801e20:	89 d0                	mov    %edx,%eax
}
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    

00801e24 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e30:	eb 12                	jmp    801e44 <strchr+0x20>
		if (*s == c)
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	8a 00                	mov    (%eax),%al
  801e37:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e3a:	75 05                	jne    801e41 <strchr+0x1d>
			return (char *) s;
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	eb 11                	jmp    801e52 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801e41:	ff 45 08             	incl   0x8(%ebp)
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	8a 00                	mov    (%eax),%al
  801e49:	84 c0                	test   %al,%al
  801e4b:	75 e5                	jne    801e32 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e60:	eb 0d                	jmp    801e6f <strfind+0x1b>
		if (*s == c)
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	8a 00                	mov    (%eax),%al
  801e67:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e6a:	74 0e                	je     801e7a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801e6c:	ff 45 08             	incl   0x8(%ebp)
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	8a 00                	mov    (%eax),%al
  801e74:	84 c0                	test   %al,%al
  801e76:	75 ea                	jne    801e62 <strfind+0xe>
  801e78:	eb 01                	jmp    801e7b <strfind+0x27>
		if (*s == c)
			break;
  801e7a:	90                   	nop
	return (char *) s;
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801e8c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801e90:	76 63                	jbe    801ef5 <memset+0x75>
		uint64 data_block = c;
  801e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e95:	99                   	cltd   
  801e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e99:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea2:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801ea6:	c1 e0 08             	shl    $0x8,%eax
  801ea9:	09 45 f0             	or     %eax,-0x10(%ebp)
  801eac:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb5:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801eb9:	c1 e0 10             	shl    $0x10,%eax
  801ebc:	09 45 f0             	or     %eax,-0x10(%ebp)
  801ebf:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec8:	89 c2                	mov    %eax,%edx
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecf:	09 45 f0             	or     %eax,-0x10(%ebp)
  801ed2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801ed5:	eb 18                	jmp    801eef <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801ed7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801eda:	8d 41 08             	lea    0x8(%ecx),%eax
  801edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee6:	89 01                	mov    %eax,(%ecx)
  801ee8:	89 51 04             	mov    %edx,0x4(%ecx)
  801eeb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801eef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ef3:	77 e2                	ja     801ed7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801ef5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ef9:	74 23                	je     801f1e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801efe:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f01:	eb 0e                	jmp    801f11 <memset+0x91>
			*p8++ = (uint8)c;
  801f03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f06:	8d 50 01             	lea    0x1(%eax),%edx
  801f09:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f17:	89 55 10             	mov    %edx,0x10(%ebp)
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	75 e5                	jne    801f03 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801f35:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f39:	76 24                	jbe    801f5f <memcpy+0x3c>
		while(n >= 8){
  801f3b:	eb 1c                	jmp    801f59 <memcpy+0x36>
			*d64 = *s64;
  801f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f40:	8b 50 04             	mov    0x4(%eax),%edx
  801f43:	8b 00                	mov    (%eax),%eax
  801f45:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f48:	89 01                	mov    %eax,(%ecx)
  801f4a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801f4d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801f51:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801f55:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801f59:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f5d:	77 de                	ja     801f3d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801f5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f63:	74 31                	je     801f96 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801f65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f68:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801f71:	eb 16                	jmp    801f89 <memcpy+0x66>
			*d8++ = *s8++;
  801f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f76:	8d 50 01             	lea    0x1(%eax),%edx
  801f79:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f82:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801f85:	8a 12                	mov    (%edx),%dl
  801f87:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801f89:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f8f:	89 55 10             	mov    %edx,0x10(%ebp)
  801f92:	85 c0                	test   %eax,%eax
  801f94:	75 dd                	jne    801f73 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fb3:	73 50                	jae    802005 <memmove+0x6a>
  801fb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbb:	01 d0                	add    %edx,%eax
  801fbd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fc0:	76 43                	jbe    802005 <memmove+0x6a>
		s += n;
  801fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fce:	eb 10                	jmp    801fe0 <memmove+0x45>
			*--d = *--s;
  801fd0:	ff 4d f8             	decl   -0x8(%ebp)
  801fd3:	ff 4d fc             	decl   -0x4(%ebp)
  801fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd9:	8a 10                	mov    (%eax),%dl
  801fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fde:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fe6:	89 55 10             	mov    %edx,0x10(%ebp)
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	75 e3                	jne    801fd0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801fed:	eb 23                	jmp    802012 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff2:	8d 50 01             	lea    0x1(%eax),%edx
  801ff5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ff8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ffb:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ffe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802001:	8a 12                	mov    (%edx),%dl
  802003:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802005:	8b 45 10             	mov    0x10(%ebp),%eax
  802008:	8d 50 ff             	lea    -0x1(%eax),%edx
  80200b:	89 55 10             	mov    %edx,0x10(%ebp)
  80200e:	85 c0                	test   %eax,%eax
  802010:	75 dd                	jne    801fef <memmove+0x54>
			*d++ = *s++;

	return dst;
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802023:	8b 45 0c             	mov    0xc(%ebp),%eax
  802026:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802029:	eb 2a                	jmp    802055 <memcmp+0x3e>
		if (*s1 != *s2)
  80202b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202e:	8a 10                	mov    (%eax),%dl
  802030:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802033:	8a 00                	mov    (%eax),%al
  802035:	38 c2                	cmp    %al,%dl
  802037:	74 16                	je     80204f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802039:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80203c:	8a 00                	mov    (%eax),%al
  80203e:	0f b6 d0             	movzbl %al,%edx
  802041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802044:	8a 00                	mov    (%eax),%al
  802046:	0f b6 c0             	movzbl %al,%eax
  802049:	29 c2                	sub    %eax,%edx
  80204b:	89 d0                	mov    %edx,%eax
  80204d:	eb 18                	jmp    802067 <memcmp+0x50>
		s1++, s2++;
  80204f:	ff 45 fc             	incl   -0x4(%ebp)
  802052:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802055:	8b 45 10             	mov    0x10(%ebp),%eax
  802058:	8d 50 ff             	lea    -0x1(%eax),%edx
  80205b:	89 55 10             	mov    %edx,0x10(%ebp)
  80205e:	85 c0                	test   %eax,%eax
  802060:	75 c9                	jne    80202b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802062:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	8b 45 10             	mov    0x10(%ebp),%eax
  802075:	01 d0                	add    %edx,%eax
  802077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80207a:	eb 15                	jmp    802091 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	8a 00                	mov    (%eax),%al
  802081:	0f b6 d0             	movzbl %al,%edx
  802084:	8b 45 0c             	mov    0xc(%ebp),%eax
  802087:	0f b6 c0             	movzbl %al,%eax
  80208a:	39 c2                	cmp    %eax,%edx
  80208c:	74 0d                	je     80209b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80208e:	ff 45 08             	incl   0x8(%ebp)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802097:	72 e3                	jb     80207c <memfind+0x13>
  802099:	eb 01                	jmp    80209c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80209b:	90                   	nop
	return (void *) s;
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020b5:	eb 03                	jmp    8020ba <strtol+0x19>
		s++;
  8020b7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8a 00                	mov    (%eax),%al
  8020bf:	3c 20                	cmp    $0x20,%al
  8020c1:	74 f4                	je     8020b7 <strtol+0x16>
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	8a 00                	mov    (%eax),%al
  8020c8:	3c 09                	cmp    $0x9,%al
  8020ca:	74 eb                	je     8020b7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	8a 00                	mov    (%eax),%al
  8020d1:	3c 2b                	cmp    $0x2b,%al
  8020d3:	75 05                	jne    8020da <strtol+0x39>
		s++;
  8020d5:	ff 45 08             	incl   0x8(%ebp)
  8020d8:	eb 13                	jmp    8020ed <strtol+0x4c>
	else if (*s == '-')
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	8a 00                	mov    (%eax),%al
  8020df:	3c 2d                	cmp    $0x2d,%al
  8020e1:	75 0a                	jne    8020ed <strtol+0x4c>
		s++, neg = 1;
  8020e3:	ff 45 08             	incl   0x8(%ebp)
  8020e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f1:	74 06                	je     8020f9 <strtol+0x58>
  8020f3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8020f7:	75 20                	jne    802119 <strtol+0x78>
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8a 00                	mov    (%eax),%al
  8020fe:	3c 30                	cmp    $0x30,%al
  802100:	75 17                	jne    802119 <strtol+0x78>
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	40                   	inc    %eax
  802106:	8a 00                	mov    (%eax),%al
  802108:	3c 78                	cmp    $0x78,%al
  80210a:	75 0d                	jne    802119 <strtol+0x78>
		s += 2, base = 16;
  80210c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802110:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802117:	eb 28                	jmp    802141 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802119:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80211d:	75 15                	jne    802134 <strtol+0x93>
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8a 00                	mov    (%eax),%al
  802124:	3c 30                	cmp    $0x30,%al
  802126:	75 0c                	jne    802134 <strtol+0x93>
		s++, base = 8;
  802128:	ff 45 08             	incl   0x8(%ebp)
  80212b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802132:	eb 0d                	jmp    802141 <strtol+0xa0>
	else if (base == 0)
  802134:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802138:	75 07                	jne    802141 <strtol+0xa0>
		base = 10;
  80213a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8a 00                	mov    (%eax),%al
  802146:	3c 2f                	cmp    $0x2f,%al
  802148:	7e 19                	jle    802163 <strtol+0xc2>
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	8a 00                	mov    (%eax),%al
  80214f:	3c 39                	cmp    $0x39,%al
  802151:	7f 10                	jg     802163 <strtol+0xc2>
			dig = *s - '0';
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	8a 00                	mov    (%eax),%al
  802158:	0f be c0             	movsbl %al,%eax
  80215b:	83 e8 30             	sub    $0x30,%eax
  80215e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802161:	eb 42                	jmp    8021a5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	8a 00                	mov    (%eax),%al
  802168:	3c 60                	cmp    $0x60,%al
  80216a:	7e 19                	jle    802185 <strtol+0xe4>
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8a 00                	mov    (%eax),%al
  802171:	3c 7a                	cmp    $0x7a,%al
  802173:	7f 10                	jg     802185 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	8a 00                	mov    (%eax),%al
  80217a:	0f be c0             	movsbl %al,%eax
  80217d:	83 e8 57             	sub    $0x57,%eax
  802180:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802183:	eb 20                	jmp    8021a5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	8a 00                	mov    (%eax),%al
  80218a:	3c 40                	cmp    $0x40,%al
  80218c:	7e 39                	jle    8021c7 <strtol+0x126>
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	8a 00                	mov    (%eax),%al
  802193:	3c 5a                	cmp    $0x5a,%al
  802195:	7f 30                	jg     8021c7 <strtol+0x126>
			dig = *s - 'A' + 10;
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	8a 00                	mov    (%eax),%al
  80219c:	0f be c0             	movsbl %al,%eax
  80219f:	83 e8 37             	sub    $0x37,%eax
  8021a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021ab:	7d 19                	jge    8021c6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021ad:	ff 45 08             	incl   0x8(%ebp)
  8021b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021b3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021b7:	89 c2                	mov    %eax,%edx
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	01 d0                	add    %edx,%eax
  8021be:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021c1:	e9 7b ff ff ff       	jmp    802141 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021c6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021cb:	74 08                	je     8021d5 <strtol+0x134>
		*endptr = (char *) s;
  8021cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d9:	74 07                	je     8021e2 <strtol+0x141>
  8021db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021de:	f7 d8                	neg    %eax
  8021e0:	eb 03                	jmp    8021e5 <strtol+0x144>
  8021e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <ltostr>:

void
ltostr(long value, char *str)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8021ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8021f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8021fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ff:	79 13                	jns    802214 <ltostr+0x2d>
	{
		neg = 1;
  802201:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80220e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802211:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80221c:	99                   	cltd   
  80221d:	f7 f9                	idiv   %ecx
  80221f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802225:	8d 50 01             	lea    0x1(%eax),%edx
  802228:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80222b:	89 c2                	mov    %eax,%edx
  80222d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802230:	01 d0                	add    %edx,%eax
  802232:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802235:	83 c2 30             	add    $0x30,%edx
  802238:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80223a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80223d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802242:	f7 e9                	imul   %ecx
  802244:	c1 fa 02             	sar    $0x2,%edx
  802247:	89 c8                	mov    %ecx,%eax
  802249:	c1 f8 1f             	sar    $0x1f,%eax
  80224c:	29 c2                	sub    %eax,%edx
  80224e:	89 d0                	mov    %edx,%eax
  802250:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802253:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802257:	75 bb                	jne    802214 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802263:	48                   	dec    %eax
  802264:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802267:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80226b:	74 3d                	je     8022aa <ltostr+0xc3>
		start = 1 ;
  80226d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802274:	eb 34                	jmp    8022aa <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227c:	01 d0                	add    %edx,%eax
  80227e:	8a 00                	mov    (%eax),%al
  802280:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802286:	8b 45 0c             	mov    0xc(%ebp),%eax
  802289:	01 c2                	add    %eax,%edx
  80228b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80228e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802291:	01 c8                	add    %ecx,%eax
  802293:	8a 00                	mov    (%eax),%al
  802295:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802297:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229d:	01 c2                	add    %eax,%edx
  80229f:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022a2:	88 02                	mov    %al,(%edx)
		start++ ;
  8022a4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022a7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022b0:	7c c4                	jl     802276 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b8:	01 d0                	add    %edx,%eax
  8022ba:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022bd:	90                   	nop
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8022c6:	ff 75 08             	pushl  0x8(%ebp)
  8022c9:	e8 c4 f9 ff ff       	call   801c92 <strlen>
  8022ce:	83 c4 04             	add    $0x4,%esp
  8022d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	e8 b6 f9 ff ff       	call   801c92 <strlen>
  8022dc:	83 c4 04             	add    $0x4,%esp
  8022df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8022e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8022e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022f0:	eb 17                	jmp    802309 <strcconcat+0x49>
		final[s] = str1[s] ;
  8022f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f8:	01 c2                	add    %eax,%edx
  8022fa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	01 c8                	add    %ecx,%eax
  802302:	8a 00                	mov    (%eax),%al
  802304:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802306:	ff 45 fc             	incl   -0x4(%ebp)
  802309:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80230f:	7c e1                	jl     8022f2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802311:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802318:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80231f:	eb 1f                	jmp    802340 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802321:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802324:	8d 50 01             	lea    0x1(%eax),%edx
  802327:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80232a:	89 c2                	mov    %eax,%edx
  80232c:	8b 45 10             	mov    0x10(%ebp),%eax
  80232f:	01 c2                	add    %eax,%edx
  802331:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802334:	8b 45 0c             	mov    0xc(%ebp),%eax
  802337:	01 c8                	add    %ecx,%eax
  802339:	8a 00                	mov    (%eax),%al
  80233b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80233d:	ff 45 f8             	incl   -0x8(%ebp)
  802340:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802343:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802346:	7c d9                	jl     802321 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802348:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80234b:	8b 45 10             	mov    0x10(%ebp),%eax
  80234e:	01 d0                	add    %edx,%eax
  802350:	c6 00 00             	movb   $0x0,(%eax)
}
  802353:	90                   	nop
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802359:	8b 45 14             	mov    0x14(%ebp),%eax
  80235c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802362:	8b 45 14             	mov    0x14(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80236e:	8b 45 10             	mov    0x10(%ebp),%eax
  802371:	01 d0                	add    %edx,%eax
  802373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802379:	eb 0c                	jmp    802387 <strsplit+0x31>
			*string++ = 0;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	8d 50 01             	lea    0x1(%eax),%edx
  802381:	89 55 08             	mov    %edx,0x8(%ebp)
  802384:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	8a 00                	mov    (%eax),%al
  80238c:	84 c0                	test   %al,%al
  80238e:	74 18                	je     8023a8 <strsplit+0x52>
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	8a 00                	mov    (%eax),%al
  802395:	0f be c0             	movsbl %al,%eax
  802398:	50                   	push   %eax
  802399:	ff 75 0c             	pushl  0xc(%ebp)
  80239c:	e8 83 fa ff ff       	call   801e24 <strchr>
  8023a1:	83 c4 08             	add    $0x8,%esp
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	75 d3                	jne    80237b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8a 00                	mov    (%eax),%al
  8023ad:	84 c0                	test   %al,%al
  8023af:	74 5a                	je     80240b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	83 f8 0f             	cmp    $0xf,%eax
  8023b9:	75 07                	jne    8023c2 <strsplit+0x6c>
		{
			return 0;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	eb 66                	jmp    802428 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	8d 48 01             	lea    0x1(%eax),%ecx
  8023ca:	8b 55 14             	mov    0x14(%ebp),%edx
  8023cd:	89 0a                	mov    %ecx,(%edx)
  8023cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d9:	01 c2                	add    %eax,%edx
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023e0:	eb 03                	jmp    8023e5 <strsplit+0x8f>
			string++;
  8023e2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	84 c0                	test   %al,%al
  8023ec:	74 8b                	je     802379 <strsplit+0x23>
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	8a 00                	mov    (%eax),%al
  8023f3:	0f be c0             	movsbl %al,%eax
  8023f6:	50                   	push   %eax
  8023f7:	ff 75 0c             	pushl  0xc(%ebp)
  8023fa:	e8 25 fa ff ff       	call   801e24 <strchr>
  8023ff:	83 c4 08             	add    $0x8,%esp
  802402:	85 c0                	test   %eax,%eax
  802404:	74 dc                	je     8023e2 <strsplit+0x8c>
			string++;
	}
  802406:	e9 6e ff ff ff       	jmp    802379 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80240b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80240c:	8b 45 14             	mov    0x14(%ebp),%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802418:	8b 45 10             	mov    0x10(%ebp),%eax
  80241b:	01 d0                	add    %edx,%eax
  80241d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802423:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
  80242d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802436:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80243d:	eb 4a                	jmp    802489 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80243f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	01 c2                	add    %eax,%edx
  802447:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80244a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244d:	01 c8                	add    %ecx,%eax
  80244f:	8a 00                	mov    (%eax),%al
  802451:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802453:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802456:	8b 45 0c             	mov    0xc(%ebp),%eax
  802459:	01 d0                	add    %edx,%eax
  80245b:	8a 00                	mov    (%eax),%al
  80245d:	3c 40                	cmp    $0x40,%al
  80245f:	7e 25                	jle    802486 <str2lower+0x5c>
  802461:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802464:	8b 45 0c             	mov    0xc(%ebp),%eax
  802467:	01 d0                	add    %edx,%eax
  802469:	8a 00                	mov    (%eax),%al
  80246b:	3c 5a                	cmp    $0x5a,%al
  80246d:	7f 17                	jg     802486 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80246f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	01 d0                	add    %edx,%eax
  802477:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80247a:	8b 55 08             	mov    0x8(%ebp),%edx
  80247d:	01 ca                	add    %ecx,%edx
  80247f:	8a 12                	mov    (%edx),%dl
  802481:	83 c2 20             	add    $0x20,%edx
  802484:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802486:	ff 45 fc             	incl   -0x4(%ebp)
  802489:	ff 75 0c             	pushl  0xc(%ebp)
  80248c:	e8 01 f8 ff ff       	call   801c92 <strlen>
  802491:	83 c4 04             	add    $0x4,%esp
  802494:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802497:	7f a6                	jg     80243f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802499:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8024a4:	a1 08 50 80 00       	mov    0x805008,%eax
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	74 42                	je     8024ef <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8024ad:	83 ec 08             	sub    $0x8,%esp
  8024b0:	68 00 00 00 82       	push   $0x82000000
  8024b5:	68 00 00 00 80       	push   $0x80000000
  8024ba:	e8 00 08 00 00       	call   802cbf <initialize_dynamic_allocator>
  8024bf:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8024c2:	e8 e7 05 00 00       	call   802aae <sys_get_uheap_strategy>
  8024c7:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8024cc:	a1 20 52 80 00       	mov    0x805220,%eax
  8024d1:	05 00 10 00 00       	add    $0x1000,%eax
  8024d6:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8024db:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  8024e0:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  8024e5:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8024ec:	00 00 00 
	}
}
  8024ef:	90                   	nop
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
  8024f5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802506:	83 ec 08             	sub    $0x8,%esp
  802509:	68 06 04 00 00       	push   $0x406
  80250e:	50                   	push   %eax
  80250f:	e8 e4 01 00 00       	call   8026f8 <__sys_allocate_page>
  802514:	83 c4 10             	add    $0x10,%esp
  802517:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80251a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80251e:	79 14                	jns    802534 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	68 48 44 80 00       	push   $0x804448
  802528:	6a 1f                	push   $0x1f
  80252a:	68 84 44 80 00       	push   $0x804484
  80252f:	e8 b7 ed ff ff       	call   8012eb <_panic>
	return 0;
  802534:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80254f:	83 ec 0c             	sub    $0xc,%esp
  802552:	50                   	push   %eax
  802553:	e8 e7 01 00 00       	call   80273f <__sys_unmap_frame>
  802558:	83 c4 10             	add    $0x10,%esp
  80255b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80255e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802562:	79 14                	jns    802578 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802564:	83 ec 04             	sub    $0x4,%esp
  802567:	68 90 44 80 00       	push   $0x804490
  80256c:	6a 2a                	push   $0x2a
  80256e:	68 84 44 80 00       	push   $0x804484
  802573:	e8 73 ed ff ff       	call   8012eb <_panic>
}
  802578:	90                   	nop
  802579:	c9                   	leave  
  80257a:	c3                   	ret    

0080257b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802581:	e8 18 ff ff ff       	call   80249e <uheap_init>
	if (size == 0) return NULL ;
  802586:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80258a:	75 07                	jne    802593 <malloc+0x18>
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
  802591:	eb 14                	jmp    8025a7 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 d0 44 80 00       	push   $0x8044d0
  80259b:	6a 3e                	push   $0x3e
  80259d:	68 84 44 80 00       	push   $0x804484
  8025a2:	e8 44 ed ff ff       	call   8012eb <_panic>
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	68 f8 44 80 00       	push   $0x8044f8
  8025b7:	6a 49                	push   $0x49
  8025b9:	68 84 44 80 00       	push   $0x804484
  8025be:	e8 28 ed ff ff       	call   8012eb <_panic>

008025c3 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	83 ec 18             	sub    $0x18,%esp
  8025c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8025cc:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025cf:	e8 ca fe ff ff       	call   80249e <uheap_init>
	if (size == 0) return NULL ;
  8025d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025d8:	75 07                	jne    8025e1 <smalloc+0x1e>
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	eb 14                	jmp    8025f5 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8025e1:	83 ec 04             	sub    $0x4,%esp
  8025e4:	68 1c 45 80 00       	push   $0x80451c
  8025e9:	6a 5a                	push   $0x5a
  8025eb:	68 84 44 80 00       	push   $0x804484
  8025f0:	e8 f6 ec ff ff       	call   8012eb <_panic>
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025fd:	e8 9c fe ff ff       	call   80249e <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	68 44 45 80 00       	push   $0x804544
  80260a:	6a 6a                	push   $0x6a
  80260c:	68 84 44 80 00       	push   $0x804484
  802611:	e8 d5 ec ff ff       	call   8012eb <_panic>

00802616 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80261c:	e8 7d fe ff ff       	call   80249e <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802621:	83 ec 04             	sub    $0x4,%esp
  802624:	68 68 45 80 00       	push   $0x804568
  802629:	68 88 00 00 00       	push   $0x88
  80262e:	68 84 44 80 00       	push   $0x804484
  802633:	e8 b3 ec ff ff       	call   8012eb <_panic>

00802638 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80263e:	83 ec 04             	sub    $0x4,%esp
  802641:	68 90 45 80 00       	push   $0x804590
  802646:	68 9b 00 00 00       	push   $0x9b
  80264b:	68 84 44 80 00       	push   $0x804484
  802650:	e8 96 ec ff ff       	call   8012eb <_panic>

00802655 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	57                   	push   %edi
  802659:	56                   	push   %esi
  80265a:	53                   	push   %ebx
  80265b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80265e:	8b 45 08             	mov    0x8(%ebp),%eax
  802661:	8b 55 0c             	mov    0xc(%ebp),%edx
  802664:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802667:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80266a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80266d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802670:	cd 30                	int    $0x30
  802672:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802675:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802678:	83 c4 10             	add    $0x10,%esp
  80267b:	5b                   	pop    %ebx
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    

00802680 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 04             	sub    $0x4,%esp
  802686:	8b 45 10             	mov    0x10(%ebp),%eax
  802689:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80268c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80268f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	6a 00                	push   $0x0
  802698:	51                   	push   %ecx
  802699:	52                   	push   %edx
  80269a:	ff 75 0c             	pushl  0xc(%ebp)
  80269d:	50                   	push   %eax
  80269e:	6a 00                	push   $0x0
  8026a0:	e8 b0 ff ff ff       	call   802655 <syscall>
  8026a5:	83 c4 18             	add    $0x18,%esp
}
  8026a8:	90                   	nop
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 02                	push   $0x2
  8026ba:	e8 96 ff ff ff       	call   802655 <syscall>
  8026bf:	83 c4 18             	add    $0x18,%esp
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 03                	push   $0x3
  8026d3:	e8 7d ff ff ff       	call   802655 <syscall>
  8026d8:	83 c4 18             	add    $0x18,%esp
}
  8026db:	90                   	nop
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 04                	push   $0x4
  8026ed:	e8 63 ff ff ff       	call   802655 <syscall>
  8026f2:	83 c4 18             	add    $0x18,%esp
}
  8026f5:	90                   	nop
  8026f6:	c9                   	leave  
  8026f7:	c3                   	ret    

008026f8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	52                   	push   %edx
  802708:	50                   	push   %eax
  802709:	6a 08                	push   $0x8
  80270b:	e8 45 ff ff ff       	call   802655 <syscall>
  802710:	83 c4 18             	add    $0x18,%esp
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	56                   	push   %esi
  802719:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80271a:	8b 75 18             	mov    0x18(%ebp),%esi
  80271d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802720:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802723:	8b 55 0c             	mov    0xc(%ebp),%edx
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	56                   	push   %esi
  80272a:	53                   	push   %ebx
  80272b:	51                   	push   %ecx
  80272c:	52                   	push   %edx
  80272d:	50                   	push   %eax
  80272e:	6a 09                	push   $0x9
  802730:	e8 20 ff ff ff       	call   802655 <syscall>
  802735:	83 c4 18             	add    $0x18,%esp
}
  802738:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5d                   	pop    %ebp
  80273e:	c3                   	ret    

0080273f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	ff 75 08             	pushl  0x8(%ebp)
  80274d:	6a 0a                	push   $0xa
  80274f:	e8 01 ff ff ff       	call   802655 <syscall>
  802754:	83 c4 18             	add    $0x18,%esp
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	ff 75 0c             	pushl  0xc(%ebp)
  802765:	ff 75 08             	pushl  0x8(%ebp)
  802768:	6a 0b                	push   $0xb
  80276a:	e8 e6 fe ff ff       	call   802655 <syscall>
  80276f:	83 c4 18             	add    $0x18,%esp
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 0c                	push   $0xc
  802783:	e8 cd fe ff ff       	call   802655 <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
}
  80278b:	c9                   	leave  
  80278c:	c3                   	ret    

0080278d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 0d                	push   $0xd
  80279c:	e8 b4 fe ff ff       	call   802655 <syscall>
  8027a1:	83 c4 18             	add    $0x18,%esp
}
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 0e                	push   $0xe
  8027b5:	e8 9b fe ff ff       	call   802655 <syscall>
  8027ba:	83 c4 18             	add    $0x18,%esp
}
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 0f                	push   $0xf
  8027ce:	e8 82 fe ff ff       	call   802655 <syscall>
  8027d3:	83 c4 18             	add    $0x18,%esp
}
  8027d6:	c9                   	leave  
  8027d7:	c3                   	ret    

008027d8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	ff 75 08             	pushl  0x8(%ebp)
  8027e6:	6a 10                	push   $0x10
  8027e8:	e8 68 fe ff ff       	call   802655 <syscall>
  8027ed:	83 c4 18             	add    $0x18,%esp
}
  8027f0:	c9                   	leave  
  8027f1:	c3                   	ret    

008027f2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027f2:	55                   	push   %ebp
  8027f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 11                	push   $0x11
  802801:	e8 4f fe ff ff       	call   802655 <syscall>
  802806:	83 c4 18             	add    $0x18,%esp
}
  802809:	90                   	nop
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <sys_cputc>:

void
sys_cputc(const char c)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802818:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	50                   	push   %eax
  802825:	6a 01                	push   $0x1
  802827:	e8 29 fe ff ff       	call   802655 <syscall>
  80282c:	83 c4 18             	add    $0x18,%esp
}
  80282f:	90                   	nop
  802830:	c9                   	leave  
  802831:	c3                   	ret    

00802832 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802832:	55                   	push   %ebp
  802833:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 00                	push   $0x0
  80283f:	6a 14                	push   $0x14
  802841:	e8 0f fe ff ff       	call   802655 <syscall>
  802846:	83 c4 18             	add    $0x18,%esp
}
  802849:	90                   	nop
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	8b 45 10             	mov    0x10(%ebp),%eax
  802855:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802858:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80285b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	6a 00                	push   $0x0
  802864:	51                   	push   %ecx
  802865:	52                   	push   %edx
  802866:	ff 75 0c             	pushl  0xc(%ebp)
  802869:	50                   	push   %eax
  80286a:	6a 15                	push   $0x15
  80286c:	e8 e4 fd ff ff       	call   802655 <syscall>
  802871:	83 c4 18             	add    $0x18,%esp
}
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	52                   	push   %edx
  802886:	50                   	push   %eax
  802887:	6a 16                	push   $0x16
  802889:	e8 c7 fd ff ff       	call   802655 <syscall>
  80288e:	83 c4 18             	add    $0x18,%esp
}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802896:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	51                   	push   %ecx
  8028a4:	52                   	push   %edx
  8028a5:	50                   	push   %eax
  8028a6:	6a 17                	push   $0x17
  8028a8:	e8 a8 fd ff ff       	call   802655 <syscall>
  8028ad:	83 c4 18             	add    $0x18,%esp
}
  8028b0:	c9                   	leave  
  8028b1:	c3                   	ret    

008028b2 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8028b2:	55                   	push   %ebp
  8028b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	6a 00                	push   $0x0
  8028c1:	52                   	push   %edx
  8028c2:	50                   	push   %eax
  8028c3:	6a 18                	push   $0x18
  8028c5:	e8 8b fd ff ff       	call   802655 <syscall>
  8028ca:	83 c4 18             	add    $0x18,%esp
}
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    

008028cf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028cf:	55                   	push   %ebp
  8028d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	6a 00                	push   $0x0
  8028d7:	ff 75 14             	pushl  0x14(%ebp)
  8028da:	ff 75 10             	pushl  0x10(%ebp)
  8028dd:	ff 75 0c             	pushl  0xc(%ebp)
  8028e0:	50                   	push   %eax
  8028e1:	6a 19                	push   $0x19
  8028e3:	e8 6d fd ff ff       	call   802655 <syscall>
  8028e8:	83 c4 18             	add    $0x18,%esp
}
  8028eb:	c9                   	leave  
  8028ec:	c3                   	ret    

008028ed <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028ed:	55                   	push   %ebp
  8028ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	50                   	push   %eax
  8028fc:	6a 1a                	push   $0x1a
  8028fe:	e8 52 fd ff ff       	call   802655 <syscall>
  802903:	83 c4 18             	add    $0x18,%esp
}
  802906:	90                   	nop
  802907:	c9                   	leave  
  802908:	c3                   	ret    

00802909 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	50                   	push   %eax
  802918:	6a 1b                	push   $0x1b
  80291a:	e8 36 fd ff ff       	call   802655 <syscall>
  80291f:	83 c4 18             	add    $0x18,%esp
}
  802922:	c9                   	leave  
  802923:	c3                   	ret    

00802924 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 05                	push   $0x5
  802933:	e8 1d fd ff ff       	call   802655 <syscall>
  802938:	83 c4 18             	add    $0x18,%esp
}
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	6a 06                	push   $0x6
  80294c:	e8 04 fd ff ff       	call   802655 <syscall>
  802951:	83 c4 18             	add    $0x18,%esp
}
  802954:	c9                   	leave  
  802955:	c3                   	ret    

00802956 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 07                	push   $0x7
  802965:	e8 eb fc ff ff       	call   802655 <syscall>
  80296a:	83 c4 18             	add    $0x18,%esp
}
  80296d:	c9                   	leave  
  80296e:	c3                   	ret    

0080296f <sys_exit_env>:


void sys_exit_env(void)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 1c                	push   $0x1c
  80297e:	e8 d2 fc ff ff       	call   802655 <syscall>
  802983:	83 c4 18             	add    $0x18,%esp
}
  802986:	90                   	nop
  802987:	c9                   	leave  
  802988:	c3                   	ret    

00802989 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
  80298c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80298f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802992:	8d 50 04             	lea    0x4(%eax),%edx
  802995:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802998:	6a 00                	push   $0x0
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	52                   	push   %edx
  80299f:	50                   	push   %eax
  8029a0:	6a 1d                	push   $0x1d
  8029a2:	e8 ae fc ff ff       	call   802655 <syscall>
  8029a7:	83 c4 18             	add    $0x18,%esp
	return result;
  8029aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029b3:	89 01                	mov    %eax,(%ecx)
  8029b5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	c9                   	leave  
  8029bc:	c2 04 00             	ret    $0x4

008029bf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029bf:	55                   	push   %ebp
  8029c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	ff 75 10             	pushl  0x10(%ebp)
  8029c9:	ff 75 0c             	pushl  0xc(%ebp)
  8029cc:	ff 75 08             	pushl  0x8(%ebp)
  8029cf:	6a 13                	push   $0x13
  8029d1:	e8 7f fc ff ff       	call   802655 <syscall>
  8029d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d9:	90                   	nop
}
  8029da:	c9                   	leave  
  8029db:	c3                   	ret    

008029dc <sys_rcr2>:
uint32 sys_rcr2()
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 1e                	push   $0x1e
  8029eb:	e8 65 fc ff ff       	call   802655 <syscall>
  8029f0:	83 c4 18             	add    $0x18,%esp
}
  8029f3:	c9                   	leave  
  8029f4:	c3                   	ret    

008029f5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8029f5:	55                   	push   %ebp
  8029f6:	89 e5                	mov    %esp,%ebp
  8029f8:	83 ec 04             	sub    $0x4,%esp
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a01:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	6a 00                	push   $0x0
  802a0b:	6a 00                	push   $0x0
  802a0d:	50                   	push   %eax
  802a0e:	6a 1f                	push   $0x1f
  802a10:	e8 40 fc ff ff       	call   802655 <syscall>
  802a15:	83 c4 18             	add    $0x18,%esp
	return ;
  802a18:	90                   	nop
}
  802a19:	c9                   	leave  
  802a1a:	c3                   	ret    

00802a1b <rsttst>:
void rsttst()
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 00                	push   $0x0
  802a26:	6a 00                	push   $0x0
  802a28:	6a 21                	push   $0x21
  802a2a:	e8 26 fc ff ff       	call   802655 <syscall>
  802a2f:	83 c4 18             	add    $0x18,%esp
	return ;
  802a32:	90                   	nop
}
  802a33:	c9                   	leave  
  802a34:	c3                   	ret    

00802a35 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
  802a38:	83 ec 04             	sub    $0x4,%esp
  802a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  802a3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a41:	8b 55 18             	mov    0x18(%ebp),%edx
  802a44:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a48:	52                   	push   %edx
  802a49:	50                   	push   %eax
  802a4a:	ff 75 10             	pushl  0x10(%ebp)
  802a4d:	ff 75 0c             	pushl  0xc(%ebp)
  802a50:	ff 75 08             	pushl  0x8(%ebp)
  802a53:	6a 20                	push   $0x20
  802a55:	e8 fb fb ff ff       	call   802655 <syscall>
  802a5a:	83 c4 18             	add    $0x18,%esp
	return ;
  802a5d:	90                   	nop
}
  802a5e:	c9                   	leave  
  802a5f:	c3                   	ret    

00802a60 <chktst>:
void chktst(uint32 n)
{
  802a60:	55                   	push   %ebp
  802a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	6a 00                	push   $0x0
  802a6b:	ff 75 08             	pushl  0x8(%ebp)
  802a6e:	6a 22                	push   $0x22
  802a70:	e8 e0 fb ff ff       	call   802655 <syscall>
  802a75:	83 c4 18             	add    $0x18,%esp
	return ;
  802a78:	90                   	nop
}
  802a79:	c9                   	leave  
  802a7a:	c3                   	ret    

00802a7b <inctst>:

void inctst()
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 00                	push   $0x0
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	6a 23                	push   $0x23
  802a8a:	e8 c6 fb ff ff       	call   802655 <syscall>
  802a8f:	83 c4 18             	add    $0x18,%esp
	return ;
  802a92:	90                   	nop
}
  802a93:	c9                   	leave  
  802a94:	c3                   	ret    

00802a95 <gettst>:
uint32 gettst()
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	6a 00                	push   $0x0
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 24                	push   $0x24
  802aa4:	e8 ac fb ff ff       	call   802655 <syscall>
  802aa9:	83 c4 18             	add    $0x18,%esp
}
  802aac:	c9                   	leave  
  802aad:	c3                   	ret    

00802aae <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ab1:	6a 00                	push   $0x0
  802ab3:	6a 00                	push   $0x0
  802ab5:	6a 00                	push   $0x0
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 25                	push   $0x25
  802abd:	e8 93 fb ff ff       	call   802655 <syscall>
  802ac2:	83 c4 18             	add    $0x18,%esp
  802ac5:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802aca:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802acf:	c9                   	leave  
  802ad0:	c3                   	ret    

00802ad1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ad1:	55                   	push   %ebp
  802ad2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802adc:	6a 00                	push   $0x0
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	ff 75 08             	pushl  0x8(%ebp)
  802ae7:	6a 26                	push   $0x26
  802ae9:	e8 67 fb ff ff       	call   802655 <syscall>
  802aee:	83 c4 18             	add    $0x18,%esp
	return ;
  802af1:	90                   	nop
}
  802af2:	c9                   	leave  
  802af3:	c3                   	ret    

00802af4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
  802af7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802af8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	6a 00                	push   $0x0
  802b06:	53                   	push   %ebx
  802b07:	51                   	push   %ecx
  802b08:	52                   	push   %edx
  802b09:	50                   	push   %eax
  802b0a:	6a 27                	push   $0x27
  802b0c:	e8 44 fb ff ff       	call   802655 <syscall>
  802b11:	83 c4 18             	add    $0x18,%esp
}
  802b14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b17:	c9                   	leave  
  802b18:	c3                   	ret    

00802b19 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b19:	55                   	push   %ebp
  802b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	52                   	push   %edx
  802b29:	50                   	push   %eax
  802b2a:	6a 28                	push   $0x28
  802b2c:	e8 24 fb ff ff       	call   802655 <syscall>
  802b31:	83 c4 18             	add    $0x18,%esp
}
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b39:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	6a 00                	push   $0x0
  802b44:	51                   	push   %ecx
  802b45:	ff 75 10             	pushl  0x10(%ebp)
  802b48:	52                   	push   %edx
  802b49:	50                   	push   %eax
  802b4a:	6a 29                	push   $0x29
  802b4c:	e8 04 fb ff ff       	call   802655 <syscall>
  802b51:	83 c4 18             	add    $0x18,%esp
}
  802b54:	c9                   	leave  
  802b55:	c3                   	ret    

00802b56 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	ff 75 10             	pushl  0x10(%ebp)
  802b60:	ff 75 0c             	pushl  0xc(%ebp)
  802b63:	ff 75 08             	pushl  0x8(%ebp)
  802b66:	6a 12                	push   $0x12
  802b68:	e8 e8 fa ff ff       	call   802655 <syscall>
  802b6d:	83 c4 18             	add    $0x18,%esp
	return ;
  802b70:	90                   	nop
}
  802b71:	c9                   	leave  
  802b72:	c3                   	ret    

00802b73 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b73:	55                   	push   %ebp
  802b74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	6a 00                	push   $0x0
  802b7e:	6a 00                	push   $0x0
  802b80:	6a 00                	push   $0x0
  802b82:	52                   	push   %edx
  802b83:	50                   	push   %eax
  802b84:	6a 2a                	push   $0x2a
  802b86:	e8 ca fa ff ff       	call   802655 <syscall>
  802b8b:	83 c4 18             	add    $0x18,%esp
	return;
  802b8e:	90                   	nop
}
  802b8f:	c9                   	leave  
  802b90:	c3                   	ret    

00802b91 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802b91:	55                   	push   %ebp
  802b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	6a 00                	push   $0x0
  802b9c:	6a 00                	push   $0x0
  802b9e:	6a 2b                	push   $0x2b
  802ba0:	e8 b0 fa ff ff       	call   802655 <syscall>
  802ba5:	83 c4 18             	add    $0x18,%esp
}
  802ba8:	c9                   	leave  
  802ba9:	c3                   	ret    

00802baa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802baa:	55                   	push   %ebp
  802bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802bad:	6a 00                	push   $0x0
  802baf:	6a 00                	push   $0x0
  802bb1:	6a 00                	push   $0x0
  802bb3:	ff 75 0c             	pushl  0xc(%ebp)
  802bb6:	ff 75 08             	pushl  0x8(%ebp)
  802bb9:	6a 2d                	push   $0x2d
  802bbb:	e8 95 fa ff ff       	call   802655 <syscall>
  802bc0:	83 c4 18             	add    $0x18,%esp
	return;
  802bc3:	90                   	nop
}
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802bc9:	6a 00                	push   $0x0
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	ff 75 0c             	pushl  0xc(%ebp)
  802bd2:	ff 75 08             	pushl  0x8(%ebp)
  802bd5:	6a 2c                	push   $0x2c
  802bd7:	e8 79 fa ff ff       	call   802655 <syscall>
  802bdc:	83 c4 18             	add    $0x18,%esp
	return ;
  802bdf:	90                   	nop
}
  802be0:	c9                   	leave  
  802be1:	c3                   	ret    

00802be2 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802be2:	55                   	push   %ebp
  802be3:	89 e5                	mov    %esp,%ebp
  802be5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	68 b4 45 80 00       	push   $0x8045b4
  802bf0:	68 25 01 00 00       	push   $0x125
  802bf5:	68 e7 45 80 00       	push   $0x8045e7
  802bfa:	e8 ec e6 ff ff       	call   8012eb <_panic>

00802bff <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802bff:	55                   	push   %ebp
  802c00:	89 e5                	mov    %esp,%ebp
  802c02:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802c05:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802c0c:	72 09                	jb     802c17 <to_page_va+0x18>
  802c0e:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802c15:	72 14                	jb     802c2b <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802c17:	83 ec 04             	sub    $0x4,%esp
  802c1a:	68 f8 45 80 00       	push   $0x8045f8
  802c1f:	6a 15                	push   $0x15
  802c21:	68 23 46 80 00       	push   $0x804623
  802c26:	e8 c0 e6 ff ff       	call   8012eb <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	ba 40 52 80 00       	mov    $0x805240,%edx
  802c33:	29 d0                	sub    %edx,%eax
  802c35:	c1 f8 02             	sar    $0x2,%eax
  802c38:	89 c2                	mov    %eax,%edx
  802c3a:	89 d0                	mov    %edx,%eax
  802c3c:	c1 e0 02             	shl    $0x2,%eax
  802c3f:	01 d0                	add    %edx,%eax
  802c41:	c1 e0 02             	shl    $0x2,%eax
  802c44:	01 d0                	add    %edx,%eax
  802c46:	c1 e0 02             	shl    $0x2,%eax
  802c49:	01 d0                	add    %edx,%eax
  802c4b:	89 c1                	mov    %eax,%ecx
  802c4d:	c1 e1 08             	shl    $0x8,%ecx
  802c50:	01 c8                	add    %ecx,%eax
  802c52:	89 c1                	mov    %eax,%ecx
  802c54:	c1 e1 10             	shl    $0x10,%ecx
  802c57:	01 c8                	add    %ecx,%eax
  802c59:	01 c0                	add    %eax,%eax
  802c5b:	01 d0                	add    %edx,%eax
  802c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	c1 e0 0c             	shl    $0xc,%eax
  802c66:	89 c2                	mov    %eax,%edx
  802c68:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802c6d:	01 d0                	add    %edx,%eax
}
  802c6f:	c9                   	leave  
  802c70:	c3                   	ret    

00802c71 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802c71:	55                   	push   %ebp
  802c72:	89 e5                	mov    %esp,%ebp
  802c74:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802c77:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7f:	29 c2                	sub    %eax,%edx
  802c81:	89 d0                	mov    %edx,%eax
  802c83:	c1 e8 0c             	shr    $0xc,%eax
  802c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802c89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8d:	78 09                	js     802c98 <to_page_info+0x27>
  802c8f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802c96:	7e 14                	jle    802cac <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802c98:	83 ec 04             	sub    $0x4,%esp
  802c9b:	68 3c 46 80 00       	push   $0x80463c
  802ca0:	6a 22                	push   $0x22
  802ca2:	68 23 46 80 00       	push   $0x804623
  802ca7:	e8 3f e6 ff ff       	call   8012eb <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802caf:	89 d0                	mov    %edx,%eax
  802cb1:	01 c0                	add    %eax,%eax
  802cb3:	01 d0                	add    %edx,%eax
  802cb5:	c1 e0 02             	shl    $0x2,%eax
  802cb8:	05 40 52 80 00       	add    $0x805240,%eax
}
  802cbd:	c9                   	leave  
  802cbe:	c3                   	ret    

00802cbf <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802cbf:	55                   	push   %ebp
  802cc0:	89 e5                	mov    %esp,%ebp
  802cc2:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	05 00 00 00 02       	add    $0x2000000,%eax
  802ccd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cd0:	73 16                	jae    802ce8 <initialize_dynamic_allocator+0x29>
  802cd2:	68 60 46 80 00       	push   $0x804660
  802cd7:	68 86 46 80 00       	push   $0x804686
  802cdc:	6a 34                	push   $0x34
  802cde:	68 23 46 80 00       	push   $0x804623
  802ce3:	e8 03 e6 ff ff       	call   8012eb <_panic>
		is_initialized = 1;
  802ce8:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802cef:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfd:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802d02:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802d09:	00 00 00 
  802d0c:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802d13:	00 00 00 
  802d16:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  802d1d:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d23:	2b 45 08             	sub    0x8(%ebp),%eax
  802d26:	c1 e8 0c             	shr    $0xc,%eax
  802d29:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802d2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d33:	e9 c8 00 00 00       	jmp    802e00 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3b:	89 d0                	mov    %edx,%eax
  802d3d:	01 c0                	add    %eax,%eax
  802d3f:	01 d0                	add    %edx,%eax
  802d41:	c1 e0 02             	shl    $0x2,%eax
  802d44:	05 48 52 80 00       	add    $0x805248,%eax
  802d49:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d51:	89 d0                	mov    %edx,%eax
  802d53:	01 c0                	add    %eax,%eax
  802d55:	01 d0                	add    %edx,%eax
  802d57:	c1 e0 02             	shl    $0x2,%eax
  802d5a:	05 4a 52 80 00       	add    $0x80524a,%eax
  802d5f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802d64:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802d6a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d6d:	89 c8                	mov    %ecx,%eax
  802d6f:	01 c0                	add    %eax,%eax
  802d71:	01 c8                	add    %ecx,%eax
  802d73:	c1 e0 02             	shl    $0x2,%eax
  802d76:	05 44 52 80 00       	add    $0x805244,%eax
  802d7b:	89 10                	mov    %edx,(%eax)
  802d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d80:	89 d0                	mov    %edx,%eax
  802d82:	01 c0                	add    %eax,%eax
  802d84:	01 d0                	add    %edx,%eax
  802d86:	c1 e0 02             	shl    $0x2,%eax
  802d89:	05 44 52 80 00       	add    $0x805244,%eax
  802d8e:	8b 00                	mov    (%eax),%eax
  802d90:	85 c0                	test   %eax,%eax
  802d92:	74 1b                	je     802daf <initialize_dynamic_allocator+0xf0>
  802d94:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802d9a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d9d:	89 c8                	mov    %ecx,%eax
  802d9f:	01 c0                	add    %eax,%eax
  802da1:	01 c8                	add    %ecx,%eax
  802da3:	c1 e0 02             	shl    $0x2,%eax
  802da6:	05 40 52 80 00       	add    $0x805240,%eax
  802dab:	89 02                	mov    %eax,(%edx)
  802dad:	eb 16                	jmp    802dc5 <initialize_dynamic_allocator+0x106>
  802daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db2:	89 d0                	mov    %edx,%eax
  802db4:	01 c0                	add    %eax,%eax
  802db6:	01 d0                	add    %edx,%eax
  802db8:	c1 e0 02             	shl    $0x2,%eax
  802dbb:	05 40 52 80 00       	add    $0x805240,%eax
  802dc0:	a3 28 52 80 00       	mov    %eax,0x805228
  802dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc8:	89 d0                	mov    %edx,%eax
  802dca:	01 c0                	add    %eax,%eax
  802dcc:	01 d0                	add    %edx,%eax
  802dce:	c1 e0 02             	shl    $0x2,%eax
  802dd1:	05 40 52 80 00       	add    $0x805240,%eax
  802dd6:	a3 2c 52 80 00       	mov    %eax,0x80522c
  802ddb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dde:	89 d0                	mov    %edx,%eax
  802de0:	01 c0                	add    %eax,%eax
  802de2:	01 d0                	add    %edx,%eax
  802de4:	c1 e0 02             	shl    $0x2,%eax
  802de7:	05 40 52 80 00       	add    $0x805240,%eax
  802dec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df2:	a1 34 52 80 00       	mov    0x805234,%eax
  802df7:	40                   	inc    %eax
  802df8:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802dfd:	ff 45 f4             	incl   -0xc(%ebp)
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e06:	0f 8c 2c ff ff ff    	jl     802d38 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802e0c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802e13:	eb 36                	jmp    802e4b <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e18:	c1 e0 04             	shl    $0x4,%eax
  802e1b:	05 60 d2 81 00       	add    $0x81d260,%eax
  802e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	c1 e0 04             	shl    $0x4,%eax
  802e2c:	05 64 d2 81 00       	add    $0x81d264,%eax
  802e31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3a:	c1 e0 04             	shl    $0x4,%eax
  802e3d:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802e42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802e48:	ff 45 f0             	incl   -0x10(%ebp)
  802e4b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802e4f:	7e c4                	jle    802e15 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802e51:	90                   	nop
  802e52:	c9                   	leave  
  802e53:	c3                   	ret    

00802e54 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
  802e57:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	83 ec 0c             	sub    $0xc,%esp
  802e60:	50                   	push   %eax
  802e61:	e8 0b fe ff ff       	call   802c71 <to_page_info>
  802e66:	83 c4 10             	add    $0x10,%esp
  802e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 40 08             	mov    0x8(%eax),%eax
  802e72:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802e75:	c9                   	leave  
  802e76:	c3                   	ret    

00802e77 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802e77:	55                   	push   %ebp
  802e78:	89 e5                	mov    %esp,%ebp
  802e7a:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802e7d:	83 ec 0c             	sub    $0xc,%esp
  802e80:	ff 75 0c             	pushl  0xc(%ebp)
  802e83:	e8 77 fd ff ff       	call   802bff <to_page_va>
  802e88:	83 c4 10             	add    $0x10,%esp
  802e8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802e8e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e93:	ba 00 00 00 00       	mov    $0x0,%edx
  802e98:	f7 75 08             	divl   0x8(%ebp)
  802e9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea1:	83 ec 0c             	sub    $0xc,%esp
  802ea4:	50                   	push   %eax
  802ea5:	e8 48 f6 ff ff       	call   8024f2 <get_page>
  802eaa:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb3:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebd:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802ec1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802ec8:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802ecf:	eb 19                	jmp    802eea <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed4:	ba 01 00 00 00       	mov    $0x1,%edx
  802ed9:	88 c1                	mov    %al,%cl
  802edb:	d3 e2                	shl    %cl,%edx
  802edd:	89 d0                	mov    %edx,%eax
  802edf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee2:	74 0e                	je     802ef2 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802ee4:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802ee7:	ff 45 f0             	incl   -0x10(%ebp)
  802eea:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802eee:	7e e1                	jle    802ed1 <split_page_to_blocks+0x5a>
  802ef0:	eb 01                	jmp    802ef3 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802ef2:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802ef3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802efa:	e9 a7 00 00 00       	jmp    802fa6 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f02:	0f af 45 08          	imul   0x8(%ebp),%eax
  802f06:	89 c2                	mov    %eax,%edx
  802f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0b:	01 d0                	add    %edx,%eax
  802f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802f10:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f14:	75 14                	jne    802f2a <split_page_to_blocks+0xb3>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 9c 46 80 00       	push   $0x80469c
  802f1e:	6a 7c                	push   $0x7c
  802f20:	68 23 46 80 00       	push   $0x804623
  802f25:	e8 c1 e3 ff ff       	call   8012eb <_panic>
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	c1 e0 04             	shl    $0x4,%eax
  802f30:	05 64 d2 81 00       	add    $0x81d264,%eax
  802f35:	8b 10                	mov    (%eax),%edx
  802f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3a:	89 50 04             	mov    %edx,0x4(%eax)
  802f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 14                	je     802f5b <split_page_to_blocks+0xe4>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	c1 e0 04             	shl    $0x4,%eax
  802f4d:	05 64 d2 81 00       	add    $0x81d264,%eax
  802f52:	8b 00                	mov    (%eax),%eax
  802f54:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	eb 11                	jmp    802f6c <split_page_to_blocks+0xf5>
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	c1 e0 04             	shl    $0x4,%eax
  802f61:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  802f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6a:	89 02                	mov    %eax,(%edx)
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	c1 e0 04             	shl    $0x4,%eax
  802f72:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  802f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7b:	89 02                	mov    %eax,(%edx)
  802f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	c1 e0 04             	shl    $0x4,%eax
  802f8c:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	8d 50 01             	lea    0x1(%eax),%edx
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	c1 e0 04             	shl    $0x4,%eax
  802f9c:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802fa1:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802fa3:	ff 45 ec             	incl   -0x14(%ebp)
  802fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802fac:	0f 82 4d ff ff ff    	jb     802eff <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802fb2:	90                   	nop
  802fb3:	c9                   	leave  
  802fb4:	c3                   	ret    

00802fb5 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802fb5:	55                   	push   %ebp
  802fb6:	89 e5                	mov    %esp,%ebp
  802fb8:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802fbb:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802fc2:	76 19                	jbe    802fdd <alloc_block+0x28>
  802fc4:	68 c0 46 80 00       	push   $0x8046c0
  802fc9:	68 86 46 80 00       	push   $0x804686
  802fce:	68 8a 00 00 00       	push   $0x8a
  802fd3:	68 23 46 80 00       	push   $0x804623
  802fd8:	e8 0e e3 ff ff       	call   8012eb <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802fdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802fe4:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802feb:	eb 19                	jmp    803006 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff0:	ba 01 00 00 00       	mov    $0x1,%edx
  802ff5:	88 c1                	mov    %al,%cl
  802ff7:	d3 e2                	shl    %cl,%edx
  802ff9:	89 d0                	mov    %edx,%eax
  802ffb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ffe:	73 0e                	jae    80300e <alloc_block+0x59>
		idx++;
  803000:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  803003:	ff 45 f0             	incl   -0x10(%ebp)
  803006:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80300a:	7e e1                	jle    802fed <alloc_block+0x38>
  80300c:	eb 01                	jmp    80300f <alloc_block+0x5a>
		if((1 << i) >= size) break;
  80300e:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	c1 e0 04             	shl    $0x4,%eax
  803015:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	0f 84 df 00 00 00    	je     803103 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	c1 e0 04             	shl    $0x4,%eax
  80302a:	05 60 d2 81 00       	add    $0x81d260,%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  803034:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803038:	75 17                	jne    803051 <alloc_block+0x9c>
  80303a:	83 ec 04             	sub    $0x4,%esp
  80303d:	68 e1 46 80 00       	push   $0x8046e1
  803042:	68 9e 00 00 00       	push   $0x9e
  803047:	68 23 46 80 00       	push   $0x804623
  80304c:	e8 9a e2 ff ff       	call   8012eb <_panic>
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	74 10                	je     80306a <alloc_block+0xb5>
  80305a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803062:	8b 52 04             	mov    0x4(%edx),%edx
  803065:	89 50 04             	mov    %edx,0x4(%eax)
  803068:	eb 14                	jmp    80307e <alloc_block+0xc9>
  80306a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803073:	c1 e2 04             	shl    $0x4,%edx
  803076:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80307c:	89 02                	mov    %eax,(%edx)
  80307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	85 c0                	test   %eax,%eax
  803086:	74 0f                	je     803097 <alloc_block+0xe2>
  803088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803091:	8b 12                	mov    (%edx),%edx
  803093:	89 10                	mov    %edx,(%eax)
  803095:	eb 13                	jmp    8030aa <alloc_block+0xf5>
  803097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309f:	c1 e2 04             	shl    $0x4,%edx
  8030a2:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8030a8:	89 02                	mov    %eax,(%edx)
  8030aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	c1 e0 04             	shl    $0x4,%eax
  8030c3:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	c1 e0 04             	shl    $0x4,%eax
  8030d3:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030d8:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8030da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030dd:	83 ec 0c             	sub    $0xc,%esp
  8030e0:	50                   	push   %eax
  8030e1:	e8 8b fb ff ff       	call   802c71 <to_page_info>
  8030e6:	83 c4 10             	add    $0x10,%esp
  8030e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8030ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ef:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8030f3:	48                   	dec    %eax
  8030f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f7:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8030fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fe:	e9 bc 02 00 00       	jmp    8033bf <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  803103:	a1 34 52 80 00       	mov    0x805234,%eax
  803108:	85 c0                	test   %eax,%eax
  80310a:	0f 84 7d 02 00 00    	je     80338d <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  803110:	a1 28 52 80 00       	mov    0x805228,%eax
  803115:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  803118:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80311c:	75 17                	jne    803135 <alloc_block+0x180>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 e1 46 80 00       	push   $0x8046e1
  803126:	68 a9 00 00 00       	push   $0xa9
  80312b:	68 23 46 80 00       	push   $0x804623
  803130:	e8 b6 e1 ff ff       	call   8012eb <_panic>
  803135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 10                	je     80314e <alloc_block+0x199>
  80313e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803146:	8b 52 04             	mov    0x4(%edx),%edx
  803149:	89 50 04             	mov    %edx,0x4(%eax)
  80314c:	eb 0b                	jmp    803159 <alloc_block+0x1a4>
  80314e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803151:	8b 40 04             	mov    0x4(%eax),%eax
  803154:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	74 0f                	je     803172 <alloc_block+0x1bd>
  803163:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803166:	8b 40 04             	mov    0x4(%eax),%eax
  803169:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80316c:	8b 12                	mov    (%edx),%edx
  80316e:	89 10                	mov    %edx,(%eax)
  803170:	eb 0a                	jmp    80317c <alloc_block+0x1c7>
  803172:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	a3 28 52 80 00       	mov    %eax,0x805228
  80317c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803188:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318f:	a1 34 52 80 00       	mov    0x805234,%eax
  803194:	48                   	dec    %eax
  803195:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	83 c0 03             	add    $0x3,%eax
  8031a0:	ba 01 00 00 00       	mov    $0x1,%edx
  8031a5:	88 c1                	mov    %al,%cl
  8031a7:	d3 e2                	shl    %cl,%edx
  8031a9:	89 d0                	mov    %edx,%eax
  8031ab:	83 ec 08             	sub    $0x8,%esp
  8031ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031b1:	50                   	push   %eax
  8031b2:	e8 c0 fc ff ff       	call   802e77 <split_page_to_blocks>
  8031b7:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	c1 e0 04             	shl    $0x4,%eax
  8031c0:	05 60 d2 81 00       	add    $0x81d260,%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8031ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031ce:	75 17                	jne    8031e7 <alloc_block+0x232>
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	68 e1 46 80 00       	push   $0x8046e1
  8031d8:	68 b0 00 00 00       	push   $0xb0
  8031dd:	68 23 46 80 00       	push   $0x804623
  8031e2:	e8 04 e1 ff ff       	call   8012eb <_panic>
  8031e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ea:	8b 00                	mov    (%eax),%eax
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	74 10                	je     803200 <alloc_block+0x24b>
  8031f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f3:	8b 00                	mov    (%eax),%eax
  8031f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031f8:	8b 52 04             	mov    0x4(%edx),%edx
  8031fb:	89 50 04             	mov    %edx,0x4(%eax)
  8031fe:	eb 14                	jmp    803214 <alloc_block+0x25f>
  803200:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803203:	8b 40 04             	mov    0x4(%eax),%eax
  803206:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803209:	c1 e2 04             	shl    $0x4,%edx
  80320c:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803212:	89 02                	mov    %eax,(%edx)
  803214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803217:	8b 40 04             	mov    0x4(%eax),%eax
  80321a:	85 c0                	test   %eax,%eax
  80321c:	74 0f                	je     80322d <alloc_block+0x278>
  80321e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803221:	8b 40 04             	mov    0x4(%eax),%eax
  803224:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803227:	8b 12                	mov    (%edx),%edx
  803229:	89 10                	mov    %edx,(%eax)
  80322b:	eb 13                	jmp    803240 <alloc_block+0x28b>
  80322d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803235:	c1 e2 04             	shl    $0x4,%edx
  803238:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80323e:	89 02                	mov    %eax,(%edx)
  803240:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803243:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803249:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	c1 e0 04             	shl    $0x4,%eax
  803259:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	8d 50 ff             	lea    -0x1(%eax),%edx
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	c1 e0 04             	shl    $0x4,%eax
  803269:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80326e:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803270:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803273:	83 ec 0c             	sub    $0xc,%esp
  803276:	50                   	push   %eax
  803277:	e8 f5 f9 ff ff       	call   802c71 <to_page_info>
  80327c:	83 c4 10             	add    $0x10,%esp
  80327f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  803282:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803285:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803289:	48                   	dec    %eax
  80328a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80328d:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803291:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803294:	e9 26 01 00 00       	jmp    8033bf <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  803299:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	c1 e0 04             	shl    $0x4,%eax
  8032a2:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	0f 84 dc 00 00 00    	je     80338d <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	c1 e0 04             	shl    $0x4,%eax
  8032b7:	05 60 d2 81 00       	add    $0x81d260,%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8032c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032c5:	75 17                	jne    8032de <alloc_block+0x329>
  8032c7:	83 ec 04             	sub    $0x4,%esp
  8032ca:	68 e1 46 80 00       	push   $0x8046e1
  8032cf:	68 be 00 00 00       	push   $0xbe
  8032d4:	68 23 46 80 00       	push   $0x804623
  8032d9:	e8 0d e0 ff ff       	call   8012eb <_panic>
  8032de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	74 10                	je     8032f7 <alloc_block+0x342>
  8032e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ea:	8b 00                	mov    (%eax),%eax
  8032ec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032ef:	8b 52 04             	mov    0x4(%edx),%edx
  8032f2:	89 50 04             	mov    %edx,0x4(%eax)
  8032f5:	eb 14                	jmp    80330b <alloc_block+0x356>
  8032f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032fa:	8b 40 04             	mov    0x4(%eax),%eax
  8032fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803300:	c1 e2 04             	shl    $0x4,%edx
  803303:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803309:	89 02                	mov    %eax,(%edx)
  80330b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80330e:	8b 40 04             	mov    0x4(%eax),%eax
  803311:	85 c0                	test   %eax,%eax
  803313:	74 0f                	je     803324 <alloc_block+0x36f>
  803315:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803318:	8b 40 04             	mov    0x4(%eax),%eax
  80331b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80331e:	8b 12                	mov    (%edx),%edx
  803320:	89 10                	mov    %edx,(%eax)
  803322:	eb 13                	jmp    803337 <alloc_block+0x382>
  803324:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80332c:	c1 e2 04             	shl    $0x4,%edx
  80332f:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803335:	89 02                	mov    %eax,(%edx)
  803337:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80333a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803340:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803343:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334d:	c1 e0 04             	shl    $0x4,%eax
  803350:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	8d 50 ff             	lea    -0x1(%eax),%edx
  80335a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335d:	c1 e0 04             	shl    $0x4,%eax
  803360:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803365:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803367:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80336a:	83 ec 0c             	sub    $0xc,%esp
  80336d:	50                   	push   %eax
  80336e:	e8 fe f8 ff ff       	call   802c71 <to_page_info>
  803373:	83 c4 10             	add    $0x10,%esp
  803376:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  803379:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803380:	48                   	dec    %eax
  803381:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803384:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803388:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80338b:	eb 32                	jmp    8033bf <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80338d:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803391:	77 15                	ja     8033a8 <alloc_block+0x3f3>
  803393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803396:	c1 e0 04             	shl    $0x4,%eax
  803399:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80339e:	8b 00                	mov    (%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	0f 84 f1 fe ff ff    	je     803299 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8033a8:	83 ec 04             	sub    $0x4,%esp
  8033ab:	68 ff 46 80 00       	push   $0x8046ff
  8033b0:	68 c8 00 00 00       	push   $0xc8
  8033b5:	68 23 46 80 00       	push   $0x804623
  8033ba:	e8 2c df ff ff       	call   8012eb <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8033bf:	c9                   	leave  
  8033c0:	c3                   	ret    

008033c1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8033c1:	55                   	push   %ebp
  8033c2:	89 e5                	mov    %esp,%ebp
  8033c4:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8033c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ca:	a1 48 d2 81 00       	mov    0x81d248,%eax
  8033cf:	39 c2                	cmp    %eax,%edx
  8033d1:	72 0c                	jb     8033df <free_block+0x1e>
  8033d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d6:	a1 20 52 80 00       	mov    0x805220,%eax
  8033db:	39 c2                	cmp    %eax,%edx
  8033dd:	72 19                	jb     8033f8 <free_block+0x37>
  8033df:	68 10 47 80 00       	push   $0x804710
  8033e4:	68 86 46 80 00       	push   $0x804686
  8033e9:	68 d7 00 00 00       	push   $0xd7
  8033ee:	68 23 46 80 00       	push   $0x804623
  8033f3:	e8 f3 de ff ff       	call   8012eb <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8033f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	83 ec 0c             	sub    $0xc,%esp
  803404:	50                   	push   %eax
  803405:	e8 67 f8 ff ff       	call   802c71 <to_page_info>
  80340a:	83 c4 10             	add    $0x10,%esp
  80340d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  803410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803413:	8b 40 08             	mov    0x8(%eax),%eax
  803416:	0f b7 c0             	movzwl %ax,%eax
  803419:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80341c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803423:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80342a:	eb 19                	jmp    803445 <free_block+0x84>
	    if ((1 << i) == blk_size)
  80342c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342f:	ba 01 00 00 00       	mov    $0x1,%edx
  803434:	88 c1                	mov    %al,%cl
  803436:	d3 e2                	shl    %cl,%edx
  803438:	89 d0                	mov    %edx,%eax
  80343a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80343d:	74 0e                	je     80344d <free_block+0x8c>
	        break;
	    idx++;
  80343f:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803442:	ff 45 f0             	incl   -0x10(%ebp)
  803445:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803449:	7e e1                	jle    80342c <free_block+0x6b>
  80344b:	eb 01                	jmp    80344e <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  80344d:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  80344e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803451:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803455:	40                   	inc    %eax
  803456:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803459:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  80345d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803461:	75 17                	jne    80347a <free_block+0xb9>
  803463:	83 ec 04             	sub    $0x4,%esp
  803466:	68 9c 46 80 00       	push   $0x80469c
  80346b:	68 ee 00 00 00       	push   $0xee
  803470:	68 23 46 80 00       	push   $0x804623
  803475:	e8 71 de ff ff       	call   8012eb <_panic>
  80347a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347d:	c1 e0 04             	shl    $0x4,%eax
  803480:	05 64 d2 81 00       	add    $0x81d264,%eax
  803485:	8b 10                	mov    (%eax),%edx
  803487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348a:	89 50 04             	mov    %edx,0x4(%eax)
  80348d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	85 c0                	test   %eax,%eax
  803495:	74 14                	je     8034ab <free_block+0xea>
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	c1 e0 04             	shl    $0x4,%eax
  80349d:	05 64 d2 81 00       	add    $0x81d264,%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a7:	89 10                	mov    %edx,(%eax)
  8034a9:	eb 11                	jmp    8034bc <free_block+0xfb>
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	c1 e0 04             	shl    $0x4,%eax
  8034b1:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ba:	89 02                	mov    %eax,(%edx)
  8034bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bf:	c1 e0 04             	shl    $0x4,%eax
  8034c2:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8034c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cb:	89 02                	mov    %eax,(%edx)
  8034cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	c1 e0 04             	shl    $0x4,%eax
  8034dc:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034e1:	8b 00                	mov    (%eax),%eax
  8034e3:	8d 50 01             	lea    0x1(%eax),%edx
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	c1 e0 04             	shl    $0x4,%eax
  8034ec:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034f1:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8034f3:	b8 00 10 00 00       	mov    $0x1000,%eax
  8034f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8034fd:	f7 75 e0             	divl   -0x20(%ebp)
  803500:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  803503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803506:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80350a:	0f b7 c0             	movzwl %ax,%eax
  80350d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803510:	0f 85 70 01 00 00    	jne    803686 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803516:	83 ec 0c             	sub    $0xc,%esp
  803519:	ff 75 e4             	pushl  -0x1c(%ebp)
  80351c:	e8 de f6 ff ff       	call   802bff <to_page_va>
  803521:	83 c4 10             	add    $0x10,%esp
  803524:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803527:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80352e:	e9 b7 00 00 00       	jmp    8035ea <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  803533:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803536:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803539:	01 d0                	add    %edx,%eax
  80353b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  80353e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803542:	75 17                	jne    80355b <free_block+0x19a>
  803544:	83 ec 04             	sub    $0x4,%esp
  803547:	68 e1 46 80 00       	push   $0x8046e1
  80354c:	68 f8 00 00 00       	push   $0xf8
  803551:	68 23 46 80 00       	push   $0x804623
  803556:	e8 90 dd ff ff       	call   8012eb <_panic>
  80355b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 10                	je     803574 <free_block+0x1b3>
  803564:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803567:	8b 00                	mov    (%eax),%eax
  803569:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80356c:	8b 52 04             	mov    0x4(%edx),%edx
  80356f:	89 50 04             	mov    %edx,0x4(%eax)
  803572:	eb 14                	jmp    803588 <free_block+0x1c7>
  803574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803577:	8b 40 04             	mov    0x4(%eax),%eax
  80357a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80357d:	c1 e2 04             	shl    $0x4,%edx
  803580:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803586:	89 02                	mov    %eax,(%edx)
  803588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358b:	8b 40 04             	mov    0x4(%eax),%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	74 0f                	je     8035a1 <free_block+0x1e0>
  803592:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803595:	8b 40 04             	mov    0x4(%eax),%eax
  803598:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80359b:	8b 12                	mov    (%edx),%edx
  80359d:	89 10                	mov    %edx,(%eax)
  80359f:	eb 13                	jmp    8035b4 <free_block+0x1f3>
  8035a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a9:	c1 e2 04             	shl    $0x4,%edx
  8035ac:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8035b2:	89 02                	mov    %eax,(%edx)
  8035b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	c1 e0 04             	shl    $0x4,%eax
  8035cd:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035d2:	8b 00                	mov    (%eax),%eax
  8035d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035da:	c1 e0 04             	shl    $0x4,%eax
  8035dd:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035e2:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8035e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035e7:	01 45 ec             	add    %eax,-0x14(%ebp)
  8035ea:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8035f1:	0f 86 3c ff ff ff    	jbe    803533 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8035f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fa:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803603:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803609:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80360d:	75 17                	jne    803626 <free_block+0x265>
  80360f:	83 ec 04             	sub    $0x4,%esp
  803612:	68 9c 46 80 00       	push   $0x80469c
  803617:	68 fe 00 00 00       	push   $0xfe
  80361c:	68 23 46 80 00       	push   $0x804623
  803621:	e8 c5 dc ff ff       	call   8012eb <_panic>
  803626:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  80362c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362f:	89 50 04             	mov    %edx,0x4(%eax)
  803632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803635:	8b 40 04             	mov    0x4(%eax),%eax
  803638:	85 c0                	test   %eax,%eax
  80363a:	74 0c                	je     803648 <free_block+0x287>
  80363c:	a1 2c 52 80 00       	mov    0x80522c,%eax
  803641:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803644:	89 10                	mov    %edx,(%eax)
  803646:	eb 08                	jmp    803650 <free_block+0x28f>
  803648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364b:	a3 28 52 80 00       	mov    %eax,0x805228
  803650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803653:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803661:	a1 34 52 80 00       	mov    0x805234,%eax
  803666:	40                   	inc    %eax
  803667:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80366c:	83 ec 0c             	sub    $0xc,%esp
  80366f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803672:	e8 88 f5 ff ff       	call   802bff <to_page_va>
  803677:	83 c4 10             	add    $0x10,%esp
  80367a:	83 ec 0c             	sub    $0xc,%esp
  80367d:	50                   	push   %eax
  80367e:	e8 b8 ee ff ff       	call   80253b <return_page>
  803683:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803686:	90                   	nop
  803687:	c9                   	leave  
  803688:	c3                   	ret    

00803689 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803689:	55                   	push   %ebp
  80368a:	89 e5                	mov    %esp,%ebp
  80368c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80368f:	83 ec 04             	sub    $0x4,%esp
  803692:	68 48 47 80 00       	push   $0x804748
  803697:	68 11 01 00 00       	push   $0x111
  80369c:	68 23 46 80 00       	push   $0x804623
  8036a1:	e8 45 dc ff ff       	call   8012eb <_panic>
  8036a6:	66 90                	xchg   %ax,%ax

008036a8 <__udivdi3>:
  8036a8:	55                   	push   %ebp
  8036a9:	57                   	push   %edi
  8036aa:	56                   	push   %esi
  8036ab:	53                   	push   %ebx
  8036ac:	83 ec 1c             	sub    $0x1c,%esp
  8036af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036bf:	89 ca                	mov    %ecx,%edx
  8036c1:	89 f8                	mov    %edi,%eax
  8036c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036c7:	85 f6                	test   %esi,%esi
  8036c9:	75 2d                	jne    8036f8 <__udivdi3+0x50>
  8036cb:	39 cf                	cmp    %ecx,%edi
  8036cd:	77 65                	ja     803734 <__udivdi3+0x8c>
  8036cf:	89 fd                	mov    %edi,%ebp
  8036d1:	85 ff                	test   %edi,%edi
  8036d3:	75 0b                	jne    8036e0 <__udivdi3+0x38>
  8036d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8036da:	31 d2                	xor    %edx,%edx
  8036dc:	f7 f7                	div    %edi
  8036de:	89 c5                	mov    %eax,%ebp
  8036e0:	31 d2                	xor    %edx,%edx
  8036e2:	89 c8                	mov    %ecx,%eax
  8036e4:	f7 f5                	div    %ebp
  8036e6:	89 c1                	mov    %eax,%ecx
  8036e8:	89 d8                	mov    %ebx,%eax
  8036ea:	f7 f5                	div    %ebp
  8036ec:	89 cf                	mov    %ecx,%edi
  8036ee:	89 fa                	mov    %edi,%edx
  8036f0:	83 c4 1c             	add    $0x1c,%esp
  8036f3:	5b                   	pop    %ebx
  8036f4:	5e                   	pop    %esi
  8036f5:	5f                   	pop    %edi
  8036f6:	5d                   	pop    %ebp
  8036f7:	c3                   	ret    
  8036f8:	39 ce                	cmp    %ecx,%esi
  8036fa:	77 28                	ja     803724 <__udivdi3+0x7c>
  8036fc:	0f bd fe             	bsr    %esi,%edi
  8036ff:	83 f7 1f             	xor    $0x1f,%edi
  803702:	75 40                	jne    803744 <__udivdi3+0x9c>
  803704:	39 ce                	cmp    %ecx,%esi
  803706:	72 0a                	jb     803712 <__udivdi3+0x6a>
  803708:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80370c:	0f 87 9e 00 00 00    	ja     8037b0 <__udivdi3+0x108>
  803712:	b8 01 00 00 00       	mov    $0x1,%eax
  803717:	89 fa                	mov    %edi,%edx
  803719:	83 c4 1c             	add    $0x1c,%esp
  80371c:	5b                   	pop    %ebx
  80371d:	5e                   	pop    %esi
  80371e:	5f                   	pop    %edi
  80371f:	5d                   	pop    %ebp
  803720:	c3                   	ret    
  803721:	8d 76 00             	lea    0x0(%esi),%esi
  803724:	31 ff                	xor    %edi,%edi
  803726:	31 c0                	xor    %eax,%eax
  803728:	89 fa                	mov    %edi,%edx
  80372a:	83 c4 1c             	add    $0x1c,%esp
  80372d:	5b                   	pop    %ebx
  80372e:	5e                   	pop    %esi
  80372f:	5f                   	pop    %edi
  803730:	5d                   	pop    %ebp
  803731:	c3                   	ret    
  803732:	66 90                	xchg   %ax,%ax
  803734:	89 d8                	mov    %ebx,%eax
  803736:	f7 f7                	div    %edi
  803738:	31 ff                	xor    %edi,%edi
  80373a:	89 fa                	mov    %edi,%edx
  80373c:	83 c4 1c             	add    $0x1c,%esp
  80373f:	5b                   	pop    %ebx
  803740:	5e                   	pop    %esi
  803741:	5f                   	pop    %edi
  803742:	5d                   	pop    %ebp
  803743:	c3                   	ret    
  803744:	bd 20 00 00 00       	mov    $0x20,%ebp
  803749:	89 eb                	mov    %ebp,%ebx
  80374b:	29 fb                	sub    %edi,%ebx
  80374d:	89 f9                	mov    %edi,%ecx
  80374f:	d3 e6                	shl    %cl,%esi
  803751:	89 c5                	mov    %eax,%ebp
  803753:	88 d9                	mov    %bl,%cl
  803755:	d3 ed                	shr    %cl,%ebp
  803757:	89 e9                	mov    %ebp,%ecx
  803759:	09 f1                	or     %esi,%ecx
  80375b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80375f:	89 f9                	mov    %edi,%ecx
  803761:	d3 e0                	shl    %cl,%eax
  803763:	89 c5                	mov    %eax,%ebp
  803765:	89 d6                	mov    %edx,%esi
  803767:	88 d9                	mov    %bl,%cl
  803769:	d3 ee                	shr    %cl,%esi
  80376b:	89 f9                	mov    %edi,%ecx
  80376d:	d3 e2                	shl    %cl,%edx
  80376f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803773:	88 d9                	mov    %bl,%cl
  803775:	d3 e8                	shr    %cl,%eax
  803777:	09 c2                	or     %eax,%edx
  803779:	89 d0                	mov    %edx,%eax
  80377b:	89 f2                	mov    %esi,%edx
  80377d:	f7 74 24 0c          	divl   0xc(%esp)
  803781:	89 d6                	mov    %edx,%esi
  803783:	89 c3                	mov    %eax,%ebx
  803785:	f7 e5                	mul    %ebp
  803787:	39 d6                	cmp    %edx,%esi
  803789:	72 19                	jb     8037a4 <__udivdi3+0xfc>
  80378b:	74 0b                	je     803798 <__udivdi3+0xf0>
  80378d:	89 d8                	mov    %ebx,%eax
  80378f:	31 ff                	xor    %edi,%edi
  803791:	e9 58 ff ff ff       	jmp    8036ee <__udivdi3+0x46>
  803796:	66 90                	xchg   %ax,%ax
  803798:	8b 54 24 08          	mov    0x8(%esp),%edx
  80379c:	89 f9                	mov    %edi,%ecx
  80379e:	d3 e2                	shl    %cl,%edx
  8037a0:	39 c2                	cmp    %eax,%edx
  8037a2:	73 e9                	jae    80378d <__udivdi3+0xe5>
  8037a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037a7:	31 ff                	xor    %edi,%edi
  8037a9:	e9 40 ff ff ff       	jmp    8036ee <__udivdi3+0x46>
  8037ae:	66 90                	xchg   %ax,%ax
  8037b0:	31 c0                	xor    %eax,%eax
  8037b2:	e9 37 ff ff ff       	jmp    8036ee <__udivdi3+0x46>
  8037b7:	90                   	nop

008037b8 <__umoddi3>:
  8037b8:	55                   	push   %ebp
  8037b9:	57                   	push   %edi
  8037ba:	56                   	push   %esi
  8037bb:	53                   	push   %ebx
  8037bc:	83 ec 1c             	sub    $0x1c,%esp
  8037bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037d7:	89 f3                	mov    %esi,%ebx
  8037d9:	89 fa                	mov    %edi,%edx
  8037db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037df:	89 34 24             	mov    %esi,(%esp)
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	75 1a                	jne    803800 <__umoddi3+0x48>
  8037e6:	39 f7                	cmp    %esi,%edi
  8037e8:	0f 86 a2 00 00 00    	jbe    803890 <__umoddi3+0xd8>
  8037ee:	89 c8                	mov    %ecx,%eax
  8037f0:	89 f2                	mov    %esi,%edx
  8037f2:	f7 f7                	div    %edi
  8037f4:	89 d0                	mov    %edx,%eax
  8037f6:	31 d2                	xor    %edx,%edx
  8037f8:	83 c4 1c             	add    $0x1c,%esp
  8037fb:	5b                   	pop    %ebx
  8037fc:	5e                   	pop    %esi
  8037fd:	5f                   	pop    %edi
  8037fe:	5d                   	pop    %ebp
  8037ff:	c3                   	ret    
  803800:	39 f0                	cmp    %esi,%eax
  803802:	0f 87 ac 00 00 00    	ja     8038b4 <__umoddi3+0xfc>
  803808:	0f bd e8             	bsr    %eax,%ebp
  80380b:	83 f5 1f             	xor    $0x1f,%ebp
  80380e:	0f 84 ac 00 00 00    	je     8038c0 <__umoddi3+0x108>
  803814:	bf 20 00 00 00       	mov    $0x20,%edi
  803819:	29 ef                	sub    %ebp,%edi
  80381b:	89 fe                	mov    %edi,%esi
  80381d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803821:	89 e9                	mov    %ebp,%ecx
  803823:	d3 e0                	shl    %cl,%eax
  803825:	89 d7                	mov    %edx,%edi
  803827:	89 f1                	mov    %esi,%ecx
  803829:	d3 ef                	shr    %cl,%edi
  80382b:	09 c7                	or     %eax,%edi
  80382d:	89 e9                	mov    %ebp,%ecx
  80382f:	d3 e2                	shl    %cl,%edx
  803831:	89 14 24             	mov    %edx,(%esp)
  803834:	89 d8                	mov    %ebx,%eax
  803836:	d3 e0                	shl    %cl,%eax
  803838:	89 c2                	mov    %eax,%edx
  80383a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80383e:	d3 e0                	shl    %cl,%eax
  803840:	89 44 24 04          	mov    %eax,0x4(%esp)
  803844:	8b 44 24 08          	mov    0x8(%esp),%eax
  803848:	89 f1                	mov    %esi,%ecx
  80384a:	d3 e8                	shr    %cl,%eax
  80384c:	09 d0                	or     %edx,%eax
  80384e:	d3 eb                	shr    %cl,%ebx
  803850:	89 da                	mov    %ebx,%edx
  803852:	f7 f7                	div    %edi
  803854:	89 d3                	mov    %edx,%ebx
  803856:	f7 24 24             	mull   (%esp)
  803859:	89 c6                	mov    %eax,%esi
  80385b:	89 d1                	mov    %edx,%ecx
  80385d:	39 d3                	cmp    %edx,%ebx
  80385f:	0f 82 87 00 00 00    	jb     8038ec <__umoddi3+0x134>
  803865:	0f 84 91 00 00 00    	je     8038fc <__umoddi3+0x144>
  80386b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80386f:	29 f2                	sub    %esi,%edx
  803871:	19 cb                	sbb    %ecx,%ebx
  803873:	89 d8                	mov    %ebx,%eax
  803875:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803879:	d3 e0                	shl    %cl,%eax
  80387b:	89 e9                	mov    %ebp,%ecx
  80387d:	d3 ea                	shr    %cl,%edx
  80387f:	09 d0                	or     %edx,%eax
  803881:	89 e9                	mov    %ebp,%ecx
  803883:	d3 eb                	shr    %cl,%ebx
  803885:	89 da                	mov    %ebx,%edx
  803887:	83 c4 1c             	add    $0x1c,%esp
  80388a:	5b                   	pop    %ebx
  80388b:	5e                   	pop    %esi
  80388c:	5f                   	pop    %edi
  80388d:	5d                   	pop    %ebp
  80388e:	c3                   	ret    
  80388f:	90                   	nop
  803890:	89 fd                	mov    %edi,%ebp
  803892:	85 ff                	test   %edi,%edi
  803894:	75 0b                	jne    8038a1 <__umoddi3+0xe9>
  803896:	b8 01 00 00 00       	mov    $0x1,%eax
  80389b:	31 d2                	xor    %edx,%edx
  80389d:	f7 f7                	div    %edi
  80389f:	89 c5                	mov    %eax,%ebp
  8038a1:	89 f0                	mov    %esi,%eax
  8038a3:	31 d2                	xor    %edx,%edx
  8038a5:	f7 f5                	div    %ebp
  8038a7:	89 c8                	mov    %ecx,%eax
  8038a9:	f7 f5                	div    %ebp
  8038ab:	89 d0                	mov    %edx,%eax
  8038ad:	e9 44 ff ff ff       	jmp    8037f6 <__umoddi3+0x3e>
  8038b2:	66 90                	xchg   %ax,%ax
  8038b4:	89 c8                	mov    %ecx,%eax
  8038b6:	89 f2                	mov    %esi,%edx
  8038b8:	83 c4 1c             	add    $0x1c,%esp
  8038bb:	5b                   	pop    %ebx
  8038bc:	5e                   	pop    %esi
  8038bd:	5f                   	pop    %edi
  8038be:	5d                   	pop    %ebp
  8038bf:	c3                   	ret    
  8038c0:	3b 04 24             	cmp    (%esp),%eax
  8038c3:	72 06                	jb     8038cb <__umoddi3+0x113>
  8038c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038c9:	77 0f                	ja     8038da <__umoddi3+0x122>
  8038cb:	89 f2                	mov    %esi,%edx
  8038cd:	29 f9                	sub    %edi,%ecx
  8038cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038d3:	89 14 24             	mov    %edx,(%esp)
  8038d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038de:	8b 14 24             	mov    (%esp),%edx
  8038e1:	83 c4 1c             	add    $0x1c,%esp
  8038e4:	5b                   	pop    %ebx
  8038e5:	5e                   	pop    %esi
  8038e6:	5f                   	pop    %edi
  8038e7:	5d                   	pop    %ebp
  8038e8:	c3                   	ret    
  8038e9:	8d 76 00             	lea    0x0(%esi),%esi
  8038ec:	2b 04 24             	sub    (%esp),%eax
  8038ef:	19 fa                	sbb    %edi,%edx
  8038f1:	89 d1                	mov    %edx,%ecx
  8038f3:	89 c6                	mov    %eax,%esi
  8038f5:	e9 71 ff ff ff       	jmp    80386b <__umoddi3+0xb3>
  8038fa:	66 90                	xchg   %ax,%ax
  8038fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803900:	72 ea                	jb     8038ec <__umoddi3+0x134>
  803902:	89 d9                	mov    %ebx,%ecx
  803904:	e9 62 ff ff ff       	jmp    80386b <__umoddi3+0xb3>
