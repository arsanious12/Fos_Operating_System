
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 01 13 00 00       	call   801337 <libmain>
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
  800067:	e8 04 29 00 00       	call   802970 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 47 29 00 00       	call   8029bb <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 b0 26 00 00       	call   802777 <malloc>
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
  8000df:	e8 8c 28 00 00       	call   802970 <sys_calculate_free_frames>
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
  800125:	68 20 3b 80 00       	push   $0x803b20
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 b1 16 00 00       	call   8017e2 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 82 28 00 00       	call   8029bb <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 3b 80 00       	push   $0x803b9c
  800150:	6a 0c                	push   $0xc
  800152:	e8 8b 16 00 00       	call   8017e2 <cprintf_colored>
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
  800174:	e8 f7 27 00 00       	call   802970 <sys_calculate_free_frames>
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
  8001b9:	e8 b2 27 00 00       	call   802970 <sys_calculate_free_frames>
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
  8001f8:	68 14 3c 80 00       	push   $0x803c14
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 de 15 00 00       	call   8017e2 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 af 27 00 00       	call   8029bb <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 3c 80 00       	push   $0x803ca0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 b1 15 00 00       	call   8017e2 <cprintf_colored>
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
  800270:	e8 bd 2a 00 00       	call   802d32 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 3d 80 00       	push   $0x803d18
  80028f:	6a 0c                	push   $0xc
  800291:	e8 4c 15 00 00       	call   8017e2 <cprintf_colored>
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
  8002ae:	e8 bd 26 00 00       	call   802970 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 00 27 00 00       	call   8029bb <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 d4 24 00 00       	call   8027a5 <free>
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
  8002fc:	e8 ba 26 00 00       	call   8029bb <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 3d 80 00       	push   $0x803d50
  800318:	6a 0c                	push   $0xc
  80031a:	e8 c3 14 00 00       	call   8017e2 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 49 26 00 00       	call   802970 <sys_calculate_free_frames>
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
  800342:	68 9c 3d 80 00       	push   $0x803d9c
  800347:	6a 0c                	push   $0xc
  800349:	e8 94 14 00 00       	call   8017e2 <cprintf_colored>
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
  8003a0:	e8 8d 29 00 00       	call   802d32 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 f8 3d 80 00       	push   $0x803df8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 1c 14 00 00       	call   8017e2 <cprintf_colored>
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
  800416:	68 30 3e 80 00       	push   $0x803e30
  80041b:	6a 03                	push   $0x3
  80041d:	e8 c0 13 00 00       	call   8017e2 <cprintf_colored>
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
  8004df:	68 60 3e 80 00       	push   $0x803e60
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 f7 12 00 00       	call   8017e2 <cprintf_colored>
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
  8005b9:	68 60 3e 80 00       	push   $0x803e60
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 1d 12 00 00       	call   8017e2 <cprintf_colored>
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
  800693:	68 60 3e 80 00       	push   $0x803e60
  800698:	6a 0c                	push   $0xc
  80069a:	e8 43 11 00 00       	call   8017e2 <cprintf_colored>
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
  80076d:	68 60 3e 80 00       	push   $0x803e60
  800772:	6a 0c                	push   $0xc
  800774:	e8 69 10 00 00       	call   8017e2 <cprintf_colored>
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
  800847:	68 60 3e 80 00       	push   $0x803e60
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 8f 0f 00 00       	call   8017e2 <cprintf_colored>
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
  800921:	68 60 3e 80 00       	push   $0x803e60
  800926:	6a 0c                	push   $0xc
  800928:	e8 b5 0e 00 00       	call   8017e2 <cprintf_colored>
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
  800a16:	68 60 3e 80 00       	push   $0x803e60
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 c0 0d 00 00       	call   8017e2 <cprintf_colored>
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
  800b14:	68 60 3e 80 00       	push   $0x803e60
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 c2 0c 00 00       	call   8017e2 <cprintf_colored>
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
  800c12:	68 60 3e 80 00       	push   $0x803e60
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 c4 0b 00 00       	call   8017e2 <cprintf_colored>
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
  800d10:	68 60 3e 80 00       	push   $0x803e60
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 c6 0a 00 00       	call   8017e2 <cprintf_colored>
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
  800dfd:	68 60 3e 80 00       	push   $0x803e60
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 d9 09 00 00       	call   8017e2 <cprintf_colored>
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
  800eea:	68 60 3e 80 00       	push   $0x803e60
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 ec 08 00 00       	call   8017e2 <cprintf_colored>
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
  800fd7:	68 60 3e 80 00       	push   $0x803e60
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 ff 07 00 00       	call   8017e2 <cprintf_colored>
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
  800ffa:	68 b2 3e 80 00       	push   $0x803eb2
  800fff:	6a 03                	push   $0x3
  801001:	e8 dc 07 00 00       	call   8017e2 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 51 19 00 00       	call   802970 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 91 19 00 00       	call   8029bb <sys_pf_calculate_allocated_pages>
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
  801055:	e8 1d 17 00 00       	call   802777 <malloc>
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
  801084:	68 d0 3e 80 00       	push   $0x803ed0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 52 07 00 00       	call   8017e2 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 23 19 00 00       	call   8029bb <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 0c 3f 80 00       	push   $0x803f0c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 26 07 00 00       	call   8017e2 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 ac 18 00 00       	call   802970 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 7c 3f 80 00       	push   $0x803f7c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 fa 06 00 00       	call   8017e2 <cprintf_colored>
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


void _main(void)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	57                   	push   %edi
  801103:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801109:	a1 00 52 80 00       	mov    0x805200,%eax
  80110e:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801114:	a1 00 52 80 00       	mov    0x805200,%eax
  801119:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80111f:	39 c2                	cmp    %eax,%edx
  801121:	72 14                	jb     801137 <_main+0x38>
			panic("Please increase the WS size");
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	68 c4 3f 80 00       	push   $0x803fc4
  80112b:	6a 18                	push   $0x18
  80112d:	68 e0 3f 80 00       	push   $0x803fe0
  801132:	e8 b0 03 00 00       	call   8014e7 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/
	int eval = 0;
  801137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool correct ;

	correct = 1;
  80113e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//Create some areas in PAGE allocators
	cprintf_colored(TEXT_cyan,"%~\n1 Create some allocations\n");
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	68 f4 3f 80 00       	push   $0x803ff4
  80114d:	6a 03                	push   $0x3
  80114f:	e8 8e 06 00 00       	call   8017e2 <cprintf_colored>
  801154:	83 c4 10             	add    $0x10,%esp
	{
		eval = initial_page_allocations();
  801157:	e8 72 f2 ff ff       	call   8003ce <initial_page_allocations>
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		eval = eval * 70 / 100; //rescale
  80115f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801162:	89 d0                	mov    %edx,%eax
  801164:	c1 e0 02             	shl    $0x2,%eax
  801167:	01 d0                	add    %edx,%eax
  801169:	01 c0                	add    %eax,%eax
  80116b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  801172:	89 d1                	mov    %edx,%ecx
  801174:	29 c1                	sub    %eax,%ecx
  801176:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  80117b:	f7 e9                	imul   %ecx
  80117d:	c1 fa 05             	sar    $0x5,%edx
  801180:	89 c8                	mov    %ecx,%eax
  801182:	c1 f8 1f             	sar    $0x1f,%eax
  801185:	29 c2                	sub    %eax,%edx
  801187:	89 d0                	mov    %edx,%eax
  801189:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	//2. Check BREAK
	correct = 1;
  80118c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n2. Check Page Allocator BREAK [10%]\n");
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	68 14 40 80 00       	push   $0x804014
  80119b:	6a 03                	push   $0x3
  80119d:	e8 40 06 00 00       	call   8017e2 <cprintf_colored>
  8011a2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 allocSizes = 0;
  8011a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int i = 0; i < allocIndex; ++i)
  8011ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8011b3:	eb 30                	jmp    8011e5 <_main+0xe6>
		{
			allocSizes += ROUNDUP(requestedSizes[i], PAGE_SIZE);
  8011b5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8011bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011bf:	8b 14 85 60 51 80 00 	mov    0x805160(,%eax,4),%edx
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	01 d0                	add    %edx,%eax
  8011cb:	48                   	dec    %eax
  8011cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d7:	f7 75 e0             	divl   -0x20(%ebp)
  8011da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011dd:	29 d0                	sub    %edx,%eax
  8011df:	01 45 ec             	add    %eax,-0x14(%ebp)
	//2. Check BREAK
	correct = 1;
	cprintf_colored(TEXT_cyan,"%~\n2. Check Page Allocator BREAK [10%]\n");
	{
		uint32 allocSizes = 0;
		for (int i = 0; i < allocIndex; ++i)
  8011e2:	ff 45 e8             	incl   -0x18(%ebp)
  8011e5:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8011ea:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8011ed:	7c c6                	jl     8011b5 <_main+0xb6>
		{
			allocSizes += ROUNDUP(requestedSizes[i], PAGE_SIZE);
		}
		uint32 expectedVA = ACTUAL_PAGE_ALLOC_START + allocSizes;
  8011ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f2:	2d 00 f0 ff 7d       	sub    $0x7dfff000,%eax
  8011f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(uheapPageAllocBreak != expectedVA) {correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedVA, uheapPageAllocBreak);}
  8011fa:	a1 50 d2 81 00       	mov    0x81d250,%eax
  8011ff:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801202:	74 1f                	je     801223 <_main+0x124>
  801204:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80120b:	a1 50 d2 81 00       	mov    0x81d250,%eax
  801210:	50                   	push   %eax
  801211:	ff 75 d8             	pushl  -0x28(%ebp)
  801214:	68 3c 40 80 00       	push   $0x80403c
  801219:	6a 0c                	push   $0xc
  80121b:	e8 c2 05 00 00       	call   8017e2 <cprintf_colored>
  801220:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval += 10;
  801223:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801227:	74 04                	je     80122d <_main+0x12e>
  801229:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	correct = 1;
  80122d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//3. Check Content
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
  801234:	8d 95 34 ff ff ff    	lea    -0xcc(%ebp),%edx
  80123a:	b9 28 00 00 00       	mov    $0x28,%ecx
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	89 d7                	mov    %edx,%edi
  801246:	f3 ab                	rep stos %eax,%es:(%edi)
	cprintf_colored(TEXT_cyan,"%~\n3. Check Content [20%]\n");
  801248:	83 ec 08             	sub    $0x8,%esp
  80124b:	68 74 40 80 00       	push   $0x804074
  801250:	6a 03                	push   $0x3
  801252:	e8 8b 05 00 00       	call   8017e2 <cprintf_colored>
  801257:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 0; i < allocIndex; ++i)
  80125a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801261:	e9 97 00 00 00       	jmp    8012fd <_main+0x1fe>
		{
			char* ptr = (char*)ptr_allocations[i];
  801266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801269:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  801270:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			sums[i] += ptr[0] ;
  801273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801276:	8b 94 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%edx
  80127d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	0f be c0             	movsbl %al,%eax
  801285:	01 c2                	add    %eax,%edx
  801287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128a:	89 94 85 34 ff ff ff 	mov    %edx,-0xcc(%ebp,%eax,4)
			sums[i] += ptr[lastIndices[i]] ;
  801291:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801294:	8b 94 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%edx
  80129b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80129e:	8b 04 85 c0 50 80 00 	mov    0x8050c0(,%eax,4),%eax
  8012a5:	89 c1                	mov    %eax,%ecx
  8012a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012aa:	01 c8                	add    %ecx,%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	0f be c0             	movsbl %al,%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b6:	89 94 85 34 ff ff ff 	mov    %edx,-0xcc(%ebp,%eax,4)
			if (sums[i] != (maxByte + maxByte))
  8012bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012c0:	8b 84 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%eax
  8012c7:	3d fe 00 00 00       	cmp    $0xfe,%eax
  8012cc:	74 2c                	je     8012fa <_main+0x1fb>
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in allocation#%d. Expected = %d, Actual = %d\n", i, maxByte + maxByte, sums[i]); }
  8012ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d8:	8b 84 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%eax
  8012df:	83 ec 0c             	sub    $0xc,%esp
  8012e2:	50                   	push   %eax
  8012e3:	68 fe 00 00 00       	push   $0xfe
  8012e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012eb:	68 90 40 80 00       	push   $0x804090
  8012f0:	6a 0c                	push   $0xc
  8012f2:	e8 eb 04 00 00       	call   8017e2 <cprintf_colored>
  8012f7:	83 c4 20             	add    $0x20,%esp

	//3. Check Content
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
	cprintf_colored(TEXT_cyan,"%~\n3. Check Content [20%]\n");
	{
		for (int i = 0; i < allocIndex; ++i)
  8012fa:	ff 45 e4             	incl   -0x1c(%ebp)
  8012fd:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  801302:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801305:	0f 8c 5b ff ff ff    	jl     801266 <_main+0x167>
			sums[i] += ptr[lastIndices[i]] ;
			if (sums[i] != (maxByte + maxByte))
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in allocation#%d. Expected = %d, Actual = %d\n", i, maxByte + maxByte, sums[i]); }
		}
	}
	if (correct) eval += 20;
  80130b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80130f:	74 04                	je     801315 <_main+0x216>
  801311:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	correct = 1;
  801315:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_light_green, "%~\nTest malloc (1) [PAGE ALLOCATOR] completed. Eval = %d\n", eval);
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	ff 75 f4             	pushl  -0xc(%ebp)
  801322:	68 d0 40 80 00       	push   $0x8040d0
  801327:	6a 0a                	push   $0xa
  801329:	e8 b4 04 00 00       	call   8017e2 <cprintf_colored>
  80132e:	83 c4 10             	add    $0x10,%esp

	return;
  801331:	90                   	nop
}
  801332:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801340:	e8 f4 17 00 00       	call   802b39 <sys_getenvindex>
  801345:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801348:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80134b:	89 d0                	mov    %edx,%eax
  80134d:	c1 e0 02             	shl    $0x2,%eax
  801350:	01 d0                	add    %edx,%eax
  801352:	c1 e0 03             	shl    $0x3,%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80135e:	01 d0                	add    %edx,%eax
  801360:	c1 e0 02             	shl    $0x2,%eax
  801363:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801368:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80136d:	a1 00 52 80 00       	mov    0x805200,%eax
  801372:	8a 40 20             	mov    0x20(%eax),%al
  801375:	84 c0                	test   %al,%al
  801377:	74 0d                	je     801386 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801379:	a1 00 52 80 00       	mov    0x805200,%eax
  80137e:	83 c0 20             	add    $0x20,%eax
  801381:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138a:	7e 0a                	jle    801396 <libmain+0x5f>
		binaryname = argv[0];
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	8b 00                	mov    (%eax),%eax
  801391:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  801396:	83 ec 08             	sub    $0x8,%esp
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	ff 75 08             	pushl  0x8(%ebp)
  80139f:	e8 5b fd ff ff       	call   8010ff <_main>
  8013a4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8013a7:	a1 00 50 80 00       	mov    0x805000,%eax
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	0f 84 01 01 00 00    	je     8014b5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8013b4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8013ba:	bb 04 42 80 00       	mov    $0x804204,%ebx
  8013bf:	ba 0e 00 00 00       	mov    $0xe,%edx
  8013c4:	89 c7                	mov    %eax,%edi
  8013c6:	89 de                	mov    %ebx,%esi
  8013c8:	89 d1                	mov    %edx,%ecx
  8013ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8013cc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8013cf:	b9 56 00 00 00       	mov    $0x56,%ecx
  8013d4:	b0 00                	mov    $0x0,%al
  8013d6:	89 d7                	mov    %edx,%edi
  8013d8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8013da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8013e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013e4:	83 ec 08             	sub    $0x8,%esp
  8013e7:	50                   	push   %eax
  8013e8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8013ee:	50                   	push   %eax
  8013ef:	e8 7b 19 00 00       	call   802d6f <sys_utilities>
  8013f4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8013f7:	e8 c4 14 00 00       	call   8028c0 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8013fc:	83 ec 0c             	sub    $0xc,%esp
  8013ff:	68 24 41 80 00       	push   $0x804124
  801404:	e8 ac 03 00 00       	call   8017b5 <cprintf>
  801409:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80140c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140f:	85 c0                	test   %eax,%eax
  801411:	74 18                	je     80142b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801413:	e8 75 19 00 00       	call   802d8d <sys_get_optimal_num_faults>
  801418:	83 ec 08             	sub    $0x8,%esp
  80141b:	50                   	push   %eax
  80141c:	68 4c 41 80 00       	push   $0x80414c
  801421:	e8 8f 03 00 00       	call   8017b5 <cprintf>
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	eb 59                	jmp    801484 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80142b:	a1 00 52 80 00       	mov    0x805200,%eax
  801430:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  801436:	a1 00 52 80 00       	mov    0x805200,%eax
  80143b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  801441:	83 ec 04             	sub    $0x4,%esp
  801444:	52                   	push   %edx
  801445:	50                   	push   %eax
  801446:	68 70 41 80 00       	push   $0x804170
  80144b:	e8 65 03 00 00       	call   8017b5 <cprintf>
  801450:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801453:	a1 00 52 80 00       	mov    0x805200,%eax
  801458:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80145e:	a1 00 52 80 00       	mov    0x805200,%eax
  801463:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  801469:	a1 00 52 80 00       	mov    0x805200,%eax
  80146e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801474:	51                   	push   %ecx
  801475:	52                   	push   %edx
  801476:	50                   	push   %eax
  801477:	68 98 41 80 00       	push   $0x804198
  80147c:	e8 34 03 00 00       	call   8017b5 <cprintf>
  801481:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801484:	a1 00 52 80 00       	mov    0x805200,%eax
  801489:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	50                   	push   %eax
  801493:	68 f0 41 80 00       	push   $0x8041f0
  801498:	e8 18 03 00 00       	call   8017b5 <cprintf>
  80149d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	68 24 41 80 00       	push   $0x804124
  8014a8:	e8 08 03 00 00       	call   8017b5 <cprintf>
  8014ad:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8014b0:	e8 25 14 00 00       	call   8028da <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8014b5:	e8 1f 00 00 00       	call   8014d9 <exit>
}
  8014ba:	90                   	nop
  8014bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014be:	5b                   	pop    %ebx
  8014bf:	5e                   	pop    %esi
  8014c0:	5f                   	pop    %edi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	6a 00                	push   $0x0
  8014ce:	e8 32 16 00 00       	call   802b05 <sys_destroy_env>
  8014d3:	83 c4 10             	add    $0x10,%esp
}
  8014d6:	90                   	nop
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <exit>:

void
exit(void)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8014df:	e8 87 16 00 00       	call   802b6b <sys_exit_env>
}
  8014e4:	90                   	nop
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8014ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8014f0:	83 c0 04             	add    $0x4,%eax
  8014f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8014f6:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	74 16                	je     801515 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8014ff:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	50                   	push   %eax
  801508:	68 68 42 80 00       	push   $0x804268
  80150d:	e8 a3 02 00 00       	call   8017b5 <cprintf>
  801512:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801515:	a1 04 50 80 00       	mov    0x805004,%eax
  80151a:	83 ec 0c             	sub    $0xc,%esp
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	ff 75 08             	pushl  0x8(%ebp)
  801523:	50                   	push   %eax
  801524:	68 70 42 80 00       	push   $0x804270
  801529:	6a 74                	push   $0x74
  80152b:	e8 b2 02 00 00       	call   8017e2 <cprintf_colored>
  801530:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	ff 75 f4             	pushl  -0xc(%ebp)
  80153c:	50                   	push   %eax
  80153d:	e8 04 02 00 00       	call   801746 <vcprintf>
  801542:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	6a 00                	push   $0x0
  80154a:	68 98 42 80 00       	push   $0x804298
  80154f:	e8 f2 01 00 00       	call   801746 <vcprintf>
  801554:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801557:	e8 7d ff ff ff       	call   8014d9 <exit>

	// should not return here
	while (1) ;
  80155c:	eb fe                	jmp    80155c <_panic+0x75>

0080155e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801564:	a1 00 52 80 00       	mov    0x805200,%eax
  801569:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	39 c2                	cmp    %eax,%edx
  801574:	74 14                	je     80158a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 9c 42 80 00       	push   $0x80429c
  80157e:	6a 26                	push   $0x26
  801580:	68 e8 42 80 00       	push   $0x8042e8
  801585:	e8 5d ff ff ff       	call   8014e7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80158a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801591:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801598:	e9 c5 00 00 00       	jmp    801662 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	01 d0                	add    %edx,%eax
  8015ac:	8b 00                	mov    (%eax),%eax
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	75 08                	jne    8015ba <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8015b2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8015b5:	e9 a5 00 00 00       	jmp    80165f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8015ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8015c8:	eb 69                	jmp    801633 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8015ca:	a1 00 52 80 00       	mov    0x805200,%eax
  8015cf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8015d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015d8:	89 d0                	mov    %edx,%eax
  8015da:	01 c0                	add    %eax,%eax
  8015dc:	01 d0                	add    %edx,%eax
  8015de:	c1 e0 03             	shl    $0x3,%eax
  8015e1:	01 c8                	add    %ecx,%eax
  8015e3:	8a 40 04             	mov    0x4(%eax),%al
  8015e6:	84 c0                	test   %al,%al
  8015e8:	75 46                	jne    801630 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8015ea:	a1 00 52 80 00       	mov    0x805200,%eax
  8015ef:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8015f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015f8:	89 d0                	mov    %edx,%eax
  8015fa:	01 c0                	add    %eax,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	c1 e0 03             	shl    $0x3,%eax
  801601:	01 c8                	add    %ecx,%eax
  801603:	8b 00                	mov    (%eax),%eax
  801605:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801608:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80160b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801610:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	01 c8                	add    %ecx,%eax
  801621:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801623:	39 c2                	cmp    %eax,%edx
  801625:	75 09                	jne    801630 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801627:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80162e:	eb 15                	jmp    801645 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801630:	ff 45 e8             	incl   -0x18(%ebp)
  801633:	a1 00 52 80 00       	mov    0x805200,%eax
  801638:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80163e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801641:	39 c2                	cmp    %eax,%edx
  801643:	77 85                	ja     8015ca <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801649:	75 14                	jne    80165f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	68 f4 42 80 00       	push   $0x8042f4
  801653:	6a 3a                	push   $0x3a
  801655:	68 e8 42 80 00       	push   $0x8042e8
  80165a:	e8 88 fe ff ff       	call   8014e7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80165f:	ff 45 f0             	incl   -0x10(%ebp)
  801662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801668:	0f 8c 2f ff ff ff    	jl     80159d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80166e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80167c:	eb 26                	jmp    8016a4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80167e:	a1 00 52 80 00       	mov    0x805200,%eax
  801683:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80168c:	89 d0                	mov    %edx,%eax
  80168e:	01 c0                	add    %eax,%eax
  801690:	01 d0                	add    %edx,%eax
  801692:	c1 e0 03             	shl    $0x3,%eax
  801695:	01 c8                	add    %ecx,%eax
  801697:	8a 40 04             	mov    0x4(%eax),%al
  80169a:	3c 01                	cmp    $0x1,%al
  80169c:	75 03                	jne    8016a1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80169e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016a1:	ff 45 e0             	incl   -0x20(%ebp)
  8016a4:	a1 00 52 80 00       	mov    0x805200,%eax
  8016a9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b2:	39 c2                	cmp    %eax,%edx
  8016b4:	77 c8                	ja     80167e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8016bc:	74 14                	je     8016d2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8016be:	83 ec 04             	sub    $0x4,%esp
  8016c1:	68 48 43 80 00       	push   $0x804348
  8016c6:	6a 44                	push   $0x44
  8016c8:	68 e8 42 80 00       	push   $0x8042e8
  8016cd:	e8 15 fe ff ff       	call   8014e7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8016d2:	90                   	nop
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8016dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016df:	8b 00                	mov    (%eax),%eax
  8016e1:	8d 48 01             	lea    0x1(%eax),%ecx
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	89 0a                	mov    %ecx,(%edx)
  8016e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ec:	88 d1                	mov    %dl,%cl
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	8b 00                	mov    (%eax),%eax
  8016fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8016ff:	75 30                	jne    801731 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801701:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801707:	a0 24 52 80 00       	mov    0x805224,%al
  80170c:	0f b6 c0             	movzbl %al,%eax
  80170f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801712:	8b 09                	mov    (%ecx),%ecx
  801714:	89 cb                	mov    %ecx,%ebx
  801716:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801719:	83 c1 08             	add    $0x8,%ecx
  80171c:	52                   	push   %edx
  80171d:	50                   	push   %eax
  80171e:	53                   	push   %ebx
  80171f:	51                   	push   %ecx
  801720:	e8 57 11 00 00       	call   80287c <sys_cputs>
  801725:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801731:	8b 45 0c             	mov    0xc(%ebp),%eax
  801734:	8b 40 04             	mov    0x4(%eax),%eax
  801737:	8d 50 01             	lea    0x1(%eax),%edx
  80173a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801740:	90                   	nop
  801741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80174f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801756:	00 00 00 
	b.cnt = 0;
  801759:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801760:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80176f:	50                   	push   %eax
  801770:	68 d5 16 80 00       	push   $0x8016d5
  801775:	e8 5a 02 00 00       	call   8019d4 <vprintfmt>
  80177a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80177d:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801783:	a0 24 52 80 00       	mov    0x805224,%al
  801788:	0f b6 c0             	movzbl %al,%eax
  80178b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801791:	52                   	push   %edx
  801792:	50                   	push   %eax
  801793:	51                   	push   %ecx
  801794:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80179a:	83 c0 08             	add    $0x8,%eax
  80179d:	50                   	push   %eax
  80179e:	e8 d9 10 00 00       	call   80287c <sys_cputs>
  8017a3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8017a6:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  8017ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8017bb:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  8017c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8017c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d1:	50                   	push   %eax
  8017d2:	e8 6f ff ff ff       	call   801746 <vcprintf>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8017e8:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	c1 e0 08             	shl    $0x8,%eax
  8017f5:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  8017fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8017fd:	83 c0 04             	add    $0x4,%eax
  801800:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	83 ec 08             	sub    $0x8,%esp
  801809:	ff 75 f4             	pushl  -0xc(%ebp)
  80180c:	50                   	push   %eax
  80180d:	e8 34 ff ff ff       	call   801746 <vcprintf>
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801818:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  80181f:	07 00 00 

	return cnt;
  801822:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80182d:	e8 8e 10 00 00       	call   8028c0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801832:	8d 45 0c             	lea    0xc(%ebp),%eax
  801835:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	83 ec 08             	sub    $0x8,%esp
  80183e:	ff 75 f4             	pushl  -0xc(%ebp)
  801841:	50                   	push   %eax
  801842:	e8 ff fe ff ff       	call   801746 <vcprintf>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80184d:	e8 88 10 00 00       	call   8028da <sys_unlock_cons>
	return cnt;
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	53                   	push   %ebx
  80185b:	83 ec 14             	sub    $0x14,%esp
  80185e:	8b 45 10             	mov    0x10(%ebp),%eax
  801861:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801864:	8b 45 14             	mov    0x14(%ebp),%eax
  801867:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80186a:	8b 45 18             	mov    0x18(%ebp),%eax
  80186d:	ba 00 00 00 00       	mov    $0x0,%edx
  801872:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801875:	77 55                	ja     8018cc <printnum+0x75>
  801877:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80187a:	72 05                	jb     801881 <printnum+0x2a>
  80187c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80187f:	77 4b                	ja     8018cc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801881:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801884:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801887:	8b 45 18             	mov    0x18(%ebp),%eax
  80188a:	ba 00 00 00 00       	mov    $0x0,%edx
  80188f:	52                   	push   %edx
  801890:	50                   	push   %eax
  801891:	ff 75 f4             	pushl  -0xc(%ebp)
  801894:	ff 75 f0             	pushl  -0x10(%ebp)
  801897:	e8 08 20 00 00       	call   8038a4 <__udivdi3>
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	ff 75 20             	pushl  0x20(%ebp)
  8018a5:	53                   	push   %ebx
  8018a6:	ff 75 18             	pushl  0x18(%ebp)
  8018a9:	52                   	push   %edx
  8018aa:	50                   	push   %eax
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	e8 a1 ff ff ff       	call   801857 <printnum>
  8018b6:	83 c4 20             	add    $0x20,%esp
  8018b9:	eb 1a                	jmp    8018d5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8018bb:	83 ec 08             	sub    $0x8,%esp
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	ff 75 20             	pushl  0x20(%ebp)
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	ff d0                	call   *%eax
  8018c9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8018cc:	ff 4d 1c             	decl   0x1c(%ebp)
  8018cf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8018d3:	7f e6                	jg     8018bb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8018d5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8018d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e3:	53                   	push   %ebx
  8018e4:	51                   	push   %ecx
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	e8 c8 20 00 00       	call   8039b4 <__umoddi3>
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	05 b4 45 80 00       	add    $0x8045b4,%eax
  8018f4:	8a 00                	mov    (%eax),%al
  8018f6:	0f be c0             	movsbl %al,%eax
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	50                   	push   %eax
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	ff d0                	call   *%eax
  801905:	83 c4 10             	add    $0x10,%esp
}
  801908:	90                   	nop
  801909:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801911:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801915:	7e 1c                	jle    801933 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	8b 00                	mov    (%eax),%eax
  80191c:	8d 50 08             	lea    0x8(%eax),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	89 10                	mov    %edx,(%eax)
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	8b 00                	mov    (%eax),%eax
  801929:	83 e8 08             	sub    $0x8,%eax
  80192c:	8b 50 04             	mov    0x4(%eax),%edx
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	eb 40                	jmp    801973 <getuint+0x65>
	else if (lflag)
  801933:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801937:	74 1e                	je     801957 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	8b 00                	mov    (%eax),%eax
  80193e:	8d 50 04             	lea    0x4(%eax),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	89 10                	mov    %edx,(%eax)
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	8b 00                	mov    (%eax),%eax
  80194b:	83 e8 04             	sub    $0x4,%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	eb 1c                	jmp    801973 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8b 00                	mov    (%eax),%eax
  80195c:	8d 50 04             	lea    0x4(%eax),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	89 10                	mov    %edx,(%eax)
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8b 00                	mov    (%eax),%eax
  801969:	83 e8 04             	sub    $0x4,%eax
  80196c:	8b 00                	mov    (%eax),%eax
  80196e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801978:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80197c:	7e 1c                	jle    80199a <getint+0x25>
		return va_arg(*ap, long long);
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	8b 00                	mov    (%eax),%eax
  801983:	8d 50 08             	lea    0x8(%eax),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 10                	mov    %edx,(%eax)
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	8b 00                	mov    (%eax),%eax
  801990:	83 e8 08             	sub    $0x8,%eax
  801993:	8b 50 04             	mov    0x4(%eax),%edx
  801996:	8b 00                	mov    (%eax),%eax
  801998:	eb 38                	jmp    8019d2 <getint+0x5d>
	else if (lflag)
  80199a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80199e:	74 1a                	je     8019ba <getint+0x45>
		return va_arg(*ap, long);
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8b 00                	mov    (%eax),%eax
  8019a5:	8d 50 04             	lea    0x4(%eax),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	89 10                	mov    %edx,(%eax)
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	83 e8 04             	sub    $0x4,%eax
  8019b5:	8b 00                	mov    (%eax),%eax
  8019b7:	99                   	cltd   
  8019b8:	eb 18                	jmp    8019d2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8b 00                	mov    (%eax),%eax
  8019bf:	8d 50 04             	lea    0x4(%eax),%edx
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	89 10                	mov    %edx,(%eax)
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	83 e8 04             	sub    $0x4,%eax
  8019cf:	8b 00                	mov    (%eax),%eax
  8019d1:	99                   	cltd   
}
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	56                   	push   %esi
  8019d8:	53                   	push   %ebx
  8019d9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8019dc:	eb 17                	jmp    8019f5 <vprintfmt+0x21>
			if (ch == '\0')
  8019de:	85 db                	test   %ebx,%ebx
  8019e0:	0f 84 c1 03 00 00    	je     801da7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8019e6:	83 ec 08             	sub    $0x8,%esp
  8019e9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ec:	53                   	push   %ebx
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	ff d0                	call   *%eax
  8019f2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	8d 50 01             	lea    0x1(%eax),%edx
  8019fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8019fe:	8a 00                	mov    (%eax),%al
  801a00:	0f b6 d8             	movzbl %al,%ebx
  801a03:	83 fb 25             	cmp    $0x25,%ebx
  801a06:	75 d6                	jne    8019de <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a08:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a0c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a28:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2b:	8d 50 01             	lea    0x1(%eax),%edx
  801a2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801a31:	8a 00                	mov    (%eax),%al
  801a33:	0f b6 d8             	movzbl %al,%ebx
  801a36:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801a39:	83 f8 5b             	cmp    $0x5b,%eax
  801a3c:	0f 87 3d 03 00 00    	ja     801d7f <vprintfmt+0x3ab>
  801a42:	8b 04 85 d8 45 80 00 	mov    0x8045d8(,%eax,4),%eax
  801a49:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801a4b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801a4f:	eb d7                	jmp    801a28 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a51:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801a55:	eb d1                	jmp    801a28 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801a5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a61:	89 d0                	mov    %edx,%eax
  801a63:	c1 e0 02             	shl    $0x2,%eax
  801a66:	01 d0                	add    %edx,%eax
  801a68:	01 c0                	add    %eax,%eax
  801a6a:	01 d8                	add    %ebx,%eax
  801a6c:	83 e8 30             	sub    $0x30,%eax
  801a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801a72:	8b 45 10             	mov    0x10(%ebp),%eax
  801a75:	8a 00                	mov    (%eax),%al
  801a77:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801a7a:	83 fb 2f             	cmp    $0x2f,%ebx
  801a7d:	7e 3e                	jle    801abd <vprintfmt+0xe9>
  801a7f:	83 fb 39             	cmp    $0x39,%ebx
  801a82:	7f 39                	jg     801abd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a84:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801a87:	eb d5                	jmp    801a5e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801a89:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8c:	83 c0 04             	add    $0x4,%eax
  801a8f:	89 45 14             	mov    %eax,0x14(%ebp)
  801a92:	8b 45 14             	mov    0x14(%ebp),%eax
  801a95:	83 e8 04             	sub    $0x4,%eax
  801a98:	8b 00                	mov    (%eax),%eax
  801a9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801a9d:	eb 1f                	jmp    801abe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801a9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aa3:	79 83                	jns    801a28 <vprintfmt+0x54>
				width = 0;
  801aa5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801aac:	e9 77 ff ff ff       	jmp    801a28 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801ab1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801ab8:	e9 6b ff ff ff       	jmp    801a28 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801abd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801abe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ac2:	0f 89 60 ff ff ff    	jns    801a28 <vprintfmt+0x54>
				width = precision, precision = -1;
  801ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ace:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801ad5:	e9 4e ff ff ff       	jmp    801a28 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ada:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801add:	e9 46 ff ff ff       	jmp    801a28 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801ae2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae5:	83 c0 04             	add    $0x4,%eax
  801ae8:	89 45 14             	mov    %eax,0x14(%ebp)
  801aeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801aee:	83 e8 04             	sub    $0x4,%eax
  801af1:	8b 00                	mov    (%eax),%eax
  801af3:	83 ec 08             	sub    $0x8,%esp
  801af6:	ff 75 0c             	pushl  0xc(%ebp)
  801af9:	50                   	push   %eax
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	ff d0                	call   *%eax
  801aff:	83 c4 10             	add    $0x10,%esp
			break;
  801b02:	e9 9b 02 00 00       	jmp    801da2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b07:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0a:	83 c0 04             	add    $0x4,%eax
  801b0d:	89 45 14             	mov    %eax,0x14(%ebp)
  801b10:	8b 45 14             	mov    0x14(%ebp),%eax
  801b13:	83 e8 04             	sub    $0x4,%eax
  801b16:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b18:	85 db                	test   %ebx,%ebx
  801b1a:	79 02                	jns    801b1e <vprintfmt+0x14a>
				err = -err;
  801b1c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b1e:	83 fb 64             	cmp    $0x64,%ebx
  801b21:	7f 0b                	jg     801b2e <vprintfmt+0x15a>
  801b23:	8b 34 9d 20 44 80 00 	mov    0x804420(,%ebx,4),%esi
  801b2a:	85 f6                	test   %esi,%esi
  801b2c:	75 19                	jne    801b47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b2e:	53                   	push   %ebx
  801b2f:	68 c5 45 80 00       	push   $0x8045c5
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	e8 70 02 00 00       	call   801daf <printfmt>
  801b3f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b42:	e9 5b 02 00 00       	jmp    801da2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b47:	56                   	push   %esi
  801b48:	68 ce 45 80 00       	push   $0x8045ce
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	e8 57 02 00 00       	call   801daf <printfmt>
  801b58:	83 c4 10             	add    $0x10,%esp
			break;
  801b5b:	e9 42 02 00 00       	jmp    801da2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801b60:	8b 45 14             	mov    0x14(%ebp),%eax
  801b63:	83 c0 04             	add    $0x4,%eax
  801b66:	89 45 14             	mov    %eax,0x14(%ebp)
  801b69:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6c:	83 e8 04             	sub    $0x4,%eax
  801b6f:	8b 30                	mov    (%eax),%esi
  801b71:	85 f6                	test   %esi,%esi
  801b73:	75 05                	jne    801b7a <vprintfmt+0x1a6>
				p = "(null)";
  801b75:	be d1 45 80 00       	mov    $0x8045d1,%esi
			if (width > 0 && padc != '-')
  801b7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b7e:	7e 6d                	jle    801bed <vprintfmt+0x219>
  801b80:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801b84:	74 67                	je     801bed <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801b86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b89:	83 ec 08             	sub    $0x8,%esp
  801b8c:	50                   	push   %eax
  801b8d:	56                   	push   %esi
  801b8e:	e8 1e 03 00 00       	call   801eb1 <strnlen>
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801b99:	eb 16                	jmp    801bb1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801b9b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801b9f:	83 ec 08             	sub    $0x8,%esp
  801ba2:	ff 75 0c             	pushl  0xc(%ebp)
  801ba5:	50                   	push   %eax
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	ff d0                	call   *%eax
  801bab:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bae:	ff 4d e4             	decl   -0x1c(%ebp)
  801bb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bb5:	7f e4                	jg     801b9b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801bb7:	eb 34                	jmp    801bed <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801bb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bbd:	74 1c                	je     801bdb <vprintfmt+0x207>
  801bbf:	83 fb 1f             	cmp    $0x1f,%ebx
  801bc2:	7e 05                	jle    801bc9 <vprintfmt+0x1f5>
  801bc4:	83 fb 7e             	cmp    $0x7e,%ebx
  801bc7:	7e 12                	jle    801bdb <vprintfmt+0x207>
					putch('?', putdat);
  801bc9:	83 ec 08             	sub    $0x8,%esp
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	6a 3f                	push   $0x3f
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	ff d0                	call   *%eax
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	eb 0f                	jmp    801bea <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801bdb:	83 ec 08             	sub    $0x8,%esp
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	53                   	push   %ebx
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	ff d0                	call   *%eax
  801be7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801bea:	ff 4d e4             	decl   -0x1c(%ebp)
  801bed:	89 f0                	mov    %esi,%eax
  801bef:	8d 70 01             	lea    0x1(%eax),%esi
  801bf2:	8a 00                	mov    (%eax),%al
  801bf4:	0f be d8             	movsbl %al,%ebx
  801bf7:	85 db                	test   %ebx,%ebx
  801bf9:	74 24                	je     801c1f <vprintfmt+0x24b>
  801bfb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bff:	78 b8                	js     801bb9 <vprintfmt+0x1e5>
  801c01:	ff 4d e0             	decl   -0x20(%ebp)
  801c04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c08:	79 af                	jns    801bb9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c0a:	eb 13                	jmp    801c1f <vprintfmt+0x24b>
				putch(' ', putdat);
  801c0c:	83 ec 08             	sub    $0x8,%esp
  801c0f:	ff 75 0c             	pushl  0xc(%ebp)
  801c12:	6a 20                	push   $0x20
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	ff d0                	call   *%eax
  801c19:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c1c:	ff 4d e4             	decl   -0x1c(%ebp)
  801c1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c23:	7f e7                	jg     801c0c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c25:	e9 78 01 00 00       	jmp    801da2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c2a:	83 ec 08             	sub    $0x8,%esp
  801c2d:	ff 75 e8             	pushl  -0x18(%ebp)
  801c30:	8d 45 14             	lea    0x14(%ebp),%eax
  801c33:	50                   	push   %eax
  801c34:	e8 3c fd ff ff       	call   801975 <getint>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c48:	85 d2                	test   %edx,%edx
  801c4a:	79 23                	jns    801c6f <vprintfmt+0x29b>
				putch('-', putdat);
  801c4c:	83 ec 08             	sub    $0x8,%esp
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	6a 2d                	push   $0x2d
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	ff d0                	call   *%eax
  801c59:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c62:	f7 d8                	neg    %eax
  801c64:	83 d2 00             	adc    $0x0,%edx
  801c67:	f7 da                	neg    %edx
  801c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801c6f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801c76:	e9 bc 00 00 00       	jmp    801d37 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801c7b:	83 ec 08             	sub    $0x8,%esp
  801c7e:	ff 75 e8             	pushl  -0x18(%ebp)
  801c81:	8d 45 14             	lea    0x14(%ebp),%eax
  801c84:	50                   	push   %eax
  801c85:	e8 84 fc ff ff       	call   80190e <getuint>
  801c8a:	83 c4 10             	add    $0x10,%esp
  801c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801c93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801c9a:	e9 98 00 00 00       	jmp    801d37 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	6a 58                	push   $0x58
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	ff d0                	call   *%eax
  801cac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801caf:	83 ec 08             	sub    $0x8,%esp
  801cb2:	ff 75 0c             	pushl  0xc(%ebp)
  801cb5:	6a 58                	push   $0x58
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	ff d0                	call   *%eax
  801cbc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cbf:	83 ec 08             	sub    $0x8,%esp
  801cc2:	ff 75 0c             	pushl  0xc(%ebp)
  801cc5:	6a 58                	push   $0x58
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	ff d0                	call   *%eax
  801ccc:	83 c4 10             	add    $0x10,%esp
			break;
  801ccf:	e9 ce 00 00 00       	jmp    801da2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801cd4:	83 ec 08             	sub    $0x8,%esp
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	6a 30                	push   $0x30
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	ff d0                	call   *%eax
  801ce1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801ce4:	83 ec 08             	sub    $0x8,%esp
  801ce7:	ff 75 0c             	pushl  0xc(%ebp)
  801cea:	6a 78                	push   $0x78
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	ff d0                	call   *%eax
  801cf1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801cf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf7:	83 c0 04             	add    $0x4,%eax
  801cfa:	89 45 14             	mov    %eax,0x14(%ebp)
  801cfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801d00:	83 e8 04             	sub    $0x4,%eax
  801d03:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d0f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d16:	eb 1f                	jmp    801d37 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d18:	83 ec 08             	sub    $0x8,%esp
  801d1b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d1e:	8d 45 14             	lea    0x14(%ebp),%eax
  801d21:	50                   	push   %eax
  801d22:	e8 e7 fb ff ff       	call   80190e <getuint>
  801d27:	83 c4 10             	add    $0x10,%esp
  801d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d30:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d37:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3e:	83 ec 04             	sub    $0x4,%esp
  801d41:	52                   	push   %edx
  801d42:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d45:	50                   	push   %eax
  801d46:	ff 75 f4             	pushl  -0xc(%ebp)
  801d49:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4c:	ff 75 0c             	pushl  0xc(%ebp)
  801d4f:	ff 75 08             	pushl  0x8(%ebp)
  801d52:	e8 00 fb ff ff       	call   801857 <printnum>
  801d57:	83 c4 20             	add    $0x20,%esp
			break;
  801d5a:	eb 46                	jmp    801da2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801d5c:	83 ec 08             	sub    $0x8,%esp
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	53                   	push   %ebx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	ff d0                	call   *%eax
  801d68:	83 c4 10             	add    $0x10,%esp
			break;
  801d6b:	eb 35                	jmp    801da2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801d6d:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801d74:	eb 2c                	jmp    801da2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801d76:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801d7d:	eb 23                	jmp    801da2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801d7f:	83 ec 08             	sub    $0x8,%esp
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	6a 25                	push   $0x25
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	ff d0                	call   *%eax
  801d8c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801d8f:	ff 4d 10             	decl   0x10(%ebp)
  801d92:	eb 03                	jmp    801d97 <vprintfmt+0x3c3>
  801d94:	ff 4d 10             	decl   0x10(%ebp)
  801d97:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9a:	48                   	dec    %eax
  801d9b:	8a 00                	mov    (%eax),%al
  801d9d:	3c 25                	cmp    $0x25,%al
  801d9f:	75 f3                	jne    801d94 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801da1:	90                   	nop
		}
	}
  801da2:	e9 35 fc ff ff       	jmp    8019dc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801da7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801da8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    

00801daf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801db5:	8d 45 10             	lea    0x10(%ebp),%eax
  801db8:	83 c0 04             	add    $0x4,%eax
  801dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc4:	50                   	push   %eax
  801dc5:	ff 75 0c             	pushl  0xc(%ebp)
  801dc8:	ff 75 08             	pushl  0x8(%ebp)
  801dcb:	e8 04 fc ff ff       	call   8019d4 <vprintfmt>
  801dd0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801dd3:	90                   	nop
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddc:	8b 40 08             	mov    0x8(%eax),%eax
  801ddf:	8d 50 01             	lea    0x1(%eax),%edx
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801deb:	8b 10                	mov    (%eax),%edx
  801ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df0:	8b 40 04             	mov    0x4(%eax),%eax
  801df3:	39 c2                	cmp    %eax,%edx
  801df5:	73 12                	jae    801e09 <sprintputch+0x33>
		*b->buf++ = ch;
  801df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfa:	8b 00                	mov    (%eax),%eax
  801dfc:	8d 48 01             	lea    0x1(%eax),%ecx
  801dff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e02:	89 0a                	mov    %ecx,(%edx)
  801e04:	8b 55 08             	mov    0x8(%ebp),%edx
  801e07:	88 10                	mov    %dl,(%eax)
}
  801e09:	90                   	nop
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    

00801e0c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	01 d0                	add    %edx,%eax
  801e23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e31:	74 06                	je     801e39 <vsnprintf+0x2d>
  801e33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e37:	7f 07                	jg     801e40 <vsnprintf+0x34>
		return -E_INVAL;
  801e39:	b8 03 00 00 00       	mov    $0x3,%eax
  801e3e:	eb 20                	jmp    801e60 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e40:	ff 75 14             	pushl  0x14(%ebp)
  801e43:	ff 75 10             	pushl  0x10(%ebp)
  801e46:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e49:	50                   	push   %eax
  801e4a:	68 d6 1d 80 00       	push   $0x801dd6
  801e4f:	e8 80 fb ff ff       	call   8019d4 <vprintfmt>
  801e54:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e68:	8d 45 10             	lea    0x10(%ebp),%eax
  801e6b:	83 c0 04             	add    $0x4,%eax
  801e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	ff 75 f4             	pushl  -0xc(%ebp)
  801e77:	50                   	push   %eax
  801e78:	ff 75 0c             	pushl  0xc(%ebp)
  801e7b:	ff 75 08             	pushl  0x8(%ebp)
  801e7e:	e8 89 ff ff ff       	call   801e0c <vsnprintf>
  801e83:	83 c4 10             	add    $0x10,%esp
  801e86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801e94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e9b:	eb 06                	jmp    801ea3 <strlen+0x15>
		n++;
  801e9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ea0:	ff 45 08             	incl   0x8(%ebp)
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	8a 00                	mov    (%eax),%al
  801ea8:	84 c0                	test   %al,%al
  801eaa:	75 f1                	jne    801e9d <strlen+0xf>
		n++;
	return n;
  801eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801eb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ebe:	eb 09                	jmp    801ec9 <strnlen+0x18>
		n++;
  801ec0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ec3:	ff 45 08             	incl   0x8(%ebp)
  801ec6:	ff 4d 0c             	decl   0xc(%ebp)
  801ec9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ecd:	74 09                	je     801ed8 <strnlen+0x27>
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	84 c0                	test   %al,%al
  801ed6:	75 e8                	jne    801ec0 <strnlen+0xf>
		n++;
	return n;
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801ee9:	90                   	nop
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	8d 50 01             	lea    0x1(%eax),%edx
  801ef0:	89 55 08             	mov    %edx,0x8(%ebp)
  801ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef6:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ef9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801efc:	8a 12                	mov    (%edx),%dl
  801efe:	88 10                	mov    %dl,(%eax)
  801f00:	8a 00                	mov    (%eax),%al
  801f02:	84 c0                	test   %al,%al
  801f04:	75 e4                	jne    801eea <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f1e:	eb 1f                	jmp    801f3f <strncpy+0x34>
		*dst++ = *src;
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	8d 50 01             	lea    0x1(%eax),%edx
  801f26:	89 55 08             	mov    %edx,0x8(%ebp)
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8a 12                	mov    (%edx),%dl
  801f2e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f33:	8a 00                	mov    (%eax),%al
  801f35:	84 c0                	test   %al,%al
  801f37:	74 03                	je     801f3c <strncpy+0x31>
			src++;
  801f39:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f3c:	ff 45 fc             	incl   -0x4(%ebp)
  801f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f42:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f45:	72 d9                	jb     801f20 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801f58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f5c:	74 30                	je     801f8e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801f5e:	eb 16                	jmp    801f76 <strlcpy+0x2a>
			*dst++ = *src++;
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	8d 50 01             	lea    0x1(%eax),%edx
  801f66:	89 55 08             	mov    %edx,0x8(%ebp)
  801f69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f72:	8a 12                	mov    (%edx),%dl
  801f74:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801f76:	ff 4d 10             	decl   0x10(%ebp)
  801f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f7d:	74 09                	je     801f88 <strlcpy+0x3c>
  801f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f82:	8a 00                	mov    (%eax),%al
  801f84:	84 c0                	test   %al,%al
  801f86:	75 d8                	jne    801f60 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f94:	29 c2                	sub    %eax,%edx
  801f96:	89 d0                	mov    %edx,%eax
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801f9d:	eb 06                	jmp    801fa5 <strcmp+0xb>
		p++, q++;
  801f9f:	ff 45 08             	incl   0x8(%ebp)
  801fa2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	8a 00                	mov    (%eax),%al
  801faa:	84 c0                	test   %al,%al
  801fac:	74 0e                	je     801fbc <strcmp+0x22>
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	8a 10                	mov    (%eax),%dl
  801fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb6:	8a 00                	mov    (%eax),%al
  801fb8:	38 c2                	cmp    %al,%dl
  801fba:	74 e3                	je     801f9f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	8a 00                	mov    (%eax),%al
  801fc1:	0f b6 d0             	movzbl %al,%edx
  801fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc7:	8a 00                	mov    (%eax),%al
  801fc9:	0f b6 c0             	movzbl %al,%eax
  801fcc:	29 c2                	sub    %eax,%edx
  801fce:	89 d0                	mov    %edx,%eax
}
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    

00801fd2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801fd5:	eb 09                	jmp    801fe0 <strncmp+0xe>
		n--, p++, q++;
  801fd7:	ff 4d 10             	decl   0x10(%ebp)
  801fda:	ff 45 08             	incl   0x8(%ebp)
  801fdd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801fe0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fe4:	74 17                	je     801ffd <strncmp+0x2b>
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	8a 00                	mov    (%eax),%al
  801feb:	84 c0                	test   %al,%al
  801fed:	74 0e                	je     801ffd <strncmp+0x2b>
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	8a 10                	mov    (%eax),%dl
  801ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff7:	8a 00                	mov    (%eax),%al
  801ff9:	38 c2                	cmp    %al,%dl
  801ffb:	74 da                	je     801fd7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ffd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802001:	75 07                	jne    80200a <strncmp+0x38>
		return 0;
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
  802008:	eb 14                	jmp    80201e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	8a 00                	mov    (%eax),%al
  80200f:	0f b6 d0             	movzbl %al,%edx
  802012:	8b 45 0c             	mov    0xc(%ebp),%eax
  802015:	8a 00                	mov    (%eax),%al
  802017:	0f b6 c0             	movzbl %al,%eax
  80201a:	29 c2                	sub    %eax,%edx
  80201c:	89 d0                	mov    %edx,%eax
}
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    

00802020 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	8b 45 0c             	mov    0xc(%ebp),%eax
  802029:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80202c:	eb 12                	jmp    802040 <strchr+0x20>
		if (*s == c)
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	8a 00                	mov    (%eax),%al
  802033:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802036:	75 05                	jne    80203d <strchr+0x1d>
			return (char *) s;
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	eb 11                	jmp    80204e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80203d:	ff 45 08             	incl   0x8(%ebp)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	8a 00                	mov    (%eax),%al
  802045:	84 c0                	test   %al,%al
  802047:	75 e5                	jne    80202e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80205c:	eb 0d                	jmp    80206b <strfind+0x1b>
		if (*s == c)
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	8a 00                	mov    (%eax),%al
  802063:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802066:	74 0e                	je     802076 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802068:	ff 45 08             	incl   0x8(%ebp)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8a 00                	mov    (%eax),%al
  802070:	84 c0                	test   %al,%al
  802072:	75 ea                	jne    80205e <strfind+0xe>
  802074:	eb 01                	jmp    802077 <strfind+0x27>
		if (*s == c)
			break;
  802076:	90                   	nop
	return (char *) s;
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802088:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80208c:	76 63                	jbe    8020f1 <memset+0x75>
		uint64 data_block = c;
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	99                   	cltd   
  802092:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802095:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8020a2:	c1 e0 08             	shl    $0x8,%eax
  8020a5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8020a8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b1:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8020b5:	c1 e0 10             	shl    $0x10,%eax
  8020b8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8020bb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8020be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c4:	89 c2                	mov    %eax,%edx
  8020c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cb:	09 45 f0             	or     %eax,-0x10(%ebp)
  8020ce:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8020d1:	eb 18                	jmp    8020eb <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8020d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8020d6:	8d 41 08             	lea    0x8(%ecx),%eax
  8020d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e2:	89 01                	mov    %eax,(%ecx)
  8020e4:	89 51 04             	mov    %edx,0x4(%ecx)
  8020e7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8020eb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8020ef:	77 e2                	ja     8020d3 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8020f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f5:	74 23                	je     80211a <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8020f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8020fd:	eb 0e                	jmp    80210d <memset+0x91>
			*p8++ = (uint8)c;
  8020ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802102:	8d 50 01             	lea    0x1(%eax),%edx
  802105:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802108:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210b:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80210d:	8b 45 10             	mov    0x10(%ebp),%eax
  802110:	8d 50 ff             	lea    -0x1(%eax),%edx
  802113:	89 55 10             	mov    %edx,0x10(%ebp)
  802116:	85 c0                	test   %eax,%eax
  802118:	75 e5                	jne    8020ff <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  802131:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802135:	76 24                	jbe    80215b <memcpy+0x3c>
		while(n >= 8){
  802137:	eb 1c                	jmp    802155 <memcpy+0x36>
			*d64 = *s64;
  802139:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213c:	8b 50 04             	mov    0x4(%eax),%edx
  80213f:	8b 00                	mov    (%eax),%eax
  802141:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802144:	89 01                	mov    %eax,(%ecx)
  802146:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802149:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80214d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802151:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802155:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802159:	77 de                	ja     802139 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80215b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80215f:	74 31                	je     802192 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802164:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802167:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80216a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80216d:	eb 16                	jmp    802185 <memcpy+0x66>
			*d8++ = *s8++;
  80216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802172:	8d 50 01             	lea    0x1(%eax),%edx
  802175:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802178:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80217e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802181:	8a 12                	mov    (%edx),%dl
  802183:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802185:	8b 45 10             	mov    0x10(%ebp),%eax
  802188:	8d 50 ff             	lea    -0x1(%eax),%edx
  80218b:	89 55 10             	mov    %edx,0x10(%ebp)
  80218e:	85 c0                	test   %eax,%eax
  802190:	75 dd                	jne    80216f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80219d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8021a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021af:	73 50                	jae    802201 <memmove+0x6a>
  8021b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b7:	01 d0                	add    %edx,%eax
  8021b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021bc:	76 43                	jbe    802201 <memmove+0x6a>
		s += n;
  8021be:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8021c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021ca:	eb 10                	jmp    8021dc <memmove+0x45>
			*--d = *--s;
  8021cc:	ff 4d f8             	decl   -0x8(%ebp)
  8021cf:	ff 4d fc             	decl   -0x4(%ebp)
  8021d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d5:	8a 10                	mov    (%eax),%dl
  8021d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021da:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8021dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	75 e3                	jne    8021cc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8021e9:	eb 23                	jmp    80220e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8021eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ee:	8d 50 01             	lea    0x1(%eax),%edx
  8021f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021fa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8021fd:	8a 12                	mov    (%edx),%dl
  8021ff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802201:	8b 45 10             	mov    0x10(%ebp),%eax
  802204:	8d 50 ff             	lea    -0x1(%eax),%edx
  802207:	89 55 10             	mov    %edx,0x10(%ebp)
  80220a:	85 c0                	test   %eax,%eax
  80220c:	75 dd                	jne    8021eb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
  802216:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80221f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802222:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802225:	eb 2a                	jmp    802251 <memcmp+0x3e>
		if (*s1 != *s2)
  802227:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222a:	8a 10                	mov    (%eax),%dl
  80222c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80222f:	8a 00                	mov    (%eax),%al
  802231:	38 c2                	cmp    %al,%dl
  802233:	74 16                	je     80224b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802235:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802238:	8a 00                	mov    (%eax),%al
  80223a:	0f b6 d0             	movzbl %al,%edx
  80223d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802240:	8a 00                	mov    (%eax),%al
  802242:	0f b6 c0             	movzbl %al,%eax
  802245:	29 c2                	sub    %eax,%edx
  802247:	89 d0                	mov    %edx,%eax
  802249:	eb 18                	jmp    802263 <memcmp+0x50>
		s1++, s2++;
  80224b:	ff 45 fc             	incl   -0x4(%ebp)
  80224e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802251:	8b 45 10             	mov    0x10(%ebp),%eax
  802254:	8d 50 ff             	lea    -0x1(%eax),%edx
  802257:	89 55 10             	mov    %edx,0x10(%ebp)
  80225a:	85 c0                	test   %eax,%eax
  80225c:	75 c9                	jne    802227 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80225e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80226b:	8b 55 08             	mov    0x8(%ebp),%edx
  80226e:	8b 45 10             	mov    0x10(%ebp),%eax
  802271:	01 d0                	add    %edx,%eax
  802273:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802276:	eb 15                	jmp    80228d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	8a 00                	mov    (%eax),%al
  80227d:	0f b6 d0             	movzbl %al,%edx
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	0f b6 c0             	movzbl %al,%eax
  802286:	39 c2                	cmp    %eax,%edx
  802288:	74 0d                	je     802297 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80228a:	ff 45 08             	incl   0x8(%ebp)
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802293:	72 e3                	jb     802278 <memfind+0x13>
  802295:	eb 01                	jmp    802298 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802297:	90                   	nop
	return (void *) s;
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8022a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8022aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022b1:	eb 03                	jmp    8022b6 <strtol+0x19>
		s++;
  8022b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8a 00                	mov    (%eax),%al
  8022bb:	3c 20                	cmp    $0x20,%al
  8022bd:	74 f4                	je     8022b3 <strtol+0x16>
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	8a 00                	mov    (%eax),%al
  8022c4:	3c 09                	cmp    $0x9,%al
  8022c6:	74 eb                	je     8022b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8a 00                	mov    (%eax),%al
  8022cd:	3c 2b                	cmp    $0x2b,%al
  8022cf:	75 05                	jne    8022d6 <strtol+0x39>
		s++;
  8022d1:	ff 45 08             	incl   0x8(%ebp)
  8022d4:	eb 13                	jmp    8022e9 <strtol+0x4c>
	else if (*s == '-')
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	8a 00                	mov    (%eax),%al
  8022db:	3c 2d                	cmp    $0x2d,%al
  8022dd:	75 0a                	jne    8022e9 <strtol+0x4c>
		s++, neg = 1;
  8022df:	ff 45 08             	incl   0x8(%ebp)
  8022e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ed:	74 06                	je     8022f5 <strtol+0x58>
  8022ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8022f3:	75 20                	jne    802315 <strtol+0x78>
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	8a 00                	mov    (%eax),%al
  8022fa:	3c 30                	cmp    $0x30,%al
  8022fc:	75 17                	jne    802315 <strtol+0x78>
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	40                   	inc    %eax
  802302:	8a 00                	mov    (%eax),%al
  802304:	3c 78                	cmp    $0x78,%al
  802306:	75 0d                	jne    802315 <strtol+0x78>
		s += 2, base = 16;
  802308:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80230c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802313:	eb 28                	jmp    80233d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802315:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802319:	75 15                	jne    802330 <strtol+0x93>
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8a 00                	mov    (%eax),%al
  802320:	3c 30                	cmp    $0x30,%al
  802322:	75 0c                	jne    802330 <strtol+0x93>
		s++, base = 8;
  802324:	ff 45 08             	incl   0x8(%ebp)
  802327:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80232e:	eb 0d                	jmp    80233d <strtol+0xa0>
	else if (base == 0)
  802330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802334:	75 07                	jne    80233d <strtol+0xa0>
		base = 10;
  802336:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	8a 00                	mov    (%eax),%al
  802342:	3c 2f                	cmp    $0x2f,%al
  802344:	7e 19                	jle    80235f <strtol+0xc2>
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	8a 00                	mov    (%eax),%al
  80234b:	3c 39                	cmp    $0x39,%al
  80234d:	7f 10                	jg     80235f <strtol+0xc2>
			dig = *s - '0';
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8a 00                	mov    (%eax),%al
  802354:	0f be c0             	movsbl %al,%eax
  802357:	83 e8 30             	sub    $0x30,%eax
  80235a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235d:	eb 42                	jmp    8023a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	8a 00                	mov    (%eax),%al
  802364:	3c 60                	cmp    $0x60,%al
  802366:	7e 19                	jle    802381 <strtol+0xe4>
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	8a 00                	mov    (%eax),%al
  80236d:	3c 7a                	cmp    $0x7a,%al
  80236f:	7f 10                	jg     802381 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8a 00                	mov    (%eax),%al
  802376:	0f be c0             	movsbl %al,%eax
  802379:	83 e8 57             	sub    $0x57,%eax
  80237c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237f:	eb 20                	jmp    8023a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	8a 00                	mov    (%eax),%al
  802386:	3c 40                	cmp    $0x40,%al
  802388:	7e 39                	jle    8023c3 <strtol+0x126>
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	8a 00                	mov    (%eax),%al
  80238f:	3c 5a                	cmp    $0x5a,%al
  802391:	7f 30                	jg     8023c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	8a 00                	mov    (%eax),%al
  802398:	0f be c0             	movsbl %al,%eax
  80239b:	83 e8 37             	sub    $0x37,%eax
  80239e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8023a7:	7d 19                	jge    8023c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8023a9:	ff 45 08             	incl   0x8(%ebp)
  8023ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8023b3:	89 c2                	mov    %eax,%edx
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	01 d0                	add    %edx,%eax
  8023ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8023bd:	e9 7b ff ff ff       	jmp    80233d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8023c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8023c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023c7:	74 08                	je     8023d1 <strtol+0x134>
		*endptr = (char *) s;
  8023c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8023d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023d5:	74 07                	je     8023de <strtol+0x141>
  8023d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023da:	f7 d8                	neg    %eax
  8023dc:	eb 03                	jmp    8023e1 <strtol+0x144>
  8023de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8023e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8023f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8023f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023fb:	79 13                	jns    802410 <ltostr+0x2d>
	{
		neg = 1;
  8023fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802404:	8b 45 0c             	mov    0xc(%ebp),%eax
  802407:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80240a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80240d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802418:	99                   	cltd   
  802419:	f7 f9                	idiv   %ecx
  80241b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80241e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802421:	8d 50 01             	lea    0x1(%eax),%edx
  802424:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802427:	89 c2                	mov    %eax,%edx
  802429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242c:	01 d0                	add    %edx,%eax
  80242e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802431:	83 c2 30             	add    $0x30,%edx
  802434:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802436:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802439:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80243e:	f7 e9                	imul   %ecx
  802440:	c1 fa 02             	sar    $0x2,%edx
  802443:	89 c8                	mov    %ecx,%eax
  802445:	c1 f8 1f             	sar    $0x1f,%eax
  802448:	29 c2                	sub    %eax,%edx
  80244a:	89 d0                	mov    %edx,%eax
  80244c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80244f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802453:	75 bb                	jne    802410 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80245c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80245f:	48                   	dec    %eax
  802460:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802463:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802467:	74 3d                	je     8024a6 <ltostr+0xc3>
		start = 1 ;
  802469:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802470:	eb 34                	jmp    8024a6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802472:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802475:	8b 45 0c             	mov    0xc(%ebp),%eax
  802478:	01 d0                	add    %edx,%eax
  80247a:	8a 00                	mov    (%eax),%al
  80247c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80247f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802482:	8b 45 0c             	mov    0xc(%ebp),%eax
  802485:	01 c2                	add    %eax,%edx
  802487:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80248a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248d:	01 c8                	add    %ecx,%eax
  80248f:	8a 00                	mov    (%eax),%al
  802491:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802493:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802496:	8b 45 0c             	mov    0xc(%ebp),%eax
  802499:	01 c2                	add    %eax,%edx
  80249b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80249e:	88 02                	mov    %al,(%edx)
		start++ ;
  8024a0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8024a3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024ac:	7c c4                	jl     802472 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8024ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8024b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b4:	01 d0                	add    %edx,%eax
  8024b6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8024b9:	90                   	nop
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8024c2:	ff 75 08             	pushl  0x8(%ebp)
  8024c5:	e8 c4 f9 ff ff       	call   801e8e <strlen>
  8024ca:	83 c4 04             	add    $0x4,%esp
  8024cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8024d0:	ff 75 0c             	pushl  0xc(%ebp)
  8024d3:	e8 b6 f9 ff ff       	call   801e8e <strlen>
  8024d8:	83 c4 04             	add    $0x4,%esp
  8024db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8024de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8024e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024ec:	eb 17                	jmp    802505 <strcconcat+0x49>
		final[s] = str1[s] ;
  8024ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f4:	01 c2                	add    %eax,%edx
  8024f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	01 c8                	add    %ecx,%eax
  8024fe:	8a 00                	mov    (%eax),%al
  802500:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802502:	ff 45 fc             	incl   -0x4(%ebp)
  802505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802508:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80250b:	7c e1                	jl     8024ee <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80250d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802514:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80251b:	eb 1f                	jmp    80253c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80251d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802520:	8d 50 01             	lea    0x1(%eax),%edx
  802523:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802526:	89 c2                	mov    %eax,%edx
  802528:	8b 45 10             	mov    0x10(%ebp),%eax
  80252b:	01 c2                	add    %eax,%edx
  80252d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802530:	8b 45 0c             	mov    0xc(%ebp),%eax
  802533:	01 c8                	add    %ecx,%eax
  802535:	8a 00                	mov    (%eax),%al
  802537:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802539:	ff 45 f8             	incl   -0x8(%ebp)
  80253c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80253f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802542:	7c d9                	jl     80251d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802544:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802547:	8b 45 10             	mov    0x10(%ebp),%eax
  80254a:	01 d0                	add    %edx,%eax
  80254c:	c6 00 00             	movb   $0x0,(%eax)
}
  80254f:	90                   	nop
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802555:	8b 45 14             	mov    0x14(%ebp),%eax
  802558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80255e:	8b 45 14             	mov    0x14(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80256a:	8b 45 10             	mov    0x10(%ebp),%eax
  80256d:	01 d0                	add    %edx,%eax
  80256f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802575:	eb 0c                	jmp    802583 <strsplit+0x31>
			*string++ = 0;
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	8d 50 01             	lea    0x1(%eax),%edx
  80257d:	89 55 08             	mov    %edx,0x8(%ebp)
  802580:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	8a 00                	mov    (%eax),%al
  802588:	84 c0                	test   %al,%al
  80258a:	74 18                	je     8025a4 <strsplit+0x52>
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	8a 00                	mov    (%eax),%al
  802591:	0f be c0             	movsbl %al,%eax
  802594:	50                   	push   %eax
  802595:	ff 75 0c             	pushl  0xc(%ebp)
  802598:	e8 83 fa ff ff       	call   802020 <strchr>
  80259d:	83 c4 08             	add    $0x8,%esp
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	75 d3                	jne    802577 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	8a 00                	mov    (%eax),%al
  8025a9:	84 c0                	test   %al,%al
  8025ab:	74 5a                	je     802607 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8025ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	83 f8 0f             	cmp    $0xf,%eax
  8025b5:	75 07                	jne    8025be <strsplit+0x6c>
		{
			return 0;
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bc:	eb 66                	jmp    802624 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8025be:	8b 45 14             	mov    0x14(%ebp),%eax
  8025c1:	8b 00                	mov    (%eax),%eax
  8025c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8025c6:	8b 55 14             	mov    0x14(%ebp),%edx
  8025c9:	89 0a                	mov    %ecx,(%edx)
  8025cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d5:	01 c2                	add    %eax,%edx
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025dc:	eb 03                	jmp    8025e1 <strsplit+0x8f>
			string++;
  8025de:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	8a 00                	mov    (%eax),%al
  8025e6:	84 c0                	test   %al,%al
  8025e8:	74 8b                	je     802575 <strsplit+0x23>
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	8a 00                	mov    (%eax),%al
  8025ef:	0f be c0             	movsbl %al,%eax
  8025f2:	50                   	push   %eax
  8025f3:	ff 75 0c             	pushl  0xc(%ebp)
  8025f6:	e8 25 fa ff ff       	call   802020 <strchr>
  8025fb:	83 c4 08             	add    $0x8,%esp
  8025fe:	85 c0                	test   %eax,%eax
  802600:	74 dc                	je     8025de <strsplit+0x8c>
			string++;
	}
  802602:	e9 6e ff ff ff       	jmp    802575 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802607:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802608:	8b 45 14             	mov    0x14(%ebp),%eax
  80260b:	8b 00                	mov    (%eax),%eax
  80260d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802614:	8b 45 10             	mov    0x10(%ebp),%eax
  802617:	01 d0                	add    %edx,%eax
  802619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80261f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80262c:	8b 45 08             	mov    0x8(%ebp),%eax
  80262f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802632:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802639:	eb 4a                	jmp    802685 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80263b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	01 c2                	add    %eax,%edx
  802643:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802646:	8b 45 0c             	mov    0xc(%ebp),%eax
  802649:	01 c8                	add    %ecx,%eax
  80264b:	8a 00                	mov    (%eax),%al
  80264d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80264f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802652:	8b 45 0c             	mov    0xc(%ebp),%eax
  802655:	01 d0                	add    %edx,%eax
  802657:	8a 00                	mov    (%eax),%al
  802659:	3c 40                	cmp    $0x40,%al
  80265b:	7e 25                	jle    802682 <str2lower+0x5c>
  80265d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802660:	8b 45 0c             	mov    0xc(%ebp),%eax
  802663:	01 d0                	add    %edx,%eax
  802665:	8a 00                	mov    (%eax),%al
  802667:	3c 5a                	cmp    $0x5a,%al
  802669:	7f 17                	jg     802682 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80266b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	01 d0                	add    %edx,%eax
  802673:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802676:	8b 55 08             	mov    0x8(%ebp),%edx
  802679:	01 ca                	add    %ecx,%edx
  80267b:	8a 12                	mov    (%edx),%dl
  80267d:	83 c2 20             	add    $0x20,%edx
  802680:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802682:	ff 45 fc             	incl   -0x4(%ebp)
  802685:	ff 75 0c             	pushl  0xc(%ebp)
  802688:	e8 01 f8 ff ff       	call   801e8e <strlen>
  80268d:	83 c4 04             	add    $0x4,%esp
  802690:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802693:	7f a6                	jg     80263b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802695:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
  80269d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8026a0:	a1 08 50 80 00       	mov    0x805008,%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 42                	je     8026eb <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8026a9:	83 ec 08             	sub    $0x8,%esp
  8026ac:	68 00 00 00 82       	push   $0x82000000
  8026b1:	68 00 00 00 80       	push   $0x80000000
  8026b6:	e8 00 08 00 00       	call   802ebb <initialize_dynamic_allocator>
  8026bb:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8026be:	e8 e7 05 00 00       	call   802caa <sys_get_uheap_strategy>
  8026c3:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8026c8:	a1 20 52 80 00       	mov    0x805220,%eax
  8026cd:	05 00 10 00 00       	add    $0x1000,%eax
  8026d2:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8026d7:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  8026dc:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  8026e1:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8026e8:	00 00 00 
	}
}
  8026eb:	90                   	nop
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8026f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802702:	83 ec 08             	sub    $0x8,%esp
  802705:	68 06 04 00 00       	push   $0x406
  80270a:	50                   	push   %eax
  80270b:	e8 e4 01 00 00       	call   8028f4 <__sys_allocate_page>
  802710:	83 c4 10             	add    $0x10,%esp
  802713:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80271a:	79 14                	jns    802730 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80271c:	83 ec 04             	sub    $0x4,%esp
  80271f:	68 48 47 80 00       	push   $0x804748
  802724:	6a 1f                	push   $0x1f
  802726:	68 84 47 80 00       	push   $0x804784
  80272b:	e8 b7 ed ff ff       	call   8014e7 <_panic>
	return 0;
  802730:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802735:	c9                   	leave  
  802736:	c3                   	ret    

00802737 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802737:	55                   	push   %ebp
  802738:	89 e5                	mov    %esp,%ebp
  80273a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80274b:	83 ec 0c             	sub    $0xc,%esp
  80274e:	50                   	push   %eax
  80274f:	e8 e7 01 00 00       	call   80293b <__sys_unmap_frame>
  802754:	83 c4 10             	add    $0x10,%esp
  802757:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80275a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275e:	79 14                	jns    802774 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802760:	83 ec 04             	sub    $0x4,%esp
  802763:	68 90 47 80 00       	push   $0x804790
  802768:	6a 2a                	push   $0x2a
  80276a:	68 84 47 80 00       	push   $0x804784
  80276f:	e8 73 ed ff ff       	call   8014e7 <_panic>
}
  802774:	90                   	nop
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80277d:	e8 18 ff ff ff       	call   80269a <uheap_init>
	if (size == 0) return NULL ;
  802782:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802786:	75 07                	jne    80278f <malloc+0x18>
  802788:	b8 00 00 00 00       	mov    $0x0,%eax
  80278d:	eb 14                	jmp    8027a3 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80278f:	83 ec 04             	sub    $0x4,%esp
  802792:	68 d0 47 80 00       	push   $0x8047d0
  802797:	6a 3e                	push   $0x3e
  802799:	68 84 47 80 00       	push   $0x804784
  80279e:	e8 44 ed ff ff       	call   8014e7 <_panic>
}
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8027ab:	83 ec 04             	sub    $0x4,%esp
  8027ae:	68 f8 47 80 00       	push   $0x8047f8
  8027b3:	6a 49                	push   $0x49
  8027b5:	68 84 47 80 00       	push   $0x804784
  8027ba:	e8 28 ed ff ff       	call   8014e7 <_panic>

008027bf <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
  8027c2:	83 ec 18             	sub    $0x18,%esp
  8027c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c8:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027cb:	e8 ca fe ff ff       	call   80269a <uheap_init>
	if (size == 0) return NULL ;
  8027d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027d4:	75 07                	jne    8027dd <smalloc+0x1e>
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027db:	eb 14                	jmp    8027f1 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8027dd:	83 ec 04             	sub    $0x4,%esp
  8027e0:	68 1c 48 80 00       	push   $0x80481c
  8027e5:	6a 5a                	push   $0x5a
  8027e7:	68 84 47 80 00       	push   $0x804784
  8027ec:	e8 f6 ec ff ff       	call   8014e7 <_panic>
}
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027f9:	e8 9c fe ff ff       	call   80269a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 44 48 80 00       	push   $0x804844
  802806:	6a 6a                	push   $0x6a
  802808:	68 84 47 80 00       	push   $0x804784
  80280d:	e8 d5 ec ff ff       	call   8014e7 <_panic>

00802812 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802812:	55                   	push   %ebp
  802813:	89 e5                	mov    %esp,%ebp
  802815:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802818:	e8 7d fe ff ff       	call   80269a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80281d:	83 ec 04             	sub    $0x4,%esp
  802820:	68 68 48 80 00       	push   $0x804868
  802825:	68 88 00 00 00       	push   $0x88
  80282a:	68 84 47 80 00       	push   $0x804784
  80282f:	e8 b3 ec ff ff       	call   8014e7 <_panic>

00802834 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80283a:	83 ec 04             	sub    $0x4,%esp
  80283d:	68 90 48 80 00       	push   $0x804890
  802842:	68 9b 00 00 00       	push   $0x9b
  802847:	68 84 47 80 00       	push   $0x804784
  80284c:	e8 96 ec ff ff       	call   8014e7 <_panic>

00802851 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	57                   	push   %edi
  802855:	56                   	push   %esi
  802856:	53                   	push   %ebx
  802857:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802860:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802863:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802866:	8b 7d 18             	mov    0x18(%ebp),%edi
  802869:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80286c:	cd 30                	int    $0x30
  80286e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802874:	83 c4 10             	add    $0x10,%esp
  802877:	5b                   	pop    %ebx
  802878:	5e                   	pop    %esi
  802879:	5f                   	pop    %edi
  80287a:	5d                   	pop    %ebp
  80287b:	c3                   	ret    

0080287c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	8b 45 10             	mov    0x10(%ebp),%eax
  802885:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802888:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80288b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	6a 00                	push   $0x0
  802894:	51                   	push   %ecx
  802895:	52                   	push   %edx
  802896:	ff 75 0c             	pushl  0xc(%ebp)
  802899:	50                   	push   %eax
  80289a:	6a 00                	push   $0x0
  80289c:	e8 b0 ff ff ff       	call   802851 <syscall>
  8028a1:	83 c4 18             	add    $0x18,%esp
}
  8028a4:	90                   	nop
  8028a5:	c9                   	leave  
  8028a6:	c3                   	ret    

008028a7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8028a7:	55                   	push   %ebp
  8028a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 02                	push   $0x2
  8028b6:	e8 96 ff ff ff       	call   802851 <syscall>
  8028bb:	83 c4 18             	add    $0x18,%esp
}
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 03                	push   $0x3
  8028cf:	e8 7d ff ff ff       	call   802851 <syscall>
  8028d4:	83 c4 18             	add    $0x18,%esp
}
  8028d7:	90                   	nop
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 04                	push   $0x4
  8028e9:	e8 63 ff ff ff       	call   802851 <syscall>
  8028ee:	83 c4 18             	add    $0x18,%esp
}
  8028f1:	90                   	nop
  8028f2:	c9                   	leave  
  8028f3:	c3                   	ret    

008028f4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8028f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	6a 00                	push   $0x0
  802903:	52                   	push   %edx
  802904:	50                   	push   %eax
  802905:	6a 08                	push   $0x8
  802907:	e8 45 ff ff ff       	call   802851 <syscall>
  80290c:	83 c4 18             	add    $0x18,%esp
}
  80290f:	c9                   	leave  
  802910:	c3                   	ret    

00802911 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802911:	55                   	push   %ebp
  802912:	89 e5                	mov    %esp,%ebp
  802914:	56                   	push   %esi
  802915:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802916:	8b 75 18             	mov    0x18(%ebp),%esi
  802919:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80291c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80291f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	56                   	push   %esi
  802926:	53                   	push   %ebx
  802927:	51                   	push   %ecx
  802928:	52                   	push   %edx
  802929:	50                   	push   %eax
  80292a:	6a 09                	push   $0x9
  80292c:	e8 20 ff ff ff       	call   802851 <syscall>
  802931:	83 c4 18             	add    $0x18,%esp
}
  802934:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802937:	5b                   	pop    %ebx
  802938:	5e                   	pop    %esi
  802939:	5d                   	pop    %ebp
  80293a:	c3                   	ret    

0080293b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	ff 75 08             	pushl  0x8(%ebp)
  802949:	6a 0a                	push   $0xa
  80294b:	e8 01 ff ff ff       	call   802851 <syscall>
  802950:	83 c4 18             	add    $0x18,%esp
}
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	ff 75 0c             	pushl  0xc(%ebp)
  802961:	ff 75 08             	pushl  0x8(%ebp)
  802964:	6a 0b                	push   $0xb
  802966:	e8 e6 fe ff ff       	call   802851 <syscall>
  80296b:	83 c4 18             	add    $0x18,%esp
}
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	6a 00                	push   $0x0
  80297d:	6a 0c                	push   $0xc
  80297f:	e8 cd fe ff ff       	call   802851 <syscall>
  802984:	83 c4 18             	add    $0x18,%esp
}
  802987:	c9                   	leave  
  802988:	c3                   	ret    

00802989 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	6a 00                	push   $0x0
  802996:	6a 0d                	push   $0xd
  802998:	e8 b4 fe ff ff       	call   802851 <syscall>
  80299d:	83 c4 18             	add    $0x18,%esp
}
  8029a0:	c9                   	leave  
  8029a1:	c3                   	ret    

008029a2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8029a2:	55                   	push   %ebp
  8029a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	6a 0e                	push   $0xe
  8029b1:	e8 9b fe ff ff       	call   802851 <syscall>
  8029b6:	83 c4 18             	add    $0x18,%esp
}
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 0f                	push   $0xf
  8029ca:	e8 82 fe ff ff       	call   802851 <syscall>
  8029cf:	83 c4 18             	add    $0x18,%esp
}
  8029d2:	c9                   	leave  
  8029d3:	c3                   	ret    

008029d4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8029d4:	55                   	push   %ebp
  8029d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029d7:	6a 00                	push   $0x0
  8029d9:	6a 00                	push   $0x0
  8029db:	6a 00                	push   $0x0
  8029dd:	6a 00                	push   $0x0
  8029df:	ff 75 08             	pushl  0x8(%ebp)
  8029e2:	6a 10                	push   $0x10
  8029e4:	e8 68 fe ff ff       	call   802851 <syscall>
  8029e9:	83 c4 18             	add    $0x18,%esp
}
  8029ec:	c9                   	leave  
  8029ed:	c3                   	ret    

008029ee <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029ee:	55                   	push   %ebp
  8029ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 11                	push   $0x11
  8029fd:	e8 4f fe ff ff       	call   802851 <syscall>
  802a02:	83 c4 18             	add    $0x18,%esp
}
  802a05:	90                   	nop
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <sys_cputc>:

void
sys_cputc(const char c)
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a14:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	50                   	push   %eax
  802a21:	6a 01                	push   $0x1
  802a23:	e8 29 fe ff ff       	call   802851 <syscall>
  802a28:	83 c4 18             	add    $0x18,%esp
}
  802a2b:	90                   	nop
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 14                	push   $0x14
  802a3d:	e8 0f fe ff ff       	call   802851 <syscall>
  802a42:	83 c4 18             	add    $0x18,%esp
}
  802a45:	90                   	nop
  802a46:	c9                   	leave  
  802a47:	c3                   	ret    

00802a48 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
  802a4b:	83 ec 04             	sub    $0x4,%esp
  802a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  802a51:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a54:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a57:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	6a 00                	push   $0x0
  802a60:	51                   	push   %ecx
  802a61:	52                   	push   %edx
  802a62:	ff 75 0c             	pushl  0xc(%ebp)
  802a65:	50                   	push   %eax
  802a66:	6a 15                	push   $0x15
  802a68:	e8 e4 fd ff ff       	call   802851 <syscall>
  802a6d:	83 c4 18             	add    $0x18,%esp
}
  802a70:	c9                   	leave  
  802a71:	c3                   	ret    

00802a72 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802a72:	55                   	push   %ebp
  802a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	52                   	push   %edx
  802a82:	50                   	push   %eax
  802a83:	6a 16                	push   $0x16
  802a85:	e8 c7 fd ff ff       	call   802851 <syscall>
  802a8a:	83 c4 18             	add    $0x18,%esp
}
  802a8d:	c9                   	leave  
  802a8e:	c3                   	ret    

00802a8f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802a8f:	55                   	push   %ebp
  802a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	51                   	push   %ecx
  802aa0:	52                   	push   %edx
  802aa1:	50                   	push   %eax
  802aa2:	6a 17                	push   $0x17
  802aa4:	e8 a8 fd ff ff       	call   802851 <syscall>
  802aa9:	83 c4 18             	add    $0x18,%esp
}
  802aac:	c9                   	leave  
  802aad:	c3                   	ret    

00802aae <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	52                   	push   %edx
  802abe:	50                   	push   %eax
  802abf:	6a 18                	push   $0x18
  802ac1:	e8 8b fd ff ff       	call   802851 <syscall>
  802ac6:	83 c4 18             	add    $0x18,%esp
}
  802ac9:	c9                   	leave  
  802aca:	c3                   	ret    

00802acb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	6a 00                	push   $0x0
  802ad3:	ff 75 14             	pushl  0x14(%ebp)
  802ad6:	ff 75 10             	pushl  0x10(%ebp)
  802ad9:	ff 75 0c             	pushl  0xc(%ebp)
  802adc:	50                   	push   %eax
  802add:	6a 19                	push   $0x19
  802adf:	e8 6d fd ff ff       	call   802851 <syscall>
  802ae4:	83 c4 18             	add    $0x18,%esp
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	6a 00                	push   $0x0
  802af1:	6a 00                	push   $0x0
  802af3:	6a 00                	push   $0x0
  802af5:	6a 00                	push   $0x0
  802af7:	50                   	push   %eax
  802af8:	6a 1a                	push   $0x1a
  802afa:	e8 52 fd ff ff       	call   802851 <syscall>
  802aff:	83 c4 18             	add    $0x18,%esp
}
  802b02:	90                   	nop
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	6a 00                	push   $0x0
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 00                	push   $0x0
  802b13:	50                   	push   %eax
  802b14:	6a 1b                	push   $0x1b
  802b16:	e8 36 fd ff ff       	call   802851 <syscall>
  802b1b:	83 c4 18             	add    $0x18,%esp
}
  802b1e:	c9                   	leave  
  802b1f:	c3                   	ret    

00802b20 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802b20:	55                   	push   %ebp
  802b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802b23:	6a 00                	push   $0x0
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 05                	push   $0x5
  802b2f:	e8 1d fd ff ff       	call   802851 <syscall>
  802b34:	83 c4 18             	add    $0x18,%esp
}
  802b37:	c9                   	leave  
  802b38:	c3                   	ret    

00802b39 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b39:	55                   	push   %ebp
  802b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	6a 00                	push   $0x0
  802b44:	6a 00                	push   $0x0
  802b46:	6a 06                	push   $0x6
  802b48:	e8 04 fd ff ff       	call   802851 <syscall>
  802b4d:	83 c4 18             	add    $0x18,%esp
}
  802b50:	c9                   	leave  
  802b51:	c3                   	ret    

00802b52 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b52:	55                   	push   %ebp
  802b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 07                	push   $0x7
  802b61:	e8 eb fc ff ff       	call   802851 <syscall>
  802b66:	83 c4 18             	add    $0x18,%esp
}
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <sys_exit_env>:


void sys_exit_env(void)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	6a 1c                	push   $0x1c
  802b7a:	e8 d2 fc ff ff       	call   802851 <syscall>
  802b7f:	83 c4 18             	add    $0x18,%esp
}
  802b82:	90                   	nop
  802b83:	c9                   	leave  
  802b84:	c3                   	ret    

00802b85 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802b85:	55                   	push   %ebp
  802b86:	89 e5                	mov    %esp,%ebp
  802b88:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b8b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b8e:	8d 50 04             	lea    0x4(%eax),%edx
  802b91:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	52                   	push   %edx
  802b9b:	50                   	push   %eax
  802b9c:	6a 1d                	push   $0x1d
  802b9e:	e8 ae fc ff ff       	call   802851 <syscall>
  802ba3:	83 c4 18             	add    $0x18,%esp
	return result;
  802ba6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802bac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802baf:	89 01                	mov    %eax,(%ecx)
  802bb1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	c9                   	leave  
  802bb8:	c2 04 00             	ret    $0x4

00802bbb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802bbb:	55                   	push   %ebp
  802bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802bbe:	6a 00                	push   $0x0
  802bc0:	6a 00                	push   $0x0
  802bc2:	ff 75 10             	pushl  0x10(%ebp)
  802bc5:	ff 75 0c             	pushl  0xc(%ebp)
  802bc8:	ff 75 08             	pushl  0x8(%ebp)
  802bcb:	6a 13                	push   $0x13
  802bcd:	e8 7f fc ff ff       	call   802851 <syscall>
  802bd2:	83 c4 18             	add    $0x18,%esp
	return ;
  802bd5:	90                   	nop
}
  802bd6:	c9                   	leave  
  802bd7:	c3                   	ret    

00802bd8 <sys_rcr2>:
uint32 sys_rcr2()
{
  802bd8:	55                   	push   %ebp
  802bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802bdb:	6a 00                	push   $0x0
  802bdd:	6a 00                	push   $0x0
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	6a 1e                	push   $0x1e
  802be7:	e8 65 fc ff ff       	call   802851 <syscall>
  802bec:	83 c4 18             	add    $0x18,%esp
}
  802bef:	c9                   	leave  
  802bf0:	c3                   	ret    

00802bf1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802bf1:	55                   	push   %ebp
  802bf2:	89 e5                	mov    %esp,%ebp
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802bfd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	6a 00                	push   $0x0
  802c09:	50                   	push   %eax
  802c0a:	6a 1f                	push   $0x1f
  802c0c:	e8 40 fc ff ff       	call   802851 <syscall>
  802c11:	83 c4 18             	add    $0x18,%esp
	return ;
  802c14:	90                   	nop
}
  802c15:	c9                   	leave  
  802c16:	c3                   	ret    

00802c17 <rsttst>:
void rsttst()
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 00                	push   $0x0
  802c24:	6a 21                	push   $0x21
  802c26:	e8 26 fc ff ff       	call   802851 <syscall>
  802c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c2e:	90                   	nop
}
  802c2f:	c9                   	leave  
  802c30:	c3                   	ret    

00802c31 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c31:	55                   	push   %ebp
  802c32:	89 e5                	mov    %esp,%ebp
  802c34:	83 ec 04             	sub    $0x4,%esp
  802c37:	8b 45 14             	mov    0x14(%ebp),%eax
  802c3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c3d:	8b 55 18             	mov    0x18(%ebp),%edx
  802c40:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c44:	52                   	push   %edx
  802c45:	50                   	push   %eax
  802c46:	ff 75 10             	pushl  0x10(%ebp)
  802c49:	ff 75 0c             	pushl  0xc(%ebp)
  802c4c:	ff 75 08             	pushl  0x8(%ebp)
  802c4f:	6a 20                	push   $0x20
  802c51:	e8 fb fb ff ff       	call   802851 <syscall>
  802c56:	83 c4 18             	add    $0x18,%esp
	return ;
  802c59:	90                   	nop
}
  802c5a:	c9                   	leave  
  802c5b:	c3                   	ret    

00802c5c <chktst>:
void chktst(uint32 n)
{
  802c5c:	55                   	push   %ebp
  802c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c5f:	6a 00                	push   $0x0
  802c61:	6a 00                	push   $0x0
  802c63:	6a 00                	push   $0x0
  802c65:	6a 00                	push   $0x0
  802c67:	ff 75 08             	pushl  0x8(%ebp)
  802c6a:	6a 22                	push   $0x22
  802c6c:	e8 e0 fb ff ff       	call   802851 <syscall>
  802c71:	83 c4 18             	add    $0x18,%esp
	return ;
  802c74:	90                   	nop
}
  802c75:	c9                   	leave  
  802c76:	c3                   	ret    

00802c77 <inctst>:

void inctst()
{
  802c77:	55                   	push   %ebp
  802c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 23                	push   $0x23
  802c86:	e8 c6 fb ff ff       	call   802851 <syscall>
  802c8b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c8e:	90                   	nop
}
  802c8f:	c9                   	leave  
  802c90:	c3                   	ret    

00802c91 <gettst>:
uint32 gettst()
{
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c94:	6a 00                	push   $0x0
  802c96:	6a 00                	push   $0x0
  802c98:	6a 00                	push   $0x0
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 24                	push   $0x24
  802ca0:	e8 ac fb ff ff       	call   802851 <syscall>
  802ca5:	83 c4 18             	add    $0x18,%esp
}
  802ca8:	c9                   	leave  
  802ca9:	c3                   	ret    

00802caa <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802caa:	55                   	push   %ebp
  802cab:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 00                	push   $0x0
  802cb7:	6a 25                	push   $0x25
  802cb9:	e8 93 fb ff ff       	call   802851 <syscall>
  802cbe:	83 c4 18             	add    $0x18,%esp
  802cc1:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802cc6:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802ccb:	c9                   	leave  
  802ccc:	c3                   	ret    

00802ccd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ccd:	55                   	push   %ebp
  802cce:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 00                	push   $0x0
  802cde:	6a 00                	push   $0x0
  802ce0:	ff 75 08             	pushl  0x8(%ebp)
  802ce3:	6a 26                	push   $0x26
  802ce5:	e8 67 fb ff ff       	call   802851 <syscall>
  802cea:	83 c4 18             	add    $0x18,%esp
	return ;
  802ced:	90                   	nop
}
  802cee:	c9                   	leave  
  802cef:	c3                   	ret    

00802cf0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802cf0:	55                   	push   %ebp
  802cf1:	89 e5                	mov    %esp,%ebp
  802cf3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802cf4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	6a 00                	push   $0x0
  802d02:	53                   	push   %ebx
  802d03:	51                   	push   %ecx
  802d04:	52                   	push   %edx
  802d05:	50                   	push   %eax
  802d06:	6a 27                	push   $0x27
  802d08:	e8 44 fb ff ff       	call   802851 <syscall>
  802d0d:	83 c4 18             	add    $0x18,%esp
}
  802d10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d13:	c9                   	leave  
  802d14:	c3                   	ret    

00802d15 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802d15:	55                   	push   %ebp
  802d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	6a 00                	push   $0x0
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	52                   	push   %edx
  802d25:	50                   	push   %eax
  802d26:	6a 28                	push   $0x28
  802d28:	e8 24 fb ff ff       	call   802851 <syscall>
  802d2d:	83 c4 18             	add    $0x18,%esp
}
  802d30:	c9                   	leave  
  802d31:	c3                   	ret    

00802d32 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802d32:	55                   	push   %ebp
  802d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802d35:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	6a 00                	push   $0x0
  802d40:	51                   	push   %ecx
  802d41:	ff 75 10             	pushl  0x10(%ebp)
  802d44:	52                   	push   %edx
  802d45:	50                   	push   %eax
  802d46:	6a 29                	push   $0x29
  802d48:	e8 04 fb ff ff       	call   802851 <syscall>
  802d4d:	83 c4 18             	add    $0x18,%esp
}
  802d50:	c9                   	leave  
  802d51:	c3                   	ret    

00802d52 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d52:	55                   	push   %ebp
  802d53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d55:	6a 00                	push   $0x0
  802d57:	6a 00                	push   $0x0
  802d59:	ff 75 10             	pushl  0x10(%ebp)
  802d5c:	ff 75 0c             	pushl  0xc(%ebp)
  802d5f:	ff 75 08             	pushl  0x8(%ebp)
  802d62:	6a 12                	push   $0x12
  802d64:	e8 e8 fa ff ff       	call   802851 <syscall>
  802d69:	83 c4 18             	add    $0x18,%esp
	return ;
  802d6c:	90                   	nop
}
  802d6d:	c9                   	leave  
  802d6e:	c3                   	ret    

00802d6f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802d6f:	55                   	push   %ebp
  802d70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	52                   	push   %edx
  802d7f:	50                   	push   %eax
  802d80:	6a 2a                	push   $0x2a
  802d82:	e8 ca fa ff ff       	call   802851 <syscall>
  802d87:	83 c4 18             	add    $0x18,%esp
	return;
  802d8a:	90                   	nop
}
  802d8b:	c9                   	leave  
  802d8c:	c3                   	ret    

00802d8d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802d8d:	55                   	push   %ebp
  802d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	6a 00                	push   $0x0
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 2b                	push   $0x2b
  802d9c:	e8 b0 fa ff ff       	call   802851 <syscall>
  802da1:	83 c4 18             	add    $0x18,%esp
}
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802da9:	6a 00                	push   $0x0
  802dab:	6a 00                	push   $0x0
  802dad:	6a 00                	push   $0x0
  802daf:	ff 75 0c             	pushl  0xc(%ebp)
  802db2:	ff 75 08             	pushl  0x8(%ebp)
  802db5:	6a 2d                	push   $0x2d
  802db7:	e8 95 fa ff ff       	call   802851 <syscall>
  802dbc:	83 c4 18             	add    $0x18,%esp
	return;
  802dbf:	90                   	nop
}
  802dc0:	c9                   	leave  
  802dc1:	c3                   	ret    

00802dc2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802dc5:	6a 00                	push   $0x0
  802dc7:	6a 00                	push   $0x0
  802dc9:	6a 00                	push   $0x0
  802dcb:	ff 75 0c             	pushl  0xc(%ebp)
  802dce:	ff 75 08             	pushl  0x8(%ebp)
  802dd1:	6a 2c                	push   $0x2c
  802dd3:	e8 79 fa ff ff       	call   802851 <syscall>
  802dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  802ddb:	90                   	nop
}
  802ddc:	c9                   	leave  
  802ddd:	c3                   	ret    

00802dde <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802dde:	55                   	push   %ebp
  802ddf:	89 e5                	mov    %esp,%ebp
  802de1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802de4:	83 ec 04             	sub    $0x4,%esp
  802de7:	68 b4 48 80 00       	push   $0x8048b4
  802dec:	68 25 01 00 00       	push   $0x125
  802df1:	68 e7 48 80 00       	push   $0x8048e7
  802df6:	e8 ec e6 ff ff       	call   8014e7 <_panic>

00802dfb <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802dfb:	55                   	push   %ebp
  802dfc:	89 e5                	mov    %esp,%ebp
  802dfe:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802e01:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802e08:	72 09                	jb     802e13 <to_page_va+0x18>
  802e0a:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802e11:	72 14                	jb     802e27 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	68 f8 48 80 00       	push   $0x8048f8
  802e1b:	6a 15                	push   $0x15
  802e1d:	68 23 49 80 00       	push   $0x804923
  802e22:	e8 c0 e6 ff ff       	call   8014e7 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	ba 40 52 80 00       	mov    $0x805240,%edx
  802e2f:	29 d0                	sub    %edx,%eax
  802e31:	c1 f8 02             	sar    $0x2,%eax
  802e34:	89 c2                	mov    %eax,%edx
  802e36:	89 d0                	mov    %edx,%eax
  802e38:	c1 e0 02             	shl    $0x2,%eax
  802e3b:	01 d0                	add    %edx,%eax
  802e3d:	c1 e0 02             	shl    $0x2,%eax
  802e40:	01 d0                	add    %edx,%eax
  802e42:	c1 e0 02             	shl    $0x2,%eax
  802e45:	01 d0                	add    %edx,%eax
  802e47:	89 c1                	mov    %eax,%ecx
  802e49:	c1 e1 08             	shl    $0x8,%ecx
  802e4c:	01 c8                	add    %ecx,%eax
  802e4e:	89 c1                	mov    %eax,%ecx
  802e50:	c1 e1 10             	shl    $0x10,%ecx
  802e53:	01 c8                	add    %ecx,%eax
  802e55:	01 c0                	add    %eax,%eax
  802e57:	01 d0                	add    %edx,%eax
  802e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	c1 e0 0c             	shl    $0xc,%eax
  802e62:	89 c2                	mov    %eax,%edx
  802e64:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802e69:	01 d0                	add    %edx,%eax
}
  802e6b:	c9                   	leave  
  802e6c:	c3                   	ret    

00802e6d <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802e6d:	55                   	push   %ebp
  802e6e:	89 e5                	mov    %esp,%ebp
  802e70:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802e73:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802e78:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7b:	29 c2                	sub    %eax,%edx
  802e7d:	89 d0                	mov    %edx,%eax
  802e7f:	c1 e8 0c             	shr    $0xc,%eax
  802e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802e85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e89:	78 09                	js     802e94 <to_page_info+0x27>
  802e8b:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802e92:	7e 14                	jle    802ea8 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802e94:	83 ec 04             	sub    $0x4,%esp
  802e97:	68 3c 49 80 00       	push   $0x80493c
  802e9c:	6a 22                	push   $0x22
  802e9e:	68 23 49 80 00       	push   $0x804923
  802ea3:	e8 3f e6 ff ff       	call   8014e7 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eab:	89 d0                	mov    %edx,%eax
  802ead:	01 c0                	add    %eax,%eax
  802eaf:	01 d0                	add    %edx,%eax
  802eb1:	c1 e0 02             	shl    $0x2,%eax
  802eb4:	05 40 52 80 00       	add    $0x805240,%eax
}
  802eb9:	c9                   	leave  
  802eba:	c3                   	ret    

00802ebb <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802ebb:	55                   	push   %ebp
  802ebc:	89 e5                	mov    %esp,%ebp
  802ebe:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	05 00 00 00 02       	add    $0x2000000,%eax
  802ec9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ecc:	73 16                	jae    802ee4 <initialize_dynamic_allocator+0x29>
  802ece:	68 60 49 80 00       	push   $0x804960
  802ed3:	68 86 49 80 00       	push   $0x804986
  802ed8:	6a 34                	push   $0x34
  802eda:	68 23 49 80 00       	push   $0x804923
  802edf:	e8 03 e6 ff ff       	call   8014e7 <_panic>
		is_initialized = 1;
  802ee4:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802eeb:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef9:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802efe:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802f05:	00 00 00 
  802f08:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802f0f:	00 00 00 
  802f12:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  802f19:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1f:	2b 45 08             	sub    0x8(%ebp),%eax
  802f22:	c1 e8 0c             	shr    $0xc,%eax
  802f25:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802f28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f2f:	e9 c8 00 00 00       	jmp    802ffc <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f37:	89 d0                	mov    %edx,%eax
  802f39:	01 c0                	add    %eax,%eax
  802f3b:	01 d0                	add    %edx,%eax
  802f3d:	c1 e0 02             	shl    $0x2,%eax
  802f40:	05 48 52 80 00       	add    $0x805248,%eax
  802f45:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4d:	89 d0                	mov    %edx,%eax
  802f4f:	01 c0                	add    %eax,%eax
  802f51:	01 d0                	add    %edx,%eax
  802f53:	c1 e0 02             	shl    $0x2,%eax
  802f56:	05 4a 52 80 00       	add    $0x80524a,%eax
  802f5b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802f60:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802f66:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802f69:	89 c8                	mov    %ecx,%eax
  802f6b:	01 c0                	add    %eax,%eax
  802f6d:	01 c8                	add    %ecx,%eax
  802f6f:	c1 e0 02             	shl    $0x2,%eax
  802f72:	05 44 52 80 00       	add    $0x805244,%eax
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f7c:	89 d0                	mov    %edx,%eax
  802f7e:	01 c0                	add    %eax,%eax
  802f80:	01 d0                	add    %edx,%eax
  802f82:	c1 e0 02             	shl    $0x2,%eax
  802f85:	05 44 52 80 00       	add    $0x805244,%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	74 1b                	je     802fab <initialize_dynamic_allocator+0xf0>
  802f90:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802f96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802f99:	89 c8                	mov    %ecx,%eax
  802f9b:	01 c0                	add    %eax,%eax
  802f9d:	01 c8                	add    %ecx,%eax
  802f9f:	c1 e0 02             	shl    $0x2,%eax
  802fa2:	05 40 52 80 00       	add    $0x805240,%eax
  802fa7:	89 02                	mov    %eax,(%edx)
  802fa9:	eb 16                	jmp    802fc1 <initialize_dynamic_allocator+0x106>
  802fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fae:	89 d0                	mov    %edx,%eax
  802fb0:	01 c0                	add    %eax,%eax
  802fb2:	01 d0                	add    %edx,%eax
  802fb4:	c1 e0 02             	shl    $0x2,%eax
  802fb7:	05 40 52 80 00       	add    $0x805240,%eax
  802fbc:	a3 28 52 80 00       	mov    %eax,0x805228
  802fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc4:	89 d0                	mov    %edx,%eax
  802fc6:	01 c0                	add    %eax,%eax
  802fc8:	01 d0                	add    %edx,%eax
  802fca:	c1 e0 02             	shl    $0x2,%eax
  802fcd:	05 40 52 80 00       	add    $0x805240,%eax
  802fd2:	a3 2c 52 80 00       	mov    %eax,0x80522c
  802fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fda:	89 d0                	mov    %edx,%eax
  802fdc:	01 c0                	add    %eax,%eax
  802fde:	01 d0                	add    %edx,%eax
  802fe0:	c1 e0 02             	shl    $0x2,%eax
  802fe3:	05 40 52 80 00       	add    $0x805240,%eax
  802fe8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fee:	a1 34 52 80 00       	mov    0x805234,%eax
  802ff3:	40                   	inc    %eax
  802ff4:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802ff9:	ff 45 f4             	incl   -0xc(%ebp)
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803002:	0f 8c 2c ff ff ff    	jl     802f34 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803008:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80300f:	eb 36                	jmp    803047 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  803011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803014:	c1 e0 04             	shl    $0x4,%eax
  803017:	05 60 d2 81 00       	add    $0x81d260,%eax
  80301c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803025:	c1 e0 04             	shl    $0x4,%eax
  803028:	05 64 d2 81 00       	add    $0x81d264,%eax
  80302d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	c1 e0 04             	shl    $0x4,%eax
  803039:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80303e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803044:	ff 45 f0             	incl   -0x10(%ebp)
  803047:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80304b:	7e c4                	jle    803011 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80304d:	90                   	nop
  80304e:	c9                   	leave  
  80304f:	c3                   	ret    

00803050 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803050:	55                   	push   %ebp
  803051:	89 e5                	mov    %esp,%ebp
  803053:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	83 ec 0c             	sub    $0xc,%esp
  80305c:	50                   	push   %eax
  80305d:	e8 0b fe ff ff       	call   802e6d <to_page_info>
  803062:	83 c4 10             	add    $0x10,%esp
  803065:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 40 08             	mov    0x8(%eax),%eax
  80306e:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803071:	c9                   	leave  
  803072:	c3                   	ret    

00803073 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  803073:	55                   	push   %ebp
  803074:	89 e5                	mov    %esp,%ebp
  803076:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  803079:	83 ec 0c             	sub    $0xc,%esp
  80307c:	ff 75 0c             	pushl  0xc(%ebp)
  80307f:	e8 77 fd ff ff       	call   802dfb <to_page_va>
  803084:	83 c4 10             	add    $0x10,%esp
  803087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80308a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80308f:	ba 00 00 00 00       	mov    $0x0,%edx
  803094:	f7 75 08             	divl   0x8(%ebp)
  803097:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80309a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309d:	83 ec 0c             	sub    $0xc,%esp
  8030a0:	50                   	push   %eax
  8030a1:	e8 48 f6 ff ff       	call   8026ee <get_page>
  8030a6:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  8030a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030af:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b9:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8030bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8030c4:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8030cb:	eb 19                	jmp    8030e6 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8030cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d0:	ba 01 00 00 00       	mov    $0x1,%edx
  8030d5:	88 c1                	mov    %al,%cl
  8030d7:	d3 e2                	shl    %cl,%edx
  8030d9:	89 d0                	mov    %edx,%eax
  8030db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030de:	74 0e                	je     8030ee <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8030e0:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8030e3:	ff 45 f0             	incl   -0x10(%ebp)
  8030e6:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8030ea:	7e e1                	jle    8030cd <split_page_to_blocks+0x5a>
  8030ec:	eb 01                	jmp    8030ef <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8030ee:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8030ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8030f6:	e9 a7 00 00 00       	jmp    8031a2 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8030fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fe:	0f af 45 08          	imul   0x8(%ebp),%eax
  803102:	89 c2                	mov    %eax,%edx
  803104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803107:	01 d0                	add    %edx,%eax
  803109:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80310c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803110:	75 14                	jne    803126 <split_page_to_blocks+0xb3>
  803112:	83 ec 04             	sub    $0x4,%esp
  803115:	68 9c 49 80 00       	push   $0x80499c
  80311a:	6a 7c                	push   $0x7c
  80311c:	68 23 49 80 00       	push   $0x804923
  803121:	e8 c1 e3 ff ff       	call   8014e7 <_panic>
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	c1 e0 04             	shl    $0x4,%eax
  80312c:	05 64 d2 81 00       	add    $0x81d264,%eax
  803131:	8b 10                	mov    (%eax),%edx
  803133:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803136:	89 50 04             	mov    %edx,0x4(%eax)
  803139:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80313c:	8b 40 04             	mov    0x4(%eax),%eax
  80313f:	85 c0                	test   %eax,%eax
  803141:	74 14                	je     803157 <split_page_to_blocks+0xe4>
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	c1 e0 04             	shl    $0x4,%eax
  803149:	05 64 d2 81 00       	add    $0x81d264,%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803153:	89 10                	mov    %edx,(%eax)
  803155:	eb 11                	jmp    803168 <split_page_to_blocks+0xf5>
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	c1 e0 04             	shl    $0x4,%eax
  80315d:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  803163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803166:	89 02                	mov    %eax,(%edx)
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	c1 e0 04             	shl    $0x4,%eax
  80316e:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  803174:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803177:	89 02                	mov    %eax,(%edx)
  803179:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80317c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	c1 e0 04             	shl    $0x4,%eax
  803188:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80318d:	8b 00                	mov    (%eax),%eax
  80318f:	8d 50 01             	lea    0x1(%eax),%edx
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	c1 e0 04             	shl    $0x4,%eax
  803198:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80319d:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80319f:	ff 45 ec             	incl   -0x14(%ebp)
  8031a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8031a8:	0f 82 4d ff ff ff    	jb     8030fb <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8031ae:	90                   	nop
  8031af:	c9                   	leave  
  8031b0:	c3                   	ret    

008031b1 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8031b1:	55                   	push   %ebp
  8031b2:	89 e5                	mov    %esp,%ebp
  8031b4:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8031b7:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8031be:	76 19                	jbe    8031d9 <alloc_block+0x28>
  8031c0:	68 c0 49 80 00       	push   $0x8049c0
  8031c5:	68 86 49 80 00       	push   $0x804986
  8031ca:	68 8a 00 00 00       	push   $0x8a
  8031cf:	68 23 49 80 00       	push   $0x804923
  8031d4:	e8 0e e3 ff ff       	call   8014e7 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8031d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8031e0:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8031e7:	eb 19                	jmp    803202 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8031e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ec:	ba 01 00 00 00       	mov    $0x1,%edx
  8031f1:	88 c1                	mov    %al,%cl
  8031f3:	d3 e2                	shl    %cl,%edx
  8031f5:	89 d0                	mov    %edx,%eax
  8031f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fa:	73 0e                	jae    80320a <alloc_block+0x59>
		idx++;
  8031fc:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8031ff:	ff 45 f0             	incl   -0x10(%ebp)
  803202:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803206:	7e e1                	jle    8031e9 <alloc_block+0x38>
  803208:	eb 01                	jmp    80320b <alloc_block+0x5a>
		if((1 << i) >= size) break;
  80320a:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	c1 e0 04             	shl    $0x4,%eax
  803211:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803216:	8b 00                	mov    (%eax),%eax
  803218:	85 c0                	test   %eax,%eax
  80321a:	0f 84 df 00 00 00    	je     8032ff <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	c1 e0 04             	shl    $0x4,%eax
  803226:	05 60 d2 81 00       	add    $0x81d260,%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  803230:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803234:	75 17                	jne    80324d <alloc_block+0x9c>
  803236:	83 ec 04             	sub    $0x4,%esp
  803239:	68 e1 49 80 00       	push   $0x8049e1
  80323e:	68 9e 00 00 00       	push   $0x9e
  803243:	68 23 49 80 00       	push   $0x804923
  803248:	e8 9a e2 ff ff       	call   8014e7 <_panic>
  80324d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 10                	je     803266 <alloc_block+0xb5>
  803256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80325e:	8b 52 04             	mov    0x4(%edx),%edx
  803261:	89 50 04             	mov    %edx,0x4(%eax)
  803264:	eb 14                	jmp    80327a <alloc_block+0xc9>
  803266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803269:	8b 40 04             	mov    0x4(%eax),%eax
  80326c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80326f:	c1 e2 04             	shl    $0x4,%edx
  803272:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803278:	89 02                	mov    %eax,(%edx)
  80327a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 0f                	je     803293 <alloc_block+0xe2>
  803284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80328d:	8b 12                	mov    (%edx),%edx
  80328f:	89 10                	mov    %edx,(%eax)
  803291:	eb 13                	jmp    8032a6 <alloc_block+0xf5>
  803293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329b:	c1 e2 04             	shl    $0x4,%edx
  80329e:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8032a4:	89 02                	mov    %eax,(%edx)
  8032a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bc:	c1 e0 04             	shl    $0x4,%eax
  8032bf:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8032c4:	8b 00                	mov    (%eax),%eax
  8032c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cc:	c1 e0 04             	shl    $0x4,%eax
  8032cf:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8032d4:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8032d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d9:	83 ec 0c             	sub    $0xc,%esp
  8032dc:	50                   	push   %eax
  8032dd:	e8 8b fb ff ff       	call   802e6d <to_page_info>
  8032e2:	83 c4 10             	add    $0x10,%esp
  8032e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032eb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032ef:	48                   	dec    %eax
  8032f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f3:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8032f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fa:	e9 bc 02 00 00       	jmp    8035bb <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8032ff:	a1 34 52 80 00       	mov    0x805234,%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	0f 84 7d 02 00 00    	je     803589 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80330c:	a1 28 52 80 00       	mov    0x805228,%eax
  803311:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  803314:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803318:	75 17                	jne    803331 <alloc_block+0x180>
  80331a:	83 ec 04             	sub    $0x4,%esp
  80331d:	68 e1 49 80 00       	push   $0x8049e1
  803322:	68 a9 00 00 00       	push   $0xa9
  803327:	68 23 49 80 00       	push   $0x804923
  80332c:	e8 b6 e1 ff ff       	call   8014e7 <_panic>
  803331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803334:	8b 00                	mov    (%eax),%eax
  803336:	85 c0                	test   %eax,%eax
  803338:	74 10                	je     80334a <alloc_block+0x199>
  80333a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803342:	8b 52 04             	mov    0x4(%edx),%edx
  803345:	89 50 04             	mov    %edx,0x4(%eax)
  803348:	eb 0b                	jmp    803355 <alloc_block+0x1a4>
  80334a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334d:	8b 40 04             	mov    0x4(%eax),%eax
  803350:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803358:	8b 40 04             	mov    0x4(%eax),%eax
  80335b:	85 c0                	test   %eax,%eax
  80335d:	74 0f                	je     80336e <alloc_block+0x1bd>
  80335f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803368:	8b 12                	mov    (%edx),%edx
  80336a:	89 10                	mov    %edx,(%eax)
  80336c:	eb 0a                	jmp    803378 <alloc_block+0x1c7>
  80336e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803371:	8b 00                	mov    (%eax),%eax
  803373:	a3 28 52 80 00       	mov    %eax,0x805228
  803378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803384:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338b:	a1 34 52 80 00       	mov    0x805234,%eax
  803390:	48                   	dec    %eax
  803391:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	83 c0 03             	add    $0x3,%eax
  80339c:	ba 01 00 00 00       	mov    $0x1,%edx
  8033a1:	88 c1                	mov    %al,%cl
  8033a3:	d3 e2                	shl    %cl,%edx
  8033a5:	89 d0                	mov    %edx,%eax
  8033a7:	83 ec 08             	sub    $0x8,%esp
  8033aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033ad:	50                   	push   %eax
  8033ae:	e8 c0 fc ff ff       	call   803073 <split_page_to_blocks>
  8033b3:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	c1 e0 04             	shl    $0x4,%eax
  8033bc:	05 60 d2 81 00       	add    $0x81d260,%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8033c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033ca:	75 17                	jne    8033e3 <alloc_block+0x232>
  8033cc:	83 ec 04             	sub    $0x4,%esp
  8033cf:	68 e1 49 80 00       	push   $0x8049e1
  8033d4:	68 b0 00 00 00       	push   $0xb0
  8033d9:	68 23 49 80 00       	push   $0x804923
  8033de:	e8 04 e1 ff ff       	call   8014e7 <_panic>
  8033e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	74 10                	je     8033fc <alloc_block+0x24b>
  8033ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033f4:	8b 52 04             	mov    0x4(%edx),%edx
  8033f7:	89 50 04             	mov    %edx,0x4(%eax)
  8033fa:	eb 14                	jmp    803410 <alloc_block+0x25f>
  8033fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ff:	8b 40 04             	mov    0x4(%eax),%eax
  803402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803405:	c1 e2 04             	shl    $0x4,%edx
  803408:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80340e:	89 02                	mov    %eax,(%edx)
  803410:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803413:	8b 40 04             	mov    0x4(%eax),%eax
  803416:	85 c0                	test   %eax,%eax
  803418:	74 0f                	je     803429 <alloc_block+0x278>
  80341a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80341d:	8b 40 04             	mov    0x4(%eax),%eax
  803420:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803423:	8b 12                	mov    (%edx),%edx
  803425:	89 10                	mov    %edx,(%eax)
  803427:	eb 13                	jmp    80343c <alloc_block+0x28b>
  803429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803431:	c1 e2 04             	shl    $0x4,%edx
  803434:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80343a:	89 02                	mov    %eax,(%edx)
  80343c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80343f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803445:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803448:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	c1 e0 04             	shl    $0x4,%eax
  803455:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80345a:	8b 00                	mov    (%eax),%eax
  80345c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	c1 e0 04             	shl    $0x4,%eax
  803465:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80346a:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80346c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346f:	83 ec 0c             	sub    $0xc,%esp
  803472:	50                   	push   %eax
  803473:	e8 f5 f9 ff ff       	call   802e6d <to_page_info>
  803478:	83 c4 10             	add    $0x10,%esp
  80347b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80347e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803481:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803485:	48                   	dec    %eax
  803486:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803489:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80348d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803490:	e9 26 01 00 00       	jmp    8035bb <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  803495:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  803498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349b:	c1 e0 04             	shl    $0x4,%eax
  80349e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	0f 84 dc 00 00 00    	je     803589 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b0:	c1 e0 04             	shl    $0x4,%eax
  8034b3:	05 60 d2 81 00       	add    $0x81d260,%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8034bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8034c1:	75 17                	jne    8034da <alloc_block+0x329>
  8034c3:	83 ec 04             	sub    $0x4,%esp
  8034c6:	68 e1 49 80 00       	push   $0x8049e1
  8034cb:	68 be 00 00 00       	push   $0xbe
  8034d0:	68 23 49 80 00       	push   $0x804923
  8034d5:	e8 0d e0 ff ff       	call   8014e7 <_panic>
  8034da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	74 10                	je     8034f3 <alloc_block+0x342>
  8034e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034e6:	8b 00                	mov    (%eax),%eax
  8034e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034eb:	8b 52 04             	mov    0x4(%edx),%edx
  8034ee:	89 50 04             	mov    %edx,0x4(%eax)
  8034f1:	eb 14                	jmp    803507 <alloc_block+0x356>
  8034f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034f6:	8b 40 04             	mov    0x4(%eax),%eax
  8034f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034fc:	c1 e2 04             	shl    $0x4,%edx
  8034ff:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803505:	89 02                	mov    %eax,(%edx)
  803507:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80350a:	8b 40 04             	mov    0x4(%eax),%eax
  80350d:	85 c0                	test   %eax,%eax
  80350f:	74 0f                	je     803520 <alloc_block+0x36f>
  803511:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803514:	8b 40 04             	mov    0x4(%eax),%eax
  803517:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80351a:	8b 12                	mov    (%edx),%edx
  80351c:	89 10                	mov    %edx,(%eax)
  80351e:	eb 13                	jmp    803533 <alloc_block+0x382>
  803520:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803528:	c1 e2 04             	shl    $0x4,%edx
  80352b:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803531:	89 02                	mov    %eax,(%edx)
  803533:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80353f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	c1 e0 04             	shl    $0x4,%eax
  80354c:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	8d 50 ff             	lea    -0x1(%eax),%edx
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	c1 e0 04             	shl    $0x4,%eax
  80355c:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803561:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803563:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803566:	83 ec 0c             	sub    $0xc,%esp
  803569:	50                   	push   %eax
  80356a:	e8 fe f8 ff ff       	call   802e6d <to_page_info>
  80356f:	83 c4 10             	add    $0x10,%esp
  803572:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  803575:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803578:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80357c:	48                   	dec    %eax
  80357d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803580:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803584:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803587:	eb 32                	jmp    8035bb <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803589:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80358d:	77 15                	ja     8035a4 <alloc_block+0x3f3>
  80358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803592:	c1 e0 04             	shl    $0x4,%eax
  803595:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80359a:	8b 00                	mov    (%eax),%eax
  80359c:	85 c0                	test   %eax,%eax
  80359e:	0f 84 f1 fe ff ff    	je     803495 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8035a4:	83 ec 04             	sub    $0x4,%esp
  8035a7:	68 ff 49 80 00       	push   $0x8049ff
  8035ac:	68 c8 00 00 00       	push   $0xc8
  8035b1:	68 23 49 80 00       	push   $0x804923
  8035b6:	e8 2c df ff ff       	call   8014e7 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8035bb:	c9                   	leave  
  8035bc:	c3                   	ret    

008035bd <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8035bd:	55                   	push   %ebp
  8035be:	89 e5                	mov    %esp,%ebp
  8035c0:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8035c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c6:	a1 48 d2 81 00       	mov    0x81d248,%eax
  8035cb:	39 c2                	cmp    %eax,%edx
  8035cd:	72 0c                	jb     8035db <free_block+0x1e>
  8035cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d2:	a1 20 52 80 00       	mov    0x805220,%eax
  8035d7:	39 c2                	cmp    %eax,%edx
  8035d9:	72 19                	jb     8035f4 <free_block+0x37>
  8035db:	68 10 4a 80 00       	push   $0x804a10
  8035e0:	68 86 49 80 00       	push   $0x804986
  8035e5:	68 d7 00 00 00       	push   $0xd7
  8035ea:	68 23 49 80 00       	push   $0x804923
  8035ef:	e8 f3 de ff ff       	call   8014e7 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	83 ec 0c             	sub    $0xc,%esp
  803600:	50                   	push   %eax
  803601:	e8 67 f8 ff ff       	call   802e6d <to_page_info>
  803606:	83 c4 10             	add    $0x10,%esp
  803609:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360f:	8b 40 08             	mov    0x8(%eax),%eax
  803612:	0f b7 c0             	movzwl %ax,%eax
  803615:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803618:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80361f:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803626:	eb 19                	jmp    803641 <free_block+0x84>
	    if ((1 << i) == blk_size)
  803628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362b:	ba 01 00 00 00       	mov    $0x1,%edx
  803630:	88 c1                	mov    %al,%cl
  803632:	d3 e2                	shl    %cl,%edx
  803634:	89 d0                	mov    %edx,%eax
  803636:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803639:	74 0e                	je     803649 <free_block+0x8c>
	        break;
	    idx++;
  80363b:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80363e:	ff 45 f0             	incl   -0x10(%ebp)
  803641:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803645:	7e e1                	jle    803628 <free_block+0x6b>
  803647:	eb 01                	jmp    80364a <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  803649:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  80364a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803651:	40                   	inc    %eax
  803652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803655:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803659:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80365d:	75 17                	jne    803676 <free_block+0xb9>
  80365f:	83 ec 04             	sub    $0x4,%esp
  803662:	68 9c 49 80 00       	push   $0x80499c
  803667:	68 ee 00 00 00       	push   $0xee
  80366c:	68 23 49 80 00       	push   $0x804923
  803671:	e8 71 de ff ff       	call   8014e7 <_panic>
  803676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803679:	c1 e0 04             	shl    $0x4,%eax
  80367c:	05 64 d2 81 00       	add    $0x81d264,%eax
  803681:	8b 10                	mov    (%eax),%edx
  803683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803686:	89 50 04             	mov    %edx,0x4(%eax)
  803689:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368c:	8b 40 04             	mov    0x4(%eax),%eax
  80368f:	85 c0                	test   %eax,%eax
  803691:	74 14                	je     8036a7 <free_block+0xea>
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	c1 e0 04             	shl    $0x4,%eax
  803699:	05 64 d2 81 00       	add    $0x81d264,%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036a3:	89 10                	mov    %edx,(%eax)
  8036a5:	eb 11                	jmp    8036b8 <free_block+0xfb>
  8036a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036aa:	c1 e0 04             	shl    $0x4,%eax
  8036ad:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8036b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b6:	89 02                	mov    %eax,(%edx)
  8036b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bb:	c1 e0 04             	shl    $0x4,%eax
  8036be:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8036c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c7:	89 02                	mov    %eax,(%edx)
  8036c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d5:	c1 e0 04             	shl    $0x4,%eax
  8036d8:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	8d 50 01             	lea    0x1(%eax),%edx
  8036e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e5:	c1 e0 04             	shl    $0x4,%eax
  8036e8:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8036ed:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8036ef:	b8 00 10 00 00       	mov    $0x1000,%eax
  8036f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8036f9:	f7 75 e0             	divl   -0x20(%ebp)
  8036fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803702:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803706:	0f b7 c0             	movzwl %ax,%eax
  803709:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80370c:	0f 85 70 01 00 00    	jne    803882 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803712:	83 ec 0c             	sub    $0xc,%esp
  803715:	ff 75 e4             	pushl  -0x1c(%ebp)
  803718:	e8 de f6 ff ff       	call   802dfb <to_page_va>
  80371d:	83 c4 10             	add    $0x10,%esp
  803720:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803723:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80372a:	e9 b7 00 00 00       	jmp    8037e6 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80372f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803735:	01 d0                	add    %edx,%eax
  803737:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  80373a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80373e:	75 17                	jne    803757 <free_block+0x19a>
  803740:	83 ec 04             	sub    $0x4,%esp
  803743:	68 e1 49 80 00       	push   $0x8049e1
  803748:	68 f8 00 00 00       	push   $0xf8
  80374d:	68 23 49 80 00       	push   $0x804923
  803752:	e8 90 dd ff ff       	call   8014e7 <_panic>
  803757:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375a:	8b 00                	mov    (%eax),%eax
  80375c:	85 c0                	test   %eax,%eax
  80375e:	74 10                	je     803770 <free_block+0x1b3>
  803760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803763:	8b 00                	mov    (%eax),%eax
  803765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803768:	8b 52 04             	mov    0x4(%edx),%edx
  80376b:	89 50 04             	mov    %edx,0x4(%eax)
  80376e:	eb 14                	jmp    803784 <free_block+0x1c7>
  803770:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803773:	8b 40 04             	mov    0x4(%eax),%eax
  803776:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803779:	c1 e2 04             	shl    $0x4,%edx
  80377c:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803782:	89 02                	mov    %eax,(%edx)
  803784:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803787:	8b 40 04             	mov    0x4(%eax),%eax
  80378a:	85 c0                	test   %eax,%eax
  80378c:	74 0f                	je     80379d <free_block+0x1e0>
  80378e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803791:	8b 40 04             	mov    0x4(%eax),%eax
  803794:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803797:	8b 12                	mov    (%edx),%edx
  803799:	89 10                	mov    %edx,(%eax)
  80379b:	eb 13                	jmp    8037b0 <free_block+0x1f3>
  80379d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a0:	8b 00                	mov    (%eax),%eax
  8037a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a5:	c1 e2 04             	shl    $0x4,%edx
  8037a8:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8037ae:	89 02                	mov    %eax,(%edx)
  8037b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c6:	c1 e0 04             	shl    $0x4,%eax
  8037c9:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8037ce:	8b 00                	mov    (%eax),%eax
  8037d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8037d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d6:	c1 e0 04             	shl    $0x4,%eax
  8037d9:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8037de:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8037e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e3:	01 45 ec             	add    %eax,-0x14(%ebp)
  8037e6:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8037ed:	0f 86 3c ff ff ff    	jbe    80372f <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f6:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8037fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ff:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803805:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803809:	75 17                	jne    803822 <free_block+0x265>
  80380b:	83 ec 04             	sub    $0x4,%esp
  80380e:	68 9c 49 80 00       	push   $0x80499c
  803813:	68 fe 00 00 00       	push   $0xfe
  803818:	68 23 49 80 00       	push   $0x804923
  80381d:	e8 c5 dc ff ff       	call   8014e7 <_panic>
  803822:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382b:	89 50 04             	mov    %edx,0x4(%eax)
  80382e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803831:	8b 40 04             	mov    0x4(%eax),%eax
  803834:	85 c0                	test   %eax,%eax
  803836:	74 0c                	je     803844 <free_block+0x287>
  803838:	a1 2c 52 80 00       	mov    0x80522c,%eax
  80383d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803840:	89 10                	mov    %edx,(%eax)
  803842:	eb 08                	jmp    80384c <free_block+0x28f>
  803844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803847:	a3 28 52 80 00       	mov    %eax,0x805228
  80384c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384f:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803857:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80385d:	a1 34 52 80 00       	mov    0x805234,%eax
  803862:	40                   	inc    %eax
  803863:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803868:	83 ec 0c             	sub    $0xc,%esp
  80386b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80386e:	e8 88 f5 ff ff       	call   802dfb <to_page_va>
  803873:	83 c4 10             	add    $0x10,%esp
  803876:	83 ec 0c             	sub    $0xc,%esp
  803879:	50                   	push   %eax
  80387a:	e8 b8 ee ff ff       	call   802737 <return_page>
  80387f:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803882:	90                   	nop
  803883:	c9                   	leave  
  803884:	c3                   	ret    

00803885 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803885:	55                   	push   %ebp
  803886:	89 e5                	mov    %esp,%ebp
  803888:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80388b:	83 ec 04             	sub    $0x4,%esp
  80388e:	68 48 4a 80 00       	push   $0x804a48
  803893:	68 11 01 00 00       	push   $0x111
  803898:	68 23 49 80 00       	push   $0x804923
  80389d:	e8 45 dc ff ff       	call   8014e7 <_panic>
  8038a2:	66 90                	xchg   %ax,%ax

008038a4 <__udivdi3>:
  8038a4:	55                   	push   %ebp
  8038a5:	57                   	push   %edi
  8038a6:	56                   	push   %esi
  8038a7:	53                   	push   %ebx
  8038a8:	83 ec 1c             	sub    $0x1c,%esp
  8038ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038bb:	89 ca                	mov    %ecx,%edx
  8038bd:	89 f8                	mov    %edi,%eax
  8038bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038c3:	85 f6                	test   %esi,%esi
  8038c5:	75 2d                	jne    8038f4 <__udivdi3+0x50>
  8038c7:	39 cf                	cmp    %ecx,%edi
  8038c9:	77 65                	ja     803930 <__udivdi3+0x8c>
  8038cb:	89 fd                	mov    %edi,%ebp
  8038cd:	85 ff                	test   %edi,%edi
  8038cf:	75 0b                	jne    8038dc <__udivdi3+0x38>
  8038d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d6:	31 d2                	xor    %edx,%edx
  8038d8:	f7 f7                	div    %edi
  8038da:	89 c5                	mov    %eax,%ebp
  8038dc:	31 d2                	xor    %edx,%edx
  8038de:	89 c8                	mov    %ecx,%eax
  8038e0:	f7 f5                	div    %ebp
  8038e2:	89 c1                	mov    %eax,%ecx
  8038e4:	89 d8                	mov    %ebx,%eax
  8038e6:	f7 f5                	div    %ebp
  8038e8:	89 cf                	mov    %ecx,%edi
  8038ea:	89 fa                	mov    %edi,%edx
  8038ec:	83 c4 1c             	add    $0x1c,%esp
  8038ef:	5b                   	pop    %ebx
  8038f0:	5e                   	pop    %esi
  8038f1:	5f                   	pop    %edi
  8038f2:	5d                   	pop    %ebp
  8038f3:	c3                   	ret    
  8038f4:	39 ce                	cmp    %ecx,%esi
  8038f6:	77 28                	ja     803920 <__udivdi3+0x7c>
  8038f8:	0f bd fe             	bsr    %esi,%edi
  8038fb:	83 f7 1f             	xor    $0x1f,%edi
  8038fe:	75 40                	jne    803940 <__udivdi3+0x9c>
  803900:	39 ce                	cmp    %ecx,%esi
  803902:	72 0a                	jb     80390e <__udivdi3+0x6a>
  803904:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803908:	0f 87 9e 00 00 00    	ja     8039ac <__udivdi3+0x108>
  80390e:	b8 01 00 00 00       	mov    $0x1,%eax
  803913:	89 fa                	mov    %edi,%edx
  803915:	83 c4 1c             	add    $0x1c,%esp
  803918:	5b                   	pop    %ebx
  803919:	5e                   	pop    %esi
  80391a:	5f                   	pop    %edi
  80391b:	5d                   	pop    %ebp
  80391c:	c3                   	ret    
  80391d:	8d 76 00             	lea    0x0(%esi),%esi
  803920:	31 ff                	xor    %edi,%edi
  803922:	31 c0                	xor    %eax,%eax
  803924:	89 fa                	mov    %edi,%edx
  803926:	83 c4 1c             	add    $0x1c,%esp
  803929:	5b                   	pop    %ebx
  80392a:	5e                   	pop    %esi
  80392b:	5f                   	pop    %edi
  80392c:	5d                   	pop    %ebp
  80392d:	c3                   	ret    
  80392e:	66 90                	xchg   %ax,%ax
  803930:	89 d8                	mov    %ebx,%eax
  803932:	f7 f7                	div    %edi
  803934:	31 ff                	xor    %edi,%edi
  803936:	89 fa                	mov    %edi,%edx
  803938:	83 c4 1c             	add    $0x1c,%esp
  80393b:	5b                   	pop    %ebx
  80393c:	5e                   	pop    %esi
  80393d:	5f                   	pop    %edi
  80393e:	5d                   	pop    %ebp
  80393f:	c3                   	ret    
  803940:	bd 20 00 00 00       	mov    $0x20,%ebp
  803945:	89 eb                	mov    %ebp,%ebx
  803947:	29 fb                	sub    %edi,%ebx
  803949:	89 f9                	mov    %edi,%ecx
  80394b:	d3 e6                	shl    %cl,%esi
  80394d:	89 c5                	mov    %eax,%ebp
  80394f:	88 d9                	mov    %bl,%cl
  803951:	d3 ed                	shr    %cl,%ebp
  803953:	89 e9                	mov    %ebp,%ecx
  803955:	09 f1                	or     %esi,%ecx
  803957:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80395b:	89 f9                	mov    %edi,%ecx
  80395d:	d3 e0                	shl    %cl,%eax
  80395f:	89 c5                	mov    %eax,%ebp
  803961:	89 d6                	mov    %edx,%esi
  803963:	88 d9                	mov    %bl,%cl
  803965:	d3 ee                	shr    %cl,%esi
  803967:	89 f9                	mov    %edi,%ecx
  803969:	d3 e2                	shl    %cl,%edx
  80396b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80396f:	88 d9                	mov    %bl,%cl
  803971:	d3 e8                	shr    %cl,%eax
  803973:	09 c2                	or     %eax,%edx
  803975:	89 d0                	mov    %edx,%eax
  803977:	89 f2                	mov    %esi,%edx
  803979:	f7 74 24 0c          	divl   0xc(%esp)
  80397d:	89 d6                	mov    %edx,%esi
  80397f:	89 c3                	mov    %eax,%ebx
  803981:	f7 e5                	mul    %ebp
  803983:	39 d6                	cmp    %edx,%esi
  803985:	72 19                	jb     8039a0 <__udivdi3+0xfc>
  803987:	74 0b                	je     803994 <__udivdi3+0xf0>
  803989:	89 d8                	mov    %ebx,%eax
  80398b:	31 ff                	xor    %edi,%edi
  80398d:	e9 58 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  803992:	66 90                	xchg   %ax,%ax
  803994:	8b 54 24 08          	mov    0x8(%esp),%edx
  803998:	89 f9                	mov    %edi,%ecx
  80399a:	d3 e2                	shl    %cl,%edx
  80399c:	39 c2                	cmp    %eax,%edx
  80399e:	73 e9                	jae    803989 <__udivdi3+0xe5>
  8039a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039a3:	31 ff                	xor    %edi,%edi
  8039a5:	e9 40 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  8039aa:	66 90                	xchg   %ax,%ax
  8039ac:	31 c0                	xor    %eax,%eax
  8039ae:	e9 37 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  8039b3:	90                   	nop

008039b4 <__umoddi3>:
  8039b4:	55                   	push   %ebp
  8039b5:	57                   	push   %edi
  8039b6:	56                   	push   %esi
  8039b7:	53                   	push   %ebx
  8039b8:	83 ec 1c             	sub    $0x1c,%esp
  8039bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039d3:	89 f3                	mov    %esi,%ebx
  8039d5:	89 fa                	mov    %edi,%edx
  8039d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039db:	89 34 24             	mov    %esi,(%esp)
  8039de:	85 c0                	test   %eax,%eax
  8039e0:	75 1a                	jne    8039fc <__umoddi3+0x48>
  8039e2:	39 f7                	cmp    %esi,%edi
  8039e4:	0f 86 a2 00 00 00    	jbe    803a8c <__umoddi3+0xd8>
  8039ea:	89 c8                	mov    %ecx,%eax
  8039ec:	89 f2                	mov    %esi,%edx
  8039ee:	f7 f7                	div    %edi
  8039f0:	89 d0                	mov    %edx,%eax
  8039f2:	31 d2                	xor    %edx,%edx
  8039f4:	83 c4 1c             	add    $0x1c,%esp
  8039f7:	5b                   	pop    %ebx
  8039f8:	5e                   	pop    %esi
  8039f9:	5f                   	pop    %edi
  8039fa:	5d                   	pop    %ebp
  8039fb:	c3                   	ret    
  8039fc:	39 f0                	cmp    %esi,%eax
  8039fe:	0f 87 ac 00 00 00    	ja     803ab0 <__umoddi3+0xfc>
  803a04:	0f bd e8             	bsr    %eax,%ebp
  803a07:	83 f5 1f             	xor    $0x1f,%ebp
  803a0a:	0f 84 ac 00 00 00    	je     803abc <__umoddi3+0x108>
  803a10:	bf 20 00 00 00       	mov    $0x20,%edi
  803a15:	29 ef                	sub    %ebp,%edi
  803a17:	89 fe                	mov    %edi,%esi
  803a19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a1d:	89 e9                	mov    %ebp,%ecx
  803a1f:	d3 e0                	shl    %cl,%eax
  803a21:	89 d7                	mov    %edx,%edi
  803a23:	89 f1                	mov    %esi,%ecx
  803a25:	d3 ef                	shr    %cl,%edi
  803a27:	09 c7                	or     %eax,%edi
  803a29:	89 e9                	mov    %ebp,%ecx
  803a2b:	d3 e2                	shl    %cl,%edx
  803a2d:	89 14 24             	mov    %edx,(%esp)
  803a30:	89 d8                	mov    %ebx,%eax
  803a32:	d3 e0                	shl    %cl,%eax
  803a34:	89 c2                	mov    %eax,%edx
  803a36:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a3a:	d3 e0                	shl    %cl,%eax
  803a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a40:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a44:	89 f1                	mov    %esi,%ecx
  803a46:	d3 e8                	shr    %cl,%eax
  803a48:	09 d0                	or     %edx,%eax
  803a4a:	d3 eb                	shr    %cl,%ebx
  803a4c:	89 da                	mov    %ebx,%edx
  803a4e:	f7 f7                	div    %edi
  803a50:	89 d3                	mov    %edx,%ebx
  803a52:	f7 24 24             	mull   (%esp)
  803a55:	89 c6                	mov    %eax,%esi
  803a57:	89 d1                	mov    %edx,%ecx
  803a59:	39 d3                	cmp    %edx,%ebx
  803a5b:	0f 82 87 00 00 00    	jb     803ae8 <__umoddi3+0x134>
  803a61:	0f 84 91 00 00 00    	je     803af8 <__umoddi3+0x144>
  803a67:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a6b:	29 f2                	sub    %esi,%edx
  803a6d:	19 cb                	sbb    %ecx,%ebx
  803a6f:	89 d8                	mov    %ebx,%eax
  803a71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a75:	d3 e0                	shl    %cl,%eax
  803a77:	89 e9                	mov    %ebp,%ecx
  803a79:	d3 ea                	shr    %cl,%edx
  803a7b:	09 d0                	or     %edx,%eax
  803a7d:	89 e9                	mov    %ebp,%ecx
  803a7f:	d3 eb                	shr    %cl,%ebx
  803a81:	89 da                	mov    %ebx,%edx
  803a83:	83 c4 1c             	add    $0x1c,%esp
  803a86:	5b                   	pop    %ebx
  803a87:	5e                   	pop    %esi
  803a88:	5f                   	pop    %edi
  803a89:	5d                   	pop    %ebp
  803a8a:	c3                   	ret    
  803a8b:	90                   	nop
  803a8c:	89 fd                	mov    %edi,%ebp
  803a8e:	85 ff                	test   %edi,%edi
  803a90:	75 0b                	jne    803a9d <__umoddi3+0xe9>
  803a92:	b8 01 00 00 00       	mov    $0x1,%eax
  803a97:	31 d2                	xor    %edx,%edx
  803a99:	f7 f7                	div    %edi
  803a9b:	89 c5                	mov    %eax,%ebp
  803a9d:	89 f0                	mov    %esi,%eax
  803a9f:	31 d2                	xor    %edx,%edx
  803aa1:	f7 f5                	div    %ebp
  803aa3:	89 c8                	mov    %ecx,%eax
  803aa5:	f7 f5                	div    %ebp
  803aa7:	89 d0                	mov    %edx,%eax
  803aa9:	e9 44 ff ff ff       	jmp    8039f2 <__umoddi3+0x3e>
  803aae:	66 90                	xchg   %ax,%ax
  803ab0:	89 c8                	mov    %ecx,%eax
  803ab2:	89 f2                	mov    %esi,%edx
  803ab4:	83 c4 1c             	add    $0x1c,%esp
  803ab7:	5b                   	pop    %ebx
  803ab8:	5e                   	pop    %esi
  803ab9:	5f                   	pop    %edi
  803aba:	5d                   	pop    %ebp
  803abb:	c3                   	ret    
  803abc:	3b 04 24             	cmp    (%esp),%eax
  803abf:	72 06                	jb     803ac7 <__umoddi3+0x113>
  803ac1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ac5:	77 0f                	ja     803ad6 <__umoddi3+0x122>
  803ac7:	89 f2                	mov    %esi,%edx
  803ac9:	29 f9                	sub    %edi,%ecx
  803acb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803acf:	89 14 24             	mov    %edx,(%esp)
  803ad2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ad6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ada:	8b 14 24             	mov    (%esp),%edx
  803add:	83 c4 1c             	add    $0x1c,%esp
  803ae0:	5b                   	pop    %ebx
  803ae1:	5e                   	pop    %esi
  803ae2:	5f                   	pop    %edi
  803ae3:	5d                   	pop    %ebp
  803ae4:	c3                   	ret    
  803ae5:	8d 76 00             	lea    0x0(%esi),%esi
  803ae8:	2b 04 24             	sub    (%esp),%eax
  803aeb:	19 fa                	sbb    %edi,%edx
  803aed:	89 d1                	mov    %edx,%ecx
  803aef:	89 c6                	mov    %eax,%esi
  803af1:	e9 71 ff ff ff       	jmp    803a67 <__umoddi3+0xb3>
  803af6:	66 90                	xchg   %ax,%ax
  803af8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803afc:	72 ea                	jb     803ae8 <__umoddi3+0x134>
  803afe:	89 d9                	mov    %ebx,%ecx
  803b00:	e9 62 ff ff ff       	jmp    803a67 <__umoddi3+0xb3>
