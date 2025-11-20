
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 c6 15 00 00       	call   8015fc <libmain>
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
  800067:	e8 c9 2b 00 00       	call   802c35 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 0c 2c 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 75 29 00 00       	call   802a3c <malloc>
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
  8000df:	e8 51 2b 00 00       	call   802c35 <sys_calculate_free_frames>
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
  800125:	68 e0 3d 80 00       	push   $0x803de0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 76 19 00 00       	call   801aa7 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 47 2b 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 5c 3e 80 00       	push   $0x803e5c
  800150:	6a 0c                	push   $0xc
  800152:	e8 50 19 00 00       	call   801aa7 <cprintf_colored>
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
  800174:	e8 bc 2a 00 00       	call   802c35 <sys_calculate_free_frames>
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
  8001b9:	e8 77 2a 00 00       	call   802c35 <sys_calculate_free_frames>
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
  8001f8:	68 d4 3e 80 00       	push   $0x803ed4
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 a3 18 00 00       	call   801aa7 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 74 2a 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 60 3f 80 00       	push   $0x803f60
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 76 18 00 00       	call   801aa7 <cprintf_colored>
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
  800270:	e8 82 2d 00 00       	call   802ff7 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 d8 3f 80 00       	push   $0x803fd8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 11 18 00 00       	call   801aa7 <cprintf_colored>
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
  8002ae:	e8 82 29 00 00       	call   802c35 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 c5 29 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 99 27 00 00       	call   802a6a <free>
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
  8002fc:	e8 7f 29 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 10 40 80 00       	push   $0x804010
  800318:	6a 0c                	push   $0xc
  80031a:	e8 88 17 00 00       	call   801aa7 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 0e 29 00 00       	call   802c35 <sys_calculate_free_frames>
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
  800342:	68 5c 40 80 00       	push   $0x80405c
  800347:	6a 0c                	push   $0xc
  800349:	e8 59 17 00 00       	call   801aa7 <cprintf_colored>
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
  8003a0:	e8 52 2c 00 00       	call   802ff7 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 b8 40 80 00       	push   $0x8040b8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 e1 16 00 00       	call   801aa7 <cprintf_colored>
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
  800416:	68 f0 40 80 00       	push   $0x8040f0
  80041b:	6a 03                	push   $0x3
  80041d:	e8 85 16 00 00       	call   801aa7 <cprintf_colored>
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
  8004df:	68 20 41 80 00       	push   $0x804120
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 bc 15 00 00       	call   801aa7 <cprintf_colored>
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
  8005b9:	68 20 41 80 00       	push   $0x804120
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 e2 14 00 00       	call   801aa7 <cprintf_colored>
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
  800693:	68 20 41 80 00       	push   $0x804120
  800698:	6a 0c                	push   $0xc
  80069a:	e8 08 14 00 00       	call   801aa7 <cprintf_colored>
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
  80076d:	68 20 41 80 00       	push   $0x804120
  800772:	6a 0c                	push   $0xc
  800774:	e8 2e 13 00 00       	call   801aa7 <cprintf_colored>
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
  800847:	68 20 41 80 00       	push   $0x804120
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 54 12 00 00       	call   801aa7 <cprintf_colored>
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
  800921:	68 20 41 80 00       	push   $0x804120
  800926:	6a 0c                	push   $0xc
  800928:	e8 7a 11 00 00       	call   801aa7 <cprintf_colored>
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
  800a16:	68 20 41 80 00       	push   $0x804120
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 85 10 00 00       	call   801aa7 <cprintf_colored>
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
  800b14:	68 20 41 80 00       	push   $0x804120
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 87 0f 00 00       	call   801aa7 <cprintf_colored>
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
  800c12:	68 20 41 80 00       	push   $0x804120
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 89 0e 00 00       	call   801aa7 <cprintf_colored>
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
  800d10:	68 20 41 80 00       	push   $0x804120
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 8b 0d 00 00       	call   801aa7 <cprintf_colored>
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
  800dfd:	68 20 41 80 00       	push   $0x804120
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 9e 0c 00 00       	call   801aa7 <cprintf_colored>
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
  800eea:	68 20 41 80 00       	push   $0x804120
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 b1 0b 00 00       	call   801aa7 <cprintf_colored>
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
  800fd7:	68 20 41 80 00       	push   $0x804120
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 c4 0a 00 00       	call   801aa7 <cprintf_colored>
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
  800ffa:	68 72 41 80 00       	push   $0x804172
  800fff:	6a 03                	push   $0x3
  801001:	e8 a1 0a 00 00       	call   801aa7 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 16 1c 00 00       	call   802c35 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 56 1c 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 e2 19 00 00       	call   802a3c <malloc>
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
  801084:	68 90 41 80 00       	push   $0x804190
  801089:	6a 0c                	push   $0xc
  80108b:	e8 17 0a 00 00       	call   801aa7 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 e8 1b 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 cc 41 80 00       	push   $0x8041cc
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 eb 09 00 00       	call   801aa7 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 71 1b 00 00       	call   802c35 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 3c 42 80 00       	push   $0x80423c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 bf 09 00 00       	call   801aa7 <cprintf_colored>
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
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 40             	sub    $0x40,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL BLOCK ALLOCATOR OR USER
	 * BLOCK ALLOCATOR DUE TO DIFFERENT MANAGEMENT OF USER HEAP
	 *********************************************************/
	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801107:	83 ec 08             	sub    $0x8,%esp
  80110a:	68 84 42 80 00       	push   $0x804284
  80110f:	6a 0e                	push   $0xe
  801111:	e8 91 09 00 00       	call   801aa7 <cprintf_colored>
  801116:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	68 b8 42 80 00       	push   $0x8042b8
  801121:	6a 0e                	push   $0xe
  801123:	e8 7f 09 00 00       	call   801aa7 <cprintf_colored>
  801128:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	68 14 43 80 00       	push   $0x804314
  801133:	6a 0e                	push   $0xe
  801135:	e8 6d 09 00 00       	call   801aa7 <cprintf_colored>
  80113a:	83 c4 10             	add    $0x10,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80113d:	a1 00 52 80 00       	mov    0x805200,%eax
  801142:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801148:	a1 00 52 80 00       	mov    0x805200,%eax
  80114d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801153:	39 c2                	cmp    %eax,%edx
  801155:	72 14                	jb     80116b <_main+0x6c>
			panic("Please increase the WS size");
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	68 4a 43 80 00       	push   $0x80434a
  80115f:	6a 18                	push   $0x18
  801161:	68 66 43 80 00       	push   $0x804366
  801166:	e8 41 06 00 00       	call   8017ac <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  801172:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801179:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;
	int freeFrames, usedDiskPages ;

	//x: Readonly
	freeFrames = sys_calculate_free_frames() ;
  801180:	e8 b0 1a 00 00       	call   802c35 <sys_calculate_free_frames>
  801185:	89 45 e8             	mov    %eax,-0x18(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  801188:	e8 f3 1a 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  80118d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	x = smalloc("x", 4, 0);
  801190:	83 ec 04             	sub    $0x4,%esp
  801193:	6a 00                	push   $0x0
  801195:	6a 04                	push   $0x4
  801197:	68 81 43 80 00       	push   $0x804381
  80119c:	e8 e3 18 00 00       	call   802a84 <smalloc>
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)pagealloc_start)
  8011a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011aa:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8011ad:	74 19                	je     8011c8 <_main+0xc9>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nCreate(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8011af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b6:	83 ec 08             	sub    $0x8,%esp
  8011b9:	68 84 43 80 00       	push   $0x804384
  8011be:	6a 0c                	push   $0xc
  8011c0:	e8 e2 08 00 00       	call   801aa7 <cprintf_colored>
  8011c5:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8011c8:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8011cf:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8011d2:	e8 5e 1a 00 00       	call   802c35 <sys_calculate_free_frames>
  8011d7:	29 c3                	sub    %eax,%ebx
  8011d9:	89 d8                	mov    %ebx,%eax
  8011db:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (!inRange(diff, expected, expected + 1 /*KH Block Alloc: 1 page for Share object*/ + 2 /*UH Block Alloc: max of 1 page & 1 table*/))
  8011de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011e1:	83 c0 03             	add    $0x3,%eax
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	50                   	push   %eax
  8011e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8011eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8011ee:	e8 45 ee ff ff       	call   800038 <inRange>
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	75 30                	jne    80122a <_main+0x12b>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nWrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expected +1 +2);}
  8011fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801201:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801204:	8d 58 03             	lea    0x3(%eax),%ebx
  801207:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80120a:	e8 26 1a 00 00       	call   802c35 <sys_calculate_free_frames>
  80120f:	29 c6                	sub    %eax,%esi
  801211:	89 f0                	mov    %esi,%eax
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	53                   	push   %ebx
  801217:	ff 75 dc             	pushl  -0x24(%ebp)
  80121a:	50                   	push   %eax
  80121b:	68 e8 43 80 00       	push   $0x8043e8
  801220:	6a 0c                	push   $0xc
  801222:	e8 80 08 00 00       	call   801aa7 <cprintf_colored>
  801227:	83 c4 20             	add    $0x20,%esp
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  80122a:	e8 51 1a 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  80122f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801232:	74 19                	je     80124d <_main+0x14e>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "Wrong page file allocation: ");}
  801234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	68 87 44 80 00       	push   $0x804487
  801243:	6a 0c                	push   $0xc
  801245:	e8 5d 08 00 00       	call   801aa7 <cprintf_colored>
  80124a:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80124d:	e8 e3 19 00 00       	call   802c35 <sys_calculate_free_frames>
  801252:	89 45 e8             	mov    %eax,-0x18(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  801255:	e8 26 1a 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  80125a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	y = smalloc("y", 4, 0);
  80125d:	83 ec 04             	sub    $0x4,%esp
  801260:	6a 00                	push   $0x0
  801262:	6a 04                	push   $0x4
  801264:	68 a4 44 80 00       	push   $0x8044a4
  801269:	e8 16 18 00 00       	call   802a84 <smalloc>
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE))
  801274:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801277:	05 00 10 00 00       	add    $0x1000,%eax
  80127c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80127f:	74 19                	je     80129a <_main+0x19b>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nCreate(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  801281:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801288:	83 ec 08             	sub    $0x8,%esp
  80128b:	68 84 43 80 00       	push   $0x804384
  801290:	6a 0c                	push   $0xc
  801292:	e8 10 08 00 00       	call   801aa7 <cprintf_colored>
  801297:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  80129a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8012a1:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8012a4:	e8 8c 19 00 00       	call   802c35 <sys_calculate_free_frames>
  8012a9:	29 c3                	sub    %eax,%ebx
  8012ab:	89 d8                	mov    %ebx,%eax
  8012ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	ff 75 dc             	pushl  -0x24(%ebp)
  8012b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8012b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8012bc:	e8 77 ed ff ff       	call   800038 <inRange>
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	75 26                	jne    8012ee <_main+0x1ef>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nWrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8012d2:	e8 5e 19 00 00       	call   802c35 <sys_calculate_free_frames>
  8012d7:	29 c3                	sub    %eax,%ebx
  8012d9:	89 d8                	mov    %ebx,%eax
  8012db:	ff 75 dc             	pushl  -0x24(%ebp)
  8012de:	50                   	push   %eax
  8012df:	68 a8 44 80 00       	push   $0x8044a8
  8012e4:	6a 0c                	push   $0xc
  8012e6:	e8 bc 07 00 00       	call   801aa7 <cprintf_colored>
  8012eb:	83 c4 10             	add    $0x10,%esp
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012ee:	e8 8d 19 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  8012f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8012f6:	74 19                	je     801311 <_main+0x212>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "Wrong page file allocation: ");}
  8012f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012ff:	83 ec 08             	sub    $0x8,%esp
  801302:	68 87 44 80 00       	push   $0x804487
  801307:	6a 0c                	push   $0xc
  801309:	e8 99 07 00 00       	call   801aa7 <cprintf_colored>
  80130e:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  801311:	e8 1f 19 00 00       	call   802c35 <sys_calculate_free_frames>
  801316:	89 45 e8             	mov    %eax,-0x18(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  801319:	e8 62 19 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  80131e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	z = smalloc("z", 4, 1);
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	6a 01                	push   $0x1
  801326:	6a 04                	push   $0x4
  801328:	68 41 45 80 00       	push   $0x804541
  80132d:	e8 52 17 00 00       	call   802a84 <smalloc>
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nCreate(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  801338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80133b:	05 00 20 00 00       	add    $0x2000,%eax
  801340:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801343:	74 19                	je     80135e <_main+0x25f>
  801345:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134c:	83 ec 08             	sub    $0x8,%esp
  80134f:	68 84 43 80 00       	push   $0x804384
  801354:	6a 0c                	push   $0xc
  801356:	e8 4c 07 00 00       	call   801aa7 <cprintf_colored>
  80135b:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  80135e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  801365:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  801368:	e8 c8 18 00 00       	call   802c35 <sys_calculate_free_frames>
  80136d:	29 c3                	sub    %eax,%ebx
  80136f:	89 d8                	mov    %ebx,%eax
  801371:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  801374:	83 ec 04             	sub    $0x4,%esp
  801377:	ff 75 dc             	pushl  -0x24(%ebp)
  80137a:	ff 75 dc             	pushl  -0x24(%ebp)
  80137d:	ff 75 d8             	pushl  -0x28(%ebp)
  801380:	e8 b3 ec ff ff       	call   800038 <inRange>
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	85 c0                	test   %eax,%eax
  80138a:	75 26                	jne    8013b2 <_main+0x2b3>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nWrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80138c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801393:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  801396:	e8 9a 18 00 00       	call   802c35 <sys_calculate_free_frames>
  80139b:	29 c3                	sub    %eax,%ebx
  80139d:	89 d8                	mov    %ebx,%eax
  80139f:	ff 75 dc             	pushl  -0x24(%ebp)
  8013a2:	50                   	push   %eax
  8013a3:	68 a8 44 80 00       	push   $0x8044a8
  8013a8:	6a 0c                	push   $0xc
  8013aa:	e8 f8 06 00 00       	call   801aa7 <cprintf_colored>
  8013af:	83 c4 10             	add    $0x10,%esp
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8013b2:	e8 c9 18 00 00       	call   802c80 <sys_pf_calculate_allocated_pages>
  8013b7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8013ba:	74 19                	je     8013d5 <_main+0x2d6>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "Wrong page file allocation: ");}
  8013bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	68 87 44 80 00       	push   $0x804487
  8013cb:	6a 0c                	push   $0xc
  8013cd:	e8 d5 06 00 00       	call   801aa7 <cprintf_colored>
  8013d2:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8013d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013d9:	74 04                	je     8013df <_main+0x2e0>
  8013db:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8013df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	*x = 10 ;
  8013e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8013ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013f2:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8013f8:	a1 00 52 80 00       	mov    0x805200,%eax
  8013fd:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  801403:	a1 00 52 80 00       	mov    0x805200,%eax
  801408:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80140e:	89 c1                	mov    %eax,%ecx
  801410:	a1 00 52 80 00       	mov    0x805200,%eax
  801415:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80141b:	52                   	push   %edx
  80141c:	51                   	push   %ecx
  80141d:	50                   	push   %eax
  80141e:	68 43 45 80 00       	push   $0x804543
  801423:	e8 68 19 00 00       	call   802d90 <sys_create_env>
  801428:	83 c4 10             	add    $0x10,%esp
  80142b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80142e:	a1 00 52 80 00       	mov    0x805200,%eax
  801433:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  801439:	a1 00 52 80 00       	mov    0x805200,%eax
  80143e:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  801444:	89 c1                	mov    %eax,%ecx
  801446:	a1 00 52 80 00       	mov    0x805200,%eax
  80144b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801451:	52                   	push   %edx
  801452:	51                   	push   %ecx
  801453:	50                   	push   %eax
  801454:	68 43 45 80 00       	push   $0x804543
  801459:	e8 32 19 00 00       	call   802d90 <sys_create_env>
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	89 45 c8             	mov    %eax,-0x38(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801464:	a1 00 52 80 00       	mov    0x805200,%eax
  801469:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80146f:	a1 00 52 80 00       	mov    0x805200,%eax
  801474:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80147a:	89 c1                	mov    %eax,%ecx
  80147c:	a1 00 52 80 00       	mov    0x805200,%eax
  801481:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801487:	52                   	push   %edx
  801488:	51                   	push   %ecx
  801489:	50                   	push   %eax
  80148a:	68 43 45 80 00       	push   $0x804543
  80148f:	e8 fc 18 00 00       	call   802d90 <sys_create_env>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  80149a:	e8 3d 1a 00 00       	call   802edc <rsttst>

	sys_run_env(id1);
  80149f:	83 ec 0c             	sub    $0xc,%esp
  8014a2:	ff 75 cc             	pushl  -0x34(%ebp)
  8014a5:	e8 04 19 00 00       	call   802dae <sys_run_env>
  8014aa:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	ff 75 c8             	pushl  -0x38(%ebp)
  8014b3:	e8 f6 18 00 00       	call   802dae <sys_run_env>
  8014b8:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8014bb:	83 ec 0c             	sub    $0xc,%esp
  8014be:	ff 75 c4             	pushl  -0x3c(%ebp)
  8014c1:	e8 e8 18 00 00       	call   802dae <sys_run_env>
  8014c6:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8014c9:	90                   	nop
  8014ca:	e8 87 1a 00 00       	call   802f56 <gettst>
  8014cf:	83 f8 03             	cmp    $0x3,%eax
  8014d2:	75 f6                	jne    8014ca <_main+0x3cb>


	if (*z != 30)
  8014d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014d7:	8b 00                	mov    (%eax),%eax
  8014d9:	83 f8 1e             	cmp    $0x1e,%eax
  8014dc:	74 19                	je     8014f7 <_main+0x3f8>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nError!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  8014de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	68 50 45 80 00       	push   $0x804550
  8014ed:	6a 0c                	push   $0xc
  8014ef:	e8 b3 05 00 00       	call   801aa7 <cprintf_colored>
  8014f4:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8014f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014fb:	74 04                	je     801501 <_main+0x402>
  8014fd:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  801501:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	atomic_cprintf("\n%@Now, attempting to write a ReadOnly variable\n\n\n");
  801508:	83 ec 0c             	sub    $0xc,%esp
  80150b:	68 a0 45 80 00       	push   $0x8045a0
  801510:	e8 d7 05 00 00       	call   801aec <atomic_cprintf>
  801515:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  801518:	a1 00 52 80 00       	mov    0x805200,%eax
  80151d:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  801523:	a1 00 52 80 00       	mov    0x805200,%eax
  801528:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80152e:	89 c1                	mov    %eax,%ecx
  801530:	a1 00 52 80 00       	mov    0x805200,%eax
  801535:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80153b:	52                   	push   %edx
  80153c:	51                   	push   %ecx
  80153d:	50                   	push   %eax
  80153e:	68 d3 45 80 00       	push   $0x8045d3
  801543:	e8 48 18 00 00       	call   802d90 <sys_create_env>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	89 45 cc             	mov    %eax,-0x34(%ebp)

	sys_run_env(id1);
  80154e:	83 ec 0c             	sub    $0xc,%esp
  801551:	ff 75 cc             	pushl  -0x34(%ebp)
  801554:	e8 55 18 00 00       	call   802dae <sys_run_env>
  801559:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  80155c:	90                   	nop
  80155d:	e8 f4 19 00 00       	call   802f56 <gettst>
  801562:	83 f8 04             	cmp    $0x4,%eax
  801565:	75 f6                	jne    80155d <_main+0x45e>

	if (*z != 50)
  801567:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80156a:	8b 00                	mov    (%eax),%eax
  80156c:	83 f8 32             	cmp    $0x32,%eax
  80156f:	74 19                	je     80158a <_main+0x48b>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nError!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  801571:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	68 50 45 80 00       	push   $0x804550
  801580:	6a 0c                	push   $0xc
  801582:	e8 20 05 00 00       	call   801aa7 <cprintf_colored>
  801587:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  80158a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80158e:	74 04                	je     801594 <_main+0x495>
  801590:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  801594:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Signal slave2
	inctst();
  80159b:	e8 9c 19 00 00       	call   802f3c <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8015a0:	90                   	nop
  8015a1:	e8 b0 19 00 00       	call   802f56 <gettst>
  8015a6:	83 f8 06             	cmp    $0x6,%eax
  8015a9:	75 f6                	jne    8015a1 <_main+0x4a2>

	if (*x != 10)
  8015ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	83 f8 0a             	cmp    $0xa,%eax
  8015b3:	74 19                	je     8015ce <_main+0x4cf>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nError!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  8015b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	68 50 45 80 00       	push   $0x804550
  8015c4:	6a 0c                	push   $0xc
  8015c6:	e8 dc 04 00 00       	call   801aa7 <cprintf_colored>
  8015cb:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8015ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d2:	74 04                	je     8015d8 <_main+0x4d9>
  8015d4:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8015d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_light_green, "\n\n%~Test of Shared Variables [Create & Get] completed. Eval = %d%%\n\n", eval);
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e5:	68 e0 45 80 00       	push   $0x8045e0
  8015ea:	6a 0a                	push   $0xa
  8015ec:	e8 b6 04 00 00       	call   801aa7 <cprintf_colored>
  8015f1:	83 c4 10             	add    $0x10,%esp
	return;
  8015f4:	90                   	nop
}
  8015f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f8:	5b                   	pop    %ebx
  8015f9:	5e                   	pop    %esi
  8015fa:	5d                   	pop    %ebp
  8015fb:	c3                   	ret    

008015fc <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	57                   	push   %edi
  801600:	56                   	push   %esi
  801601:	53                   	push   %ebx
  801602:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801605:	e8 f4 17 00 00       	call   802dfe <sys_getenvindex>
  80160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80160d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801610:	89 d0                	mov    %edx,%eax
  801612:	c1 e0 02             	shl    $0x2,%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	c1 e0 03             	shl    $0x3,%eax
  80161a:	01 d0                	add    %edx,%eax
  80161c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  801623:	01 d0                	add    %edx,%eax
  801625:	c1 e0 02             	shl    $0x2,%eax
  801628:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80162d:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801632:	a1 00 52 80 00       	mov    0x805200,%eax
  801637:	8a 40 20             	mov    0x20(%eax),%al
  80163a:	84 c0                	test   %al,%al
  80163c:	74 0d                	je     80164b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80163e:	a1 00 52 80 00       	mov    0x805200,%eax
  801643:	83 c0 20             	add    $0x20,%eax
  801646:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80164b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80164f:	7e 0a                	jle    80165b <libmain+0x5f>
		binaryname = argv[0];
  801651:	8b 45 0c             	mov    0xc(%ebp),%eax
  801654:	8b 00                	mov    (%eax),%eax
  801656:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80165b:	83 ec 08             	sub    $0x8,%esp
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	e8 96 fa ff ff       	call   8010ff <_main>
  801669:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80166c:	a1 00 50 80 00       	mov    0x805000,%eax
  801671:	85 c0                	test   %eax,%eax
  801673:	0f 84 01 01 00 00    	je     80177a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801679:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80167f:	bb 20 47 80 00       	mov    $0x804720,%ebx
  801684:	ba 0e 00 00 00       	mov    $0xe,%edx
  801689:	89 c7                	mov    %eax,%edi
  80168b:	89 de                	mov    %ebx,%esi
  80168d:	89 d1                	mov    %edx,%ecx
  80168f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801691:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801694:	b9 56 00 00 00       	mov    $0x56,%ecx
  801699:	b0 00                	mov    $0x0,%al
  80169b:	89 d7                	mov    %edx,%edi
  80169d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80169f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8016a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	50                   	push   %eax
  8016ad:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8016b3:	50                   	push   %eax
  8016b4:	e8 7b 19 00 00       	call   803034 <sys_utilities>
  8016b9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8016bc:	e8 c4 14 00 00       	call   802b85 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8016c1:	83 ec 0c             	sub    $0xc,%esp
  8016c4:	68 40 46 80 00       	push   $0x804640
  8016c9:	e8 ac 03 00 00       	call   801a7a <cprintf>
  8016ce:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8016d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	74 18                	je     8016f0 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8016d8:	e8 75 19 00 00       	call   803052 <sys_get_optimal_num_faults>
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	50                   	push   %eax
  8016e1:	68 68 46 80 00       	push   $0x804668
  8016e6:	e8 8f 03 00 00       	call   801a7a <cprintf>
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	eb 59                	jmp    801749 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8016f0:	a1 00 52 80 00       	mov    0x805200,%eax
  8016f5:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8016fb:	a1 00 52 80 00       	mov    0x805200,%eax
  801700:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	68 8c 46 80 00       	push   $0x80468c
  801710:	e8 65 03 00 00       	call   801a7a <cprintf>
  801715:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801718:	a1 00 52 80 00       	mov    0x805200,%eax
  80171d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801723:	a1 00 52 80 00       	mov    0x805200,%eax
  801728:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80172e:	a1 00 52 80 00       	mov    0x805200,%eax
  801733:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801739:	51                   	push   %ecx
  80173a:	52                   	push   %edx
  80173b:	50                   	push   %eax
  80173c:	68 b4 46 80 00       	push   $0x8046b4
  801741:	e8 34 03 00 00       	call   801a7a <cprintf>
  801746:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801749:	a1 00 52 80 00       	mov    0x805200,%eax
  80174e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	50                   	push   %eax
  801758:	68 0c 47 80 00       	push   $0x80470c
  80175d:	e8 18 03 00 00       	call   801a7a <cprintf>
  801762:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801765:	83 ec 0c             	sub    $0xc,%esp
  801768:	68 40 46 80 00       	push   $0x804640
  80176d:	e8 08 03 00 00       	call   801a7a <cprintf>
  801772:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801775:	e8 25 14 00 00       	call   802b9f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80177a:	e8 1f 00 00 00       	call   80179e <exit>
}
  80177f:	90                   	nop
  801780:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80178e:	83 ec 0c             	sub    $0xc,%esp
  801791:	6a 00                	push   $0x0
  801793:	e8 32 16 00 00       	call   802dca <sys_destroy_env>
  801798:	83 c4 10             	add    $0x10,%esp
}
  80179b:	90                   	nop
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <exit>:

void
exit(void)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8017a4:	e8 87 16 00 00       	call   802e30 <sys_exit_env>
}
  8017a9:	90                   	nop
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8017b5:	83 c0 04             	add    $0x4,%eax
  8017b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017bb:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	74 16                	je     8017da <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017c4:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	50                   	push   %eax
  8017cd:	68 84 47 80 00       	push   $0x804784
  8017d2:	e8 a3 02 00 00       	call   801a7a <cprintf>
  8017d7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017da:	a1 04 50 80 00       	mov    0x805004,%eax
  8017df:	83 ec 0c             	sub    $0xc,%esp
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	50                   	push   %eax
  8017e9:	68 8c 47 80 00       	push   $0x80478c
  8017ee:	6a 74                	push   $0x74
  8017f0:	e8 b2 02 00 00       	call   801aa7 <cprintf_colored>
  8017f5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801801:	50                   	push   %eax
  801802:	e8 04 02 00 00       	call   801a0b <vcprintf>
  801807:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	6a 00                	push   $0x0
  80180f:	68 b4 47 80 00       	push   $0x8047b4
  801814:	e8 f2 01 00 00       	call   801a0b <vcprintf>
  801819:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80181c:	e8 7d ff ff ff       	call   80179e <exit>

	// should not return here
	while (1) ;
  801821:	eb fe                	jmp    801821 <_panic+0x75>

00801823 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801829:	a1 00 52 80 00       	mov    0x805200,%eax
  80182e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	39 c2                	cmp    %eax,%edx
  801839:	74 14                	je     80184f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	68 b8 47 80 00       	push   $0x8047b8
  801843:	6a 26                	push   $0x26
  801845:	68 04 48 80 00       	push   $0x804804
  80184a:	e8 5d ff ff ff       	call   8017ac <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80184f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801856:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80185d:	e9 c5 00 00 00       	jmp    801927 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801865:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	01 d0                	add    %edx,%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	85 c0                	test   %eax,%eax
  801875:	75 08                	jne    80187f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801877:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80187a:	e9 a5 00 00 00       	jmp    801924 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80187f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801886:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80188d:	eb 69                	jmp    8018f8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80188f:	a1 00 52 80 00       	mov    0x805200,%eax
  801894:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80189a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80189d:	89 d0                	mov    %edx,%eax
  80189f:	01 c0                	add    %eax,%eax
  8018a1:	01 d0                	add    %edx,%eax
  8018a3:	c1 e0 03             	shl    $0x3,%eax
  8018a6:	01 c8                	add    %ecx,%eax
  8018a8:	8a 40 04             	mov    0x4(%eax),%al
  8018ab:	84 c0                	test   %al,%al
  8018ad:	75 46                	jne    8018f5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018af:	a1 00 52 80 00       	mov    0x805200,%eax
  8018b4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8018ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018bd:	89 d0                	mov    %edx,%eax
  8018bf:	01 c0                	add    %eax,%eax
  8018c1:	01 d0                	add    %edx,%eax
  8018c3:	c1 e0 03             	shl    $0x3,%eax
  8018c6:	01 c8                	add    %ecx,%eax
  8018c8:	8b 00                	mov    (%eax),%eax
  8018ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018d5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018da:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	01 c8                	add    %ecx,%eax
  8018e6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018e8:	39 c2                	cmp    %eax,%edx
  8018ea:	75 09                	jne    8018f5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018ec:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018f3:	eb 15                	jmp    80190a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018f5:	ff 45 e8             	incl   -0x18(%ebp)
  8018f8:	a1 00 52 80 00       	mov    0x805200,%eax
  8018fd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801906:	39 c2                	cmp    %eax,%edx
  801908:	77 85                	ja     80188f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80190a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80190e:	75 14                	jne    801924 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	68 10 48 80 00       	push   $0x804810
  801918:	6a 3a                	push   $0x3a
  80191a:	68 04 48 80 00       	push   $0x804804
  80191f:	e8 88 fe ff ff       	call   8017ac <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801924:	ff 45 f0             	incl   -0x10(%ebp)
  801927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80192d:	0f 8c 2f ff ff ff    	jl     801862 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801933:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80193a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801941:	eb 26                	jmp    801969 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801943:	a1 00 52 80 00       	mov    0x805200,%eax
  801948:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80194e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801951:	89 d0                	mov    %edx,%eax
  801953:	01 c0                	add    %eax,%eax
  801955:	01 d0                	add    %edx,%eax
  801957:	c1 e0 03             	shl    $0x3,%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 40 04             	mov    0x4(%eax),%al
  80195f:	3c 01                	cmp    $0x1,%al
  801961:	75 03                	jne    801966 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801963:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801966:	ff 45 e0             	incl   -0x20(%ebp)
  801969:	a1 00 52 80 00       	mov    0x805200,%eax
  80196e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801974:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801977:	39 c2                	cmp    %eax,%edx
  801979:	77 c8                	ja     801943 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801981:	74 14                	je     801997 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	68 64 48 80 00       	push   $0x804864
  80198b:	6a 44                	push   $0x44
  80198d:	68 04 48 80 00       	push   $0x804804
  801992:	e8 15 fe ff ff       	call   8017ac <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	8b 00                	mov    (%eax),%eax
  8019a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8019a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ac:	89 0a                	mov    %ecx,(%edx)
  8019ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b1:	88 d1                	mov    %dl,%cl
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bd:	8b 00                	mov    (%eax),%eax
  8019bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8019c4:	75 30                	jne    8019f6 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8019c6:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  8019cc:	a0 24 52 80 00       	mov    0x805224,%al
  8019d1:	0f b6 c0             	movzbl %al,%eax
  8019d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019d7:	8b 09                	mov    (%ecx),%ecx
  8019d9:	89 cb                	mov    %ecx,%ebx
  8019db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019de:	83 c1 08             	add    $0x8,%ecx
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	53                   	push   %ebx
  8019e4:	51                   	push   %ecx
  8019e5:	e8 57 11 00 00       	call   802b41 <sys_cputs>
  8019ea:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8019ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f9:	8b 40 04             	mov    0x4(%eax),%eax
  8019fc:	8d 50 01             	lea    0x1(%eax),%edx
  8019ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a02:	89 50 04             	mov    %edx,0x4(%eax)
}
  801a05:	90                   	nop
  801a06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801a14:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a1b:	00 00 00 
	b.cnt = 0;
  801a1e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801a25:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	ff 75 08             	pushl  0x8(%ebp)
  801a2e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a34:	50                   	push   %eax
  801a35:	68 9a 19 80 00       	push   $0x80199a
  801a3a:	e8 5a 02 00 00       	call   801c99 <vprintfmt>
  801a3f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801a42:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801a48:	a0 24 52 80 00       	mov    0x805224,%al
  801a4d:	0f b6 c0             	movzbl %al,%eax
  801a50:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	51                   	push   %ecx
  801a59:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a5f:	83 c0 08             	add    $0x8,%eax
  801a62:	50                   	push   %eax
  801a63:	e8 d9 10 00 00       	call   802b41 <sys_cputs>
  801a68:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801a6b:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  801a72:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801a80:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  801a87:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	83 ec 08             	sub    $0x8,%esp
  801a93:	ff 75 f4             	pushl  -0xc(%ebp)
  801a96:	50                   	push   %eax
  801a97:	e8 6f ff ff ff       	call   801a0b <vcprintf>
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801aad:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	c1 e0 08             	shl    $0x8,%eax
  801aba:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  801abf:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ac2:	83 c0 04             	add    $0x4,%eax
  801ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acb:	83 ec 08             	sub    $0x8,%esp
  801ace:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad1:	50                   	push   %eax
  801ad2:	e8 34 ff ff ff       	call   801a0b <vcprintf>
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801add:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  801ae4:	07 00 00 

	return cnt;
  801ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801af2:	e8 8e 10 00 00       	call   802b85 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801af7:	8d 45 0c             	lea    0xc(%ebp),%eax
  801afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	ff 75 f4             	pushl  -0xc(%ebp)
  801b06:	50                   	push   %eax
  801b07:	e8 ff fe ff ff       	call   801a0b <vcprintf>
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801b12:	e8 88 10 00 00       	call   802b9f <sys_unlock_cons>
	return cnt;
  801b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	53                   	push   %ebx
  801b20:	83 ec 14             	sub    $0x14,%esp
  801b23:	8b 45 10             	mov    0x10(%ebp),%eax
  801b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b29:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801b2f:	8b 45 18             	mov    0x18(%ebp),%eax
  801b32:	ba 00 00 00 00       	mov    $0x0,%edx
  801b37:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b3a:	77 55                	ja     801b91 <printnum+0x75>
  801b3c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b3f:	72 05                	jb     801b46 <printnum+0x2a>
  801b41:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b44:	77 4b                	ja     801b91 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801b46:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801b49:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801b4c:	8b 45 18             	mov    0x18(%ebp),%eax
  801b4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b54:	52                   	push   %edx
  801b55:	50                   	push   %eax
  801b56:	ff 75 f4             	pushl  -0xc(%ebp)
  801b59:	ff 75 f0             	pushl  -0x10(%ebp)
  801b5c:	e8 07 20 00 00       	call   803b68 <__udivdi3>
  801b61:	83 c4 10             	add    $0x10,%esp
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	ff 75 20             	pushl  0x20(%ebp)
  801b6a:	53                   	push   %ebx
  801b6b:	ff 75 18             	pushl  0x18(%ebp)
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	e8 a1 ff ff ff       	call   801b1c <printnum>
  801b7b:	83 c4 20             	add    $0x20,%esp
  801b7e:	eb 1a                	jmp    801b9a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801b80:	83 ec 08             	sub    $0x8,%esp
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	ff 75 20             	pushl  0x20(%ebp)
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	ff d0                	call   *%eax
  801b8e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801b91:	ff 4d 1c             	decl   0x1c(%ebp)
  801b94:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801b98:	7f e6                	jg     801b80 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b9a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba8:	53                   	push   %ebx
  801ba9:	51                   	push   %ecx
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	e8 c7 20 00 00       	call   803c78 <__umoddi3>
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	05 d4 4a 80 00       	add    $0x804ad4,%eax
  801bb9:	8a 00                	mov    (%eax),%al
  801bbb:	0f be c0             	movsbl %al,%eax
  801bbe:	83 ec 08             	sub    $0x8,%esp
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	50                   	push   %eax
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	ff d0                	call   *%eax
  801bca:	83 c4 10             	add    $0x10,%esp
}
  801bcd:	90                   	nop
  801bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801bd6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bda:	7e 1c                	jle    801bf8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	8b 00                	mov    (%eax),%eax
  801be1:	8d 50 08             	lea    0x8(%eax),%edx
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	89 10                	mov    %edx,(%eax)
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	8b 00                	mov    (%eax),%eax
  801bee:	83 e8 08             	sub    $0x8,%eax
  801bf1:	8b 50 04             	mov    0x4(%eax),%edx
  801bf4:	8b 00                	mov    (%eax),%eax
  801bf6:	eb 40                	jmp    801c38 <getuint+0x65>
	else if (lflag)
  801bf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bfc:	74 1e                	je     801c1c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	8b 00                	mov    (%eax),%eax
  801c03:	8d 50 04             	lea    0x4(%eax),%edx
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	89 10                	mov    %edx,(%eax)
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	8b 00                	mov    (%eax),%eax
  801c10:	83 e8 04             	sub    $0x4,%eax
  801c13:	8b 00                	mov    (%eax),%eax
  801c15:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1a:	eb 1c                	jmp    801c38 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	8b 00                	mov    (%eax),%eax
  801c21:	8d 50 04             	lea    0x4(%eax),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	89 10                	mov    %edx,(%eax)
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8b 00                	mov    (%eax),%eax
  801c2e:	83 e8 04             	sub    $0x4,%eax
  801c31:	8b 00                	mov    (%eax),%eax
  801c33:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    

00801c3a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c3d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c41:	7e 1c                	jle    801c5f <getint+0x25>
		return va_arg(*ap, long long);
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8b 00                	mov    (%eax),%eax
  801c48:	8d 50 08             	lea    0x8(%eax),%edx
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	89 10                	mov    %edx,(%eax)
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	8b 00                	mov    (%eax),%eax
  801c55:	83 e8 08             	sub    $0x8,%eax
  801c58:	8b 50 04             	mov    0x4(%eax),%edx
  801c5b:	8b 00                	mov    (%eax),%eax
  801c5d:	eb 38                	jmp    801c97 <getint+0x5d>
	else if (lflag)
  801c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c63:	74 1a                	je     801c7f <getint+0x45>
		return va_arg(*ap, long);
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	8b 00                	mov    (%eax),%eax
  801c6a:	8d 50 04             	lea    0x4(%eax),%edx
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	89 10                	mov    %edx,(%eax)
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8b 00                	mov    (%eax),%eax
  801c77:	83 e8 04             	sub    $0x4,%eax
  801c7a:	8b 00                	mov    (%eax),%eax
  801c7c:	99                   	cltd   
  801c7d:	eb 18                	jmp    801c97 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	8b 00                	mov    (%eax),%eax
  801c84:	8d 50 04             	lea    0x4(%eax),%edx
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	89 10                	mov    %edx,(%eax)
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	8b 00                	mov    (%eax),%eax
  801c91:	83 e8 04             	sub    $0x4,%eax
  801c94:	8b 00                	mov    (%eax),%eax
  801c96:	99                   	cltd   
}
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    

00801c99 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	56                   	push   %esi
  801c9d:	53                   	push   %ebx
  801c9e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ca1:	eb 17                	jmp    801cba <vprintfmt+0x21>
			if (ch == '\0')
  801ca3:	85 db                	test   %ebx,%ebx
  801ca5:	0f 84 c1 03 00 00    	je     80206c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801cab:	83 ec 08             	sub    $0x8,%esp
  801cae:	ff 75 0c             	pushl  0xc(%ebp)
  801cb1:	53                   	push   %ebx
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	ff d0                	call   *%eax
  801cb7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801cba:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbd:	8d 50 01             	lea    0x1(%eax),%edx
  801cc0:	89 55 10             	mov    %edx,0x10(%ebp)
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	0f b6 d8             	movzbl %al,%ebx
  801cc8:	83 fb 25             	cmp    $0x25,%ebx
  801ccb:	75 d6                	jne    801ca3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801ccd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801cd1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801cd8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801cdf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ce6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ced:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf0:	8d 50 01             	lea    0x1(%eax),%edx
  801cf3:	89 55 10             	mov    %edx,0x10(%ebp)
  801cf6:	8a 00                	mov    (%eax),%al
  801cf8:	0f b6 d8             	movzbl %al,%ebx
  801cfb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801cfe:	83 f8 5b             	cmp    $0x5b,%eax
  801d01:	0f 87 3d 03 00 00    	ja     802044 <vprintfmt+0x3ab>
  801d07:	8b 04 85 f8 4a 80 00 	mov    0x804af8(,%eax,4),%eax
  801d0e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801d10:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801d14:	eb d7                	jmp    801ced <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801d16:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801d1a:	eb d1                	jmp    801ced <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d1c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801d23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d26:	89 d0                	mov    %edx,%eax
  801d28:	c1 e0 02             	shl    $0x2,%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	01 c0                	add    %eax,%eax
  801d2f:	01 d8                	add    %ebx,%eax
  801d31:	83 e8 30             	sub    $0x30,%eax
  801d34:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801d37:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3a:	8a 00                	mov    (%eax),%al
  801d3c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801d3f:	83 fb 2f             	cmp    $0x2f,%ebx
  801d42:	7e 3e                	jle    801d82 <vprintfmt+0xe9>
  801d44:	83 fb 39             	cmp    $0x39,%ebx
  801d47:	7f 39                	jg     801d82 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d49:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801d4c:	eb d5                	jmp    801d23 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d51:	83 c0 04             	add    $0x4,%eax
  801d54:	89 45 14             	mov    %eax,0x14(%ebp)
  801d57:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5a:	83 e8 04             	sub    $0x4,%eax
  801d5d:	8b 00                	mov    (%eax),%eax
  801d5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801d62:	eb 1f                	jmp    801d83 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801d64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d68:	79 83                	jns    801ced <vprintfmt+0x54>
				width = 0;
  801d6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801d71:	e9 77 ff ff ff       	jmp    801ced <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801d76:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801d7d:	e9 6b ff ff ff       	jmp    801ced <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801d82:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801d83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d87:	0f 89 60 ff ff ff    	jns    801ced <vprintfmt+0x54>
				width = precision, precision = -1;
  801d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d93:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d9a:	e9 4e ff ff ff       	jmp    801ced <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d9f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801da2:	e9 46 ff ff ff       	jmp    801ced <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801da7:	8b 45 14             	mov    0x14(%ebp),%eax
  801daa:	83 c0 04             	add    $0x4,%eax
  801dad:	89 45 14             	mov    %eax,0x14(%ebp)
  801db0:	8b 45 14             	mov    0x14(%ebp),%eax
  801db3:	83 e8 04             	sub    $0x4,%eax
  801db6:	8b 00                	mov    (%eax),%eax
  801db8:	83 ec 08             	sub    $0x8,%esp
  801dbb:	ff 75 0c             	pushl  0xc(%ebp)
  801dbe:	50                   	push   %eax
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	ff d0                	call   *%eax
  801dc4:	83 c4 10             	add    $0x10,%esp
			break;
  801dc7:	e9 9b 02 00 00       	jmp    802067 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801dcc:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcf:	83 c0 04             	add    $0x4,%eax
  801dd2:	89 45 14             	mov    %eax,0x14(%ebp)
  801dd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd8:	83 e8 04             	sub    $0x4,%eax
  801ddb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801ddd:	85 db                	test   %ebx,%ebx
  801ddf:	79 02                	jns    801de3 <vprintfmt+0x14a>
				err = -err;
  801de1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801de3:	83 fb 64             	cmp    $0x64,%ebx
  801de6:	7f 0b                	jg     801df3 <vprintfmt+0x15a>
  801de8:	8b 34 9d 40 49 80 00 	mov    0x804940(,%ebx,4),%esi
  801def:	85 f6                	test   %esi,%esi
  801df1:	75 19                	jne    801e0c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801df3:	53                   	push   %ebx
  801df4:	68 e5 4a 80 00       	push   $0x804ae5
  801df9:	ff 75 0c             	pushl  0xc(%ebp)
  801dfc:	ff 75 08             	pushl  0x8(%ebp)
  801dff:	e8 70 02 00 00       	call   802074 <printfmt>
  801e04:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801e07:	e9 5b 02 00 00       	jmp    802067 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801e0c:	56                   	push   %esi
  801e0d:	68 ee 4a 80 00       	push   $0x804aee
  801e12:	ff 75 0c             	pushl  0xc(%ebp)
  801e15:	ff 75 08             	pushl  0x8(%ebp)
  801e18:	e8 57 02 00 00       	call   802074 <printfmt>
  801e1d:	83 c4 10             	add    $0x10,%esp
			break;
  801e20:	e9 42 02 00 00       	jmp    802067 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801e25:	8b 45 14             	mov    0x14(%ebp),%eax
  801e28:	83 c0 04             	add    $0x4,%eax
  801e2b:	89 45 14             	mov    %eax,0x14(%ebp)
  801e2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e31:	83 e8 04             	sub    $0x4,%eax
  801e34:	8b 30                	mov    (%eax),%esi
  801e36:	85 f6                	test   %esi,%esi
  801e38:	75 05                	jne    801e3f <vprintfmt+0x1a6>
				p = "(null)";
  801e3a:	be f1 4a 80 00       	mov    $0x804af1,%esi
			if (width > 0 && padc != '-')
  801e3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e43:	7e 6d                	jle    801eb2 <vprintfmt+0x219>
  801e45:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801e49:	74 67                	je     801eb2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4e:	83 ec 08             	sub    $0x8,%esp
  801e51:	50                   	push   %eax
  801e52:	56                   	push   %esi
  801e53:	e8 1e 03 00 00       	call   802176 <strnlen>
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801e5e:	eb 16                	jmp    801e76 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801e60:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801e64:	83 ec 08             	sub    $0x8,%esp
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	50                   	push   %eax
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	ff d0                	call   *%eax
  801e70:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801e73:	ff 4d e4             	decl   -0x1c(%ebp)
  801e76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e7a:	7f e4                	jg     801e60 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e7c:	eb 34                	jmp    801eb2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801e7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e82:	74 1c                	je     801ea0 <vprintfmt+0x207>
  801e84:	83 fb 1f             	cmp    $0x1f,%ebx
  801e87:	7e 05                	jle    801e8e <vprintfmt+0x1f5>
  801e89:	83 fb 7e             	cmp    $0x7e,%ebx
  801e8c:	7e 12                	jle    801ea0 <vprintfmt+0x207>
					putch('?', putdat);
  801e8e:	83 ec 08             	sub    $0x8,%esp
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	6a 3f                	push   $0x3f
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	ff d0                	call   *%eax
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	eb 0f                	jmp    801eaf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801ea0:	83 ec 08             	sub    $0x8,%esp
  801ea3:	ff 75 0c             	pushl  0xc(%ebp)
  801ea6:	53                   	push   %ebx
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	ff d0                	call   *%eax
  801eac:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801eaf:	ff 4d e4             	decl   -0x1c(%ebp)
  801eb2:	89 f0                	mov    %esi,%eax
  801eb4:	8d 70 01             	lea    0x1(%eax),%esi
  801eb7:	8a 00                	mov    (%eax),%al
  801eb9:	0f be d8             	movsbl %al,%ebx
  801ebc:	85 db                	test   %ebx,%ebx
  801ebe:	74 24                	je     801ee4 <vprintfmt+0x24b>
  801ec0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ec4:	78 b8                	js     801e7e <vprintfmt+0x1e5>
  801ec6:	ff 4d e0             	decl   -0x20(%ebp)
  801ec9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ecd:	79 af                	jns    801e7e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ecf:	eb 13                	jmp    801ee4 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ed1:	83 ec 08             	sub    $0x8,%esp
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	6a 20                	push   $0x20
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	ff d0                	call   *%eax
  801ede:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ee1:	ff 4d e4             	decl   -0x1c(%ebp)
  801ee4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ee8:	7f e7                	jg     801ed1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801eea:	e9 78 01 00 00       	jmp    802067 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801eef:	83 ec 08             	sub    $0x8,%esp
  801ef2:	ff 75 e8             	pushl  -0x18(%ebp)
  801ef5:	8d 45 14             	lea    0x14(%ebp),%eax
  801ef8:	50                   	push   %eax
  801ef9:	e8 3c fd ff ff       	call   801c3a <getint>
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0d:	85 d2                	test   %edx,%edx
  801f0f:	79 23                	jns    801f34 <vprintfmt+0x29b>
				putch('-', putdat);
  801f11:	83 ec 08             	sub    $0x8,%esp
  801f14:	ff 75 0c             	pushl  0xc(%ebp)
  801f17:	6a 2d                	push   $0x2d
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	ff d0                	call   *%eax
  801f1e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f27:	f7 d8                	neg    %eax
  801f29:	83 d2 00             	adc    $0x0,%edx
  801f2c:	f7 da                	neg    %edx
  801f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801f34:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f3b:	e9 bc 00 00 00       	jmp    801ffc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801f40:	83 ec 08             	sub    $0x8,%esp
  801f43:	ff 75 e8             	pushl  -0x18(%ebp)
  801f46:	8d 45 14             	lea    0x14(%ebp),%eax
  801f49:	50                   	push   %eax
  801f4a:	e8 84 fc ff ff       	call   801bd3 <getuint>
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801f58:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f5f:	e9 98 00 00 00       	jmp    801ffc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801f64:	83 ec 08             	sub    $0x8,%esp
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	6a 58                	push   $0x58
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	ff d0                	call   *%eax
  801f71:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f74:	83 ec 08             	sub    $0x8,%esp
  801f77:	ff 75 0c             	pushl  0xc(%ebp)
  801f7a:	6a 58                	push   $0x58
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	ff d0                	call   *%eax
  801f81:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f84:	83 ec 08             	sub    $0x8,%esp
  801f87:	ff 75 0c             	pushl  0xc(%ebp)
  801f8a:	6a 58                	push   $0x58
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	ff d0                	call   *%eax
  801f91:	83 c4 10             	add    $0x10,%esp
			break;
  801f94:	e9 ce 00 00 00       	jmp    802067 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801f99:	83 ec 08             	sub    $0x8,%esp
  801f9c:	ff 75 0c             	pushl  0xc(%ebp)
  801f9f:	6a 30                	push   $0x30
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	ff d0                	call   *%eax
  801fa6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801fa9:	83 ec 08             	sub    $0x8,%esp
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	6a 78                	push   $0x78
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	ff d0                	call   *%eax
  801fb6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbc:	83 c0 04             	add    $0x4,%eax
  801fbf:	89 45 14             	mov    %eax,0x14(%ebp)
  801fc2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc5:	83 e8 04             	sub    $0x4,%eax
  801fc8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801fd4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801fdb:	eb 1f                	jmp    801ffc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801fdd:	83 ec 08             	sub    $0x8,%esp
  801fe0:	ff 75 e8             	pushl  -0x18(%ebp)
  801fe3:	8d 45 14             	lea    0x14(%ebp),%eax
  801fe6:	50                   	push   %eax
  801fe7:	e8 e7 fb ff ff       	call   801bd3 <getuint>
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ff2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801ff5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801ffc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  802000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	52                   	push   %edx
  802007:	ff 75 e4             	pushl  -0x1c(%ebp)
  80200a:	50                   	push   %eax
  80200b:	ff 75 f4             	pushl  -0xc(%ebp)
  80200e:	ff 75 f0             	pushl  -0x10(%ebp)
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	ff 75 08             	pushl  0x8(%ebp)
  802017:	e8 00 fb ff ff       	call   801b1c <printnum>
  80201c:	83 c4 20             	add    $0x20,%esp
			break;
  80201f:	eb 46                	jmp    802067 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802021:	83 ec 08             	sub    $0x8,%esp
  802024:	ff 75 0c             	pushl  0xc(%ebp)
  802027:	53                   	push   %ebx
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	ff d0                	call   *%eax
  80202d:	83 c4 10             	add    $0x10,%esp
			break;
  802030:	eb 35                	jmp    802067 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  802032:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  802039:	eb 2c                	jmp    802067 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80203b:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  802042:	eb 23                	jmp    802067 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802044:	83 ec 08             	sub    $0x8,%esp
  802047:	ff 75 0c             	pushl  0xc(%ebp)
  80204a:	6a 25                	push   $0x25
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	ff d0                	call   *%eax
  802051:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802054:	ff 4d 10             	decl   0x10(%ebp)
  802057:	eb 03                	jmp    80205c <vprintfmt+0x3c3>
  802059:	ff 4d 10             	decl   0x10(%ebp)
  80205c:	8b 45 10             	mov    0x10(%ebp),%eax
  80205f:	48                   	dec    %eax
  802060:	8a 00                	mov    (%eax),%al
  802062:	3c 25                	cmp    $0x25,%al
  802064:	75 f3                	jne    802059 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  802066:	90                   	nop
		}
	}
  802067:	e9 35 fc ff ff       	jmp    801ca1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80206c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80206d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5d                   	pop    %ebp
  802073:	c3                   	ret    

00802074 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80207a:	8d 45 10             	lea    0x10(%ebp),%eax
  80207d:	83 c0 04             	add    $0x4,%eax
  802080:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802083:	8b 45 10             	mov    0x10(%ebp),%eax
  802086:	ff 75 f4             	pushl  -0xc(%ebp)
  802089:	50                   	push   %eax
  80208a:	ff 75 0c             	pushl  0xc(%ebp)
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	e8 04 fc ff ff       	call   801c99 <vprintfmt>
  802095:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802098:	90                   	nop
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	8b 40 08             	mov    0x8(%eax),%eax
  8020a4:	8d 50 01             	lea    0x1(%eax),%edx
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8020ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b0:	8b 10                	mov    (%eax),%edx
  8020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b5:	8b 40 04             	mov    0x4(%eax),%eax
  8020b8:	39 c2                	cmp    %eax,%edx
  8020ba:	73 12                	jae    8020ce <sprintputch+0x33>
		*b->buf++ = ch;
  8020bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020bf:	8b 00                	mov    (%eax),%eax
  8020c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8020c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c7:	89 0a                	mov    %ecx,(%edx)
  8020c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cc:	88 10                	mov    %dl,(%eax)
}
  8020ce:	90                   	nop
  8020cf:	5d                   	pop    %ebp
  8020d0:	c3                   	ret    

008020d1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	01 d0                	add    %edx,%eax
  8020e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8020f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f6:	74 06                	je     8020fe <vsnprintf+0x2d>
  8020f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020fc:	7f 07                	jg     802105 <vsnprintf+0x34>
		return -E_INVAL;
  8020fe:	b8 03 00 00 00       	mov    $0x3,%eax
  802103:	eb 20                	jmp    802125 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802105:	ff 75 14             	pushl  0x14(%ebp)
  802108:	ff 75 10             	pushl  0x10(%ebp)
  80210b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80210e:	50                   	push   %eax
  80210f:	68 9b 20 80 00       	push   $0x80209b
  802114:	e8 80 fb ff ff       	call   801c99 <vprintfmt>
  802119:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80211c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80212d:	8d 45 10             	lea    0x10(%ebp),%eax
  802130:	83 c0 04             	add    $0x4,%eax
  802133:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802136:	8b 45 10             	mov    0x10(%ebp),%eax
  802139:	ff 75 f4             	pushl  -0xc(%ebp)
  80213c:	50                   	push   %eax
  80213d:	ff 75 0c             	pushl  0xc(%ebp)
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	e8 89 ff ff ff       	call   8020d1 <vsnprintf>
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80214e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802160:	eb 06                	jmp    802168 <strlen+0x15>
		n++;
  802162:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802165:	ff 45 08             	incl   0x8(%ebp)
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	84 c0                	test   %al,%al
  80216f:	75 f1                	jne    802162 <strlen+0xf>
		n++;
	return n;
  802171:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80217c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802183:	eb 09                	jmp    80218e <strnlen+0x18>
		n++;
  802185:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802188:	ff 45 08             	incl   0x8(%ebp)
  80218b:	ff 4d 0c             	decl   0xc(%ebp)
  80218e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802192:	74 09                	je     80219d <strnlen+0x27>
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8a 00                	mov    (%eax),%al
  802199:	84 c0                	test   %al,%al
  80219b:	75 e8                	jne    802185 <strnlen+0xf>
		n++;
	return n;
  80219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8021ae:	90                   	nop
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8d 50 01             	lea    0x1(%eax),%edx
  8021b5:	89 55 08             	mov    %edx,0x8(%ebp)
  8021b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021be:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8021c1:	8a 12                	mov    (%edx),%dl
  8021c3:	88 10                	mov    %dl,(%eax)
  8021c5:	8a 00                	mov    (%eax),%al
  8021c7:	84 c0                	test   %al,%al
  8021c9:	75 e4                	jne    8021af <strcpy+0xd>
		/* do nothing */;
	return ret;
  8021cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8021dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021e3:	eb 1f                	jmp    802204 <strncpy+0x34>
		*dst++ = *src;
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	8d 50 01             	lea    0x1(%eax),%edx
  8021eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8021ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f1:	8a 12                	mov    (%edx),%dl
  8021f3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8021f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f8:	8a 00                	mov    (%eax),%al
  8021fa:	84 c0                	test   %al,%al
  8021fc:	74 03                	je     802201 <strncpy+0x31>
			src++;
  8021fe:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802201:	ff 45 fc             	incl   -0x4(%ebp)
  802204:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802207:	3b 45 10             	cmp    0x10(%ebp),%eax
  80220a:	72 d9                	jb     8021e5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80220c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80221d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802221:	74 30                	je     802253 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802223:	eb 16                	jmp    80223b <strlcpy+0x2a>
			*dst++ = *src++;
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	8d 50 01             	lea    0x1(%eax),%edx
  80222b:	89 55 08             	mov    %edx,0x8(%ebp)
  80222e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802231:	8d 4a 01             	lea    0x1(%edx),%ecx
  802234:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802237:	8a 12                	mov    (%edx),%dl
  802239:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80223b:	ff 4d 10             	decl   0x10(%ebp)
  80223e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802242:	74 09                	je     80224d <strlcpy+0x3c>
  802244:	8b 45 0c             	mov    0xc(%ebp),%eax
  802247:	8a 00                	mov    (%eax),%al
  802249:	84 c0                	test   %al,%al
  80224b:	75 d8                	jne    802225 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802253:	8b 55 08             	mov    0x8(%ebp),%edx
  802256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802259:	29 c2                	sub    %eax,%edx
  80225b:	89 d0                	mov    %edx,%eax
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802262:	eb 06                	jmp    80226a <strcmp+0xb>
		p++, q++;
  802264:	ff 45 08             	incl   0x8(%ebp)
  802267:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8a 00                	mov    (%eax),%al
  80226f:	84 c0                	test   %al,%al
  802271:	74 0e                	je     802281 <strcmp+0x22>
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8a 10                	mov    (%eax),%dl
  802278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227b:	8a 00                	mov    (%eax),%al
  80227d:	38 c2                	cmp    %al,%dl
  80227f:	74 e3                	je     802264 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	8a 00                	mov    (%eax),%al
  802286:	0f b6 d0             	movzbl %al,%edx
  802289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228c:	8a 00                	mov    (%eax),%al
  80228e:	0f b6 c0             	movzbl %al,%eax
  802291:	29 c2                	sub    %eax,%edx
  802293:	89 d0                	mov    %edx,%eax
}
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    

00802297 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80229a:	eb 09                	jmp    8022a5 <strncmp+0xe>
		n--, p++, q++;
  80229c:	ff 4d 10             	decl   0x10(%ebp)
  80229f:	ff 45 08             	incl   0x8(%ebp)
  8022a2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8022a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022a9:	74 17                	je     8022c2 <strncmp+0x2b>
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	8a 00                	mov    (%eax),%al
  8022b0:	84 c0                	test   %al,%al
  8022b2:	74 0e                	je     8022c2 <strncmp+0x2b>
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	8a 10                	mov    (%eax),%dl
  8022b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bc:	8a 00                	mov    (%eax),%al
  8022be:	38 c2                	cmp    %al,%dl
  8022c0:	74 da                	je     80229c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8022c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022c6:	75 07                	jne    8022cf <strncmp+0x38>
		return 0;
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cd:	eb 14                	jmp    8022e3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8a 00                	mov    (%eax),%al
  8022d4:	0f b6 d0             	movzbl %al,%edx
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	8a 00                	mov    (%eax),%al
  8022dc:	0f b6 c0             	movzbl %al,%eax
  8022df:	29 c2                	sub    %eax,%edx
  8022e1:	89 d0                	mov    %edx,%eax
}
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    

008022e5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022f1:	eb 12                	jmp    802305 <strchr+0x20>
		if (*s == c)
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	8a 00                	mov    (%eax),%al
  8022f8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022fb:	75 05                	jne    802302 <strchr+0x1d>
			return (char *) s;
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	eb 11                	jmp    802313 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802302:	ff 45 08             	incl   0x8(%ebp)
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	8a 00                	mov    (%eax),%al
  80230a:	84 c0                	test   %al,%al
  80230c:	75 e5                	jne    8022f3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802321:	eb 0d                	jmp    802330 <strfind+0x1b>
		if (*s == c)
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	8a 00                	mov    (%eax),%al
  802328:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80232b:	74 0e                	je     80233b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80232d:	ff 45 08             	incl   0x8(%ebp)
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	8a 00                	mov    (%eax),%al
  802335:	84 c0                	test   %al,%al
  802337:	75 ea                	jne    802323 <strfind+0xe>
  802339:	eb 01                	jmp    80233c <strfind+0x27>
		if (*s == c)
			break;
  80233b:	90                   	nop
	return (char *) s;
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80234d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802351:	76 63                	jbe    8023b6 <memset+0x75>
		uint64 data_block = c;
  802353:	8b 45 0c             	mov    0xc(%ebp),%eax
  802356:	99                   	cltd   
  802357:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80235a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80235d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802363:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802367:	c1 e0 08             	shl    $0x8,%eax
  80236a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80236d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802376:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80237a:	c1 e0 10             	shl    $0x10,%eax
  80237d:	09 45 f0             	or     %eax,-0x10(%ebp)
  802380:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802389:	89 c2                	mov    %eax,%edx
  80238b:	b8 00 00 00 00       	mov    $0x0,%eax
  802390:	09 45 f0             	or     %eax,-0x10(%ebp)
  802393:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  802396:	eb 18                	jmp    8023b0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802398:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80239b:	8d 41 08             	lea    0x8(%ecx),%eax
  80239e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a7:	89 01                	mov    %eax,(%ecx)
  8023a9:	89 51 04             	mov    %edx,0x4(%ecx)
  8023ac:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8023b0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023b4:	77 e2                	ja     802398 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8023b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023ba:	74 23                	je     8023df <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8023bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8023c2:	eb 0e                	jmp    8023d2 <memset+0x91>
			*p8++ = (uint8)c;
  8023c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023c7:	8d 50 01             	lea    0x1(%eax),%edx
  8023ca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8023d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	75 e5                	jne    8023c4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8023ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8023f6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023fa:	76 24                	jbe    802420 <memcpy+0x3c>
		while(n >= 8){
  8023fc:	eb 1c                	jmp    80241a <memcpy+0x36>
			*d64 = *s64;
  8023fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802401:	8b 50 04             	mov    0x4(%eax),%edx
  802404:	8b 00                	mov    (%eax),%eax
  802406:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802409:	89 01                	mov    %eax,(%ecx)
  80240b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80240e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802412:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802416:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80241a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80241e:	77 de                	ja     8023fe <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802420:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802424:	74 31                	je     802457 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802426:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802429:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80242c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80242f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802432:	eb 16                	jmp    80244a <memcpy+0x66>
			*d8++ = *s8++;
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	8d 50 01             	lea    0x1(%eax),%edx
  80243a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80243d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802440:	8d 4a 01             	lea    0x1(%edx),%ecx
  802443:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802446:	8a 12                	mov    (%edx),%dl
  802448:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80244a:	8b 45 10             	mov    0x10(%ebp),%eax
  80244d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802450:	89 55 10             	mov    %edx,0x10(%ebp)
  802453:	85 c0                	test   %eax,%eax
  802455:	75 dd                	jne    802434 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802462:	8b 45 0c             	mov    0xc(%ebp),%eax
  802465:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80246e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802471:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802474:	73 50                	jae    8024c6 <memmove+0x6a>
  802476:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802479:	8b 45 10             	mov    0x10(%ebp),%eax
  80247c:	01 d0                	add    %edx,%eax
  80247e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802481:	76 43                	jbe    8024c6 <memmove+0x6a>
		s += n;
  802483:	8b 45 10             	mov    0x10(%ebp),%eax
  802486:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802489:	8b 45 10             	mov    0x10(%ebp),%eax
  80248c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80248f:	eb 10                	jmp    8024a1 <memmove+0x45>
			*--d = *--s;
  802491:	ff 4d f8             	decl   -0x8(%ebp)
  802494:	ff 4d fc             	decl   -0x4(%ebp)
  802497:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80249a:	8a 10                	mov    (%eax),%dl
  80249c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80249f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8024a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	75 e3                	jne    802491 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8024ae:	eb 23                	jmp    8024d3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8024b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024b3:	8d 50 01             	lea    0x1(%eax),%edx
  8024b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024bf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024c2:	8a 12                	mov    (%edx),%dl
  8024c4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8024c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	75 dd                	jne    8024b0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8024e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8024ea:	eb 2a                	jmp    802516 <memcmp+0x3e>
		if (*s1 != *s2)
  8024ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024ef:	8a 10                	mov    (%eax),%dl
  8024f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024f4:	8a 00                	mov    (%eax),%al
  8024f6:	38 c2                	cmp    %al,%dl
  8024f8:	74 16                	je     802510 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8024fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024fd:	8a 00                	mov    (%eax),%al
  8024ff:	0f b6 d0             	movzbl %al,%edx
  802502:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802505:	8a 00                	mov    (%eax),%al
  802507:	0f b6 c0             	movzbl %al,%eax
  80250a:	29 c2                	sub    %eax,%edx
  80250c:	89 d0                	mov    %edx,%eax
  80250e:	eb 18                	jmp    802528 <memcmp+0x50>
		s1++, s2++;
  802510:	ff 45 fc             	incl   -0x4(%ebp)
  802513:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802516:	8b 45 10             	mov    0x10(%ebp),%eax
  802519:	8d 50 ff             	lea    -0x1(%eax),%edx
  80251c:	89 55 10             	mov    %edx,0x10(%ebp)
  80251f:	85 c0                	test   %eax,%eax
  802521:	75 c9                	jne    8024ec <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802530:	8b 55 08             	mov    0x8(%ebp),%edx
  802533:	8b 45 10             	mov    0x10(%ebp),%eax
  802536:	01 d0                	add    %edx,%eax
  802538:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80253b:	eb 15                	jmp    802552 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	8a 00                	mov    (%eax),%al
  802542:	0f b6 d0             	movzbl %al,%edx
  802545:	8b 45 0c             	mov    0xc(%ebp),%eax
  802548:	0f b6 c0             	movzbl %al,%eax
  80254b:	39 c2                	cmp    %eax,%edx
  80254d:	74 0d                	je     80255c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80254f:	ff 45 08             	incl   0x8(%ebp)
  802552:	8b 45 08             	mov    0x8(%ebp),%eax
  802555:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802558:	72 e3                	jb     80253d <memfind+0x13>
  80255a:	eb 01                	jmp    80255d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80255c:	90                   	nop
	return (void *) s;
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802568:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80256f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802576:	eb 03                	jmp    80257b <strtol+0x19>
		s++;
  802578:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	8a 00                	mov    (%eax),%al
  802580:	3c 20                	cmp    $0x20,%al
  802582:	74 f4                	je     802578 <strtol+0x16>
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	8a 00                	mov    (%eax),%al
  802589:	3c 09                	cmp    $0x9,%al
  80258b:	74 eb                	je     802578 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	8a 00                	mov    (%eax),%al
  802592:	3c 2b                	cmp    $0x2b,%al
  802594:	75 05                	jne    80259b <strtol+0x39>
		s++;
  802596:	ff 45 08             	incl   0x8(%ebp)
  802599:	eb 13                	jmp    8025ae <strtol+0x4c>
	else if (*s == '-')
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	8a 00                	mov    (%eax),%al
  8025a0:	3c 2d                	cmp    $0x2d,%al
  8025a2:	75 0a                	jne    8025ae <strtol+0x4c>
		s++, neg = 1;
  8025a4:	ff 45 08             	incl   0x8(%ebp)
  8025a7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025b2:	74 06                	je     8025ba <strtol+0x58>
  8025b4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8025b8:	75 20                	jne    8025da <strtol+0x78>
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	8a 00                	mov    (%eax),%al
  8025bf:	3c 30                	cmp    $0x30,%al
  8025c1:	75 17                	jne    8025da <strtol+0x78>
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	40                   	inc    %eax
  8025c7:	8a 00                	mov    (%eax),%al
  8025c9:	3c 78                	cmp    $0x78,%al
  8025cb:	75 0d                	jne    8025da <strtol+0x78>
		s += 2, base = 16;
  8025cd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8025d1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8025d8:	eb 28                	jmp    802602 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8025da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025de:	75 15                	jne    8025f5 <strtol+0x93>
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	8a 00                	mov    (%eax),%al
  8025e5:	3c 30                	cmp    $0x30,%al
  8025e7:	75 0c                	jne    8025f5 <strtol+0x93>
		s++, base = 8;
  8025e9:	ff 45 08             	incl   0x8(%ebp)
  8025ec:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8025f3:	eb 0d                	jmp    802602 <strtol+0xa0>
	else if (base == 0)
  8025f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025f9:	75 07                	jne    802602 <strtol+0xa0>
		base = 10;
  8025fb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	8a 00                	mov    (%eax),%al
  802607:	3c 2f                	cmp    $0x2f,%al
  802609:	7e 19                	jle    802624 <strtol+0xc2>
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	8a 00                	mov    (%eax),%al
  802610:	3c 39                	cmp    $0x39,%al
  802612:	7f 10                	jg     802624 <strtol+0xc2>
			dig = *s - '0';
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	8a 00                	mov    (%eax),%al
  802619:	0f be c0             	movsbl %al,%eax
  80261c:	83 e8 30             	sub    $0x30,%eax
  80261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802622:	eb 42                	jmp    802666 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	8a 00                	mov    (%eax),%al
  802629:	3c 60                	cmp    $0x60,%al
  80262b:	7e 19                	jle    802646 <strtol+0xe4>
  80262d:	8b 45 08             	mov    0x8(%ebp),%eax
  802630:	8a 00                	mov    (%eax),%al
  802632:	3c 7a                	cmp    $0x7a,%al
  802634:	7f 10                	jg     802646 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802636:	8b 45 08             	mov    0x8(%ebp),%eax
  802639:	8a 00                	mov    (%eax),%al
  80263b:	0f be c0             	movsbl %al,%eax
  80263e:	83 e8 57             	sub    $0x57,%eax
  802641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802644:	eb 20                	jmp    802666 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	8a 00                	mov    (%eax),%al
  80264b:	3c 40                	cmp    $0x40,%al
  80264d:	7e 39                	jle    802688 <strtol+0x126>
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	8a 00                	mov    (%eax),%al
  802654:	3c 5a                	cmp    $0x5a,%al
  802656:	7f 30                	jg     802688 <strtol+0x126>
			dig = *s - 'A' + 10;
  802658:	8b 45 08             	mov    0x8(%ebp),%eax
  80265b:	8a 00                	mov    (%eax),%al
  80265d:	0f be c0             	movsbl %al,%eax
  802660:	83 e8 37             	sub    $0x37,%eax
  802663:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	3b 45 10             	cmp    0x10(%ebp),%eax
  80266c:	7d 19                	jge    802687 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80266e:	ff 45 08             	incl   0x8(%ebp)
  802671:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802674:	0f af 45 10          	imul   0x10(%ebp),%eax
  802678:	89 c2                	mov    %eax,%edx
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	01 d0                	add    %edx,%eax
  80267f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802682:	e9 7b ff ff ff       	jmp    802602 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802687:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802688:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80268c:	74 08                	je     802696 <strtol+0x134>
		*endptr = (char *) s;
  80268e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802691:	8b 55 08             	mov    0x8(%ebp),%edx
  802694:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802696:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80269a:	74 07                	je     8026a3 <strtol+0x141>
  80269c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80269f:	f7 d8                	neg    %eax
  8026a1:	eb 03                	jmp    8026a6 <strtol+0x144>
  8026a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <ltostr>:

void
ltostr(long value, char *str)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8026ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8026b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8026bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026c0:	79 13                	jns    8026d5 <ltostr+0x2d>
	{
		neg = 1;
  8026c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8026c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026cc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8026cf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8026d2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8026dd:	99                   	cltd   
  8026de:	f7 f9                	idiv   %ecx
  8026e0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8026e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026e6:	8d 50 01             	lea    0x1(%eax),%edx
  8026e9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8026ec:	89 c2                	mov    %eax,%edx
  8026ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f1:	01 d0                	add    %edx,%eax
  8026f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f6:	83 c2 30             	add    $0x30,%edx
  8026f9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8026fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802703:	f7 e9                	imul   %ecx
  802705:	c1 fa 02             	sar    $0x2,%edx
  802708:	89 c8                	mov    %ecx,%eax
  80270a:	c1 f8 1f             	sar    $0x1f,%eax
  80270d:	29 c2                	sub    %eax,%edx
  80270f:	89 d0                	mov    %edx,%eax
  802711:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802714:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802718:	75 bb                	jne    8026d5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80271a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802721:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802724:	48                   	dec    %eax
  802725:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802728:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80272c:	74 3d                	je     80276b <ltostr+0xc3>
		start = 1 ;
  80272e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802735:	eb 34                	jmp    80276b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273d:	01 d0                	add    %edx,%eax
  80273f:	8a 00                	mov    (%eax),%al
  802741:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802744:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274a:	01 c2                	add    %eax,%edx
  80274c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80274f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802752:	01 c8                	add    %ecx,%eax
  802754:	8a 00                	mov    (%eax),%al
  802756:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802758:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275e:	01 c2                	add    %eax,%edx
  802760:	8a 45 eb             	mov    -0x15(%ebp),%al
  802763:	88 02                	mov    %al,(%edx)
		start++ ;
  802765:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802768:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802771:	7c c4                	jl     802737 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802773:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802776:	8b 45 0c             	mov    0xc(%ebp),%eax
  802779:	01 d0                	add    %edx,%eax
  80277b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80277e:	90                   	nop
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802787:	ff 75 08             	pushl  0x8(%ebp)
  80278a:	e8 c4 f9 ff ff       	call   802153 <strlen>
  80278f:	83 c4 04             	add    $0x4,%esp
  802792:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802795:	ff 75 0c             	pushl  0xc(%ebp)
  802798:	e8 b6 f9 ff ff       	call   802153 <strlen>
  80279d:	83 c4 04             	add    $0x4,%esp
  8027a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8027a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8027aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8027b1:	eb 17                	jmp    8027ca <strcconcat+0x49>
		final[s] = str1[s] ;
  8027b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8027b9:	01 c2                	add    %eax,%edx
  8027bb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	01 c8                	add    %ecx,%eax
  8027c3:	8a 00                	mov    (%eax),%al
  8027c5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8027c7:	ff 45 fc             	incl   -0x4(%ebp)
  8027ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027d0:	7c e1                	jl     8027b3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8027d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8027d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8027e0:	eb 1f                	jmp    802801 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8027e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e5:	8d 50 01             	lea    0x1(%eax),%edx
  8027e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8027eb:	89 c2                	mov    %eax,%edx
  8027ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f0:	01 c2                	add    %eax,%edx
  8027f2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8027f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f8:	01 c8                	add    %ecx,%eax
  8027fa:	8a 00                	mov    (%eax),%al
  8027fc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8027fe:	ff 45 f8             	incl   -0x8(%ebp)
  802801:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802804:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802807:	7c d9                	jl     8027e2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802809:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80280c:	8b 45 10             	mov    0x10(%ebp),%eax
  80280f:	01 d0                	add    %edx,%eax
  802811:	c6 00 00             	movb   $0x0,(%eax)
}
  802814:	90                   	nop
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80281a:	8b 45 14             	mov    0x14(%ebp),%eax
  80281d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802823:	8b 45 14             	mov    0x14(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80282f:	8b 45 10             	mov    0x10(%ebp),%eax
  802832:	01 d0                	add    %edx,%eax
  802834:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80283a:	eb 0c                	jmp    802848 <strsplit+0x31>
			*string++ = 0;
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	8d 50 01             	lea    0x1(%eax),%edx
  802842:	89 55 08             	mov    %edx,0x8(%ebp)
  802845:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	8a 00                	mov    (%eax),%al
  80284d:	84 c0                	test   %al,%al
  80284f:	74 18                	je     802869 <strsplit+0x52>
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	8a 00                	mov    (%eax),%al
  802856:	0f be c0             	movsbl %al,%eax
  802859:	50                   	push   %eax
  80285a:	ff 75 0c             	pushl  0xc(%ebp)
  80285d:	e8 83 fa ff ff       	call   8022e5 <strchr>
  802862:	83 c4 08             	add    $0x8,%esp
  802865:	85 c0                	test   %eax,%eax
  802867:	75 d3                	jne    80283c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802869:	8b 45 08             	mov    0x8(%ebp),%eax
  80286c:	8a 00                	mov    (%eax),%al
  80286e:	84 c0                	test   %al,%al
  802870:	74 5a                	je     8028cc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802872:	8b 45 14             	mov    0x14(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	83 f8 0f             	cmp    $0xf,%eax
  80287a:	75 07                	jne    802883 <strsplit+0x6c>
		{
			return 0;
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
  802881:	eb 66                	jmp    8028e9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802883:	8b 45 14             	mov    0x14(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	8d 48 01             	lea    0x1(%eax),%ecx
  80288b:	8b 55 14             	mov    0x14(%ebp),%edx
  80288e:	89 0a                	mov    %ecx,(%edx)
  802890:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802897:	8b 45 10             	mov    0x10(%ebp),%eax
  80289a:	01 c2                	add    %eax,%edx
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8028a1:	eb 03                	jmp    8028a6 <strsplit+0x8f>
			string++;
  8028a3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	8a 00                	mov    (%eax),%al
  8028ab:	84 c0                	test   %al,%al
  8028ad:	74 8b                	je     80283a <strsplit+0x23>
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	8a 00                	mov    (%eax),%al
  8028b4:	0f be c0             	movsbl %al,%eax
  8028b7:	50                   	push   %eax
  8028b8:	ff 75 0c             	pushl  0xc(%ebp)
  8028bb:	e8 25 fa ff ff       	call   8022e5 <strchr>
  8028c0:	83 c4 08             	add    $0x8,%esp
  8028c3:	85 c0                	test   %eax,%eax
  8028c5:	74 dc                	je     8028a3 <strsplit+0x8c>
			string++;
	}
  8028c7:	e9 6e ff ff ff       	jmp    80283a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8028cc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8028cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8028dc:	01 d0                	add    %edx,%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8028e4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
  8028ee:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8028f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8028fe:	eb 4a                	jmp    80294a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802900:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	01 c2                	add    %eax,%edx
  802908:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80290b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80290e:	01 c8                	add    %ecx,%eax
  802910:	8a 00                	mov    (%eax),%al
  802912:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802914:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291a:	01 d0                	add    %edx,%eax
  80291c:	8a 00                	mov    (%eax),%al
  80291e:	3c 40                	cmp    $0x40,%al
  802920:	7e 25                	jle    802947 <str2lower+0x5c>
  802922:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802925:	8b 45 0c             	mov    0xc(%ebp),%eax
  802928:	01 d0                	add    %edx,%eax
  80292a:	8a 00                	mov    (%eax),%al
  80292c:	3c 5a                	cmp    $0x5a,%al
  80292e:	7f 17                	jg     802947 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802930:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	01 d0                	add    %edx,%eax
  802938:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80293b:	8b 55 08             	mov    0x8(%ebp),%edx
  80293e:	01 ca                	add    %ecx,%edx
  802940:	8a 12                	mov    (%edx),%dl
  802942:	83 c2 20             	add    $0x20,%edx
  802945:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802947:	ff 45 fc             	incl   -0x4(%ebp)
  80294a:	ff 75 0c             	pushl  0xc(%ebp)
  80294d:	e8 01 f8 ff ff       	call   802153 <strlen>
  802952:	83 c4 04             	add    $0x4,%esp
  802955:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802958:	7f a6                	jg     802900 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80295a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802965:	a1 08 50 80 00       	mov    0x805008,%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	74 42                	je     8029b0 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80296e:	83 ec 08             	sub    $0x8,%esp
  802971:	68 00 00 00 82       	push   $0x82000000
  802976:	68 00 00 00 80       	push   $0x80000000
  80297b:	e8 00 08 00 00       	call   803180 <initialize_dynamic_allocator>
  802980:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802983:	e8 e7 05 00 00       	call   802f6f <sys_get_uheap_strategy>
  802988:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80298d:	a1 20 52 80 00       	mov    0x805220,%eax
  802992:	05 00 10 00 00       	add    $0x1000,%eax
  802997:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  80299c:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  8029a1:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  8029a6:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8029ad:	00 00 00 
	}
}
  8029b0:	90                   	nop
  8029b1:	c9                   	leave  
  8029b2:	c3                   	ret    

008029b3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
  8029b6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029c7:	83 ec 08             	sub    $0x8,%esp
  8029ca:	68 06 04 00 00       	push   $0x406
  8029cf:	50                   	push   %eax
  8029d0:	e8 e4 01 00 00       	call   802bb9 <__sys_allocate_page>
  8029d5:	83 c4 10             	add    $0x10,%esp
  8029d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8029db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029df:	79 14                	jns    8029f5 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8029e1:	83 ec 04             	sub    $0x4,%esp
  8029e4:	68 68 4c 80 00       	push   $0x804c68
  8029e9:	6a 1f                	push   $0x1f
  8029eb:	68 a4 4c 80 00       	push   $0x804ca4
  8029f0:	e8 b7 ed ff ff       	call   8017ac <_panic>
	return 0;
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
  8029ff:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a10:	83 ec 0c             	sub    $0xc,%esp
  802a13:	50                   	push   %eax
  802a14:	e8 e7 01 00 00       	call   802c00 <__sys_unmap_frame>
  802a19:	83 c4 10             	add    $0x10,%esp
  802a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802a1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a23:	79 14                	jns    802a39 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802a25:	83 ec 04             	sub    $0x4,%esp
  802a28:	68 b0 4c 80 00       	push   $0x804cb0
  802a2d:	6a 2a                	push   $0x2a
  802a2f:	68 a4 4c 80 00       	push   $0x804ca4
  802a34:	e8 73 ed ff ff       	call   8017ac <_panic>
}
  802a39:	90                   	nop
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a42:	e8 18 ff ff ff       	call   80295f <uheap_init>
	if (size == 0) return NULL ;
  802a47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a4b:	75 07                	jne    802a54 <malloc+0x18>
  802a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a52:	eb 14                	jmp    802a68 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802a54:	83 ec 04             	sub    $0x4,%esp
  802a57:	68 f0 4c 80 00       	push   $0x804cf0
  802a5c:	6a 3e                	push   $0x3e
  802a5e:	68 a4 4c 80 00       	push   $0x804ca4
  802a63:	e8 44 ed ff ff       	call   8017ac <_panic>
}
  802a68:	c9                   	leave  
  802a69:	c3                   	ret    

00802a6a <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
  802a6d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802a70:	83 ec 04             	sub    $0x4,%esp
  802a73:	68 18 4d 80 00       	push   $0x804d18
  802a78:	6a 49                	push   $0x49
  802a7a:	68 a4 4c 80 00       	push   $0x804ca4
  802a7f:	e8 28 ed ff ff       	call   8017ac <_panic>

00802a84 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802a84:	55                   	push   %ebp
  802a85:	89 e5                	mov    %esp,%ebp
  802a87:	83 ec 18             	sub    $0x18,%esp
  802a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  802a8d:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a90:	e8 ca fe ff ff       	call   80295f <uheap_init>
	if (size == 0) return NULL ;
  802a95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a99:	75 07                	jne    802aa2 <smalloc+0x1e>
  802a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa0:	eb 14                	jmp    802ab6 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 3c 4d 80 00       	push   $0x804d3c
  802aaa:	6a 5a                	push   $0x5a
  802aac:	68 a4 4c 80 00       	push   $0x804ca4
  802ab1:	e8 f6 ec ff ff       	call   8017ac <_panic>
}
  802ab6:	c9                   	leave  
  802ab7:	c3                   	ret    

00802ab8 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802abe:	e8 9c fe ff ff       	call   80295f <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  802ac3:	83 ec 04             	sub    $0x4,%esp
  802ac6:	68 64 4d 80 00       	push   $0x804d64
  802acb:	6a 6a                	push   $0x6a
  802acd:	68 a4 4c 80 00       	push   $0x804ca4
  802ad2:	e8 d5 ec ff ff       	call   8017ac <_panic>

00802ad7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802ad7:	55                   	push   %ebp
  802ad8:	89 e5                	mov    %esp,%ebp
  802ada:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802add:	e8 7d fe ff ff       	call   80295f <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802ae2:	83 ec 04             	sub    $0x4,%esp
  802ae5:	68 88 4d 80 00       	push   $0x804d88
  802aea:	68 88 00 00 00       	push   $0x88
  802aef:	68 a4 4c 80 00       	push   $0x804ca4
  802af4:	e8 b3 ec ff ff       	call   8017ac <_panic>

00802af9 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802af9:	55                   	push   %ebp
  802afa:	89 e5                	mov    %esp,%ebp
  802afc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	68 b0 4d 80 00       	push   $0x804db0
  802b07:	68 9b 00 00 00       	push   $0x9b
  802b0c:	68 a4 4c 80 00       	push   $0x804ca4
  802b11:	e8 96 ec ff ff       	call   8017ac <_panic>

00802b16 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802b16:	55                   	push   %ebp
  802b17:	89 e5                	mov    %esp,%ebp
  802b19:	57                   	push   %edi
  802b1a:	56                   	push   %esi
  802b1b:	53                   	push   %ebx
  802b1c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b28:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b2b:	8b 7d 18             	mov    0x18(%ebp),%edi
  802b2e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802b31:	cd 30                	int    $0x30
  802b33:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802b39:	83 c4 10             	add    $0x10,%esp
  802b3c:	5b                   	pop    %ebx
  802b3d:	5e                   	pop    %esi
  802b3e:	5f                   	pop    %edi
  802b3f:	5d                   	pop    %ebp
  802b40:	c3                   	ret    

00802b41 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802b41:	55                   	push   %ebp
  802b42:	89 e5                	mov    %esp,%ebp
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	8b 45 10             	mov    0x10(%ebp),%eax
  802b4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802b4d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b50:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	6a 00                	push   $0x0
  802b59:	51                   	push   %ecx
  802b5a:	52                   	push   %edx
  802b5b:	ff 75 0c             	pushl  0xc(%ebp)
  802b5e:	50                   	push   %eax
  802b5f:	6a 00                	push   $0x0
  802b61:	e8 b0 ff ff ff       	call   802b16 <syscall>
  802b66:	83 c4 18             	add    $0x18,%esp
}
  802b69:	90                   	nop
  802b6a:	c9                   	leave  
  802b6b:	c3                   	ret    

00802b6c <sys_cgetc>:

int
sys_cgetc(void)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 00                	push   $0x0
  802b77:	6a 00                	push   $0x0
  802b79:	6a 02                	push   $0x2
  802b7b:	e8 96 ff ff ff       	call   802b16 <syscall>
  802b80:	83 c4 18             	add    $0x18,%esp
}
  802b83:	c9                   	leave  
  802b84:	c3                   	ret    

00802b85 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802b85:	55                   	push   %ebp
  802b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802b88:	6a 00                	push   $0x0
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 03                	push   $0x3
  802b94:	e8 7d ff ff ff       	call   802b16 <syscall>
  802b99:	83 c4 18             	add    $0x18,%esp
}
  802b9c:	90                   	nop
  802b9d:	c9                   	leave  
  802b9e:	c3                   	ret    

00802b9f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802b9f:	55                   	push   %ebp
  802ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	6a 04                	push   $0x4
  802bae:	e8 63 ff ff ff       	call   802b16 <syscall>
  802bb3:	83 c4 18             	add    $0x18,%esp
}
  802bb6:	90                   	nop
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	6a 00                	push   $0x0
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 00                	push   $0x0
  802bc8:	52                   	push   %edx
  802bc9:	50                   	push   %eax
  802bca:	6a 08                	push   $0x8
  802bcc:	e8 45 ff ff ff       	call   802b16 <syscall>
  802bd1:	83 c4 18             	add    $0x18,%esp
}
  802bd4:	c9                   	leave  
  802bd5:	c3                   	ret    

00802bd6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
  802bd9:	56                   	push   %esi
  802bda:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802bdb:	8b 75 18             	mov    0x18(%ebp),%esi
  802bde:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802be1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802be4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	56                   	push   %esi
  802beb:	53                   	push   %ebx
  802bec:	51                   	push   %ecx
  802bed:	52                   	push   %edx
  802bee:	50                   	push   %eax
  802bef:	6a 09                	push   $0x9
  802bf1:	e8 20 ff ff ff       	call   802b16 <syscall>
  802bf6:	83 c4 18             	add    $0x18,%esp
}
  802bf9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bfc:	5b                   	pop    %ebx
  802bfd:	5e                   	pop    %esi
  802bfe:	5d                   	pop    %ebp
  802bff:	c3                   	ret    

00802c00 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802c00:	55                   	push   %ebp
  802c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	6a 00                	push   $0x0
  802c09:	6a 00                	push   $0x0
  802c0b:	ff 75 08             	pushl  0x8(%ebp)
  802c0e:	6a 0a                	push   $0xa
  802c10:	e8 01 ff ff ff       	call   802b16 <syscall>
  802c15:	83 c4 18             	add    $0x18,%esp
}
  802c18:	c9                   	leave  
  802c19:	c3                   	ret    

00802c1a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802c1a:	55                   	push   %ebp
  802c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 00                	push   $0x0
  802c23:	ff 75 0c             	pushl  0xc(%ebp)
  802c26:	ff 75 08             	pushl  0x8(%ebp)
  802c29:	6a 0b                	push   $0xb
  802c2b:	e8 e6 fe ff ff       	call   802b16 <syscall>
  802c30:	83 c4 18             	add    $0x18,%esp
}
  802c33:	c9                   	leave  
  802c34:	c3                   	ret    

00802c35 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802c35:	55                   	push   %ebp
  802c36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802c38:	6a 00                	push   $0x0
  802c3a:	6a 00                	push   $0x0
  802c3c:	6a 00                	push   $0x0
  802c3e:	6a 00                	push   $0x0
  802c40:	6a 00                	push   $0x0
  802c42:	6a 0c                	push   $0xc
  802c44:	e8 cd fe ff ff       	call   802b16 <syscall>
  802c49:	83 c4 18             	add    $0x18,%esp
}
  802c4c:	c9                   	leave  
  802c4d:	c3                   	ret    

00802c4e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c4e:	55                   	push   %ebp
  802c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	6a 00                	push   $0x0
  802c59:	6a 00                	push   $0x0
  802c5b:	6a 0d                	push   $0xd
  802c5d:	e8 b4 fe ff ff       	call   802b16 <syscall>
  802c62:	83 c4 18             	add    $0x18,%esp
}
  802c65:	c9                   	leave  
  802c66:	c3                   	ret    

00802c67 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c67:	55                   	push   %ebp
  802c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c6a:	6a 00                	push   $0x0
  802c6c:	6a 00                	push   $0x0
  802c6e:	6a 00                	push   $0x0
  802c70:	6a 00                	push   $0x0
  802c72:	6a 00                	push   $0x0
  802c74:	6a 0e                	push   $0xe
  802c76:	e8 9b fe ff ff       	call   802b16 <syscall>
  802c7b:	83 c4 18             	add    $0x18,%esp
}
  802c7e:	c9                   	leave  
  802c7f:	c3                   	ret    

00802c80 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c83:	6a 00                	push   $0x0
  802c85:	6a 00                	push   $0x0
  802c87:	6a 00                	push   $0x0
  802c89:	6a 00                	push   $0x0
  802c8b:	6a 00                	push   $0x0
  802c8d:	6a 0f                	push   $0xf
  802c8f:	e8 82 fe ff ff       	call   802b16 <syscall>
  802c94:	83 c4 18             	add    $0x18,%esp
}
  802c97:	c9                   	leave  
  802c98:	c3                   	ret    

00802c99 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802c99:	55                   	push   %ebp
  802c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 00                	push   $0x0
  802ca4:	ff 75 08             	pushl  0x8(%ebp)
  802ca7:	6a 10                	push   $0x10
  802ca9:	e8 68 fe ff ff       	call   802b16 <syscall>
  802cae:	83 c4 18             	add    $0x18,%esp
}
  802cb1:	c9                   	leave  
  802cb2:	c3                   	ret    

00802cb3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802cb3:	55                   	push   %ebp
  802cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802cb6:	6a 00                	push   $0x0
  802cb8:	6a 00                	push   $0x0
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	6a 00                	push   $0x0
  802cc0:	6a 11                	push   $0x11
  802cc2:	e8 4f fe ff ff       	call   802b16 <syscall>
  802cc7:	83 c4 18             	add    $0x18,%esp
}
  802cca:	90                   	nop
  802ccb:	c9                   	leave  
  802ccc:	c3                   	ret    

00802ccd <sys_cputc>:

void
sys_cputc(const char c)
{
  802ccd:	55                   	push   %ebp
  802cce:	89 e5                	mov    %esp,%ebp
  802cd0:	83 ec 04             	sub    $0x4,%esp
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802cd9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 00                	push   $0x0
  802ce1:	6a 00                	push   $0x0
  802ce3:	6a 00                	push   $0x0
  802ce5:	50                   	push   %eax
  802ce6:	6a 01                	push   $0x1
  802ce8:	e8 29 fe ff ff       	call   802b16 <syscall>
  802ced:	83 c4 18             	add    $0x18,%esp
}
  802cf0:	90                   	nop
  802cf1:	c9                   	leave  
  802cf2:	c3                   	ret    

00802cf3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802cf3:	55                   	push   %ebp
  802cf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802cf6:	6a 00                	push   $0x0
  802cf8:	6a 00                	push   $0x0
  802cfa:	6a 00                	push   $0x0
  802cfc:	6a 00                	push   $0x0
  802cfe:	6a 00                	push   $0x0
  802d00:	6a 14                	push   $0x14
  802d02:	e8 0f fe ff ff       	call   802b16 <syscall>
  802d07:	83 c4 18             	add    $0x18,%esp
}
  802d0a:	90                   	nop
  802d0b:	c9                   	leave  
  802d0c:	c3                   	ret    

00802d0d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802d0d:	55                   	push   %ebp
  802d0e:	89 e5                	mov    %esp,%ebp
  802d10:	83 ec 04             	sub    $0x4,%esp
  802d13:	8b 45 10             	mov    0x10(%ebp),%eax
  802d16:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802d19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	6a 00                	push   $0x0
  802d25:	51                   	push   %ecx
  802d26:	52                   	push   %edx
  802d27:	ff 75 0c             	pushl  0xc(%ebp)
  802d2a:	50                   	push   %eax
  802d2b:	6a 15                	push   $0x15
  802d2d:	e8 e4 fd ff ff       	call   802b16 <syscall>
  802d32:	83 c4 18             	add    $0x18,%esp
}
  802d35:	c9                   	leave  
  802d36:	c3                   	ret    

00802d37 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	6a 00                	push   $0x0
  802d42:	6a 00                	push   $0x0
  802d44:	6a 00                	push   $0x0
  802d46:	52                   	push   %edx
  802d47:	50                   	push   %eax
  802d48:	6a 16                	push   $0x16
  802d4a:	e8 c7 fd ff ff       	call   802b16 <syscall>
  802d4f:	83 c4 18             	add    $0x18,%esp
}
  802d52:	c9                   	leave  
  802d53:	c3                   	ret    

00802d54 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802d54:	55                   	push   %ebp
  802d55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	51                   	push   %ecx
  802d65:	52                   	push   %edx
  802d66:	50                   	push   %eax
  802d67:	6a 17                	push   $0x17
  802d69:	e8 a8 fd ff ff       	call   802b16 <syscall>
  802d6e:	83 c4 18             	add    $0x18,%esp
}
  802d71:	c9                   	leave  
  802d72:	c3                   	ret    

00802d73 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802d73:	55                   	push   %ebp
  802d74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	6a 00                	push   $0x0
  802d7e:	6a 00                	push   $0x0
  802d80:	6a 00                	push   $0x0
  802d82:	52                   	push   %edx
  802d83:	50                   	push   %eax
  802d84:	6a 18                	push   $0x18
  802d86:	e8 8b fd ff ff       	call   802b16 <syscall>
  802d8b:	83 c4 18             	add    $0x18,%esp
}
  802d8e:	c9                   	leave  
  802d8f:	c3                   	ret    

00802d90 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d90:	55                   	push   %ebp
  802d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	6a 00                	push   $0x0
  802d98:	ff 75 14             	pushl  0x14(%ebp)
  802d9b:	ff 75 10             	pushl  0x10(%ebp)
  802d9e:	ff 75 0c             	pushl  0xc(%ebp)
  802da1:	50                   	push   %eax
  802da2:	6a 19                	push   $0x19
  802da4:	e8 6d fd ff ff       	call   802b16 <syscall>
  802da9:	83 c4 18             	add    $0x18,%esp
}
  802dac:	c9                   	leave  
  802dad:	c3                   	ret    

00802dae <sys_run_env>:

void sys_run_env(int32 envId)
{
  802dae:	55                   	push   %ebp
  802daf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	6a 00                	push   $0x0
  802db6:	6a 00                	push   $0x0
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	50                   	push   %eax
  802dbd:	6a 1a                	push   $0x1a
  802dbf:	e8 52 fd ff ff       	call   802b16 <syscall>
  802dc4:	83 c4 18             	add    $0x18,%esp
}
  802dc7:	90                   	nop
  802dc8:	c9                   	leave  
  802dc9:	c3                   	ret    

00802dca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802dca:	55                   	push   %ebp
  802dcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 00                	push   $0x0
  802dd8:	50                   	push   %eax
  802dd9:	6a 1b                	push   $0x1b
  802ddb:	e8 36 fd ff ff       	call   802b16 <syscall>
  802de0:	83 c4 18             	add    $0x18,%esp
}
  802de3:	c9                   	leave  
  802de4:	c3                   	ret    

00802de5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802de5:	55                   	push   %ebp
  802de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 00                	push   $0x0
  802df0:	6a 00                	push   $0x0
  802df2:	6a 05                	push   $0x5
  802df4:	e8 1d fd ff ff       	call   802b16 <syscall>
  802df9:	83 c4 18             	add    $0x18,%esp
}
  802dfc:	c9                   	leave  
  802dfd:	c3                   	ret    

00802dfe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802dfe:	55                   	push   %ebp
  802dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	6a 00                	push   $0x0
  802e0b:	6a 06                	push   $0x6
  802e0d:	e8 04 fd ff ff       	call   802b16 <syscall>
  802e12:	83 c4 18             	add    $0x18,%esp
}
  802e15:	c9                   	leave  
  802e16:	c3                   	ret    

00802e17 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802e17:	55                   	push   %ebp
  802e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802e1a:	6a 00                	push   $0x0
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 00                	push   $0x0
  802e20:	6a 00                	push   $0x0
  802e22:	6a 00                	push   $0x0
  802e24:	6a 07                	push   $0x7
  802e26:	e8 eb fc ff ff       	call   802b16 <syscall>
  802e2b:	83 c4 18             	add    $0x18,%esp
}
  802e2e:	c9                   	leave  
  802e2f:	c3                   	ret    

00802e30 <sys_exit_env>:


void sys_exit_env(void)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802e33:	6a 00                	push   $0x0
  802e35:	6a 00                	push   $0x0
  802e37:	6a 00                	push   $0x0
  802e39:	6a 00                	push   $0x0
  802e3b:	6a 00                	push   $0x0
  802e3d:	6a 1c                	push   $0x1c
  802e3f:	e8 d2 fc ff ff       	call   802b16 <syscall>
  802e44:	83 c4 18             	add    $0x18,%esp
}
  802e47:	90                   	nop
  802e48:	c9                   	leave  
  802e49:	c3                   	ret    

00802e4a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802e4a:	55                   	push   %ebp
  802e4b:	89 e5                	mov    %esp,%ebp
  802e4d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e53:	8d 50 04             	lea    0x4(%eax),%edx
  802e56:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	52                   	push   %edx
  802e60:	50                   	push   %eax
  802e61:	6a 1d                	push   $0x1d
  802e63:	e8 ae fc ff ff       	call   802b16 <syscall>
  802e68:	83 c4 18             	add    $0x18,%esp
	return result;
  802e6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e74:	89 01                	mov    %eax,(%ecx)
  802e76:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	c9                   	leave  
  802e7d:	c2 04 00             	ret    $0x4

00802e80 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	ff 75 10             	pushl  0x10(%ebp)
  802e8a:	ff 75 0c             	pushl  0xc(%ebp)
  802e8d:	ff 75 08             	pushl  0x8(%ebp)
  802e90:	6a 13                	push   $0x13
  802e92:	e8 7f fc ff ff       	call   802b16 <syscall>
  802e97:	83 c4 18             	add    $0x18,%esp
	return ;
  802e9a:	90                   	nop
}
  802e9b:	c9                   	leave  
  802e9c:	c3                   	ret    

00802e9d <sys_rcr2>:
uint32 sys_rcr2()
{
  802e9d:	55                   	push   %ebp
  802e9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 00                	push   $0x0
  802ea6:	6a 00                	push   $0x0
  802ea8:	6a 00                	push   $0x0
  802eaa:	6a 1e                	push   $0x1e
  802eac:	e8 65 fc ff ff       	call   802b16 <syscall>
  802eb1:	83 c4 18             	add    $0x18,%esp
}
  802eb4:	c9                   	leave  
  802eb5:	c3                   	ret    

00802eb6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802eb6:	55                   	push   %ebp
  802eb7:	89 e5                	mov    %esp,%ebp
  802eb9:	83 ec 04             	sub    $0x4,%esp
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ec2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ec6:	6a 00                	push   $0x0
  802ec8:	6a 00                	push   $0x0
  802eca:	6a 00                	push   $0x0
  802ecc:	6a 00                	push   $0x0
  802ece:	50                   	push   %eax
  802ecf:	6a 1f                	push   $0x1f
  802ed1:	e8 40 fc ff ff       	call   802b16 <syscall>
  802ed6:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed9:	90                   	nop
}
  802eda:	c9                   	leave  
  802edb:	c3                   	ret    

00802edc <rsttst>:
void rsttst()
{
  802edc:	55                   	push   %ebp
  802edd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802edf:	6a 00                	push   $0x0
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 21                	push   $0x21
  802eeb:	e8 26 fc ff ff       	call   802b16 <syscall>
  802ef0:	83 c4 18             	add    $0x18,%esp
	return ;
  802ef3:	90                   	nop
}
  802ef4:	c9                   	leave  
  802ef5:	c3                   	ret    

00802ef6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	8b 45 14             	mov    0x14(%ebp),%eax
  802eff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802f02:	8b 55 18             	mov    0x18(%ebp),%edx
  802f05:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f09:	52                   	push   %edx
  802f0a:	50                   	push   %eax
  802f0b:	ff 75 10             	pushl  0x10(%ebp)
  802f0e:	ff 75 0c             	pushl  0xc(%ebp)
  802f11:	ff 75 08             	pushl  0x8(%ebp)
  802f14:	6a 20                	push   $0x20
  802f16:	e8 fb fb ff ff       	call   802b16 <syscall>
  802f1b:	83 c4 18             	add    $0x18,%esp
	return ;
  802f1e:	90                   	nop
}
  802f1f:	c9                   	leave  
  802f20:	c3                   	ret    

00802f21 <chktst>:
void chktst(uint32 n)
{
  802f21:	55                   	push   %ebp
  802f22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802f24:	6a 00                	push   $0x0
  802f26:	6a 00                	push   $0x0
  802f28:	6a 00                	push   $0x0
  802f2a:	6a 00                	push   $0x0
  802f2c:	ff 75 08             	pushl  0x8(%ebp)
  802f2f:	6a 22                	push   $0x22
  802f31:	e8 e0 fb ff ff       	call   802b16 <syscall>
  802f36:	83 c4 18             	add    $0x18,%esp
	return ;
  802f39:	90                   	nop
}
  802f3a:	c9                   	leave  
  802f3b:	c3                   	ret    

00802f3c <inctst>:

void inctst()
{
  802f3c:	55                   	push   %ebp
  802f3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802f3f:	6a 00                	push   $0x0
  802f41:	6a 00                	push   $0x0
  802f43:	6a 00                	push   $0x0
  802f45:	6a 00                	push   $0x0
  802f47:	6a 00                	push   $0x0
  802f49:	6a 23                	push   $0x23
  802f4b:	e8 c6 fb ff ff       	call   802b16 <syscall>
  802f50:	83 c4 18             	add    $0x18,%esp
	return ;
  802f53:	90                   	nop
}
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    

00802f56 <gettst>:
uint32 gettst()
{
  802f56:	55                   	push   %ebp
  802f57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 24                	push   $0x24
  802f65:	e8 ac fb ff ff       	call   802b16 <syscall>
  802f6a:	83 c4 18             	add    $0x18,%esp
}
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f72:	6a 00                	push   $0x0
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 25                	push   $0x25
  802f7e:	e8 93 fb ff ff       	call   802b16 <syscall>
  802f83:	83 c4 18             	add    $0x18,%esp
  802f86:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802f8b:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802f90:	c9                   	leave  
  802f91:	c3                   	ret    

00802f92 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f92:	55                   	push   %ebp
  802f93:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	6a 00                	push   $0x0
  802fa3:	6a 00                	push   $0x0
  802fa5:	ff 75 08             	pushl  0x8(%ebp)
  802fa8:	6a 26                	push   $0x26
  802faa:	e8 67 fb ff ff       	call   802b16 <syscall>
  802faf:	83 c4 18             	add    $0x18,%esp
	return ;
  802fb2:	90                   	nop
}
  802fb3:	c9                   	leave  
  802fb4:	c3                   	ret    

00802fb5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802fb5:	55                   	push   %ebp
  802fb6:	89 e5                	mov    %esp,%ebp
  802fb8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802fb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	6a 00                	push   $0x0
  802fc7:	53                   	push   %ebx
  802fc8:	51                   	push   %ecx
  802fc9:	52                   	push   %edx
  802fca:	50                   	push   %eax
  802fcb:	6a 27                	push   $0x27
  802fcd:	e8 44 fb ff ff       	call   802b16 <syscall>
  802fd2:	83 c4 18             	add    $0x18,%esp
}
  802fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 00                	push   $0x0
  802fe9:	52                   	push   %edx
  802fea:	50                   	push   %eax
  802feb:	6a 28                	push   $0x28
  802fed:	e8 24 fb ff ff       	call   802b16 <syscall>
  802ff2:	83 c4 18             	add    $0x18,%esp
}
  802ff5:	c9                   	leave  
  802ff6:	c3                   	ret    

00802ff7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802ff7:	55                   	push   %ebp
  802ff8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802ffa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	6a 00                	push   $0x0
  803005:	51                   	push   %ecx
  803006:	ff 75 10             	pushl  0x10(%ebp)
  803009:	52                   	push   %edx
  80300a:	50                   	push   %eax
  80300b:	6a 29                	push   $0x29
  80300d:	e8 04 fb ff ff       	call   802b16 <syscall>
  803012:	83 c4 18             	add    $0x18,%esp
}
  803015:	c9                   	leave  
  803016:	c3                   	ret    

00803017 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803017:	55                   	push   %ebp
  803018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80301a:	6a 00                	push   $0x0
  80301c:	6a 00                	push   $0x0
  80301e:	ff 75 10             	pushl  0x10(%ebp)
  803021:	ff 75 0c             	pushl  0xc(%ebp)
  803024:	ff 75 08             	pushl  0x8(%ebp)
  803027:	6a 12                	push   $0x12
  803029:	e8 e8 fa ff ff       	call   802b16 <syscall>
  80302e:	83 c4 18             	add    $0x18,%esp
	return ;
  803031:	90                   	nop
}
  803032:	c9                   	leave  
  803033:	c3                   	ret    

00803034 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803034:	55                   	push   %ebp
  803035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803037:	8b 55 0c             	mov    0xc(%ebp),%edx
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	6a 00                	push   $0x0
  80303f:	6a 00                	push   $0x0
  803041:	6a 00                	push   $0x0
  803043:	52                   	push   %edx
  803044:	50                   	push   %eax
  803045:	6a 2a                	push   $0x2a
  803047:	e8 ca fa ff ff       	call   802b16 <syscall>
  80304c:	83 c4 18             	add    $0x18,%esp
	return;
  80304f:	90                   	nop
}
  803050:	c9                   	leave  
  803051:	c3                   	ret    

00803052 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803052:	55                   	push   %ebp
  803053:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803055:	6a 00                	push   $0x0
  803057:	6a 00                	push   $0x0
  803059:	6a 00                	push   $0x0
  80305b:	6a 00                	push   $0x0
  80305d:	6a 00                	push   $0x0
  80305f:	6a 2b                	push   $0x2b
  803061:	e8 b0 fa ff ff       	call   802b16 <syscall>
  803066:	83 c4 18             	add    $0x18,%esp
}
  803069:	c9                   	leave  
  80306a:	c3                   	ret    

0080306b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80306b:	55                   	push   %ebp
  80306c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	ff 75 0c             	pushl  0xc(%ebp)
  803077:	ff 75 08             	pushl  0x8(%ebp)
  80307a:	6a 2d                	push   $0x2d
  80307c:	e8 95 fa ff ff       	call   802b16 <syscall>
  803081:	83 c4 18             	add    $0x18,%esp
	return;
  803084:	90                   	nop
}
  803085:	c9                   	leave  
  803086:	c3                   	ret    

00803087 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803087:	55                   	push   %ebp
  803088:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	6a 00                	push   $0x0
  803090:	ff 75 0c             	pushl  0xc(%ebp)
  803093:	ff 75 08             	pushl  0x8(%ebp)
  803096:	6a 2c                	push   $0x2c
  803098:	e8 79 fa ff ff       	call   802b16 <syscall>
  80309d:	83 c4 18             	add    $0x18,%esp
	return ;
  8030a0:	90                   	nop
}
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
  8030a6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	68 d4 4d 80 00       	push   $0x804dd4
  8030b1:	68 25 01 00 00       	push   $0x125
  8030b6:	68 07 4e 80 00       	push   $0x804e07
  8030bb:	e8 ec e6 ff ff       	call   8017ac <_panic>

008030c0 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8030c0:	55                   	push   %ebp
  8030c1:	89 e5                	mov    %esp,%ebp
  8030c3:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8030c6:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  8030cd:	72 09                	jb     8030d8 <to_page_va+0x18>
  8030cf:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  8030d6:	72 14                	jb     8030ec <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	68 18 4e 80 00       	push   $0x804e18
  8030e0:	6a 15                	push   $0x15
  8030e2:	68 43 4e 80 00       	push   $0x804e43
  8030e7:	e8 c0 e6 ff ff       	call   8017ac <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	ba 40 52 80 00       	mov    $0x805240,%edx
  8030f4:	29 d0                	sub    %edx,%eax
  8030f6:	c1 f8 02             	sar    $0x2,%eax
  8030f9:	89 c2                	mov    %eax,%edx
  8030fb:	89 d0                	mov    %edx,%eax
  8030fd:	c1 e0 02             	shl    $0x2,%eax
  803100:	01 d0                	add    %edx,%eax
  803102:	c1 e0 02             	shl    $0x2,%eax
  803105:	01 d0                	add    %edx,%eax
  803107:	c1 e0 02             	shl    $0x2,%eax
  80310a:	01 d0                	add    %edx,%eax
  80310c:	89 c1                	mov    %eax,%ecx
  80310e:	c1 e1 08             	shl    $0x8,%ecx
  803111:	01 c8                	add    %ecx,%eax
  803113:	89 c1                	mov    %eax,%ecx
  803115:	c1 e1 10             	shl    $0x10,%ecx
  803118:	01 c8                	add    %ecx,%eax
  80311a:	01 c0                	add    %eax,%eax
  80311c:	01 d0                	add    %edx,%eax
  80311e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	c1 e0 0c             	shl    $0xc,%eax
  803127:	89 c2                	mov    %eax,%edx
  803129:	a1 48 d2 81 00       	mov    0x81d248,%eax
  80312e:	01 d0                	add    %edx,%eax
}
  803130:	c9                   	leave  
  803131:	c3                   	ret    

00803132 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803132:	55                   	push   %ebp
  803133:	89 e5                	mov    %esp,%ebp
  803135:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803138:	a1 48 d2 81 00       	mov    0x81d248,%eax
  80313d:	8b 55 08             	mov    0x8(%ebp),%edx
  803140:	29 c2                	sub    %eax,%edx
  803142:	89 d0                	mov    %edx,%eax
  803144:	c1 e8 0c             	shr    $0xc,%eax
  803147:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80314a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314e:	78 09                	js     803159 <to_page_info+0x27>
  803150:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803157:	7e 14                	jle    80316d <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803159:	83 ec 04             	sub    $0x4,%esp
  80315c:	68 5c 4e 80 00       	push   $0x804e5c
  803161:	6a 22                	push   $0x22
  803163:	68 43 4e 80 00       	push   $0x804e43
  803168:	e8 3f e6 ff ff       	call   8017ac <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80316d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803170:	89 d0                	mov    %edx,%eax
  803172:	01 c0                	add    %eax,%eax
  803174:	01 d0                	add    %edx,%eax
  803176:	c1 e0 02             	shl    $0x2,%eax
  803179:	05 40 52 80 00       	add    $0x805240,%eax
}
  80317e:	c9                   	leave  
  80317f:	c3                   	ret    

00803180 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803180:	55                   	push   %ebp
  803181:	89 e5                	mov    %esp,%ebp
  803183:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	05 00 00 00 02       	add    $0x2000000,%eax
  80318e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803191:	73 16                	jae    8031a9 <initialize_dynamic_allocator+0x29>
  803193:	68 80 4e 80 00       	push   $0x804e80
  803198:	68 a6 4e 80 00       	push   $0x804ea6
  80319d:	6a 34                	push   $0x34
  80319f:	68 43 4e 80 00       	push   $0x804e43
  8031a4:	e8 03 e6 ff ff       	call   8017ac <_panic>
		is_initialized = 1;
  8031a9:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  8031b0:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  8031bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031be:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  8031c3:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  8031ca:	00 00 00 
  8031cd:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  8031d4:	00 00 00 
  8031d7:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  8031de:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  8031e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e4:	2b 45 08             	sub    0x8(%ebp),%eax
  8031e7:	c1 e8 0c             	shr    $0xc,%eax
  8031ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8031ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031f4:	e9 c8 00 00 00       	jmp    8032c1 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  8031f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031fc:	89 d0                	mov    %edx,%eax
  8031fe:	01 c0                	add    %eax,%eax
  803200:	01 d0                	add    %edx,%eax
  803202:	c1 e0 02             	shl    $0x2,%eax
  803205:	05 48 52 80 00       	add    $0x805248,%eax
  80320a:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80320f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803212:	89 d0                	mov    %edx,%eax
  803214:	01 c0                	add    %eax,%eax
  803216:	01 d0                	add    %edx,%eax
  803218:	c1 e0 02             	shl    $0x2,%eax
  80321b:	05 4a 52 80 00       	add    $0x80524a,%eax
  803220:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803225:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  80322b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80322e:	89 c8                	mov    %ecx,%eax
  803230:	01 c0                	add    %eax,%eax
  803232:	01 c8                	add    %ecx,%eax
  803234:	c1 e0 02             	shl    $0x2,%eax
  803237:	05 44 52 80 00       	add    $0x805244,%eax
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803241:	89 d0                	mov    %edx,%eax
  803243:	01 c0                	add    %eax,%eax
  803245:	01 d0                	add    %edx,%eax
  803247:	c1 e0 02             	shl    $0x2,%eax
  80324a:	05 44 52 80 00       	add    $0x805244,%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	85 c0                	test   %eax,%eax
  803253:	74 1b                	je     803270 <initialize_dynamic_allocator+0xf0>
  803255:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  80325b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80325e:	89 c8                	mov    %ecx,%eax
  803260:	01 c0                	add    %eax,%eax
  803262:	01 c8                	add    %ecx,%eax
  803264:	c1 e0 02             	shl    $0x2,%eax
  803267:	05 40 52 80 00       	add    $0x805240,%eax
  80326c:	89 02                	mov    %eax,(%edx)
  80326e:	eb 16                	jmp    803286 <initialize_dynamic_allocator+0x106>
  803270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803273:	89 d0                	mov    %edx,%eax
  803275:	01 c0                	add    %eax,%eax
  803277:	01 d0                	add    %edx,%eax
  803279:	c1 e0 02             	shl    $0x2,%eax
  80327c:	05 40 52 80 00       	add    $0x805240,%eax
  803281:	a3 28 52 80 00       	mov    %eax,0x805228
  803286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803289:	89 d0                	mov    %edx,%eax
  80328b:	01 c0                	add    %eax,%eax
  80328d:	01 d0                	add    %edx,%eax
  80328f:	c1 e0 02             	shl    $0x2,%eax
  803292:	05 40 52 80 00       	add    $0x805240,%eax
  803297:	a3 2c 52 80 00       	mov    %eax,0x80522c
  80329c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329f:	89 d0                	mov    %edx,%eax
  8032a1:	01 c0                	add    %eax,%eax
  8032a3:	01 d0                	add    %edx,%eax
  8032a5:	c1 e0 02             	shl    $0x2,%eax
  8032a8:	05 40 52 80 00       	add    $0x805240,%eax
  8032ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b3:	a1 34 52 80 00       	mov    0x805234,%eax
  8032b8:	40                   	inc    %eax
  8032b9:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8032be:	ff 45 f4             	incl   -0xc(%ebp)
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8032c7:	0f 8c 2c ff ff ff    	jl     8031f9 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8032cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032d4:	eb 36                	jmp    80330c <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8032d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d9:	c1 e0 04             	shl    $0x4,%eax
  8032dc:	05 60 d2 81 00       	add    $0x81d260,%eax
  8032e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ea:	c1 e0 04             	shl    $0x4,%eax
  8032ed:	05 64 d2 81 00       	add    $0x81d264,%eax
  8032f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fb:	c1 e0 04             	shl    $0x4,%eax
  8032fe:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803303:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803309:	ff 45 f0             	incl   -0x10(%ebp)
  80330c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803310:	7e c4                	jle    8032d6 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803312:	90                   	nop
  803313:	c9                   	leave  
  803314:	c3                   	ret    

00803315 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803315:	55                   	push   %ebp
  803316:	89 e5                	mov    %esp,%ebp
  803318:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	83 ec 0c             	sub    $0xc,%esp
  803321:	50                   	push   %eax
  803322:	e8 0b fe ff ff       	call   803132 <to_page_info>
  803327:	83 c4 10             	add    $0x10,%esp
  80332a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	8b 40 08             	mov    0x8(%eax),%eax
  803333:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803336:	c9                   	leave  
  803337:	c3                   	ret    

00803338 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
  80333b:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  80333e:	83 ec 0c             	sub    $0xc,%esp
  803341:	ff 75 0c             	pushl  0xc(%ebp)
  803344:	e8 77 fd ff ff       	call   8030c0 <to_page_va>
  803349:	83 c4 10             	add    $0x10,%esp
  80334c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80334f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803354:	ba 00 00 00 00       	mov    $0x0,%edx
  803359:	f7 75 08             	divl   0x8(%ebp)
  80335c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803362:	83 ec 0c             	sub    $0xc,%esp
  803365:	50                   	push   %eax
  803366:	e8 48 f6 ff ff       	call   8029b3 <get_page>
  80336b:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  80336e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803371:	8b 55 0c             	mov    0xc(%ebp),%edx
  803374:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80337e:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  803382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803389:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803390:	eb 19                	jmp    8033ab <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  803392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803395:	ba 01 00 00 00       	mov    $0x1,%edx
  80339a:	88 c1                	mov    %al,%cl
  80339c:	d3 e2                	shl    %cl,%edx
  80339e:	89 d0                	mov    %edx,%eax
  8033a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a3:	74 0e                	je     8033b3 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8033a5:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8033a8:	ff 45 f0             	incl   -0x10(%ebp)
  8033ab:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8033af:	7e e1                	jle    803392 <split_page_to_blocks+0x5a>
  8033b1:	eb 01                	jmp    8033b4 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8033b3:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8033b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8033bb:	e9 a7 00 00 00       	jmp    803467 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c3:	0f af 45 08          	imul   0x8(%ebp),%eax
  8033c7:	89 c2                	mov    %eax,%edx
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	01 d0                	add    %edx,%eax
  8033ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8033d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033d5:	75 14                	jne    8033eb <split_page_to_blocks+0xb3>
  8033d7:	83 ec 04             	sub    $0x4,%esp
  8033da:	68 bc 4e 80 00       	push   $0x804ebc
  8033df:	6a 7c                	push   $0x7c
  8033e1:	68 43 4e 80 00       	push   $0x804e43
  8033e6:	e8 c1 e3 ff ff       	call   8017ac <_panic>
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	c1 e0 04             	shl    $0x4,%eax
  8033f1:	05 64 d2 81 00       	add    $0x81d264,%eax
  8033f6:	8b 10                	mov    (%eax),%edx
  8033f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033fb:	89 50 04             	mov    %edx,0x4(%eax)
  8033fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803401:	8b 40 04             	mov    0x4(%eax),%eax
  803404:	85 c0                	test   %eax,%eax
  803406:	74 14                	je     80341c <split_page_to_blocks+0xe4>
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	c1 e0 04             	shl    $0x4,%eax
  80340e:	05 64 d2 81 00       	add    $0x81d264,%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803418:	89 10                	mov    %edx,(%eax)
  80341a:	eb 11                	jmp    80342d <split_page_to_blocks+0xf5>
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	c1 e0 04             	shl    $0x4,%eax
  803422:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  803428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342b:	89 02                	mov    %eax,(%edx)
  80342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803430:	c1 e0 04             	shl    $0x4,%eax
  803433:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  803439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80343c:	89 02                	mov    %eax,(%edx)
  80343e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344a:	c1 e0 04             	shl    $0x4,%eax
  80344d:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	8d 50 01             	lea    0x1(%eax),%edx
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	c1 e0 04             	shl    $0x4,%eax
  80345d:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803462:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  803464:	ff 45 ec             	incl   -0x14(%ebp)
  803467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80346d:	0f 82 4d ff ff ff    	jb     8033c0 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  803473:	90                   	nop
  803474:	c9                   	leave  
  803475:	c3                   	ret    

00803476 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803476:	55                   	push   %ebp
  803477:	89 e5                	mov    %esp,%ebp
  803479:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80347c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803483:	76 19                	jbe    80349e <alloc_block+0x28>
  803485:	68 e0 4e 80 00       	push   $0x804ee0
  80348a:	68 a6 4e 80 00       	push   $0x804ea6
  80348f:	68 8a 00 00 00       	push   $0x8a
  803494:	68 43 4e 80 00       	push   $0x804e43
  803499:	e8 0e e3 ff ff       	call   8017ac <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  80349e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8034a5:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8034ac:	eb 19                	jmp    8034c7 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8034ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b1:	ba 01 00 00 00       	mov    $0x1,%edx
  8034b6:	88 c1                	mov    %al,%cl
  8034b8:	d3 e2                	shl    %cl,%edx
  8034ba:	89 d0                	mov    %edx,%eax
  8034bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034bf:	73 0e                	jae    8034cf <alloc_block+0x59>
		idx++;
  8034c1:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8034c4:	ff 45 f0             	incl   -0x10(%ebp)
  8034c7:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8034cb:	7e e1                	jle    8034ae <alloc_block+0x38>
  8034cd:	eb 01                	jmp    8034d0 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8034cf:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d3:	c1 e0 04             	shl    $0x4,%eax
  8034d6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	0f 84 df 00 00 00    	je     8035c4 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	c1 e0 04             	shl    $0x4,%eax
  8034eb:	05 60 d2 81 00       	add    $0x81d260,%eax
  8034f0:	8b 00                	mov    (%eax),%eax
  8034f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8034f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034f9:	75 17                	jne    803512 <alloc_block+0x9c>
  8034fb:	83 ec 04             	sub    $0x4,%esp
  8034fe:	68 01 4f 80 00       	push   $0x804f01
  803503:	68 9e 00 00 00       	push   $0x9e
  803508:	68 43 4e 80 00       	push   $0x804e43
  80350d:	e8 9a e2 ff ff       	call   8017ac <_panic>
  803512:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803515:	8b 00                	mov    (%eax),%eax
  803517:	85 c0                	test   %eax,%eax
  803519:	74 10                	je     80352b <alloc_block+0xb5>
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803523:	8b 52 04             	mov    0x4(%edx),%edx
  803526:	89 50 04             	mov    %edx,0x4(%eax)
  803529:	eb 14                	jmp    80353f <alloc_block+0xc9>
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	8b 40 04             	mov    0x4(%eax),%eax
  803531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803534:	c1 e2 04             	shl    $0x4,%edx
  803537:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80353d:	89 02                	mov    %eax,(%edx)
  80353f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803542:	8b 40 04             	mov    0x4(%eax),%eax
  803545:	85 c0                	test   %eax,%eax
  803547:	74 0f                	je     803558 <alloc_block+0xe2>
  803549:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354c:	8b 40 04             	mov    0x4(%eax),%eax
  80354f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803552:	8b 12                	mov    (%edx),%edx
  803554:	89 10                	mov    %edx,(%eax)
  803556:	eb 13                	jmp    80356b <alloc_block+0xf5>
  803558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355b:	8b 00                	mov    (%eax),%eax
  80355d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803560:	c1 e2 04             	shl    $0x4,%edx
  803563:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803569:	89 02                	mov    %eax,(%edx)
  80356b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803577:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	c1 e0 04             	shl    $0x4,%eax
  803584:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	c1 e0 04             	shl    $0x4,%eax
  803594:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803599:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80359b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359e:	83 ec 0c             	sub    $0xc,%esp
  8035a1:	50                   	push   %eax
  8035a2:	e8 8b fb ff ff       	call   803132 <to_page_info>
  8035a7:	83 c4 10             	add    $0x10,%esp
  8035aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8035ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8035b4:	48                   	dec    %eax
  8035b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035b8:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8035bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bf:	e9 bc 02 00 00       	jmp    803880 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8035c4:	a1 34 52 80 00       	mov    0x805234,%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	0f 84 7d 02 00 00    	je     80384e <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8035d1:	a1 28 52 80 00       	mov    0x805228,%eax
  8035d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8035d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035dd:	75 17                	jne    8035f6 <alloc_block+0x180>
  8035df:	83 ec 04             	sub    $0x4,%esp
  8035e2:	68 01 4f 80 00       	push   $0x804f01
  8035e7:	68 a9 00 00 00       	push   $0xa9
  8035ec:	68 43 4e 80 00       	push   $0x804e43
  8035f1:	e8 b6 e1 ff ff       	call   8017ac <_panic>
  8035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f9:	8b 00                	mov    (%eax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	74 10                	je     80360f <alloc_block+0x199>
  8035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803607:	8b 52 04             	mov    0x4(%edx),%edx
  80360a:	89 50 04             	mov    %edx,0x4(%eax)
  80360d:	eb 0b                	jmp    80361a <alloc_block+0x1a4>
  80360f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803612:	8b 40 04             	mov    0x4(%eax),%eax
  803615:	a3 2c 52 80 00       	mov    %eax,0x80522c
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	8b 40 04             	mov    0x4(%eax),%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	74 0f                	je     803633 <alloc_block+0x1bd>
  803624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803627:	8b 40 04             	mov    0x4(%eax),%eax
  80362a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80362d:	8b 12                	mov    (%edx),%edx
  80362f:	89 10                	mov    %edx,(%eax)
  803631:	eb 0a                	jmp    80363d <alloc_block+0x1c7>
  803633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	a3 28 52 80 00       	mov    %eax,0x805228
  80363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803649:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803650:	a1 34 52 80 00       	mov    0x805234,%eax
  803655:	48                   	dec    %eax
  803656:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80365b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365e:	83 c0 03             	add    $0x3,%eax
  803661:	ba 01 00 00 00       	mov    $0x1,%edx
  803666:	88 c1                	mov    %al,%cl
  803668:	d3 e2                	shl    %cl,%edx
  80366a:	89 d0                	mov    %edx,%eax
  80366c:	83 ec 08             	sub    $0x8,%esp
  80366f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803672:	50                   	push   %eax
  803673:	e8 c0 fc ff ff       	call   803338 <split_page_to_blocks>
  803678:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367e:	c1 e0 04             	shl    $0x4,%eax
  803681:	05 60 d2 81 00       	add    $0x81d260,%eax
  803686:	8b 00                	mov    (%eax),%eax
  803688:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80368b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80368f:	75 17                	jne    8036a8 <alloc_block+0x232>
  803691:	83 ec 04             	sub    $0x4,%esp
  803694:	68 01 4f 80 00       	push   $0x804f01
  803699:	68 b0 00 00 00       	push   $0xb0
  80369e:	68 43 4e 80 00       	push   $0x804e43
  8036a3:	e8 04 e1 ff ff       	call   8017ac <_panic>
  8036a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	74 10                	je     8036c1 <alloc_block+0x24b>
  8036b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036b9:	8b 52 04             	mov    0x4(%edx),%edx
  8036bc:	89 50 04             	mov    %edx,0x4(%eax)
  8036bf:	eb 14                	jmp    8036d5 <alloc_block+0x25f>
  8036c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c4:	8b 40 04             	mov    0x4(%eax),%eax
  8036c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ca:	c1 e2 04             	shl    $0x4,%edx
  8036cd:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8036d3:	89 02                	mov    %eax,(%edx)
  8036d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d8:	8b 40 04             	mov    0x4(%eax),%eax
  8036db:	85 c0                	test   %eax,%eax
  8036dd:	74 0f                	je     8036ee <alloc_block+0x278>
  8036df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036e2:	8b 40 04             	mov    0x4(%eax),%eax
  8036e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036e8:	8b 12                	mov    (%edx),%edx
  8036ea:	89 10                	mov    %edx,(%eax)
  8036ec:	eb 13                	jmp    803701 <alloc_block+0x28b>
  8036ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f1:	8b 00                	mov    (%eax),%eax
  8036f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f6:	c1 e2 04             	shl    $0x4,%edx
  8036f9:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8036ff:	89 02                	mov    %eax,(%edx)
  803701:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80370d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803717:	c1 e0 04             	shl    $0x4,%eax
  80371a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80371f:	8b 00                	mov    (%eax),%eax
  803721:	8d 50 ff             	lea    -0x1(%eax),%edx
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	c1 e0 04             	shl    $0x4,%eax
  80372a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80372f:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803731:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803734:	83 ec 0c             	sub    $0xc,%esp
  803737:	50                   	push   %eax
  803738:	e8 f5 f9 ff ff       	call   803132 <to_page_info>
  80373d:	83 c4 10             	add    $0x10,%esp
  803740:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  803743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803746:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80374a:	48                   	dec    %eax
  80374b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80374e:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803752:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803755:	e9 26 01 00 00       	jmp    803880 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80375a:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	c1 e0 04             	shl    $0x4,%eax
  803763:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803768:	8b 00                	mov    (%eax),%eax
  80376a:	85 c0                	test   %eax,%eax
  80376c:	0f 84 dc 00 00 00    	je     80384e <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803775:	c1 e0 04             	shl    $0x4,%eax
  803778:	05 60 d2 81 00       	add    $0x81d260,%eax
  80377d:	8b 00                	mov    (%eax),%eax
  80377f:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  803782:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803786:	75 17                	jne    80379f <alloc_block+0x329>
  803788:	83 ec 04             	sub    $0x4,%esp
  80378b:	68 01 4f 80 00       	push   $0x804f01
  803790:	68 be 00 00 00       	push   $0xbe
  803795:	68 43 4e 80 00       	push   $0x804e43
  80379a:	e8 0d e0 ff ff       	call   8017ac <_panic>
  80379f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037a2:	8b 00                	mov    (%eax),%eax
  8037a4:	85 c0                	test   %eax,%eax
  8037a6:	74 10                	je     8037b8 <alloc_block+0x342>
  8037a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037b0:	8b 52 04             	mov    0x4(%edx),%edx
  8037b3:	89 50 04             	mov    %edx,0x4(%eax)
  8037b6:	eb 14                	jmp    8037cc <alloc_block+0x356>
  8037b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037bb:	8b 40 04             	mov    0x4(%eax),%eax
  8037be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c1:	c1 e2 04             	shl    $0x4,%edx
  8037c4:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8037ca:	89 02                	mov    %eax,(%edx)
  8037cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037cf:	8b 40 04             	mov    0x4(%eax),%eax
  8037d2:	85 c0                	test   %eax,%eax
  8037d4:	74 0f                	je     8037e5 <alloc_block+0x36f>
  8037d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037d9:	8b 40 04             	mov    0x4(%eax),%eax
  8037dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037df:	8b 12                	mov    (%edx),%edx
  8037e1:	89 10                	mov    %edx,(%eax)
  8037e3:	eb 13                	jmp    8037f8 <alloc_block+0x382>
  8037e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037e8:	8b 00                	mov    (%eax),%eax
  8037ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037ed:	c1 e2 04             	shl    $0x4,%edx
  8037f0:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8037f6:	89 02                	mov    %eax,(%edx)
  8037f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803801:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803804:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380e:	c1 e0 04             	shl    $0x4,%eax
  803811:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	8d 50 ff             	lea    -0x1(%eax),%edx
  80381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381e:	c1 e0 04             	shl    $0x4,%eax
  803821:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803826:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80382b:	83 ec 0c             	sub    $0xc,%esp
  80382e:	50                   	push   %eax
  80382f:	e8 fe f8 ff ff       	call   803132 <to_page_info>
  803834:	83 c4 10             	add    $0x10,%esp
  803837:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80383a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803841:	48                   	dec    %eax
  803842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803845:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80384c:	eb 32                	jmp    803880 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80384e:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803852:	77 15                	ja     803869 <alloc_block+0x3f3>
  803854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803857:	c1 e0 04             	shl    $0x4,%eax
  80385a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80385f:	8b 00                	mov    (%eax),%eax
  803861:	85 c0                	test   %eax,%eax
  803863:	0f 84 f1 fe ff ff    	je     80375a <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  803869:	83 ec 04             	sub    $0x4,%esp
  80386c:	68 1f 4f 80 00       	push   $0x804f1f
  803871:	68 c8 00 00 00       	push   $0xc8
  803876:	68 43 4e 80 00       	push   $0x804e43
  80387b:	e8 2c df ff ff       	call   8017ac <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  803880:	c9                   	leave  
  803881:	c3                   	ret    

00803882 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803882:	55                   	push   %ebp
  803883:	89 e5                	mov    %esp,%ebp
  803885:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803888:	8b 55 08             	mov    0x8(%ebp),%edx
  80388b:	a1 48 d2 81 00       	mov    0x81d248,%eax
  803890:	39 c2                	cmp    %eax,%edx
  803892:	72 0c                	jb     8038a0 <free_block+0x1e>
  803894:	8b 55 08             	mov    0x8(%ebp),%edx
  803897:	a1 20 52 80 00       	mov    0x805220,%eax
  80389c:	39 c2                	cmp    %eax,%edx
  80389e:	72 19                	jb     8038b9 <free_block+0x37>
  8038a0:	68 30 4f 80 00       	push   $0x804f30
  8038a5:	68 a6 4e 80 00       	push   $0x804ea6
  8038aa:	68 d7 00 00 00       	push   $0xd7
  8038af:	68 43 4e 80 00       	push   $0x804e43
  8038b4:	e8 f3 de ff ff       	call   8017ac <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	83 ec 0c             	sub    $0xc,%esp
  8038c5:	50                   	push   %eax
  8038c6:	e8 67 f8 ff ff       	call   803132 <to_page_info>
  8038cb:	83 c4 10             	add    $0x10,%esp
  8038ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8038d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d4:	8b 40 08             	mov    0x8(%eax),%eax
  8038d7:	0f b7 c0             	movzwl %ax,%eax
  8038da:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8038dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8038e4:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8038eb:	eb 19                	jmp    803906 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8038ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f0:	ba 01 00 00 00       	mov    $0x1,%edx
  8038f5:	88 c1                	mov    %al,%cl
  8038f7:	d3 e2                	shl    %cl,%edx
  8038f9:	89 d0                	mov    %edx,%eax
  8038fb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038fe:	74 0e                	je     80390e <free_block+0x8c>
	        break;
	    idx++;
  803900:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803903:	ff 45 f0             	incl   -0x10(%ebp)
  803906:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80390a:	7e e1                	jle    8038ed <free_block+0x6b>
  80390c:	eb 01                	jmp    80390f <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  80390e:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  80390f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803912:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803916:	40                   	inc    %eax
  803917:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80391a:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  80391e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803922:	75 17                	jne    80393b <free_block+0xb9>
  803924:	83 ec 04             	sub    $0x4,%esp
  803927:	68 bc 4e 80 00       	push   $0x804ebc
  80392c:	68 ee 00 00 00       	push   $0xee
  803931:	68 43 4e 80 00       	push   $0x804e43
  803936:	e8 71 de ff ff       	call   8017ac <_panic>
  80393b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393e:	c1 e0 04             	shl    $0x4,%eax
  803941:	05 64 d2 81 00       	add    $0x81d264,%eax
  803946:	8b 10                	mov    (%eax),%edx
  803948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394b:	89 50 04             	mov    %edx,0x4(%eax)
  80394e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803951:	8b 40 04             	mov    0x4(%eax),%eax
  803954:	85 c0                	test   %eax,%eax
  803956:	74 14                	je     80396c <free_block+0xea>
  803958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395b:	c1 e0 04             	shl    $0x4,%eax
  80395e:	05 64 d2 81 00       	add    $0x81d264,%eax
  803963:	8b 00                	mov    (%eax),%eax
  803965:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803968:	89 10                	mov    %edx,(%eax)
  80396a:	eb 11                	jmp    80397d <free_block+0xfb>
  80396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396f:	c1 e0 04             	shl    $0x4,%eax
  803972:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  803978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397b:	89 02                	mov    %eax,(%edx)
  80397d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803980:	c1 e0 04             	shl    $0x4,%eax
  803983:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  803989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398c:	89 02                	mov    %eax,(%edx)
  80398e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399a:	c1 e0 04             	shl    $0x4,%eax
  80399d:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8039a2:	8b 00                	mov    (%eax),%eax
  8039a4:	8d 50 01             	lea    0x1(%eax),%edx
  8039a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039aa:	c1 e0 04             	shl    $0x4,%eax
  8039ad:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8039b2:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8039b4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8039be:	f7 75 e0             	divl   -0x20(%ebp)
  8039c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8039c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8039cb:	0f b7 c0             	movzwl %ax,%eax
  8039ce:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8039d1:	0f 85 70 01 00 00    	jne    803b47 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8039d7:	83 ec 0c             	sub    $0xc,%esp
  8039da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039dd:	e8 de f6 ff ff       	call   8030c0 <to_page_va>
  8039e2:	83 c4 10             	add    $0x10,%esp
  8039e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8039e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8039ef:	e9 b7 00 00 00       	jmp    803aab <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8039f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039fa:	01 d0                	add    %edx,%eax
  8039fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8039ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a03:	75 17                	jne    803a1c <free_block+0x19a>
  803a05:	83 ec 04             	sub    $0x4,%esp
  803a08:	68 01 4f 80 00       	push   $0x804f01
  803a0d:	68 f8 00 00 00       	push   $0xf8
  803a12:	68 43 4e 80 00       	push   $0x804e43
  803a17:	e8 90 dd ff ff       	call   8017ac <_panic>
  803a1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a1f:	8b 00                	mov    (%eax),%eax
  803a21:	85 c0                	test   %eax,%eax
  803a23:	74 10                	je     803a35 <free_block+0x1b3>
  803a25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a28:	8b 00                	mov    (%eax),%eax
  803a2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a2d:	8b 52 04             	mov    0x4(%edx),%edx
  803a30:	89 50 04             	mov    %edx,0x4(%eax)
  803a33:	eb 14                	jmp    803a49 <free_block+0x1c7>
  803a35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a38:	8b 40 04             	mov    0x4(%eax),%eax
  803a3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a3e:	c1 e2 04             	shl    $0x4,%edx
  803a41:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803a47:	89 02                	mov    %eax,(%edx)
  803a49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4c:	8b 40 04             	mov    0x4(%eax),%eax
  803a4f:	85 c0                	test   %eax,%eax
  803a51:	74 0f                	je     803a62 <free_block+0x1e0>
  803a53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a56:	8b 40 04             	mov    0x4(%eax),%eax
  803a59:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a5c:	8b 12                	mov    (%edx),%edx
  803a5e:	89 10                	mov    %edx,(%eax)
  803a60:	eb 13                	jmp    803a75 <free_block+0x1f3>
  803a62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a6a:	c1 e2 04             	shl    $0x4,%edx
  803a6d:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803a73:	89 02                	mov    %eax,(%edx)
  803a75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8b:	c1 e0 04             	shl    $0x4,%eax
  803a8e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803a93:	8b 00                	mov    (%eax),%eax
  803a95:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9b:	c1 e0 04             	shl    $0x4,%eax
  803a9e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803aa3:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aa8:	01 45 ec             	add    %eax,-0x14(%ebp)
  803aab:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803ab2:	0f 86 3c ff ff ff    	jbe    8039f4 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  803ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abb:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac4:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803aca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ace:	75 17                	jne    803ae7 <free_block+0x265>
  803ad0:	83 ec 04             	sub    $0x4,%esp
  803ad3:	68 bc 4e 80 00       	push   $0x804ebc
  803ad8:	68 fe 00 00 00       	push   $0xfe
  803add:	68 43 4e 80 00       	push   $0x804e43
  803ae2:	e8 c5 dc ff ff       	call   8017ac <_panic>
  803ae7:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af0:	89 50 04             	mov    %edx,0x4(%eax)
  803af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af6:	8b 40 04             	mov    0x4(%eax),%eax
  803af9:	85 c0                	test   %eax,%eax
  803afb:	74 0c                	je     803b09 <free_block+0x287>
  803afd:	a1 2c 52 80 00       	mov    0x80522c,%eax
  803b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b05:	89 10                	mov    %edx,(%eax)
  803b07:	eb 08                	jmp    803b11 <free_block+0x28f>
  803b09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0c:	a3 28 52 80 00       	mov    %eax,0x805228
  803b11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b14:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b22:	a1 34 52 80 00       	mov    0x805234,%eax
  803b27:	40                   	inc    %eax
  803b28:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803b2d:	83 ec 0c             	sub    $0xc,%esp
  803b30:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b33:	e8 88 f5 ff ff       	call   8030c0 <to_page_va>
  803b38:	83 c4 10             	add    $0x10,%esp
  803b3b:	83 ec 0c             	sub    $0xc,%esp
  803b3e:	50                   	push   %eax
  803b3f:	e8 b8 ee ff ff       	call   8029fc <return_page>
  803b44:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803b47:	90                   	nop
  803b48:	c9                   	leave  
  803b49:	c3                   	ret    

00803b4a <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803b4a:	55                   	push   %ebp
  803b4b:	89 e5                	mov    %esp,%ebp
  803b4d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803b50:	83 ec 04             	sub    $0x4,%esp
  803b53:	68 68 4f 80 00       	push   $0x804f68
  803b58:	68 11 01 00 00       	push   $0x111
  803b5d:	68 43 4e 80 00       	push   $0x804e43
  803b62:	e8 45 dc ff ff       	call   8017ac <_panic>
  803b67:	90                   	nop

00803b68 <__udivdi3>:
  803b68:	55                   	push   %ebp
  803b69:	57                   	push   %edi
  803b6a:	56                   	push   %esi
  803b6b:	53                   	push   %ebx
  803b6c:	83 ec 1c             	sub    $0x1c,%esp
  803b6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b7f:	89 ca                	mov    %ecx,%edx
  803b81:	89 f8                	mov    %edi,%eax
  803b83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b87:	85 f6                	test   %esi,%esi
  803b89:	75 2d                	jne    803bb8 <__udivdi3+0x50>
  803b8b:	39 cf                	cmp    %ecx,%edi
  803b8d:	77 65                	ja     803bf4 <__udivdi3+0x8c>
  803b8f:	89 fd                	mov    %edi,%ebp
  803b91:	85 ff                	test   %edi,%edi
  803b93:	75 0b                	jne    803ba0 <__udivdi3+0x38>
  803b95:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9a:	31 d2                	xor    %edx,%edx
  803b9c:	f7 f7                	div    %edi
  803b9e:	89 c5                	mov    %eax,%ebp
  803ba0:	31 d2                	xor    %edx,%edx
  803ba2:	89 c8                	mov    %ecx,%eax
  803ba4:	f7 f5                	div    %ebp
  803ba6:	89 c1                	mov    %eax,%ecx
  803ba8:	89 d8                	mov    %ebx,%eax
  803baa:	f7 f5                	div    %ebp
  803bac:	89 cf                	mov    %ecx,%edi
  803bae:	89 fa                	mov    %edi,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	39 ce                	cmp    %ecx,%esi
  803bba:	77 28                	ja     803be4 <__udivdi3+0x7c>
  803bbc:	0f bd fe             	bsr    %esi,%edi
  803bbf:	83 f7 1f             	xor    $0x1f,%edi
  803bc2:	75 40                	jne    803c04 <__udivdi3+0x9c>
  803bc4:	39 ce                	cmp    %ecx,%esi
  803bc6:	72 0a                	jb     803bd2 <__udivdi3+0x6a>
  803bc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bcc:	0f 87 9e 00 00 00    	ja     803c70 <__udivdi3+0x108>
  803bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd7:	89 fa                	mov    %edi,%edx
  803bd9:	83 c4 1c             	add    $0x1c,%esp
  803bdc:	5b                   	pop    %ebx
  803bdd:	5e                   	pop    %esi
  803bde:	5f                   	pop    %edi
  803bdf:	5d                   	pop    %ebp
  803be0:	c3                   	ret    
  803be1:	8d 76 00             	lea    0x0(%esi),%esi
  803be4:	31 ff                	xor    %edi,%edi
  803be6:	31 c0                	xor    %eax,%eax
  803be8:	89 fa                	mov    %edi,%edx
  803bea:	83 c4 1c             	add    $0x1c,%esp
  803bed:	5b                   	pop    %ebx
  803bee:	5e                   	pop    %esi
  803bef:	5f                   	pop    %edi
  803bf0:	5d                   	pop    %ebp
  803bf1:	c3                   	ret    
  803bf2:	66 90                	xchg   %ax,%ax
  803bf4:	89 d8                	mov    %ebx,%eax
  803bf6:	f7 f7                	div    %edi
  803bf8:	31 ff                	xor    %edi,%edi
  803bfa:	89 fa                	mov    %edi,%edx
  803bfc:	83 c4 1c             	add    $0x1c,%esp
  803bff:	5b                   	pop    %ebx
  803c00:	5e                   	pop    %esi
  803c01:	5f                   	pop    %edi
  803c02:	5d                   	pop    %ebp
  803c03:	c3                   	ret    
  803c04:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c09:	89 eb                	mov    %ebp,%ebx
  803c0b:	29 fb                	sub    %edi,%ebx
  803c0d:	89 f9                	mov    %edi,%ecx
  803c0f:	d3 e6                	shl    %cl,%esi
  803c11:	89 c5                	mov    %eax,%ebp
  803c13:	88 d9                	mov    %bl,%cl
  803c15:	d3 ed                	shr    %cl,%ebp
  803c17:	89 e9                	mov    %ebp,%ecx
  803c19:	09 f1                	or     %esi,%ecx
  803c1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c1f:	89 f9                	mov    %edi,%ecx
  803c21:	d3 e0                	shl    %cl,%eax
  803c23:	89 c5                	mov    %eax,%ebp
  803c25:	89 d6                	mov    %edx,%esi
  803c27:	88 d9                	mov    %bl,%cl
  803c29:	d3 ee                	shr    %cl,%esi
  803c2b:	89 f9                	mov    %edi,%ecx
  803c2d:	d3 e2                	shl    %cl,%edx
  803c2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c33:	88 d9                	mov    %bl,%cl
  803c35:	d3 e8                	shr    %cl,%eax
  803c37:	09 c2                	or     %eax,%edx
  803c39:	89 d0                	mov    %edx,%eax
  803c3b:	89 f2                	mov    %esi,%edx
  803c3d:	f7 74 24 0c          	divl   0xc(%esp)
  803c41:	89 d6                	mov    %edx,%esi
  803c43:	89 c3                	mov    %eax,%ebx
  803c45:	f7 e5                	mul    %ebp
  803c47:	39 d6                	cmp    %edx,%esi
  803c49:	72 19                	jb     803c64 <__udivdi3+0xfc>
  803c4b:	74 0b                	je     803c58 <__udivdi3+0xf0>
  803c4d:	89 d8                	mov    %ebx,%eax
  803c4f:	31 ff                	xor    %edi,%edi
  803c51:	e9 58 ff ff ff       	jmp    803bae <__udivdi3+0x46>
  803c56:	66 90                	xchg   %ax,%ax
  803c58:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c5c:	89 f9                	mov    %edi,%ecx
  803c5e:	d3 e2                	shl    %cl,%edx
  803c60:	39 c2                	cmp    %eax,%edx
  803c62:	73 e9                	jae    803c4d <__udivdi3+0xe5>
  803c64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c67:	31 ff                	xor    %edi,%edi
  803c69:	e9 40 ff ff ff       	jmp    803bae <__udivdi3+0x46>
  803c6e:	66 90                	xchg   %ax,%ax
  803c70:	31 c0                	xor    %eax,%eax
  803c72:	e9 37 ff ff ff       	jmp    803bae <__udivdi3+0x46>
  803c77:	90                   	nop

00803c78 <__umoddi3>:
  803c78:	55                   	push   %ebp
  803c79:	57                   	push   %edi
  803c7a:	56                   	push   %esi
  803c7b:	53                   	push   %ebx
  803c7c:	83 ec 1c             	sub    $0x1c,%esp
  803c7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c83:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c97:	89 f3                	mov    %esi,%ebx
  803c99:	89 fa                	mov    %edi,%edx
  803c9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c9f:	89 34 24             	mov    %esi,(%esp)
  803ca2:	85 c0                	test   %eax,%eax
  803ca4:	75 1a                	jne    803cc0 <__umoddi3+0x48>
  803ca6:	39 f7                	cmp    %esi,%edi
  803ca8:	0f 86 a2 00 00 00    	jbe    803d50 <__umoddi3+0xd8>
  803cae:	89 c8                	mov    %ecx,%eax
  803cb0:	89 f2                	mov    %esi,%edx
  803cb2:	f7 f7                	div    %edi
  803cb4:	89 d0                	mov    %edx,%eax
  803cb6:	31 d2                	xor    %edx,%edx
  803cb8:	83 c4 1c             	add    $0x1c,%esp
  803cbb:	5b                   	pop    %ebx
  803cbc:	5e                   	pop    %esi
  803cbd:	5f                   	pop    %edi
  803cbe:	5d                   	pop    %ebp
  803cbf:	c3                   	ret    
  803cc0:	39 f0                	cmp    %esi,%eax
  803cc2:	0f 87 ac 00 00 00    	ja     803d74 <__umoddi3+0xfc>
  803cc8:	0f bd e8             	bsr    %eax,%ebp
  803ccb:	83 f5 1f             	xor    $0x1f,%ebp
  803cce:	0f 84 ac 00 00 00    	je     803d80 <__umoddi3+0x108>
  803cd4:	bf 20 00 00 00       	mov    $0x20,%edi
  803cd9:	29 ef                	sub    %ebp,%edi
  803cdb:	89 fe                	mov    %edi,%esi
  803cdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ce1:	89 e9                	mov    %ebp,%ecx
  803ce3:	d3 e0                	shl    %cl,%eax
  803ce5:	89 d7                	mov    %edx,%edi
  803ce7:	89 f1                	mov    %esi,%ecx
  803ce9:	d3 ef                	shr    %cl,%edi
  803ceb:	09 c7                	or     %eax,%edi
  803ced:	89 e9                	mov    %ebp,%ecx
  803cef:	d3 e2                	shl    %cl,%edx
  803cf1:	89 14 24             	mov    %edx,(%esp)
  803cf4:	89 d8                	mov    %ebx,%eax
  803cf6:	d3 e0                	shl    %cl,%eax
  803cf8:	89 c2                	mov    %eax,%edx
  803cfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cfe:	d3 e0                	shl    %cl,%eax
  803d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d04:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d08:	89 f1                	mov    %esi,%ecx
  803d0a:	d3 e8                	shr    %cl,%eax
  803d0c:	09 d0                	or     %edx,%eax
  803d0e:	d3 eb                	shr    %cl,%ebx
  803d10:	89 da                	mov    %ebx,%edx
  803d12:	f7 f7                	div    %edi
  803d14:	89 d3                	mov    %edx,%ebx
  803d16:	f7 24 24             	mull   (%esp)
  803d19:	89 c6                	mov    %eax,%esi
  803d1b:	89 d1                	mov    %edx,%ecx
  803d1d:	39 d3                	cmp    %edx,%ebx
  803d1f:	0f 82 87 00 00 00    	jb     803dac <__umoddi3+0x134>
  803d25:	0f 84 91 00 00 00    	je     803dbc <__umoddi3+0x144>
  803d2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d2f:	29 f2                	sub    %esi,%edx
  803d31:	19 cb                	sbb    %ecx,%ebx
  803d33:	89 d8                	mov    %ebx,%eax
  803d35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d39:	d3 e0                	shl    %cl,%eax
  803d3b:	89 e9                	mov    %ebp,%ecx
  803d3d:	d3 ea                	shr    %cl,%edx
  803d3f:	09 d0                	or     %edx,%eax
  803d41:	89 e9                	mov    %ebp,%ecx
  803d43:	d3 eb                	shr    %cl,%ebx
  803d45:	89 da                	mov    %ebx,%edx
  803d47:	83 c4 1c             	add    $0x1c,%esp
  803d4a:	5b                   	pop    %ebx
  803d4b:	5e                   	pop    %esi
  803d4c:	5f                   	pop    %edi
  803d4d:	5d                   	pop    %ebp
  803d4e:	c3                   	ret    
  803d4f:	90                   	nop
  803d50:	89 fd                	mov    %edi,%ebp
  803d52:	85 ff                	test   %edi,%edi
  803d54:	75 0b                	jne    803d61 <__umoddi3+0xe9>
  803d56:	b8 01 00 00 00       	mov    $0x1,%eax
  803d5b:	31 d2                	xor    %edx,%edx
  803d5d:	f7 f7                	div    %edi
  803d5f:	89 c5                	mov    %eax,%ebp
  803d61:	89 f0                	mov    %esi,%eax
  803d63:	31 d2                	xor    %edx,%edx
  803d65:	f7 f5                	div    %ebp
  803d67:	89 c8                	mov    %ecx,%eax
  803d69:	f7 f5                	div    %ebp
  803d6b:	89 d0                	mov    %edx,%eax
  803d6d:	e9 44 ff ff ff       	jmp    803cb6 <__umoddi3+0x3e>
  803d72:	66 90                	xchg   %ax,%ax
  803d74:	89 c8                	mov    %ecx,%eax
  803d76:	89 f2                	mov    %esi,%edx
  803d78:	83 c4 1c             	add    $0x1c,%esp
  803d7b:	5b                   	pop    %ebx
  803d7c:	5e                   	pop    %esi
  803d7d:	5f                   	pop    %edi
  803d7e:	5d                   	pop    %ebp
  803d7f:	c3                   	ret    
  803d80:	3b 04 24             	cmp    (%esp),%eax
  803d83:	72 06                	jb     803d8b <__umoddi3+0x113>
  803d85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d89:	77 0f                	ja     803d9a <__umoddi3+0x122>
  803d8b:	89 f2                	mov    %esi,%edx
  803d8d:	29 f9                	sub    %edi,%ecx
  803d8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d93:	89 14 24             	mov    %edx,(%esp)
  803d96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d9e:	8b 14 24             	mov    (%esp),%edx
  803da1:	83 c4 1c             	add    $0x1c,%esp
  803da4:	5b                   	pop    %ebx
  803da5:	5e                   	pop    %esi
  803da6:	5f                   	pop    %edi
  803da7:	5d                   	pop    %ebp
  803da8:	c3                   	ret    
  803da9:	8d 76 00             	lea    0x0(%esi),%esi
  803dac:	2b 04 24             	sub    (%esp),%eax
  803daf:	19 fa                	sbb    %edi,%edx
  803db1:	89 d1                	mov    %edx,%ecx
  803db3:	89 c6                	mov    %eax,%esi
  803db5:	e9 71 ff ff ff       	jmp    803d2b <__umoddi3+0xb3>
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dc0:	72 ea                	jb     803dac <__umoddi3+0x134>
  803dc2:	89 d9                	mov    %ebx,%ecx
  803dc4:	e9 62 ff ff ff       	jmp    803d2b <__umoddi3+0xb3>
