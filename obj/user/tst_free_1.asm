
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 e3 10 00 00       	call   801119 <libmain>
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
  800067:	e8 fb 26 00 00       	call   802767 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 3e 27 00 00       	call   8027b2 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 a7 24 00 00       	call   80256e <malloc>
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
  8000df:	e8 83 26 00 00       	call   802767 <sys_calculate_free_frames>
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
  80012c:	e8 a8 14 00 00       	call   8015d9 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 79 26 00 00       	call   8027b2 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 7c 39 80 00       	push   $0x80397c
  800150:	6a 0c                	push   $0xc
  800152:	e8 82 14 00 00       	call   8015d9 <cprintf_colored>
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
  800174:	e8 ee 25 00 00       	call   802767 <sys_calculate_free_frames>
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
  8001b9:	e8 a9 25 00 00       	call   802767 <sys_calculate_free_frames>
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
  8001ff:	e8 d5 13 00 00       	call   8015d9 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 a6 25 00 00       	call   8027b2 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 80 3a 80 00       	push   $0x803a80
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 a8 13 00 00       	call   8015d9 <cprintf_colored>
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
  800270:	e8 b4 28 00 00       	call   802b29 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 f8 3a 80 00       	push   $0x803af8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 43 13 00 00       	call   8015d9 <cprintf_colored>
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
  8002ae:	e8 b4 24 00 00       	call   802767 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 f7 24 00 00       	call   8027b2 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 cb 22 00 00       	call   80259c <free>
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
  8002fc:	e8 b1 24 00 00       	call   8027b2 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 30 3b 80 00       	push   $0x803b30
  800318:	6a 0c                	push   $0xc
  80031a:	e8 ba 12 00 00       	call   8015d9 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 40 24 00 00       	call   802767 <sys_calculate_free_frames>
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
  800349:	e8 8b 12 00 00       	call   8015d9 <cprintf_colored>
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
  8003a0:	e8 84 27 00 00       	call   802b29 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 d8 3b 80 00       	push   $0x803bd8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 13 12 00 00       	call   8015d9 <cprintf_colored>
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
  80041d:	e8 b7 11 00 00       	call   8015d9 <cprintf_colored>
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
  8004e6:	e8 ee 10 00 00       	call   8015d9 <cprintf_colored>
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
  8005c0:	e8 14 10 00 00       	call   8015d9 <cprintf_colored>
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
  80069a:	e8 3a 0f 00 00       	call   8015d9 <cprintf_colored>
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
  800774:	e8 60 0e 00 00       	call   8015d9 <cprintf_colored>
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
  80084e:	e8 86 0d 00 00       	call   8015d9 <cprintf_colored>
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
  800928:	e8 ac 0c 00 00       	call   8015d9 <cprintf_colored>
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
  800a1d:	e8 b7 0b 00 00       	call   8015d9 <cprintf_colored>
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
  800b1b:	e8 b9 0a 00 00       	call   8015d9 <cprintf_colored>
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
  800c19:	e8 bb 09 00 00       	call   8015d9 <cprintf_colored>
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
  800d17:	e8 bd 08 00 00       	call   8015d9 <cprintf_colored>
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
  800e04:	e8 d0 07 00 00       	call   8015d9 <cprintf_colored>
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
  800ef1:	e8 e3 06 00 00       	call   8015d9 <cprintf_colored>
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
  800fde:	e8 f6 05 00 00       	call   8015d9 <cprintf_colored>
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
  801001:	e8 d3 05 00 00       	call   8015d9 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 48 17 00 00       	call   802767 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 88 17 00 00       	call   8027b2 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 14 15 00 00       	call   80256e <malloc>
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
  80108b:	e8 49 05 00 00       	call   8015d9 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 1a 17 00 00       	call   8027b2 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 ec 3c 80 00       	push   $0x803cec
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 1d 05 00 00       	call   8015d9 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 a3 16 00 00       	call   802767 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 5c 3d 80 00       	push   $0x803d5c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 f1 04 00 00       	call   8015d9 <cprintf_colored>
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
  801102:	83 ec 08             	sub    $0x8,%esp
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
			panic("Please increase the WS size");
	}
	/*=================================================*/
#else
	panic("not handled!");
  801105:	83 ec 04             	sub    $0x4,%esp
  801108:	68 a4 3d 80 00       	push   $0x803da4
  80110d:	6a 19                	push   $0x19
  80110f:	68 b1 3d 80 00       	push   $0x803db1
  801114:	e8 c5 01 00 00       	call   8012de <_panic>

00801119 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	57                   	push   %edi
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
  80111f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801122:	e8 09 18 00 00       	call   802930 <sys_getenvindex>
  801127:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80112a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	c1 e0 06             	shl    $0x6,%eax
  801132:	29 d0                	sub    %edx,%eax
  801134:	c1 e0 02             	shl    $0x2,%eax
  801137:	01 d0                	add    %edx,%eax
  801139:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801140:	01 c8                	add    %ecx,%eax
  801142:	c1 e0 03             	shl    $0x3,%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114e:	29 c2                	sub    %eax,%edx
  801150:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  801157:	89 c2                	mov    %eax,%edx
  801159:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80115f:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801164:	a1 00 52 80 00       	mov    0x805200,%eax
  801169:	8a 40 20             	mov    0x20(%eax),%al
  80116c:	84 c0                	test   %al,%al
  80116e:	74 0d                	je     80117d <libmain+0x64>
		binaryname = myEnv->prog_name;
  801170:	a1 00 52 80 00       	mov    0x805200,%eax
  801175:	83 c0 20             	add    $0x20,%eax
  801178:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80117d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801181:	7e 0a                	jle    80118d <libmain+0x74>
		binaryname = argv[0];
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 00                	mov    (%eax),%eax
  801188:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	ff 75 0c             	pushl  0xc(%ebp)
  801193:	ff 75 08             	pushl  0x8(%ebp)
  801196:	e8 64 ff ff ff       	call   8010ff <_main>
  80119b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80119e:	a1 00 50 80 00       	mov    0x805000,%eax
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	0f 84 01 01 00 00    	je     8012ac <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8011ab:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011b1:	bb bc 3e 80 00       	mov    $0x803ebc,%ebx
  8011b6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8011bb:	89 c7                	mov    %eax,%edi
  8011bd:	89 de                	mov    %ebx,%esi
  8011bf:	89 d1                	mov    %edx,%ecx
  8011c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8011c3:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8011c6:	b9 56 00 00 00       	mov    $0x56,%ecx
  8011cb:	b0 00                	mov    $0x0,%al
  8011cd:	89 d7                	mov    %edx,%edi
  8011cf:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8011d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8011d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	50                   	push   %eax
  8011df:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011e5:	50                   	push   %eax
  8011e6:	e8 7b 19 00 00       	call   802b66 <sys_utilities>
  8011eb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8011ee:	e8 c4 14 00 00       	call   8026b7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	68 dc 3d 80 00       	push   $0x803ddc
  8011fb:	e8 ac 03 00 00       	call   8015ac <cprintf>
  801200:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801206:	85 c0                	test   %eax,%eax
  801208:	74 18                	je     801222 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80120a:	e8 75 19 00 00       	call   802b84 <sys_get_optimal_num_faults>
  80120f:	83 ec 08             	sub    $0x8,%esp
  801212:	50                   	push   %eax
  801213:	68 04 3e 80 00       	push   $0x803e04
  801218:	e8 8f 03 00 00       	call   8015ac <cprintf>
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	eb 59                	jmp    80127b <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801222:	a1 00 52 80 00       	mov    0x805200,%eax
  801227:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80122d:	a1 00 52 80 00       	mov    0x805200,%eax
  801232:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	52                   	push   %edx
  80123c:	50                   	push   %eax
  80123d:	68 28 3e 80 00       	push   $0x803e28
  801242:	e8 65 03 00 00       	call   8015ac <cprintf>
  801247:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80124a:	a1 00 52 80 00       	mov    0x805200,%eax
  80124f:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  801255:	a1 00 52 80 00       	mov    0x805200,%eax
  80125a:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  801260:	a1 00 52 80 00       	mov    0x805200,%eax
  801265:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80126b:	51                   	push   %ecx
  80126c:	52                   	push   %edx
  80126d:	50                   	push   %eax
  80126e:	68 50 3e 80 00       	push   $0x803e50
  801273:	e8 34 03 00 00       	call   8015ac <cprintf>
  801278:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80127b:	a1 00 52 80 00       	mov    0x805200,%eax
  801280:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  801286:	83 ec 08             	sub    $0x8,%esp
  801289:	50                   	push   %eax
  80128a:	68 a8 3e 80 00       	push   $0x803ea8
  80128f:	e8 18 03 00 00       	call   8015ac <cprintf>
  801294:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801297:	83 ec 0c             	sub    $0xc,%esp
  80129a:	68 dc 3d 80 00       	push   $0x803ddc
  80129f:	e8 08 03 00 00       	call   8015ac <cprintf>
  8012a4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8012a7:	e8 25 14 00 00       	call   8026d1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8012ac:	e8 1f 00 00 00       	call   8012d0 <exit>
}
  8012b1:	90                   	nop
  8012b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b5:	5b                   	pop    %ebx
  8012b6:	5e                   	pop    %esi
  8012b7:	5f                   	pop    %edi
  8012b8:	5d                   	pop    %ebp
  8012b9:	c3                   	ret    

008012ba <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8012c0:	83 ec 0c             	sub    $0xc,%esp
  8012c3:	6a 00                	push   $0x0
  8012c5:	e8 32 16 00 00       	call   8028fc <sys_destroy_env>
  8012ca:	83 c4 10             	add    $0x10,%esp
}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <exit>:

void
exit(void)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012d6:	e8 87 16 00 00       	call   802962 <sys_exit_env>
}
  8012db:	90                   	nop
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8012e7:	83 c0 04             	add    $0x4,%eax
  8012ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012ed:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	74 16                	je     80130c <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012f6:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	50                   	push   %eax
  8012ff:	68 20 3f 80 00       	push   $0x803f20
  801304:	e8 a3 02 00 00       	call   8015ac <cprintf>
  801309:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80130c:	a1 04 50 80 00       	mov    0x805004,%eax
  801311:	83 ec 0c             	sub    $0xc,%esp
  801314:	ff 75 0c             	pushl  0xc(%ebp)
  801317:	ff 75 08             	pushl  0x8(%ebp)
  80131a:	50                   	push   %eax
  80131b:	68 28 3f 80 00       	push   $0x803f28
  801320:	6a 74                	push   $0x74
  801322:	e8 b2 02 00 00       	call   8015d9 <cprintf_colored>
  801327:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80132a:	8b 45 10             	mov    0x10(%ebp),%eax
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 f4             	pushl  -0xc(%ebp)
  801333:	50                   	push   %eax
  801334:	e8 04 02 00 00       	call   80153d <vcprintf>
  801339:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	6a 00                	push   $0x0
  801341:	68 50 3f 80 00       	push   $0x803f50
  801346:	e8 f2 01 00 00       	call   80153d <vcprintf>
  80134b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80134e:	e8 7d ff ff ff       	call   8012d0 <exit>

	// should not return here
	while (1) ;
  801353:	eb fe                	jmp    801353 <_panic+0x75>

00801355 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80135b:	a1 00 52 80 00       	mov    0x805200,%eax
  801360:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	39 c2                	cmp    %eax,%edx
  80136b:	74 14                	je     801381 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	68 54 3f 80 00       	push   $0x803f54
  801375:	6a 26                	push   $0x26
  801377:	68 a0 3f 80 00       	push   $0x803fa0
  80137c:	e8 5d ff ff ff       	call   8012de <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801381:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80138f:	e9 c5 00 00 00       	jmp    801459 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801397:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	01 d0                	add    %edx,%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	75 08                	jne    8013b1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8013a9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8013ac:	e9 a5 00 00 00       	jmp    801456 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8013b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013bf:	eb 69                	jmp    80142a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8013c1:	a1 00 52 80 00       	mov    0x805200,%eax
  8013c6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8013cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013cf:	89 d0                	mov    %edx,%eax
  8013d1:	01 c0                	add    %eax,%eax
  8013d3:	01 d0                	add    %edx,%eax
  8013d5:	c1 e0 03             	shl    $0x3,%eax
  8013d8:	01 c8                	add    %ecx,%eax
  8013da:	8a 40 04             	mov    0x4(%eax),%al
  8013dd:	84 c0                	test   %al,%al
  8013df:	75 46                	jne    801427 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013e1:	a1 00 52 80 00       	mov    0x805200,%eax
  8013e6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8013ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013ef:	89 d0                	mov    %edx,%eax
  8013f1:	01 c0                	add    %eax,%eax
  8013f3:	01 d0                	add    %edx,%eax
  8013f5:	c1 e0 03             	shl    $0x3,%eax
  8013f8:	01 c8                	add    %ecx,%eax
  8013fa:	8b 00                	mov    (%eax),%eax
  8013fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801402:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801407:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	01 c8                	add    %ecx,%eax
  801418:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80141a:	39 c2                	cmp    %eax,%edx
  80141c:	75 09                	jne    801427 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80141e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801425:	eb 15                	jmp    80143c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801427:	ff 45 e8             	incl   -0x18(%ebp)
  80142a:	a1 00 52 80 00       	mov    0x805200,%eax
  80142f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801438:	39 c2                	cmp    %eax,%edx
  80143a:	77 85                	ja     8013c1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80143c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801440:	75 14                	jne    801456 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	68 ac 3f 80 00       	push   $0x803fac
  80144a:	6a 3a                	push   $0x3a
  80144c:	68 a0 3f 80 00       	push   $0x803fa0
  801451:	e8 88 fe ff ff       	call   8012de <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801456:	ff 45 f0             	incl   -0x10(%ebp)
  801459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80145f:	0f 8c 2f ff ff ff    	jl     801394 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80146c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801473:	eb 26                	jmp    80149b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801475:	a1 00 52 80 00       	mov    0x805200,%eax
  80147a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801483:	89 d0                	mov    %edx,%eax
  801485:	01 c0                	add    %eax,%eax
  801487:	01 d0                	add    %edx,%eax
  801489:	c1 e0 03             	shl    $0x3,%eax
  80148c:	01 c8                	add    %ecx,%eax
  80148e:	8a 40 04             	mov    0x4(%eax),%al
  801491:	3c 01                	cmp    $0x1,%al
  801493:	75 03                	jne    801498 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801498:	ff 45 e0             	incl   -0x20(%ebp)
  80149b:	a1 00 52 80 00       	mov    0x805200,%eax
  8014a0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8014a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a9:	39 c2                	cmp    %eax,%edx
  8014ab:	77 c8                	ja     801475 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8014b3:	74 14                	je     8014c9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	68 00 40 80 00       	push   $0x804000
  8014bd:	6a 44                	push   $0x44
  8014bf:	68 a0 3f 80 00       	push   $0x803fa0
  8014c4:	e8 15 fe ff ff       	call   8012de <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8014d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d6:	8b 00                	mov    (%eax),%eax
  8014d8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014de:	89 0a                	mov    %ecx,(%edx)
  8014e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e3:	88 d1                	mov    %dl,%cl
  8014e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ef:	8b 00                	mov    (%eax),%eax
  8014f1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014f6:	75 30                	jne    801528 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8014f8:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  8014fe:	a0 24 52 80 00       	mov    0x805224,%al
  801503:	0f b6 c0             	movzbl %al,%eax
  801506:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801509:	8b 09                	mov    (%ecx),%ecx
  80150b:	89 cb                	mov    %ecx,%ebx
  80150d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801510:	83 c1 08             	add    $0x8,%ecx
  801513:	52                   	push   %edx
  801514:	50                   	push   %eax
  801515:	53                   	push   %ebx
  801516:	51                   	push   %ecx
  801517:	e8 57 11 00 00       	call   802673 <sys_cputs>
  80151c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80151f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152b:	8b 40 04             	mov    0x4(%eax),%eax
  80152e:	8d 50 01             	lea    0x1(%eax),%edx
  801531:	8b 45 0c             	mov    0xc(%ebp),%eax
  801534:	89 50 04             	mov    %edx,0x4(%eax)
}
  801537:	90                   	nop
  801538:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801546:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80154d:	00 00 00 
	b.cnt = 0;
  801550:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801557:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	ff 75 08             	pushl  0x8(%ebp)
  801560:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801566:	50                   	push   %eax
  801567:	68 cc 14 80 00       	push   $0x8014cc
  80156c:	e8 5a 02 00 00       	call   8017cb <vprintfmt>
  801571:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801574:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  80157a:	a0 24 52 80 00       	mov    0x805224,%al
  80157f:	0f b6 c0             	movzbl %al,%eax
  801582:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801588:	52                   	push   %edx
  801589:	50                   	push   %eax
  80158a:	51                   	push   %ecx
  80158b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801591:	83 c0 08             	add    $0x8,%eax
  801594:	50                   	push   %eax
  801595:	e8 d9 10 00 00       	call   802673 <sys_cputs>
  80159a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80159d:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  8015a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015b2:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  8015b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	83 ec 08             	sub    $0x8,%esp
  8015c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	e8 6f ff ff ff       	call   80153d <vcprintf>
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015df:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	c1 e0 08             	shl    $0x8,%eax
  8015ec:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  8015f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015f4:	83 c0 04             	add    $0x4,%eax
  8015f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 f4             	pushl  -0xc(%ebp)
  801603:	50                   	push   %eax
  801604:	e8 34 ff ff ff       	call   80153d <vcprintf>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80160f:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  801616:	07 00 00 

	return cnt;
  801619:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801624:	e8 8e 10 00 00       	call   8026b7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801629:	8d 45 0c             	lea    0xc(%ebp),%eax
  80162c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	ff 75 f4             	pushl  -0xc(%ebp)
  801638:	50                   	push   %eax
  801639:	e8 ff fe ff ff       	call   80153d <vcprintf>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801644:	e8 88 10 00 00       	call   8026d1 <sys_unlock_cons>
	return cnt;
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	53                   	push   %ebx
  801652:	83 ec 14             	sub    $0x14,%esp
  801655:	8b 45 10             	mov    0x10(%ebp),%eax
  801658:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80165b:	8b 45 14             	mov    0x14(%ebp),%eax
  80165e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801661:	8b 45 18             	mov    0x18(%ebp),%eax
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80166c:	77 55                	ja     8016c3 <printnum+0x75>
  80166e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801671:	72 05                	jb     801678 <printnum+0x2a>
  801673:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801676:	77 4b                	ja     8016c3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801678:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80167b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80167e:	8b 45 18             	mov    0x18(%ebp),%eax
  801681:	ba 00 00 00 00       	mov    $0x0,%edx
  801686:	52                   	push   %edx
  801687:	50                   	push   %eax
  801688:	ff 75 f4             	pushl  -0xc(%ebp)
  80168b:	ff 75 f0             	pushl  -0x10(%ebp)
  80168e:	e8 09 20 00 00       	call   80369c <__udivdi3>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	ff 75 20             	pushl  0x20(%ebp)
  80169c:	53                   	push   %ebx
  80169d:	ff 75 18             	pushl  0x18(%ebp)
  8016a0:	52                   	push   %edx
  8016a1:	50                   	push   %eax
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	e8 a1 ff ff ff       	call   80164e <printnum>
  8016ad:	83 c4 20             	add    $0x20,%esp
  8016b0:	eb 1a                	jmp    8016cc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	ff 75 0c             	pushl  0xc(%ebp)
  8016b8:	ff 75 20             	pushl  0x20(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	ff d0                	call   *%eax
  8016c0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016c3:	ff 4d 1c             	decl   0x1c(%ebp)
  8016c6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8016ca:	7f e6                	jg     8016b2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016cc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8016cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016da:	53                   	push   %ebx
  8016db:	51                   	push   %ecx
  8016dc:	52                   	push   %edx
  8016dd:	50                   	push   %eax
  8016de:	e8 c9 20 00 00       	call   8037ac <__umoddi3>
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	05 74 42 80 00       	add    $0x804274,%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	0f be c0             	movsbl %al,%eax
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	50                   	push   %eax
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	ff d0                	call   *%eax
  8016fc:	83 c4 10             	add    $0x10,%esp
}
  8016ff:	90                   	nop
  801700:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801708:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80170c:	7e 1c                	jle    80172a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8b 00                	mov    (%eax),%eax
  801713:	8d 50 08             	lea    0x8(%eax),%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	89 10                	mov    %edx,(%eax)
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8b 00                	mov    (%eax),%eax
  801720:	83 e8 08             	sub    $0x8,%eax
  801723:	8b 50 04             	mov    0x4(%eax),%edx
  801726:	8b 00                	mov    (%eax),%eax
  801728:	eb 40                	jmp    80176a <getuint+0x65>
	else if (lflag)
  80172a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172e:	74 1e                	je     80174e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	8d 50 04             	lea    0x4(%eax),%edx
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	89 10                	mov    %edx,(%eax)
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8b 00                	mov    (%eax),%eax
  801742:	83 e8 04             	sub    $0x4,%eax
  801745:	8b 00                	mov    (%eax),%eax
  801747:	ba 00 00 00 00       	mov    $0x0,%edx
  80174c:	eb 1c                	jmp    80176a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8b 00                	mov    (%eax),%eax
  801753:	8d 50 04             	lea    0x4(%eax),%edx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	89 10                	mov    %edx,(%eax)
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8b 00                	mov    (%eax),%eax
  801760:	83 e8 04             	sub    $0x4,%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80176f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801773:	7e 1c                	jle    801791 <getint+0x25>
		return va_arg(*ap, long long);
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8b 00                	mov    (%eax),%eax
  80177a:	8d 50 08             	lea    0x8(%eax),%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	89 10                	mov    %edx,(%eax)
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	83 e8 08             	sub    $0x8,%eax
  80178a:	8b 50 04             	mov    0x4(%eax),%edx
  80178d:	8b 00                	mov    (%eax),%eax
  80178f:	eb 38                	jmp    8017c9 <getint+0x5d>
	else if (lflag)
  801791:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801795:	74 1a                	je     8017b1 <getint+0x45>
		return va_arg(*ap, long);
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	8d 50 04             	lea    0x4(%eax),%edx
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	89 10                	mov    %edx,(%eax)
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	83 e8 04             	sub    $0x4,%eax
  8017ac:	8b 00                	mov    (%eax),%eax
  8017ae:	99                   	cltd   
  8017af:	eb 18                	jmp    8017c9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8b 00                	mov    (%eax),%eax
  8017b6:	8d 50 04             	lea    0x4(%eax),%edx
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	89 10                	mov    %edx,(%eax)
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8b 00                	mov    (%eax),%eax
  8017c3:	83 e8 04             	sub    $0x4,%eax
  8017c6:	8b 00                	mov    (%eax),%eax
  8017c8:	99                   	cltd   
}
  8017c9:	5d                   	pop    %ebp
  8017ca:	c3                   	ret    

008017cb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	56                   	push   %esi
  8017cf:	53                   	push   %ebx
  8017d0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017d3:	eb 17                	jmp    8017ec <vprintfmt+0x21>
			if (ch == '\0')
  8017d5:	85 db                	test   %ebx,%ebx
  8017d7:	0f 84 c1 03 00 00    	je     801b9e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	53                   	push   %ebx
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	ff d0                	call   *%eax
  8017e9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ef:	8d 50 01             	lea    0x1(%eax),%edx
  8017f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8017f5:	8a 00                	mov    (%eax),%al
  8017f7:	0f b6 d8             	movzbl %al,%ebx
  8017fa:	83 fb 25             	cmp    $0x25,%ebx
  8017fd:	75 d6                	jne    8017d5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8017ff:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801803:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80180a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801811:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801818:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80181f:	8b 45 10             	mov    0x10(%ebp),%eax
  801822:	8d 50 01             	lea    0x1(%eax),%edx
  801825:	89 55 10             	mov    %edx,0x10(%ebp)
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f b6 d8             	movzbl %al,%ebx
  80182d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801830:	83 f8 5b             	cmp    $0x5b,%eax
  801833:	0f 87 3d 03 00 00    	ja     801b76 <vprintfmt+0x3ab>
  801839:	8b 04 85 98 42 80 00 	mov    0x804298(,%eax,4),%eax
  801840:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801842:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801846:	eb d7                	jmp    80181f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801848:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80184c:	eb d1                	jmp    80181f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80184e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801855:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801858:	89 d0                	mov    %edx,%eax
  80185a:	c1 e0 02             	shl    $0x2,%eax
  80185d:	01 d0                	add    %edx,%eax
  80185f:	01 c0                	add    %eax,%eax
  801861:	01 d8                	add    %ebx,%eax
  801863:	83 e8 30             	sub    $0x30,%eax
  801866:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801869:	8b 45 10             	mov    0x10(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801871:	83 fb 2f             	cmp    $0x2f,%ebx
  801874:	7e 3e                	jle    8018b4 <vprintfmt+0xe9>
  801876:	83 fb 39             	cmp    $0x39,%ebx
  801879:	7f 39                	jg     8018b4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80187b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80187e:	eb d5                	jmp    801855 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801880:	8b 45 14             	mov    0x14(%ebp),%eax
  801883:	83 c0 04             	add    $0x4,%eax
  801886:	89 45 14             	mov    %eax,0x14(%ebp)
  801889:	8b 45 14             	mov    0x14(%ebp),%eax
  80188c:	83 e8 04             	sub    $0x4,%eax
  80188f:	8b 00                	mov    (%eax),%eax
  801891:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801894:	eb 1f                	jmp    8018b5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801896:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80189a:	79 83                	jns    80181f <vprintfmt+0x54>
				width = 0;
  80189c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8018a3:	e9 77 ff ff ff       	jmp    80181f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8018a8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8018af:	e9 6b ff ff ff       	jmp    80181f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8018b4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8018b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018b9:	0f 89 60 ff ff ff    	jns    80181f <vprintfmt+0x54>
				width = precision, precision = -1;
  8018bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8018cc:	e9 4e ff ff ff       	jmp    80181f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8018d1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8018d4:	e9 46 ff ff ff       	jmp    80181f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8018d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018dc:	83 c0 04             	add    $0x4,%eax
  8018df:	89 45 14             	mov    %eax,0x14(%ebp)
  8018e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e5:	83 e8 04             	sub    $0x4,%eax
  8018e8:	8b 00                	mov    (%eax),%eax
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	50                   	push   %eax
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	ff d0                	call   *%eax
  8018f6:	83 c4 10             	add    $0x10,%esp
			break;
  8018f9:	e9 9b 02 00 00       	jmp    801b99 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8018fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801901:	83 c0 04             	add    $0x4,%eax
  801904:	89 45 14             	mov    %eax,0x14(%ebp)
  801907:	8b 45 14             	mov    0x14(%ebp),%eax
  80190a:	83 e8 04             	sub    $0x4,%eax
  80190d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80190f:	85 db                	test   %ebx,%ebx
  801911:	79 02                	jns    801915 <vprintfmt+0x14a>
				err = -err;
  801913:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801915:	83 fb 64             	cmp    $0x64,%ebx
  801918:	7f 0b                	jg     801925 <vprintfmt+0x15a>
  80191a:	8b 34 9d e0 40 80 00 	mov    0x8040e0(,%ebx,4),%esi
  801921:	85 f6                	test   %esi,%esi
  801923:	75 19                	jne    80193e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801925:	53                   	push   %ebx
  801926:	68 85 42 80 00       	push   $0x804285
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	e8 70 02 00 00       	call   801ba6 <printfmt>
  801936:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801939:	e9 5b 02 00 00       	jmp    801b99 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80193e:	56                   	push   %esi
  80193f:	68 8e 42 80 00       	push   $0x80428e
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	ff 75 08             	pushl  0x8(%ebp)
  80194a:	e8 57 02 00 00       	call   801ba6 <printfmt>
  80194f:	83 c4 10             	add    $0x10,%esp
			break;
  801952:	e9 42 02 00 00       	jmp    801b99 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801957:	8b 45 14             	mov    0x14(%ebp),%eax
  80195a:	83 c0 04             	add    $0x4,%eax
  80195d:	89 45 14             	mov    %eax,0x14(%ebp)
  801960:	8b 45 14             	mov    0x14(%ebp),%eax
  801963:	83 e8 04             	sub    $0x4,%eax
  801966:	8b 30                	mov    (%eax),%esi
  801968:	85 f6                	test   %esi,%esi
  80196a:	75 05                	jne    801971 <vprintfmt+0x1a6>
				p = "(null)";
  80196c:	be 91 42 80 00       	mov    $0x804291,%esi
			if (width > 0 && padc != '-')
  801971:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801975:	7e 6d                	jle    8019e4 <vprintfmt+0x219>
  801977:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80197b:	74 67                	je     8019e4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80197d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801980:	83 ec 08             	sub    $0x8,%esp
  801983:	50                   	push   %eax
  801984:	56                   	push   %esi
  801985:	e8 1e 03 00 00       	call   801ca8 <strnlen>
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801990:	eb 16                	jmp    8019a8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801992:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801996:	83 ec 08             	sub    $0x8,%esp
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	50                   	push   %eax
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	ff d0                	call   *%eax
  8019a2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8019a5:	ff 4d e4             	decl   -0x1c(%ebp)
  8019a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019ac:	7f e4                	jg     801992 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019ae:	eb 34                	jmp    8019e4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8019b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019b4:	74 1c                	je     8019d2 <vprintfmt+0x207>
  8019b6:	83 fb 1f             	cmp    $0x1f,%ebx
  8019b9:	7e 05                	jle    8019c0 <vprintfmt+0x1f5>
  8019bb:	83 fb 7e             	cmp    $0x7e,%ebx
  8019be:	7e 12                	jle    8019d2 <vprintfmt+0x207>
					putch('?', putdat);
  8019c0:	83 ec 08             	sub    $0x8,%esp
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	6a 3f                	push   $0x3f
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	ff d0                	call   *%eax
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	eb 0f                	jmp    8019e1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8019d2:	83 ec 08             	sub    $0x8,%esp
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	53                   	push   %ebx
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	ff d0                	call   *%eax
  8019de:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019e1:	ff 4d e4             	decl   -0x1c(%ebp)
  8019e4:	89 f0                	mov    %esi,%eax
  8019e6:	8d 70 01             	lea    0x1(%eax),%esi
  8019e9:	8a 00                	mov    (%eax),%al
  8019eb:	0f be d8             	movsbl %al,%ebx
  8019ee:	85 db                	test   %ebx,%ebx
  8019f0:	74 24                	je     801a16 <vprintfmt+0x24b>
  8019f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019f6:	78 b8                	js     8019b0 <vprintfmt+0x1e5>
  8019f8:	ff 4d e0             	decl   -0x20(%ebp)
  8019fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019ff:	79 af                	jns    8019b0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a01:	eb 13                	jmp    801a16 <vprintfmt+0x24b>
				putch(' ', putdat);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	6a 20                	push   $0x20
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	ff d0                	call   *%eax
  801a10:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a13:	ff 4d e4             	decl   -0x1c(%ebp)
  801a16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a1a:	7f e7                	jg     801a03 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801a1c:	e9 78 01 00 00       	jmp    801b99 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801a21:	83 ec 08             	sub    $0x8,%esp
  801a24:	ff 75 e8             	pushl  -0x18(%ebp)
  801a27:	8d 45 14             	lea    0x14(%ebp),%eax
  801a2a:	50                   	push   %eax
  801a2b:	e8 3c fd ff ff       	call   80176c <getint>
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a3f:	85 d2                	test   %edx,%edx
  801a41:	79 23                	jns    801a66 <vprintfmt+0x29b>
				putch('-', putdat);
  801a43:	83 ec 08             	sub    $0x8,%esp
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	6a 2d                	push   $0x2d
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	ff d0                	call   *%eax
  801a50:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a59:	f7 d8                	neg    %eax
  801a5b:	83 d2 00             	adc    $0x0,%edx
  801a5e:	f7 da                	neg    %edx
  801a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801a66:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a6d:	e9 bc 00 00 00       	jmp    801b2e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801a72:	83 ec 08             	sub    $0x8,%esp
  801a75:	ff 75 e8             	pushl  -0x18(%ebp)
  801a78:	8d 45 14             	lea    0x14(%ebp),%eax
  801a7b:	50                   	push   %eax
  801a7c:	e8 84 fc ff ff       	call   801705 <getuint>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a87:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801a8a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a91:	e9 98 00 00 00       	jmp    801b2e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a96:	83 ec 08             	sub    $0x8,%esp
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	6a 58                	push   $0x58
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	ff d0                	call   *%eax
  801aa3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801aa6:	83 ec 08             	sub    $0x8,%esp
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	6a 58                	push   $0x58
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	ff d0                	call   *%eax
  801ab3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	6a 58                	push   $0x58
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	ff d0                	call   *%eax
  801ac3:	83 c4 10             	add    $0x10,%esp
			break;
  801ac6:	e9 ce 00 00 00       	jmp    801b99 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801acb:	83 ec 08             	sub    $0x8,%esp
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	6a 30                	push   $0x30
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	ff d0                	call   *%eax
  801ad8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	ff 75 0c             	pushl  0xc(%ebp)
  801ae1:	6a 78                	push   $0x78
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	ff d0                	call   *%eax
  801ae8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801aeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801aee:	83 c0 04             	add    $0x4,%eax
  801af1:	89 45 14             	mov    %eax,0x14(%ebp)
  801af4:	8b 45 14             	mov    0x14(%ebp),%eax
  801af7:	83 e8 04             	sub    $0x4,%eax
  801afa:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801b06:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801b0d:	eb 1f                	jmp    801b2e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	ff 75 e8             	pushl  -0x18(%ebp)
  801b15:	8d 45 14             	lea    0x14(%ebp),%eax
  801b18:	50                   	push   %eax
  801b19:	e8 e7 fb ff ff       	call   801705 <getuint>
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801b27:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801b2e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b35:	83 ec 04             	sub    $0x4,%esp
  801b38:	52                   	push   %edx
  801b39:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b3c:	50                   	push   %eax
  801b3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b40:	ff 75 f0             	pushl  -0x10(%ebp)
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	ff 75 08             	pushl  0x8(%ebp)
  801b49:	e8 00 fb ff ff       	call   80164e <printnum>
  801b4e:	83 c4 20             	add    $0x20,%esp
			break;
  801b51:	eb 46                	jmp    801b99 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801b53:	83 ec 08             	sub    $0x8,%esp
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	53                   	push   %ebx
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	ff d0                	call   *%eax
  801b5f:	83 c4 10             	add    $0x10,%esp
			break;
  801b62:	eb 35                	jmp    801b99 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801b64:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801b6b:	eb 2c                	jmp    801b99 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801b6d:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801b74:	eb 23                	jmp    801b99 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	6a 25                	push   $0x25
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	ff d0                	call   *%eax
  801b83:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b86:	ff 4d 10             	decl   0x10(%ebp)
  801b89:	eb 03                	jmp    801b8e <vprintfmt+0x3c3>
  801b8b:	ff 4d 10             	decl   0x10(%ebp)
  801b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b91:	48                   	dec    %eax
  801b92:	8a 00                	mov    (%eax),%al
  801b94:	3c 25                	cmp    $0x25,%al
  801b96:	75 f3                	jne    801b8b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801b98:	90                   	nop
		}
	}
  801b99:	e9 35 fc ff ff       	jmp    8017d3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801b9e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801b9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    

00801ba6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801bac:	8d 45 10             	lea    0x10(%ebp),%eax
  801baf:	83 c0 04             	add    $0x4,%eax
  801bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbb:	50                   	push   %eax
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	ff 75 08             	pushl  0x8(%ebp)
  801bc2:	e8 04 fc ff ff       	call   8017cb <vprintfmt>
  801bc7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd3:	8b 40 08             	mov    0x8(%eax),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be2:	8b 10                	mov    (%eax),%edx
  801be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be7:	8b 40 04             	mov    0x4(%eax),%eax
  801bea:	39 c2                	cmp    %eax,%edx
  801bec:	73 12                	jae    801c00 <sprintputch+0x33>
		*b->buf++ = ch;
  801bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf1:	8b 00                	mov    (%eax),%eax
  801bf3:	8d 48 01             	lea    0x1(%eax),%ecx
  801bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf9:	89 0a                	mov    %ecx,(%edx)
  801bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bfe:	88 10                	mov    %dl,(%eax)
}
  801c00:	90                   	nop
  801c01:	5d                   	pop    %ebp
  801c02:	c3                   	ret    

00801c03 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c12:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c28:	74 06                	je     801c30 <vsnprintf+0x2d>
  801c2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c2e:	7f 07                	jg     801c37 <vsnprintf+0x34>
		return -E_INVAL;
  801c30:	b8 03 00 00 00       	mov    $0x3,%eax
  801c35:	eb 20                	jmp    801c57 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c37:	ff 75 14             	pushl  0x14(%ebp)
  801c3a:	ff 75 10             	pushl  0x10(%ebp)
  801c3d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c40:	50                   	push   %eax
  801c41:	68 cd 1b 80 00       	push   $0x801bcd
  801c46:	e8 80 fb ff ff       	call   8017cb <vprintfmt>
  801c4b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c51:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c5f:	8d 45 10             	lea    0x10(%ebp),%eax
  801c62:	83 c0 04             	add    $0x4,%eax
  801c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6e:	50                   	push   %eax
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	e8 89 ff ff ff       	call   801c03 <vsnprintf>
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801c8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c92:	eb 06                	jmp    801c9a <strlen+0x15>
		n++;
  801c94:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801c97:	ff 45 08             	incl   0x8(%ebp)
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	8a 00                	mov    (%eax),%al
  801c9f:	84 c0                	test   %al,%al
  801ca1:	75 f1                	jne    801c94 <strlen+0xf>
		n++;
	return n;
  801ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cb5:	eb 09                	jmp    801cc0 <strnlen+0x18>
		n++;
  801cb7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cba:	ff 45 08             	incl   0x8(%ebp)
  801cbd:	ff 4d 0c             	decl   0xc(%ebp)
  801cc0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cc4:	74 09                	je     801ccf <strnlen+0x27>
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	8a 00                	mov    (%eax),%al
  801ccb:	84 c0                	test   %al,%al
  801ccd:	75 e8                	jne    801cb7 <strnlen+0xf>
		n++;
	return n;
  801ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801ce0:	90                   	nop
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	8d 50 01             	lea    0x1(%eax),%edx
  801ce7:	89 55 08             	mov    %edx,0x8(%ebp)
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cf0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cf3:	8a 12                	mov    (%edx),%dl
  801cf5:	88 10                	mov    %dl,(%eax)
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	84 c0                	test   %al,%al
  801cfb:	75 e4                	jne    801ce1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801cfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801d0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d15:	eb 1f                	jmp    801d36 <strncpy+0x34>
		*dst++ = *src;
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	8d 50 01             	lea    0x1(%eax),%edx
  801d1d:	89 55 08             	mov    %edx,0x8(%ebp)
  801d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d23:	8a 12                	mov    (%edx),%dl
  801d25:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	8a 00                	mov    (%eax),%al
  801d2c:	84 c0                	test   %al,%al
  801d2e:	74 03                	je     801d33 <strncpy+0x31>
			src++;
  801d30:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d33:	ff 45 fc             	incl   -0x4(%ebp)
  801d36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d39:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d3c:	72 d9                	jb     801d17 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801d3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d53:	74 30                	je     801d85 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801d55:	eb 16                	jmp    801d6d <strlcpy+0x2a>
			*dst++ = *src++;
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	8d 50 01             	lea    0x1(%eax),%edx
  801d5d:	89 55 08             	mov    %edx,0x8(%ebp)
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d66:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d69:	8a 12                	mov    (%edx),%dl
  801d6b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801d6d:	ff 4d 10             	decl   0x10(%ebp)
  801d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d74:	74 09                	je     801d7f <strlcpy+0x3c>
  801d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d79:	8a 00                	mov    (%eax),%al
  801d7b:	84 c0                	test   %al,%al
  801d7d:	75 d8                	jne    801d57 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d85:	8b 55 08             	mov    0x8(%ebp),%edx
  801d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d8b:	29 c2                	sub    %eax,%edx
  801d8d:	89 d0                	mov    %edx,%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801d94:	eb 06                	jmp    801d9c <strcmp+0xb>
		p++, q++;
  801d96:	ff 45 08             	incl   0x8(%ebp)
  801d99:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	8a 00                	mov    (%eax),%al
  801da1:	84 c0                	test   %al,%al
  801da3:	74 0e                	je     801db3 <strcmp+0x22>
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	8a 10                	mov    (%eax),%dl
  801daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dad:	8a 00                	mov    (%eax),%al
  801daf:	38 c2                	cmp    %al,%dl
  801db1:	74 e3                	je     801d96 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	8a 00                	mov    (%eax),%al
  801db8:	0f b6 d0             	movzbl %al,%edx
  801dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbe:	8a 00                	mov    (%eax),%al
  801dc0:	0f b6 c0             	movzbl %al,%eax
  801dc3:	29 c2                	sub    %eax,%edx
  801dc5:	89 d0                	mov    %edx,%eax
}
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    

00801dc9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801dcc:	eb 09                	jmp    801dd7 <strncmp+0xe>
		n--, p++, q++;
  801dce:	ff 4d 10             	decl   0x10(%ebp)
  801dd1:	ff 45 08             	incl   0x8(%ebp)
  801dd4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801dd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ddb:	74 17                	je     801df4 <strncmp+0x2b>
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	8a 00                	mov    (%eax),%al
  801de2:	84 c0                	test   %al,%al
  801de4:	74 0e                	je     801df4 <strncmp+0x2b>
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	8a 10                	mov    (%eax),%dl
  801deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dee:	8a 00                	mov    (%eax),%al
  801df0:	38 c2                	cmp    %al,%dl
  801df2:	74 da                	je     801dce <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801df8:	75 07                	jne    801e01 <strncmp+0x38>
		return 0;
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	eb 14                	jmp    801e15 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	0f b6 d0             	movzbl %al,%edx
  801e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0c:	8a 00                	mov    (%eax),%al
  801e0e:	0f b6 c0             	movzbl %al,%eax
  801e11:	29 c2                	sub    %eax,%edx
  801e13:	89 d0                	mov    %edx,%eax
}
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    

00801e17 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e20:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e23:	eb 12                	jmp    801e37 <strchr+0x20>
		if (*s == c)
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	8a 00                	mov    (%eax),%al
  801e2a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e2d:	75 05                	jne    801e34 <strchr+0x1d>
			return (char *) s;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	eb 11                	jmp    801e45 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801e34:	ff 45 08             	incl   0x8(%ebp)
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	8a 00                	mov    (%eax),%al
  801e3c:	84 c0                	test   %al,%al
  801e3e:	75 e5                	jne    801e25 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e53:	eb 0d                	jmp    801e62 <strfind+0x1b>
		if (*s == c)
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	8a 00                	mov    (%eax),%al
  801e5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e5d:	74 0e                	je     801e6d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801e5f:	ff 45 08             	incl   0x8(%ebp)
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	8a 00                	mov    (%eax),%al
  801e67:	84 c0                	test   %al,%al
  801e69:	75 ea                	jne    801e55 <strfind+0xe>
  801e6b:	eb 01                	jmp    801e6e <strfind+0x27>
		if (*s == c)
			break;
  801e6d:	90                   	nop
	return (char *) s;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801e7f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801e83:	76 63                	jbe    801ee8 <memset+0x75>
		uint64 data_block = c;
  801e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e88:	99                   	cltd   
  801e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e95:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801e99:	c1 e0 08             	shl    $0x8,%eax
  801e9c:	09 45 f0             	or     %eax,-0x10(%ebp)
  801e9f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801eac:	c1 e0 10             	shl    $0x10,%eax
  801eaf:	09 45 f0             	or     %eax,-0x10(%ebp)
  801eb2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebb:	89 c2                	mov    %eax,%edx
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	09 45 f0             	or     %eax,-0x10(%ebp)
  801ec5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801ec8:	eb 18                	jmp    801ee2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801eca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ecd:	8d 41 08             	lea    0x8(%ecx),%eax
  801ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed9:	89 01                	mov    %eax,(%ecx)
  801edb:	89 51 04             	mov    %edx,0x4(%ecx)
  801ede:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801ee2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ee6:	77 e2                	ja     801eca <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801ee8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eec:	74 23                	je     801f11 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801ef4:	eb 0e                	jmp    801f04 <memset+0x91>
			*p8++ = (uint8)c;
  801ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ef9:	8d 50 01             	lea    0x1(%eax),%edx
  801efc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f02:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801f04:	8b 45 10             	mov    0x10(%ebp),%eax
  801f07:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f0a:	89 55 10             	mov    %edx,0x10(%ebp)
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	75 e5                	jne    801ef6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801f28:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f2c:	76 24                	jbe    801f52 <memcpy+0x3c>
		while(n >= 8){
  801f2e:	eb 1c                	jmp    801f4c <memcpy+0x36>
			*d64 = *s64;
  801f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f33:	8b 50 04             	mov    0x4(%eax),%edx
  801f36:	8b 00                	mov    (%eax),%eax
  801f38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f3b:	89 01                	mov    %eax,(%ecx)
  801f3d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801f40:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801f44:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801f48:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801f4c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f50:	77 de                	ja     801f30 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801f52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f56:	74 31                	je     801f89 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f61:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801f64:	eb 16                	jmp    801f7c <memcpy+0x66>
			*d8++ = *s8++;
  801f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f69:	8d 50 01             	lea    0x1(%eax),%edx
  801f6c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801f6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f72:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f75:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801f78:	8a 12                	mov    (%edx),%dl
  801f7a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f82:	89 55 10             	mov    %edx,0x10(%ebp)
  801f85:	85 c0                	test   %eax,%eax
  801f87:	75 dd                	jne    801f66 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fa6:	73 50                	jae    801ff8 <memmove+0x6a>
  801fa8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fab:	8b 45 10             	mov    0x10(%ebp),%eax
  801fae:	01 d0                	add    %edx,%eax
  801fb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fb3:	76 43                	jbe    801ff8 <memmove+0x6a>
		s += n;
  801fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbe:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fc1:	eb 10                	jmp    801fd3 <memmove+0x45>
			*--d = *--s;
  801fc3:	ff 4d f8             	decl   -0x8(%ebp)
  801fc6:	ff 4d fc             	decl   -0x4(%ebp)
  801fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcc:	8a 10                	mov    (%eax),%dl
  801fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fd1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801fd3:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd6:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fd9:	89 55 10             	mov    %edx,0x10(%ebp)
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	75 e3                	jne    801fc3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801fe0:	eb 23                	jmp    802005 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fe5:	8d 50 01             	lea    0x1(%eax),%edx
  801fe8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801feb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fee:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ff1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ff4:	8a 12                	mov    (%edx),%dl
  801ff6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ff8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffb:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ffe:	89 55 10             	mov    %edx,0x10(%ebp)
  802001:	85 c0                	test   %eax,%eax
  802003:	75 dd                	jne    801fe2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80201c:	eb 2a                	jmp    802048 <memcmp+0x3e>
		if (*s1 != *s2)
  80201e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802021:	8a 10                	mov    (%eax),%dl
  802023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802026:	8a 00                	mov    (%eax),%al
  802028:	38 c2                	cmp    %al,%dl
  80202a:	74 16                	je     802042 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80202c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202f:	8a 00                	mov    (%eax),%al
  802031:	0f b6 d0             	movzbl %al,%edx
  802034:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802037:	8a 00                	mov    (%eax),%al
  802039:	0f b6 c0             	movzbl %al,%eax
  80203c:	29 c2                	sub    %eax,%edx
  80203e:	89 d0                	mov    %edx,%eax
  802040:	eb 18                	jmp    80205a <memcmp+0x50>
		s1++, s2++;
  802042:	ff 45 fc             	incl   -0x4(%ebp)
  802045:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802048:	8b 45 10             	mov    0x10(%ebp),%eax
  80204b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80204e:	89 55 10             	mov    %edx,0x10(%ebp)
  802051:	85 c0                	test   %eax,%eax
  802053:	75 c9                	jne    80201e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802062:	8b 55 08             	mov    0x8(%ebp),%edx
  802065:	8b 45 10             	mov    0x10(%ebp),%eax
  802068:	01 d0                	add    %edx,%eax
  80206a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80206d:	eb 15                	jmp    802084 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	8a 00                	mov    (%eax),%al
  802074:	0f b6 d0             	movzbl %al,%edx
  802077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207a:	0f b6 c0             	movzbl %al,%eax
  80207d:	39 c2                	cmp    %eax,%edx
  80207f:	74 0d                	je     80208e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802081:	ff 45 08             	incl   0x8(%ebp)
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80208a:	72 e3                	jb     80206f <memfind+0x13>
  80208c:	eb 01                	jmp    80208f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80208e:	90                   	nop
	return (void *) s;
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80209a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020a8:	eb 03                	jmp    8020ad <strtol+0x19>
		s++;
  8020aa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8a 00                	mov    (%eax),%al
  8020b2:	3c 20                	cmp    $0x20,%al
  8020b4:	74 f4                	je     8020aa <strtol+0x16>
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8a 00                	mov    (%eax),%al
  8020bb:	3c 09                	cmp    $0x9,%al
  8020bd:	74 eb                	je     8020aa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	8a 00                	mov    (%eax),%al
  8020c4:	3c 2b                	cmp    $0x2b,%al
  8020c6:	75 05                	jne    8020cd <strtol+0x39>
		s++;
  8020c8:	ff 45 08             	incl   0x8(%ebp)
  8020cb:	eb 13                	jmp    8020e0 <strtol+0x4c>
	else if (*s == '-')
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8a 00                	mov    (%eax),%al
  8020d2:	3c 2d                	cmp    $0x2d,%al
  8020d4:	75 0a                	jne    8020e0 <strtol+0x4c>
		s++, neg = 1;
  8020d6:	ff 45 08             	incl   0x8(%ebp)
  8020d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e4:	74 06                	je     8020ec <strtol+0x58>
  8020e6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8020ea:	75 20                	jne    80210c <strtol+0x78>
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	8a 00                	mov    (%eax),%al
  8020f1:	3c 30                	cmp    $0x30,%al
  8020f3:	75 17                	jne    80210c <strtol+0x78>
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	40                   	inc    %eax
  8020f9:	8a 00                	mov    (%eax),%al
  8020fb:	3c 78                	cmp    $0x78,%al
  8020fd:	75 0d                	jne    80210c <strtol+0x78>
		s += 2, base = 16;
  8020ff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802103:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80210a:	eb 28                	jmp    802134 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80210c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802110:	75 15                	jne    802127 <strtol+0x93>
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	8a 00                	mov    (%eax),%al
  802117:	3c 30                	cmp    $0x30,%al
  802119:	75 0c                	jne    802127 <strtol+0x93>
		s++, base = 8;
  80211b:	ff 45 08             	incl   0x8(%ebp)
  80211e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802125:	eb 0d                	jmp    802134 <strtol+0xa0>
	else if (base == 0)
  802127:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80212b:	75 07                	jne    802134 <strtol+0xa0>
		base = 10;
  80212d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	8a 00                	mov    (%eax),%al
  802139:	3c 2f                	cmp    $0x2f,%al
  80213b:	7e 19                	jle    802156 <strtol+0xc2>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	3c 39                	cmp    $0x39,%al
  802144:	7f 10                	jg     802156 <strtol+0xc2>
			dig = *s - '0';
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	8a 00                	mov    (%eax),%al
  80214b:	0f be c0             	movsbl %al,%eax
  80214e:	83 e8 30             	sub    $0x30,%eax
  802151:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802154:	eb 42                	jmp    802198 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	8a 00                	mov    (%eax),%al
  80215b:	3c 60                	cmp    $0x60,%al
  80215d:	7e 19                	jle    802178 <strtol+0xe4>
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 7a                	cmp    $0x7a,%al
  802166:	7f 10                	jg     802178 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	0f be c0             	movsbl %al,%eax
  802170:	83 e8 57             	sub    $0x57,%eax
  802173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802176:	eb 20                	jmp    802198 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	8a 00                	mov    (%eax),%al
  80217d:	3c 40                	cmp    $0x40,%al
  80217f:	7e 39                	jle    8021ba <strtol+0x126>
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 5a                	cmp    $0x5a,%al
  802188:	7f 30                	jg     8021ba <strtol+0x126>
			dig = *s - 'A' + 10;
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	0f be c0             	movsbl %al,%eax
  802192:	83 e8 37             	sub    $0x37,%eax
  802195:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80219e:	7d 19                	jge    8021b9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021a0:	ff 45 08             	incl   0x8(%ebp)
  8021a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021a6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021aa:	89 c2                	mov    %eax,%edx
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	01 d0                	add    %edx,%eax
  8021b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021b4:	e9 7b ff ff ff       	jmp    802134 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021b9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021be:	74 08                	je     8021c8 <strtol+0x134>
		*endptr = (char *) s;
  8021c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021cc:	74 07                	je     8021d5 <strtol+0x141>
  8021ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d1:	f7 d8                	neg    %eax
  8021d3:	eb 03                	jmp    8021d8 <strtol+0x144>
  8021d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <ltostr>:

void
ltostr(long value, char *str)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8021e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8021e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8021ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f2:	79 13                	jns    802207 <ltostr+0x2d>
	{
		neg = 1;
  8021f4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8021fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802201:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802204:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80220f:	99                   	cltd   
  802210:	f7 f9                	idiv   %ecx
  802212:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802215:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802218:	8d 50 01             	lea    0x1(%eax),%edx
  80221b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80221e:	89 c2                	mov    %eax,%edx
  802220:	8b 45 0c             	mov    0xc(%ebp),%eax
  802223:	01 d0                	add    %edx,%eax
  802225:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802228:	83 c2 30             	add    $0x30,%edx
  80222b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80222d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802230:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802235:	f7 e9                	imul   %ecx
  802237:	c1 fa 02             	sar    $0x2,%edx
  80223a:	89 c8                	mov    %ecx,%eax
  80223c:	c1 f8 1f             	sar    $0x1f,%eax
  80223f:	29 c2                	sub    %eax,%edx
  802241:	89 d0                	mov    %edx,%eax
  802243:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802246:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224a:	75 bb                	jne    802207 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80224c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802253:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802256:	48                   	dec    %eax
  802257:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80225a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80225e:	74 3d                	je     80229d <ltostr+0xc3>
		start = 1 ;
  802260:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802267:	eb 34                	jmp    80229d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802269:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226f:	01 d0                	add    %edx,%eax
  802271:	8a 00                	mov    (%eax),%al
  802273:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227c:	01 c2                	add    %eax,%edx
  80227e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	01 c8                	add    %ecx,%eax
  802286:	8a 00                	mov    (%eax),%al
  802288:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80228a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80228d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802290:	01 c2                	add    %eax,%edx
  802292:	8a 45 eb             	mov    -0x15(%ebp),%al
  802295:	88 02                	mov    %al,(%edx)
		start++ ;
  802297:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80229a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022a3:	7c c4                	jl     802269 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022a5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ab:	01 d0                	add    %edx,%eax
  8022ad:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022b0:	90                   	nop
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8022b9:	ff 75 08             	pushl  0x8(%ebp)
  8022bc:	e8 c4 f9 ff ff       	call   801c85 <strlen>
  8022c1:	83 c4 04             	add    $0x4,%esp
  8022c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8022c7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ca:	e8 b6 f9 ff ff       	call   801c85 <strlen>
  8022cf:	83 c4 04             	add    $0x4,%esp
  8022d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8022d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8022dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022e3:	eb 17                	jmp    8022fc <strcconcat+0x49>
		final[s] = str1[s] ;
  8022e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022eb:	01 c2                	add    %eax,%edx
  8022ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	01 c8                	add    %ecx,%eax
  8022f5:	8a 00                	mov    (%eax),%al
  8022f7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8022f9:	ff 45 fc             	incl   -0x4(%ebp)
  8022fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802302:	7c e1                	jl     8022e5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802304:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80230b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802312:	eb 1f                	jmp    802333 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802317:	8d 50 01             	lea    0x1(%eax),%edx
  80231a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80231d:	89 c2                	mov    %eax,%edx
  80231f:	8b 45 10             	mov    0x10(%ebp),%eax
  802322:	01 c2                	add    %eax,%edx
  802324:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232a:	01 c8                	add    %ecx,%eax
  80232c:	8a 00                	mov    (%eax),%al
  80232e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802330:	ff 45 f8             	incl   -0x8(%ebp)
  802333:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802339:	7c d9                	jl     802314 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80233b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80233e:	8b 45 10             	mov    0x10(%ebp),%eax
  802341:	01 d0                	add    %edx,%eax
  802343:	c6 00 00             	movb   $0x0,(%eax)
}
  802346:	90                   	nop
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80234c:	8b 45 14             	mov    0x14(%ebp),%eax
  80234f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802355:	8b 45 14             	mov    0x14(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802361:	8b 45 10             	mov    0x10(%ebp),%eax
  802364:	01 d0                	add    %edx,%eax
  802366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80236c:	eb 0c                	jmp    80237a <strsplit+0x31>
			*string++ = 0;
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	8d 50 01             	lea    0x1(%eax),%edx
  802374:	89 55 08             	mov    %edx,0x8(%ebp)
  802377:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	8a 00                	mov    (%eax),%al
  80237f:	84 c0                	test   %al,%al
  802381:	74 18                	je     80239b <strsplit+0x52>
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	8a 00                	mov    (%eax),%al
  802388:	0f be c0             	movsbl %al,%eax
  80238b:	50                   	push   %eax
  80238c:	ff 75 0c             	pushl  0xc(%ebp)
  80238f:	e8 83 fa ff ff       	call   801e17 <strchr>
  802394:	83 c4 08             	add    $0x8,%esp
  802397:	85 c0                	test   %eax,%eax
  802399:	75 d3                	jne    80236e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	8a 00                	mov    (%eax),%al
  8023a0:	84 c0                	test   %al,%al
  8023a2:	74 5a                	je     8023fe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	83 f8 0f             	cmp    $0xf,%eax
  8023ac:	75 07                	jne    8023b5 <strsplit+0x6c>
		{
			return 0;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b3:	eb 66                	jmp    80241b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b8:	8b 00                	mov    (%eax),%eax
  8023ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8023bd:	8b 55 14             	mov    0x14(%ebp),%edx
  8023c0:	89 0a                	mov    %ecx,(%edx)
  8023c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cc:	01 c2                	add    %eax,%edx
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023d3:	eb 03                	jmp    8023d8 <strsplit+0x8f>
			string++;
  8023d5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	8a 00                	mov    (%eax),%al
  8023dd:	84 c0                	test   %al,%al
  8023df:	74 8b                	je     80236c <strsplit+0x23>
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	8a 00                	mov    (%eax),%al
  8023e6:	0f be c0             	movsbl %al,%eax
  8023e9:	50                   	push   %eax
  8023ea:	ff 75 0c             	pushl  0xc(%ebp)
  8023ed:	e8 25 fa ff ff       	call   801e17 <strchr>
  8023f2:	83 c4 08             	add    $0x8,%esp
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 dc                	je     8023d5 <strsplit+0x8c>
			string++;
	}
  8023f9:	e9 6e ff ff ff       	jmp    80236c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8023fe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80240b:	8b 45 10             	mov    0x10(%ebp),%eax
  80240e:	01 d0                	add    %edx,%eax
  802410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802416:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802429:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802430:	eb 4a                	jmp    80247c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	01 c2                	add    %eax,%edx
  80243a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80243d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802440:	01 c8                	add    %ecx,%eax
  802442:	8a 00                	mov    (%eax),%al
  802444:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244c:	01 d0                	add    %edx,%eax
  80244e:	8a 00                	mov    (%eax),%al
  802450:	3c 40                	cmp    $0x40,%al
  802452:	7e 25                	jle    802479 <str2lower+0x5c>
  802454:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245a:	01 d0                	add    %edx,%eax
  80245c:	8a 00                	mov    (%eax),%al
  80245e:	3c 5a                	cmp    $0x5a,%al
  802460:	7f 17                	jg     802479 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802462:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	01 d0                	add    %edx,%eax
  80246a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80246d:	8b 55 08             	mov    0x8(%ebp),%edx
  802470:	01 ca                	add    %ecx,%edx
  802472:	8a 12                	mov    (%edx),%dl
  802474:	83 c2 20             	add    $0x20,%edx
  802477:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802479:	ff 45 fc             	incl   -0x4(%ebp)
  80247c:	ff 75 0c             	pushl  0xc(%ebp)
  80247f:	e8 01 f8 ff ff       	call   801c85 <strlen>
  802484:	83 c4 04             	add    $0x4,%esp
  802487:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80248a:	7f a6                	jg     802432 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80248c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802497:	a1 08 50 80 00       	mov    0x805008,%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	74 42                	je     8024e2 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8024a0:	83 ec 08             	sub    $0x8,%esp
  8024a3:	68 00 00 00 82       	push   $0x82000000
  8024a8:	68 00 00 00 80       	push   $0x80000000
  8024ad:	e8 00 08 00 00       	call   802cb2 <initialize_dynamic_allocator>
  8024b2:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8024b5:	e8 e7 05 00 00       	call   802aa1 <sys_get_uheap_strategy>
  8024ba:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8024bf:	a1 20 52 80 00       	mov    0x805220,%eax
  8024c4:	05 00 10 00 00       	add    $0x1000,%eax
  8024c9:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8024ce:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  8024d3:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  8024d8:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8024df:	00 00 00 
	}
}
  8024e2:	90                   	nop
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024f9:	83 ec 08             	sub    $0x8,%esp
  8024fc:	68 06 04 00 00       	push   $0x406
  802501:	50                   	push   %eax
  802502:	e8 e4 01 00 00       	call   8026eb <__sys_allocate_page>
  802507:	83 c4 10             	add    $0x10,%esp
  80250a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80250d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802511:	79 14                	jns    802527 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802513:	83 ec 04             	sub    $0x4,%esp
  802516:	68 08 44 80 00       	push   $0x804408
  80251b:	6a 1f                	push   $0x1f
  80251d:	68 44 44 80 00       	push   $0x804444
  802522:	e8 b7 ed ff ff       	call   8012de <_panic>
	return 0;
  802527:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802542:	83 ec 0c             	sub    $0xc,%esp
  802545:	50                   	push   %eax
  802546:	e8 e7 01 00 00       	call   802732 <__sys_unmap_frame>
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802551:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802555:	79 14                	jns    80256b <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 50 44 80 00       	push   $0x804450
  80255f:	6a 2a                	push   $0x2a
  802561:	68 44 44 80 00       	push   $0x804444
  802566:	e8 73 ed ff ff       	call   8012de <_panic>
}
  80256b:	90                   	nop
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
  802571:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802574:	e8 18 ff ff ff       	call   802491 <uheap_init>
	if (size == 0) return NULL ;
  802579:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80257d:	75 07                	jne    802586 <malloc+0x18>
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	eb 14                	jmp    80259a <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802586:	83 ec 04             	sub    $0x4,%esp
  802589:	68 90 44 80 00       	push   $0x804490
  80258e:	6a 3e                	push   $0x3e
  802590:	68 44 44 80 00       	push   $0x804444
  802595:	e8 44 ed ff ff       	call   8012de <_panic>
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	68 b8 44 80 00       	push   $0x8044b8
  8025aa:	6a 49                	push   $0x49
  8025ac:	68 44 44 80 00       	push   $0x804444
  8025b1:	e8 28 ed ff ff       	call   8012de <_panic>

008025b6 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 18             	sub    $0x18,%esp
  8025bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8025bf:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025c2:	e8 ca fe ff ff       	call   802491 <uheap_init>
	if (size == 0) return NULL ;
  8025c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025cb:	75 07                	jne    8025d4 <smalloc+0x1e>
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d2:	eb 14                	jmp    8025e8 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8025d4:	83 ec 04             	sub    $0x4,%esp
  8025d7:	68 dc 44 80 00       	push   $0x8044dc
  8025dc:	6a 5a                	push   $0x5a
  8025de:	68 44 44 80 00       	push   $0x804444
  8025e3:	e8 f6 ec ff ff       	call   8012de <_panic>
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025f0:	e8 9c fe ff ff       	call   802491 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8025f5:	83 ec 04             	sub    $0x4,%esp
  8025f8:	68 04 45 80 00       	push   $0x804504
  8025fd:	6a 6a                	push   $0x6a
  8025ff:	68 44 44 80 00       	push   $0x804444
  802604:	e8 d5 ec ff ff       	call   8012de <_panic>

00802609 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80260f:	e8 7d fe ff ff       	call   802491 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 28 45 80 00       	push   $0x804528
  80261c:	68 88 00 00 00       	push   $0x88
  802621:	68 44 44 80 00       	push   $0x804444
  802626:	e8 b3 ec ff ff       	call   8012de <_panic>

0080262b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 50 45 80 00       	push   $0x804550
  802639:	68 9b 00 00 00       	push   $0x9b
  80263e:	68 44 44 80 00       	push   $0x804444
  802643:	e8 96 ec ff ff       	call   8012de <_panic>

00802648 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	57                   	push   %edi
  80264c:	56                   	push   %esi
  80264d:	53                   	push   %ebx
  80264e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	8b 55 0c             	mov    0xc(%ebp),%edx
  802657:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80265a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80265d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802660:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802663:	cd 30                	int    $0x30
  802665:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802668:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	5b                   	pop    %ebx
  80266f:	5e                   	pop    %esi
  802670:	5f                   	pop    %edi
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    

00802673 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 04             	sub    $0x4,%esp
  802679:	8b 45 10             	mov    0x10(%ebp),%eax
  80267c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80267f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802682:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	6a 00                	push   $0x0
  80268b:	51                   	push   %ecx
  80268c:	52                   	push   %edx
  80268d:	ff 75 0c             	pushl  0xc(%ebp)
  802690:	50                   	push   %eax
  802691:	6a 00                	push   $0x0
  802693:	e8 b0 ff ff ff       	call   802648 <syscall>
  802698:	83 c4 18             	add    $0x18,%esp
}
  80269b:	90                   	nop
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_cgetc>:

int
sys_cgetc(void)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 02                	push   $0x2
  8026ad:	e8 96 ff ff ff       	call   802648 <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 03                	push   $0x3
  8026c6:	e8 7d ff ff ff       	call   802648 <syscall>
  8026cb:	83 c4 18             	add    $0x18,%esp
}
  8026ce:	90                   	nop
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 04                	push   $0x4
  8026e0:	e8 63 ff ff ff       	call   802648 <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
}
  8026e8:	90                   	nop
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	52                   	push   %edx
  8026fb:	50                   	push   %eax
  8026fc:	6a 08                	push   $0x8
  8026fe:	e8 45 ff ff ff       	call   802648 <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	56                   	push   %esi
  80270c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80270d:	8b 75 18             	mov    0x18(%ebp),%esi
  802710:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802713:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802716:	8b 55 0c             	mov    0xc(%ebp),%edx
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	56                   	push   %esi
  80271d:	53                   	push   %ebx
  80271e:	51                   	push   %ecx
  80271f:	52                   	push   %edx
  802720:	50                   	push   %eax
  802721:	6a 09                	push   $0x9
  802723:	e8 20 ff ff ff       	call   802648 <syscall>
  802728:	83 c4 18             	add    $0x18,%esp
}
  80272b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5e                   	pop    %esi
  802730:	5d                   	pop    %ebp
  802731:	c3                   	ret    

00802732 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	ff 75 08             	pushl  0x8(%ebp)
  802740:	6a 0a                	push   $0xa
  802742:	e8 01 ff ff ff       	call   802648 <syscall>
  802747:	83 c4 18             	add    $0x18,%esp
}
  80274a:	c9                   	leave  
  80274b:	c3                   	ret    

0080274c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	ff 75 0c             	pushl  0xc(%ebp)
  802758:	ff 75 08             	pushl  0x8(%ebp)
  80275b:	6a 0b                	push   $0xb
  80275d:	e8 e6 fe ff ff       	call   802648 <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 0c                	push   $0xc
  802776:	e8 cd fe ff ff       	call   802648 <syscall>
  80277b:	83 c4 18             	add    $0x18,%esp
}
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 0d                	push   $0xd
  80278f:	e8 b4 fe ff ff       	call   802648 <syscall>
  802794:	83 c4 18             	add    $0x18,%esp
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 0e                	push   $0xe
  8027a8:	e8 9b fe ff ff       	call   802648 <syscall>
  8027ad:	83 c4 18             	add    $0x18,%esp
}
  8027b0:	c9                   	leave  
  8027b1:	c3                   	ret    

008027b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 0f                	push   $0xf
  8027c1:	e8 82 fe ff ff       	call   802648 <syscall>
  8027c6:	83 c4 18             	add    $0x18,%esp
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	ff 75 08             	pushl  0x8(%ebp)
  8027d9:	6a 10                	push   $0x10
  8027db:	e8 68 fe ff ff       	call   802648 <syscall>
  8027e0:	83 c4 18             	add    $0x18,%esp
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 11                	push   $0x11
  8027f4:	e8 4f fe ff ff       	call   802648 <syscall>
  8027f9:	83 c4 18             	add    $0x18,%esp
}
  8027fc:	90                   	nop
  8027fd:	c9                   	leave  
  8027fe:	c3                   	ret    

008027ff <sys_cputc>:

void
sys_cputc(const char c)
{
  8027ff:	55                   	push   %ebp
  802800:	89 e5                	mov    %esp,%ebp
  802802:	83 ec 04             	sub    $0x4,%esp
  802805:	8b 45 08             	mov    0x8(%ebp),%eax
  802808:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80280b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	50                   	push   %eax
  802818:	6a 01                	push   $0x1
  80281a:	e8 29 fe ff ff       	call   802648 <syscall>
  80281f:	83 c4 18             	add    $0x18,%esp
}
  802822:	90                   	nop
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	6a 14                	push   $0x14
  802834:	e8 0f fe ff ff       	call   802648 <syscall>
  802839:	83 c4 18             	add    $0x18,%esp
}
  80283c:	90                   	nop
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	8b 45 10             	mov    0x10(%ebp),%eax
  802848:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80284b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80284e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	6a 00                	push   $0x0
  802857:	51                   	push   %ecx
  802858:	52                   	push   %edx
  802859:	ff 75 0c             	pushl  0xc(%ebp)
  80285c:	50                   	push   %eax
  80285d:	6a 15                	push   $0x15
  80285f:	e8 e4 fd ff ff       	call   802648 <syscall>
  802864:	83 c4 18             	add    $0x18,%esp
}
  802867:	c9                   	leave  
  802868:	c3                   	ret    

00802869 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80286c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	52                   	push   %edx
  802879:	50                   	push   %eax
  80287a:	6a 16                	push   $0x16
  80287c:	e8 c7 fd ff ff       	call   802648 <syscall>
  802881:	83 c4 18             	add    $0x18,%esp
}
  802884:	c9                   	leave  
  802885:	c3                   	ret    

00802886 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802889:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80288c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	51                   	push   %ecx
  802897:	52                   	push   %edx
  802898:	50                   	push   %eax
  802899:	6a 17                	push   $0x17
  80289b:	e8 a8 fd ff ff       	call   802648 <syscall>
  8028a0:	83 c4 18             	add    $0x18,%esp
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	52                   	push   %edx
  8028b5:	50                   	push   %eax
  8028b6:	6a 18                	push   $0x18
  8028b8:	e8 8b fd ff ff       	call   802648 <syscall>
  8028bd:	83 c4 18             	add    $0x18,%esp
}
  8028c0:	c9                   	leave  
  8028c1:	c3                   	ret    

008028c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	6a 00                	push   $0x0
  8028ca:	ff 75 14             	pushl  0x14(%ebp)
  8028cd:	ff 75 10             	pushl  0x10(%ebp)
  8028d0:	ff 75 0c             	pushl  0xc(%ebp)
  8028d3:	50                   	push   %eax
  8028d4:	6a 19                	push   $0x19
  8028d6:	e8 6d fd ff ff       	call   802648 <syscall>
  8028db:	83 c4 18             	add    $0x18,%esp
}
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	50                   	push   %eax
  8028ef:	6a 1a                	push   $0x1a
  8028f1:	e8 52 fd ff ff       	call   802648 <syscall>
  8028f6:	83 c4 18             	add    $0x18,%esp
}
  8028f9:	90                   	nop
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	50                   	push   %eax
  80290b:	6a 1b                	push   $0x1b
  80290d:	e8 36 fd ff ff       	call   802648 <syscall>
  802912:	83 c4 18             	add    $0x18,%esp
}
  802915:	c9                   	leave  
  802916:	c3                   	ret    

00802917 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 05                	push   $0x5
  802926:	e8 1d fd ff ff       	call   802648 <syscall>
  80292b:	83 c4 18             	add    $0x18,%esp
}
  80292e:	c9                   	leave  
  80292f:	c3                   	ret    

00802930 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 06                	push   $0x6
  80293f:	e8 04 fd ff ff       	call   802648 <syscall>
  802944:	83 c4 18             	add    $0x18,%esp
}
  802947:	c9                   	leave  
  802948:	c3                   	ret    

00802949 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80294c:	6a 00                	push   $0x0
  80294e:	6a 00                	push   $0x0
  802950:	6a 00                	push   $0x0
  802952:	6a 00                	push   $0x0
  802954:	6a 00                	push   $0x0
  802956:	6a 07                	push   $0x7
  802958:	e8 eb fc ff ff       	call   802648 <syscall>
  80295d:	83 c4 18             	add    $0x18,%esp
}
  802960:	c9                   	leave  
  802961:	c3                   	ret    

00802962 <sys_exit_env>:


void sys_exit_env(void)
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 1c                	push   $0x1c
  802971:	e8 d2 fc ff ff       	call   802648 <syscall>
  802976:	83 c4 18             	add    $0x18,%esp
}
  802979:	90                   	nop
  80297a:	c9                   	leave  
  80297b:	c3                   	ret    

0080297c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80297c:	55                   	push   %ebp
  80297d:	89 e5                	mov    %esp,%ebp
  80297f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802982:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802985:	8d 50 04             	lea    0x4(%eax),%edx
  802988:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80298b:	6a 00                	push   $0x0
  80298d:	6a 00                	push   $0x0
  80298f:	6a 00                	push   $0x0
  802991:	52                   	push   %edx
  802992:	50                   	push   %eax
  802993:	6a 1d                	push   $0x1d
  802995:	e8 ae fc ff ff       	call   802648 <syscall>
  80299a:	83 c4 18             	add    $0x18,%esp
	return result;
  80299d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029a6:	89 01                	mov    %eax,(%ecx)
  8029a8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	c9                   	leave  
  8029af:	c2 04 00             	ret    $0x4

008029b2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	ff 75 10             	pushl  0x10(%ebp)
  8029bc:	ff 75 0c             	pushl  0xc(%ebp)
  8029bf:	ff 75 08             	pushl  0x8(%ebp)
  8029c2:	6a 13                	push   $0x13
  8029c4:	e8 7f fc ff ff       	call   802648 <syscall>
  8029c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8029cc:	90                   	nop
}
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <sys_rcr2>:
uint32 sys_rcr2()
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 1e                	push   $0x1e
  8029de:	e8 65 fc ff ff       	call   802648 <syscall>
  8029e3:	83 c4 18             	add    $0x18,%esp
}
  8029e6:	c9                   	leave  
  8029e7:	c3                   	ret    

008029e8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8029e8:	55                   	push   %ebp
  8029e9:	89 e5                	mov    %esp,%ebp
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029f4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	50                   	push   %eax
  802a01:	6a 1f                	push   $0x1f
  802a03:	e8 40 fc ff ff       	call   802648 <syscall>
  802a08:	83 c4 18             	add    $0x18,%esp
	return ;
  802a0b:	90                   	nop
}
  802a0c:	c9                   	leave  
  802a0d:	c3                   	ret    

00802a0e <rsttst>:
void rsttst()
{
  802a0e:	55                   	push   %ebp
  802a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 00                	push   $0x0
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 21                	push   $0x21
  802a1d:	e8 26 fc ff ff       	call   802648 <syscall>
  802a22:	83 c4 18             	add    $0x18,%esp
	return ;
  802a25:	90                   	nop
}
  802a26:	c9                   	leave  
  802a27:	c3                   	ret    

00802a28 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  802a31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a34:	8b 55 18             	mov    0x18(%ebp),%edx
  802a37:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a3b:	52                   	push   %edx
  802a3c:	50                   	push   %eax
  802a3d:	ff 75 10             	pushl  0x10(%ebp)
  802a40:	ff 75 0c             	pushl  0xc(%ebp)
  802a43:	ff 75 08             	pushl  0x8(%ebp)
  802a46:	6a 20                	push   $0x20
  802a48:	e8 fb fb ff ff       	call   802648 <syscall>
  802a4d:	83 c4 18             	add    $0x18,%esp
	return ;
  802a50:	90                   	nop
}
  802a51:	c9                   	leave  
  802a52:	c3                   	ret    

00802a53 <chktst>:
void chktst(uint32 n)
{
  802a53:	55                   	push   %ebp
  802a54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a56:	6a 00                	push   $0x0
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	6a 00                	push   $0x0
  802a5e:	ff 75 08             	pushl  0x8(%ebp)
  802a61:	6a 22                	push   $0x22
  802a63:	e8 e0 fb ff ff       	call   802648 <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
	return ;
  802a6b:	90                   	nop
}
  802a6c:	c9                   	leave  
  802a6d:	c3                   	ret    

00802a6e <inctst>:

void inctst()
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 23                	push   $0x23
  802a7d:	e8 c6 fb ff ff       	call   802648 <syscall>
  802a82:	83 c4 18             	add    $0x18,%esp
	return ;
  802a85:	90                   	nop
}
  802a86:	c9                   	leave  
  802a87:	c3                   	ret    

00802a88 <gettst>:
uint32 gettst()
{
  802a88:	55                   	push   %ebp
  802a89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 24                	push   $0x24
  802a97:	e8 ac fb ff ff       	call   802648 <syscall>
  802a9c:	83 c4 18             	add    $0x18,%esp
}
  802a9f:	c9                   	leave  
  802aa0:	c3                   	ret    

00802aa1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802aa1:	55                   	push   %ebp
  802aa2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 25                	push   $0x25
  802ab0:	e8 93 fb ff ff       	call   802648 <syscall>
  802ab5:	83 c4 18             	add    $0x18,%esp
  802ab8:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802abd:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802ac2:	c9                   	leave  
  802ac3:	c3                   	ret    

00802ac4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ac4:	55                   	push   %ebp
  802ac5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 00                	push   $0x0
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	ff 75 08             	pushl  0x8(%ebp)
  802ada:	6a 26                	push   $0x26
  802adc:	e8 67 fb ff ff       	call   802648 <syscall>
  802ae1:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae4:	90                   	nop
}
  802ae5:	c9                   	leave  
  802ae6:	c3                   	ret    

00802ae7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
  802aea:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802aeb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802aee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	6a 00                	push   $0x0
  802af9:	53                   	push   %ebx
  802afa:	51                   	push   %ecx
  802afb:	52                   	push   %edx
  802afc:	50                   	push   %eax
  802afd:	6a 27                	push   $0x27
  802aff:	e8 44 fb ff ff       	call   802648 <syscall>
  802b04:	83 c4 18             	add    $0x18,%esp
}
  802b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	6a 00                	push   $0x0
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	52                   	push   %edx
  802b1c:	50                   	push   %eax
  802b1d:	6a 28                	push   $0x28
  802b1f:	e8 24 fb ff ff       	call   802648 <syscall>
  802b24:	83 c4 18             	add    $0x18,%esp
}
  802b27:	c9                   	leave  
  802b28:	c3                   	ret    

00802b29 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b29:	55                   	push   %ebp
  802b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b2c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	6a 00                	push   $0x0
  802b37:	51                   	push   %ecx
  802b38:	ff 75 10             	pushl  0x10(%ebp)
  802b3b:	52                   	push   %edx
  802b3c:	50                   	push   %eax
  802b3d:	6a 29                	push   $0x29
  802b3f:	e8 04 fb ff ff       	call   802648 <syscall>
  802b44:	83 c4 18             	add    $0x18,%esp
}
  802b47:	c9                   	leave  
  802b48:	c3                   	ret    

00802b49 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b49:	55                   	push   %ebp
  802b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b4c:	6a 00                	push   $0x0
  802b4e:	6a 00                	push   $0x0
  802b50:	ff 75 10             	pushl  0x10(%ebp)
  802b53:	ff 75 0c             	pushl  0xc(%ebp)
  802b56:	ff 75 08             	pushl  0x8(%ebp)
  802b59:	6a 12                	push   $0x12
  802b5b:	e8 e8 fa ff ff       	call   802648 <syscall>
  802b60:	83 c4 18             	add    $0x18,%esp
	return ;
  802b63:	90                   	nop
}
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	52                   	push   %edx
  802b76:	50                   	push   %eax
  802b77:	6a 2a                	push   $0x2a
  802b79:	e8 ca fa ff ff       	call   802648 <syscall>
  802b7e:	83 c4 18             	add    $0x18,%esp
	return;
  802b81:	90                   	nop
}
  802b82:	c9                   	leave  
  802b83:	c3                   	ret    

00802b84 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 00                	push   $0x0
  802b91:	6a 2b                	push   $0x2b
  802b93:	e8 b0 fa ff ff       	call   802648 <syscall>
  802b98:	83 c4 18             	add    $0x18,%esp
}
  802b9b:	c9                   	leave  
  802b9c:	c3                   	ret    

00802b9d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	ff 75 0c             	pushl  0xc(%ebp)
  802ba9:	ff 75 08             	pushl  0x8(%ebp)
  802bac:	6a 2d                	push   $0x2d
  802bae:	e8 95 fa ff ff       	call   802648 <syscall>
  802bb3:	83 c4 18             	add    $0x18,%esp
	return;
  802bb6:	90                   	nop
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 00                	push   $0x0
  802bc0:	6a 00                	push   $0x0
  802bc2:	ff 75 0c             	pushl  0xc(%ebp)
  802bc5:	ff 75 08             	pushl  0x8(%ebp)
  802bc8:	6a 2c                	push   $0x2c
  802bca:	e8 79 fa ff ff       	call   802648 <syscall>
  802bcf:	83 c4 18             	add    $0x18,%esp
	return ;
  802bd2:	90                   	nop
}
  802bd3:	c9                   	leave  
  802bd4:	c3                   	ret    

00802bd5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802bd5:	55                   	push   %ebp
  802bd6:	89 e5                	mov    %esp,%ebp
  802bd8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 74 45 80 00       	push   $0x804574
  802be3:	68 25 01 00 00       	push   $0x125
  802be8:	68 a7 45 80 00       	push   $0x8045a7
  802bed:	e8 ec e6 ff ff       	call   8012de <_panic>

00802bf2 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802bf2:	55                   	push   %ebp
  802bf3:	89 e5                	mov    %esp,%ebp
  802bf5:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802bf8:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802bff:	72 09                	jb     802c0a <to_page_va+0x18>
  802c01:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802c08:	72 14                	jb     802c1e <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	68 b8 45 80 00       	push   $0x8045b8
  802c12:	6a 15                	push   $0x15
  802c14:	68 e3 45 80 00       	push   $0x8045e3
  802c19:	e8 c0 e6 ff ff       	call   8012de <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	ba 40 52 80 00       	mov    $0x805240,%edx
  802c26:	29 d0                	sub    %edx,%eax
  802c28:	c1 f8 02             	sar    $0x2,%eax
  802c2b:	89 c2                	mov    %eax,%edx
  802c2d:	89 d0                	mov    %edx,%eax
  802c2f:	c1 e0 02             	shl    $0x2,%eax
  802c32:	01 d0                	add    %edx,%eax
  802c34:	c1 e0 02             	shl    $0x2,%eax
  802c37:	01 d0                	add    %edx,%eax
  802c39:	c1 e0 02             	shl    $0x2,%eax
  802c3c:	01 d0                	add    %edx,%eax
  802c3e:	89 c1                	mov    %eax,%ecx
  802c40:	c1 e1 08             	shl    $0x8,%ecx
  802c43:	01 c8                	add    %ecx,%eax
  802c45:	89 c1                	mov    %eax,%ecx
  802c47:	c1 e1 10             	shl    $0x10,%ecx
  802c4a:	01 c8                	add    %ecx,%eax
  802c4c:	01 c0                	add    %eax,%eax
  802c4e:	01 d0                	add    %edx,%eax
  802c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	c1 e0 0c             	shl    $0xc,%eax
  802c59:	89 c2                	mov    %eax,%edx
  802c5b:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802c60:	01 d0                	add    %edx,%eax
}
  802c62:	c9                   	leave  
  802c63:	c3                   	ret    

00802c64 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
  802c67:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802c6a:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c72:	29 c2                	sub    %eax,%edx
  802c74:	89 d0                	mov    %edx,%eax
  802c76:	c1 e8 0c             	shr    $0xc,%eax
  802c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c80:	78 09                	js     802c8b <to_page_info+0x27>
  802c82:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802c89:	7e 14                	jle    802c9f <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802c8b:	83 ec 04             	sub    $0x4,%esp
  802c8e:	68 fc 45 80 00       	push   $0x8045fc
  802c93:	6a 22                	push   $0x22
  802c95:	68 e3 45 80 00       	push   $0x8045e3
  802c9a:	e8 3f e6 ff ff       	call   8012de <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca2:	89 d0                	mov    %edx,%eax
  802ca4:	01 c0                	add    %eax,%eax
  802ca6:	01 d0                	add    %edx,%eax
  802ca8:	c1 e0 02             	shl    $0x2,%eax
  802cab:	05 40 52 80 00       	add    $0x805240,%eax
}
  802cb0:	c9                   	leave  
  802cb1:	c3                   	ret    

00802cb2 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802cb2:	55                   	push   %ebp
  802cb3:	89 e5                	mov    %esp,%ebp
  802cb5:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	05 00 00 00 02       	add    $0x2000000,%eax
  802cc0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cc3:	73 16                	jae    802cdb <initialize_dynamic_allocator+0x29>
  802cc5:	68 20 46 80 00       	push   $0x804620
  802cca:	68 46 46 80 00       	push   $0x804646
  802ccf:	6a 34                	push   $0x34
  802cd1:	68 e3 45 80 00       	push   $0x8045e3
  802cd6:	e8 03 e6 ff ff       	call   8012de <_panic>
		is_initialized = 1;
  802cdb:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802ce2:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf0:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802cf5:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802cfc:	00 00 00 
  802cff:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802d06:	00 00 00 
  802d09:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  802d10:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d16:	2b 45 08             	sub    0x8(%ebp),%eax
  802d19:	c1 e8 0c             	shr    $0xc,%eax
  802d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802d1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d26:	e9 c8 00 00 00       	jmp    802df3 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802d2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2e:	89 d0                	mov    %edx,%eax
  802d30:	01 c0                	add    %eax,%eax
  802d32:	01 d0                	add    %edx,%eax
  802d34:	c1 e0 02             	shl    $0x2,%eax
  802d37:	05 48 52 80 00       	add    $0x805248,%eax
  802d3c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d44:	89 d0                	mov    %edx,%eax
  802d46:	01 c0                	add    %eax,%eax
  802d48:	01 d0                	add    %edx,%eax
  802d4a:	c1 e0 02             	shl    $0x2,%eax
  802d4d:	05 4a 52 80 00       	add    $0x80524a,%eax
  802d52:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802d57:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802d5d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d60:	89 c8                	mov    %ecx,%eax
  802d62:	01 c0                	add    %eax,%eax
  802d64:	01 c8                	add    %ecx,%eax
  802d66:	c1 e0 02             	shl    $0x2,%eax
  802d69:	05 44 52 80 00       	add    $0x805244,%eax
  802d6e:	89 10                	mov    %edx,(%eax)
  802d70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d73:	89 d0                	mov    %edx,%eax
  802d75:	01 c0                	add    %eax,%eax
  802d77:	01 d0                	add    %edx,%eax
  802d79:	c1 e0 02             	shl    $0x2,%eax
  802d7c:	05 44 52 80 00       	add    $0x805244,%eax
  802d81:	8b 00                	mov    (%eax),%eax
  802d83:	85 c0                	test   %eax,%eax
  802d85:	74 1b                	je     802da2 <initialize_dynamic_allocator+0xf0>
  802d87:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802d8d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d90:	89 c8                	mov    %ecx,%eax
  802d92:	01 c0                	add    %eax,%eax
  802d94:	01 c8                	add    %ecx,%eax
  802d96:	c1 e0 02             	shl    $0x2,%eax
  802d99:	05 40 52 80 00       	add    $0x805240,%eax
  802d9e:	89 02                	mov    %eax,(%edx)
  802da0:	eb 16                	jmp    802db8 <initialize_dynamic_allocator+0x106>
  802da2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da5:	89 d0                	mov    %edx,%eax
  802da7:	01 c0                	add    %eax,%eax
  802da9:	01 d0                	add    %edx,%eax
  802dab:	c1 e0 02             	shl    $0x2,%eax
  802dae:	05 40 52 80 00       	add    $0x805240,%eax
  802db3:	a3 28 52 80 00       	mov    %eax,0x805228
  802db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbb:	89 d0                	mov    %edx,%eax
  802dbd:	01 c0                	add    %eax,%eax
  802dbf:	01 d0                	add    %edx,%eax
  802dc1:	c1 e0 02             	shl    $0x2,%eax
  802dc4:	05 40 52 80 00       	add    $0x805240,%eax
  802dc9:	a3 2c 52 80 00       	mov    %eax,0x80522c
  802dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd1:	89 d0                	mov    %edx,%eax
  802dd3:	01 c0                	add    %eax,%eax
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	c1 e0 02             	shl    $0x2,%eax
  802dda:	05 40 52 80 00       	add    $0x805240,%eax
  802ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de5:	a1 34 52 80 00       	mov    0x805234,%eax
  802dea:	40                   	inc    %eax
  802deb:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802df0:	ff 45 f4             	incl   -0xc(%ebp)
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802df9:	0f 8c 2c ff ff ff    	jl     802d2b <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802dff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802e06:	eb 36                	jmp    802e3e <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0b:	c1 e0 04             	shl    $0x4,%eax
  802e0e:	05 60 d2 81 00       	add    $0x81d260,%eax
  802e13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1c:	c1 e0 04             	shl    $0x4,%eax
  802e1f:	05 64 d2 81 00       	add    $0x81d264,%eax
  802e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	c1 e0 04             	shl    $0x4,%eax
  802e30:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802e35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802e3b:	ff 45 f0             	incl   -0x10(%ebp)
  802e3e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802e42:	7e c4                	jle    802e08 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802e44:	90                   	nop
  802e45:	c9                   	leave  
  802e46:	c3                   	ret    

00802e47 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802e47:	55                   	push   %ebp
  802e48:	89 e5                	mov    %esp,%ebp
  802e4a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	83 ec 0c             	sub    $0xc,%esp
  802e53:	50                   	push   %eax
  802e54:	e8 0b fe ff ff       	call   802c64 <to_page_info>
  802e59:	83 c4 10             	add    $0x10,%esp
  802e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	8b 40 08             	mov    0x8(%eax),%eax
  802e65:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802e68:	c9                   	leave  
  802e69:	c3                   	ret    

00802e6a <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802e6a:	55                   	push   %ebp
  802e6b:	89 e5                	mov    %esp,%ebp
  802e6d:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802e70:	83 ec 0c             	sub    $0xc,%esp
  802e73:	ff 75 0c             	pushl  0xc(%ebp)
  802e76:	e8 77 fd ff ff       	call   802bf2 <to_page_va>
  802e7b:	83 c4 10             	add    $0x10,%esp
  802e7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802e81:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e86:	ba 00 00 00 00       	mov    $0x0,%edx
  802e8b:	f7 75 08             	divl   0x8(%ebp)
  802e8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e94:	83 ec 0c             	sub    $0xc,%esp
  802e97:	50                   	push   %eax
  802e98:	e8 48 f6 ff ff       	call   8024e5 <get_page>
  802e9d:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea6:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb0:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802eb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802ebb:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802ec2:	eb 19                	jmp    802edd <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec7:	ba 01 00 00 00       	mov    $0x1,%edx
  802ecc:	88 c1                	mov    %al,%cl
  802ece:	d3 e2                	shl    %cl,%edx
  802ed0:	89 d0                	mov    %edx,%eax
  802ed2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed5:	74 0e                	je     802ee5 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802ed7:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802eda:	ff 45 f0             	incl   -0x10(%ebp)
  802edd:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802ee1:	7e e1                	jle    802ec4 <split_page_to_blocks+0x5a>
  802ee3:	eb 01                	jmp    802ee6 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802ee5:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802ee6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802eed:	e9 a7 00 00 00       	jmp    802f99 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef5:	0f af 45 08          	imul   0x8(%ebp),%eax
  802ef9:	89 c2                	mov    %eax,%edx
  802efb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efe:	01 d0                	add    %edx,%eax
  802f00:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802f03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f07:	75 14                	jne    802f1d <split_page_to_blocks+0xb3>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 5c 46 80 00       	push   $0x80465c
  802f11:	6a 7c                	push   $0x7c
  802f13:	68 e3 45 80 00       	push   $0x8045e3
  802f18:	e8 c1 e3 ff ff       	call   8012de <_panic>
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	c1 e0 04             	shl    $0x4,%eax
  802f23:	05 64 d2 81 00       	add    $0x81d264,%eax
  802f28:	8b 10                	mov    (%eax),%edx
  802f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	85 c0                	test   %eax,%eax
  802f38:	74 14                	je     802f4e <split_page_to_blocks+0xe4>
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	c1 e0 04             	shl    $0x4,%eax
  802f40:	05 64 d2 81 00       	add    $0x81d264,%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f4a:	89 10                	mov    %edx,(%eax)
  802f4c:	eb 11                	jmp    802f5f <split_page_to_blocks+0xf5>
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	c1 e0 04             	shl    $0x4,%eax
  802f54:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  802f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5d:	89 02                	mov    %eax,(%edx)
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	c1 e0 04             	shl    $0x4,%eax
  802f65:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  802f6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6e:	89 02                	mov    %eax,(%edx)
  802f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	c1 e0 04             	shl    $0x4,%eax
  802f7f:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	8d 50 01             	lea    0x1(%eax),%edx
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	c1 e0 04             	shl    $0x4,%eax
  802f8f:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802f94:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802f96:	ff 45 ec             	incl   -0x14(%ebp)
  802f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802f9f:	0f 82 4d ff ff ff    	jb     802ef2 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802fa5:	90                   	nop
  802fa6:	c9                   	leave  
  802fa7:	c3                   	ret    

00802fa8 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802fa8:	55                   	push   %ebp
  802fa9:	89 e5                	mov    %esp,%ebp
  802fab:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802fae:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802fb5:	76 19                	jbe    802fd0 <alloc_block+0x28>
  802fb7:	68 80 46 80 00       	push   $0x804680
  802fbc:	68 46 46 80 00       	push   $0x804646
  802fc1:	68 8a 00 00 00       	push   $0x8a
  802fc6:	68 e3 45 80 00       	push   $0x8045e3
  802fcb:	e8 0e e3 ff ff       	call   8012de <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802fd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802fd7:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802fde:	eb 19                	jmp    802ff9 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe3:	ba 01 00 00 00       	mov    $0x1,%edx
  802fe8:	88 c1                	mov    %al,%cl
  802fea:	d3 e2                	shl    %cl,%edx
  802fec:	89 d0                	mov    %edx,%eax
  802fee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff1:	73 0e                	jae    803001 <alloc_block+0x59>
		idx++;
  802ff3:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802ff6:	ff 45 f0             	incl   -0x10(%ebp)
  802ff9:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802ffd:	7e e1                	jle    802fe0 <alloc_block+0x38>
  802fff:	eb 01                	jmp    803002 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  803001:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	c1 e0 04             	shl    $0x4,%eax
  803008:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	0f 84 df 00 00 00    	je     8030f6 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	c1 e0 04             	shl    $0x4,%eax
  80301d:	05 60 d2 81 00       	add    $0x81d260,%eax
  803022:	8b 00                	mov    (%eax),%eax
  803024:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  803027:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80302b:	75 17                	jne    803044 <alloc_block+0x9c>
  80302d:	83 ec 04             	sub    $0x4,%esp
  803030:	68 a1 46 80 00       	push   $0x8046a1
  803035:	68 9e 00 00 00       	push   $0x9e
  80303a:	68 e3 45 80 00       	push   $0x8045e3
  80303f:	e8 9a e2 ff ff       	call   8012de <_panic>
  803044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	74 10                	je     80305d <alloc_block+0xb5>
  80304d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803055:	8b 52 04             	mov    0x4(%edx),%edx
  803058:	89 50 04             	mov    %edx,0x4(%eax)
  80305b:	eb 14                	jmp    803071 <alloc_block+0xc9>
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	8b 40 04             	mov    0x4(%eax),%eax
  803063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803066:	c1 e2 04             	shl    $0x4,%edx
  803069:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80306f:	89 02                	mov    %eax,(%edx)
  803071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 0f                	je     80308a <alloc_block+0xe2>
  80307b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307e:	8b 40 04             	mov    0x4(%eax),%eax
  803081:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803084:	8b 12                	mov    (%edx),%edx
  803086:	89 10                	mov    %edx,(%eax)
  803088:	eb 13                	jmp    80309d <alloc_block+0xf5>
  80308a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803092:	c1 e2 04             	shl    $0x4,%edx
  803095:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80309b:	89 02                	mov    %eax,(%edx)
  80309d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	c1 e0 04             	shl    $0x4,%eax
  8030b6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	c1 e0 04             	shl    $0x4,%eax
  8030c6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030cb:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8030cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d0:	83 ec 0c             	sub    $0xc,%esp
  8030d3:	50                   	push   %eax
  8030d4:	e8 8b fb ff ff       	call   802c64 <to_page_info>
  8030d9:	83 c4 10             	add    $0x10,%esp
  8030dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8030df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8030e6:	48                   	dec    %eax
  8030e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ea:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8030ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f1:	e9 bc 02 00 00       	jmp    8033b2 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8030f6:	a1 34 52 80 00       	mov    0x805234,%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	0f 84 7d 02 00 00    	je     803380 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  803103:	a1 28 52 80 00       	mov    0x805228,%eax
  803108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80310b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80310f:	75 17                	jne    803128 <alloc_block+0x180>
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 a1 46 80 00       	push   $0x8046a1
  803119:	68 a9 00 00 00       	push   $0xa9
  80311e:	68 e3 45 80 00       	push   $0x8045e3
  803123:	e8 b6 e1 ff ff       	call   8012de <_panic>
  803128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	85 c0                	test   %eax,%eax
  80312f:	74 10                	je     803141 <alloc_block+0x199>
  803131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803139:	8b 52 04             	mov    0x4(%edx),%edx
  80313c:	89 50 04             	mov    %edx,0x4(%eax)
  80313f:	eb 0b                	jmp    80314c <alloc_block+0x1a4>
  803141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803144:	8b 40 04             	mov    0x4(%eax),%eax
  803147:	a3 2c 52 80 00       	mov    %eax,0x80522c
  80314c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	85 c0                	test   %eax,%eax
  803154:	74 0f                	je     803165 <alloc_block+0x1bd>
  803156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803159:	8b 40 04             	mov    0x4(%eax),%eax
  80315c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80315f:	8b 12                	mov    (%edx),%edx
  803161:	89 10                	mov    %edx,(%eax)
  803163:	eb 0a                	jmp    80316f <alloc_block+0x1c7>
  803165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	a3 28 52 80 00       	mov    %eax,0x805228
  80316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803172:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803182:	a1 34 52 80 00       	mov    0x805234,%eax
  803187:	48                   	dec    %eax
  803188:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	83 c0 03             	add    $0x3,%eax
  803193:	ba 01 00 00 00       	mov    $0x1,%edx
  803198:	88 c1                	mov    %al,%cl
  80319a:	d3 e2                	shl    %cl,%edx
  80319c:	89 d0                	mov    %edx,%eax
  80319e:	83 ec 08             	sub    $0x8,%esp
  8031a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031a4:	50                   	push   %eax
  8031a5:	e8 c0 fc ff ff       	call   802e6a <split_page_to_blocks>
  8031aa:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	c1 e0 04             	shl    $0x4,%eax
  8031b3:	05 60 d2 81 00       	add    $0x81d260,%eax
  8031b8:	8b 00                	mov    (%eax),%eax
  8031ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8031bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031c1:	75 17                	jne    8031da <alloc_block+0x232>
  8031c3:	83 ec 04             	sub    $0x4,%esp
  8031c6:	68 a1 46 80 00       	push   $0x8046a1
  8031cb:	68 b0 00 00 00       	push   $0xb0
  8031d0:	68 e3 45 80 00       	push   $0x8045e3
  8031d5:	e8 04 e1 ff ff       	call   8012de <_panic>
  8031da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	85 c0                	test   %eax,%eax
  8031e1:	74 10                	je     8031f3 <alloc_block+0x24b>
  8031e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031eb:	8b 52 04             	mov    0x4(%edx),%edx
  8031ee:	89 50 04             	mov    %edx,0x4(%eax)
  8031f1:	eb 14                	jmp    803207 <alloc_block+0x25f>
  8031f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f6:	8b 40 04             	mov    0x4(%eax),%eax
  8031f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031fc:	c1 e2 04             	shl    $0x4,%edx
  8031ff:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803205:	89 02                	mov    %eax,(%edx)
  803207:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320a:	8b 40 04             	mov    0x4(%eax),%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	74 0f                	je     803220 <alloc_block+0x278>
  803211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803214:	8b 40 04             	mov    0x4(%eax),%eax
  803217:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80321a:	8b 12                	mov    (%edx),%edx
  80321c:	89 10                	mov    %edx,(%eax)
  80321e:	eb 13                	jmp    803233 <alloc_block+0x28b>
  803220:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803228:	c1 e2 04             	shl    $0x4,%edx
  80322b:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803231:	89 02                	mov    %eax,(%edx)
  803233:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	c1 e0 04             	shl    $0x4,%eax
  80324c:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	8d 50 ff             	lea    -0x1(%eax),%edx
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	c1 e0 04             	shl    $0x4,%eax
  80325c:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803261:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803263:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803266:	83 ec 0c             	sub    $0xc,%esp
  803269:	50                   	push   %eax
  80326a:	e8 f5 f9 ff ff       	call   802c64 <to_page_info>
  80326f:	83 c4 10             	add    $0x10,%esp
  803272:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  803275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803278:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80327c:	48                   	dec    %eax
  80327d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803280:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803287:	e9 26 01 00 00       	jmp    8033b2 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80328c:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	c1 e0 04             	shl    $0x4,%eax
  803295:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	85 c0                	test   %eax,%eax
  80329e:	0f 84 dc 00 00 00    	je     803380 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	c1 e0 04             	shl    $0x4,%eax
  8032aa:	05 60 d2 81 00       	add    $0x81d260,%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8032b4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032b8:	75 17                	jne    8032d1 <alloc_block+0x329>
  8032ba:	83 ec 04             	sub    $0x4,%esp
  8032bd:	68 a1 46 80 00       	push   $0x8046a1
  8032c2:	68 be 00 00 00       	push   $0xbe
  8032c7:	68 e3 45 80 00       	push   $0x8045e3
  8032cc:	e8 0d e0 ff ff       	call   8012de <_panic>
  8032d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 10                	je     8032ea <alloc_block+0x342>
  8032da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032e2:	8b 52 04             	mov    0x4(%edx),%edx
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
  8032e8:	eb 14                	jmp    8032fe <alloc_block+0x356>
  8032ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ed:	8b 40 04             	mov    0x4(%eax),%eax
  8032f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f3:	c1 e2 04             	shl    $0x4,%edx
  8032f6:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8032fc:	89 02                	mov    %eax,(%edx)
  8032fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803301:	8b 40 04             	mov    0x4(%eax),%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	74 0f                	je     803317 <alloc_block+0x36f>
  803308:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803311:	8b 12                	mov    (%edx),%edx
  803313:	89 10                	mov    %edx,(%eax)
  803315:	eb 13                	jmp    80332a <alloc_block+0x382>
  803317:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80331f:	c1 e2 04             	shl    $0x4,%edx
  803322:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803328:	89 02                	mov    %eax,(%edx)
  80332a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80332d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803333:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803336:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	c1 e0 04             	shl    $0x4,%eax
  803343:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	c1 e0 04             	shl    $0x4,%eax
  803353:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803358:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80335a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80335d:	83 ec 0c             	sub    $0xc,%esp
  803360:	50                   	push   %eax
  803361:	e8 fe f8 ff ff       	call   802c64 <to_page_info>
  803366:	83 c4 10             	add    $0x10,%esp
  803369:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80336c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803373:	48                   	dec    %eax
  803374:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803377:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80337b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80337e:	eb 32                	jmp    8033b2 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803380:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803384:	77 15                	ja     80339b <alloc_block+0x3f3>
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	c1 e0 04             	shl    $0x4,%eax
  80338c:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	0f 84 f1 fe ff ff    	je     80328c <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80339b:	83 ec 04             	sub    $0x4,%esp
  80339e:	68 bf 46 80 00       	push   $0x8046bf
  8033a3:	68 c8 00 00 00       	push   $0xc8
  8033a8:	68 e3 45 80 00       	push   $0x8045e3
  8033ad:	e8 2c df ff ff       	call   8012de <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8033b2:	c9                   	leave  
  8033b3:	c3                   	ret    

008033b4 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8033b4:	55                   	push   %ebp
  8033b5:	89 e5                	mov    %esp,%ebp
  8033b7:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8033ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bd:	a1 48 d2 81 00       	mov    0x81d248,%eax
  8033c2:	39 c2                	cmp    %eax,%edx
  8033c4:	72 0c                	jb     8033d2 <free_block+0x1e>
  8033c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c9:	a1 20 52 80 00       	mov    0x805220,%eax
  8033ce:	39 c2                	cmp    %eax,%edx
  8033d0:	72 19                	jb     8033eb <free_block+0x37>
  8033d2:	68 d0 46 80 00       	push   $0x8046d0
  8033d7:	68 46 46 80 00       	push   $0x804646
  8033dc:	68 d7 00 00 00       	push   $0xd7
  8033e1:	68 e3 45 80 00       	push   $0x8045e3
  8033e6:	e8 f3 de ff ff       	call   8012de <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	83 ec 0c             	sub    $0xc,%esp
  8033f7:	50                   	push   %eax
  8033f8:	e8 67 f8 ff ff       	call   802c64 <to_page_info>
  8033fd:	83 c4 10             	add    $0x10,%esp
  803400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  803403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803406:	8b 40 08             	mov    0x8(%eax),%eax
  803409:	0f b7 c0             	movzwl %ax,%eax
  80340c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80340f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803416:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80341d:	eb 19                	jmp    803438 <free_block+0x84>
	    if ((1 << i) == blk_size)
  80341f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803422:	ba 01 00 00 00       	mov    $0x1,%edx
  803427:	88 c1                	mov    %al,%cl
  803429:	d3 e2                	shl    %cl,%edx
  80342b:	89 d0                	mov    %edx,%eax
  80342d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803430:	74 0e                	je     803440 <free_block+0x8c>
	        break;
	    idx++;
  803432:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803435:	ff 45 f0             	incl   -0x10(%ebp)
  803438:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80343c:	7e e1                	jle    80341f <free_block+0x6b>
  80343e:	eb 01                	jmp    803441 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  803440:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  803441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803444:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803448:	40                   	inc    %eax
  803449:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80344c:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803450:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803454:	75 17                	jne    80346d <free_block+0xb9>
  803456:	83 ec 04             	sub    $0x4,%esp
  803459:	68 5c 46 80 00       	push   $0x80465c
  80345e:	68 ee 00 00 00       	push   $0xee
  803463:	68 e3 45 80 00       	push   $0x8045e3
  803468:	e8 71 de ff ff       	call   8012de <_panic>
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	c1 e0 04             	shl    $0x4,%eax
  803473:	05 64 d2 81 00       	add    $0x81d264,%eax
  803478:	8b 10                	mov    (%eax),%edx
  80347a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347d:	89 50 04             	mov    %edx,0x4(%eax)
  803480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803483:	8b 40 04             	mov    0x4(%eax),%eax
  803486:	85 c0                	test   %eax,%eax
  803488:	74 14                	je     80349e <free_block+0xea>
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	c1 e0 04             	shl    $0x4,%eax
  803490:	05 64 d2 81 00       	add    $0x81d264,%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80349a:	89 10                	mov    %edx,(%eax)
  80349c:	eb 11                	jmp    8034af <free_block+0xfb>
  80349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a1:	c1 e0 04             	shl    $0x4,%eax
  8034a4:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ad:	89 02                	mov    %eax,(%edx)
  8034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b2:	c1 e0 04             	shl    $0x4,%eax
  8034b5:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8034bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034be:	89 02                	mov    %eax,(%edx)
  8034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	c1 e0 04             	shl    $0x4,%eax
  8034cf:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	8d 50 01             	lea    0x1(%eax),%edx
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	c1 e0 04             	shl    $0x4,%eax
  8034df:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034e4:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8034e6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8034eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8034f0:	f7 75 e0             	divl   -0x20(%ebp)
  8034f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8034f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8034fd:	0f b7 c0             	movzwl %ax,%eax
  803500:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803503:	0f 85 70 01 00 00    	jne    803679 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803509:	83 ec 0c             	sub    $0xc,%esp
  80350c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80350f:	e8 de f6 ff ff       	call   802bf2 <to_page_va>
  803514:	83 c4 10             	add    $0x10,%esp
  803517:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80351a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803521:	e9 b7 00 00 00       	jmp    8035dd <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  803526:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352c:	01 d0                	add    %edx,%eax
  80352e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  803531:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803535:	75 17                	jne    80354e <free_block+0x19a>
  803537:	83 ec 04             	sub    $0x4,%esp
  80353a:	68 a1 46 80 00       	push   $0x8046a1
  80353f:	68 f8 00 00 00       	push   $0xf8
  803544:	68 e3 45 80 00       	push   $0x8045e3
  803549:	e8 90 dd ff ff       	call   8012de <_panic>
  80354e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	74 10                	je     803567 <free_block+0x1b3>
  803557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80355f:	8b 52 04             	mov    0x4(%edx),%edx
  803562:	89 50 04             	mov    %edx,0x4(%eax)
  803565:	eb 14                	jmp    80357b <free_block+0x1c7>
  803567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356a:	8b 40 04             	mov    0x4(%eax),%eax
  80356d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803570:	c1 e2 04             	shl    $0x4,%edx
  803573:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803579:	89 02                	mov    %eax,(%edx)
  80357b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357e:	8b 40 04             	mov    0x4(%eax),%eax
  803581:	85 c0                	test   %eax,%eax
  803583:	74 0f                	je     803594 <free_block+0x1e0>
  803585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803588:	8b 40 04             	mov    0x4(%eax),%eax
  80358b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80358e:	8b 12                	mov    (%edx),%edx
  803590:	89 10                	mov    %edx,(%eax)
  803592:	eb 13                	jmp    8035a7 <free_block+0x1f3>
  803594:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80359c:	c1 e2 04             	shl    $0x4,%edx
  80359f:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8035a5:	89 02                	mov    %eax,(%edx)
  8035a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bd:	c1 e0 04             	shl    $0x4,%eax
  8035c0:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	c1 e0 04             	shl    $0x4,%eax
  8035d0:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035d5:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8035d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035da:	01 45 ec             	add    %eax,-0x14(%ebp)
  8035dd:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8035e4:	0f 86 3c ff ff ff    	jbe    803526 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ed:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8035f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f6:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8035fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803600:	75 17                	jne    803619 <free_block+0x265>
  803602:	83 ec 04             	sub    $0x4,%esp
  803605:	68 5c 46 80 00       	push   $0x80465c
  80360a:	68 fe 00 00 00       	push   $0xfe
  80360f:	68 e3 45 80 00       	push   $0x8045e3
  803614:	e8 c5 dc ff ff       	call   8012de <_panic>
  803619:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  80361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803622:	89 50 04             	mov    %edx,0x4(%eax)
  803625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803628:	8b 40 04             	mov    0x4(%eax),%eax
  80362b:	85 c0                	test   %eax,%eax
  80362d:	74 0c                	je     80363b <free_block+0x287>
  80362f:	a1 2c 52 80 00       	mov    0x80522c,%eax
  803634:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803637:	89 10                	mov    %edx,(%eax)
  803639:	eb 08                	jmp    803643 <free_block+0x28f>
  80363b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363e:	a3 28 52 80 00       	mov    %eax,0x805228
  803643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803646:	a3 2c 52 80 00       	mov    %eax,0x80522c
  80364b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803654:	a1 34 52 80 00       	mov    0x805234,%eax
  803659:	40                   	inc    %eax
  80365a:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80365f:	83 ec 0c             	sub    $0xc,%esp
  803662:	ff 75 e4             	pushl  -0x1c(%ebp)
  803665:	e8 88 f5 ff ff       	call   802bf2 <to_page_va>
  80366a:	83 c4 10             	add    $0x10,%esp
  80366d:	83 ec 0c             	sub    $0xc,%esp
  803670:	50                   	push   %eax
  803671:	e8 b8 ee ff ff       	call   80252e <return_page>
  803676:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803679:	90                   	nop
  80367a:	c9                   	leave  
  80367b:	c3                   	ret    

0080367c <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80367c:	55                   	push   %ebp
  80367d:	89 e5                	mov    %esp,%ebp
  80367f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803682:	83 ec 04             	sub    $0x4,%esp
  803685:	68 08 47 80 00       	push   $0x804708
  80368a:	68 11 01 00 00       	push   $0x111
  80368f:	68 e3 45 80 00       	push   $0x8045e3
  803694:	e8 45 dc ff ff       	call   8012de <_panic>
  803699:	66 90                	xchg   %ax,%ax
  80369b:	90                   	nop

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
