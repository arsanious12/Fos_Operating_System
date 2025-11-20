
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
  800031:	e8 ef 13 00 00       	call   801425 <libmain>
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
  800067:	e8 f2 29 00 00       	call   802a5e <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 35 2a 00 00       	call   802aa9 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 9e 27 00 00       	call   802865 <malloc>
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
  8000df:	e8 7a 29 00 00       	call   802a5e <sys_calculate_free_frames>
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
  800125:	68 c0 3c 80 00       	push   $0x803cc0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 9f 17 00 00       	call   8018d0 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 70 29 00 00       	call   802aa9 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 3c 3d 80 00       	push   $0x803d3c
  800150:	6a 0c                	push   $0xc
  800152:	e8 79 17 00 00       	call   8018d0 <cprintf_colored>
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
  800174:	e8 e5 28 00 00       	call   802a5e <sys_calculate_free_frames>
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
  8001b9:	e8 a0 28 00 00       	call   802a5e <sys_calculate_free_frames>
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
  8001f8:	68 b4 3d 80 00       	push   $0x803db4
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 cc 16 00 00       	call   8018d0 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 9d 28 00 00       	call   802aa9 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 40 3e 80 00       	push   $0x803e40
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 9f 16 00 00       	call   8018d0 <cprintf_colored>
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
  800270:	e8 ab 2b 00 00       	call   802e20 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 b8 3e 80 00       	push   $0x803eb8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 3a 16 00 00       	call   8018d0 <cprintf_colored>
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
  8002ae:	e8 ab 27 00 00       	call   802a5e <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 ee 27 00 00       	call   802aa9 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 c2 25 00 00       	call   802893 <free>
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
  8002fc:	e8 a8 27 00 00       	call   802aa9 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 f0 3e 80 00       	push   $0x803ef0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 b1 15 00 00       	call   8018d0 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 37 27 00 00       	call   802a5e <sys_calculate_free_frames>
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
  800342:	68 3c 3f 80 00       	push   $0x803f3c
  800347:	6a 0c                	push   $0xc
  800349:	e8 82 15 00 00       	call   8018d0 <cprintf_colored>
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
  8003a0:	e8 7b 2a 00 00       	call   802e20 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 98 3f 80 00       	push   $0x803f98
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 0a 15 00 00       	call   8018d0 <cprintf_colored>
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
  800416:	68 d0 3f 80 00       	push   $0x803fd0
  80041b:	6a 03                	push   $0x3
  80041d:	e8 ae 14 00 00       	call   8018d0 <cprintf_colored>
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
  8004df:	68 00 40 80 00       	push   $0x804000
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 e5 13 00 00       	call   8018d0 <cprintf_colored>
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
  8005b9:	68 00 40 80 00       	push   $0x804000
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 0b 13 00 00       	call   8018d0 <cprintf_colored>
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
  800693:	68 00 40 80 00       	push   $0x804000
  800698:	6a 0c                	push   $0xc
  80069a:	e8 31 12 00 00       	call   8018d0 <cprintf_colored>
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
  80076d:	68 00 40 80 00       	push   $0x804000
  800772:	6a 0c                	push   $0xc
  800774:	e8 57 11 00 00       	call   8018d0 <cprintf_colored>
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
  800847:	68 00 40 80 00       	push   $0x804000
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 7d 10 00 00       	call   8018d0 <cprintf_colored>
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
  800921:	68 00 40 80 00       	push   $0x804000
  800926:	6a 0c                	push   $0xc
  800928:	e8 a3 0f 00 00       	call   8018d0 <cprintf_colored>
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
  800a16:	68 00 40 80 00       	push   $0x804000
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 ae 0e 00 00       	call   8018d0 <cprintf_colored>
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
  800b14:	68 00 40 80 00       	push   $0x804000
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 b0 0d 00 00       	call   8018d0 <cprintf_colored>
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
  800c12:	68 00 40 80 00       	push   $0x804000
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 b2 0c 00 00       	call   8018d0 <cprintf_colored>
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
  800d10:	68 00 40 80 00       	push   $0x804000
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 b4 0b 00 00       	call   8018d0 <cprintf_colored>
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
  800dfd:	68 00 40 80 00       	push   $0x804000
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 c7 0a 00 00       	call   8018d0 <cprintf_colored>
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
  800eea:	68 00 40 80 00       	push   $0x804000
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 da 09 00 00       	call   8018d0 <cprintf_colored>
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
  800fd7:	68 00 40 80 00       	push   $0x804000
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 ed 08 00 00       	call   8018d0 <cprintf_colored>
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
  800ffa:	68 52 40 80 00       	push   $0x804052
  800fff:	6a 03                	push   $0x3
  801001:	e8 ca 08 00 00       	call   8018d0 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 3f 1a 00 00       	call   802a5e <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 7f 1a 00 00       	call   802aa9 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 0b 18 00 00       	call   802865 <malloc>
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
  801084:	68 70 40 80 00       	push   $0x804070
  801089:	6a 0c                	push   $0xc
  80108b:	e8 40 08 00 00       	call   8018d0 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 11 1a 00 00       	call   802aa9 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 ac 40 80 00       	push   $0x8040ac
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 14 08 00 00       	call   8018d0 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 9a 19 00 00       	call   802a5e <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 1c 41 80 00       	push   $0x80411c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 e8 07 00 00       	call   8018d0 <cprintf_colored>
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
  801102:	83 ec 28             	sub    $0x28,%esp

#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
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
  801122:	68 64 41 80 00       	push   $0x804164
  801127:	6a 15                	push   $0x15
  801129:	68 80 41 80 00       	push   $0x804180
  80112e:	e8 a2 04 00 00       	call   8015d5 <_panic>
	/*=================================================*/
#else
	panic("not handled!");
#endif
	//1. Alloc some spaces in PAGE allocator
	int correct = 1;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int eval;
	cprintf_colored(TEXT_cyan,"\n1. Alloc some spaces in PAGE allocator\n");
  80113a:	83 ec 08             	sub    $0x8,%esp
  80113d:	68 94 41 80 00       	push   $0x804194
  801142:	6a 03                	push   $0x3
  801144:	e8 87 07 00 00       	call   8018d0 <cprintf_colored>
  801149:	83 c4 10             	add    $0x10,%esp
	{
		eval = initial_page_allocations();
  80114c:	e8 7d f2 ff ff       	call   8003ce <initial_page_allocations>
  801151:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (eval != 100)
  801154:	83 7d f0 64          	cmpl   $0x64,-0x10(%ebp)
  801158:	74 17                	je     801171 <_main+0x72>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"initial allocations are not correct!\nplease make sure the the kmalloc test is correct before testing the kfree\n");
  80115a:	83 ec 08             	sub    $0x8,%esp
  80115d:	68 c0 41 80 00       	push   $0x8041c0
  801162:	6a 0c                	push   $0xc
  801164:	e8 67 07 00 00       	call   8018d0 <cprintf_colored>
  801169:	83 c4 10             	add    $0x10,%esp
			return ;
  80116c:	e9 b2 02 00 00       	jmp    801423 <_main+0x324>
		}
	}
	eval = 0;
  801171:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 pagealloc_end = ACTUAL_PAGE_ALLOC_START + totalRequestedSize ;
  801178:	a1 40 d2 81 00       	mov    0x81d240,%eax
  80117d:	2d 00 f0 ff 7d       	sub    $0x7dfff000,%eax
  801182:	89 45 ec             	mov    %eax,-0x14(%ebp)


	correct = 1;
  801185:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	//2. FREE Some
	cprintf_colored(TEXT_cyan,"%~\n2. Free some allocated spaces from PAGE ALLOCATOR [50%]\n");
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	68 30 42 80 00       	push   $0x804230
  801194:	6a 03                	push   $0x3
  801196:	e8 35 07 00 00       	call   8018d0 <cprintf_colored>
  80119b:	83 c4 10             	add    $0x10,%esp
	{
		//3 MB Hole
		correct = freeSpaceInPageAlloc(1, 1);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	6a 01                	push   $0x1
  8011a3:	6a 01                	push   $0x1
  8011a5:	e8 f7 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 10;
  8011b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011b4:	74 04                	je     8011ba <_main+0xbb>
  8011b6:	83 45 f0 0a          	addl   $0xa,-0x10(%ebp)
		correct = 1;
  8011ba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 4 MB Hole
		correct = freeSpaceInPageAlloc(3, 1);
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	6a 01                	push   $0x1
  8011c6:	6a 03                	push   $0x3
  8011c8:	e8 d4 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 10;
  8011d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011d7:	74 04                	je     8011dd <_main+0xde>
  8011d9:	83 45 f0 0a          	addl   $0xa,-0x10(%ebp)
		correct = 1;
  8011dd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 1 MB Hole
		correct = freeSpaceInPageAlloc(5, 1);
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	6a 01                	push   $0x1
  8011e9:	6a 05                	push   $0x5
  8011eb:	e8 b1 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  8011f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011fa:	74 04                	je     801200 <_main+0x101>
  8011fc:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801200:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 2 MB Hole
		correct = freeSpaceInPageAlloc(7, 1);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	6a 01                	push   $0x1
  80120c:	6a 07                	push   $0x7
  80120e:	e8 8e f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  801219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80121d:	74 04                	je     801223 <_main+0x124>
  80121f:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801223:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//1st 3 KB Hole
		correct = freeSpaceInPageAlloc(9, 1);
  80122a:	83 ec 08             	sub    $0x8,%esp
  80122d:	6a 01                	push   $0x1
  80122f:	6a 09                	push   $0x9
  801231:	e8 6b f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  80123c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801240:	74 04                	je     801246 <_main+0x147>
  801242:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801246:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 3 KB Hole
		correct = freeSpaceInPageAlloc(11, 1);
  80124d:	83 ec 08             	sub    $0x8,%esp
  801250:	6a 01                	push   $0x1
  801252:	6a 0b                	push   $0xb
  801254:	e8 48 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  80125f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801263:	74 04                	je     801269 <_main+0x16a>
  801265:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801269:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//5 KB Hole (should be merged with prev & next)
		correct = freeSpaceInPageAlloc(10, 1);
  801270:	83 ec 08             	sub    $0x8,%esp
  801273:	6a 01                	push   $0x1
  801275:	6a 0a                	push   $0xa
  801277:	e8 25 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  80127c:	83 c4 10             	add    $0x10,%esp
  80127f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  801282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801286:	74 04                	je     80128c <_main+0x18d>
  801288:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  80128c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//LAST 9 KB Hole (break should be moved down to the begin of alloc#9)
		correct = freeSpaceInPageAlloc(12, 1);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	6a 01                	push   $0x1
  801298:	6a 0c                	push   $0xc
  80129a:	e8 02 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  8012a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012a9:	74 04                	je     8012af <_main+0x1b0>
  8012ab:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  8012af:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}

	//3. Check the move-down of the BREAK
	correct = 1;
  8012b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n3. Check the move-down of the BREAK [20%]\n");
  8012bd:	83 ec 08             	sub    $0x8,%esp
  8012c0:	68 6c 42 80 00       	push   $0x80426c
  8012c5:	6a 03                	push   $0x3
  8012c7:	e8 04 06 00 00       	call   8018d0 <cprintf_colored>
  8012cc:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedBreak = ACTUAL_PAGE_ALLOC_START + totalRequestedSize - 28*kilo;
  8012cf:	a1 40 d2 81 00       	mov    0x81d240,%eax
  8012d4:	2d 00 60 00 7e       	sub    $0x7e006000,%eax
  8012d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(uheapPageAllocBreak != expectedBreak)
  8012dc:	a1 50 d2 81 00       	mov    0x81d250,%eax
  8012e1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012e4:	74 1f                	je     801305 <_main+0x206>
		{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedBreak, uheapPageAllocBreak);}
  8012e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8012ed:	a1 50 d2 81 00       	mov    0x81d250,%eax
  8012f2:	50                   	push   %eax
  8012f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8012f6:	68 9c 42 80 00       	push   $0x80429c
  8012fb:	6a 0c                	push   $0xc
  8012fd:	e8 ce 05 00 00       	call   8018d0 <cprintf_colored>
  801302:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval += 20;
  801305:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801309:	74 04                	je     80130f <_main+0x210>
  80130b:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)

	//4. Test accessing a freed area (processes should be killed by the validation of the fault handler)
	correct = 1;
  80130f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n4. Test accessing a freed area (processes should be killed by the validation of the fault handler) [30%]\n");
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	68 d4 42 80 00       	push   $0x8042d4
  80131e:	6a 03                	push   $0x3
  801320:	e8 ab 05 00 00       	call   8018d0 <cprintf_colored>
  801325:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  801328:	e8 d8 19 00 00       	call   802d05 <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80132d:	a1 00 52 80 00       	mov    0x805200,%eax
  801332:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  801338:	a1 00 52 80 00       	mov    0x805200,%eax
  80133d:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  801343:	89 c1                	mov    %eax,%ecx
  801345:	a1 00 52 80 00       	mov    0x805200,%eax
  80134a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801350:	52                   	push   %edx
  801351:	51                   	push   %ecx
  801352:	50                   	push   %eax
  801353:	68 41 43 80 00       	push   $0x804341
  801358:	e8 5c 18 00 00       	call   802bb9 <sys_create_env>
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		sys_run_env(ID1);
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	ff 75 e4             	pushl  -0x1c(%ebp)
  801369:	e8 69 18 00 00       	call   802bd7 <sys_run_env>
  80136e:	83 c4 10             	add    $0x10,%esp

		//wait until the 1st slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  801371:	90                   	nop
  801372:	e8 08 1a 00 00       	call   802d7f <gettst>
  801377:	83 f8 01             	cmp    $0x1,%eax
  80137a:	75 f6                	jne    801372 <_main+0x273>

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80137c:	a1 00 52 80 00       	mov    0x805200,%eax
  801381:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  801387:	a1 00 52 80 00       	mov    0x805200,%eax
  80138c:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  801392:	89 c1                	mov    %eax,%ecx
  801394:	a1 00 52 80 00       	mov    0x805200,%eax
  801399:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80139f:	52                   	push   %edx
  8013a0:	51                   	push   %ecx
  8013a1:	50                   	push   %eax
  8013a2:	68 4c 43 80 00       	push   $0x80434c
  8013a7:	e8 0d 18 00 00       	call   802bb9 <sys_create_env>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	89 45 e0             	mov    %eax,-0x20(%ebp)
		sys_run_env(ID2);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8013b8:	e8 1a 18 00 00       	call   802bd7 <sys_run_env>
  8013bd:	83 c4 10             	add    $0x10,%esp

		//wait until the 2nd slave finishes the allocation & freeing operations
		while (gettst() != 2) ;
  8013c0:	90                   	nop
  8013c1:	e8 b9 19 00 00       	call   802d7f <gettst>
  8013c6:	83 f8 02             	cmp    $0x2,%eax
  8013c9:	75 f6                	jne    8013c1 <_main+0x2c2>

		//signal them to start accessing the freed area
		inctst();
  8013cb:	e8 95 19 00 00       	call   802d65 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(15000);
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 98 3a 00 00       	push   $0x3a98
  8013d8:	e8 b3 25 00 00       	call   803990 <env_sleep>
  8013dd:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  8013e0:	e8 9a 19 00 00       	call   802d7f <gettst>
  8013e5:	83 f8 03             	cmp    $0x3,%eax
  8013e8:	76 19                	jbe    801403 <_main+0x304>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  8013ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013f1:	83 ec 08             	sub    $0x8,%esp
  8013f4:	68 58 43 80 00       	push   $0x804358
  8013f9:	6a 0c                	push   $0xc
  8013fb:	e8 d0 04 00 00       	call   8018d0 <cprintf_colored>
  801400:	83 c4 10             	add    $0x10,%esp
	}
	if (correct)
  801403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801407:	74 04                	je     80140d <_main+0x30e>
	{
		eval += 30;
  801409:	83 45 f0 1e          	addl   $0x1e,-0x10(%ebp)
	}
	cprintf_colored(TEXT_light_green, "%~\ntest free [1] [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  80140d:	83 ec 04             	sub    $0x4,%esp
  801410:	ff 75 f0             	pushl  -0x10(%ebp)
  801413:	68 e4 43 80 00       	push   $0x8043e4
  801418:	6a 0a                	push   $0xa
  80141a:	e8 b1 04 00 00       	call   8018d0 <cprintf_colored>
  80141f:	83 c4 10             	add    $0x10,%esp

	return;
  801422:	90                   	nop
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	57                   	push   %edi
  801429:	56                   	push   %esi
  80142a:	53                   	push   %ebx
  80142b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80142e:	e8 f4 17 00 00       	call   802c27 <sys_getenvindex>
  801433:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801436:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801439:	89 d0                	mov    %edx,%eax
  80143b:	c1 e0 02             	shl    $0x2,%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	c1 e0 03             	shl    $0x3,%eax
  801443:	01 d0                	add    %edx,%eax
  801445:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80144c:	01 d0                	add    %edx,%eax
  80144e:	c1 e0 02             	shl    $0x2,%eax
  801451:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801456:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80145b:	a1 00 52 80 00       	mov    0x805200,%eax
  801460:	8a 40 20             	mov    0x20(%eax),%al
  801463:	84 c0                	test   %al,%al
  801465:	74 0d                	je     801474 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801467:	a1 00 52 80 00       	mov    0x805200,%eax
  80146c:	83 c0 20             	add    $0x20,%eax
  80146f:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801474:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801478:	7e 0a                	jle    801484 <libmain+0x5f>
		binaryname = argv[0];
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	8b 00                	mov    (%eax),%eax
  80147f:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	ff 75 08             	pushl  0x8(%ebp)
  80148d:	e8 6d fc ff ff       	call   8010ff <_main>
  801492:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801495:	a1 00 50 80 00       	mov    0x805000,%eax
  80149a:	85 c0                	test   %eax,%eax
  80149c:	0f 84 01 01 00 00    	je     8015a3 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8014a2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014a8:	bb 18 45 80 00       	mov    $0x804518,%ebx
  8014ad:	ba 0e 00 00 00       	mov    $0xe,%edx
  8014b2:	89 c7                	mov    %eax,%edi
  8014b4:	89 de                	mov    %ebx,%esi
  8014b6:	89 d1                	mov    %edx,%ecx
  8014b8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8014ba:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8014bd:	b9 56 00 00 00       	mov    $0x56,%ecx
  8014c2:	b0 00                	mov    $0x0,%al
  8014c4:	89 d7                	mov    %edx,%edi
  8014c6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8014c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8014cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	50                   	push   %eax
  8014d6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014dc:	50                   	push   %eax
  8014dd:	e8 7b 19 00 00       	call   802e5d <sys_utilities>
  8014e2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8014e5:	e8 c4 14 00 00       	call   8029ae <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8014ea:	83 ec 0c             	sub    $0xc,%esp
  8014ed:	68 38 44 80 00       	push   $0x804438
  8014f2:	e8 ac 03 00 00       	call   8018a3 <cprintf>
  8014f7:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8014fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	74 18                	je     801519 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801501:	e8 75 19 00 00       	call   802e7b <sys_get_optimal_num_faults>
  801506:	83 ec 08             	sub    $0x8,%esp
  801509:	50                   	push   %eax
  80150a:	68 60 44 80 00       	push   $0x804460
  80150f:	e8 8f 03 00 00       	call   8018a3 <cprintf>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	eb 59                	jmp    801572 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801519:	a1 00 52 80 00       	mov    0x805200,%eax
  80151e:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  801524:	a1 00 52 80 00       	mov    0x805200,%eax
  801529:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	52                   	push   %edx
  801533:	50                   	push   %eax
  801534:	68 84 44 80 00       	push   $0x804484
  801539:	e8 65 03 00 00       	call   8018a3 <cprintf>
  80153e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801541:	a1 00 52 80 00       	mov    0x805200,%eax
  801546:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80154c:	a1 00 52 80 00       	mov    0x805200,%eax
  801551:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  801557:	a1 00 52 80 00       	mov    0x805200,%eax
  80155c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801562:	51                   	push   %ecx
  801563:	52                   	push   %edx
  801564:	50                   	push   %eax
  801565:	68 ac 44 80 00       	push   $0x8044ac
  80156a:	e8 34 03 00 00       	call   8018a3 <cprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801572:	a1 00 52 80 00       	mov    0x805200,%eax
  801577:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80157d:	83 ec 08             	sub    $0x8,%esp
  801580:	50                   	push   %eax
  801581:	68 04 45 80 00       	push   $0x804504
  801586:	e8 18 03 00 00       	call   8018a3 <cprintf>
  80158b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80158e:	83 ec 0c             	sub    $0xc,%esp
  801591:	68 38 44 80 00       	push   $0x804438
  801596:	e8 08 03 00 00       	call   8018a3 <cprintf>
  80159b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80159e:	e8 25 14 00 00       	call   8029c8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8015a3:	e8 1f 00 00 00       	call   8015c7 <exit>
}
  8015a8:	90                   	nop
  8015a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ac:	5b                   	pop    %ebx
  8015ad:	5e                   	pop    %esi
  8015ae:	5f                   	pop    %edi
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    

008015b1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8015b7:	83 ec 0c             	sub    $0xc,%esp
  8015ba:	6a 00                	push   $0x0
  8015bc:	e8 32 16 00 00       	call   802bf3 <sys_destroy_env>
  8015c1:	83 c4 10             	add    $0x10,%esp
}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <exit>:

void
exit(void)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015cd:	e8 87 16 00 00       	call   802c59 <sys_exit_env>
}
  8015d2:	90                   	nop
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015db:	8d 45 10             	lea    0x10(%ebp),%eax
  8015de:	83 c0 04             	add    $0x4,%eax
  8015e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015e4:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	74 16                	je     801603 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015ed:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	50                   	push   %eax
  8015f6:	68 7c 45 80 00       	push   $0x80457c
  8015fb:	e8 a3 02 00 00       	call   8018a3 <cprintf>
  801600:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801603:	a1 04 50 80 00       	mov    0x805004,%eax
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	ff 75 0c             	pushl  0xc(%ebp)
  80160e:	ff 75 08             	pushl  0x8(%ebp)
  801611:	50                   	push   %eax
  801612:	68 84 45 80 00       	push   $0x804584
  801617:	6a 74                	push   $0x74
  801619:	e8 b2 02 00 00       	call   8018d0 <cprintf_colored>
  80161e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	ff 75 f4             	pushl  -0xc(%ebp)
  80162a:	50                   	push   %eax
  80162b:	e8 04 02 00 00       	call   801834 <vcprintf>
  801630:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	6a 00                	push   $0x0
  801638:	68 ac 45 80 00       	push   $0x8045ac
  80163d:	e8 f2 01 00 00       	call   801834 <vcprintf>
  801642:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801645:	e8 7d ff ff ff       	call   8015c7 <exit>

	// should not return here
	while (1) ;
  80164a:	eb fe                	jmp    80164a <_panic+0x75>

0080164c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801652:	a1 00 52 80 00       	mov    0x805200,%eax
  801657:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801660:	39 c2                	cmp    %eax,%edx
  801662:	74 14                	je     801678 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	68 b0 45 80 00       	push   $0x8045b0
  80166c:	6a 26                	push   $0x26
  80166e:	68 fc 45 80 00       	push   $0x8045fc
  801673:	e8 5d ff ff ff       	call   8015d5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801678:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80167f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801686:	e9 c5 00 00 00       	jmp    801750 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80168b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	01 d0                	add    %edx,%eax
  80169a:	8b 00                	mov    (%eax),%eax
  80169c:	85 c0                	test   %eax,%eax
  80169e:	75 08                	jne    8016a8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8016a0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016a3:	e9 a5 00 00 00       	jmp    80174d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8016a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016b6:	eb 69                	jmp    801721 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8016b8:	a1 00 52 80 00       	mov    0x805200,%eax
  8016bd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8016c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016c6:	89 d0                	mov    %edx,%eax
  8016c8:	01 c0                	add    %eax,%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	c1 e0 03             	shl    $0x3,%eax
  8016cf:	01 c8                	add    %ecx,%eax
  8016d1:	8a 40 04             	mov    0x4(%eax),%al
  8016d4:	84 c0                	test   %al,%al
  8016d6:	75 46                	jne    80171e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016d8:	a1 00 52 80 00       	mov    0x805200,%eax
  8016dd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8016e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	01 c0                	add    %eax,%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	c1 e0 03             	shl    $0x3,%eax
  8016ef:	01 c8                	add    %ecx,%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016fe:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	01 c8                	add    %ecx,%eax
  80170f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801711:	39 c2                	cmp    %eax,%edx
  801713:	75 09                	jne    80171e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801715:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80171c:	eb 15                	jmp    801733 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80171e:	ff 45 e8             	incl   -0x18(%ebp)
  801721:	a1 00 52 80 00       	mov    0x805200,%eax
  801726:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80172c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172f:	39 c2                	cmp    %eax,%edx
  801731:	77 85                	ja     8016b8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801733:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801737:	75 14                	jne    80174d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	68 08 46 80 00       	push   $0x804608
  801741:	6a 3a                	push   $0x3a
  801743:	68 fc 45 80 00       	push   $0x8045fc
  801748:	e8 88 fe ff ff       	call   8015d5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80174d:	ff 45 f0             	incl   -0x10(%ebp)
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801756:	0f 8c 2f ff ff ff    	jl     80168b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80175c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801763:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80176a:	eb 26                	jmp    801792 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80176c:	a1 00 52 80 00       	mov    0x805200,%eax
  801771:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801777:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80177a:	89 d0                	mov    %edx,%eax
  80177c:	01 c0                	add    %eax,%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	c1 e0 03             	shl    $0x3,%eax
  801783:	01 c8                	add    %ecx,%eax
  801785:	8a 40 04             	mov    0x4(%eax),%al
  801788:	3c 01                	cmp    $0x1,%al
  80178a:	75 03                	jne    80178f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80178c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80178f:	ff 45 e0             	incl   -0x20(%ebp)
  801792:	a1 00 52 80 00       	mov    0x805200,%eax
  801797:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80179d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a0:	39 c2                	cmp    %eax,%edx
  8017a2:	77 c8                	ja     80176c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017aa:	74 14                	je     8017c0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 5c 46 80 00       	push   $0x80465c
  8017b4:	6a 44                	push   $0x44
  8017b6:	68 fc 45 80 00       	push   $0x8045fc
  8017bb:	e8 15 fe ff ff       	call   8015d5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017c0:	90                   	nop
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8017ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cd:	8b 00                	mov    (%eax),%eax
  8017cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8017d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d5:	89 0a                	mov    %ecx,(%edx)
  8017d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017da:	88 d1                	mov    %dl,%cl
  8017dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017df:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e6:	8b 00                	mov    (%eax),%eax
  8017e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017ed:	75 30                	jne    80181f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8017ef:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  8017f5:	a0 24 52 80 00       	mov    0x805224,%al
  8017fa:	0f b6 c0             	movzbl %al,%eax
  8017fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801800:	8b 09                	mov    (%ecx),%ecx
  801802:	89 cb                	mov    %ecx,%ebx
  801804:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801807:	83 c1 08             	add    $0x8,%ecx
  80180a:	52                   	push   %edx
  80180b:	50                   	push   %eax
  80180c:	53                   	push   %ebx
  80180d:	51                   	push   %ecx
  80180e:	e8 57 11 00 00       	call   80296a <sys_cputs>
  801813:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801816:	8b 45 0c             	mov    0xc(%ebp),%eax
  801819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80181f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801822:	8b 40 04             	mov    0x4(%eax),%eax
  801825:	8d 50 01             	lea    0x1(%eax),%edx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80182e:	90                   	nop
  80182f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80183d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801844:	00 00 00 
	b.cnt = 0;
  801847:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80184e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80185d:	50                   	push   %eax
  80185e:	68 c3 17 80 00       	push   $0x8017c3
  801863:	e8 5a 02 00 00       	call   801ac2 <vprintfmt>
  801868:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80186b:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801871:	a0 24 52 80 00       	mov    0x805224,%al
  801876:	0f b6 c0             	movzbl %al,%eax
  801879:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80187f:	52                   	push   %edx
  801880:	50                   	push   %eax
  801881:	51                   	push   %ecx
  801882:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801888:	83 c0 08             	add    $0x8,%eax
  80188b:	50                   	push   %eax
  80188c:	e8 d9 10 00 00       	call   80296a <sys_cputs>
  801891:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801894:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  80189b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018a9:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  8018b0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	e8 6f ff ff ff       	call   801834 <vcprintf>
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8018cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018d6:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	c1 e0 08             	shl    $0x8,%eax
  8018e3:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  8018e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018eb:	83 c0 04             	add    $0x4,%eax
  8018ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	83 ec 08             	sub    $0x8,%esp
  8018f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fa:	50                   	push   %eax
  8018fb:	e8 34 ff ff ff       	call   801834 <vcprintf>
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801906:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  80190d:	07 00 00 

	return cnt;
  801910:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80191b:	e8 8e 10 00 00       	call   8029ae <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801920:	8d 45 0c             	lea    0xc(%ebp),%eax
  801923:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	83 ec 08             	sub    $0x8,%esp
  80192c:	ff 75 f4             	pushl  -0xc(%ebp)
  80192f:	50                   	push   %eax
  801930:	e8 ff fe ff ff       	call   801834 <vcprintf>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80193b:	e8 88 10 00 00       	call   8029c8 <sys_unlock_cons>
	return cnt;
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	53                   	push   %ebx
  801949:	83 ec 14             	sub    $0x14,%esp
  80194c:	8b 45 10             	mov    0x10(%ebp),%eax
  80194f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801952:	8b 45 14             	mov    0x14(%ebp),%eax
  801955:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801958:	8b 45 18             	mov    0x18(%ebp),%eax
  80195b:	ba 00 00 00 00       	mov    $0x0,%edx
  801960:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801963:	77 55                	ja     8019ba <printnum+0x75>
  801965:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801968:	72 05                	jb     80196f <printnum+0x2a>
  80196a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80196d:	77 4b                	ja     8019ba <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80196f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801972:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801975:	8b 45 18             	mov    0x18(%ebp),%eax
  801978:	ba 00 00 00 00       	mov    $0x0,%edx
  80197d:	52                   	push   %edx
  80197e:	50                   	push   %eax
  80197f:	ff 75 f4             	pushl  -0xc(%ebp)
  801982:	ff 75 f0             	pushl  -0x10(%ebp)
  801985:	e8 c6 20 00 00       	call   803a50 <__udivdi3>
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	ff 75 20             	pushl  0x20(%ebp)
  801993:	53                   	push   %ebx
  801994:	ff 75 18             	pushl  0x18(%ebp)
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	ff 75 08             	pushl  0x8(%ebp)
  80199f:	e8 a1 ff ff ff       	call   801945 <printnum>
  8019a4:	83 c4 20             	add    $0x20,%esp
  8019a7:	eb 1a                	jmp    8019c3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019a9:	83 ec 08             	sub    $0x8,%esp
  8019ac:	ff 75 0c             	pushl  0xc(%ebp)
  8019af:	ff 75 20             	pushl  0x20(%ebp)
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	ff d0                	call   *%eax
  8019b7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019ba:	ff 4d 1c             	decl   0x1c(%ebp)
  8019bd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8019c1:	7f e6                	jg     8019a9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019c3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d1:	53                   	push   %ebx
  8019d2:	51                   	push   %ecx
  8019d3:	52                   	push   %edx
  8019d4:	50                   	push   %eax
  8019d5:	e8 86 21 00 00       	call   803b60 <__umoddi3>
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	05 d4 48 80 00       	add    $0x8048d4,%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	0f be c0             	movsbl %al,%eax
  8019e7:	83 ec 08             	sub    $0x8,%esp
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	50                   	push   %eax
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	ff d0                	call   *%eax
  8019f3:	83 c4 10             	add    $0x10,%esp
}
  8019f6:	90                   	nop
  8019f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019ff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a03:	7e 1c                	jle    801a21 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8b 00                	mov    (%eax),%eax
  801a0a:	8d 50 08             	lea    0x8(%eax),%edx
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	89 10                	mov    %edx,(%eax)
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	8b 00                	mov    (%eax),%eax
  801a17:	83 e8 08             	sub    $0x8,%eax
  801a1a:	8b 50 04             	mov    0x4(%eax),%edx
  801a1d:	8b 00                	mov    (%eax),%eax
  801a1f:	eb 40                	jmp    801a61 <getuint+0x65>
	else if (lflag)
  801a21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a25:	74 1e                	je     801a45 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	8b 00                	mov    (%eax),%eax
  801a2c:	8d 50 04             	lea    0x4(%eax),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	89 10                	mov    %edx,(%eax)
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	8b 00                	mov    (%eax),%eax
  801a39:	83 e8 04             	sub    $0x4,%eax
  801a3c:	8b 00                	mov    (%eax),%eax
  801a3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a43:	eb 1c                	jmp    801a61 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	8b 00                	mov    (%eax),%eax
  801a4a:	8d 50 04             	lea    0x4(%eax),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	89 10                	mov    %edx,(%eax)
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	8b 00                	mov    (%eax),%eax
  801a57:	83 e8 04             	sub    $0x4,%eax
  801a5a:	8b 00                	mov    (%eax),%eax
  801a5c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    

00801a63 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a66:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a6a:	7e 1c                	jle    801a88 <getint+0x25>
		return va_arg(*ap, long long);
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8b 00                	mov    (%eax),%eax
  801a71:	8d 50 08             	lea    0x8(%eax),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	89 10                	mov    %edx,(%eax)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	83 e8 08             	sub    $0x8,%eax
  801a81:	8b 50 04             	mov    0x4(%eax),%edx
  801a84:	8b 00                	mov    (%eax),%eax
  801a86:	eb 38                	jmp    801ac0 <getint+0x5d>
	else if (lflag)
  801a88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a8c:	74 1a                	je     801aa8 <getint+0x45>
		return va_arg(*ap, long);
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	8b 00                	mov    (%eax),%eax
  801a93:	8d 50 04             	lea    0x4(%eax),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	89 10                	mov    %edx,(%eax)
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	8b 00                	mov    (%eax),%eax
  801aa0:	83 e8 04             	sub    $0x4,%eax
  801aa3:	8b 00                	mov    (%eax),%eax
  801aa5:	99                   	cltd   
  801aa6:	eb 18                	jmp    801ac0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	8b 00                	mov    (%eax),%eax
  801aad:	8d 50 04             	lea    0x4(%eax),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	89 10                	mov    %edx,(%eax)
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	8b 00                	mov    (%eax),%eax
  801aba:	83 e8 04             	sub    $0x4,%eax
  801abd:	8b 00                	mov    (%eax),%eax
  801abf:	99                   	cltd   
}
  801ac0:	5d                   	pop    %ebp
  801ac1:	c3                   	ret    

00801ac2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	56                   	push   %esi
  801ac6:	53                   	push   %ebx
  801ac7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801aca:	eb 17                	jmp    801ae3 <vprintfmt+0x21>
			if (ch == '\0')
  801acc:	85 db                	test   %ebx,%ebx
  801ace:	0f 84 c1 03 00 00    	je     801e95 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801ad4:	83 ec 08             	sub    $0x8,%esp
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	53                   	push   %ebx
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	ff d0                	call   *%eax
  801ae0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ae3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae6:	8d 50 01             	lea    0x1(%eax),%edx
  801ae9:	89 55 10             	mov    %edx,0x10(%ebp)
  801aec:	8a 00                	mov    (%eax),%al
  801aee:	0f b6 d8             	movzbl %al,%ebx
  801af1:	83 fb 25             	cmp    $0x25,%ebx
  801af4:	75 d6                	jne    801acc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801af6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801afa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801b01:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801b08:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801b0f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b16:	8b 45 10             	mov    0x10(%ebp),%eax
  801b19:	8d 50 01             	lea    0x1(%eax),%edx
  801b1c:	89 55 10             	mov    %edx,0x10(%ebp)
  801b1f:	8a 00                	mov    (%eax),%al
  801b21:	0f b6 d8             	movzbl %al,%ebx
  801b24:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801b27:	83 f8 5b             	cmp    $0x5b,%eax
  801b2a:	0f 87 3d 03 00 00    	ja     801e6d <vprintfmt+0x3ab>
  801b30:	8b 04 85 f8 48 80 00 	mov    0x8048f8(,%eax,4),%eax
  801b37:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801b39:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b3d:	eb d7                	jmp    801b16 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b3f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b43:	eb d1                	jmp    801b16 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b45:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b4f:	89 d0                	mov    %edx,%eax
  801b51:	c1 e0 02             	shl    $0x2,%eax
  801b54:	01 d0                	add    %edx,%eax
  801b56:	01 c0                	add    %eax,%eax
  801b58:	01 d8                	add    %ebx,%eax
  801b5a:	83 e8 30             	sub    $0x30,%eax
  801b5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b60:	8b 45 10             	mov    0x10(%ebp),%eax
  801b63:	8a 00                	mov    (%eax),%al
  801b65:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b68:	83 fb 2f             	cmp    $0x2f,%ebx
  801b6b:	7e 3e                	jle    801bab <vprintfmt+0xe9>
  801b6d:	83 fb 39             	cmp    $0x39,%ebx
  801b70:	7f 39                	jg     801bab <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b72:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b75:	eb d5                	jmp    801b4c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b77:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7a:	83 c0 04             	add    $0x4,%eax
  801b7d:	89 45 14             	mov    %eax,0x14(%ebp)
  801b80:	8b 45 14             	mov    0x14(%ebp),%eax
  801b83:	83 e8 04             	sub    $0x4,%eax
  801b86:	8b 00                	mov    (%eax),%eax
  801b88:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b8b:	eb 1f                	jmp    801bac <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b91:	79 83                	jns    801b16 <vprintfmt+0x54>
				width = 0;
  801b93:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b9a:	e9 77 ff ff ff       	jmp    801b16 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b9f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801ba6:	e9 6b ff ff ff       	jmp    801b16 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801bab:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801bac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bb0:	0f 89 60 ff ff ff    	jns    801b16 <vprintfmt+0x54>
				width = precision, precision = -1;
  801bb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bbc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801bc3:	e9 4e ff ff ff       	jmp    801b16 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801bc8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801bcb:	e9 46 ff ff ff       	jmp    801b16 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801bd0:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd3:	83 c0 04             	add    $0x4,%eax
  801bd6:	89 45 14             	mov    %eax,0x14(%ebp)
  801bd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdc:	83 e8 04             	sub    $0x4,%eax
  801bdf:	8b 00                	mov    (%eax),%eax
  801be1:	83 ec 08             	sub    $0x8,%esp
  801be4:	ff 75 0c             	pushl  0xc(%ebp)
  801be7:	50                   	push   %eax
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	ff d0                	call   *%eax
  801bed:	83 c4 10             	add    $0x10,%esp
			break;
  801bf0:	e9 9b 02 00 00       	jmp    801e90 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf8:	83 c0 04             	add    $0x4,%eax
  801bfb:	89 45 14             	mov    %eax,0x14(%ebp)
  801bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801c01:	83 e8 04             	sub    $0x4,%eax
  801c04:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801c06:	85 db                	test   %ebx,%ebx
  801c08:	79 02                	jns    801c0c <vprintfmt+0x14a>
				err = -err;
  801c0a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801c0c:	83 fb 64             	cmp    $0x64,%ebx
  801c0f:	7f 0b                	jg     801c1c <vprintfmt+0x15a>
  801c11:	8b 34 9d 40 47 80 00 	mov    0x804740(,%ebx,4),%esi
  801c18:	85 f6                	test   %esi,%esi
  801c1a:	75 19                	jne    801c35 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801c1c:	53                   	push   %ebx
  801c1d:	68 e5 48 80 00       	push   $0x8048e5
  801c22:	ff 75 0c             	pushl  0xc(%ebp)
  801c25:	ff 75 08             	pushl  0x8(%ebp)
  801c28:	e8 70 02 00 00       	call   801e9d <printfmt>
  801c2d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801c30:	e9 5b 02 00 00       	jmp    801e90 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801c35:	56                   	push   %esi
  801c36:	68 ee 48 80 00       	push   $0x8048ee
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	e8 57 02 00 00       	call   801e9d <printfmt>
  801c46:	83 c4 10             	add    $0x10,%esp
			break;
  801c49:	e9 42 02 00 00       	jmp    801e90 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c51:	83 c0 04             	add    $0x4,%eax
  801c54:	89 45 14             	mov    %eax,0x14(%ebp)
  801c57:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5a:	83 e8 04             	sub    $0x4,%eax
  801c5d:	8b 30                	mov    (%eax),%esi
  801c5f:	85 f6                	test   %esi,%esi
  801c61:	75 05                	jne    801c68 <vprintfmt+0x1a6>
				p = "(null)";
  801c63:	be f1 48 80 00       	mov    $0x8048f1,%esi
			if (width > 0 && padc != '-')
  801c68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c6c:	7e 6d                	jle    801cdb <vprintfmt+0x219>
  801c6e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c72:	74 67                	je     801cdb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c77:	83 ec 08             	sub    $0x8,%esp
  801c7a:	50                   	push   %eax
  801c7b:	56                   	push   %esi
  801c7c:	e8 1e 03 00 00       	call   801f9f <strnlen>
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c87:	eb 16                	jmp    801c9f <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c89:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	50                   	push   %eax
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	ff d0                	call   *%eax
  801c99:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c9c:	ff 4d e4             	decl   -0x1c(%ebp)
  801c9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ca3:	7f e4                	jg     801c89 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ca5:	eb 34                	jmp    801cdb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801ca7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801cab:	74 1c                	je     801cc9 <vprintfmt+0x207>
  801cad:	83 fb 1f             	cmp    $0x1f,%ebx
  801cb0:	7e 05                	jle    801cb7 <vprintfmt+0x1f5>
  801cb2:	83 fb 7e             	cmp    $0x7e,%ebx
  801cb5:	7e 12                	jle    801cc9 <vprintfmt+0x207>
					putch('?', putdat);
  801cb7:	83 ec 08             	sub    $0x8,%esp
  801cba:	ff 75 0c             	pushl  0xc(%ebp)
  801cbd:	6a 3f                	push   $0x3f
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	ff d0                	call   *%eax
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	eb 0f                	jmp    801cd8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801cc9:	83 ec 08             	sub    $0x8,%esp
  801ccc:	ff 75 0c             	pushl  0xc(%ebp)
  801ccf:	53                   	push   %ebx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	ff d0                	call   *%eax
  801cd5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cd8:	ff 4d e4             	decl   -0x1c(%ebp)
  801cdb:	89 f0                	mov    %esi,%eax
  801cdd:	8d 70 01             	lea    0x1(%eax),%esi
  801ce0:	8a 00                	mov    (%eax),%al
  801ce2:	0f be d8             	movsbl %al,%ebx
  801ce5:	85 db                	test   %ebx,%ebx
  801ce7:	74 24                	je     801d0d <vprintfmt+0x24b>
  801ce9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ced:	78 b8                	js     801ca7 <vprintfmt+0x1e5>
  801cef:	ff 4d e0             	decl   -0x20(%ebp)
  801cf2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cf6:	79 af                	jns    801ca7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cf8:	eb 13                	jmp    801d0d <vprintfmt+0x24b>
				putch(' ', putdat);
  801cfa:	83 ec 08             	sub    $0x8,%esp
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	6a 20                	push   $0x20
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	ff d0                	call   *%eax
  801d07:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d0a:	ff 4d e4             	decl   -0x1c(%ebp)
  801d0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d11:	7f e7                	jg     801cfa <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801d13:	e9 78 01 00 00       	jmp    801e90 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d18:	83 ec 08             	sub    $0x8,%esp
  801d1b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d1e:	8d 45 14             	lea    0x14(%ebp),%eax
  801d21:	50                   	push   %eax
  801d22:	e8 3c fd ff ff       	call   801a63 <getint>
  801d27:	83 c4 10             	add    $0x10,%esp
  801d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d36:	85 d2                	test   %edx,%edx
  801d38:	79 23                	jns    801d5d <vprintfmt+0x29b>
				putch('-', putdat);
  801d3a:	83 ec 08             	sub    $0x8,%esp
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	6a 2d                	push   $0x2d
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	ff d0                	call   *%eax
  801d47:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d50:	f7 d8                	neg    %eax
  801d52:	83 d2 00             	adc    $0x0,%edx
  801d55:	f7 da                	neg    %edx
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d5d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d64:	e9 bc 00 00 00       	jmp    801e25 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d69:	83 ec 08             	sub    $0x8,%esp
  801d6c:	ff 75 e8             	pushl  -0x18(%ebp)
  801d6f:	8d 45 14             	lea    0x14(%ebp),%eax
  801d72:	50                   	push   %eax
  801d73:	e8 84 fc ff ff       	call   8019fc <getuint>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d7e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d81:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d88:	e9 98 00 00 00       	jmp    801e25 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d8d:	83 ec 08             	sub    $0x8,%esp
  801d90:	ff 75 0c             	pushl  0xc(%ebp)
  801d93:	6a 58                	push   $0x58
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	ff d0                	call   *%eax
  801d9a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d9d:	83 ec 08             	sub    $0x8,%esp
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	6a 58                	push   $0x58
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	ff d0                	call   *%eax
  801daa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801dad:	83 ec 08             	sub    $0x8,%esp
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	6a 58                	push   $0x58
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	ff d0                	call   *%eax
  801dba:	83 c4 10             	add    $0x10,%esp
			break;
  801dbd:	e9 ce 00 00 00       	jmp    801e90 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801dc2:	83 ec 08             	sub    $0x8,%esp
  801dc5:	ff 75 0c             	pushl  0xc(%ebp)
  801dc8:	6a 30                	push   $0x30
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	ff d0                	call   *%eax
  801dcf:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801dd2:	83 ec 08             	sub    $0x8,%esp
  801dd5:	ff 75 0c             	pushl  0xc(%ebp)
  801dd8:	6a 78                	push   $0x78
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	ff d0                	call   *%eax
  801ddf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801de2:	8b 45 14             	mov    0x14(%ebp),%eax
  801de5:	83 c0 04             	add    $0x4,%eax
  801de8:	89 45 14             	mov    %eax,0x14(%ebp)
  801deb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dee:	83 e8 04             	sub    $0x4,%eax
  801df1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801df6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801dfd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801e04:	eb 1f                	jmp    801e25 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e06:	83 ec 08             	sub    $0x8,%esp
  801e09:	ff 75 e8             	pushl  -0x18(%ebp)
  801e0c:	8d 45 14             	lea    0x14(%ebp),%eax
  801e0f:	50                   	push   %eax
  801e10:	e8 e7 fb ff ff       	call   8019fc <getuint>
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801e1e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e25:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2c:	83 ec 04             	sub    $0x4,%esp
  801e2f:	52                   	push   %edx
  801e30:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e33:	50                   	push   %eax
  801e34:	ff 75 f4             	pushl  -0xc(%ebp)
  801e37:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	ff 75 08             	pushl  0x8(%ebp)
  801e40:	e8 00 fb ff ff       	call   801945 <printnum>
  801e45:	83 c4 20             	add    $0x20,%esp
			break;
  801e48:	eb 46                	jmp    801e90 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e4a:	83 ec 08             	sub    $0x8,%esp
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	53                   	push   %ebx
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	ff d0                	call   *%eax
  801e56:	83 c4 10             	add    $0x10,%esp
			break;
  801e59:	eb 35                	jmp    801e90 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e5b:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801e62:	eb 2c                	jmp    801e90 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801e64:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801e6b:	eb 23                	jmp    801e90 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e6d:	83 ec 08             	sub    $0x8,%esp
  801e70:	ff 75 0c             	pushl  0xc(%ebp)
  801e73:	6a 25                	push   $0x25
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	ff d0                	call   *%eax
  801e7a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e7d:	ff 4d 10             	decl   0x10(%ebp)
  801e80:	eb 03                	jmp    801e85 <vprintfmt+0x3c3>
  801e82:	ff 4d 10             	decl   0x10(%ebp)
  801e85:	8b 45 10             	mov    0x10(%ebp),%eax
  801e88:	48                   	dec    %eax
  801e89:	8a 00                	mov    (%eax),%al
  801e8b:	3c 25                	cmp    $0x25,%al
  801e8d:	75 f3                	jne    801e82 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e8f:	90                   	nop
		}
	}
  801e90:	e9 35 fc ff ff       	jmp    801aca <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e95:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e99:	5b                   	pop    %ebx
  801e9a:	5e                   	pop    %esi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    

00801e9d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801ea3:	8d 45 10             	lea    0x10(%ebp),%eax
  801ea6:	83 c0 04             	add    $0x4,%eax
  801ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb2:	50                   	push   %eax
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	ff 75 08             	pushl  0x8(%ebp)
  801eb9:	e8 04 fc ff ff       	call   801ac2 <vprintfmt>
  801ebe:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ec1:	90                   	nop
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eca:	8b 40 08             	mov    0x8(%eax),%eax
  801ecd:	8d 50 01             	lea    0x1(%eax),%edx
  801ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed9:	8b 10                	mov    (%eax),%edx
  801edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ede:	8b 40 04             	mov    0x4(%eax),%eax
  801ee1:	39 c2                	cmp    %eax,%edx
  801ee3:	73 12                	jae    801ef7 <sprintputch+0x33>
		*b->buf++ = ch;
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	8b 00                	mov    (%eax),%eax
  801eea:	8d 48 01             	lea    0x1(%eax),%ecx
  801eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef0:	89 0a                	mov    %ecx,(%edx)
  801ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef5:	88 10                	mov    %dl,(%eax)
}
  801ef7:	90                   	nop
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    

00801efa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f09:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	01 d0                	add    %edx,%eax
  801f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f1f:	74 06                	je     801f27 <vsnprintf+0x2d>
  801f21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f25:	7f 07                	jg     801f2e <vsnprintf+0x34>
		return -E_INVAL;
  801f27:	b8 03 00 00 00       	mov    $0x3,%eax
  801f2c:	eb 20                	jmp    801f4e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f2e:	ff 75 14             	pushl  0x14(%ebp)
  801f31:	ff 75 10             	pushl  0x10(%ebp)
  801f34:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f37:	50                   	push   %eax
  801f38:	68 c4 1e 80 00       	push   $0x801ec4
  801f3d:	e8 80 fb ff ff       	call   801ac2 <vprintfmt>
  801f42:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f56:	8d 45 10             	lea    0x10(%ebp),%eax
  801f59:	83 c0 04             	add    $0x4,%eax
  801f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f62:	ff 75 f4             	pushl  -0xc(%ebp)
  801f65:	50                   	push   %eax
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	e8 89 ff ff ff       	call   801efa <vsnprintf>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f89:	eb 06                	jmp    801f91 <strlen+0x15>
		n++;
  801f8b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f8e:	ff 45 08             	incl   0x8(%ebp)
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	8a 00                	mov    (%eax),%al
  801f96:	84 c0                	test   %al,%al
  801f98:	75 f1                	jne    801f8b <strlen+0xf>
		n++;
	return n;
  801f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fac:	eb 09                	jmp    801fb7 <strnlen+0x18>
		n++;
  801fae:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fb1:	ff 45 08             	incl   0x8(%ebp)
  801fb4:	ff 4d 0c             	decl   0xc(%ebp)
  801fb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fbb:	74 09                	je     801fc6 <strnlen+0x27>
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	8a 00                	mov    (%eax),%al
  801fc2:	84 c0                	test   %al,%al
  801fc4:	75 e8                	jne    801fae <strnlen+0xf>
		n++;
	return n;
  801fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801fd7:	90                   	nop
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8d 50 01             	lea    0x1(%eax),%edx
  801fde:	89 55 08             	mov    %edx,0x8(%ebp)
  801fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fe7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fea:	8a 12                	mov    (%edx),%dl
  801fec:	88 10                	mov    %dl,(%eax)
  801fee:	8a 00                	mov    (%eax),%al
  801ff0:	84 c0                	test   %al,%al
  801ff2:	75 e4                	jne    801fd8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802005:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80200c:	eb 1f                	jmp    80202d <strncpy+0x34>
		*dst++ = *src;
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	8d 50 01             	lea    0x1(%eax),%edx
  802014:	89 55 08             	mov    %edx,0x8(%ebp)
  802017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201a:	8a 12                	mov    (%edx),%dl
  80201c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	8a 00                	mov    (%eax),%al
  802023:	84 c0                	test   %al,%al
  802025:	74 03                	je     80202a <strncpy+0x31>
			src++;
  802027:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80202a:	ff 45 fc             	incl   -0x4(%ebp)
  80202d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802030:	3b 45 10             	cmp    0x10(%ebp),%eax
  802033:	72 d9                	jb     80200e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802035:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80204a:	74 30                	je     80207c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80204c:	eb 16                	jmp    802064 <strlcpy+0x2a>
			*dst++ = *src++;
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	8d 50 01             	lea    0x1(%eax),%edx
  802054:	89 55 08             	mov    %edx,0x8(%ebp)
  802057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80205d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802060:	8a 12                	mov    (%edx),%dl
  802062:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802064:	ff 4d 10             	decl   0x10(%ebp)
  802067:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80206b:	74 09                	je     802076 <strlcpy+0x3c>
  80206d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802070:	8a 00                	mov    (%eax),%al
  802072:	84 c0                	test   %al,%al
  802074:	75 d8                	jne    80204e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80207c:	8b 55 08             	mov    0x8(%ebp),%edx
  80207f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802082:	29 c2                	sub    %eax,%edx
  802084:	89 d0                	mov    %edx,%eax
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80208b:	eb 06                	jmp    802093 <strcmp+0xb>
		p++, q++;
  80208d:	ff 45 08             	incl   0x8(%ebp)
  802090:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	8a 00                	mov    (%eax),%al
  802098:	84 c0                	test   %al,%al
  80209a:	74 0e                	je     8020aa <strcmp+0x22>
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	8a 10                	mov    (%eax),%dl
  8020a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a4:	8a 00                	mov    (%eax),%al
  8020a6:	38 c2                	cmp    %al,%dl
  8020a8:	74 e3                	je     80208d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	8a 00                	mov    (%eax),%al
  8020af:	0f b6 d0             	movzbl %al,%edx
  8020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b5:	8a 00                	mov    (%eax),%al
  8020b7:	0f b6 c0             	movzbl %al,%eax
  8020ba:	29 c2                	sub    %eax,%edx
  8020bc:	89 d0                	mov    %edx,%eax
}
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    

008020c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8020c3:	eb 09                	jmp    8020ce <strncmp+0xe>
		n--, p++, q++;
  8020c5:	ff 4d 10             	decl   0x10(%ebp)
  8020c8:	ff 45 08             	incl   0x8(%ebp)
  8020cb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8020ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020d2:	74 17                	je     8020eb <strncmp+0x2b>
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	8a 00                	mov    (%eax),%al
  8020d9:	84 c0                	test   %al,%al
  8020db:	74 0e                	je     8020eb <strncmp+0x2b>
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8a 10                	mov    (%eax),%dl
  8020e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e5:	8a 00                	mov    (%eax),%al
  8020e7:	38 c2                	cmp    %al,%dl
  8020e9:	74 da                	je     8020c5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8020eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020ef:	75 07                	jne    8020f8 <strncmp+0x38>
		return 0;
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f6:	eb 14                	jmp    80210c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8a 00                	mov    (%eax),%al
  8020fd:	0f b6 d0             	movzbl %al,%edx
  802100:	8b 45 0c             	mov    0xc(%ebp),%eax
  802103:	8a 00                	mov    (%eax),%al
  802105:	0f b6 c0             	movzbl %al,%eax
  802108:	29 c2                	sub    %eax,%edx
  80210a:	89 d0                	mov    %edx,%eax
}
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    

0080210e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	8b 45 0c             	mov    0xc(%ebp),%eax
  802117:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80211a:	eb 12                	jmp    80212e <strchr+0x20>
		if (*s == c)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	8a 00                	mov    (%eax),%al
  802121:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802124:	75 05                	jne    80212b <strchr+0x1d>
			return (char *) s;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	eb 11                	jmp    80213c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80212b:	ff 45 08             	incl   0x8(%ebp)
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	8a 00                	mov    (%eax),%al
  802133:	84 c0                	test   %al,%al
  802135:	75 e5                	jne    80211c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80214a:	eb 0d                	jmp    802159 <strfind+0x1b>
		if (*s == c)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	8a 00                	mov    (%eax),%al
  802151:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802154:	74 0e                	je     802164 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802156:	ff 45 08             	incl   0x8(%ebp)
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	8a 00                	mov    (%eax),%al
  80215e:	84 c0                	test   %al,%al
  802160:	75 ea                	jne    80214c <strfind+0xe>
  802162:	eb 01                	jmp    802165 <strfind+0x27>
		if (*s == c)
			break;
  802164:	90                   	nop
	return (char *) s;
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802176:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80217a:	76 63                	jbe    8021df <memset+0x75>
		uint64 data_block = c;
  80217c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217f:	99                   	cltd   
  802180:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802183:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802190:	c1 e0 08             	shl    $0x8,%eax
  802193:	09 45 f0             	or     %eax,-0x10(%ebp)
  802196:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8021a3:	c1 e0 10             	shl    $0x10,%eax
  8021a6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021a9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8021ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b2:	89 c2                	mov    %eax,%edx
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b9:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021bc:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8021bf:	eb 18                	jmp    8021d9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8021c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021c4:	8d 41 08             	lea    0x8(%ecx),%eax
  8021c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d0:	89 01                	mov    %eax,(%ecx)
  8021d2:	89 51 04             	mov    %edx,0x4(%ecx)
  8021d5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8021d9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021dd:	77 e2                	ja     8021c1 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8021df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021e3:	74 23                	je     802208 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8021e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021eb:	eb 0e                	jmp    8021fb <memset+0x91>
			*p8++ = (uint8)c;
  8021ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f0:	8d 50 01             	lea    0x1(%eax),%edx
  8021f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8021fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8021fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  802201:	89 55 10             	mov    %edx,0x10(%ebp)
  802204:	85 c0                	test   %eax,%eax
  802206:	75 e5                	jne    8021ed <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802213:	8b 45 0c             	mov    0xc(%ebp),%eax
  802216:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80221f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802223:	76 24                	jbe    802249 <memcpy+0x3c>
		while(n >= 8){
  802225:	eb 1c                	jmp    802243 <memcpy+0x36>
			*d64 = *s64;
  802227:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222a:	8b 50 04             	mov    0x4(%eax),%edx
  80222d:	8b 00                	mov    (%eax),%eax
  80222f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802232:	89 01                	mov    %eax,(%ecx)
  802234:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802237:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80223b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80223f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802243:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802247:	77 de                	ja     802227 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802249:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80224d:	74 31                	je     802280 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80224f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802252:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802255:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802258:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80225b:	eb 16                	jmp    802273 <memcpy+0x66>
			*d8++ = *s8++;
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	8d 50 01             	lea    0x1(%eax),%edx
  802263:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802269:	8d 4a 01             	lea    0x1(%edx),%ecx
  80226c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80226f:	8a 12                	mov    (%edx),%dl
  802271:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802273:	8b 45 10             	mov    0x10(%ebp),%eax
  802276:	8d 50 ff             	lea    -0x1(%eax),%edx
  802279:	89 55 10             	mov    %edx,0x10(%ebp)
  80227c:	85 c0                	test   %eax,%eax
  80227e:	75 dd                	jne    80225d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80228b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802297:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80229a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80229d:	73 50                	jae    8022ef <memmove+0x6a>
  80229f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022aa:	76 43                	jbe    8022ef <memmove+0x6a>
		s += n;
  8022ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8022af:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8022b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8022b8:	eb 10                	jmp    8022ca <memmove+0x45>
			*--d = *--s;
  8022ba:	ff 4d f8             	decl   -0x8(%ebp)
  8022bd:	ff 4d fc             	decl   -0x4(%ebp)
  8022c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c3:	8a 10                	mov    (%eax),%dl
  8022c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8022ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	75 e3                	jne    8022ba <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8022d7:	eb 23                	jmp    8022fc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8022d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022dc:	8d 50 01             	lea    0x1(%eax),%edx
  8022df:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022e8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8022eb:	8a 12                	mov    (%edx),%dl
  8022ed:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8022ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	75 dd                	jne    8022d9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80230d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802310:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802313:	eb 2a                	jmp    80233f <memcmp+0x3e>
		if (*s1 != *s2)
  802315:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802318:	8a 10                	mov    (%eax),%dl
  80231a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80231d:	8a 00                	mov    (%eax),%al
  80231f:	38 c2                	cmp    %al,%dl
  802321:	74 16                	je     802339 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802323:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802326:	8a 00                	mov    (%eax),%al
  802328:	0f b6 d0             	movzbl %al,%edx
  80232b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80232e:	8a 00                	mov    (%eax),%al
  802330:	0f b6 c0             	movzbl %al,%eax
  802333:	29 c2                	sub    %eax,%edx
  802335:	89 d0                	mov    %edx,%eax
  802337:	eb 18                	jmp    802351 <memcmp+0x50>
		s1++, s2++;
  802339:	ff 45 fc             	incl   -0x4(%ebp)
  80233c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80233f:	8b 45 10             	mov    0x10(%ebp),%eax
  802342:	8d 50 ff             	lea    -0x1(%eax),%edx
  802345:	89 55 10             	mov    %edx,0x10(%ebp)
  802348:	85 c0                	test   %eax,%eax
  80234a:	75 c9                	jne    802315 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80234c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
  802356:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802359:	8b 55 08             	mov    0x8(%ebp),%edx
  80235c:	8b 45 10             	mov    0x10(%ebp),%eax
  80235f:	01 d0                	add    %edx,%eax
  802361:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802364:	eb 15                	jmp    80237b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	8a 00                	mov    (%eax),%al
  80236b:	0f b6 d0             	movzbl %al,%edx
  80236e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802371:	0f b6 c0             	movzbl %al,%eax
  802374:	39 c2                	cmp    %eax,%edx
  802376:	74 0d                	je     802385 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802378:	ff 45 08             	incl   0x8(%ebp)
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802381:	72 e3                	jb     802366 <memfind+0x13>
  802383:	eb 01                	jmp    802386 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802385:	90                   	nop
	return (void *) s;
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802398:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80239f:	eb 03                	jmp    8023a4 <strtol+0x19>
		s++;
  8023a1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8a 00                	mov    (%eax),%al
  8023a9:	3c 20                	cmp    $0x20,%al
  8023ab:	74 f4                	je     8023a1 <strtol+0x16>
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	8a 00                	mov    (%eax),%al
  8023b2:	3c 09                	cmp    $0x9,%al
  8023b4:	74 eb                	je     8023a1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	8a 00                	mov    (%eax),%al
  8023bb:	3c 2b                	cmp    $0x2b,%al
  8023bd:	75 05                	jne    8023c4 <strtol+0x39>
		s++;
  8023bf:	ff 45 08             	incl   0x8(%ebp)
  8023c2:	eb 13                	jmp    8023d7 <strtol+0x4c>
	else if (*s == '-')
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	3c 2d                	cmp    $0x2d,%al
  8023cb:	75 0a                	jne    8023d7 <strtol+0x4c>
		s++, neg = 1;
  8023cd:	ff 45 08             	incl   0x8(%ebp)
  8023d0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023db:	74 06                	je     8023e3 <strtol+0x58>
  8023dd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8023e1:	75 20                	jne    802403 <strtol+0x78>
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8a 00                	mov    (%eax),%al
  8023e8:	3c 30                	cmp    $0x30,%al
  8023ea:	75 17                	jne    802403 <strtol+0x78>
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	40                   	inc    %eax
  8023f0:	8a 00                	mov    (%eax),%al
  8023f2:	3c 78                	cmp    $0x78,%al
  8023f4:	75 0d                	jne    802403 <strtol+0x78>
		s += 2, base = 16;
  8023f6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8023fa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802401:	eb 28                	jmp    80242b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802403:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802407:	75 15                	jne    80241e <strtol+0x93>
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	8a 00                	mov    (%eax),%al
  80240e:	3c 30                	cmp    $0x30,%al
  802410:	75 0c                	jne    80241e <strtol+0x93>
		s++, base = 8;
  802412:	ff 45 08             	incl   0x8(%ebp)
  802415:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80241c:	eb 0d                	jmp    80242b <strtol+0xa0>
	else if (base == 0)
  80241e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802422:	75 07                	jne    80242b <strtol+0xa0>
		base = 10;
  802424:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	3c 2f                	cmp    $0x2f,%al
  802432:	7e 19                	jle    80244d <strtol+0xc2>
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	8a 00                	mov    (%eax),%al
  802439:	3c 39                	cmp    $0x39,%al
  80243b:	7f 10                	jg     80244d <strtol+0xc2>
			dig = *s - '0';
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8a 00                	mov    (%eax),%al
  802442:	0f be c0             	movsbl %al,%eax
  802445:	83 e8 30             	sub    $0x30,%eax
  802448:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244b:	eb 42                	jmp    80248f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	8a 00                	mov    (%eax),%al
  802452:	3c 60                	cmp    $0x60,%al
  802454:	7e 19                	jle    80246f <strtol+0xe4>
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	8a 00                	mov    (%eax),%al
  80245b:	3c 7a                	cmp    $0x7a,%al
  80245d:	7f 10                	jg     80246f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	8a 00                	mov    (%eax),%al
  802464:	0f be c0             	movsbl %al,%eax
  802467:	83 e8 57             	sub    $0x57,%eax
  80246a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246d:	eb 20                	jmp    80248f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	8a 00                	mov    (%eax),%al
  802474:	3c 40                	cmp    $0x40,%al
  802476:	7e 39                	jle    8024b1 <strtol+0x126>
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	8a 00                	mov    (%eax),%al
  80247d:	3c 5a                	cmp    $0x5a,%al
  80247f:	7f 30                	jg     8024b1 <strtol+0x126>
			dig = *s - 'A' + 10;
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	8a 00                	mov    (%eax),%al
  802486:	0f be c0             	movsbl %al,%eax
  802489:	83 e8 37             	sub    $0x37,%eax
  80248c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	3b 45 10             	cmp    0x10(%ebp),%eax
  802495:	7d 19                	jge    8024b0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802497:	ff 45 08             	incl   0x8(%ebp)
  80249a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80249d:	0f af 45 10          	imul   0x10(%ebp),%eax
  8024a1:	89 c2                	mov    %eax,%edx
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	01 d0                	add    %edx,%eax
  8024a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8024ab:	e9 7b ff ff ff       	jmp    80242b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8024b0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8024b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024b5:	74 08                	je     8024bf <strtol+0x134>
		*endptr = (char *) s;
  8024b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8024bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024c3:	74 07                	je     8024cc <strtol+0x141>
  8024c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024c8:	f7 d8                	neg    %eax
  8024ca:	eb 03                	jmp    8024cf <strtol+0x144>
  8024cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <ltostr>:

void
ltostr(long value, char *str)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8024d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8024de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8024e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e9:	79 13                	jns    8024fe <ltostr+0x2d>
	{
		neg = 1;
  8024eb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8024f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8024f8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8024fb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802506:	99                   	cltd   
  802507:	f7 f9                	idiv   %ecx
  802509:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80250c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80250f:	8d 50 01             	lea    0x1(%eax),%edx
  802512:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802515:	89 c2                	mov    %eax,%edx
  802517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251a:	01 d0                	add    %edx,%eax
  80251c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251f:	83 c2 30             	add    $0x30,%edx
  802522:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802527:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80252c:	f7 e9                	imul   %ecx
  80252e:	c1 fa 02             	sar    $0x2,%edx
  802531:	89 c8                	mov    %ecx,%eax
  802533:	c1 f8 1f             	sar    $0x1f,%eax
  802536:	29 c2                	sub    %eax,%edx
  802538:	89 d0                	mov    %edx,%eax
  80253a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80253d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802541:	75 bb                	jne    8024fe <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802543:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80254a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80254d:	48                   	dec    %eax
  80254e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802551:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802555:	74 3d                	je     802594 <ltostr+0xc3>
		start = 1 ;
  802557:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80255e:	eb 34                	jmp    802594 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802563:	8b 45 0c             	mov    0xc(%ebp),%eax
  802566:	01 d0                	add    %edx,%eax
  802568:	8a 00                	mov    (%eax),%al
  80256a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80256d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802570:	8b 45 0c             	mov    0xc(%ebp),%eax
  802573:	01 c2                	add    %eax,%edx
  802575:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257b:	01 c8                	add    %ecx,%eax
  80257d:	8a 00                	mov    (%eax),%al
  80257f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802581:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802584:	8b 45 0c             	mov    0xc(%ebp),%eax
  802587:	01 c2                	add    %eax,%edx
  802589:	8a 45 eb             	mov    -0x15(%ebp),%al
  80258c:	88 02                	mov    %al,(%edx)
		start++ ;
  80258e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802591:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80259a:	7c c4                	jl     802560 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80259c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80259f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8025a7:	90                   	nop
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8025b0:	ff 75 08             	pushl  0x8(%ebp)
  8025b3:	e8 c4 f9 ff ff       	call   801f7c <strlen>
  8025b8:	83 c4 04             	add    $0x4,%esp
  8025bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8025be:	ff 75 0c             	pushl  0xc(%ebp)
  8025c1:	e8 b6 f9 ff ff       	call   801f7c <strlen>
  8025c6:	83 c4 04             	add    $0x4,%esp
  8025c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8025cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8025d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025da:	eb 17                	jmp    8025f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8025dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025df:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e2:	01 c2                	add    %eax,%edx
  8025e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	01 c8                	add    %ecx,%eax
  8025ec:	8a 00                	mov    (%eax),%al
  8025ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8025f0:	ff 45 fc             	incl   -0x4(%ebp)
  8025f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025f9:	7c e1                	jl     8025dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8025fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802602:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802609:	eb 1f                	jmp    80262a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80260b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260e:	8d 50 01             	lea    0x1(%eax),%edx
  802611:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802614:	89 c2                	mov    %eax,%edx
  802616:	8b 45 10             	mov    0x10(%ebp),%eax
  802619:	01 c2                	add    %eax,%edx
  80261b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80261e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802621:	01 c8                	add    %ecx,%eax
  802623:	8a 00                	mov    (%eax),%al
  802625:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802627:	ff 45 f8             	incl   -0x8(%ebp)
  80262a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80262d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802630:	7c d9                	jl     80260b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802632:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802635:	8b 45 10             	mov    0x10(%ebp),%eax
  802638:	01 d0                	add    %edx,%eax
  80263a:	c6 00 00             	movb   $0x0,(%eax)
}
  80263d:	90                   	nop
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802643:	8b 45 14             	mov    0x14(%ebp),%eax
  802646:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80264c:	8b 45 14             	mov    0x14(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802658:	8b 45 10             	mov    0x10(%ebp),%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802663:	eb 0c                	jmp    802671 <strsplit+0x31>
			*string++ = 0;
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	8d 50 01             	lea    0x1(%eax),%edx
  80266b:	89 55 08             	mov    %edx,0x8(%ebp)
  80266e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	8a 00                	mov    (%eax),%al
  802676:	84 c0                	test   %al,%al
  802678:	74 18                	je     802692 <strsplit+0x52>
  80267a:	8b 45 08             	mov    0x8(%ebp),%eax
  80267d:	8a 00                	mov    (%eax),%al
  80267f:	0f be c0             	movsbl %al,%eax
  802682:	50                   	push   %eax
  802683:	ff 75 0c             	pushl  0xc(%ebp)
  802686:	e8 83 fa ff ff       	call   80210e <strchr>
  80268b:	83 c4 08             	add    $0x8,%esp
  80268e:	85 c0                	test   %eax,%eax
  802690:	75 d3                	jne    802665 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	8a 00                	mov    (%eax),%al
  802697:	84 c0                	test   %al,%al
  802699:	74 5a                	je     8026f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80269b:	8b 45 14             	mov    0x14(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	83 f8 0f             	cmp    $0xf,%eax
  8026a3:	75 07                	jne    8026ac <strsplit+0x6c>
		{
			return 0;
  8026a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026aa:	eb 66                	jmp    802712 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8026ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8026b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8026b7:	89 0a                	mov    %ecx,(%edx)
  8026b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c3:	01 c2                	add    %eax,%edx
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026ca:	eb 03                	jmp    8026cf <strsplit+0x8f>
			string++;
  8026cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	8a 00                	mov    (%eax),%al
  8026d4:	84 c0                	test   %al,%al
  8026d6:	74 8b                	je     802663 <strsplit+0x23>
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	8a 00                	mov    (%eax),%al
  8026dd:	0f be c0             	movsbl %al,%eax
  8026e0:	50                   	push   %eax
  8026e1:	ff 75 0c             	pushl  0xc(%ebp)
  8026e4:	e8 25 fa ff ff       	call   80210e <strchr>
  8026e9:	83 c4 08             	add    $0x8,%esp
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	74 dc                	je     8026cc <strsplit+0x8c>
			string++;
	}
  8026f0:	e9 6e ff ff ff       	jmp    802663 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8026f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8026f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802702:	8b 45 10             	mov    0x10(%ebp),%eax
  802705:	01 d0                	add    %edx,%eax
  802707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80270d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802720:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802727:	eb 4a                	jmp    802773 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802729:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	01 c2                	add    %eax,%edx
  802731:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802734:	8b 45 0c             	mov    0xc(%ebp),%eax
  802737:	01 c8                	add    %ecx,%eax
  802739:	8a 00                	mov    (%eax),%al
  80273b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80273d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802740:	8b 45 0c             	mov    0xc(%ebp),%eax
  802743:	01 d0                	add    %edx,%eax
  802745:	8a 00                	mov    (%eax),%al
  802747:	3c 40                	cmp    $0x40,%al
  802749:	7e 25                	jle    802770 <str2lower+0x5c>
  80274b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80274e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802751:	01 d0                	add    %edx,%eax
  802753:	8a 00                	mov    (%eax),%al
  802755:	3c 5a                	cmp    $0x5a,%al
  802757:	7f 17                	jg     802770 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802759:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	01 d0                	add    %edx,%eax
  802761:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802764:	8b 55 08             	mov    0x8(%ebp),%edx
  802767:	01 ca                	add    %ecx,%edx
  802769:	8a 12                	mov    (%edx),%dl
  80276b:	83 c2 20             	add    $0x20,%edx
  80276e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802770:	ff 45 fc             	incl   -0x4(%ebp)
  802773:	ff 75 0c             	pushl  0xc(%ebp)
  802776:	e8 01 f8 ff ff       	call   801f7c <strlen>
  80277b:	83 c4 04             	add    $0x4,%esp
  80277e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802781:	7f a6                	jg     802729 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802783:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802786:	c9                   	leave  
  802787:	c3                   	ret    

00802788 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802788:	55                   	push   %ebp
  802789:	89 e5                	mov    %esp,%ebp
  80278b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80278e:	a1 08 50 80 00       	mov    0x805008,%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	74 42                	je     8027d9 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802797:	83 ec 08             	sub    $0x8,%esp
  80279a:	68 00 00 00 82       	push   $0x82000000
  80279f:	68 00 00 00 80       	push   $0x80000000
  8027a4:	e8 00 08 00 00       	call   802fa9 <initialize_dynamic_allocator>
  8027a9:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8027ac:	e8 e7 05 00 00       	call   802d98 <sys_get_uheap_strategy>
  8027b1:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8027b6:	a1 20 52 80 00       	mov    0x805220,%eax
  8027bb:	05 00 10 00 00       	add    $0x1000,%eax
  8027c0:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8027c5:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  8027ca:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  8027cf:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8027d6:	00 00 00 
	}
}
  8027d9:	90                   	nop
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8027e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027f0:	83 ec 08             	sub    $0x8,%esp
  8027f3:	68 06 04 00 00       	push   $0x406
  8027f8:	50                   	push   %eax
  8027f9:	e8 e4 01 00 00       	call   8029e2 <__sys_allocate_page>
  8027fe:	83 c4 10             	add    $0x10,%esp
  802801:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802808:	79 14                	jns    80281e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80280a:	83 ec 04             	sub    $0x4,%esp
  80280d:	68 68 4a 80 00       	push   $0x804a68
  802812:	6a 1f                	push   $0x1f
  802814:	68 a4 4a 80 00       	push   $0x804aa4
  802819:	e8 b7 ed ff ff       	call   8015d5 <_panic>
	return 0;
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802839:	83 ec 0c             	sub    $0xc,%esp
  80283c:	50                   	push   %eax
  80283d:	e8 e7 01 00 00       	call   802a29 <__sys_unmap_frame>
  802842:	83 c4 10             	add    $0x10,%esp
  802845:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284c:	79 14                	jns    802862 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80284e:	83 ec 04             	sub    $0x4,%esp
  802851:	68 b0 4a 80 00       	push   $0x804ab0
  802856:	6a 2a                	push   $0x2a
  802858:	68 a4 4a 80 00       	push   $0x804aa4
  80285d:	e8 73 ed ff ff       	call   8015d5 <_panic>
}
  802862:	90                   	nop
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80286b:	e8 18 ff ff ff       	call   802788 <uheap_init>
	if (size == 0) return NULL ;
  802870:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802874:	75 07                	jne    80287d <malloc+0x18>
  802876:	b8 00 00 00 00       	mov    $0x0,%eax
  80287b:	eb 14                	jmp    802891 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 f0 4a 80 00       	push   $0x804af0
  802885:	6a 3e                	push   $0x3e
  802887:	68 a4 4a 80 00       	push   $0x804aa4
  80288c:	e8 44 ed ff ff       	call   8015d5 <_panic>
}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
  802896:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802899:	83 ec 04             	sub    $0x4,%esp
  80289c:	68 18 4b 80 00       	push   $0x804b18
  8028a1:	6a 49                	push   $0x49
  8028a3:	68 a4 4a 80 00       	push   $0x804aa4
  8028a8:	e8 28 ed ff ff       	call   8015d5 <_panic>

008028ad <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8028ad:	55                   	push   %ebp
  8028ae:	89 e5                	mov    %esp,%ebp
  8028b0:	83 ec 18             	sub    $0x18,%esp
  8028b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b6:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028b9:	e8 ca fe ff ff       	call   802788 <uheap_init>
	if (size == 0) return NULL ;
  8028be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028c2:	75 07                	jne    8028cb <smalloc+0x1e>
  8028c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c9:	eb 14                	jmp    8028df <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8028cb:	83 ec 04             	sub    $0x4,%esp
  8028ce:	68 3c 4b 80 00       	push   $0x804b3c
  8028d3:	6a 5a                	push   $0x5a
  8028d5:	68 a4 4a 80 00       	push   $0x804aa4
  8028da:	e8 f6 ec ff ff       	call   8015d5 <_panic>
}
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028e7:	e8 9c fe ff ff       	call   802788 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8028ec:	83 ec 04             	sub    $0x4,%esp
  8028ef:	68 64 4b 80 00       	push   $0x804b64
  8028f4:	6a 6a                	push   $0x6a
  8028f6:	68 a4 4a 80 00       	push   $0x804aa4
  8028fb:	e8 d5 ec ff ff       	call   8015d5 <_panic>

00802900 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802906:	e8 7d fe ff ff       	call   802788 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80290b:	83 ec 04             	sub    $0x4,%esp
  80290e:	68 88 4b 80 00       	push   $0x804b88
  802913:	68 88 00 00 00       	push   $0x88
  802918:	68 a4 4a 80 00       	push   $0x804aa4
  80291d:	e8 b3 ec ff ff       	call   8015d5 <_panic>

00802922 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802928:	83 ec 04             	sub    $0x4,%esp
  80292b:	68 b0 4b 80 00       	push   $0x804bb0
  802930:	68 9b 00 00 00       	push   $0x9b
  802935:	68 a4 4a 80 00       	push   $0x804aa4
  80293a:	e8 96 ec ff ff       	call   8015d5 <_panic>

0080293f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	57                   	push   %edi
  802943:	56                   	push   %esi
  802944:	53                   	push   %ebx
  802945:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80294e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802951:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802954:	8b 7d 18             	mov    0x18(%ebp),%edi
  802957:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80295a:	cd 30                	int    $0x30
  80295c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802962:	83 c4 10             	add    $0x10,%esp
  802965:	5b                   	pop    %ebx
  802966:	5e                   	pop    %esi
  802967:	5f                   	pop    %edi
  802968:	5d                   	pop    %ebp
  802969:	c3                   	ret    

0080296a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	8b 45 10             	mov    0x10(%ebp),%eax
  802973:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802976:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802979:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	6a 00                	push   $0x0
  802982:	51                   	push   %ecx
  802983:	52                   	push   %edx
  802984:	ff 75 0c             	pushl  0xc(%ebp)
  802987:	50                   	push   %eax
  802988:	6a 00                	push   $0x0
  80298a:	e8 b0 ff ff ff       	call   80293f <syscall>
  80298f:	83 c4 18             	add    $0x18,%esp
}
  802992:	90                   	nop
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <sys_cgetc>:

int
sys_cgetc(void)
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802998:	6a 00                	push   $0x0
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 02                	push   $0x2
  8029a4:	e8 96 ff ff ff       	call   80293f <syscall>
  8029a9:	83 c4 18             	add    $0x18,%esp
}
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <sys_lock_cons>:

void sys_lock_cons(void)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 03                	push   $0x3
  8029bd:	e8 7d ff ff ff       	call   80293f <syscall>
  8029c2:	83 c4 18             	add    $0x18,%esp
}
  8029c5:	90                   	nop
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 04                	push   $0x4
  8029d7:	e8 63 ff ff ff       	call   80293f <syscall>
  8029dc:	83 c4 18             	add    $0x18,%esp
}
  8029df:	90                   	nop
  8029e0:	c9                   	leave  
  8029e1:	c3                   	ret    

008029e2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8029e2:	55                   	push   %ebp
  8029e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8029e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	52                   	push   %edx
  8029f2:	50                   	push   %eax
  8029f3:	6a 08                	push   $0x8
  8029f5:	e8 45 ff ff ff       	call   80293f <syscall>
  8029fa:	83 c4 18             	add    $0x18,%esp
}
  8029fd:	c9                   	leave  
  8029fe:	c3                   	ret    

008029ff <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a04:	8b 75 18             	mov    0x18(%ebp),%esi
  802a07:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	56                   	push   %esi
  802a14:	53                   	push   %ebx
  802a15:	51                   	push   %ecx
  802a16:	52                   	push   %edx
  802a17:	50                   	push   %eax
  802a18:	6a 09                	push   $0x9
  802a1a:	e8 20 ff ff ff       	call   80293f <syscall>
  802a1f:	83 c4 18             	add    $0x18,%esp
}
  802a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a25:	5b                   	pop    %ebx
  802a26:	5e                   	pop    %esi
  802a27:	5d                   	pop    %ebp
  802a28:	c3                   	ret    

00802a29 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802a29:	55                   	push   %ebp
  802a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	6a 00                	push   $0x0
  802a34:	ff 75 08             	pushl  0x8(%ebp)
  802a37:	6a 0a                	push   $0xa
  802a39:	e8 01 ff ff ff       	call   80293f <syscall>
  802a3e:	83 c4 18             	add    $0x18,%esp
}
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    

00802a43 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a46:	6a 00                	push   $0x0
  802a48:	6a 00                	push   $0x0
  802a4a:	6a 00                	push   $0x0
  802a4c:	ff 75 0c             	pushl  0xc(%ebp)
  802a4f:	ff 75 08             	pushl  0x8(%ebp)
  802a52:	6a 0b                	push   $0xb
  802a54:	e8 e6 fe ff ff       	call   80293f <syscall>
  802a59:	83 c4 18             	add    $0x18,%esp
}
  802a5c:	c9                   	leave  
  802a5d:	c3                   	ret    

00802a5e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a5e:	55                   	push   %ebp
  802a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	6a 00                	push   $0x0
  802a6b:	6a 0c                	push   $0xc
  802a6d:	e8 cd fe ff ff       	call   80293f <syscall>
  802a72:	83 c4 18             	add    $0x18,%esp
}
  802a75:	c9                   	leave  
  802a76:	c3                   	ret    

00802a77 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a77:	55                   	push   %ebp
  802a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a7a:	6a 00                	push   $0x0
  802a7c:	6a 00                	push   $0x0
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 00                	push   $0x0
  802a82:	6a 00                	push   $0x0
  802a84:	6a 0d                	push   $0xd
  802a86:	e8 b4 fe ff ff       	call   80293f <syscall>
  802a8b:	83 c4 18             	add    $0x18,%esp
}
  802a8e:	c9                   	leave  
  802a8f:	c3                   	ret    

00802a90 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 0e                	push   $0xe
  802a9f:	e8 9b fe ff ff       	call   80293f <syscall>
  802aa4:	83 c4 18             	add    $0x18,%esp
}
  802aa7:	c9                   	leave  
  802aa8:	c3                   	ret    

00802aa9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802aa9:	55                   	push   %ebp
  802aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 0f                	push   $0xf
  802ab8:	e8 82 fe ff ff       	call   80293f <syscall>
  802abd:	83 c4 18             	add    $0x18,%esp
}
  802ac0:	c9                   	leave  
  802ac1:	c3                   	ret    

00802ac2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ac2:	55                   	push   %ebp
  802ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ac5:	6a 00                	push   $0x0
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	ff 75 08             	pushl  0x8(%ebp)
  802ad0:	6a 10                	push   $0x10
  802ad2:	e8 68 fe ff ff       	call   80293f <syscall>
  802ad7:	83 c4 18             	add    $0x18,%esp
}
  802ada:	c9                   	leave  
  802adb:	c3                   	ret    

00802adc <sys_scarce_memory>:

void sys_scarce_memory()
{
  802adc:	55                   	push   %ebp
  802add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 11                	push   $0x11
  802aeb:	e8 4f fe ff ff       	call   80293f <syscall>
  802af0:	83 c4 18             	add    $0x18,%esp
}
  802af3:	90                   	nop
  802af4:	c9                   	leave  
  802af5:	c3                   	ret    

00802af6 <sys_cputc>:

void
sys_cputc(const char c)
{
  802af6:	55                   	push   %ebp
  802af7:	89 e5                	mov    %esp,%ebp
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802b02:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b06:	6a 00                	push   $0x0
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 00                	push   $0x0
  802b0c:	6a 00                	push   $0x0
  802b0e:	50                   	push   %eax
  802b0f:	6a 01                	push   $0x1
  802b11:	e8 29 fe ff ff       	call   80293f <syscall>
  802b16:	83 c4 18             	add    $0x18,%esp
}
  802b19:	90                   	nop
  802b1a:	c9                   	leave  
  802b1b:	c3                   	ret    

00802b1c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802b1c:	55                   	push   %ebp
  802b1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802b1f:	6a 00                	push   $0x0
  802b21:	6a 00                	push   $0x0
  802b23:	6a 00                	push   $0x0
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	6a 14                	push   $0x14
  802b2b:	e8 0f fe ff ff       	call   80293f <syscall>
  802b30:	83 c4 18             	add    $0x18,%esp
}
  802b33:	90                   	nop
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	8b 45 10             	mov    0x10(%ebp),%eax
  802b3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802b42:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b45:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	6a 00                	push   $0x0
  802b4e:	51                   	push   %ecx
  802b4f:	52                   	push   %edx
  802b50:	ff 75 0c             	pushl  0xc(%ebp)
  802b53:	50                   	push   %eax
  802b54:	6a 15                	push   $0x15
  802b56:	e8 e4 fd ff ff       	call   80293f <syscall>
  802b5b:	83 c4 18             	add    $0x18,%esp
}
  802b5e:	c9                   	leave  
  802b5f:	c3                   	ret    

00802b60 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	6a 00                	push   $0x0
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 00                	push   $0x0
  802b6f:	52                   	push   %edx
  802b70:	50                   	push   %eax
  802b71:	6a 16                	push   $0x16
  802b73:	e8 c7 fd ff ff       	call   80293f <syscall>
  802b78:	83 c4 18             	add    $0x18,%esp
}
  802b7b:	c9                   	leave  
  802b7c:	c3                   	ret    

00802b7d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802b7d:	55                   	push   %ebp
  802b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b80:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	51                   	push   %ecx
  802b8e:	52                   	push   %edx
  802b8f:	50                   	push   %eax
  802b90:	6a 17                	push   $0x17
  802b92:	e8 a8 fd ff ff       	call   80293f <syscall>
  802b97:	83 c4 18             	add    $0x18,%esp
}
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    

00802b9c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	6a 00                	push   $0x0
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 00                	push   $0x0
  802bab:	52                   	push   %edx
  802bac:	50                   	push   %eax
  802bad:	6a 18                	push   $0x18
  802baf:	e8 8b fd ff ff       	call   80293f <syscall>
  802bb4:	83 c4 18             	add    $0x18,%esp
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	6a 00                	push   $0x0
  802bc1:	ff 75 14             	pushl  0x14(%ebp)
  802bc4:	ff 75 10             	pushl  0x10(%ebp)
  802bc7:	ff 75 0c             	pushl  0xc(%ebp)
  802bca:	50                   	push   %eax
  802bcb:	6a 19                	push   $0x19
  802bcd:	e8 6d fd ff ff       	call   80293f <syscall>
  802bd2:	83 c4 18             	add    $0x18,%esp
}
  802bd5:	c9                   	leave  
  802bd6:	c3                   	ret    

00802bd7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802bd7:	55                   	push   %ebp
  802bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	6a 00                	push   $0x0
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	50                   	push   %eax
  802be6:	6a 1a                	push   $0x1a
  802be8:	e8 52 fd ff ff       	call   80293f <syscall>
  802bed:	83 c4 18             	add    $0x18,%esp
}
  802bf0:	90                   	nop
  802bf1:	c9                   	leave  
  802bf2:	c3                   	ret    

00802bf3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	6a 00                	push   $0x0
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 00                	push   $0x0
  802c01:	50                   	push   %eax
  802c02:	6a 1b                	push   $0x1b
  802c04:	e8 36 fd ff ff       	call   80293f <syscall>
  802c09:	83 c4 18             	add    $0x18,%esp
}
  802c0c:	c9                   	leave  
  802c0d:	c3                   	ret    

00802c0e <sys_getenvid>:

int32 sys_getenvid(void)
{
  802c0e:	55                   	push   %ebp
  802c0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	6a 00                	push   $0x0
  802c17:	6a 00                	push   $0x0
  802c19:	6a 00                	push   $0x0
  802c1b:	6a 05                	push   $0x5
  802c1d:	e8 1d fd ff ff       	call   80293f <syscall>
  802c22:	83 c4 18             	add    $0x18,%esp
}
  802c25:	c9                   	leave  
  802c26:	c3                   	ret    

00802c27 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802c27:	55                   	push   %ebp
  802c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 00                	push   $0x0
  802c30:	6a 00                	push   $0x0
  802c32:	6a 00                	push   $0x0
  802c34:	6a 06                	push   $0x6
  802c36:	e8 04 fd ff ff       	call   80293f <syscall>
  802c3b:	83 c4 18             	add    $0x18,%esp
}
  802c3e:	c9                   	leave  
  802c3f:	c3                   	ret    

00802c40 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	6a 00                	push   $0x0
  802c4b:	6a 00                	push   $0x0
  802c4d:	6a 07                	push   $0x7
  802c4f:	e8 eb fc ff ff       	call   80293f <syscall>
  802c54:	83 c4 18             	add    $0x18,%esp
}
  802c57:	c9                   	leave  
  802c58:	c3                   	ret    

00802c59 <sys_exit_env>:


void sys_exit_env(void)
{
  802c59:	55                   	push   %ebp
  802c5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 00                	push   $0x0
  802c66:	6a 1c                	push   $0x1c
  802c68:	e8 d2 fc ff ff       	call   80293f <syscall>
  802c6d:	83 c4 18             	add    $0x18,%esp
}
  802c70:	90                   	nop
  802c71:	c9                   	leave  
  802c72:	c3                   	ret    

00802c73 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802c73:	55                   	push   %ebp
  802c74:	89 e5                	mov    %esp,%ebp
  802c76:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c79:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c7c:	8d 50 04             	lea    0x4(%eax),%edx
  802c7f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	52                   	push   %edx
  802c89:	50                   	push   %eax
  802c8a:	6a 1d                	push   $0x1d
  802c8c:	e8 ae fc ff ff       	call   80293f <syscall>
  802c91:	83 c4 18             	add    $0x18,%esp
	return result;
  802c94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c9d:	89 01                	mov    %eax,(%ecx)
  802c9f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	c9                   	leave  
  802ca6:	c2 04 00             	ret    $0x4

00802ca9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802cac:	6a 00                	push   $0x0
  802cae:	6a 00                	push   $0x0
  802cb0:	ff 75 10             	pushl  0x10(%ebp)
  802cb3:	ff 75 0c             	pushl  0xc(%ebp)
  802cb6:	ff 75 08             	pushl  0x8(%ebp)
  802cb9:	6a 13                	push   $0x13
  802cbb:	e8 7f fc ff ff       	call   80293f <syscall>
  802cc0:	83 c4 18             	add    $0x18,%esp
	return ;
  802cc3:	90                   	nop
}
  802cc4:	c9                   	leave  
  802cc5:	c3                   	ret    

00802cc6 <sys_rcr2>:
uint32 sys_rcr2()
{
  802cc6:	55                   	push   %ebp
  802cc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 00                	push   $0x0
  802ccf:	6a 00                	push   $0x0
  802cd1:	6a 00                	push   $0x0
  802cd3:	6a 1e                	push   $0x1e
  802cd5:	e8 65 fc ff ff       	call   80293f <syscall>
  802cda:	83 c4 18             	add    $0x18,%esp
}
  802cdd:	c9                   	leave  
  802cde:	c3                   	ret    

00802cdf <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802cdf:	55                   	push   %ebp
  802ce0:	89 e5                	mov    %esp,%ebp
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ceb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802cef:	6a 00                	push   $0x0
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	50                   	push   %eax
  802cf8:	6a 1f                	push   $0x1f
  802cfa:	e8 40 fc ff ff       	call   80293f <syscall>
  802cff:	83 c4 18             	add    $0x18,%esp
	return ;
  802d02:	90                   	nop
}
  802d03:	c9                   	leave  
  802d04:	c3                   	ret    

00802d05 <rsttst>:
void rsttst()
{
  802d05:	55                   	push   %ebp
  802d06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802d08:	6a 00                	push   $0x0
  802d0a:	6a 00                	push   $0x0
  802d0c:	6a 00                	push   $0x0
  802d0e:	6a 00                	push   $0x0
  802d10:	6a 00                	push   $0x0
  802d12:	6a 21                	push   $0x21
  802d14:	e8 26 fc ff ff       	call   80293f <syscall>
  802d19:	83 c4 18             	add    $0x18,%esp
	return ;
  802d1c:	90                   	nop
}
  802d1d:	c9                   	leave  
  802d1e:	c3                   	ret    

00802d1f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802d1f:	55                   	push   %ebp
  802d20:	89 e5                	mov    %esp,%ebp
  802d22:	83 ec 04             	sub    $0x4,%esp
  802d25:	8b 45 14             	mov    0x14(%ebp),%eax
  802d28:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802d2b:	8b 55 18             	mov    0x18(%ebp),%edx
  802d2e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d32:	52                   	push   %edx
  802d33:	50                   	push   %eax
  802d34:	ff 75 10             	pushl  0x10(%ebp)
  802d37:	ff 75 0c             	pushl  0xc(%ebp)
  802d3a:	ff 75 08             	pushl  0x8(%ebp)
  802d3d:	6a 20                	push   $0x20
  802d3f:	e8 fb fb ff ff       	call   80293f <syscall>
  802d44:	83 c4 18             	add    $0x18,%esp
	return ;
  802d47:	90                   	nop
}
  802d48:	c9                   	leave  
  802d49:	c3                   	ret    

00802d4a <chktst>:
void chktst(uint32 n)
{
  802d4a:	55                   	push   %ebp
  802d4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	ff 75 08             	pushl  0x8(%ebp)
  802d58:	6a 22                	push   $0x22
  802d5a:	e8 e0 fb ff ff       	call   80293f <syscall>
  802d5f:	83 c4 18             	add    $0x18,%esp
	return ;
  802d62:	90                   	nop
}
  802d63:	c9                   	leave  
  802d64:	c3                   	ret    

00802d65 <inctst>:

void inctst()
{
  802d65:	55                   	push   %ebp
  802d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d68:	6a 00                	push   $0x0
  802d6a:	6a 00                	push   $0x0
  802d6c:	6a 00                	push   $0x0
  802d6e:	6a 00                	push   $0x0
  802d70:	6a 00                	push   $0x0
  802d72:	6a 23                	push   $0x23
  802d74:	e8 c6 fb ff ff       	call   80293f <syscall>
  802d79:	83 c4 18             	add    $0x18,%esp
	return ;
  802d7c:	90                   	nop
}
  802d7d:	c9                   	leave  
  802d7e:	c3                   	ret    

00802d7f <gettst>:
uint32 gettst()
{
  802d7f:	55                   	push   %ebp
  802d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d82:	6a 00                	push   $0x0
  802d84:	6a 00                	push   $0x0
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 24                	push   $0x24
  802d8e:	e8 ac fb ff ff       	call   80293f <syscall>
  802d93:	83 c4 18             	add    $0x18,%esp
}
  802d96:	c9                   	leave  
  802d97:	c3                   	ret    

00802d98 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802d98:	55                   	push   %ebp
  802d99:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d9b:	6a 00                	push   $0x0
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	6a 00                	push   $0x0
  802da5:	6a 25                	push   $0x25
  802da7:	e8 93 fb ff ff       	call   80293f <syscall>
  802dac:	83 c4 18             	add    $0x18,%esp
  802daf:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802db4:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802db9:	c9                   	leave  
  802dba:	c3                   	ret    

00802dbb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802dbb:	55                   	push   %ebp
  802dbc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802dc6:	6a 00                	push   $0x0
  802dc8:	6a 00                	push   $0x0
  802dca:	6a 00                	push   $0x0
  802dcc:	6a 00                	push   $0x0
  802dce:	ff 75 08             	pushl  0x8(%ebp)
  802dd1:	6a 26                	push   $0x26
  802dd3:	e8 67 fb ff ff       	call   80293f <syscall>
  802dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  802ddb:	90                   	nop
}
  802ddc:	c9                   	leave  
  802ddd:	c3                   	ret    

00802dde <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802dde:	55                   	push   %ebp
  802ddf:	89 e5                	mov    %esp,%ebp
  802de1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802de2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802de5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	6a 00                	push   $0x0
  802df0:	53                   	push   %ebx
  802df1:	51                   	push   %ecx
  802df2:	52                   	push   %edx
  802df3:	50                   	push   %eax
  802df4:	6a 27                	push   $0x27
  802df6:	e8 44 fb ff ff       	call   80293f <syscall>
  802dfb:	83 c4 18             	add    $0x18,%esp
}
  802dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e01:	c9                   	leave  
  802e02:	c3                   	ret    

00802e03 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e03:	55                   	push   %ebp
  802e04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	6a 00                	push   $0x0
  802e0e:	6a 00                	push   $0x0
  802e10:	6a 00                	push   $0x0
  802e12:	52                   	push   %edx
  802e13:	50                   	push   %eax
  802e14:	6a 28                	push   $0x28
  802e16:	e8 24 fb ff ff       	call   80293f <syscall>
  802e1b:	83 c4 18             	add    $0x18,%esp
}
  802e1e:	c9                   	leave  
  802e1f:	c3                   	ret    

00802e20 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802e23:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	6a 00                	push   $0x0
  802e2e:	51                   	push   %ecx
  802e2f:	ff 75 10             	pushl  0x10(%ebp)
  802e32:	52                   	push   %edx
  802e33:	50                   	push   %eax
  802e34:	6a 29                	push   $0x29
  802e36:	e8 04 fb ff ff       	call   80293f <syscall>
  802e3b:	83 c4 18             	add    $0x18,%esp
}
  802e3e:	c9                   	leave  
  802e3f:	c3                   	ret    

00802e40 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802e40:	55                   	push   %ebp
  802e41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802e43:	6a 00                	push   $0x0
  802e45:	6a 00                	push   $0x0
  802e47:	ff 75 10             	pushl  0x10(%ebp)
  802e4a:	ff 75 0c             	pushl  0xc(%ebp)
  802e4d:	ff 75 08             	pushl  0x8(%ebp)
  802e50:	6a 12                	push   $0x12
  802e52:	e8 e8 fa ff ff       	call   80293f <syscall>
  802e57:	83 c4 18             	add    $0x18,%esp
	return ;
  802e5a:	90                   	nop
}
  802e5b:	c9                   	leave  
  802e5c:	c3                   	ret    

00802e5d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802e5d:	55                   	push   %ebp
  802e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802e60:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	6a 00                	push   $0x0
  802e68:	6a 00                	push   $0x0
  802e6a:	6a 00                	push   $0x0
  802e6c:	52                   	push   %edx
  802e6d:	50                   	push   %eax
  802e6e:	6a 2a                	push   $0x2a
  802e70:	e8 ca fa ff ff       	call   80293f <syscall>
  802e75:	83 c4 18             	add    $0x18,%esp
	return;
  802e78:	90                   	nop
}
  802e79:	c9                   	leave  
  802e7a:	c3                   	ret    

00802e7b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802e7b:	55                   	push   %ebp
  802e7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802e7e:	6a 00                	push   $0x0
  802e80:	6a 00                	push   $0x0
  802e82:	6a 00                	push   $0x0
  802e84:	6a 00                	push   $0x0
  802e86:	6a 00                	push   $0x0
  802e88:	6a 2b                	push   $0x2b
  802e8a:	e8 b0 fa ff ff       	call   80293f <syscall>
  802e8f:	83 c4 18             	add    $0x18,%esp
}
  802e92:	c9                   	leave  
  802e93:	c3                   	ret    

00802e94 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e94:	55                   	push   %ebp
  802e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	ff 75 0c             	pushl  0xc(%ebp)
  802ea0:	ff 75 08             	pushl  0x8(%ebp)
  802ea3:	6a 2d                	push   $0x2d
  802ea5:	e8 95 fa ff ff       	call   80293f <syscall>
  802eaa:	83 c4 18             	add    $0x18,%esp
	return;
  802ead:	90                   	nop
}
  802eae:	c9                   	leave  
  802eaf:	c3                   	ret    

00802eb0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	6a 00                	push   $0x0
  802eb9:	ff 75 0c             	pushl  0xc(%ebp)
  802ebc:	ff 75 08             	pushl  0x8(%ebp)
  802ebf:	6a 2c                	push   $0x2c
  802ec1:	e8 79 fa ff ff       	call   80293f <syscall>
  802ec6:	83 c4 18             	add    $0x18,%esp
	return ;
  802ec9:	90                   	nop
}
  802eca:	c9                   	leave  
  802ecb:	c3                   	ret    

00802ecc <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802ecc:	55                   	push   %ebp
  802ecd:	89 e5                	mov    %esp,%ebp
  802ecf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802ed2:	83 ec 04             	sub    $0x4,%esp
  802ed5:	68 d4 4b 80 00       	push   $0x804bd4
  802eda:	68 25 01 00 00       	push   $0x125
  802edf:	68 07 4c 80 00       	push   $0x804c07
  802ee4:	e8 ec e6 ff ff       	call   8015d5 <_panic>

00802ee9 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802ee9:	55                   	push   %ebp
  802eea:	89 e5                	mov    %esp,%ebp
  802eec:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802eef:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802ef6:	72 09                	jb     802f01 <to_page_va+0x18>
  802ef8:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802eff:	72 14                	jb     802f15 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802f01:	83 ec 04             	sub    $0x4,%esp
  802f04:	68 18 4c 80 00       	push   $0x804c18
  802f09:	6a 15                	push   $0x15
  802f0b:	68 43 4c 80 00       	push   $0x804c43
  802f10:	e8 c0 e6 ff ff       	call   8015d5 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	ba 40 52 80 00       	mov    $0x805240,%edx
  802f1d:	29 d0                	sub    %edx,%eax
  802f1f:	c1 f8 02             	sar    $0x2,%eax
  802f22:	89 c2                	mov    %eax,%edx
  802f24:	89 d0                	mov    %edx,%eax
  802f26:	c1 e0 02             	shl    $0x2,%eax
  802f29:	01 d0                	add    %edx,%eax
  802f2b:	c1 e0 02             	shl    $0x2,%eax
  802f2e:	01 d0                	add    %edx,%eax
  802f30:	c1 e0 02             	shl    $0x2,%eax
  802f33:	01 d0                	add    %edx,%eax
  802f35:	89 c1                	mov    %eax,%ecx
  802f37:	c1 e1 08             	shl    $0x8,%ecx
  802f3a:	01 c8                	add    %ecx,%eax
  802f3c:	89 c1                	mov    %eax,%ecx
  802f3e:	c1 e1 10             	shl    $0x10,%ecx
  802f41:	01 c8                	add    %ecx,%eax
  802f43:	01 c0                	add    %eax,%eax
  802f45:	01 d0                	add    %edx,%eax
  802f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	c1 e0 0c             	shl    $0xc,%eax
  802f50:	89 c2                	mov    %eax,%edx
  802f52:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802f57:	01 d0                	add    %edx,%eax
}
  802f59:	c9                   	leave  
  802f5a:	c3                   	ret    

00802f5b <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802f5b:	55                   	push   %ebp
  802f5c:	89 e5                	mov    %esp,%ebp
  802f5e:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802f61:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802f66:	8b 55 08             	mov    0x8(%ebp),%edx
  802f69:	29 c2                	sub    %eax,%edx
  802f6b:	89 d0                	mov    %edx,%eax
  802f6d:	c1 e8 0c             	shr    $0xc,%eax
  802f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802f73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f77:	78 09                	js     802f82 <to_page_info+0x27>
  802f79:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802f80:	7e 14                	jle    802f96 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802f82:	83 ec 04             	sub    $0x4,%esp
  802f85:	68 5c 4c 80 00       	push   $0x804c5c
  802f8a:	6a 22                	push   $0x22
  802f8c:	68 43 4c 80 00       	push   $0x804c43
  802f91:	e8 3f e6 ff ff       	call   8015d5 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f99:	89 d0                	mov    %edx,%eax
  802f9b:	01 c0                	add    %eax,%eax
  802f9d:	01 d0                	add    %edx,%eax
  802f9f:	c1 e0 02             	shl    $0x2,%eax
  802fa2:	05 40 52 80 00       	add    $0x805240,%eax
}
  802fa7:	c9                   	leave  
  802fa8:	c3                   	ret    

00802fa9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802fa9:	55                   	push   %ebp
  802faa:	89 e5                	mov    %esp,%ebp
  802fac:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	05 00 00 00 02       	add    $0x2000000,%eax
  802fb7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fba:	73 16                	jae    802fd2 <initialize_dynamic_allocator+0x29>
  802fbc:	68 80 4c 80 00       	push   $0x804c80
  802fc1:	68 a6 4c 80 00       	push   $0x804ca6
  802fc6:	6a 34                	push   $0x34
  802fc8:	68 43 4c 80 00       	push   $0x804c43
  802fcd:	e8 03 e6 ff ff       	call   8015d5 <_panic>
		is_initialized = 1;
  802fd2:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802fd9:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe7:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802fec:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802ff3:	00 00 00 
  802ff6:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802ffd:	00 00 00 
  803000:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  803007:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  80300a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300d:	2b 45 08             	sub    0x8(%ebp),%eax
  803010:	c1 e8 0c             	shr    $0xc,%eax
  803013:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  803016:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80301d:	e9 c8 00 00 00       	jmp    8030ea <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  803022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803025:	89 d0                	mov    %edx,%eax
  803027:	01 c0                	add    %eax,%eax
  803029:	01 d0                	add    %edx,%eax
  80302b:	c1 e0 02             	shl    $0x2,%eax
  80302e:	05 48 52 80 00       	add    $0x805248,%eax
  803033:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303b:	89 d0                	mov    %edx,%eax
  80303d:	01 c0                	add    %eax,%eax
  80303f:	01 d0                	add    %edx,%eax
  803041:	c1 e0 02             	shl    $0x2,%eax
  803044:	05 4a 52 80 00       	add    $0x80524a,%eax
  803049:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80304e:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803054:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803057:	89 c8                	mov    %ecx,%eax
  803059:	01 c0                	add    %eax,%eax
  80305b:	01 c8                	add    %ecx,%eax
  80305d:	c1 e0 02             	shl    $0x2,%eax
  803060:	05 44 52 80 00       	add    $0x805244,%eax
  803065:	89 10                	mov    %edx,(%eax)
  803067:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306a:	89 d0                	mov    %edx,%eax
  80306c:	01 c0                	add    %eax,%eax
  80306e:	01 d0                	add    %edx,%eax
  803070:	c1 e0 02             	shl    $0x2,%eax
  803073:	05 44 52 80 00       	add    $0x805244,%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	74 1b                	je     803099 <initialize_dynamic_allocator+0xf0>
  80307e:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803084:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803087:	89 c8                	mov    %ecx,%eax
  803089:	01 c0                	add    %eax,%eax
  80308b:	01 c8                	add    %ecx,%eax
  80308d:	c1 e0 02             	shl    $0x2,%eax
  803090:	05 40 52 80 00       	add    $0x805240,%eax
  803095:	89 02                	mov    %eax,(%edx)
  803097:	eb 16                	jmp    8030af <initialize_dynamic_allocator+0x106>
  803099:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309c:	89 d0                	mov    %edx,%eax
  80309e:	01 c0                	add    %eax,%eax
  8030a0:	01 d0                	add    %edx,%eax
  8030a2:	c1 e0 02             	shl    $0x2,%eax
  8030a5:	05 40 52 80 00       	add    $0x805240,%eax
  8030aa:	a3 28 52 80 00       	mov    %eax,0x805228
  8030af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b2:	89 d0                	mov    %edx,%eax
  8030b4:	01 c0                	add    %eax,%eax
  8030b6:	01 d0                	add    %edx,%eax
  8030b8:	c1 e0 02             	shl    $0x2,%eax
  8030bb:	05 40 52 80 00       	add    $0x805240,%eax
  8030c0:	a3 2c 52 80 00       	mov    %eax,0x80522c
  8030c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c8:	89 d0                	mov    %edx,%eax
  8030ca:	01 c0                	add    %eax,%eax
  8030cc:	01 d0                	add    %edx,%eax
  8030ce:	c1 e0 02             	shl    $0x2,%eax
  8030d1:	05 40 52 80 00       	add    $0x805240,%eax
  8030d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030dc:	a1 34 52 80 00       	mov    0x805234,%eax
  8030e1:	40                   	inc    %eax
  8030e2:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8030e7:	ff 45 f4             	incl   -0xc(%ebp)
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8030f0:	0f 8c 2c ff ff ff    	jl     803022 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8030f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8030fd:	eb 36                	jmp    803135 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8030ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803102:	c1 e0 04             	shl    $0x4,%eax
  803105:	05 60 d2 81 00       	add    $0x81d260,%eax
  80310a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803113:	c1 e0 04             	shl    $0x4,%eax
  803116:	05 64 d2 81 00       	add    $0x81d264,%eax
  80311b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	c1 e0 04             	shl    $0x4,%eax
  803127:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80312c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803132:	ff 45 f0             	incl   -0x10(%ebp)
  803135:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803139:	7e c4                	jle    8030ff <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80313b:	90                   	nop
  80313c:	c9                   	leave  
  80313d:	c3                   	ret    

0080313e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80313e:	55                   	push   %ebp
  80313f:	89 e5                	mov    %esp,%ebp
  803141:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	83 ec 0c             	sub    $0xc,%esp
  80314a:	50                   	push   %eax
  80314b:	e8 0b fe ff ff       	call   802f5b <to_page_info>
  803150:	83 c4 10             	add    $0x10,%esp
  803153:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  803156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803159:	8b 40 08             	mov    0x8(%eax),%eax
  80315c:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80315f:	c9                   	leave  
  803160:	c3                   	ret    

00803161 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
  803164:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  803167:	83 ec 0c             	sub    $0xc,%esp
  80316a:	ff 75 0c             	pushl  0xc(%ebp)
  80316d:	e8 77 fd ff ff       	call   802ee9 <to_page_va>
  803172:	83 c4 10             	add    $0x10,%esp
  803175:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  803178:	b8 00 10 00 00       	mov    $0x1000,%eax
  80317d:	ba 00 00 00 00       	mov    $0x0,%edx
  803182:	f7 75 08             	divl   0x8(%ebp)
  803185:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  803188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318b:	83 ec 0c             	sub    $0xc,%esp
  80318e:	50                   	push   %eax
  80318f:	e8 48 f6 ff ff       	call   8027dc <get_page>
  803194:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  803197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80319d:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a7:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8031ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8031b2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8031b9:	eb 19                	jmp    8031d4 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8031bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031be:	ba 01 00 00 00       	mov    $0x1,%edx
  8031c3:	88 c1                	mov    %al,%cl
  8031c5:	d3 e2                	shl    %cl,%edx
  8031c7:	89 d0                	mov    %edx,%eax
  8031c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031cc:	74 0e                	je     8031dc <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8031ce:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8031d1:	ff 45 f0             	incl   -0x10(%ebp)
  8031d4:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8031d8:	7e e1                	jle    8031bb <split_page_to_blocks+0x5a>
  8031da:	eb 01                	jmp    8031dd <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8031dc:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8031dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8031e4:	e9 a7 00 00 00       	jmp    803290 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ec:	0f af 45 08          	imul   0x8(%ebp),%eax
  8031f0:	89 c2                	mov    %eax,%edx
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	01 d0                	add    %edx,%eax
  8031f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8031fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031fe:	75 14                	jne    803214 <split_page_to_blocks+0xb3>
  803200:	83 ec 04             	sub    $0x4,%esp
  803203:	68 bc 4c 80 00       	push   $0x804cbc
  803208:	6a 7c                	push   $0x7c
  80320a:	68 43 4c 80 00       	push   $0x804c43
  80320f:	e8 c1 e3 ff ff       	call   8015d5 <_panic>
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	c1 e0 04             	shl    $0x4,%eax
  80321a:	05 64 d2 81 00       	add    $0x81d264,%eax
  80321f:	8b 10                	mov    (%eax),%edx
  803221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803224:	89 50 04             	mov    %edx,0x4(%eax)
  803227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80322a:	8b 40 04             	mov    0x4(%eax),%eax
  80322d:	85 c0                	test   %eax,%eax
  80322f:	74 14                	je     803245 <split_page_to_blocks+0xe4>
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	c1 e0 04             	shl    $0x4,%eax
  803237:	05 64 d2 81 00       	add    $0x81d264,%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803241:	89 10                	mov    %edx,(%eax)
  803243:	eb 11                	jmp    803256 <split_page_to_blocks+0xf5>
  803245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803248:	c1 e0 04             	shl    $0x4,%eax
  80324b:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  803251:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803254:	89 02                	mov    %eax,(%edx)
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	c1 e0 04             	shl    $0x4,%eax
  80325c:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  803262:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803265:	89 02                	mov    %eax,(%edx)
  803267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	c1 e0 04             	shl    $0x4,%eax
  803276:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	8d 50 01             	lea    0x1(%eax),%edx
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	c1 e0 04             	shl    $0x4,%eax
  803286:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80328b:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80328d:	ff 45 ec             	incl   -0x14(%ebp)
  803290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803293:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  803296:	0f 82 4d ff ff ff    	jb     8031e9 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80329c:	90                   	nop
  80329d:	c9                   	leave  
  80329e:	c3                   	ret    

0080329f <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80329f:	55                   	push   %ebp
  8032a0:	89 e5                	mov    %esp,%ebp
  8032a2:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8032a5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8032ac:	76 19                	jbe    8032c7 <alloc_block+0x28>
  8032ae:	68 e0 4c 80 00       	push   $0x804ce0
  8032b3:	68 a6 4c 80 00       	push   $0x804ca6
  8032b8:	68 8a 00 00 00       	push   $0x8a
  8032bd:	68 43 4c 80 00       	push   $0x804c43
  8032c2:	e8 0e e3 ff ff       	call   8015d5 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8032c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8032ce:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8032d5:	eb 19                	jmp    8032f0 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032da:	ba 01 00 00 00       	mov    $0x1,%edx
  8032df:	88 c1                	mov    %al,%cl
  8032e1:	d3 e2                	shl    %cl,%edx
  8032e3:	89 d0                	mov    %edx,%eax
  8032e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e8:	73 0e                	jae    8032f8 <alloc_block+0x59>
		idx++;
  8032ea:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8032ed:	ff 45 f0             	incl   -0x10(%ebp)
  8032f0:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8032f4:	7e e1                	jle    8032d7 <alloc_block+0x38>
  8032f6:	eb 01                	jmp    8032f9 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8032f8:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fc:	c1 e0 04             	shl    $0x4,%eax
  8032ff:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	85 c0                	test   %eax,%eax
  803308:	0f 84 df 00 00 00    	je     8033ed <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	c1 e0 04             	shl    $0x4,%eax
  803314:	05 60 d2 81 00       	add    $0x81d260,%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80331e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803322:	75 17                	jne    80333b <alloc_block+0x9c>
  803324:	83 ec 04             	sub    $0x4,%esp
  803327:	68 01 4d 80 00       	push   $0x804d01
  80332c:	68 9e 00 00 00       	push   $0x9e
  803331:	68 43 4c 80 00       	push   $0x804c43
  803336:	e8 9a e2 ff ff       	call   8015d5 <_panic>
  80333b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 10                	je     803354 <alloc_block+0xb5>
  803344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80334c:	8b 52 04             	mov    0x4(%edx),%edx
  80334f:	89 50 04             	mov    %edx,0x4(%eax)
  803352:	eb 14                	jmp    803368 <alloc_block+0xc9>
  803354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335d:	c1 e2 04             	shl    $0x4,%edx
  803360:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803366:	89 02                	mov    %eax,(%edx)
  803368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0f                	je     803381 <alloc_block+0xe2>
  803372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803375:	8b 40 04             	mov    0x4(%eax),%eax
  803378:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80337b:	8b 12                	mov    (%edx),%edx
  80337d:	89 10                	mov    %edx,(%eax)
  80337f:	eb 13                	jmp    803394 <alloc_block+0xf5>
  803381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803389:	c1 e2 04             	shl    $0x4,%edx
  80338c:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803392:	89 02                	mov    %eax,(%edx)
  803394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803397:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	c1 e0 04             	shl    $0x4,%eax
  8033ad:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8033b2:	8b 00                	mov    (%eax),%eax
  8033b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ba:	c1 e0 04             	shl    $0x4,%eax
  8033bd:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8033c2:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8033c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c7:	83 ec 0c             	sub    $0xc,%esp
  8033ca:	50                   	push   %eax
  8033cb:	e8 8b fb ff ff       	call   802f5b <to_page_info>
  8033d0:	83 c4 10             	add    $0x10,%esp
  8033d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8033d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8033dd:	48                   	dec    %eax
  8033de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033e1:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8033e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e8:	e9 bc 02 00 00       	jmp    8036a9 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8033ed:	a1 34 52 80 00       	mov    0x805234,%eax
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	0f 84 7d 02 00 00    	je     803677 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8033fa:	a1 28 52 80 00       	mov    0x805228,%eax
  8033ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  803402:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803406:	75 17                	jne    80341f <alloc_block+0x180>
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 01 4d 80 00       	push   $0x804d01
  803410:	68 a9 00 00 00       	push   $0xa9
  803415:	68 43 4c 80 00       	push   $0x804c43
  80341a:	e8 b6 e1 ff ff       	call   8015d5 <_panic>
  80341f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 10                	je     803438 <alloc_block+0x199>
  803428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803430:	8b 52 04             	mov    0x4(%edx),%edx
  803433:	89 50 04             	mov    %edx,0x4(%eax)
  803436:	eb 0b                	jmp    803443 <alloc_block+0x1a4>
  803438:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343b:	8b 40 04             	mov    0x4(%eax),%eax
  80343e:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 0f                	je     80345c <alloc_block+0x1bd>
  80344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803456:	8b 12                	mov    (%edx),%edx
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	eb 0a                	jmp    803466 <alloc_block+0x1c7>
  80345c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	a3 28 52 80 00       	mov    %eax,0x805228
  803466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803479:	a1 34 52 80 00       	mov    0x805234,%eax
  80347e:	48                   	dec    %eax
  80347f:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  803484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803487:	83 c0 03             	add    $0x3,%eax
  80348a:	ba 01 00 00 00       	mov    $0x1,%edx
  80348f:	88 c1                	mov    %al,%cl
  803491:	d3 e2                	shl    %cl,%edx
  803493:	89 d0                	mov    %edx,%eax
  803495:	83 ec 08             	sub    $0x8,%esp
  803498:	ff 75 e4             	pushl  -0x1c(%ebp)
  80349b:	50                   	push   %eax
  80349c:	e8 c0 fc ff ff       	call   803161 <split_page_to_blocks>
  8034a1:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	c1 e0 04             	shl    $0x4,%eax
  8034aa:	05 60 d2 81 00       	add    $0x81d260,%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8034b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034b8:	75 17                	jne    8034d1 <alloc_block+0x232>
  8034ba:	83 ec 04             	sub    $0x4,%esp
  8034bd:	68 01 4d 80 00       	push   $0x804d01
  8034c2:	68 b0 00 00 00       	push   $0xb0
  8034c7:	68 43 4c 80 00       	push   $0x804c43
  8034cc:	e8 04 e1 ff ff       	call   8015d5 <_panic>
  8034d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	74 10                	je     8034ea <alloc_block+0x24b>
  8034da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034e2:	8b 52 04             	mov    0x4(%edx),%edx
  8034e5:	89 50 04             	mov    %edx,0x4(%eax)
  8034e8:	eb 14                	jmp    8034fe <alloc_block+0x25f>
  8034ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ed:	8b 40 04             	mov    0x4(%eax),%eax
  8034f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f3:	c1 e2 04             	shl    $0x4,%edx
  8034f6:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8034fc:	89 02                	mov    %eax,(%edx)
  8034fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803501:	8b 40 04             	mov    0x4(%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	74 0f                	je     803517 <alloc_block+0x278>
  803508:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80350b:	8b 40 04             	mov    0x4(%eax),%eax
  80350e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803511:	8b 12                	mov    (%edx),%edx
  803513:	89 10                	mov    %edx,(%eax)
  803515:	eb 13                	jmp    80352a <alloc_block+0x28b>
  803517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80351f:	c1 e2 04             	shl    $0x4,%edx
  803522:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803528:	89 02                	mov    %eax,(%edx)
  80352a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80352d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803536:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	c1 e0 04             	shl    $0x4,%eax
  803543:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	c1 e0 04             	shl    $0x4,%eax
  803553:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803558:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80355a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80355d:	83 ec 0c             	sub    $0xc,%esp
  803560:	50                   	push   %eax
  803561:	e8 f5 f9 ff ff       	call   802f5b <to_page_info>
  803566:	83 c4 10             	add    $0x10,%esp
  803569:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80356c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80356f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803573:	48                   	dec    %eax
  803574:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803577:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80357b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357e:	e9 26 01 00 00       	jmp    8036a9 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  803583:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	c1 e0 04             	shl    $0x4,%eax
  80358c:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	85 c0                	test   %eax,%eax
  803595:	0f 84 dc 00 00 00    	je     803677 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359e:	c1 e0 04             	shl    $0x4,%eax
  8035a1:	05 60 d2 81 00       	add    $0x81d260,%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8035ab:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8035af:	75 17                	jne    8035c8 <alloc_block+0x329>
  8035b1:	83 ec 04             	sub    $0x4,%esp
  8035b4:	68 01 4d 80 00       	push   $0x804d01
  8035b9:	68 be 00 00 00       	push   $0xbe
  8035be:	68 43 4c 80 00       	push   $0x804c43
  8035c3:	e8 0d e0 ff ff       	call   8015d5 <_panic>
  8035c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	74 10                	je     8035e1 <alloc_block+0x342>
  8035d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035d9:	8b 52 04             	mov    0x4(%edx),%edx
  8035dc:	89 50 04             	mov    %edx,0x4(%eax)
  8035df:	eb 14                	jmp    8035f5 <alloc_block+0x356>
  8035e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035e4:	8b 40 04             	mov    0x4(%eax),%eax
  8035e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ea:	c1 e2 04             	shl    $0x4,%edx
  8035ed:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8035f3:	89 02                	mov    %eax,(%edx)
  8035f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035f8:	8b 40 04             	mov    0x4(%eax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	74 0f                	je     80360e <alloc_block+0x36f>
  8035ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803602:	8b 40 04             	mov    0x4(%eax),%eax
  803605:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803608:	8b 12                	mov    (%edx),%edx
  80360a:	89 10                	mov    %edx,(%eax)
  80360c:	eb 13                	jmp    803621 <alloc_block+0x382>
  80360e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803611:	8b 00                	mov    (%eax),%eax
  803613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803616:	c1 e2 04             	shl    $0x4,%edx
  803619:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80361f:	89 02                	mov    %eax,(%edx)
  803621:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80362d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	c1 e0 04             	shl    $0x4,%eax
  80363a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	8d 50 ff             	lea    -0x1(%eax),%edx
  803644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803647:	c1 e0 04             	shl    $0x4,%eax
  80364a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80364f:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803651:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803654:	83 ec 0c             	sub    $0xc,%esp
  803657:	50                   	push   %eax
  803658:	e8 fe f8 ff ff       	call   802f5b <to_page_info>
  80365d:	83 c4 10             	add    $0x10,%esp
  803660:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  803663:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803666:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80366a:	48                   	dec    %eax
  80366b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80366e:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803672:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803675:	eb 32                	jmp    8036a9 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803677:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80367b:	77 15                	ja     803692 <alloc_block+0x3f3>
  80367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803680:	c1 e0 04             	shl    $0x4,%eax
  803683:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	85 c0                	test   %eax,%eax
  80368c:	0f 84 f1 fe ff ff    	je     803583 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  803692:	83 ec 04             	sub    $0x4,%esp
  803695:	68 1f 4d 80 00       	push   $0x804d1f
  80369a:	68 c8 00 00 00       	push   $0xc8
  80369f:	68 43 4c 80 00       	push   $0x804c43
  8036a4:	e8 2c df ff ff       	call   8015d5 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8036a9:	c9                   	leave  
  8036aa:	c3                   	ret    

008036ab <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8036ab:	55                   	push   %ebp
  8036ac:	89 e5                	mov    %esp,%ebp
  8036ae:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8036b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b4:	a1 48 d2 81 00       	mov    0x81d248,%eax
  8036b9:	39 c2                	cmp    %eax,%edx
  8036bb:	72 0c                	jb     8036c9 <free_block+0x1e>
  8036bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c0:	a1 20 52 80 00       	mov    0x805220,%eax
  8036c5:	39 c2                	cmp    %eax,%edx
  8036c7:	72 19                	jb     8036e2 <free_block+0x37>
  8036c9:	68 30 4d 80 00       	push   $0x804d30
  8036ce:	68 a6 4c 80 00       	push   $0x804ca6
  8036d3:	68 d7 00 00 00       	push   $0xd7
  8036d8:	68 43 4c 80 00       	push   $0x804c43
  8036dd:	e8 f3 de ff ff       	call   8015d5 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	83 ec 0c             	sub    $0xc,%esp
  8036ee:	50                   	push   %eax
  8036ef:	e8 67 f8 ff ff       	call   802f5b <to_page_info>
  8036f4:	83 c4 10             	add    $0x10,%esp
  8036f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8036fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fd:	8b 40 08             	mov    0x8(%eax),%eax
  803700:	0f b7 c0             	movzwl %ax,%eax
  803703:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803706:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80370d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803714:	eb 19                	jmp    80372f <free_block+0x84>
	    if ((1 << i) == blk_size)
  803716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803719:	ba 01 00 00 00       	mov    $0x1,%edx
  80371e:	88 c1                	mov    %al,%cl
  803720:	d3 e2                	shl    %cl,%edx
  803722:	89 d0                	mov    %edx,%eax
  803724:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803727:	74 0e                	je     803737 <free_block+0x8c>
	        break;
	    idx++;
  803729:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80372c:	ff 45 f0             	incl   -0x10(%ebp)
  80372f:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803733:	7e e1                	jle    803716 <free_block+0x6b>
  803735:	eb 01                	jmp    803738 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  803737:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  803738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80373f:	40                   	inc    %eax
  803740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803743:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803747:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80374b:	75 17                	jne    803764 <free_block+0xb9>
  80374d:	83 ec 04             	sub    $0x4,%esp
  803750:	68 bc 4c 80 00       	push   $0x804cbc
  803755:	68 ee 00 00 00       	push   $0xee
  80375a:	68 43 4c 80 00       	push   $0x804c43
  80375f:	e8 71 de ff ff       	call   8015d5 <_panic>
  803764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803767:	c1 e0 04             	shl    $0x4,%eax
  80376a:	05 64 d2 81 00       	add    $0x81d264,%eax
  80376f:	8b 10                	mov    (%eax),%edx
  803771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803774:	89 50 04             	mov    %edx,0x4(%eax)
  803777:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377a:	8b 40 04             	mov    0x4(%eax),%eax
  80377d:	85 c0                	test   %eax,%eax
  80377f:	74 14                	je     803795 <free_block+0xea>
  803781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803784:	c1 e0 04             	shl    $0x4,%eax
  803787:	05 64 d2 81 00       	add    $0x81d264,%eax
  80378c:	8b 00                	mov    (%eax),%eax
  80378e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803791:	89 10                	mov    %edx,(%eax)
  803793:	eb 11                	jmp    8037a6 <free_block+0xfb>
  803795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803798:	c1 e0 04             	shl    $0x4,%eax
  80379b:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8037a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a4:	89 02                	mov    %eax,(%edx)
  8037a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a9:	c1 e0 04             	shl    $0x4,%eax
  8037ac:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8037b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b5:	89 02                	mov    %eax,(%edx)
  8037b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	c1 e0 04             	shl    $0x4,%eax
  8037c6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8037cb:	8b 00                	mov    (%eax),%eax
  8037cd:	8d 50 01             	lea    0x1(%eax),%edx
  8037d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d3:	c1 e0 04             	shl    $0x4,%eax
  8037d6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8037db:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8037dd:	b8 00 10 00 00       	mov    $0x1000,%eax
  8037e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8037e7:	f7 75 e0             	divl   -0x20(%ebp)
  8037ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8037ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037f4:	0f b7 c0             	movzwl %ax,%eax
  8037f7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8037fa:	0f 85 70 01 00 00    	jne    803970 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803800:	83 ec 0c             	sub    $0xc,%esp
  803803:	ff 75 e4             	pushl  -0x1c(%ebp)
  803806:	e8 de f6 ff ff       	call   802ee9 <to_page_va>
  80380b:	83 c4 10             	add    $0x10,%esp
  80380e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803811:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803818:	e9 b7 00 00 00       	jmp    8038d4 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80381d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803823:	01 d0                	add    %edx,%eax
  803825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  803828:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80382c:	75 17                	jne    803845 <free_block+0x19a>
  80382e:	83 ec 04             	sub    $0x4,%esp
  803831:	68 01 4d 80 00       	push   $0x804d01
  803836:	68 f8 00 00 00       	push   $0xf8
  80383b:	68 43 4c 80 00       	push   $0x804c43
  803840:	e8 90 dd ff ff       	call   8015d5 <_panic>
  803845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803848:	8b 00                	mov    (%eax),%eax
  80384a:	85 c0                	test   %eax,%eax
  80384c:	74 10                	je     80385e <free_block+0x1b3>
  80384e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803851:	8b 00                	mov    (%eax),%eax
  803853:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803856:	8b 52 04             	mov    0x4(%edx),%edx
  803859:	89 50 04             	mov    %edx,0x4(%eax)
  80385c:	eb 14                	jmp    803872 <free_block+0x1c7>
  80385e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803861:	8b 40 04             	mov    0x4(%eax),%eax
  803864:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803867:	c1 e2 04             	shl    $0x4,%edx
  80386a:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803870:	89 02                	mov    %eax,(%edx)
  803872:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803875:	8b 40 04             	mov    0x4(%eax),%eax
  803878:	85 c0                	test   %eax,%eax
  80387a:	74 0f                	je     80388b <free_block+0x1e0>
  80387c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387f:	8b 40 04             	mov    0x4(%eax),%eax
  803882:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803885:	8b 12                	mov    (%edx),%edx
  803887:	89 10                	mov    %edx,(%eax)
  803889:	eb 13                	jmp    80389e <free_block+0x1f3>
  80388b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80388e:	8b 00                	mov    (%eax),%eax
  803890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803893:	c1 e2 04             	shl    $0x4,%edx
  803896:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80389c:	89 02                	mov    %eax,(%edx)
  80389e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b4:	c1 e0 04             	shl    $0x4,%eax
  8038b7:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c4:	c1 e0 04             	shl    $0x4,%eax
  8038c7:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8038cc:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8038ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d1:	01 45 ec             	add    %eax,-0x14(%ebp)
  8038d4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8038db:	0f 86 3c ff ff ff    	jbe    80381d <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8038f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038f7:	75 17                	jne    803910 <free_block+0x265>
  8038f9:	83 ec 04             	sub    $0x4,%esp
  8038fc:	68 bc 4c 80 00       	push   $0x804cbc
  803901:	68 fe 00 00 00       	push   $0xfe
  803906:	68 43 4c 80 00       	push   $0x804c43
  80390b:	e8 c5 dc ff ff       	call   8015d5 <_panic>
  803910:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803919:	89 50 04             	mov    %edx,0x4(%eax)
  80391c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391f:	8b 40 04             	mov    0x4(%eax),%eax
  803922:	85 c0                	test   %eax,%eax
  803924:	74 0c                	je     803932 <free_block+0x287>
  803926:	a1 2c 52 80 00       	mov    0x80522c,%eax
  80392b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392e:	89 10                	mov    %edx,(%eax)
  803930:	eb 08                	jmp    80393a <free_block+0x28f>
  803932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803935:	a3 28 52 80 00       	mov    %eax,0x805228
  80393a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393d:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803945:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80394b:	a1 34 52 80 00       	mov    0x805234,%eax
  803950:	40                   	inc    %eax
  803951:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803956:	83 ec 0c             	sub    $0xc,%esp
  803959:	ff 75 e4             	pushl  -0x1c(%ebp)
  80395c:	e8 88 f5 ff ff       	call   802ee9 <to_page_va>
  803961:	83 c4 10             	add    $0x10,%esp
  803964:	83 ec 0c             	sub    $0xc,%esp
  803967:	50                   	push   %eax
  803968:	e8 b8 ee ff ff       	call   802825 <return_page>
  80396d:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803970:	90                   	nop
  803971:	c9                   	leave  
  803972:	c3                   	ret    

00803973 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803973:	55                   	push   %ebp
  803974:	89 e5                	mov    %esp,%ebp
  803976:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803979:	83 ec 04             	sub    $0x4,%esp
  80397c:	68 68 4d 80 00       	push   $0x804d68
  803981:	68 11 01 00 00       	push   $0x111
  803986:	68 43 4c 80 00       	push   $0x804c43
  80398b:	e8 45 dc ff ff       	call   8015d5 <_panic>

00803990 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803990:	55                   	push   %ebp
  803991:	89 e5                	mov    %esp,%ebp
  803993:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803996:	8b 55 08             	mov    0x8(%ebp),%edx
  803999:	89 d0                	mov    %edx,%eax
  80399b:	c1 e0 02             	shl    $0x2,%eax
  80399e:	01 d0                	add    %edx,%eax
  8039a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039a7:	01 d0                	add    %edx,%eax
  8039a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039b0:	01 d0                	add    %edx,%eax
  8039b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039b9:	01 d0                	add    %edx,%eax
  8039bb:	c1 e0 04             	shl    $0x4,%eax
  8039be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8039c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8039c8:	0f 31                	rdtsc  
  8039ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8039cd:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8039d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8039d9:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8039dc:	eb 46                	jmp    803a24 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8039de:	0f 31                	rdtsc  
  8039e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8039e3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8039e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8039ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8039f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f8:	29 c2                	sub    %eax,%edx
  8039fa:	89 d0                	mov    %edx,%eax
  8039fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8039ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a05:	89 d1                	mov    %edx,%ecx
  803a07:	29 c1                	sub    %eax,%ecx
  803a09:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a0f:	39 c2                	cmp    %eax,%edx
  803a11:	0f 97 c0             	seta   %al
  803a14:	0f b6 c0             	movzbl %al,%eax
  803a17:	29 c1                	sub    %eax,%ecx
  803a19:	89 c8                	mov    %ecx,%eax
  803a1b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803a1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a2a:	72 b2                	jb     8039de <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803a2c:	90                   	nop
  803a2d:	c9                   	leave  
  803a2e:	c3                   	ret    

00803a2f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803a2f:	55                   	push   %ebp
  803a30:	89 e5                	mov    %esp,%ebp
  803a32:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803a35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803a3c:	eb 03                	jmp    803a41 <busy_wait+0x12>
  803a3e:	ff 45 fc             	incl   -0x4(%ebp)
  803a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a44:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a47:	72 f5                	jb     803a3e <busy_wait+0xf>
	return i;
  803a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803a4c:	c9                   	leave  
  803a4d:	c3                   	ret    
  803a4e:	66 90                	xchg   %ax,%ax

00803a50 <__udivdi3>:
  803a50:	55                   	push   %ebp
  803a51:	57                   	push   %edi
  803a52:	56                   	push   %esi
  803a53:	53                   	push   %ebx
  803a54:	83 ec 1c             	sub    $0x1c,%esp
  803a57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a67:	89 ca                	mov    %ecx,%edx
  803a69:	89 f8                	mov    %edi,%eax
  803a6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a6f:	85 f6                	test   %esi,%esi
  803a71:	75 2d                	jne    803aa0 <__udivdi3+0x50>
  803a73:	39 cf                	cmp    %ecx,%edi
  803a75:	77 65                	ja     803adc <__udivdi3+0x8c>
  803a77:	89 fd                	mov    %edi,%ebp
  803a79:	85 ff                	test   %edi,%edi
  803a7b:	75 0b                	jne    803a88 <__udivdi3+0x38>
  803a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a82:	31 d2                	xor    %edx,%edx
  803a84:	f7 f7                	div    %edi
  803a86:	89 c5                	mov    %eax,%ebp
  803a88:	31 d2                	xor    %edx,%edx
  803a8a:	89 c8                	mov    %ecx,%eax
  803a8c:	f7 f5                	div    %ebp
  803a8e:	89 c1                	mov    %eax,%ecx
  803a90:	89 d8                	mov    %ebx,%eax
  803a92:	f7 f5                	div    %ebp
  803a94:	89 cf                	mov    %ecx,%edi
  803a96:	89 fa                	mov    %edi,%edx
  803a98:	83 c4 1c             	add    $0x1c,%esp
  803a9b:	5b                   	pop    %ebx
  803a9c:	5e                   	pop    %esi
  803a9d:	5f                   	pop    %edi
  803a9e:	5d                   	pop    %ebp
  803a9f:	c3                   	ret    
  803aa0:	39 ce                	cmp    %ecx,%esi
  803aa2:	77 28                	ja     803acc <__udivdi3+0x7c>
  803aa4:	0f bd fe             	bsr    %esi,%edi
  803aa7:	83 f7 1f             	xor    $0x1f,%edi
  803aaa:	75 40                	jne    803aec <__udivdi3+0x9c>
  803aac:	39 ce                	cmp    %ecx,%esi
  803aae:	72 0a                	jb     803aba <__udivdi3+0x6a>
  803ab0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ab4:	0f 87 9e 00 00 00    	ja     803b58 <__udivdi3+0x108>
  803aba:	b8 01 00 00 00       	mov    $0x1,%eax
  803abf:	89 fa                	mov    %edi,%edx
  803ac1:	83 c4 1c             	add    $0x1c,%esp
  803ac4:	5b                   	pop    %ebx
  803ac5:	5e                   	pop    %esi
  803ac6:	5f                   	pop    %edi
  803ac7:	5d                   	pop    %ebp
  803ac8:	c3                   	ret    
  803ac9:	8d 76 00             	lea    0x0(%esi),%esi
  803acc:	31 ff                	xor    %edi,%edi
  803ace:	31 c0                	xor    %eax,%eax
  803ad0:	89 fa                	mov    %edi,%edx
  803ad2:	83 c4 1c             	add    $0x1c,%esp
  803ad5:	5b                   	pop    %ebx
  803ad6:	5e                   	pop    %esi
  803ad7:	5f                   	pop    %edi
  803ad8:	5d                   	pop    %ebp
  803ad9:	c3                   	ret    
  803ada:	66 90                	xchg   %ax,%ax
  803adc:	89 d8                	mov    %ebx,%eax
  803ade:	f7 f7                	div    %edi
  803ae0:	31 ff                	xor    %edi,%edi
  803ae2:	89 fa                	mov    %edi,%edx
  803ae4:	83 c4 1c             	add    $0x1c,%esp
  803ae7:	5b                   	pop    %ebx
  803ae8:	5e                   	pop    %esi
  803ae9:	5f                   	pop    %edi
  803aea:	5d                   	pop    %ebp
  803aeb:	c3                   	ret    
  803aec:	bd 20 00 00 00       	mov    $0x20,%ebp
  803af1:	89 eb                	mov    %ebp,%ebx
  803af3:	29 fb                	sub    %edi,%ebx
  803af5:	89 f9                	mov    %edi,%ecx
  803af7:	d3 e6                	shl    %cl,%esi
  803af9:	89 c5                	mov    %eax,%ebp
  803afb:	88 d9                	mov    %bl,%cl
  803afd:	d3 ed                	shr    %cl,%ebp
  803aff:	89 e9                	mov    %ebp,%ecx
  803b01:	09 f1                	or     %esi,%ecx
  803b03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b07:	89 f9                	mov    %edi,%ecx
  803b09:	d3 e0                	shl    %cl,%eax
  803b0b:	89 c5                	mov    %eax,%ebp
  803b0d:	89 d6                	mov    %edx,%esi
  803b0f:	88 d9                	mov    %bl,%cl
  803b11:	d3 ee                	shr    %cl,%esi
  803b13:	89 f9                	mov    %edi,%ecx
  803b15:	d3 e2                	shl    %cl,%edx
  803b17:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b1b:	88 d9                	mov    %bl,%cl
  803b1d:	d3 e8                	shr    %cl,%eax
  803b1f:	09 c2                	or     %eax,%edx
  803b21:	89 d0                	mov    %edx,%eax
  803b23:	89 f2                	mov    %esi,%edx
  803b25:	f7 74 24 0c          	divl   0xc(%esp)
  803b29:	89 d6                	mov    %edx,%esi
  803b2b:	89 c3                	mov    %eax,%ebx
  803b2d:	f7 e5                	mul    %ebp
  803b2f:	39 d6                	cmp    %edx,%esi
  803b31:	72 19                	jb     803b4c <__udivdi3+0xfc>
  803b33:	74 0b                	je     803b40 <__udivdi3+0xf0>
  803b35:	89 d8                	mov    %ebx,%eax
  803b37:	31 ff                	xor    %edi,%edi
  803b39:	e9 58 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b3e:	66 90                	xchg   %ax,%ax
  803b40:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b44:	89 f9                	mov    %edi,%ecx
  803b46:	d3 e2                	shl    %cl,%edx
  803b48:	39 c2                	cmp    %eax,%edx
  803b4a:	73 e9                	jae    803b35 <__udivdi3+0xe5>
  803b4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b4f:	31 ff                	xor    %edi,%edi
  803b51:	e9 40 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b56:	66 90                	xchg   %ax,%ax
  803b58:	31 c0                	xor    %eax,%eax
  803b5a:	e9 37 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b5f:	90                   	nop

00803b60 <__umoddi3>:
  803b60:	55                   	push   %ebp
  803b61:	57                   	push   %edi
  803b62:	56                   	push   %esi
  803b63:	53                   	push   %ebx
  803b64:	83 ec 1c             	sub    $0x1c,%esp
  803b67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b7f:	89 f3                	mov    %esi,%ebx
  803b81:	89 fa                	mov    %edi,%edx
  803b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b87:	89 34 24             	mov    %esi,(%esp)
  803b8a:	85 c0                	test   %eax,%eax
  803b8c:	75 1a                	jne    803ba8 <__umoddi3+0x48>
  803b8e:	39 f7                	cmp    %esi,%edi
  803b90:	0f 86 a2 00 00 00    	jbe    803c38 <__umoddi3+0xd8>
  803b96:	89 c8                	mov    %ecx,%eax
  803b98:	89 f2                	mov    %esi,%edx
  803b9a:	f7 f7                	div    %edi
  803b9c:	89 d0                	mov    %edx,%eax
  803b9e:	31 d2                	xor    %edx,%edx
  803ba0:	83 c4 1c             	add    $0x1c,%esp
  803ba3:	5b                   	pop    %ebx
  803ba4:	5e                   	pop    %esi
  803ba5:	5f                   	pop    %edi
  803ba6:	5d                   	pop    %ebp
  803ba7:	c3                   	ret    
  803ba8:	39 f0                	cmp    %esi,%eax
  803baa:	0f 87 ac 00 00 00    	ja     803c5c <__umoddi3+0xfc>
  803bb0:	0f bd e8             	bsr    %eax,%ebp
  803bb3:	83 f5 1f             	xor    $0x1f,%ebp
  803bb6:	0f 84 ac 00 00 00    	je     803c68 <__umoddi3+0x108>
  803bbc:	bf 20 00 00 00       	mov    $0x20,%edi
  803bc1:	29 ef                	sub    %ebp,%edi
  803bc3:	89 fe                	mov    %edi,%esi
  803bc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bc9:	89 e9                	mov    %ebp,%ecx
  803bcb:	d3 e0                	shl    %cl,%eax
  803bcd:	89 d7                	mov    %edx,%edi
  803bcf:	89 f1                	mov    %esi,%ecx
  803bd1:	d3 ef                	shr    %cl,%edi
  803bd3:	09 c7                	or     %eax,%edi
  803bd5:	89 e9                	mov    %ebp,%ecx
  803bd7:	d3 e2                	shl    %cl,%edx
  803bd9:	89 14 24             	mov    %edx,(%esp)
  803bdc:	89 d8                	mov    %ebx,%eax
  803bde:	d3 e0                	shl    %cl,%eax
  803be0:	89 c2                	mov    %eax,%edx
  803be2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be6:	d3 e0                	shl    %cl,%eax
  803be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bec:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf0:	89 f1                	mov    %esi,%ecx
  803bf2:	d3 e8                	shr    %cl,%eax
  803bf4:	09 d0                	or     %edx,%eax
  803bf6:	d3 eb                	shr    %cl,%ebx
  803bf8:	89 da                	mov    %ebx,%edx
  803bfa:	f7 f7                	div    %edi
  803bfc:	89 d3                	mov    %edx,%ebx
  803bfe:	f7 24 24             	mull   (%esp)
  803c01:	89 c6                	mov    %eax,%esi
  803c03:	89 d1                	mov    %edx,%ecx
  803c05:	39 d3                	cmp    %edx,%ebx
  803c07:	0f 82 87 00 00 00    	jb     803c94 <__umoddi3+0x134>
  803c0d:	0f 84 91 00 00 00    	je     803ca4 <__umoddi3+0x144>
  803c13:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c17:	29 f2                	sub    %esi,%edx
  803c19:	19 cb                	sbb    %ecx,%ebx
  803c1b:	89 d8                	mov    %ebx,%eax
  803c1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c21:	d3 e0                	shl    %cl,%eax
  803c23:	89 e9                	mov    %ebp,%ecx
  803c25:	d3 ea                	shr    %cl,%edx
  803c27:	09 d0                	or     %edx,%eax
  803c29:	89 e9                	mov    %ebp,%ecx
  803c2b:	d3 eb                	shr    %cl,%ebx
  803c2d:	89 da                	mov    %ebx,%edx
  803c2f:	83 c4 1c             	add    $0x1c,%esp
  803c32:	5b                   	pop    %ebx
  803c33:	5e                   	pop    %esi
  803c34:	5f                   	pop    %edi
  803c35:	5d                   	pop    %ebp
  803c36:	c3                   	ret    
  803c37:	90                   	nop
  803c38:	89 fd                	mov    %edi,%ebp
  803c3a:	85 ff                	test   %edi,%edi
  803c3c:	75 0b                	jne    803c49 <__umoddi3+0xe9>
  803c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c43:	31 d2                	xor    %edx,%edx
  803c45:	f7 f7                	div    %edi
  803c47:	89 c5                	mov    %eax,%ebp
  803c49:	89 f0                	mov    %esi,%eax
  803c4b:	31 d2                	xor    %edx,%edx
  803c4d:	f7 f5                	div    %ebp
  803c4f:	89 c8                	mov    %ecx,%eax
  803c51:	f7 f5                	div    %ebp
  803c53:	89 d0                	mov    %edx,%eax
  803c55:	e9 44 ff ff ff       	jmp    803b9e <__umoddi3+0x3e>
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	89 c8                	mov    %ecx,%eax
  803c5e:	89 f2                	mov    %esi,%edx
  803c60:	83 c4 1c             	add    $0x1c,%esp
  803c63:	5b                   	pop    %ebx
  803c64:	5e                   	pop    %esi
  803c65:	5f                   	pop    %edi
  803c66:	5d                   	pop    %ebp
  803c67:	c3                   	ret    
  803c68:	3b 04 24             	cmp    (%esp),%eax
  803c6b:	72 06                	jb     803c73 <__umoddi3+0x113>
  803c6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c71:	77 0f                	ja     803c82 <__umoddi3+0x122>
  803c73:	89 f2                	mov    %esi,%edx
  803c75:	29 f9                	sub    %edi,%ecx
  803c77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c7b:	89 14 24             	mov    %edx,(%esp)
  803c7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c82:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c86:	8b 14 24             	mov    (%esp),%edx
  803c89:	83 c4 1c             	add    $0x1c,%esp
  803c8c:	5b                   	pop    %ebx
  803c8d:	5e                   	pop    %esi
  803c8e:	5f                   	pop    %edi
  803c8f:	5d                   	pop    %ebp
  803c90:	c3                   	ret    
  803c91:	8d 76 00             	lea    0x0(%esi),%esi
  803c94:	2b 04 24             	sub    (%esp),%eax
  803c97:	19 fa                	sbb    %edi,%edx
  803c99:	89 d1                	mov    %edx,%ecx
  803c9b:	89 c6                	mov    %eax,%esi
  803c9d:	e9 71 ff ff ff       	jmp    803c13 <__umoddi3+0xb3>
  803ca2:	66 90                	xchg   %ax,%ax
  803ca4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ca8:	72 ea                	jb     803c94 <__umoddi3+0x134>
  803caa:	89 d9                	mov    %ebx,%ecx
  803cac:	e9 62 ff ff ff       	jmp    803c13 <__umoddi3+0xb3>
