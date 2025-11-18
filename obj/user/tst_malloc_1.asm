
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
  800031:	e8 e6 10 00 00       	call   80111c <libmain>
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
  800067:	e8 fe 26 00 00       	call   80276a <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 41 27 00 00       	call   8027b5 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 aa 24 00 00       	call   802571 <malloc>
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
  8000df:	e8 86 26 00 00       	call   80276a <sys_calculate_free_frames>
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
  800125:	68 00 39 80 00       	push   $0x803900
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 ab 14 00 00       	call   8015dc <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 7c 26 00 00       	call   8027b5 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 7c 39 80 00       	push   $0x80397c
  800150:	6a 0c                	push   $0xc
  800152:	e8 85 14 00 00       	call   8015dc <cprintf_colored>
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
  800174:	e8 f1 25 00 00       	call   80276a <sys_calculate_free_frames>
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
  8001b9:	e8 ac 25 00 00       	call   80276a <sys_calculate_free_frames>
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
  8001f8:	68 f4 39 80 00       	push   $0x8039f4
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 d8 13 00 00       	call   8015dc <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 a9 25 00 00       	call   8027b5 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 80 3a 80 00       	push   $0x803a80
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 ab 13 00 00       	call   8015dc <cprintf_colored>
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
  800270:	e8 b7 28 00 00       	call   802b2c <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 f8 3a 80 00       	push   $0x803af8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 46 13 00 00       	call   8015dc <cprintf_colored>
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
  8002ae:	e8 b7 24 00 00       	call   80276a <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 fa 24 00 00       	call   8027b5 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 ce 22 00 00       	call   80259f <free>
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
  8002fc:	e8 b4 24 00 00       	call   8027b5 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 30 3b 80 00       	push   $0x803b30
  800318:	6a 0c                	push   $0xc
  80031a:	e8 bd 12 00 00       	call   8015dc <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 43 24 00 00       	call   80276a <sys_calculate_free_frames>
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
  800342:	68 7c 3b 80 00       	push   $0x803b7c
  800347:	6a 0c                	push   $0xc
  800349:	e8 8e 12 00 00       	call   8015dc <cprintf_colored>
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
  8003a0:	e8 87 27 00 00       	call   802b2c <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 d8 3b 80 00       	push   $0x803bd8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 16 12 00 00       	call   8015dc <cprintf_colored>
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
  800416:	68 10 3c 80 00       	push   $0x803c10
  80041b:	6a 03                	push   $0x3
  80041d:	e8 ba 11 00 00       	call   8015dc <cprintf_colored>
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
  8004df:	68 40 3c 80 00       	push   $0x803c40
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 f1 10 00 00       	call   8015dc <cprintf_colored>
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
  8005b9:	68 40 3c 80 00       	push   $0x803c40
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 17 10 00 00       	call   8015dc <cprintf_colored>
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
  800693:	68 40 3c 80 00       	push   $0x803c40
  800698:	6a 0c                	push   $0xc
  80069a:	e8 3d 0f 00 00       	call   8015dc <cprintf_colored>
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
  80076d:	68 40 3c 80 00       	push   $0x803c40
  800772:	6a 0c                	push   $0xc
  800774:	e8 63 0e 00 00       	call   8015dc <cprintf_colored>
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
  800847:	68 40 3c 80 00       	push   $0x803c40
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 89 0d 00 00       	call   8015dc <cprintf_colored>
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
  800921:	68 40 3c 80 00       	push   $0x803c40
  800926:	6a 0c                	push   $0xc
  800928:	e8 af 0c 00 00       	call   8015dc <cprintf_colored>
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
  800a16:	68 40 3c 80 00       	push   $0x803c40
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 ba 0b 00 00       	call   8015dc <cprintf_colored>
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
  800b14:	68 40 3c 80 00       	push   $0x803c40
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 bc 0a 00 00       	call   8015dc <cprintf_colored>
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
  800c12:	68 40 3c 80 00       	push   $0x803c40
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 be 09 00 00       	call   8015dc <cprintf_colored>
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
  800d10:	68 40 3c 80 00       	push   $0x803c40
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 c0 08 00 00       	call   8015dc <cprintf_colored>
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
  800dfd:	68 40 3c 80 00       	push   $0x803c40
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 d3 07 00 00       	call   8015dc <cprintf_colored>
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
  800eea:	68 40 3c 80 00       	push   $0x803c40
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 e6 06 00 00       	call   8015dc <cprintf_colored>
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
  800fd7:	68 40 3c 80 00       	push   $0x803c40
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 f9 05 00 00       	call   8015dc <cprintf_colored>
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
  800ffa:	68 92 3c 80 00       	push   $0x803c92
  800fff:	6a 03                	push   $0x3
  801001:	e8 d6 05 00 00       	call   8015dc <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 4b 17 00 00       	call   80276a <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 8b 17 00 00       	call   8027b5 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 17 15 00 00       	call   802571 <malloc>
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
  801084:	68 b0 3c 80 00       	push   $0x803cb0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 4c 05 00 00       	call   8015dc <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 1d 17 00 00       	call   8027b5 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 ec 3c 80 00       	push   $0x803cec
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 20 05 00 00       	call   8015dc <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 a6 16 00 00       	call   80276a <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 5c 3d 80 00       	push   $0x803d5c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 f4 04 00 00       	call   8015dc <cprintf_colored>
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
  801102:	81 ec a8 00 00 00    	sub    $0xa8,%esp
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
			panic("Please increase the WS size");
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
  801108:	83 ec 04             	sub    $0x4,%esp
  80110b:	68 a4 3d 80 00       	push   $0x803da4
  801110:	6a 1b                	push   $0x1b
  801112:	68 d5 3d 80 00       	push   $0x803dd5
  801117:	e8 c5 01 00 00       	call   8012e1 <_panic>

0080111c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	57                   	push   %edi
  801120:	56                   	push   %esi
  801121:	53                   	push   %ebx
  801122:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801125:	e8 09 18 00 00       	call   802933 <sys_getenvindex>
  80112a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80112d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801130:	89 d0                	mov    %edx,%eax
  801132:	c1 e0 06             	shl    $0x6,%eax
  801135:	29 d0                	sub    %edx,%eax
  801137:	c1 e0 02             	shl    $0x2,%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801143:	01 c8                	add    %ecx,%eax
  801145:	c1 e0 03             	shl    $0x3,%eax
  801148:	01 d0                	add    %edx,%eax
  80114a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801151:	29 c2                	sub    %eax,%edx
  801153:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80115a:	89 c2                	mov    %eax,%edx
  80115c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  801162:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801167:	a1 00 52 80 00       	mov    0x805200,%eax
  80116c:	8a 40 20             	mov    0x20(%eax),%al
  80116f:	84 c0                	test   %al,%al
  801171:	74 0d                	je     801180 <libmain+0x64>
		binaryname = myEnv->prog_name;
  801173:	a1 00 52 80 00       	mov    0x805200,%eax
  801178:	83 c0 20             	add    $0x20,%eax
  80117b:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	7e 0a                	jle    801190 <libmain+0x74>
		binaryname = argv[0];
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	8b 00                	mov    (%eax),%eax
  80118b:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	ff 75 08             	pushl  0x8(%ebp)
  801199:	e8 61 ff ff ff       	call   8010ff <_main>
  80119e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8011a1:	a1 00 50 80 00       	mov    0x805000,%eax
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	0f 84 01 01 00 00    	je     8012af <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8011ae:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011b4:	bb e4 3e 80 00       	mov    $0x803ee4,%ebx
  8011b9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8011be:	89 c7                	mov    %eax,%edi
  8011c0:	89 de                	mov    %ebx,%esi
  8011c2:	89 d1                	mov    %edx,%ecx
  8011c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8011c6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8011c9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8011ce:	b0 00                	mov    $0x0,%al
  8011d0:	89 d7                	mov    %edx,%edi
  8011d2:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8011d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8011db:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011de:	83 ec 08             	sub    $0x8,%esp
  8011e1:	50                   	push   %eax
  8011e2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011e8:	50                   	push   %eax
  8011e9:	e8 7b 19 00 00       	call   802b69 <sys_utilities>
  8011ee:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8011f1:	e8 c4 14 00 00       	call   8026ba <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	68 04 3e 80 00       	push   $0x803e04
  8011fe:	e8 ac 03 00 00       	call   8015af <cprintf>
  801203:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801209:	85 c0                	test   %eax,%eax
  80120b:	74 18                	je     801225 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80120d:	e8 75 19 00 00       	call   802b87 <sys_get_optimal_num_faults>
  801212:	83 ec 08             	sub    $0x8,%esp
  801215:	50                   	push   %eax
  801216:	68 2c 3e 80 00       	push   $0x803e2c
  80121b:	e8 8f 03 00 00       	call   8015af <cprintf>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	eb 59                	jmp    80127e <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801225:	a1 00 52 80 00       	mov    0x805200,%eax
  80122a:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  801230:	a1 00 52 80 00       	mov    0x805200,%eax
  801235:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80123b:	83 ec 04             	sub    $0x4,%esp
  80123e:	52                   	push   %edx
  80123f:	50                   	push   %eax
  801240:	68 50 3e 80 00       	push   $0x803e50
  801245:	e8 65 03 00 00       	call   8015af <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80124d:	a1 00 52 80 00       	mov    0x805200,%eax
  801252:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  801258:	a1 00 52 80 00       	mov    0x805200,%eax
  80125d:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  801263:	a1 00 52 80 00       	mov    0x805200,%eax
  801268:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80126e:	51                   	push   %ecx
  80126f:	52                   	push   %edx
  801270:	50                   	push   %eax
  801271:	68 78 3e 80 00       	push   $0x803e78
  801276:	e8 34 03 00 00       	call   8015af <cprintf>
  80127b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80127e:	a1 00 52 80 00       	mov    0x805200,%eax
  801283:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  801289:	83 ec 08             	sub    $0x8,%esp
  80128c:	50                   	push   %eax
  80128d:	68 d0 3e 80 00       	push   $0x803ed0
  801292:	e8 18 03 00 00       	call   8015af <cprintf>
  801297:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80129a:	83 ec 0c             	sub    $0xc,%esp
  80129d:	68 04 3e 80 00       	push   $0x803e04
  8012a2:	e8 08 03 00 00       	call   8015af <cprintf>
  8012a7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8012aa:	e8 25 14 00 00       	call   8026d4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8012af:	e8 1f 00 00 00       	call   8012d3 <exit>
}
  8012b4:	90                   	nop
  8012b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5f                   	pop    %edi
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 32 16 00 00       	call   8028ff <sys_destroy_env>
  8012cd:	83 c4 10             	add    $0x10,%esp
}
  8012d0:	90                   	nop
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <exit>:

void
exit(void)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012d9:	e8 87 16 00 00       	call   802965 <sys_exit_env>
}
  8012de:	90                   	nop
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8012ea:	83 c0 04             	add    $0x4,%eax
  8012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012f0:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	74 16                	je     80130f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012f9:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8012fe:	83 ec 08             	sub    $0x8,%esp
  801301:	50                   	push   %eax
  801302:	68 48 3f 80 00       	push   $0x803f48
  801307:	e8 a3 02 00 00       	call   8015af <cprintf>
  80130c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80130f:	a1 04 50 80 00       	mov    0x805004,%eax
  801314:	83 ec 0c             	sub    $0xc,%esp
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	ff 75 08             	pushl  0x8(%ebp)
  80131d:	50                   	push   %eax
  80131e:	68 50 3f 80 00       	push   $0x803f50
  801323:	6a 74                	push   $0x74
  801325:	e8 b2 02 00 00       	call   8015dc <cprintf_colored>
  80132a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	83 ec 08             	sub    $0x8,%esp
  801333:	ff 75 f4             	pushl  -0xc(%ebp)
  801336:	50                   	push   %eax
  801337:	e8 04 02 00 00       	call   801540 <vcprintf>
  80133c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	6a 00                	push   $0x0
  801344:	68 78 3f 80 00       	push   $0x803f78
  801349:	e8 f2 01 00 00       	call   801540 <vcprintf>
  80134e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801351:	e8 7d ff ff ff       	call   8012d3 <exit>

	// should not return here
	while (1) ;
  801356:	eb fe                	jmp    801356 <_panic+0x75>

00801358 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80135e:	a1 00 52 80 00       	mov    0x805200,%eax
  801363:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	39 c2                	cmp    %eax,%edx
  80136e:	74 14                	je     801384 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	68 7c 3f 80 00       	push   $0x803f7c
  801378:	6a 26                	push   $0x26
  80137a:	68 c8 3f 80 00       	push   $0x803fc8
  80137f:	e8 5d ff ff ff       	call   8012e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80138b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801392:	e9 c5 00 00 00       	jmp    80145c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	01 d0                	add    %edx,%eax
  8013a6:	8b 00                	mov    (%eax),%eax
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	75 08                	jne    8013b4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8013ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8013af:	e9 a5 00 00 00       	jmp    801459 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8013b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013c2:	eb 69                	jmp    80142d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8013c4:	a1 00 52 80 00       	mov    0x805200,%eax
  8013c9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8013cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013d2:	89 d0                	mov    %edx,%eax
  8013d4:	01 c0                	add    %eax,%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	c1 e0 03             	shl    $0x3,%eax
  8013db:	01 c8                	add    %ecx,%eax
  8013dd:	8a 40 04             	mov    0x4(%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 46                	jne    80142a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013e4:	a1 00 52 80 00       	mov    0x805200,%eax
  8013e9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8013ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	01 c0                	add    %eax,%eax
  8013f6:	01 d0                	add    %edx,%eax
  8013f8:	c1 e0 03             	shl    $0x3,%eax
  8013fb:	01 c8                	add    %ecx,%eax
  8013fd:	8b 00                	mov    (%eax),%eax
  8013ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80140a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80140c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	01 c8                	add    %ecx,%eax
  80141b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80141d:	39 c2                	cmp    %eax,%edx
  80141f:	75 09                	jne    80142a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801428:	eb 15                	jmp    80143f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80142a:	ff 45 e8             	incl   -0x18(%ebp)
  80142d:	a1 00 52 80 00       	mov    0x805200,%eax
  801432:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801438:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143b:	39 c2                	cmp    %eax,%edx
  80143d:	77 85                	ja     8013c4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80143f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801443:	75 14                	jne    801459 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 d4 3f 80 00       	push   $0x803fd4
  80144d:	6a 3a                	push   $0x3a
  80144f:	68 c8 3f 80 00       	push   $0x803fc8
  801454:	e8 88 fe ff ff       	call   8012e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801459:	ff 45 f0             	incl   -0x10(%ebp)
  80145c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801462:	0f 8c 2f ff ff ff    	jl     801397 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801468:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80146f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801476:	eb 26                	jmp    80149e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801478:	a1 00 52 80 00       	mov    0x805200,%eax
  80147d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801483:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801486:	89 d0                	mov    %edx,%eax
  801488:	01 c0                	add    %eax,%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	c1 e0 03             	shl    $0x3,%eax
  80148f:	01 c8                	add    %ecx,%eax
  801491:	8a 40 04             	mov    0x4(%eax),%al
  801494:	3c 01                	cmp    $0x1,%al
  801496:	75 03                	jne    80149b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801498:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80149b:	ff 45 e0             	incl   -0x20(%ebp)
  80149e:	a1 00 52 80 00       	mov    0x805200,%eax
  8014a3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8014a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ac:	39 c2                	cmp    %eax,%edx
  8014ae:	77 c8                	ja     801478 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8014b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8014b6:	74 14                	je     8014cc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	68 28 40 80 00       	push   $0x804028
  8014c0:	6a 44                	push   $0x44
  8014c2:	68 c8 3f 80 00       	push   $0x803fc8
  8014c7:	e8 15 fe ff ff       	call   8012e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8014cc:	90                   	nop
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	53                   	push   %ebx
  8014d3:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	8b 00                	mov    (%eax),%eax
  8014db:	8d 48 01             	lea    0x1(%eax),%ecx
  8014de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e1:	89 0a                	mov    %ecx,(%edx)
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	88 d1                	mov    %dl,%cl
  8014e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014eb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	8b 00                	mov    (%eax),%eax
  8014f4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014f9:	75 30                	jne    80152b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8014fb:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801501:	a0 24 52 80 00       	mov    0x805224,%al
  801506:	0f b6 c0             	movzbl %al,%eax
  801509:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80150c:	8b 09                	mov    (%ecx),%ecx
  80150e:	89 cb                	mov    %ecx,%ebx
  801510:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801513:	83 c1 08             	add    $0x8,%ecx
  801516:	52                   	push   %edx
  801517:	50                   	push   %eax
  801518:	53                   	push   %ebx
  801519:	51                   	push   %ecx
  80151a:	e8 57 11 00 00       	call   802676 <sys_cputs>
  80151f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 40 04             	mov    0x4(%eax),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 50 04             	mov    %edx,0x4(%eax)
}
  80153a:	90                   	nop
  80153b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801549:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801550:	00 00 00 
	b.cnt = 0;
  801553:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80155a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80155d:	ff 75 0c             	pushl  0xc(%ebp)
  801560:	ff 75 08             	pushl  0x8(%ebp)
  801563:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801569:	50                   	push   %eax
  80156a:	68 cf 14 80 00       	push   $0x8014cf
  80156f:	e8 5a 02 00 00       	call   8017ce <vprintfmt>
  801574:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801577:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  80157d:	a0 24 52 80 00       	mov    0x805224,%al
  801582:	0f b6 c0             	movzbl %al,%eax
  801585:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80158b:	52                   	push   %edx
  80158c:	50                   	push   %eax
  80158d:	51                   	push   %ecx
  80158e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801594:	83 c0 08             	add    $0x8,%eax
  801597:	50                   	push   %eax
  801598:	e8 d9 10 00 00       	call   802676 <sys_cputs>
  80159d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8015a0:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  8015a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015b5:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  8015bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cb:	50                   	push   %eax
  8015cc:	e8 6f ff ff ff       	call   801540 <vcprintf>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015e2:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	c1 e0 08             	shl    $0x8,%eax
  8015ef:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  8015f4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015f7:	83 c0 04             	add    $0x4,%eax
  8015fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	ff 75 f4             	pushl  -0xc(%ebp)
  801606:	50                   	push   %eax
  801607:	e8 34 ff ff ff       	call   801540 <vcprintf>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801612:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  801619:	07 00 00 

	return cnt;
  80161c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801627:	e8 8e 10 00 00       	call   8026ba <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80162c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80162f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	ff 75 f4             	pushl  -0xc(%ebp)
  80163b:	50                   	push   %eax
  80163c:	e8 ff fe ff ff       	call   801540 <vcprintf>
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801647:	e8 88 10 00 00       	call   8026d4 <sys_unlock_cons>
	return cnt;
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	53                   	push   %ebx
  801655:	83 ec 14             	sub    $0x14,%esp
  801658:	8b 45 10             	mov    0x10(%ebp),%eax
  80165b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80165e:	8b 45 14             	mov    0x14(%ebp),%eax
  801661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801664:	8b 45 18             	mov    0x18(%ebp),%eax
  801667:	ba 00 00 00 00       	mov    $0x0,%edx
  80166c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80166f:	77 55                	ja     8016c6 <printnum+0x75>
  801671:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801674:	72 05                	jb     80167b <printnum+0x2a>
  801676:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801679:	77 4b                	ja     8016c6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80167b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80167e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801681:	8b 45 18             	mov    0x18(%ebp),%eax
  801684:	ba 00 00 00 00       	mov    $0x0,%edx
  801689:	52                   	push   %edx
  80168a:	50                   	push   %eax
  80168b:	ff 75 f4             	pushl  -0xc(%ebp)
  80168e:	ff 75 f0             	pushl  -0x10(%ebp)
  801691:	e8 06 20 00 00       	call   80369c <__udivdi3>
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	ff 75 20             	pushl  0x20(%ebp)
  80169f:	53                   	push   %ebx
  8016a0:	ff 75 18             	pushl  0x18(%ebp)
  8016a3:	52                   	push   %edx
  8016a4:	50                   	push   %eax
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	ff 75 08             	pushl  0x8(%ebp)
  8016ab:	e8 a1 ff ff ff       	call   801651 <printnum>
  8016b0:	83 c4 20             	add    $0x20,%esp
  8016b3:	eb 1a                	jmp    8016cf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 20             	pushl  0x20(%ebp)
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	ff d0                	call   *%eax
  8016c3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016c6:	ff 4d 1c             	decl   0x1c(%ebp)
  8016c9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8016cd:	7f e6                	jg     8016b5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016cf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8016d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016dd:	53                   	push   %ebx
  8016de:	51                   	push   %ecx
  8016df:	52                   	push   %edx
  8016e0:	50                   	push   %eax
  8016e1:	e8 c6 20 00 00       	call   8037ac <__umoddi3>
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	05 94 42 80 00       	add    $0x804294,%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f be c0             	movsbl %al,%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	ff d0                	call   *%eax
  8016ff:	83 c4 10             	add    $0x10,%esp
}
  801702:	90                   	nop
  801703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80170b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80170f:	7e 1c                	jle    80172d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 50 08             	lea    0x8(%eax),%edx
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 10                	mov    %edx,(%eax)
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 e8 08             	sub    $0x8,%eax
  801726:	8b 50 04             	mov    0x4(%eax),%edx
  801729:	8b 00                	mov    (%eax),%eax
  80172b:	eb 40                	jmp    80176d <getuint+0x65>
	else if (lflag)
  80172d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801731:	74 1e                	je     801751 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8b 00                	mov    (%eax),%eax
  801738:	8d 50 04             	lea    0x4(%eax),%edx
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	89 10                	mov    %edx,(%eax)
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	8b 00                	mov    (%eax),%eax
  801745:	83 e8 04             	sub    $0x4,%eax
  801748:	8b 00                	mov    (%eax),%eax
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	eb 1c                	jmp    80176d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8b 00                	mov    (%eax),%eax
  801756:	8d 50 04             	lea    0x4(%eax),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	89 10                	mov    %edx,(%eax)
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	8b 00                	mov    (%eax),%eax
  801763:	83 e8 04             	sub    $0x4,%eax
  801766:	8b 00                	mov    (%eax),%eax
  801768:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80176d:	5d                   	pop    %ebp
  80176e:	c3                   	ret    

0080176f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801772:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801776:	7e 1c                	jle    801794 <getint+0x25>
		return va_arg(*ap, long long);
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8b 00                	mov    (%eax),%eax
  80177d:	8d 50 08             	lea    0x8(%eax),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	89 10                	mov    %edx,(%eax)
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8b 00                	mov    (%eax),%eax
  80178a:	83 e8 08             	sub    $0x8,%eax
  80178d:	8b 50 04             	mov    0x4(%eax),%edx
  801790:	8b 00                	mov    (%eax),%eax
  801792:	eb 38                	jmp    8017cc <getint+0x5d>
	else if (lflag)
  801794:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801798:	74 1a                	je     8017b4 <getint+0x45>
		return va_arg(*ap, long);
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8b 00                	mov    (%eax),%eax
  80179f:	8d 50 04             	lea    0x4(%eax),%edx
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	89 10                	mov    %edx,(%eax)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8b 00                	mov    (%eax),%eax
  8017ac:	83 e8 04             	sub    $0x4,%eax
  8017af:	8b 00                	mov    (%eax),%eax
  8017b1:	99                   	cltd   
  8017b2:	eb 18                	jmp    8017cc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8b 00                	mov    (%eax),%eax
  8017b9:	8d 50 04             	lea    0x4(%eax),%edx
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	89 10                	mov    %edx,(%eax)
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8b 00                	mov    (%eax),%eax
  8017c6:	83 e8 04             	sub    $0x4,%eax
  8017c9:	8b 00                	mov    (%eax),%eax
  8017cb:	99                   	cltd   
}
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    

008017ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	56                   	push   %esi
  8017d2:	53                   	push   %ebx
  8017d3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017d6:	eb 17                	jmp    8017ef <vprintfmt+0x21>
			if (ch == '\0')
  8017d8:	85 db                	test   %ebx,%ebx
  8017da:	0f 84 c1 03 00 00    	je     801ba1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	53                   	push   %ebx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	ff d0                	call   *%eax
  8017ec:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f2:	8d 50 01             	lea    0x1(%eax),%edx
  8017f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	0f b6 d8             	movzbl %al,%ebx
  8017fd:	83 fb 25             	cmp    $0x25,%ebx
  801800:	75 d6                	jne    8017d8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801802:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801806:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80180d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801814:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80181b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801822:	8b 45 10             	mov    0x10(%ebp),%eax
  801825:	8d 50 01             	lea    0x1(%eax),%edx
  801828:	89 55 10             	mov    %edx,0x10(%ebp)
  80182b:	8a 00                	mov    (%eax),%al
  80182d:	0f b6 d8             	movzbl %al,%ebx
  801830:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801833:	83 f8 5b             	cmp    $0x5b,%eax
  801836:	0f 87 3d 03 00 00    	ja     801b79 <vprintfmt+0x3ab>
  80183c:	8b 04 85 b8 42 80 00 	mov    0x8042b8(,%eax,4),%eax
  801843:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801845:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801849:	eb d7                	jmp    801822 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80184b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80184f:	eb d1                	jmp    801822 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801851:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801858:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80185b:	89 d0                	mov    %edx,%eax
  80185d:	c1 e0 02             	shl    $0x2,%eax
  801860:	01 d0                	add    %edx,%eax
  801862:	01 c0                	add    %eax,%eax
  801864:	01 d8                	add    %ebx,%eax
  801866:	83 e8 30             	sub    $0x30,%eax
  801869:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	8a 00                	mov    (%eax),%al
  801871:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801874:	83 fb 2f             	cmp    $0x2f,%ebx
  801877:	7e 3e                	jle    8018b7 <vprintfmt+0xe9>
  801879:	83 fb 39             	cmp    $0x39,%ebx
  80187c:	7f 39                	jg     8018b7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80187e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801881:	eb d5                	jmp    801858 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801883:	8b 45 14             	mov    0x14(%ebp),%eax
  801886:	83 c0 04             	add    $0x4,%eax
  801889:	89 45 14             	mov    %eax,0x14(%ebp)
  80188c:	8b 45 14             	mov    0x14(%ebp),%eax
  80188f:	83 e8 04             	sub    $0x4,%eax
  801892:	8b 00                	mov    (%eax),%eax
  801894:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801897:	eb 1f                	jmp    8018b8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80189d:	79 83                	jns    801822 <vprintfmt+0x54>
				width = 0;
  80189f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8018a6:	e9 77 ff ff ff       	jmp    801822 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8018ab:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8018b2:	e9 6b ff ff ff       	jmp    801822 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8018b7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8018b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018bc:	0f 89 60 ff ff ff    	jns    801822 <vprintfmt+0x54>
				width = precision, precision = -1;
  8018c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8018cf:	e9 4e ff ff ff       	jmp    801822 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8018d4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8018d7:	e9 46 ff ff ff       	jmp    801822 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8018dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018df:	83 c0 04             	add    $0x4,%eax
  8018e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8018e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e8:	83 e8 04             	sub    $0x4,%eax
  8018eb:	8b 00                	mov    (%eax),%eax
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	50                   	push   %eax
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	ff d0                	call   *%eax
  8018f9:	83 c4 10             	add    $0x10,%esp
			break;
  8018fc:	e9 9b 02 00 00       	jmp    801b9c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801901:	8b 45 14             	mov    0x14(%ebp),%eax
  801904:	83 c0 04             	add    $0x4,%eax
  801907:	89 45 14             	mov    %eax,0x14(%ebp)
  80190a:	8b 45 14             	mov    0x14(%ebp),%eax
  80190d:	83 e8 04             	sub    $0x4,%eax
  801910:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801912:	85 db                	test   %ebx,%ebx
  801914:	79 02                	jns    801918 <vprintfmt+0x14a>
				err = -err;
  801916:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801918:	83 fb 64             	cmp    $0x64,%ebx
  80191b:	7f 0b                	jg     801928 <vprintfmt+0x15a>
  80191d:	8b 34 9d 00 41 80 00 	mov    0x804100(,%ebx,4),%esi
  801924:	85 f6                	test   %esi,%esi
  801926:	75 19                	jne    801941 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801928:	53                   	push   %ebx
  801929:	68 a5 42 80 00       	push   $0x8042a5
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	ff 75 08             	pushl  0x8(%ebp)
  801934:	e8 70 02 00 00       	call   801ba9 <printfmt>
  801939:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80193c:	e9 5b 02 00 00       	jmp    801b9c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801941:	56                   	push   %esi
  801942:	68 ae 42 80 00       	push   $0x8042ae
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	e8 57 02 00 00       	call   801ba9 <printfmt>
  801952:	83 c4 10             	add    $0x10,%esp
			break;
  801955:	e9 42 02 00 00       	jmp    801b9c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80195a:	8b 45 14             	mov    0x14(%ebp),%eax
  80195d:	83 c0 04             	add    $0x4,%eax
  801960:	89 45 14             	mov    %eax,0x14(%ebp)
  801963:	8b 45 14             	mov    0x14(%ebp),%eax
  801966:	83 e8 04             	sub    $0x4,%eax
  801969:	8b 30                	mov    (%eax),%esi
  80196b:	85 f6                	test   %esi,%esi
  80196d:	75 05                	jne    801974 <vprintfmt+0x1a6>
				p = "(null)";
  80196f:	be b1 42 80 00       	mov    $0x8042b1,%esi
			if (width > 0 && padc != '-')
  801974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801978:	7e 6d                	jle    8019e7 <vprintfmt+0x219>
  80197a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80197e:	74 67                	je     8019e7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801980:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	50                   	push   %eax
  801987:	56                   	push   %esi
  801988:	e8 1e 03 00 00       	call   801cab <strnlen>
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801993:	eb 16                	jmp    8019ab <vprintfmt+0x1dd>
					putch(padc, putdat);
  801995:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	50                   	push   %eax
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	ff d0                	call   *%eax
  8019a5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8019a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8019ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019af:	7f e4                	jg     801995 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019b1:	eb 34                	jmp    8019e7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8019b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019b7:	74 1c                	je     8019d5 <vprintfmt+0x207>
  8019b9:	83 fb 1f             	cmp    $0x1f,%ebx
  8019bc:	7e 05                	jle    8019c3 <vprintfmt+0x1f5>
  8019be:	83 fb 7e             	cmp    $0x7e,%ebx
  8019c1:	7e 12                	jle    8019d5 <vprintfmt+0x207>
					putch('?', putdat);
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	6a 3f                	push   $0x3f
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	ff d0                	call   *%eax
  8019d0:	83 c4 10             	add    $0x10,%esp
  8019d3:	eb 0f                	jmp    8019e4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	53                   	push   %ebx
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	ff d0                	call   *%eax
  8019e1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8019e7:	89 f0                	mov    %esi,%eax
  8019e9:	8d 70 01             	lea    0x1(%eax),%esi
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	0f be d8             	movsbl %al,%ebx
  8019f1:	85 db                	test   %ebx,%ebx
  8019f3:	74 24                	je     801a19 <vprintfmt+0x24b>
  8019f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019f9:	78 b8                	js     8019b3 <vprintfmt+0x1e5>
  8019fb:	ff 4d e0             	decl   -0x20(%ebp)
  8019fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a02:	79 af                	jns    8019b3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a04:	eb 13                	jmp    801a19 <vprintfmt+0x24b>
				putch(' ', putdat);
  801a06:	83 ec 08             	sub    $0x8,%esp
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	6a 20                	push   $0x20
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	ff d0                	call   *%eax
  801a13:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a16:	ff 4d e4             	decl   -0x1c(%ebp)
  801a19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a1d:	7f e7                	jg     801a06 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801a1f:	e9 78 01 00 00       	jmp    801b9c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801a24:	83 ec 08             	sub    $0x8,%esp
  801a27:	ff 75 e8             	pushl  -0x18(%ebp)
  801a2a:	8d 45 14             	lea    0x14(%ebp),%eax
  801a2d:	50                   	push   %eax
  801a2e:	e8 3c fd ff ff       	call   80176f <getint>
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a39:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	85 d2                	test   %edx,%edx
  801a44:	79 23                	jns    801a69 <vprintfmt+0x29b>
				putch('-', putdat);
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	6a 2d                	push   $0x2d
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	ff d0                	call   *%eax
  801a53:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5c:	f7 d8                	neg    %eax
  801a5e:	83 d2 00             	adc    $0x0,%edx
  801a61:	f7 da                	neg    %edx
  801a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801a69:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a70:	e9 bc 00 00 00       	jmp    801b31 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801a75:	83 ec 08             	sub    $0x8,%esp
  801a78:	ff 75 e8             	pushl  -0x18(%ebp)
  801a7b:	8d 45 14             	lea    0x14(%ebp),%eax
  801a7e:	50                   	push   %eax
  801a7f:	e8 84 fc ff ff       	call   801708 <getuint>
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801a8d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a94:	e9 98 00 00 00       	jmp    801b31 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	6a 58                	push   $0x58
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	ff d0                	call   *%eax
  801aa6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	ff 75 0c             	pushl  0xc(%ebp)
  801aaf:	6a 58                	push   $0x58
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	ff d0                	call   *%eax
  801ab6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ab9:	83 ec 08             	sub    $0x8,%esp
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	6a 58                	push   $0x58
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	ff d0                	call   *%eax
  801ac6:	83 c4 10             	add    $0x10,%esp
			break;
  801ac9:	e9 ce 00 00 00       	jmp    801b9c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801ace:	83 ec 08             	sub    $0x8,%esp
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	6a 30                	push   $0x30
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	ff d0                	call   *%eax
  801adb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801ade:	83 ec 08             	sub    $0x8,%esp
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	6a 78                	push   $0x78
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	ff d0                	call   *%eax
  801aeb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801aee:	8b 45 14             	mov    0x14(%ebp),%eax
  801af1:	83 c0 04             	add    $0x4,%eax
  801af4:	89 45 14             	mov    %eax,0x14(%ebp)
  801af7:	8b 45 14             	mov    0x14(%ebp),%eax
  801afa:	83 e8 04             	sub    $0x4,%eax
  801afd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801b09:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801b10:	eb 1f                	jmp    801b31 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801b12:	83 ec 08             	sub    $0x8,%esp
  801b15:	ff 75 e8             	pushl  -0x18(%ebp)
  801b18:	8d 45 14             	lea    0x14(%ebp),%eax
  801b1b:	50                   	push   %eax
  801b1c:	e8 e7 fb ff ff       	call   801708 <getuint>
  801b21:	83 c4 10             	add    $0x10,%esp
  801b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b27:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801b2a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801b31:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b38:	83 ec 04             	sub    $0x4,%esp
  801b3b:	52                   	push   %edx
  801b3c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b3f:	50                   	push   %eax
  801b40:	ff 75 f4             	pushl  -0xc(%ebp)
  801b43:	ff 75 f0             	pushl  -0x10(%ebp)
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	ff 75 08             	pushl  0x8(%ebp)
  801b4c:	e8 00 fb ff ff       	call   801651 <printnum>
  801b51:	83 c4 20             	add    $0x20,%esp
			break;
  801b54:	eb 46                	jmp    801b9c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801b56:	83 ec 08             	sub    $0x8,%esp
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	53                   	push   %ebx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	ff d0                	call   *%eax
  801b62:	83 c4 10             	add    $0x10,%esp
			break;
  801b65:	eb 35                	jmp    801b9c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801b67:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801b6e:	eb 2c                	jmp    801b9c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801b70:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801b77:	eb 23                	jmp    801b9c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801b79:	83 ec 08             	sub    $0x8,%esp
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	6a 25                	push   $0x25
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	ff d0                	call   *%eax
  801b86:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b89:	ff 4d 10             	decl   0x10(%ebp)
  801b8c:	eb 03                	jmp    801b91 <vprintfmt+0x3c3>
  801b8e:	ff 4d 10             	decl   0x10(%ebp)
  801b91:	8b 45 10             	mov    0x10(%ebp),%eax
  801b94:	48                   	dec    %eax
  801b95:	8a 00                	mov    (%eax),%al
  801b97:	3c 25                	cmp    $0x25,%al
  801b99:	75 f3                	jne    801b8e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801b9b:	90                   	nop
		}
	}
  801b9c:	e9 35 fc ff ff       	jmp    8017d6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801ba1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ba2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba5:	5b                   	pop    %ebx
  801ba6:	5e                   	pop    %esi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801baf:	8d 45 10             	lea    0x10(%ebp),%eax
  801bb2:	83 c0 04             	add    $0x4,%eax
  801bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801bbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	ff 75 08             	pushl  0x8(%ebp)
  801bc5:	e8 04 fc ff ff       	call   8017ce <vprintfmt>
  801bca:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801bcd:	90                   	nop
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd6:	8b 40 08             	mov    0x8(%eax),%eax
  801bd9:	8d 50 01             	lea    0x1(%eax),%edx
  801bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be5:	8b 10                	mov    (%eax),%edx
  801be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bea:	8b 40 04             	mov    0x4(%eax),%eax
  801bed:	39 c2                	cmp    %eax,%edx
  801bef:	73 12                	jae    801c03 <sprintputch+0x33>
		*b->buf++ = ch;
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	8b 00                	mov    (%eax),%eax
  801bf6:	8d 48 01             	lea    0x1(%eax),%ecx
  801bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfc:	89 0a                	mov    %ecx,(%edx)
  801bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  801c01:	88 10                	mov    %dl,(%eax)
}
  801c03:	90                   	nop
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    

00801c06 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	01 d0                	add    %edx,%eax
  801c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c2b:	74 06                	je     801c33 <vsnprintf+0x2d>
  801c2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c31:	7f 07                	jg     801c3a <vsnprintf+0x34>
		return -E_INVAL;
  801c33:	b8 03 00 00 00       	mov    $0x3,%eax
  801c38:	eb 20                	jmp    801c5a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c3a:	ff 75 14             	pushl  0x14(%ebp)
  801c3d:	ff 75 10             	pushl  0x10(%ebp)
  801c40:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c43:	50                   	push   %eax
  801c44:	68 d0 1b 80 00       	push   $0x801bd0
  801c49:	e8 80 fb ff ff       	call   8017ce <vprintfmt>
  801c4e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c54:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c62:	8d 45 10             	lea    0x10(%ebp),%eax
  801c65:	83 c0 04             	add    $0x4,%eax
  801c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c71:	50                   	push   %eax
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	e8 89 ff ff ff       	call   801c06 <vsnprintf>
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801c8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c95:	eb 06                	jmp    801c9d <strlen+0x15>
		n++;
  801c97:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801c9a:	ff 45 08             	incl   0x8(%ebp)
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	8a 00                	mov    (%eax),%al
  801ca2:	84 c0                	test   %al,%al
  801ca4:	75 f1                	jne    801c97 <strlen+0xf>
		n++;
	return n;
  801ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cb8:	eb 09                	jmp    801cc3 <strnlen+0x18>
		n++;
  801cba:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cbd:	ff 45 08             	incl   0x8(%ebp)
  801cc0:	ff 4d 0c             	decl   0xc(%ebp)
  801cc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cc7:	74 09                	je     801cd2 <strnlen+0x27>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	84 c0                	test   %al,%al
  801cd0:	75 e8                	jne    801cba <strnlen+0xf>
		n++;
	return n;
  801cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801ce3:	90                   	nop
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8d 50 01             	lea    0x1(%eax),%edx
  801cea:	89 55 08             	mov    %edx,0x8(%ebp)
  801ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf0:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cf3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cf6:	8a 12                	mov    (%edx),%dl
  801cf8:	88 10                	mov    %dl,(%eax)
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	75 e4                	jne    801ce4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d18:	eb 1f                	jmp    801d39 <strncpy+0x34>
		*dst++ = *src;
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	8d 50 01             	lea    0x1(%eax),%edx
  801d20:	89 55 08             	mov    %edx,0x8(%ebp)
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8a 12                	mov    (%edx),%dl
  801d28:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	84 c0                	test   %al,%al
  801d31:	74 03                	je     801d36 <strncpy+0x31>
			src++;
  801d33:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d36:	ff 45 fc             	incl   -0x4(%ebp)
  801d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d3c:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d3f:	72 d9                	jb     801d1a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801d41:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801d52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d56:	74 30                	je     801d88 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801d58:	eb 16                	jmp    801d70 <strlcpy+0x2a>
			*dst++ = *src++;
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	8d 50 01             	lea    0x1(%eax),%edx
  801d60:	89 55 08             	mov    %edx,0x8(%ebp)
  801d63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d66:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d6c:	8a 12                	mov    (%edx),%dl
  801d6e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801d70:	ff 4d 10             	decl   0x10(%ebp)
  801d73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d77:	74 09                	je     801d82 <strlcpy+0x3c>
  801d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7c:	8a 00                	mov    (%eax),%al
  801d7e:	84 c0                	test   %al,%al
  801d80:	75 d8                	jne    801d5a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d88:	8b 55 08             	mov    0x8(%ebp),%edx
  801d8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d8e:	29 c2                	sub    %eax,%edx
  801d90:	89 d0                	mov    %edx,%eax
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801d97:	eb 06                	jmp    801d9f <strcmp+0xb>
		p++, q++;
  801d99:	ff 45 08             	incl   0x8(%ebp)
  801d9c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	8a 00                	mov    (%eax),%al
  801da4:	84 c0                	test   %al,%al
  801da6:	74 0e                	je     801db6 <strcmp+0x22>
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	8a 10                	mov    (%eax),%dl
  801dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db0:	8a 00                	mov    (%eax),%al
  801db2:	38 c2                	cmp    %al,%dl
  801db4:	74 e3                	je     801d99 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	8a 00                	mov    (%eax),%al
  801dbb:	0f b6 d0             	movzbl %al,%edx
  801dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc1:	8a 00                	mov    (%eax),%al
  801dc3:	0f b6 c0             	movzbl %al,%eax
  801dc6:	29 c2                	sub    %eax,%edx
  801dc8:	89 d0                	mov    %edx,%eax
}
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    

00801dcc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801dcf:	eb 09                	jmp    801dda <strncmp+0xe>
		n--, p++, q++;
  801dd1:	ff 4d 10             	decl   0x10(%ebp)
  801dd4:	ff 45 08             	incl   0x8(%ebp)
  801dd7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dde:	74 17                	je     801df7 <strncmp+0x2b>
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	8a 00                	mov    (%eax),%al
  801de5:	84 c0                	test   %al,%al
  801de7:	74 0e                	je     801df7 <strncmp+0x2b>
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	8a 10                	mov    (%eax),%dl
  801dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df1:	8a 00                	mov    (%eax),%al
  801df3:	38 c2                	cmp    %al,%dl
  801df5:	74 da                	je     801dd1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801df7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dfb:	75 07                	jne    801e04 <strncmp+0x38>
		return 0;
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801e02:	eb 14                	jmp    801e18 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	8a 00                	mov    (%eax),%al
  801e09:	0f b6 d0             	movzbl %al,%edx
  801e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	0f b6 c0             	movzbl %al,%eax
  801e14:	29 c2                	sub    %eax,%edx
  801e16:	89 d0                	mov    %edx,%eax
}
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    

00801e1a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 04             	sub    $0x4,%esp
  801e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e23:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e26:	eb 12                	jmp    801e3a <strchr+0x20>
		if (*s == c)
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	8a 00                	mov    (%eax),%al
  801e2d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e30:	75 05                	jne    801e37 <strchr+0x1d>
			return (char *) s;
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	eb 11                	jmp    801e48 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801e37:	ff 45 08             	incl   0x8(%ebp)
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	8a 00                	mov    (%eax),%al
  801e3f:	84 c0                	test   %al,%al
  801e41:	75 e5                	jne    801e28 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 04             	sub    $0x4,%esp
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e56:	eb 0d                	jmp    801e65 <strfind+0x1b>
		if (*s == c)
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	8a 00                	mov    (%eax),%al
  801e5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e60:	74 0e                	je     801e70 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801e62:	ff 45 08             	incl   0x8(%ebp)
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	8a 00                	mov    (%eax),%al
  801e6a:	84 c0                	test   %al,%al
  801e6c:	75 ea                	jne    801e58 <strfind+0xe>
  801e6e:	eb 01                	jmp    801e71 <strfind+0x27>
		if (*s == c)
			break;
  801e70:	90                   	nop
	return (char *) s;
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801e82:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801e86:	76 63                	jbe    801eeb <memset+0x75>
		uint64 data_block = c;
  801e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8b:	99                   	cltd   
  801e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e98:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801e9c:	c1 e0 08             	shl    $0x8,%eax
  801e9f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801ea2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eab:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801eaf:	c1 e0 10             	shl    $0x10,%eax
  801eb2:	09 45 f0             	or     %eax,-0x10(%ebp)
  801eb5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebe:	89 c2                	mov    %eax,%edx
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec5:	09 45 f0             	or     %eax,-0x10(%ebp)
  801ec8:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801ecb:	eb 18                	jmp    801ee5 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801ecd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ed0:	8d 41 08             	lea    0x8(%ecx),%eax
  801ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	89 01                	mov    %eax,(%ecx)
  801ede:	89 51 04             	mov    %edx,0x4(%ecx)
  801ee1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801ee5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ee9:	77 e2                	ja     801ecd <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801eeb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eef:	74 23                	je     801f14 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801ef7:	eb 0e                	jmp    801f07 <memset+0x91>
			*p8++ = (uint8)c;
  801ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801efc:	8d 50 01             	lea    0x1(%eax),%edx
  801eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f05:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801f07:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  801f10:	85 c0                	test   %eax,%eax
  801f12:	75 e5                	jne    801ef9 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801f2b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f2f:	76 24                	jbe    801f55 <memcpy+0x3c>
		while(n >= 8){
  801f31:	eb 1c                	jmp    801f4f <memcpy+0x36>
			*d64 = *s64;
  801f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f36:	8b 50 04             	mov    0x4(%eax),%edx
  801f39:	8b 00                	mov    (%eax),%eax
  801f3b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f3e:	89 01                	mov    %eax,(%ecx)
  801f40:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801f43:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801f47:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801f4b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801f4f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f53:	77 de                	ja     801f33 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801f55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f59:	74 31                	je     801f8c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801f67:	eb 16                	jmp    801f7f <memcpy+0x66>
			*d8++ = *s8++;
  801f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6c:	8d 50 01             	lea    0x1(%eax),%edx
  801f6f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f75:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f78:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801f7b:	8a 12                	mov    (%edx),%dl
  801f7d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f85:	89 55 10             	mov    %edx,0x10(%ebp)
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	75 dd                	jne    801f69 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fa9:	73 50                	jae    801ffb <memmove+0x6a>
  801fab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fae:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb1:	01 d0                	add    %edx,%eax
  801fb3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fb6:	76 43                	jbe    801ffb <memmove+0x6a>
		s += n;
  801fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fc4:	eb 10                	jmp    801fd6 <memmove+0x45>
			*--d = *--s;
  801fc6:	ff 4d f8             	decl   -0x8(%ebp)
  801fc9:	ff 4d fc             	decl   -0x4(%ebp)
  801fcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcf:	8a 10                	mov    (%eax),%dl
  801fd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fd4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fdc:	89 55 10             	mov    %edx,0x10(%ebp)
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	75 e3                	jne    801fc6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801fe3:	eb 23                	jmp    802008 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801fe5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fe8:	8d 50 01             	lea    0x1(%eax),%edx
  801feb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff1:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ff4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ff7:	8a 12                	mov    (%edx),%dl
  801ff9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffe:	8d 50 ff             	lea    -0x1(%eax),%edx
  802001:	89 55 10             	mov    %edx,0x10(%ebp)
  802004:	85 c0                	test   %eax,%eax
  802006:	75 dd                	jne    801fe5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80201f:	eb 2a                	jmp    80204b <memcmp+0x3e>
		if (*s1 != *s2)
  802021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802024:	8a 10                	mov    (%eax),%dl
  802026:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802029:	8a 00                	mov    (%eax),%al
  80202b:	38 c2                	cmp    %al,%dl
  80202d:	74 16                	je     802045 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80202f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802032:	8a 00                	mov    (%eax),%al
  802034:	0f b6 d0             	movzbl %al,%edx
  802037:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80203a:	8a 00                	mov    (%eax),%al
  80203c:	0f b6 c0             	movzbl %al,%eax
  80203f:	29 c2                	sub    %eax,%edx
  802041:	89 d0                	mov    %edx,%eax
  802043:	eb 18                	jmp    80205d <memcmp+0x50>
		s1++, s2++;
  802045:	ff 45 fc             	incl   -0x4(%ebp)
  802048:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80204b:	8b 45 10             	mov    0x10(%ebp),%eax
  80204e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802051:	89 55 10             	mov    %edx,0x10(%ebp)
  802054:	85 c0                	test   %eax,%eax
  802056:	75 c9                	jne    802021 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802065:	8b 55 08             	mov    0x8(%ebp),%edx
  802068:	8b 45 10             	mov    0x10(%ebp),%eax
  80206b:	01 d0                	add    %edx,%eax
  80206d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802070:	eb 15                	jmp    802087 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	8a 00                	mov    (%eax),%al
  802077:	0f b6 d0             	movzbl %al,%edx
  80207a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207d:	0f b6 c0             	movzbl %al,%eax
  802080:	39 c2                	cmp    %eax,%edx
  802082:	74 0d                	je     802091 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802084:	ff 45 08             	incl   0x8(%ebp)
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80208d:	72 e3                	jb     802072 <memfind+0x13>
  80208f:	eb 01                	jmp    802092 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802091:	90                   	nop
	return (void *) s;
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80209d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020ab:	eb 03                	jmp    8020b0 <strtol+0x19>
		s++;
  8020ad:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	8a 00                	mov    (%eax),%al
  8020b5:	3c 20                	cmp    $0x20,%al
  8020b7:	74 f4                	je     8020ad <strtol+0x16>
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	8a 00                	mov    (%eax),%al
  8020be:	3c 09                	cmp    $0x9,%al
  8020c0:	74 eb                	je     8020ad <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	8a 00                	mov    (%eax),%al
  8020c7:	3c 2b                	cmp    $0x2b,%al
  8020c9:	75 05                	jne    8020d0 <strtol+0x39>
		s++;
  8020cb:	ff 45 08             	incl   0x8(%ebp)
  8020ce:	eb 13                	jmp    8020e3 <strtol+0x4c>
	else if (*s == '-')
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	8a 00                	mov    (%eax),%al
  8020d5:	3c 2d                	cmp    $0x2d,%al
  8020d7:	75 0a                	jne    8020e3 <strtol+0x4c>
		s++, neg = 1;
  8020d9:	ff 45 08             	incl   0x8(%ebp)
  8020dc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e7:	74 06                	je     8020ef <strtol+0x58>
  8020e9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8020ed:	75 20                	jne    80210f <strtol+0x78>
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8a 00                	mov    (%eax),%al
  8020f4:	3c 30                	cmp    $0x30,%al
  8020f6:	75 17                	jne    80210f <strtol+0x78>
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	40                   	inc    %eax
  8020fc:	8a 00                	mov    (%eax),%al
  8020fe:	3c 78                	cmp    $0x78,%al
  802100:	75 0d                	jne    80210f <strtol+0x78>
		s += 2, base = 16;
  802102:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802106:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80210d:	eb 28                	jmp    802137 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80210f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802113:	75 15                	jne    80212a <strtol+0x93>
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	8a 00                	mov    (%eax),%al
  80211a:	3c 30                	cmp    $0x30,%al
  80211c:	75 0c                	jne    80212a <strtol+0x93>
		s++, base = 8;
  80211e:	ff 45 08             	incl   0x8(%ebp)
  802121:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802128:	eb 0d                	jmp    802137 <strtol+0xa0>
	else if (base == 0)
  80212a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80212e:	75 07                	jne    802137 <strtol+0xa0>
		base = 10;
  802130:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	8a 00                	mov    (%eax),%al
  80213c:	3c 2f                	cmp    $0x2f,%al
  80213e:	7e 19                	jle    802159 <strtol+0xc2>
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	8a 00                	mov    (%eax),%al
  802145:	3c 39                	cmp    $0x39,%al
  802147:	7f 10                	jg     802159 <strtol+0xc2>
			dig = *s - '0';
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8a 00                	mov    (%eax),%al
  80214e:	0f be c0             	movsbl %al,%eax
  802151:	83 e8 30             	sub    $0x30,%eax
  802154:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802157:	eb 42                	jmp    80219b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	8a 00                	mov    (%eax),%al
  80215e:	3c 60                	cmp    $0x60,%al
  802160:	7e 19                	jle    80217b <strtol+0xe4>
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	8a 00                	mov    (%eax),%al
  802167:	3c 7a                	cmp    $0x7a,%al
  802169:	7f 10                	jg     80217b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8a 00                	mov    (%eax),%al
  802170:	0f be c0             	movsbl %al,%eax
  802173:	83 e8 57             	sub    $0x57,%eax
  802176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802179:	eb 20                	jmp    80219b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8a 00                	mov    (%eax),%al
  802180:	3c 40                	cmp    $0x40,%al
  802182:	7e 39                	jle    8021bd <strtol+0x126>
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	8a 00                	mov    (%eax),%al
  802189:	3c 5a                	cmp    $0x5a,%al
  80218b:	7f 30                	jg     8021bd <strtol+0x126>
			dig = *s - 'A' + 10;
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8a 00                	mov    (%eax),%al
  802192:	0f be c0             	movsbl %al,%eax
  802195:	83 e8 37             	sub    $0x37,%eax
  802198:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021a1:	7d 19                	jge    8021bc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021a3:	ff 45 08             	incl   0x8(%ebp)
  8021a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021a9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021ad:	89 c2                	mov    %eax,%edx
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	01 d0                	add    %edx,%eax
  8021b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021b7:	e9 7b ff ff ff       	jmp    802137 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021bc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021c1:	74 08                	je     8021cb <strtol+0x134>
		*endptr = (char *) s;
  8021c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021cf:	74 07                	je     8021d8 <strtol+0x141>
  8021d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d4:	f7 d8                	neg    %eax
  8021d6:	eb 03                	jmp    8021db <strtol+0x144>
  8021d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <ltostr>:

void
ltostr(long value, char *str)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8021e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8021ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8021f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f5:	79 13                	jns    80220a <ltostr+0x2d>
	{
		neg = 1;
  8021f7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8021fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802201:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802204:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802207:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802212:	99                   	cltd   
  802213:	f7 f9                	idiv   %ecx
  802215:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802218:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80221b:	8d 50 01             	lea    0x1(%eax),%edx
  80221e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802221:	89 c2                	mov    %eax,%edx
  802223:	8b 45 0c             	mov    0xc(%ebp),%eax
  802226:	01 d0                	add    %edx,%eax
  802228:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80222b:	83 c2 30             	add    $0x30,%edx
  80222e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802230:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802233:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802238:	f7 e9                	imul   %ecx
  80223a:	c1 fa 02             	sar    $0x2,%edx
  80223d:	89 c8                	mov    %ecx,%eax
  80223f:	c1 f8 1f             	sar    $0x1f,%eax
  802242:	29 c2                	sub    %eax,%edx
  802244:	89 d0                	mov    %edx,%eax
  802246:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224d:	75 bb                	jne    80220a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80224f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802256:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802259:	48                   	dec    %eax
  80225a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80225d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802261:	74 3d                	je     8022a0 <ltostr+0xc3>
		start = 1 ;
  802263:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80226a:	eb 34                	jmp    8022a0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80226c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802272:	01 d0                	add    %edx,%eax
  802274:	8a 00                	mov    (%eax),%al
  802276:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802279:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227f:	01 c2                	add    %eax,%edx
  802281:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802284:	8b 45 0c             	mov    0xc(%ebp),%eax
  802287:	01 c8                	add    %ecx,%eax
  802289:	8a 00                	mov    (%eax),%al
  80228b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80228d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802290:	8b 45 0c             	mov    0xc(%ebp),%eax
  802293:	01 c2                	add    %eax,%edx
  802295:	8a 45 eb             	mov    -0x15(%ebp),%al
  802298:	88 02                	mov    %al,(%edx)
		start++ ;
  80229a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80229d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022a6:	7c c4                	jl     80226c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ae:	01 d0                	add    %edx,%eax
  8022b0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022b3:	90                   	nop
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8022bc:	ff 75 08             	pushl  0x8(%ebp)
  8022bf:	e8 c4 f9 ff ff       	call   801c88 <strlen>
  8022c4:	83 c4 04             	add    $0x4,%esp
  8022c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8022ca:	ff 75 0c             	pushl  0xc(%ebp)
  8022cd:	e8 b6 f9 ff ff       	call   801c88 <strlen>
  8022d2:	83 c4 04             	add    $0x4,%esp
  8022d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8022d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8022df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022e6:	eb 17                	jmp    8022ff <strcconcat+0x49>
		final[s] = str1[s] ;
  8022e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ee:	01 c2                	add    %eax,%edx
  8022f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	01 c8                	add    %ecx,%eax
  8022f8:	8a 00                	mov    (%eax),%al
  8022fa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8022fc:	ff 45 fc             	incl   -0x4(%ebp)
  8022ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802302:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802305:	7c e1                	jl     8022e8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802307:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80230e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802315:	eb 1f                	jmp    802336 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802317:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80231a:	8d 50 01             	lea    0x1(%eax),%edx
  80231d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802320:	89 c2                	mov    %eax,%edx
  802322:	8b 45 10             	mov    0x10(%ebp),%eax
  802325:	01 c2                	add    %eax,%edx
  802327:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80232a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232d:	01 c8                	add    %ecx,%eax
  80232f:	8a 00                	mov    (%eax),%al
  802331:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802333:	ff 45 f8             	incl   -0x8(%ebp)
  802336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802339:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80233c:	7c d9                	jl     802317 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80233e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802341:	8b 45 10             	mov    0x10(%ebp),%eax
  802344:	01 d0                	add    %edx,%eax
  802346:	c6 00 00             	movb   $0x0,(%eax)
}
  802349:	90                   	nop
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80234f:	8b 45 14             	mov    0x14(%ebp),%eax
  802352:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802358:	8b 45 14             	mov    0x14(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802364:	8b 45 10             	mov    0x10(%ebp),%eax
  802367:	01 d0                	add    %edx,%eax
  802369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80236f:	eb 0c                	jmp    80237d <strsplit+0x31>
			*string++ = 0;
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8d 50 01             	lea    0x1(%eax),%edx
  802377:	89 55 08             	mov    %edx,0x8(%ebp)
  80237a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	8a 00                	mov    (%eax),%al
  802382:	84 c0                	test   %al,%al
  802384:	74 18                	je     80239e <strsplit+0x52>
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	8a 00                	mov    (%eax),%al
  80238b:	0f be c0             	movsbl %al,%eax
  80238e:	50                   	push   %eax
  80238f:	ff 75 0c             	pushl  0xc(%ebp)
  802392:	e8 83 fa ff ff       	call   801e1a <strchr>
  802397:	83 c4 08             	add    $0x8,%esp
  80239a:	85 c0                	test   %eax,%eax
  80239c:	75 d3                	jne    802371 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	8a 00                	mov    (%eax),%al
  8023a3:	84 c0                	test   %al,%al
  8023a5:	74 5a                	je     802401 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	83 f8 0f             	cmp    $0xf,%eax
  8023af:	75 07                	jne    8023b8 <strsplit+0x6c>
		{
			return 0;
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b6:	eb 66                	jmp    80241e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8023c0:	8b 55 14             	mov    0x14(%ebp),%edx
  8023c3:	89 0a                	mov    %ecx,(%edx)
  8023c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cf:	01 c2                	add    %eax,%edx
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023d6:	eb 03                	jmp    8023db <strsplit+0x8f>
			string++;
  8023d8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	8a 00                	mov    (%eax),%al
  8023e0:	84 c0                	test   %al,%al
  8023e2:	74 8b                	je     80236f <strsplit+0x23>
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	8a 00                	mov    (%eax),%al
  8023e9:	0f be c0             	movsbl %al,%eax
  8023ec:	50                   	push   %eax
  8023ed:	ff 75 0c             	pushl  0xc(%ebp)
  8023f0:	e8 25 fa ff ff       	call   801e1a <strchr>
  8023f5:	83 c4 08             	add    $0x8,%esp
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 dc                	je     8023d8 <strsplit+0x8c>
			string++;
	}
  8023fc:	e9 6e ff ff ff       	jmp    80236f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802401:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802402:	8b 45 14             	mov    0x14(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80240e:	8b 45 10             	mov    0x10(%ebp),%eax
  802411:	01 d0                	add    %edx,%eax
  802413:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802419:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80242c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802433:	eb 4a                	jmp    80247f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802435:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	01 c2                	add    %eax,%edx
  80243d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802440:	8b 45 0c             	mov    0xc(%ebp),%eax
  802443:	01 c8                	add    %ecx,%eax
  802445:	8a 00                	mov    (%eax),%al
  802447:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802449:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80244c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244f:	01 d0                	add    %edx,%eax
  802451:	8a 00                	mov    (%eax),%al
  802453:	3c 40                	cmp    $0x40,%al
  802455:	7e 25                	jle    80247c <str2lower+0x5c>
  802457:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80245a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245d:	01 d0                	add    %edx,%eax
  80245f:	8a 00                	mov    (%eax),%al
  802461:	3c 5a                	cmp    $0x5a,%al
  802463:	7f 17                	jg     80247c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802465:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	01 d0                	add    %edx,%eax
  80246d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802470:	8b 55 08             	mov    0x8(%ebp),%edx
  802473:	01 ca                	add    %ecx,%edx
  802475:	8a 12                	mov    (%edx),%dl
  802477:	83 c2 20             	add    $0x20,%edx
  80247a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80247c:	ff 45 fc             	incl   -0x4(%ebp)
  80247f:	ff 75 0c             	pushl  0xc(%ebp)
  802482:	e8 01 f8 ff ff       	call   801c88 <strlen>
  802487:	83 c4 04             	add    $0x4,%esp
  80248a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80248d:	7f a6                	jg     802435 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80248f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80249a:	a1 08 50 80 00       	mov    0x805008,%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 42                	je     8024e5 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8024a3:	83 ec 08             	sub    $0x8,%esp
  8024a6:	68 00 00 00 82       	push   $0x82000000
  8024ab:	68 00 00 00 80       	push   $0x80000000
  8024b0:	e8 00 08 00 00       	call   802cb5 <initialize_dynamic_allocator>
  8024b5:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8024b8:	e8 e7 05 00 00       	call   802aa4 <sys_get_uheap_strategy>
  8024bd:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8024c2:	a1 20 52 80 00       	mov    0x805220,%eax
  8024c7:	05 00 10 00 00       	add    $0x1000,%eax
  8024cc:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8024d1:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  8024d6:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  8024db:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8024e2:	00 00 00 
	}
}
  8024e5:	90                   	nop
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024fc:	83 ec 08             	sub    $0x8,%esp
  8024ff:	68 06 04 00 00       	push   $0x406
  802504:	50                   	push   %eax
  802505:	e8 e4 01 00 00       	call   8026ee <__sys_allocate_page>
  80250a:	83 c4 10             	add    $0x10,%esp
  80250d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802514:	79 14                	jns    80252a <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	68 28 44 80 00       	push   $0x804428
  80251e:	6a 1f                	push   $0x1f
  802520:	68 64 44 80 00       	push   $0x804464
  802525:	e8 b7 ed ff ff       	call   8012e1 <_panic>
	return 0;
  80252a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802537:	8b 45 08             	mov    0x8(%ebp),%eax
  80253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802545:	83 ec 0c             	sub    $0xc,%esp
  802548:	50                   	push   %eax
  802549:	e8 e7 01 00 00       	call   802735 <__sys_unmap_frame>
  80254e:	83 c4 10             	add    $0x10,%esp
  802551:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802554:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802558:	79 14                	jns    80256e <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80255a:	83 ec 04             	sub    $0x4,%esp
  80255d:	68 70 44 80 00       	push   $0x804470
  802562:	6a 2a                	push   $0x2a
  802564:	68 64 44 80 00       	push   $0x804464
  802569:	e8 73 ed ff ff       	call   8012e1 <_panic>
}
  80256e:	90                   	nop
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802577:	e8 18 ff ff ff       	call   802494 <uheap_init>
	if (size == 0) return NULL ;
  80257c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802580:	75 07                	jne    802589 <malloc+0x18>
  802582:	b8 00 00 00 00       	mov    $0x0,%eax
  802587:	eb 14                	jmp    80259d <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 b0 44 80 00       	push   $0x8044b0
  802591:	6a 3e                	push   $0x3e
  802593:	68 64 44 80 00       	push   $0x804464
  802598:	e8 44 ed ff ff       	call   8012e1 <_panic>
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8025a5:	83 ec 04             	sub    $0x4,%esp
  8025a8:	68 d8 44 80 00       	push   $0x8044d8
  8025ad:	6a 49                	push   $0x49
  8025af:	68 64 44 80 00       	push   $0x804464
  8025b4:	e8 28 ed ff ff       	call   8012e1 <_panic>

008025b9 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	83 ec 18             	sub    $0x18,%esp
  8025bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c2:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025c5:	e8 ca fe ff ff       	call   802494 <uheap_init>
	if (size == 0) return NULL ;
  8025ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025ce:	75 07                	jne    8025d7 <smalloc+0x1e>
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	eb 14                	jmp    8025eb <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8025d7:	83 ec 04             	sub    $0x4,%esp
  8025da:	68 fc 44 80 00       	push   $0x8044fc
  8025df:	6a 5a                	push   $0x5a
  8025e1:	68 64 44 80 00       	push   $0x804464
  8025e6:	e8 f6 ec ff ff       	call   8012e1 <_panic>
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
  8025f0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025f3:	e8 9c fe ff ff       	call   802494 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 24 45 80 00       	push   $0x804524
  802600:	6a 6a                	push   $0x6a
  802602:	68 64 44 80 00       	push   $0x804464
  802607:	e8 d5 ec ff ff       	call   8012e1 <_panic>

0080260c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
  80260f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802612:	e8 7d fe ff ff       	call   802494 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802617:	83 ec 04             	sub    $0x4,%esp
  80261a:	68 48 45 80 00       	push   $0x804548
  80261f:	68 88 00 00 00       	push   $0x88
  802624:	68 64 44 80 00       	push   $0x804464
  802629:	e8 b3 ec ff ff       	call   8012e1 <_panic>

0080262e <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802634:	83 ec 04             	sub    $0x4,%esp
  802637:	68 70 45 80 00       	push   $0x804570
  80263c:	68 9b 00 00 00       	push   $0x9b
  802641:	68 64 44 80 00       	push   $0x804464
  802646:	e8 96 ec ff ff       	call   8012e1 <_panic>

0080264b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	57                   	push   %edi
  80264f:	56                   	push   %esi
  802650:	53                   	push   %ebx
  802651:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80265d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802660:	8b 7d 18             	mov    0x18(%ebp),%edi
  802663:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802666:	cd 30                	int    $0x30
  802668:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80266b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80266e:	83 c4 10             	add    $0x10,%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    

00802676 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 04             	sub    $0x4,%esp
  80267c:	8b 45 10             	mov    0x10(%ebp),%eax
  80267f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802682:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802685:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	6a 00                	push   $0x0
  80268e:	51                   	push   %ecx
  80268f:	52                   	push   %edx
  802690:	ff 75 0c             	pushl  0xc(%ebp)
  802693:	50                   	push   %eax
  802694:	6a 00                	push   $0x0
  802696:	e8 b0 ff ff ff       	call   80264b <syscall>
  80269b:	83 c4 18             	add    $0x18,%esp
}
  80269e:	90                   	nop
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 02                	push   $0x2
  8026b0:	e8 96 ff ff ff       	call   80264b <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <sys_lock_cons>:

void sys_lock_cons(void)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 03                	push   $0x3
  8026c9:	e8 7d ff ff ff       	call   80264b <syscall>
  8026ce:	83 c4 18             	add    $0x18,%esp
}
  8026d1:	90                   	nop
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 04                	push   $0x4
  8026e3:	e8 63 ff ff ff       	call   80264b <syscall>
  8026e8:	83 c4 18             	add    $0x18,%esp
}
  8026eb:	90                   	nop
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	52                   	push   %edx
  8026fe:	50                   	push   %eax
  8026ff:	6a 08                	push   $0x8
  802701:	e8 45 ff ff ff       	call   80264b <syscall>
  802706:	83 c4 18             	add    $0x18,%esp
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	56                   	push   %esi
  80270f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802710:	8b 75 18             	mov    0x18(%ebp),%esi
  802713:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802716:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	56                   	push   %esi
  802720:	53                   	push   %ebx
  802721:	51                   	push   %ecx
  802722:	52                   	push   %edx
  802723:	50                   	push   %eax
  802724:	6a 09                	push   $0x9
  802726:	e8 20 ff ff ff       	call   80264b <syscall>
  80272b:	83 c4 18             	add    $0x18,%esp
}
  80272e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    

00802735 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	ff 75 08             	pushl  0x8(%ebp)
  802743:	6a 0a                	push   $0xa
  802745:	e8 01 ff ff ff       	call   80264b <syscall>
  80274a:	83 c4 18             	add    $0x18,%esp
}
  80274d:	c9                   	leave  
  80274e:	c3                   	ret    

0080274f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	ff 75 0c             	pushl  0xc(%ebp)
  80275b:	ff 75 08             	pushl  0x8(%ebp)
  80275e:	6a 0b                	push   $0xb
  802760:	e8 e6 fe ff ff       	call   80264b <syscall>
  802765:	83 c4 18             	add    $0x18,%esp
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 0c                	push   $0xc
  802779:	e8 cd fe ff ff       	call   80264b <syscall>
  80277e:	83 c4 18             	add    $0x18,%esp
}
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 0d                	push   $0xd
  802792:	e8 b4 fe ff ff       	call   80264b <syscall>
  802797:	83 c4 18             	add    $0x18,%esp
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 0e                	push   $0xe
  8027ab:	e8 9b fe ff ff       	call   80264b <syscall>
  8027b0:	83 c4 18             	add    $0x18,%esp
}
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    

008027b5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 0f                	push   $0xf
  8027c4:	e8 82 fe ff ff       	call   80264b <syscall>
  8027c9:	83 c4 18             	add    $0x18,%esp
}
  8027cc:	c9                   	leave  
  8027cd:	c3                   	ret    

008027ce <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027ce:	55                   	push   %ebp
  8027cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	ff 75 08             	pushl  0x8(%ebp)
  8027dc:	6a 10                	push   $0x10
  8027de:	e8 68 fe ff ff       	call   80264b <syscall>
  8027e3:	83 c4 18             	add    $0x18,%esp
}
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 11                	push   $0x11
  8027f7:	e8 4f fe ff ff       	call   80264b <syscall>
  8027fc:	83 c4 18             	add    $0x18,%esp
}
  8027ff:	90                   	nop
  802800:	c9                   	leave  
  802801:	c3                   	ret    

00802802 <sys_cputc>:

void
sys_cputc(const char c)
{
  802802:	55                   	push   %ebp
  802803:	89 e5                	mov    %esp,%ebp
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80280e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	50                   	push   %eax
  80281b:	6a 01                	push   $0x1
  80281d:	e8 29 fe ff ff       	call   80264b <syscall>
  802822:	83 c4 18             	add    $0x18,%esp
}
  802825:	90                   	nop
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 14                	push   $0x14
  802837:	e8 0f fe ff ff       	call   80264b <syscall>
  80283c:	83 c4 18             	add    $0x18,%esp
}
  80283f:	90                   	nop
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	8b 45 10             	mov    0x10(%ebp),%eax
  80284b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80284e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802851:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	6a 00                	push   $0x0
  80285a:	51                   	push   %ecx
  80285b:	52                   	push   %edx
  80285c:	ff 75 0c             	pushl  0xc(%ebp)
  80285f:	50                   	push   %eax
  802860:	6a 15                	push   $0x15
  802862:	e8 e4 fd ff ff       	call   80264b <syscall>
  802867:	83 c4 18             	add    $0x18,%esp
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80286f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	52                   	push   %edx
  80287c:	50                   	push   %eax
  80287d:	6a 16                	push   $0x16
  80287f:	e8 c7 fd ff ff       	call   80264b <syscall>
  802884:	83 c4 18             	add    $0x18,%esp
}
  802887:	c9                   	leave  
  802888:	c3                   	ret    

00802889 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80288c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80288f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	51                   	push   %ecx
  80289a:	52                   	push   %edx
  80289b:	50                   	push   %eax
  80289c:	6a 17                	push   $0x17
  80289e:	e8 a8 fd ff ff       	call   80264b <syscall>
  8028a3:	83 c4 18             	add    $0x18,%esp
}
  8028a6:	c9                   	leave  
  8028a7:	c3                   	ret    

008028a8 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	52                   	push   %edx
  8028b8:	50                   	push   %eax
  8028b9:	6a 18                	push   $0x18
  8028bb:	e8 8b fd ff ff       	call   80264b <syscall>
  8028c0:	83 c4 18             	add    $0x18,%esp
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	6a 00                	push   $0x0
  8028cd:	ff 75 14             	pushl  0x14(%ebp)
  8028d0:	ff 75 10             	pushl  0x10(%ebp)
  8028d3:	ff 75 0c             	pushl  0xc(%ebp)
  8028d6:	50                   	push   %eax
  8028d7:	6a 19                	push   $0x19
  8028d9:	e8 6d fd ff ff       	call   80264b <syscall>
  8028de:	83 c4 18             	add    $0x18,%esp
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	50                   	push   %eax
  8028f2:	6a 1a                	push   $0x1a
  8028f4:	e8 52 fd ff ff       	call   80264b <syscall>
  8028f9:	83 c4 18             	add    $0x18,%esp
}
  8028fc:	90                   	nop
  8028fd:	c9                   	leave  
  8028fe:	c3                   	ret    

008028ff <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8028ff:	55                   	push   %ebp
  802900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	50                   	push   %eax
  80290e:	6a 1b                	push   $0x1b
  802910:	e8 36 fd ff ff       	call   80264b <syscall>
  802915:	83 c4 18             	add    $0x18,%esp
}
  802918:	c9                   	leave  
  802919:	c3                   	ret    

0080291a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 05                	push   $0x5
  802929:	e8 1d fd ff ff       	call   80264b <syscall>
  80292e:	83 c4 18             	add    $0x18,%esp
}
  802931:	c9                   	leave  
  802932:	c3                   	ret    

00802933 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802933:	55                   	push   %ebp
  802934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802936:	6a 00                	push   $0x0
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 06                	push   $0x6
  802942:	e8 04 fd ff ff       	call   80264b <syscall>
  802947:	83 c4 18             	add    $0x18,%esp
}
  80294a:	c9                   	leave  
  80294b:	c3                   	ret    

0080294c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 07                	push   $0x7
  80295b:	e8 eb fc ff ff       	call   80264b <syscall>
  802960:	83 c4 18             	add    $0x18,%esp
}
  802963:	c9                   	leave  
  802964:	c3                   	ret    

00802965 <sys_exit_env>:


void sys_exit_env(void)
{
  802965:	55                   	push   %ebp
  802966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802968:	6a 00                	push   $0x0
  80296a:	6a 00                	push   $0x0
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	6a 1c                	push   $0x1c
  802974:	e8 d2 fc ff ff       	call   80264b <syscall>
  802979:	83 c4 18             	add    $0x18,%esp
}
  80297c:	90                   	nop
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80297f:	55                   	push   %ebp
  802980:	89 e5                	mov    %esp,%ebp
  802982:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802985:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802988:	8d 50 04             	lea    0x4(%eax),%edx
  80298b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	52                   	push   %edx
  802995:	50                   	push   %eax
  802996:	6a 1d                	push   $0x1d
  802998:	e8 ae fc ff ff       	call   80264b <syscall>
  80299d:	83 c4 18             	add    $0x18,%esp
	return result;
  8029a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029a9:	89 01                	mov    %eax,(%ecx)
  8029ab:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	c9                   	leave  
  8029b2:	c2 04 00             	ret    $0x4

008029b5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	ff 75 10             	pushl  0x10(%ebp)
  8029bf:	ff 75 0c             	pushl  0xc(%ebp)
  8029c2:	ff 75 08             	pushl  0x8(%ebp)
  8029c5:	6a 13                	push   $0x13
  8029c7:	e8 7f fc ff ff       	call   80264b <syscall>
  8029cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8029cf:	90                   	nop
}
  8029d0:	c9                   	leave  
  8029d1:	c3                   	ret    

008029d2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8029d2:	55                   	push   %ebp
  8029d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	6a 00                	push   $0x0
  8029db:	6a 00                	push   $0x0
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 1e                	push   $0x1e
  8029e1:	e8 65 fc ff ff       	call   80264b <syscall>
  8029e6:	83 c4 18             	add    $0x18,%esp
}
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    

008029eb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029f7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 00                	push   $0x0
  802a01:	6a 00                	push   $0x0
  802a03:	50                   	push   %eax
  802a04:	6a 1f                	push   $0x1f
  802a06:	e8 40 fc ff ff       	call   80264b <syscall>
  802a0b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a0e:	90                   	nop
}
  802a0f:	c9                   	leave  
  802a10:	c3                   	ret    

00802a11 <rsttst>:
void rsttst()
{
  802a11:	55                   	push   %ebp
  802a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a14:	6a 00                	push   $0x0
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 21                	push   $0x21
  802a20:	e8 26 fc ff ff       	call   80264b <syscall>
  802a25:	83 c4 18             	add    $0x18,%esp
	return ;
  802a28:	90                   	nop
}
  802a29:	c9                   	leave  
  802a2a:	c3                   	ret    

00802a2b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a2b:	55                   	push   %ebp
  802a2c:	89 e5                	mov    %esp,%ebp
  802a2e:	83 ec 04             	sub    $0x4,%esp
  802a31:	8b 45 14             	mov    0x14(%ebp),%eax
  802a34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a37:	8b 55 18             	mov    0x18(%ebp),%edx
  802a3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a3e:	52                   	push   %edx
  802a3f:	50                   	push   %eax
  802a40:	ff 75 10             	pushl  0x10(%ebp)
  802a43:	ff 75 0c             	pushl  0xc(%ebp)
  802a46:	ff 75 08             	pushl  0x8(%ebp)
  802a49:	6a 20                	push   $0x20
  802a4b:	e8 fb fb ff ff       	call   80264b <syscall>
  802a50:	83 c4 18             	add    $0x18,%esp
	return ;
  802a53:	90                   	nop
}
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <chktst>:
void chktst(uint32 n)
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	6a 00                	push   $0x0
  802a5f:	6a 00                	push   $0x0
  802a61:	ff 75 08             	pushl  0x8(%ebp)
  802a64:	6a 22                	push   $0x22
  802a66:	e8 e0 fb ff ff       	call   80264b <syscall>
  802a6b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a6e:	90                   	nop
}
  802a6f:	c9                   	leave  
  802a70:	c3                   	ret    

00802a71 <inctst>:

void inctst()
{
  802a71:	55                   	push   %ebp
  802a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	6a 00                	push   $0x0
  802a7e:	6a 23                	push   $0x23
  802a80:	e8 c6 fb ff ff       	call   80264b <syscall>
  802a85:	83 c4 18             	add    $0x18,%esp
	return ;
  802a88:	90                   	nop
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <gettst>:
uint32 gettst()
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 00                	push   $0x0
  802a94:	6a 00                	push   $0x0
  802a96:	6a 00                	push   $0x0
  802a98:	6a 24                	push   $0x24
  802a9a:	e8 ac fb ff ff       	call   80264b <syscall>
  802a9f:	83 c4 18             	add    $0x18,%esp
}
  802aa2:	c9                   	leave  
  802aa3:	c3                   	ret    

00802aa4 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802aa4:	55                   	push   %ebp
  802aa5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	6a 00                	push   $0x0
  802ab1:	6a 25                	push   $0x25
  802ab3:	e8 93 fb ff ff       	call   80264b <syscall>
  802ab8:	83 c4 18             	add    $0x18,%esp
  802abb:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802ac0:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802ac5:	c9                   	leave  
  802ac6:	c3                   	ret    

00802ac7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ac7:	55                   	push   %ebp
  802ac8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	ff 75 08             	pushl  0x8(%ebp)
  802add:	6a 26                	push   $0x26
  802adf:	e8 67 fb ff ff       	call   80264b <syscall>
  802ae4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae7:	90                   	nop
}
  802ae8:	c9                   	leave  
  802ae9:	c3                   	ret    

00802aea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802aea:	55                   	push   %ebp
  802aeb:	89 e5                	mov    %esp,%ebp
  802aed:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802aee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	6a 00                	push   $0x0
  802afc:	53                   	push   %ebx
  802afd:	51                   	push   %ecx
  802afe:	52                   	push   %edx
  802aff:	50                   	push   %eax
  802b00:	6a 27                	push   $0x27
  802b02:	e8 44 fb ff ff       	call   80264b <syscall>
  802b07:	83 c4 18             	add    $0x18,%esp
}
  802b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b0d:	c9                   	leave  
  802b0e:	c3                   	ret    

00802b0f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	52                   	push   %edx
  802b1f:	50                   	push   %eax
  802b20:	6a 28                	push   $0x28
  802b22:	e8 24 fb ff ff       	call   80264b <syscall>
  802b27:	83 c4 18             	add    $0x18,%esp
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	6a 00                	push   $0x0
  802b3a:	51                   	push   %ecx
  802b3b:	ff 75 10             	pushl  0x10(%ebp)
  802b3e:	52                   	push   %edx
  802b3f:	50                   	push   %eax
  802b40:	6a 29                	push   $0x29
  802b42:	e8 04 fb ff ff       	call   80264b <syscall>
  802b47:	83 c4 18             	add    $0x18,%esp
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	ff 75 10             	pushl  0x10(%ebp)
  802b56:	ff 75 0c             	pushl  0xc(%ebp)
  802b59:	ff 75 08             	pushl  0x8(%ebp)
  802b5c:	6a 12                	push   $0x12
  802b5e:	e8 e8 fa ff ff       	call   80264b <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
	return ;
  802b66:	90                   	nop
}
  802b67:	c9                   	leave  
  802b68:	c3                   	ret    

00802b69 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b69:	55                   	push   %ebp
  802b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	52                   	push   %edx
  802b79:	50                   	push   %eax
  802b7a:	6a 2a                	push   $0x2a
  802b7c:	e8 ca fa ff ff       	call   80264b <syscall>
  802b81:	83 c4 18             	add    $0x18,%esp
	return;
  802b84:	90                   	nop
}
  802b85:	c9                   	leave  
  802b86:	c3                   	ret    

00802b87 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802b87:	55                   	push   %ebp
  802b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 2b                	push   $0x2b
  802b96:	e8 b0 fa ff ff       	call   80264b <syscall>
  802b9b:	83 c4 18             	add    $0x18,%esp
}
  802b9e:	c9                   	leave  
  802b9f:	c3                   	ret    

00802ba0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ba3:	6a 00                	push   $0x0
  802ba5:	6a 00                	push   $0x0
  802ba7:	6a 00                	push   $0x0
  802ba9:	ff 75 0c             	pushl  0xc(%ebp)
  802bac:	ff 75 08             	pushl  0x8(%ebp)
  802baf:	6a 2d                	push   $0x2d
  802bb1:	e8 95 fa ff ff       	call   80264b <syscall>
  802bb6:	83 c4 18             	add    $0x18,%esp
	return;
  802bb9:	90                   	nop
}
  802bba:	c9                   	leave  
  802bbb:	c3                   	ret    

00802bbc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bbc:	55                   	push   %ebp
  802bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	ff 75 0c             	pushl  0xc(%ebp)
  802bc8:	ff 75 08             	pushl  0x8(%ebp)
  802bcb:	6a 2c                	push   $0x2c
  802bcd:	e8 79 fa ff ff       	call   80264b <syscall>
  802bd2:	83 c4 18             	add    $0x18,%esp
	return ;
  802bd5:	90                   	nop
}
  802bd6:	c9                   	leave  
  802bd7:	c3                   	ret    

00802bd8 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802bd8:	55                   	push   %ebp
  802bd9:	89 e5                	mov    %esp,%ebp
  802bdb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 94 45 80 00       	push   $0x804594
  802be6:	68 25 01 00 00       	push   $0x125
  802beb:	68 c7 45 80 00       	push   $0x8045c7
  802bf0:	e8 ec e6 ff ff       	call   8012e1 <_panic>

00802bf5 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802bf5:	55                   	push   %ebp
  802bf6:	89 e5                	mov    %esp,%ebp
  802bf8:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802bfb:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802c02:	72 09                	jb     802c0d <to_page_va+0x18>
  802c04:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802c0b:	72 14                	jb     802c21 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802c0d:	83 ec 04             	sub    $0x4,%esp
  802c10:	68 d8 45 80 00       	push   $0x8045d8
  802c15:	6a 15                	push   $0x15
  802c17:	68 03 46 80 00       	push   $0x804603
  802c1c:	e8 c0 e6 ff ff       	call   8012e1 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	ba 40 52 80 00       	mov    $0x805240,%edx
  802c29:	29 d0                	sub    %edx,%eax
  802c2b:	c1 f8 02             	sar    $0x2,%eax
  802c2e:	89 c2                	mov    %eax,%edx
  802c30:	89 d0                	mov    %edx,%eax
  802c32:	c1 e0 02             	shl    $0x2,%eax
  802c35:	01 d0                	add    %edx,%eax
  802c37:	c1 e0 02             	shl    $0x2,%eax
  802c3a:	01 d0                	add    %edx,%eax
  802c3c:	c1 e0 02             	shl    $0x2,%eax
  802c3f:	01 d0                	add    %edx,%eax
  802c41:	89 c1                	mov    %eax,%ecx
  802c43:	c1 e1 08             	shl    $0x8,%ecx
  802c46:	01 c8                	add    %ecx,%eax
  802c48:	89 c1                	mov    %eax,%ecx
  802c4a:	c1 e1 10             	shl    $0x10,%ecx
  802c4d:	01 c8                	add    %ecx,%eax
  802c4f:	01 c0                	add    %eax,%eax
  802c51:	01 d0                	add    %edx,%eax
  802c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	c1 e0 0c             	shl    $0xc,%eax
  802c5c:	89 c2                	mov    %eax,%edx
  802c5e:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802c63:	01 d0                	add    %edx,%eax
}
  802c65:	c9                   	leave  
  802c66:	c3                   	ret    

00802c67 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802c67:	55                   	push   %ebp
  802c68:	89 e5                	mov    %esp,%ebp
  802c6a:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802c6d:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802c72:	8b 55 08             	mov    0x8(%ebp),%edx
  802c75:	29 c2                	sub    %eax,%edx
  802c77:	89 d0                	mov    %edx,%eax
  802c79:	c1 e8 0c             	shr    $0xc,%eax
  802c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c83:	78 09                	js     802c8e <to_page_info+0x27>
  802c85:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802c8c:	7e 14                	jle    802ca2 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802c8e:	83 ec 04             	sub    $0x4,%esp
  802c91:	68 1c 46 80 00       	push   $0x80461c
  802c96:	6a 22                	push   $0x22
  802c98:	68 03 46 80 00       	push   $0x804603
  802c9d:	e8 3f e6 ff ff       	call   8012e1 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca5:	89 d0                	mov    %edx,%eax
  802ca7:	01 c0                	add    %eax,%eax
  802ca9:	01 d0                	add    %edx,%eax
  802cab:	c1 e0 02             	shl    $0x2,%eax
  802cae:	05 40 52 80 00       	add    $0x805240,%eax
}
  802cb3:	c9                   	leave  
  802cb4:	c3                   	ret    

00802cb5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802cb5:	55                   	push   %ebp
  802cb6:	89 e5                	mov    %esp,%ebp
  802cb8:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	05 00 00 00 02       	add    $0x2000000,%eax
  802cc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cc6:	73 16                	jae    802cde <initialize_dynamic_allocator+0x29>
  802cc8:	68 40 46 80 00       	push   $0x804640
  802ccd:	68 66 46 80 00       	push   $0x804666
  802cd2:	6a 34                	push   $0x34
  802cd4:	68 03 46 80 00       	push   $0x804603
  802cd9:	e8 03 e6 ff ff       	call   8012e1 <_panic>
		is_initialized = 1;
  802cde:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802ce5:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf3:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802cf8:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802cff:	00 00 00 
  802d02:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802d09:	00 00 00 
  802d0c:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  802d13:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d19:	2b 45 08             	sub    0x8(%ebp),%eax
  802d1c:	c1 e8 0c             	shr    $0xc,%eax
  802d1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d29:	e9 c8 00 00 00       	jmp    802df6 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d31:	89 d0                	mov    %edx,%eax
  802d33:	01 c0                	add    %eax,%eax
  802d35:	01 d0                	add    %edx,%eax
  802d37:	c1 e0 02             	shl    $0x2,%eax
  802d3a:	05 48 52 80 00       	add    $0x805248,%eax
  802d3f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802d44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d47:	89 d0                	mov    %edx,%eax
  802d49:	01 c0                	add    %eax,%eax
  802d4b:	01 d0                	add    %edx,%eax
  802d4d:	c1 e0 02             	shl    $0x2,%eax
  802d50:	05 4a 52 80 00       	add    $0x80524a,%eax
  802d55:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802d5a:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802d60:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d63:	89 c8                	mov    %ecx,%eax
  802d65:	01 c0                	add    %eax,%eax
  802d67:	01 c8                	add    %ecx,%eax
  802d69:	c1 e0 02             	shl    $0x2,%eax
  802d6c:	05 44 52 80 00       	add    $0x805244,%eax
  802d71:	89 10                	mov    %edx,(%eax)
  802d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d76:	89 d0                	mov    %edx,%eax
  802d78:	01 c0                	add    %eax,%eax
  802d7a:	01 d0                	add    %edx,%eax
  802d7c:	c1 e0 02             	shl    $0x2,%eax
  802d7f:	05 44 52 80 00       	add    $0x805244,%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 1b                	je     802da5 <initialize_dynamic_allocator+0xf0>
  802d8a:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802d90:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d93:	89 c8                	mov    %ecx,%eax
  802d95:	01 c0                	add    %eax,%eax
  802d97:	01 c8                	add    %ecx,%eax
  802d99:	c1 e0 02             	shl    $0x2,%eax
  802d9c:	05 40 52 80 00       	add    $0x805240,%eax
  802da1:	89 02                	mov    %eax,(%edx)
  802da3:	eb 16                	jmp    802dbb <initialize_dynamic_allocator+0x106>
  802da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da8:	89 d0                	mov    %edx,%eax
  802daa:	01 c0                	add    %eax,%eax
  802dac:	01 d0                	add    %edx,%eax
  802dae:	c1 e0 02             	shl    $0x2,%eax
  802db1:	05 40 52 80 00       	add    $0x805240,%eax
  802db6:	a3 28 52 80 00       	mov    %eax,0x805228
  802dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbe:	89 d0                	mov    %edx,%eax
  802dc0:	01 c0                	add    %eax,%eax
  802dc2:	01 d0                	add    %edx,%eax
  802dc4:	c1 e0 02             	shl    $0x2,%eax
  802dc7:	05 40 52 80 00       	add    $0x805240,%eax
  802dcc:	a3 2c 52 80 00       	mov    %eax,0x80522c
  802dd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd4:	89 d0                	mov    %edx,%eax
  802dd6:	01 c0                	add    %eax,%eax
  802dd8:	01 d0                	add    %edx,%eax
  802dda:	c1 e0 02             	shl    $0x2,%eax
  802ddd:	05 40 52 80 00       	add    $0x805240,%eax
  802de2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de8:	a1 34 52 80 00       	mov    0x805234,%eax
  802ded:	40                   	inc    %eax
  802dee:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802df3:	ff 45 f4             	incl   -0xc(%ebp)
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802dfc:	0f 8c 2c ff ff ff    	jl     802d2e <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802e02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802e09:	eb 36                	jmp    802e41 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	c1 e0 04             	shl    $0x4,%eax
  802e11:	05 60 d2 81 00       	add    $0x81d260,%eax
  802e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1f:	c1 e0 04             	shl    $0x4,%eax
  802e22:	05 64 d2 81 00       	add    $0x81d264,%eax
  802e27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e30:	c1 e0 04             	shl    $0x4,%eax
  802e33:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802e3e:	ff 45 f0             	incl   -0x10(%ebp)
  802e41:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802e45:	7e c4                	jle    802e0b <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802e47:	90                   	nop
  802e48:	c9                   	leave  
  802e49:	c3                   	ret    

00802e4a <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802e4a:	55                   	push   %ebp
  802e4b:	89 e5                	mov    %esp,%ebp
  802e4d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	83 ec 0c             	sub    $0xc,%esp
  802e56:	50                   	push   %eax
  802e57:	e8 0b fe ff ff       	call   802c67 <to_page_info>
  802e5c:	83 c4 10             	add    $0x10,%esp
  802e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802e6b:	c9                   	leave  
  802e6c:	c3                   	ret    

00802e6d <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802e6d:	55                   	push   %ebp
  802e6e:	89 e5                	mov    %esp,%ebp
  802e70:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802e73:	83 ec 0c             	sub    $0xc,%esp
  802e76:	ff 75 0c             	pushl  0xc(%ebp)
  802e79:	e8 77 fd ff ff       	call   802bf5 <to_page_va>
  802e7e:	83 c4 10             	add    $0x10,%esp
  802e81:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802e84:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e89:	ba 00 00 00 00       	mov    $0x0,%edx
  802e8e:	f7 75 08             	divl   0x8(%ebp)
  802e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802e94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e97:	83 ec 0c             	sub    $0xc,%esp
  802e9a:	50                   	push   %eax
  802e9b:	e8 48 f6 ff ff       	call   8024e8 <get_page>
  802ea0:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802ea3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea9:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb3:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802eb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802ebe:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802ec5:	eb 19                	jmp    802ee0 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eca:	ba 01 00 00 00       	mov    $0x1,%edx
  802ecf:	88 c1                	mov    %al,%cl
  802ed1:	d3 e2                	shl    %cl,%edx
  802ed3:	89 d0                	mov    %edx,%eax
  802ed5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed8:	74 0e                	je     802ee8 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802eda:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802edd:	ff 45 f0             	incl   -0x10(%ebp)
  802ee0:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802ee4:	7e e1                	jle    802ec7 <split_page_to_blocks+0x5a>
  802ee6:	eb 01                	jmp    802ee9 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802ee8:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802ee9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802ef0:	e9 a7 00 00 00       	jmp    802f9c <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef8:	0f af 45 08          	imul   0x8(%ebp),%eax
  802efc:	89 c2                	mov    %eax,%edx
  802efe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f01:	01 d0                	add    %edx,%eax
  802f03:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802f06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f0a:	75 14                	jne    802f20 <split_page_to_blocks+0xb3>
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	68 7c 46 80 00       	push   $0x80467c
  802f14:	6a 7c                	push   $0x7c
  802f16:	68 03 46 80 00       	push   $0x804603
  802f1b:	e8 c1 e3 ff ff       	call   8012e1 <_panic>
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	c1 e0 04             	shl    $0x4,%eax
  802f26:	05 64 d2 81 00       	add    $0x81d264,%eax
  802f2b:	8b 10                	mov    (%eax),%edx
  802f2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f30:	89 50 04             	mov    %edx,0x4(%eax)
  802f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f36:	8b 40 04             	mov    0x4(%eax),%eax
  802f39:	85 c0                	test   %eax,%eax
  802f3b:	74 14                	je     802f51 <split_page_to_blocks+0xe4>
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	c1 e0 04             	shl    $0x4,%eax
  802f43:	05 64 d2 81 00       	add    $0x81d264,%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f4d:	89 10                	mov    %edx,(%eax)
  802f4f:	eb 11                	jmp    802f62 <split_page_to_blocks+0xf5>
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	c1 e0 04             	shl    $0x4,%eax
  802f57:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  802f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f60:	89 02                	mov    %eax,(%edx)
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	c1 e0 04             	shl    $0x4,%eax
  802f68:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  802f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f71:	89 02                	mov    %eax,(%edx)
  802f73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	c1 e0 04             	shl    $0x4,%eax
  802f82:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	8d 50 01             	lea    0x1(%eax),%edx
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	c1 e0 04             	shl    $0x4,%eax
  802f92:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802f97:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802f99:	ff 45 ec             	incl   -0x14(%ebp)
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802fa2:	0f 82 4d ff ff ff    	jb     802ef5 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802fa8:	90                   	nop
  802fa9:	c9                   	leave  
  802faa:	c3                   	ret    

00802fab <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802fab:	55                   	push   %ebp
  802fac:	89 e5                	mov    %esp,%ebp
  802fae:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802fb1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802fb8:	76 19                	jbe    802fd3 <alloc_block+0x28>
  802fba:	68 a0 46 80 00       	push   $0x8046a0
  802fbf:	68 66 46 80 00       	push   $0x804666
  802fc4:	68 8a 00 00 00       	push   $0x8a
  802fc9:	68 03 46 80 00       	push   $0x804603
  802fce:	e8 0e e3 ff ff       	call   8012e1 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802fd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802fda:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802fe1:	eb 19                	jmp    802ffc <alloc_block+0x51>
		if((1 << i) >= size) break;
  802fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe6:	ba 01 00 00 00       	mov    $0x1,%edx
  802feb:	88 c1                	mov    %al,%cl
  802fed:	d3 e2                	shl    %cl,%edx
  802fef:	89 d0                	mov    %edx,%eax
  802ff1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff4:	73 0e                	jae    803004 <alloc_block+0x59>
		idx++;
  802ff6:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802ff9:	ff 45 f0             	incl   -0x10(%ebp)
  802ffc:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803000:	7e e1                	jle    802fe3 <alloc_block+0x38>
  803002:	eb 01                	jmp    803005 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  803004:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	c1 e0 04             	shl    $0x4,%eax
  80300b:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803010:	8b 00                	mov    (%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	0f 84 df 00 00 00    	je     8030f9 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	c1 e0 04             	shl    $0x4,%eax
  803020:	05 60 d2 81 00       	add    $0x81d260,%eax
  803025:	8b 00                	mov    (%eax),%eax
  803027:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80302a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80302e:	75 17                	jne    803047 <alloc_block+0x9c>
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 c1 46 80 00       	push   $0x8046c1
  803038:	68 9e 00 00 00       	push   $0x9e
  80303d:	68 03 46 80 00       	push   $0x804603
  803042:	e8 9a e2 ff ff       	call   8012e1 <_panic>
  803047:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	85 c0                	test   %eax,%eax
  80304e:	74 10                	je     803060 <alloc_block+0xb5>
  803050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803058:	8b 52 04             	mov    0x4(%edx),%edx
  80305b:	89 50 04             	mov    %edx,0x4(%eax)
  80305e:	eb 14                	jmp    803074 <alloc_block+0xc9>
  803060:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803069:	c1 e2 04             	shl    $0x4,%edx
  80306c:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803072:	89 02                	mov    %eax,(%edx)
  803074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	74 0f                	je     80308d <alloc_block+0xe2>
  80307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803087:	8b 12                	mov    (%edx),%edx
  803089:	89 10                	mov    %edx,(%eax)
  80308b:	eb 13                	jmp    8030a0 <alloc_block+0xf5>
  80308d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803095:	c1 e2 04             	shl    $0x4,%edx
  803098:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80309e:	89 02                	mov    %eax,(%edx)
  8030a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b6:	c1 e0 04             	shl    $0x4,%eax
  8030b9:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030be:	8b 00                	mov    (%eax),%eax
  8030c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	c1 e0 04             	shl    $0x4,%eax
  8030c9:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030ce:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8030d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d3:	83 ec 0c             	sub    $0xc,%esp
  8030d6:	50                   	push   %eax
  8030d7:	e8 8b fb ff ff       	call   802c67 <to_page_info>
  8030dc:	83 c4 10             	add    $0x10,%esp
  8030df:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8030e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8030e9:	48                   	dec    %eax
  8030ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ed:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8030f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f4:	e9 bc 02 00 00       	jmp    8033b5 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8030f9:	a1 34 52 80 00       	mov    0x805234,%eax
  8030fe:	85 c0                	test   %eax,%eax
  803100:	0f 84 7d 02 00 00    	je     803383 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  803106:	a1 28 52 80 00       	mov    0x805228,%eax
  80310b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80310e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803112:	75 17                	jne    80312b <alloc_block+0x180>
  803114:	83 ec 04             	sub    $0x4,%esp
  803117:	68 c1 46 80 00       	push   $0x8046c1
  80311c:	68 a9 00 00 00       	push   $0xa9
  803121:	68 03 46 80 00       	push   $0x804603
  803126:	e8 b6 e1 ff ff       	call   8012e1 <_panic>
  80312b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312e:	8b 00                	mov    (%eax),%eax
  803130:	85 c0                	test   %eax,%eax
  803132:	74 10                	je     803144 <alloc_block+0x199>
  803134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80313c:	8b 52 04             	mov    0x4(%edx),%edx
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	eb 0b                	jmp    80314f <alloc_block+0x1a4>
  803144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803147:	8b 40 04             	mov    0x4(%eax),%eax
  80314a:	a3 2c 52 80 00       	mov    %eax,0x80522c
  80314f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803152:	8b 40 04             	mov    0x4(%eax),%eax
  803155:	85 c0                	test   %eax,%eax
  803157:	74 0f                	je     803168 <alloc_block+0x1bd>
  803159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803162:	8b 12                	mov    (%edx),%edx
  803164:	89 10                	mov    %edx,(%eax)
  803166:	eb 0a                	jmp    803172 <alloc_block+0x1c7>
  803168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	a3 28 52 80 00       	mov    %eax,0x805228
  803172:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803175:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803185:	a1 34 52 80 00       	mov    0x805234,%eax
  80318a:	48                   	dec    %eax
  80318b:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	83 c0 03             	add    $0x3,%eax
  803196:	ba 01 00 00 00       	mov    $0x1,%edx
  80319b:	88 c1                	mov    %al,%cl
  80319d:	d3 e2                	shl    %cl,%edx
  80319f:	89 d0                	mov    %edx,%eax
  8031a1:	83 ec 08             	sub    $0x8,%esp
  8031a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031a7:	50                   	push   %eax
  8031a8:	e8 c0 fc ff ff       	call   802e6d <split_page_to_blocks>
  8031ad:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8031b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b3:	c1 e0 04             	shl    $0x4,%eax
  8031b6:	05 60 d2 81 00       	add    $0x81d260,%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8031c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031c4:	75 17                	jne    8031dd <alloc_block+0x232>
  8031c6:	83 ec 04             	sub    $0x4,%esp
  8031c9:	68 c1 46 80 00       	push   $0x8046c1
  8031ce:	68 b0 00 00 00       	push   $0xb0
  8031d3:	68 03 46 80 00       	push   $0x804603
  8031d8:	e8 04 e1 ff ff       	call   8012e1 <_panic>
  8031dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	74 10                	je     8031f6 <alloc_block+0x24b>
  8031e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031ee:	8b 52 04             	mov    0x4(%edx),%edx
  8031f1:	89 50 04             	mov    %edx,0x4(%eax)
  8031f4:	eb 14                	jmp    80320a <alloc_block+0x25f>
  8031f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f9:	8b 40 04             	mov    0x4(%eax),%eax
  8031fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ff:	c1 e2 04             	shl    $0x4,%edx
  803202:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803208:	89 02                	mov    %eax,(%edx)
  80320a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320d:	8b 40 04             	mov    0x4(%eax),%eax
  803210:	85 c0                	test   %eax,%eax
  803212:	74 0f                	je     803223 <alloc_block+0x278>
  803214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803217:	8b 40 04             	mov    0x4(%eax),%eax
  80321a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80321d:	8b 12                	mov    (%edx),%edx
  80321f:	89 10                	mov    %edx,(%eax)
  803221:	eb 13                	jmp    803236 <alloc_block+0x28b>
  803223:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322b:	c1 e2 04             	shl    $0x4,%edx
  80322e:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803234:	89 02                	mov    %eax,(%edx)
  803236:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803242:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	c1 e0 04             	shl    $0x4,%eax
  80324f:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	8d 50 ff             	lea    -0x1(%eax),%edx
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	c1 e0 04             	shl    $0x4,%eax
  80325f:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803264:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803266:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803269:	83 ec 0c             	sub    $0xc,%esp
  80326c:	50                   	push   %eax
  80326d:	e8 f5 f9 ff ff       	call   802c67 <to_page_info>
  803272:	83 c4 10             	add    $0x10,%esp
  803275:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  803278:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80327b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80327f:	48                   	dec    %eax
  803280:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803283:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80328a:	e9 26 01 00 00       	jmp    8033b5 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80328f:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	c1 e0 04             	shl    $0x4,%eax
  803298:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	0f 84 dc 00 00 00    	je     803383 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	c1 e0 04             	shl    $0x4,%eax
  8032ad:	05 60 d2 81 00       	add    $0x81d260,%eax
  8032b2:	8b 00                	mov    (%eax),%eax
  8032b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8032b7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032bb:	75 17                	jne    8032d4 <alloc_block+0x329>
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	68 c1 46 80 00       	push   $0x8046c1
  8032c5:	68 be 00 00 00       	push   $0xbe
  8032ca:	68 03 46 80 00       	push   $0x804603
  8032cf:	e8 0d e0 ff ff       	call   8012e1 <_panic>
  8032d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 10                	je     8032ed <alloc_block+0x342>
  8032dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032e5:	8b 52 04             	mov    0x4(%edx),%edx
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	eb 14                	jmp    803301 <alloc_block+0x356>
  8032ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032f0:	8b 40 04             	mov    0x4(%eax),%eax
  8032f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f6:	c1 e2 04             	shl    $0x4,%edx
  8032f9:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8032ff:	89 02                	mov    %eax,(%edx)
  803301:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803304:	8b 40 04             	mov    0x4(%eax),%eax
  803307:	85 c0                	test   %eax,%eax
  803309:	74 0f                	je     80331a <alloc_block+0x36f>
  80330b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80330e:	8b 40 04             	mov    0x4(%eax),%eax
  803311:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803314:	8b 12                	mov    (%edx),%edx
  803316:	89 10                	mov    %edx,(%eax)
  803318:	eb 13                	jmp    80332d <alloc_block+0x382>
  80331a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803322:	c1 e2 04             	shl    $0x4,%edx
  803325:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80332b:	89 02                	mov    %eax,(%edx)
  80332d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803330:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803336:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803339:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	c1 e0 04             	shl    $0x4,%eax
  803346:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803353:	c1 e0 04             	shl    $0x4,%eax
  803356:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80335b:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80335d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803360:	83 ec 0c             	sub    $0xc,%esp
  803363:	50                   	push   %eax
  803364:	e8 fe f8 ff ff       	call   802c67 <to_page_info>
  803369:	83 c4 10             	add    $0x10,%esp
  80336c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80336f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803372:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803376:	48                   	dec    %eax
  803377:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80337a:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80337e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803381:	eb 32                	jmp    8033b5 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803383:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803387:	77 15                	ja     80339e <alloc_block+0x3f3>
  803389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338c:	c1 e0 04             	shl    $0x4,%eax
  80338f:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	0f 84 f1 fe ff ff    	je     80328f <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80339e:	83 ec 04             	sub    $0x4,%esp
  8033a1:	68 df 46 80 00       	push   $0x8046df
  8033a6:	68 c8 00 00 00       	push   $0xc8
  8033ab:	68 03 46 80 00       	push   $0x804603
  8033b0:	e8 2c df ff ff       	call   8012e1 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8033b5:	c9                   	leave  
  8033b6:	c3                   	ret    

008033b7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
  8033ba:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8033bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c0:	a1 48 d2 81 00       	mov    0x81d248,%eax
  8033c5:	39 c2                	cmp    %eax,%edx
  8033c7:	72 0c                	jb     8033d5 <free_block+0x1e>
  8033c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033cc:	a1 20 52 80 00       	mov    0x805220,%eax
  8033d1:	39 c2                	cmp    %eax,%edx
  8033d3:	72 19                	jb     8033ee <free_block+0x37>
  8033d5:	68 f0 46 80 00       	push   $0x8046f0
  8033da:	68 66 46 80 00       	push   $0x804666
  8033df:	68 d7 00 00 00       	push   $0xd7
  8033e4:	68 03 46 80 00       	push   $0x804603
  8033e9:	e8 f3 de ff ff       	call   8012e1 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	83 ec 0c             	sub    $0xc,%esp
  8033fa:	50                   	push   %eax
  8033fb:	e8 67 f8 ff ff       	call   802c67 <to_page_info>
  803400:	83 c4 10             	add    $0x10,%esp
  803403:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  803406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803409:	8b 40 08             	mov    0x8(%eax),%eax
  80340c:	0f b7 c0             	movzwl %ax,%eax
  80340f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803412:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803419:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803420:	eb 19                	jmp    80343b <free_block+0x84>
	    if ((1 << i) == blk_size)
  803422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803425:	ba 01 00 00 00       	mov    $0x1,%edx
  80342a:	88 c1                	mov    %al,%cl
  80342c:	d3 e2                	shl    %cl,%edx
  80342e:	89 d0                	mov    %edx,%eax
  803430:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803433:	74 0e                	je     803443 <free_block+0x8c>
	        break;
	    idx++;
  803435:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803438:	ff 45 f0             	incl   -0x10(%ebp)
  80343b:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80343f:	7e e1                	jle    803422 <free_block+0x6b>
  803441:	eb 01                	jmp    803444 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  803443:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  803444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803447:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80344b:	40                   	inc    %eax
  80344c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80344f:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803453:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803457:	75 17                	jne    803470 <free_block+0xb9>
  803459:	83 ec 04             	sub    $0x4,%esp
  80345c:	68 7c 46 80 00       	push   $0x80467c
  803461:	68 ee 00 00 00       	push   $0xee
  803466:	68 03 46 80 00       	push   $0x804603
  80346b:	e8 71 de ff ff       	call   8012e1 <_panic>
  803470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803473:	c1 e0 04             	shl    $0x4,%eax
  803476:	05 64 d2 81 00       	add    $0x81d264,%eax
  80347b:	8b 10                	mov    (%eax),%edx
  80347d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803480:	89 50 04             	mov    %edx,0x4(%eax)
  803483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803486:	8b 40 04             	mov    0x4(%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 14                	je     8034a1 <free_block+0xea>
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	c1 e0 04             	shl    $0x4,%eax
  803493:	05 64 d2 81 00       	add    $0x81d264,%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80349d:	89 10                	mov    %edx,(%eax)
  80349f:	eb 11                	jmp    8034b2 <free_block+0xfb>
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	c1 e0 04             	shl    $0x4,%eax
  8034a7:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8034ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b0:	89 02                	mov    %eax,(%edx)
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	c1 e0 04             	shl    $0x4,%eax
  8034b8:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8034be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c1:	89 02                	mov    %eax,(%edx)
  8034c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cf:	c1 e0 04             	shl    $0x4,%eax
  8034d2:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034d7:	8b 00                	mov    (%eax),%eax
  8034d9:	8d 50 01             	lea    0x1(%eax),%edx
  8034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034df:	c1 e0 04             	shl    $0x4,%eax
  8034e2:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034e7:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8034e9:	b8 00 10 00 00       	mov    $0x1000,%eax
  8034ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8034f3:	f7 75 e0             	divl   -0x20(%ebp)
  8034f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8034f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803500:	0f b7 c0             	movzwl %ax,%eax
  803503:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803506:	0f 85 70 01 00 00    	jne    80367c <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  80350c:	83 ec 0c             	sub    $0xc,%esp
  80350f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803512:	e8 de f6 ff ff       	call   802bf5 <to_page_va>
  803517:	83 c4 10             	add    $0x10,%esp
  80351a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80351d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803524:	e9 b7 00 00 00       	jmp    8035e0 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  803529:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80352c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352f:	01 d0                	add    %edx,%eax
  803531:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  803534:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803538:	75 17                	jne    803551 <free_block+0x19a>
  80353a:	83 ec 04             	sub    $0x4,%esp
  80353d:	68 c1 46 80 00       	push   $0x8046c1
  803542:	68 f8 00 00 00       	push   $0xf8
  803547:	68 03 46 80 00       	push   $0x804603
  80354c:	e8 90 dd ff ff       	call   8012e1 <_panic>
  803551:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 10                	je     80356a <free_block+0x1b3>
  80355a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803562:	8b 52 04             	mov    0x4(%edx),%edx
  803565:	89 50 04             	mov    %edx,0x4(%eax)
  803568:	eb 14                	jmp    80357e <free_block+0x1c7>
  80356a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356d:	8b 40 04             	mov    0x4(%eax),%eax
  803570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803573:	c1 e2 04             	shl    $0x4,%edx
  803576:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80357c:	89 02                	mov    %eax,(%edx)
  80357e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803581:	8b 40 04             	mov    0x4(%eax),%eax
  803584:	85 c0                	test   %eax,%eax
  803586:	74 0f                	je     803597 <free_block+0x1e0>
  803588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358b:	8b 40 04             	mov    0x4(%eax),%eax
  80358e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803591:	8b 12                	mov    (%edx),%edx
  803593:	89 10                	mov    %edx,(%eax)
  803595:	eb 13                	jmp    8035aa <free_block+0x1f3>
  803597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359a:	8b 00                	mov    (%eax),%eax
  80359c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80359f:	c1 e2 04             	shl    $0x4,%edx
  8035a2:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8035a8:	89 02                	mov    %eax,(%edx)
  8035aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	c1 e0 04             	shl    $0x4,%eax
  8035c3:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d0:	c1 e0 04             	shl    $0x4,%eax
  8035d3:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035d8:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8035da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035dd:	01 45 ec             	add    %eax,-0x14(%ebp)
  8035e0:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8035e7:	0f 86 3c ff ff ff    	jbe    803529 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8035ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f0:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f9:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8035ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803603:	75 17                	jne    80361c <free_block+0x265>
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	68 7c 46 80 00       	push   $0x80467c
  80360d:	68 fe 00 00 00       	push   $0xfe
  803612:	68 03 46 80 00       	push   $0x804603
  803617:	e8 c5 dc ff ff       	call   8012e1 <_panic>
  80361c:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362b:	8b 40 04             	mov    0x4(%eax),%eax
  80362e:	85 c0                	test   %eax,%eax
  803630:	74 0c                	je     80363e <free_block+0x287>
  803632:	a1 2c 52 80 00       	mov    0x80522c,%eax
  803637:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80363a:	89 10                	mov    %edx,(%eax)
  80363c:	eb 08                	jmp    803646 <free_block+0x28f>
  80363e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803641:	a3 28 52 80 00       	mov    %eax,0x805228
  803646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803649:	a3 2c 52 80 00       	mov    %eax,0x80522c
  80364e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803657:	a1 34 52 80 00       	mov    0x805234,%eax
  80365c:	40                   	inc    %eax
  80365d:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803662:	83 ec 0c             	sub    $0xc,%esp
  803665:	ff 75 e4             	pushl  -0x1c(%ebp)
  803668:	e8 88 f5 ff ff       	call   802bf5 <to_page_va>
  80366d:	83 c4 10             	add    $0x10,%esp
  803670:	83 ec 0c             	sub    $0xc,%esp
  803673:	50                   	push   %eax
  803674:	e8 b8 ee ff ff       	call   802531 <return_page>
  803679:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80367c:	90                   	nop
  80367d:	c9                   	leave  
  80367e:	c3                   	ret    

0080367f <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80367f:	55                   	push   %ebp
  803680:	89 e5                	mov    %esp,%ebp
  803682:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803685:	83 ec 04             	sub    $0x4,%esp
  803688:	68 28 47 80 00       	push   $0x804728
  80368d:	68 11 01 00 00       	push   $0x111
  803692:	68 03 46 80 00       	push   $0x804603
  803697:	e8 45 dc ff ff       	call   8012e1 <_panic>

0080369c <__udivdi3>:
  80369c:	55                   	push   %ebp
  80369d:	57                   	push   %edi
  80369e:	56                   	push   %esi
  80369f:	53                   	push   %ebx
  8036a0:	83 ec 1c             	sub    $0x1c,%esp
  8036a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036b3:	89 ca                	mov    %ecx,%edx
  8036b5:	89 f8                	mov    %edi,%eax
  8036b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036bb:	85 f6                	test   %esi,%esi
  8036bd:	75 2d                	jne    8036ec <__udivdi3+0x50>
  8036bf:	39 cf                	cmp    %ecx,%edi
  8036c1:	77 65                	ja     803728 <__udivdi3+0x8c>
  8036c3:	89 fd                	mov    %edi,%ebp
  8036c5:	85 ff                	test   %edi,%edi
  8036c7:	75 0b                	jne    8036d4 <__udivdi3+0x38>
  8036c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ce:	31 d2                	xor    %edx,%edx
  8036d0:	f7 f7                	div    %edi
  8036d2:	89 c5                	mov    %eax,%ebp
  8036d4:	31 d2                	xor    %edx,%edx
  8036d6:	89 c8                	mov    %ecx,%eax
  8036d8:	f7 f5                	div    %ebp
  8036da:	89 c1                	mov    %eax,%ecx
  8036dc:	89 d8                	mov    %ebx,%eax
  8036de:	f7 f5                	div    %ebp
  8036e0:	89 cf                	mov    %ecx,%edi
  8036e2:	89 fa                	mov    %edi,%edx
  8036e4:	83 c4 1c             	add    $0x1c,%esp
  8036e7:	5b                   	pop    %ebx
  8036e8:	5e                   	pop    %esi
  8036e9:	5f                   	pop    %edi
  8036ea:	5d                   	pop    %ebp
  8036eb:	c3                   	ret    
  8036ec:	39 ce                	cmp    %ecx,%esi
  8036ee:	77 28                	ja     803718 <__udivdi3+0x7c>
  8036f0:	0f bd fe             	bsr    %esi,%edi
  8036f3:	83 f7 1f             	xor    $0x1f,%edi
  8036f6:	75 40                	jne    803738 <__udivdi3+0x9c>
  8036f8:	39 ce                	cmp    %ecx,%esi
  8036fa:	72 0a                	jb     803706 <__udivdi3+0x6a>
  8036fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803700:	0f 87 9e 00 00 00    	ja     8037a4 <__udivdi3+0x108>
  803706:	b8 01 00 00 00       	mov    $0x1,%eax
  80370b:	89 fa                	mov    %edi,%edx
  80370d:	83 c4 1c             	add    $0x1c,%esp
  803710:	5b                   	pop    %ebx
  803711:	5e                   	pop    %esi
  803712:	5f                   	pop    %edi
  803713:	5d                   	pop    %ebp
  803714:	c3                   	ret    
  803715:	8d 76 00             	lea    0x0(%esi),%esi
  803718:	31 ff                	xor    %edi,%edi
  80371a:	31 c0                	xor    %eax,%eax
  80371c:	89 fa                	mov    %edi,%edx
  80371e:	83 c4 1c             	add    $0x1c,%esp
  803721:	5b                   	pop    %ebx
  803722:	5e                   	pop    %esi
  803723:	5f                   	pop    %edi
  803724:	5d                   	pop    %ebp
  803725:	c3                   	ret    
  803726:	66 90                	xchg   %ax,%ax
  803728:	89 d8                	mov    %ebx,%eax
  80372a:	f7 f7                	div    %edi
  80372c:	31 ff                	xor    %edi,%edi
  80372e:	89 fa                	mov    %edi,%edx
  803730:	83 c4 1c             	add    $0x1c,%esp
  803733:	5b                   	pop    %ebx
  803734:	5e                   	pop    %esi
  803735:	5f                   	pop    %edi
  803736:	5d                   	pop    %ebp
  803737:	c3                   	ret    
  803738:	bd 20 00 00 00       	mov    $0x20,%ebp
  80373d:	89 eb                	mov    %ebp,%ebx
  80373f:	29 fb                	sub    %edi,%ebx
  803741:	89 f9                	mov    %edi,%ecx
  803743:	d3 e6                	shl    %cl,%esi
  803745:	89 c5                	mov    %eax,%ebp
  803747:	88 d9                	mov    %bl,%cl
  803749:	d3 ed                	shr    %cl,%ebp
  80374b:	89 e9                	mov    %ebp,%ecx
  80374d:	09 f1                	or     %esi,%ecx
  80374f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803753:	89 f9                	mov    %edi,%ecx
  803755:	d3 e0                	shl    %cl,%eax
  803757:	89 c5                	mov    %eax,%ebp
  803759:	89 d6                	mov    %edx,%esi
  80375b:	88 d9                	mov    %bl,%cl
  80375d:	d3 ee                	shr    %cl,%esi
  80375f:	89 f9                	mov    %edi,%ecx
  803761:	d3 e2                	shl    %cl,%edx
  803763:	8b 44 24 08          	mov    0x8(%esp),%eax
  803767:	88 d9                	mov    %bl,%cl
  803769:	d3 e8                	shr    %cl,%eax
  80376b:	09 c2                	or     %eax,%edx
  80376d:	89 d0                	mov    %edx,%eax
  80376f:	89 f2                	mov    %esi,%edx
  803771:	f7 74 24 0c          	divl   0xc(%esp)
  803775:	89 d6                	mov    %edx,%esi
  803777:	89 c3                	mov    %eax,%ebx
  803779:	f7 e5                	mul    %ebp
  80377b:	39 d6                	cmp    %edx,%esi
  80377d:	72 19                	jb     803798 <__udivdi3+0xfc>
  80377f:	74 0b                	je     80378c <__udivdi3+0xf0>
  803781:	89 d8                	mov    %ebx,%eax
  803783:	31 ff                	xor    %edi,%edi
  803785:	e9 58 ff ff ff       	jmp    8036e2 <__udivdi3+0x46>
  80378a:	66 90                	xchg   %ax,%ax
  80378c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803790:	89 f9                	mov    %edi,%ecx
  803792:	d3 e2                	shl    %cl,%edx
  803794:	39 c2                	cmp    %eax,%edx
  803796:	73 e9                	jae    803781 <__udivdi3+0xe5>
  803798:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80379b:	31 ff                	xor    %edi,%edi
  80379d:	e9 40 ff ff ff       	jmp    8036e2 <__udivdi3+0x46>
  8037a2:	66 90                	xchg   %ax,%ax
  8037a4:	31 c0                	xor    %eax,%eax
  8037a6:	e9 37 ff ff ff       	jmp    8036e2 <__udivdi3+0x46>
  8037ab:	90                   	nop

008037ac <__umoddi3>:
  8037ac:	55                   	push   %ebp
  8037ad:	57                   	push   %edi
  8037ae:	56                   	push   %esi
  8037af:	53                   	push   %ebx
  8037b0:	83 ec 1c             	sub    $0x1c,%esp
  8037b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037cb:	89 f3                	mov    %esi,%ebx
  8037cd:	89 fa                	mov    %edi,%edx
  8037cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037d3:	89 34 24             	mov    %esi,(%esp)
  8037d6:	85 c0                	test   %eax,%eax
  8037d8:	75 1a                	jne    8037f4 <__umoddi3+0x48>
  8037da:	39 f7                	cmp    %esi,%edi
  8037dc:	0f 86 a2 00 00 00    	jbe    803884 <__umoddi3+0xd8>
  8037e2:	89 c8                	mov    %ecx,%eax
  8037e4:	89 f2                	mov    %esi,%edx
  8037e6:	f7 f7                	div    %edi
  8037e8:	89 d0                	mov    %edx,%eax
  8037ea:	31 d2                	xor    %edx,%edx
  8037ec:	83 c4 1c             	add    $0x1c,%esp
  8037ef:	5b                   	pop    %ebx
  8037f0:	5e                   	pop    %esi
  8037f1:	5f                   	pop    %edi
  8037f2:	5d                   	pop    %ebp
  8037f3:	c3                   	ret    
  8037f4:	39 f0                	cmp    %esi,%eax
  8037f6:	0f 87 ac 00 00 00    	ja     8038a8 <__umoddi3+0xfc>
  8037fc:	0f bd e8             	bsr    %eax,%ebp
  8037ff:	83 f5 1f             	xor    $0x1f,%ebp
  803802:	0f 84 ac 00 00 00    	je     8038b4 <__umoddi3+0x108>
  803808:	bf 20 00 00 00       	mov    $0x20,%edi
  80380d:	29 ef                	sub    %ebp,%edi
  80380f:	89 fe                	mov    %edi,%esi
  803811:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803815:	89 e9                	mov    %ebp,%ecx
  803817:	d3 e0                	shl    %cl,%eax
  803819:	89 d7                	mov    %edx,%edi
  80381b:	89 f1                	mov    %esi,%ecx
  80381d:	d3 ef                	shr    %cl,%edi
  80381f:	09 c7                	or     %eax,%edi
  803821:	89 e9                	mov    %ebp,%ecx
  803823:	d3 e2                	shl    %cl,%edx
  803825:	89 14 24             	mov    %edx,(%esp)
  803828:	89 d8                	mov    %ebx,%eax
  80382a:	d3 e0                	shl    %cl,%eax
  80382c:	89 c2                	mov    %eax,%edx
  80382e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803832:	d3 e0                	shl    %cl,%eax
  803834:	89 44 24 04          	mov    %eax,0x4(%esp)
  803838:	8b 44 24 08          	mov    0x8(%esp),%eax
  80383c:	89 f1                	mov    %esi,%ecx
  80383e:	d3 e8                	shr    %cl,%eax
  803840:	09 d0                	or     %edx,%eax
  803842:	d3 eb                	shr    %cl,%ebx
  803844:	89 da                	mov    %ebx,%edx
  803846:	f7 f7                	div    %edi
  803848:	89 d3                	mov    %edx,%ebx
  80384a:	f7 24 24             	mull   (%esp)
  80384d:	89 c6                	mov    %eax,%esi
  80384f:	89 d1                	mov    %edx,%ecx
  803851:	39 d3                	cmp    %edx,%ebx
  803853:	0f 82 87 00 00 00    	jb     8038e0 <__umoddi3+0x134>
  803859:	0f 84 91 00 00 00    	je     8038f0 <__umoddi3+0x144>
  80385f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803863:	29 f2                	sub    %esi,%edx
  803865:	19 cb                	sbb    %ecx,%ebx
  803867:	89 d8                	mov    %ebx,%eax
  803869:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80386d:	d3 e0                	shl    %cl,%eax
  80386f:	89 e9                	mov    %ebp,%ecx
  803871:	d3 ea                	shr    %cl,%edx
  803873:	09 d0                	or     %edx,%eax
  803875:	89 e9                	mov    %ebp,%ecx
  803877:	d3 eb                	shr    %cl,%ebx
  803879:	89 da                	mov    %ebx,%edx
  80387b:	83 c4 1c             	add    $0x1c,%esp
  80387e:	5b                   	pop    %ebx
  80387f:	5e                   	pop    %esi
  803880:	5f                   	pop    %edi
  803881:	5d                   	pop    %ebp
  803882:	c3                   	ret    
  803883:	90                   	nop
  803884:	89 fd                	mov    %edi,%ebp
  803886:	85 ff                	test   %edi,%edi
  803888:	75 0b                	jne    803895 <__umoddi3+0xe9>
  80388a:	b8 01 00 00 00       	mov    $0x1,%eax
  80388f:	31 d2                	xor    %edx,%edx
  803891:	f7 f7                	div    %edi
  803893:	89 c5                	mov    %eax,%ebp
  803895:	89 f0                	mov    %esi,%eax
  803897:	31 d2                	xor    %edx,%edx
  803899:	f7 f5                	div    %ebp
  80389b:	89 c8                	mov    %ecx,%eax
  80389d:	f7 f5                	div    %ebp
  80389f:	89 d0                	mov    %edx,%eax
  8038a1:	e9 44 ff ff ff       	jmp    8037ea <__umoddi3+0x3e>
  8038a6:	66 90                	xchg   %ax,%ax
  8038a8:	89 c8                	mov    %ecx,%eax
  8038aa:	89 f2                	mov    %esi,%edx
  8038ac:	83 c4 1c             	add    $0x1c,%esp
  8038af:	5b                   	pop    %ebx
  8038b0:	5e                   	pop    %esi
  8038b1:	5f                   	pop    %edi
  8038b2:	5d                   	pop    %ebp
  8038b3:	c3                   	ret    
  8038b4:	3b 04 24             	cmp    (%esp),%eax
  8038b7:	72 06                	jb     8038bf <__umoddi3+0x113>
  8038b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038bd:	77 0f                	ja     8038ce <__umoddi3+0x122>
  8038bf:	89 f2                	mov    %esi,%edx
  8038c1:	29 f9                	sub    %edi,%ecx
  8038c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038c7:	89 14 24             	mov    %edx,(%esp)
  8038ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038d2:	8b 14 24             	mov    (%esp),%edx
  8038d5:	83 c4 1c             	add    $0x1c,%esp
  8038d8:	5b                   	pop    %ebx
  8038d9:	5e                   	pop    %esi
  8038da:	5f                   	pop    %edi
  8038db:	5d                   	pop    %ebp
  8038dc:	c3                   	ret    
  8038dd:	8d 76 00             	lea    0x0(%esi),%esi
  8038e0:	2b 04 24             	sub    (%esp),%eax
  8038e3:	19 fa                	sbb    %edi,%edx
  8038e5:	89 d1                	mov    %edx,%ecx
  8038e7:	89 c6                	mov    %eax,%esi
  8038e9:	e9 71 ff ff ff       	jmp    80385f <__umoddi3+0xb3>
  8038ee:	66 90                	xchg   %ax,%ax
  8038f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038f4:	72 ea                	jb     8038e0 <__umoddi3+0x134>
  8038f6:	89 d9                	mov    %ebx,%ecx
  8038f8:	e9 62 ff ff ff       	jmp    80385f <__umoddi3+0xb3>
