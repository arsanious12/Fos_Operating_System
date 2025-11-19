
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 7b 15 00 00       	call   8015b1 <libmain>
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
  800067:	e8 7e 2b 00 00       	call   802bea <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 c1 2b 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char *byteArr;

	//Allocate the required size
	requestedSizes[index] = size ;
  800077:	8b 45 08             	mov    0x8(%ebp),%eax
  80007a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80007d:	89 14 85 60 61 80 00 	mov    %edx,0x806160(,%eax,4)
	uint32 expectedNumOfFrames = ROUNDUP(requestedSizes[index], PAGE_SIZE) / PAGE_SIZE ;
  800084:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80008b:	8b 45 08             	mov    0x8(%ebp),%eax
  80008e:	8b 14 85 60 61 80 00 	mov    0x806160(,%eax,4),%edx
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
  8000b7:	8b 04 85 60 61 80 00 	mov    0x806160(,%eax,4),%eax
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	50                   	push   %eax
  8000c2:	e8 2a 29 00 00       	call   8029f1 <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	89 c2                	mov    %eax,%edx
  8000cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cf:	89 14 85 20 60 80 00 	mov    %edx,0x806020(,%eax,4)
	}

	//Check allocation in RAM & Page File
	expectedNumOfFrames = expectedNumOfTables ;
  8000d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8000dc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000df:	e8 06 2b 00 00       	call   802bea <sys_calculate_free_frames>
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
  800125:	68 80 3d 80 00       	push   $0x803d80
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 2b 19 00 00       	call   801a5c <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 fc 2a 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 fc 3d 80 00       	push   $0x803dfc
  800150:	6a 0c                	push   $0xc
  800152:	e8 05 19 00 00       	call   801a5c <cprintf_colored>
  800157:	83 c4 10             	add    $0x10,%esp

	lastIndices[index] = (size)/sizeof(char) - 1;
  80015a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015d:	48                   	dec    %eax
  80015e:	89 c2                	mov    %eax,%edx
  800160:	8b 45 08             	mov    0x8(%ebp),%eax
  800163:	89 14 85 c0 60 80 00 	mov    %edx,0x8060c0(,%eax,4)
	if (writeData)
  80016a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016e:	0f 84 25 01 00 00    	je     800299 <allocSpaceInPageAlloc+0x240>
	{
		//Write in first & last pages
		freeFrames = sys_calculate_free_frames() ;
  800174:	e8 71 2a 00 00       	call   802bea <sys_calculate_free_frames>
  800179:	89 45 ec             	mov    %eax,-0x14(%ebp)
		byteArr = (char *) ptr_allocations[index];
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800186:	89 45 d8             	mov    %eax,-0x28(%ebp)
		byteArr[0] = maxByte ;
  800189:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018c:	c6 00 7f             	movb   $0x7f,(%eax)
		byteArr[lastIndices[index]] = maxByte ;
  80018f:	8b 45 08             	mov    0x8(%ebp),%eax
  800192:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
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
  8001b9:	e8 2c 2a 00 00       	call   802bea <sys_calculate_free_frames>
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
  8001f8:	68 74 3e 80 00       	push   $0x803e74
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 58 18 00 00       	call   801a5c <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 29 2a 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 00 3f 80 00       	push   $0x803f00
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 2b 18 00 00       	call   801a5c <cprintf_colored>
  800231:	83 c4 10             	add    $0x10,%esp

		//Check WS
		uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800242:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
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
  800270:	e8 37 2d 00 00       	call   802fac <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 78 3f 80 00       	push   $0x803f78
  80028f:	6a 0c                	push   $0xc
  800291:	e8 c6 17 00 00       	call   801a5c <cprintf_colored>
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
  8002ae:	e8 37 29 00 00       	call   802bea <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 7a 29 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 4e 27 00 00       	call   802a1f <free>
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
  8002eb:	8b 04 85 60 61 80 00 	mov    0x806160(,%eax,4),%eax
  8002f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8002f7:	76 03                	jbe    8002fc <freeSpaceInPageAlloc+0x5b>
			expectedNumOfFrames++ ;
  8002f9:	ff 45 f0             	incl   -0x10(%ebp)
	}
	//Check allocation in RAM & Page File
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8002fc:	e8 34 29 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 b0 3f 80 00       	push   $0x803fb0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 3d 17 00 00       	call   801a5c <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 c3 28 00 00       	call   802bea <sys_calculate_free_frames>
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
  800342:	68 fc 3f 80 00       	push   $0x803ffc
  800347:	6a 0c                	push   $0xc
  800349:	e8 0e 17 00 00       	call   801a5c <cprintf_colored>
  80034e:	83 c4 10             	add    $0x10,%esp

	if (isDataWritten)
  800351:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800355:	74 72                	je     8003c9 <freeSpaceInPageAlloc+0x128>
	{
		//Check WS
		char* byteArr = (char *) ptr_allocations[index];
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800367:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80036a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800372:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
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
  8003a0:	e8 07 2c 00 00       	call   802fac <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 58 40 80 00       	push   $0x804058
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 96 16 00 00       	call   801a5c <cprintf_colored>
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
  8003fb:	c7 05 40 e2 81 00 00 	movl   $0x0,0x81e240
  800402:	00 00 00 

	int eval = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool correct ;

	correct = 1;
  80040c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//Create some areas in PAGE allocators
	cprintf_colored(TEXT_cyan,"%~\n	1.1 Create some areas in PAGE allocators\n");
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	68 90 40 80 00       	push   $0x804090
  80041b:	6a 03                	push   $0x3
  80041d:	e8 3a 16 00 00       	call   801a5c <cprintf_colored>
  800422:	83 c4 10             	add    $0x10,%esp
	{
		//4 MB
		allocIndex = 0;
  800425:	c7 05 4c e2 81 00 00 	movl   $0x0,0x81e24c
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
  800481:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 2;
  80048d:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800494:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800497:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80049c:	52                   	push   %edx
  80049d:	6a 01                	push   $0x1
  80049f:	ff 75 e8             	pushl  -0x18(%ebp)
  8004a2:	50                   	push   %eax
  8004a3:	e8 b1 fb ff ff       	call   800059 <allocSpaceInPageAlloc>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8004ae:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8004b3:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8004ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8004bd:	74 2f                	je     8004ee <initial_page_allocations+0x120>
  8004bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c6:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8004cb:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  8004d2:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8004d7:	83 ec 0c             	sub    $0xc,%esp
  8004da:	52                   	push   %edx
  8004db:	ff 75 ec             	pushl  -0x14(%ebp)
  8004de:	50                   	push   %eax
  8004df:	68 c0 40 80 00       	push   $0x8040c0
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 71 15 00 00       	call   801a5c <cprintf_colored>
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
  8004ff:	c7 05 4c e2 81 00 01 	movl   $0x1,0x81e24c
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
  80055b:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 0;
  800567:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80056e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800571:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800576:	52                   	push   %edx
  800577:	6a 01                	push   $0x1
  800579:	ff 75 e8             	pushl  -0x18(%ebp)
  80057c:	50                   	push   %eax
  80057d:	e8 d7 fa ff ff       	call   800059 <allocSpaceInPageAlloc>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800588:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80058d:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800594:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800597:	74 2f                	je     8005c8 <initial_page_allocations+0x1fa>
  800599:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a0:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8005a5:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  8005ac:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	52                   	push   %edx
  8005b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	68 c0 40 80 00       	push   $0x8040c0
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 97 14 00 00       	call   801a5c <cprintf_colored>
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
  8005d9:	c7 05 4c e2 81 00 02 	movl   $0x2,0x81e24c
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
  800635:	a1 40 e2 81 00       	mov    0x81e240,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 1;
  800641:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800648:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064b:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800650:	52                   	push   %edx
  800651:	6a 01                	push   $0x1
  800653:	ff 75 e8             	pushl  -0x18(%ebp)
  800656:	50                   	push   %eax
  800657:	e8 fd f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800662:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800667:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80066e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800671:	74 2f                	je     8006a2 <initial_page_allocations+0x2d4>
  800673:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80067a:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80067f:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800686:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80068b:	83 ec 0c             	sub    $0xc,%esp
  80068e:	52                   	push   %edx
  80068f:	ff 75 ec             	pushl  -0x14(%ebp)
  800692:	50                   	push   %eax
  800693:	68 c0 40 80 00       	push   $0x8040c0
  800698:	6a 0c                	push   $0xc
  80069a:	e8 bd 13 00 00       	call   801a5c <cprintf_colored>
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
  8006b3:	c7 05 4c e2 81 00 03 	movl   $0x3,0x81e24c
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
  80070f:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800714:	01 d0                	add    %edx,%eax
  800716:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 1;
  80071b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800722:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800725:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80072a:	52                   	push   %edx
  80072b:	6a 01                	push   $0x1
  80072d:	ff 75 e8             	pushl  -0x18(%ebp)
  800730:	50                   	push   %eax
  800731:	e8 23 f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80073c:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800741:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800748:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80074b:	74 2f                	je     80077c <initial_page_allocations+0x3ae>
  80074d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800754:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800759:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800760:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800765:	83 ec 0c             	sub    $0xc,%esp
  800768:	52                   	push   %edx
  800769:	ff 75 ec             	pushl  -0x14(%ebp)
  80076c:	50                   	push   %eax
  80076d:	68 c0 40 80 00       	push   $0x8040c0
  800772:	6a 0c                	push   $0xc
  800774:	e8 e3 12 00 00       	call   801a5c <cprintf_colored>
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
  80078d:	c7 05 4c e2 81 00 04 	movl   $0x4,0x81e24c
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
  8007e9:	a1 40 e2 81 00       	mov    0x81e240,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 0;
  8007f5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8007fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007ff:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800804:	52                   	push   %edx
  800805:	6a 01                	push   $0x1
  800807:	ff 75 e8             	pushl  -0x18(%ebp)
  80080a:	50                   	push   %eax
  80080b:	e8 49 f8 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800816:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80081b:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800822:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800825:	74 2f                	je     800856 <initial_page_allocations+0x488>
  800827:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80082e:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800833:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  80083a:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80083f:	83 ec 0c             	sub    $0xc,%esp
  800842:	52                   	push   %edx
  800843:	ff 75 ec             	pushl  -0x14(%ebp)
  800846:	50                   	push   %eax
  800847:	68 c0 40 80 00       	push   $0x8040c0
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 09 12 00 00       	call   801a5c <cprintf_colored>
  800853:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800856:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80085a:	74 04                	je     800860 <initial_page_allocations+0x492>
  80085c:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800860:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 5;
  800867:	c7 05 4c e2 81 00 05 	movl   $0x5,0x81e24c
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
  8008c3:	a1 40 e2 81 00       	mov    0x81e240,%eax
  8008c8:	01 d0                	add    %edx,%eax
  8008ca:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 0;
  8008cf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8008d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008d9:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8008de:	52                   	push   %edx
  8008df:	6a 01                	push   $0x1
  8008e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e4:	50                   	push   %eax
  8008e5:	e8 6f f7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8008f0:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8008f5:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8008fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8008ff:	74 2f                	je     800930 <initial_page_allocations+0x562>
  800901:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800908:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80090d:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800914:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800919:	83 ec 0c             	sub    $0xc,%esp
  80091c:	52                   	push   %edx
  80091d:	ff 75 ec             	pushl  -0x14(%ebp)
  800920:	50                   	push   %eax
  800921:	68 c0 40 80 00       	push   $0x8040c0
  800926:	6a 0c                	push   $0xc
  800928:	e8 2f 11 00 00       	call   801a5c <cprintf_colored>
  80092d:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800930:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800934:	74 04                	je     80093a <initial_page_allocations+0x56c>
  800936:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  80093a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 6;
  800941:	c7 05 4c e2 81 00 06 	movl   $0x6,0x81e24c
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
  8009b8:	a1 40 e2 81 00       	mov    0x81e240,%eax
  8009bd:	01 d0                	add    %edx,%eax
  8009bf:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 1; //since page allocator is started 1 page after the 32MB of Block Allocator
  8009c4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8009cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009ce:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8009d3:	52                   	push   %edx
  8009d4:	6a 01                	push   $0x1
  8009d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d9:	50                   	push   %eax
  8009da:	e8 7a f6 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8009e5:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8009ea:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8009f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8009f4:	74 2f                	je     800a25 <initial_page_allocations+0x657>
  8009f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009fd:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800a02:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800a09:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800a0e:	83 ec 0c             	sub    $0xc,%esp
  800a11:	52                   	push   %edx
  800a12:	ff 75 ec             	pushl  -0x14(%ebp)
  800a15:	50                   	push   %eax
  800a16:	68 c0 40 80 00       	push   $0x8040c0
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 3a 10 00 00       	call   801a5c <cprintf_colored>
  800a22:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800a25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a29:	74 04                	je     800a2f <initial_page_allocations+0x661>
  800a2b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800a2f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 7;
  800a36:	c7 05 4c e2 81 00 07 	movl   $0x7,0x81e24c
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
  800ab6:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800abb:	01 d0                	add    %edx,%eax
  800abd:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 0;
  800ac2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ac9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800acc:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ad1:	52                   	push   %edx
  800ad2:	6a 01                	push   $0x1
  800ad4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	e8 7c f5 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800ae3:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ae8:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800aef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800af2:	74 2f                	je     800b23 <initial_page_allocations+0x755>
  800af4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800afb:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800b00:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800b07:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800b0c:	83 ec 0c             	sub    $0xc,%esp
  800b0f:	52                   	push   %edx
  800b10:	ff 75 ec             	pushl  -0x14(%ebp)
  800b13:	50                   	push   %eax
  800b14:	68 c0 40 80 00       	push   $0x8040c0
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 3c 0f 00 00       	call   801a5c <cprintf_colored>
  800b20:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b27:	74 04                	je     800b2d <initial_page_allocations+0x75f>
  800b29:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800b2d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 8;
  800b34:	c7 05 4c e2 81 00 08 	movl   $0x8,0x81e24c
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
  800bb4:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800bb9:	01 d0                	add    %edx,%eax
  800bbb:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 1;
  800bc0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800bc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800bca:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800bcf:	52                   	push   %edx
  800bd0:	6a 01                	push   $0x1
  800bd2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	e8 7e f4 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800be1:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800be6:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800bed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800bf0:	74 2f                	je     800c21 <initial_page_allocations+0x853>
  800bf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bf9:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800bfe:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800c05:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	52                   	push   %edx
  800c0e:	ff 75 ec             	pushl  -0x14(%ebp)
  800c11:	50                   	push   %eax
  800c12:	68 c0 40 80 00       	push   $0x8040c0
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 3e 0e 00 00       	call   801a5c <cprintf_colored>
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
  800c32:	c7 05 4c e2 81 00 09 	movl   $0x9,0x81e24c
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
  800cb2:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800cb7:	01 d0                	add    %edx,%eax
  800cb9:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 0;
  800cbe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800cc5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800cc8:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ccd:	52                   	push   %edx
  800cce:	6a 01                	push   $0x1
  800cd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd3:	50                   	push   %eax
  800cd4:	e8 80 f3 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800cd9:	83 c4 10             	add    $0x10,%esp
  800cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800cdf:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ce4:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800cee:	74 2f                	je     800d1f <initial_page_allocations+0x951>
  800cf0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cf7:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800cfc:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800d03:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	52                   	push   %edx
  800d0c:	ff 75 ec             	pushl  -0x14(%ebp)
  800d0f:	50                   	push   %eax
  800d10:	68 c0 40 80 00       	push   $0x8040c0
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 40 0d 00 00       	call   801a5c <cprintf_colored>
  800d1c:	83 c4 20             	add    $0x20,%esp

			//5 KB
			allocIndex = 10;
  800d1f:	c7 05 4c e2 81 00 0a 	movl   $0xa,0x81e24c
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
  800d9f:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800da4:	01 d0                	add    %edx,%eax
  800da6:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 0;
  800dab:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800db2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800db5:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800dba:	52                   	push   %edx
  800dbb:	6a 01                	push   $0x1
  800dbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc0:	50                   	push   %eax
  800dc1:	e8 93 f2 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800dcc:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800dd1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800dd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ddb:	74 2f                	je     800e0c <initial_page_allocations+0xa3e>
  800ddd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800de4:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800de9:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800df0:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	52                   	push   %edx
  800df9:	ff 75 ec             	pushl  -0x14(%ebp)
  800dfc:	50                   	push   %eax
  800dfd:	68 c0 40 80 00       	push   $0x8040c0
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 53 0c 00 00       	call   801a5c <cprintf_colored>
  800e09:	83 c4 20             	add    $0x20,%esp

			//3 KB
			allocIndex = 11;
  800e0c:	c7 05 4c e2 81 00 0b 	movl   $0xb,0x81e24c
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
  800e8c:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800e91:	01 d0                	add    %edx,%eax
  800e93:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 0;
  800e98:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800e9f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ea2:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ea7:	52                   	push   %edx
  800ea8:	6a 01                	push   $0x1
  800eaa:	ff 75 e8             	pushl  -0x18(%ebp)
  800ead:	50                   	push   %eax
  800eae:	e8 a6 f1 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800eb3:	83 c4 10             	add    $0x10,%esp
  800eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800eb9:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ebe:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800ec5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ec8:	74 2f                	je     800ef9 <initial_page_allocations+0xb2b>
  800eca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed1:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ed6:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800edd:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ee2:	83 ec 0c             	sub    $0xc,%esp
  800ee5:	52                   	push   %edx
  800ee6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ee9:	50                   	push   %eax
  800eea:	68 c0 40 80 00       	push   $0x8040c0
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 66 0b 00 00       	call   801a5c <cprintf_colored>
  800ef6:	83 c4 20             	add    $0x20,%esp

			//9 KB
			allocIndex = 12;
  800ef9:	c7 05 4c e2 81 00 0c 	movl   $0xc,0x81e24c
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
  800f79:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 0;
  800f85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800f8c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f8f:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800f94:	52                   	push   %edx
  800f95:	6a 01                	push   $0x1
  800f97:	ff 75 e8             	pushl  -0x18(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	e8 b9 f0 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800fa6:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800fab:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800fb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800fb5:	74 2f                	je     800fe6 <initial_page_allocations+0xc18>
  800fb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fbe:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800fc3:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800fca:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	52                   	push   %edx
  800fd3:	ff 75 ec             	pushl  -0x14(%ebp)
  800fd6:	50                   	push   %eax
  800fd7:	68 c0 40 80 00       	push   $0x8040c0
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 79 0a 00 00       	call   801a5c <cprintf_colored>
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
  800ffa:	68 12 41 80 00       	push   $0x804112
  800fff:	6a 03                	push   $0x3
  801001:	e8 56 0a 00 00       	call   801a5c <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c e2 81 00 0d 	movl   $0xd,0x81e24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 cb 1b 00 00       	call   802bea <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 0b 1c 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  80102a:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		uint32 restOfUHeap = (USER_HEAP_MAX - ACTUAL_PAGE_ALLOC_START) - (totalRequestedSize) ;
  801030:	a1 40 e2 81 00       	mov    0x81e240,%eax
  801035:	ba 00 f0 ff 1d       	mov    $0x1dfff000,%edx
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
		ptr_allocations[allocIndex] = malloc(restOfUHeap+1);
  801044:	8b 1d 4c e2 81 00    	mov    0x81e24c,%ebx
  80104a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  801050:	40                   	inc    %eax
  801051:	83 ec 0c             	sub    $0xc,%esp
  801054:	50                   	push   %eax
  801055:	e8 97 19 00 00       	call   8029f1 <malloc>
  80105a:	83 c4 10             	add    $0x10,%esp
  80105d:	89 04 9d 20 60 80 00 	mov    %eax,0x806020(,%ebx,4)
		if (ptr_allocations[allocIndex] != NULL) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.1 Allocating insufficient space: should return NULL\n", allocIndex); }
  801064:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801069:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  801070:	85 c0                	test   %eax,%eax
  801072:	74 1f                	je     801093 <initial_page_allocations+0xcc5>
  801074:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80107b:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801080:	83 ec 04             	sub    $0x4,%esp
  801083:	50                   	push   %eax
  801084:	68 30 41 80 00       	push   $0x804130
  801089:	6a 0c                	push   $0xc
  80108b:	e8 cc 09 00 00       	call   801a5c <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 9d 1b 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 6c 41 80 00       	push   $0x80416c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 a0 09 00 00       	call   801a5c <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 26 1b 00 00       	call   802bea <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 dc 41 80 00       	push   $0x8041dc
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 74 09 00 00       	call   801a5c <cprintf_colored>
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
  801104:	83 ec 30             	sub    $0x30,%esp
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL BLOCK ALLOCATOR OR USER
	 * BLOCK ALLOCATOR DUE TO DIFFERENT MANAGEMENT OF USER HEAP
	 *********************************************************/

	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801107:	83 ec 08             	sub    $0x8,%esp
  80110a:	68 24 42 80 00       	push   $0x804224
  80110f:	6a 0e                	push   $0xe
  801111:	e8 46 09 00 00       	call   801a5c <cprintf_colored>
  801116:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	68 58 42 80 00       	push   $0x804258
  801121:	6a 0e                	push   $0xe
  801123:	e8 34 09 00 00       	call   801a5c <cprintf_colored>
  801128:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	68 b4 42 80 00       	push   $0x8042b4
  801133:	6a 0e                	push   $0xe
  801135:	e8 22 09 00 00       	call   801a5c <cprintf_colored>
  80113a:	83 c4 10             	add    $0x10,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80113d:	a1 00 62 80 00       	mov    0x806200,%eax
  801142:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801148:	a1 00 62 80 00       	mov    0x806200,%eax
  80114d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801153:	39 c2                	cmp    %eax,%edx
  801155:	72 14                	jb     80116b <_main+0x6c>
			panic("Please increase the WS size");
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	68 ea 42 80 00       	push   $0x8042ea
  80115f:	6a 18                	push   $0x18
  801161:	68 06 43 80 00       	push   $0x804306
  801166:	e8 f6 05 00 00       	call   801761 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  801172:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801179:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)
	int freeFrames, usedDiskPages ;

	cprintf_colored(TEXT_cyan, "\n%~STEP A: checking the creation of shared variables... [60%]\n");
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	68 1c 43 80 00       	push   $0x80431c
  801188:	6a 03                	push   $0x3
  80118a:	e8 cd 08 00 00       	call   801a5c <cprintf_colored>
  80118f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  801192:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  801199:	e8 4c 1a 00 00       	call   802bea <sys_calculate_free_frames>
  80119e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8011a1:	e8 8f 1a 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  8011a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8011a9:	83 ec 04             	sub    $0x4,%esp
  8011ac:	6a 01                	push   $0x1
  8011ae:	68 00 10 00 00       	push   $0x1000
  8011b3:	68 5b 43 80 00       	push   $0x80435b
  8011b8:	e8 7c 18 00 00       	call   802a39 <smalloc>
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)pagealloc_start)
  8011c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011c6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8011c9:	74 19                	je     8011e4 <_main+0xe5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8011cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011d2:	83 ec 08             	sub    $0x8,%esp
  8011d5:	68 60 43 80 00       	push   $0x804360
  8011da:	6a 0c                	push   $0xc
  8011dc:	e8 7b 08 00 00       	call   801a5c <cprintf_colored>
  8011e1:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8011e4:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8011eb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8011ee:	e8 f7 19 00 00       	call   802bea <sys_calculate_free_frames>
  8011f3:	29 c3                	sub    %eax,%ebx
  8011f5:	89 d8                	mov    %ebx,%eax
  8011f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected + 1 /*KH Block Alloc: 1 page for Share object*/ + 2 /*UH Block Alloc: max of 1 page & 1 table*/))
  8011fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011fd:	83 c0 03             	add    $0x3,%eax
  801200:	89 c2                	mov    %eax,%edx
  801202:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	52                   	push   %edx
  801209:	50                   	push   %eax
  80120a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80120d:	e8 26 ee ff ff       	call   800038 <inRange>
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	75 30                	jne    801249 <_main+0x14a>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Wrong allocation (actual=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expected +1 +2);}
  801219:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801220:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801223:	8d 58 03             	lea    0x3(%eax),%ebx
  801226:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801229:	e8 bc 19 00 00       	call   802bea <sys_calculate_free_frames>
  80122e:	29 c6                	sub    %eax,%esi
  801230:	89 f0                	mov    %esi,%eax
  801232:	83 ec 0c             	sub    $0xc,%esp
  801235:	53                   	push   %ebx
  801236:	ff 75 d8             	pushl  -0x28(%ebp)
  801239:	50                   	push   %eax
  80123a:	68 d0 43 80 00       	push   $0x8043d0
  80123f:	6a 0c                	push   $0xc
  801241:	e8 16 08 00 00       	call   801a5c <cprintf_colored>
  801246:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801249:	e8 e7 19 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  80124e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801251:	74 19                	je     80126c <_main+0x16d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Wrong page file allocation: ");}
  801253:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80125a:	83 ec 08             	sub    $0x8,%esp
  80125d:	68 74 44 80 00       	push   $0x804474
  801262:	6a 0c                	push   $0xc
  801264:	e8 f3 07 00 00       	call   801a5c <cprintf_colored>
  801269:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80126c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801270:	74 04                	je     801276 <_main+0x177>
  801272:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  801276:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80127d:	e8 68 19 00 00       	call   802bea <sys_calculate_free_frames>
  801282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801285:	e8 ab 19 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  80128a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	6a 01                	push   $0x1
  801292:	68 04 10 00 00       	push   $0x1004
  801297:	68 95 44 80 00       	push   $0x804495
  80129c:	e8 98 17 00 00       	call   802a39 <smalloc>
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE))
  8012a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012aa:	05 00 10 00 00       	add    $0x1000,%eax
  8012af:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8012b2:	74 19                	je     8012cd <_main+0x1ce>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8012b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	68 98 44 80 00       	push   $0x804498
  8012c3:	6a 0c                	push   $0xc
  8012c5:	e8 92 07 00 00       	call   801a5c <cprintf_colored>
  8012ca:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2 pages*/
  8012cd:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8012d4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8012d7:	e8 0e 19 00 00       	call   802bea <sys_calculate_free_frames>
  8012dc:	29 c3                	sub    %eax,%ebx
  8012de:	89 d8                	mov    %ebx,%eax
  8012e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  8012e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8012e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	52                   	push   %edx
  8012ed:	50                   	push   %eax
  8012ee:	ff 75 d4             	pushl  -0x2c(%ebp)
  8012f1:	e8 42 ed ff ff       	call   800038 <inRange>
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	75 26                	jne    801323 <_main+0x224>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8012fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801304:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  801307:	e8 de 18 00 00       	call   802bea <sys_calculate_free_frames>
  80130c:	29 c3                	sub    %eax,%ebx
  80130e:	89 d8                	mov    %ebx,%eax
  801310:	ff 75 d8             	pushl  -0x28(%ebp)
  801313:	50                   	push   %eax
  801314:	68 08 45 80 00       	push   $0x804508
  801319:	6a 0c                	push   $0xc
  80131b:	e8 3c 07 00 00       	call   801a5c <cprintf_colored>
  801320:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801323:	e8 0d 19 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  801328:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80132b:	74 19                	je     801346 <_main+0x247>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Wrong page file allocation: ");}
  80132d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	68 a4 45 80 00       	push   $0x8045a4
  80133c:	6a 0c                	push   $0xc
  80133e:	e8 19 07 00 00       	call   801a5c <cprintf_colored>
  801343:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  801346:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80134a:	74 04                	je     801350 <_main+0x251>
  80134c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  801350:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  801357:	e8 8e 18 00 00       	call   802bea <sys_calculate_free_frames>
  80135c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80135f:	e8 d1 18 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  801364:	89 45 e0             	mov    %eax,-0x20(%ebp)
		y = smalloc("y", 4, 1);
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	6a 01                	push   $0x1
  80136c:	6a 04                	push   $0x4
  80136e:	68 c5 45 80 00       	push   $0x8045c5
  801373:	e8 c1 16 00 00       	call   802a39 <smalloc>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE))
  80137e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801381:	05 00 30 00 00       	add    $0x3000,%eax
  801386:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801389:	74 19                	je     8013a4 <_main+0x2a5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80138b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	68 c8 45 80 00       	push   $0x8045c8
  80139a:	6a 0c                	push   $0xc
  80139c:	e8 bb 06 00 00       	call   801a5c <cprintf_colored>
  8013a1:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1 page*/
  8013a4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8013ab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013ae:	e8 37 18 00 00       	call   802bea <sys_calculate_free_frames>
  8013b3:	29 c3                	sub    %eax,%ebx
  8013b5:	89 d8                	mov    %ebx,%eax
  8013b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  8013ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	52                   	push   %edx
  8013c4:	50                   	push   %eax
  8013c5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8013c8:	e8 6b ec ff ff       	call   800038 <inRange>
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	75 26                	jne    8013fa <_main+0x2fb>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8013d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013db:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013de:	e8 07 18 00 00       	call   802bea <sys_calculate_free_frames>
  8013e3:	29 c3                	sub    %eax,%ebx
  8013e5:	89 d8                	mov    %ebx,%eax
  8013e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8013ea:	50                   	push   %eax
  8013eb:	68 38 46 80 00       	push   $0x804638
  8013f0:	6a 0c                	push   $0xc
  8013f2:	e8 65 06 00 00       	call   801a5c <cprintf_colored>
  8013f7:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8013fa:	e8 36 18 00 00       	call   802c35 <sys_pf_calculate_allocated_pages>
  8013ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801402:	74 19                	je     80141d <_main+0x31e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Wrong page file allocation: ");}
  801404:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80140b:	83 ec 08             	sub    $0x8,%esp
  80140e:	68 d4 46 80 00       	push   $0x8046d4
  801413:	6a 0c                	push   $0xc
  801415:	e8 42 06 00 00       	call   801a5c <cprintf_colored>
  80141a:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80141d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801421:	74 04                	je     801427 <_main+0x328>
  801423:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}

	is_correct = 1;
  801427:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking reading & writing... [40%]\n");
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	68 f8 46 80 00       	push   $0x8046f8
  801436:	6a 03                	push   $0x3
  801438:	e8 1f 06 00 00       	call   801a5c <cprintf_colored>
  80143d:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  801440:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  801447:	eb 2d                	jmp    801476 <_main+0x377>
		{
			x[i] = -1;
  801449:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80144c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801453:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80145e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801468:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80146b:	01 d0                	add    %edx,%eax
  80146d:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

	is_correct = 1;
	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking reading & writing... [40%]\n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  801473:	ff 45 ec             	incl   -0x14(%ebp)
  801476:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80147d:	7e ca                	jle    801449 <_main+0x34a>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80147f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  801486:	eb 18                	jmp    8014a0 <_main+0x3a1>
		{
			z[i] = -1;
  801488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80148b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801492:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801495:	01 d0                	add    %edx,%eax
  801497:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80149d:	ff 45 ec             	incl   -0x14(%ebp)
  8014a0:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  8014a7:	7e df                	jle    801488 <_main+0x389>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  8014a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	83 f8 ff             	cmp    $0xffffffff,%eax
  8014b1:	74 19                	je     8014cc <_main+0x3cd>
  8014b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014ba:	83 ec 08             	sub    $0x8,%esp
  8014bd:	68 28 47 80 00       	push   $0x804728
  8014c2:	6a 0c                	push   $0xc
  8014c4:	e8 93 05 00 00       	call   801a5c <cprintf_colored>
  8014c9:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  8014cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014cf:	05 fc 0f 00 00       	add    $0xffc,%eax
  8014d4:	8b 00                	mov    (%eax),%eax
  8014d6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8014d9:	74 19                	je     8014f4 <_main+0x3f5>
  8014db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	68 28 47 80 00       	push   $0x804728
  8014ea:	6a 0c                	push   $0xc
  8014ec:	e8 6b 05 00 00       	call   801a5c <cprintf_colored>
  8014f1:	83 c4 10             	add    $0x10,%esp

		if( y[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  8014f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014f7:	8b 00                	mov    (%eax),%eax
  8014f9:	83 f8 ff             	cmp    $0xffffffff,%eax
  8014fc:	74 19                	je     801517 <_main+0x418>
  8014fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	68 28 47 80 00       	push   $0x804728
  80150d:	6a 0c                	push   $0xc
  80150f:	e8 48 05 00 00       	call   801a5c <cprintf_colored>
  801514:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  801517:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80151a:	05 fc 0f 00 00       	add    $0xffc,%eax
  80151f:	8b 00                	mov    (%eax),%eax
  801521:	83 f8 ff             	cmp    $0xffffffff,%eax
  801524:	74 19                	je     80153f <_main+0x440>
  801526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	68 28 47 80 00       	push   $0x804728
  801535:	6a 0c                	push   $0xc
  801537:	e8 20 05 00 00       	call   801a5c <cprintf_colored>
  80153c:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  80153f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801542:	8b 00                	mov    (%eax),%eax
  801544:	83 f8 ff             	cmp    $0xffffffff,%eax
  801547:	74 19                	je     801562 <_main+0x463>
  801549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	68 28 47 80 00       	push   $0x804728
  801558:	6a 0c                	push   $0xc
  80155a:	e8 fd 04 00 00       	call   801a5c <cprintf_colored>
  80155f:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  801562:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801565:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80156a:	8b 00                	mov    (%eax),%eax
  80156c:	83 f8 ff             	cmp    $0xffffffff,%eax
  80156f:	74 19                	je     80158a <_main+0x48b>
  801571:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	68 28 47 80 00       	push   $0x804728
  801580:	6a 0c                	push   $0xc
  801582:	e8 d5 04 00 00       	call   801a5c <cprintf_colored>
  801587:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  80158a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80158e:	74 04                	je     801594 <_main+0x495>
		eval += 40 ;
  801590:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf_colored(TEXT_light_green, "%~\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	ff 75 f4             	pushl  -0xc(%ebp)
  80159a:	68 58 47 80 00       	push   $0x804758
  80159f:	6a 0a                	push   $0xa
  8015a1:	e8 b6 04 00 00       	call   801a5c <cprintf_colored>
  8015a6:	83 c4 10             	add    $0x10,%esp

	return;
  8015a9:	90                   	nop
}
  8015aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ad:	5b                   	pop    %ebx
  8015ae:	5e                   	pop    %esi
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    

008015b1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	57                   	push   %edi
  8015b5:	56                   	push   %esi
  8015b6:	53                   	push   %ebx
  8015b7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8015ba:	e8 f4 17 00 00       	call   802db3 <sys_getenvindex>
  8015bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8015c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c5:	89 d0                	mov    %edx,%eax
  8015c7:	c1 e0 02             	shl    $0x2,%eax
  8015ca:	01 d0                	add    %edx,%eax
  8015cc:	c1 e0 03             	shl    $0x3,%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8015d8:	01 d0                	add    %edx,%eax
  8015da:	c1 e0 02             	shl    $0x2,%eax
  8015dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015e2:	a3 00 62 80 00       	mov    %eax,0x806200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8015e7:	a1 00 62 80 00       	mov    0x806200,%eax
  8015ec:	8a 40 20             	mov    0x20(%eax),%al
  8015ef:	84 c0                	test   %al,%al
  8015f1:	74 0d                	je     801600 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8015f3:	a1 00 62 80 00       	mov    0x806200,%eax
  8015f8:	83 c0 20             	add    $0x20,%eax
  8015fb:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801600:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801604:	7e 0a                	jle    801610 <libmain+0x5f>
		binaryname = argv[0];
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	8b 00                	mov    (%eax),%eax
  80160b:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	ff 75 08             	pushl  0x8(%ebp)
  801619:	e8 e1 fa ff ff       	call   8010ff <_main>
  80161e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801621:	a1 00 60 80 00       	mov    0x806000,%eax
  801626:	85 c0                	test   %eax,%eax
  801628:	0f 84 01 01 00 00    	je     80172f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80162e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801634:	bb 94 48 80 00       	mov    $0x804894,%ebx
  801639:	ba 0e 00 00 00       	mov    $0xe,%edx
  80163e:	89 c7                	mov    %eax,%edi
  801640:	89 de                	mov    %ebx,%esi
  801642:	89 d1                	mov    %edx,%ecx
  801644:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801646:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801649:	b9 56 00 00 00       	mov    $0x56,%ecx
  80164e:	b0 00                	mov    $0x0,%al
  801650:	89 d7                	mov    %edx,%edi
  801652:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801654:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80165b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	50                   	push   %eax
  801662:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801668:	50                   	push   %eax
  801669:	e8 7b 19 00 00       	call   802fe9 <sys_utilities>
  80166e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801671:	e8 c4 14 00 00       	call   802b3a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801676:	83 ec 0c             	sub    $0xc,%esp
  801679:	68 b4 47 80 00       	push   $0x8047b4
  80167e:	e8 ac 03 00 00       	call   801a2f <cprintf>
  801683:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801686:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801689:	85 c0                	test   %eax,%eax
  80168b:	74 18                	je     8016a5 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80168d:	e8 75 19 00 00       	call   803007 <sys_get_optimal_num_faults>
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	50                   	push   %eax
  801696:	68 dc 47 80 00       	push   $0x8047dc
  80169b:	e8 8f 03 00 00       	call   801a2f <cprintf>
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	eb 59                	jmp    8016fe <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8016a5:	a1 00 62 80 00       	mov    0x806200,%eax
  8016aa:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8016b0:	a1 00 62 80 00       	mov    0x806200,%eax
  8016b5:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	52                   	push   %edx
  8016bf:	50                   	push   %eax
  8016c0:	68 00 48 80 00       	push   $0x804800
  8016c5:	e8 65 03 00 00       	call   801a2f <cprintf>
  8016ca:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8016cd:	a1 00 62 80 00       	mov    0x806200,%eax
  8016d2:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8016d8:	a1 00 62 80 00       	mov    0x806200,%eax
  8016dd:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8016e3:	a1 00 62 80 00       	mov    0x806200,%eax
  8016e8:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8016ee:	51                   	push   %ecx
  8016ef:	52                   	push   %edx
  8016f0:	50                   	push   %eax
  8016f1:	68 28 48 80 00       	push   $0x804828
  8016f6:	e8 34 03 00 00       	call   801a2f <cprintf>
  8016fb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8016fe:	a1 00 62 80 00       	mov    0x806200,%eax
  801703:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  801709:	83 ec 08             	sub    $0x8,%esp
  80170c:	50                   	push   %eax
  80170d:	68 80 48 80 00       	push   $0x804880
  801712:	e8 18 03 00 00       	call   801a2f <cprintf>
  801717:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80171a:	83 ec 0c             	sub    $0xc,%esp
  80171d:	68 b4 47 80 00       	push   $0x8047b4
  801722:	e8 08 03 00 00       	call   801a2f <cprintf>
  801727:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80172a:	e8 25 14 00 00       	call   802b54 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80172f:	e8 1f 00 00 00       	call   801753 <exit>
}
  801734:	90                   	nop
  801735:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5f                   	pop    %edi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    

0080173d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801743:	83 ec 0c             	sub    $0xc,%esp
  801746:	6a 00                	push   $0x0
  801748:	e8 32 16 00 00       	call   802d7f <sys_destroy_env>
  80174d:	83 c4 10             	add    $0x10,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <exit>:

void
exit(void)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801759:	e8 87 16 00 00       	call   802de5 <sys_exit_env>
}
  80175e:	90                   	nop
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801767:	8d 45 10             	lea    0x10(%ebp),%eax
  80176a:	83 c0 04             	add    $0x4,%eax
  80176d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801770:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801775:	85 c0                	test   %eax,%eax
  801777:	74 16                	je     80178f <_panic+0x2e>
		cprintf("%s: ", argv0);
  801779:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	50                   	push   %eax
  801782:	68 f8 48 80 00       	push   $0x8048f8
  801787:	e8 a3 02 00 00       	call   801a2f <cprintf>
  80178c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80178f:	a1 04 60 80 00       	mov    0x806004,%eax
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	ff 75 0c             	pushl  0xc(%ebp)
  80179a:	ff 75 08             	pushl  0x8(%ebp)
  80179d:	50                   	push   %eax
  80179e:	68 00 49 80 00       	push   $0x804900
  8017a3:	6a 74                	push   $0x74
  8017a5:	e8 b2 02 00 00       	call   801a5c <cprintf_colored>
  8017aa:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b0:	83 ec 08             	sub    $0x8,%esp
  8017b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b6:	50                   	push   %eax
  8017b7:	e8 04 02 00 00       	call   8019c0 <vcprintf>
  8017bc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017bf:	83 ec 08             	sub    $0x8,%esp
  8017c2:	6a 00                	push   $0x0
  8017c4:	68 28 49 80 00       	push   $0x804928
  8017c9:	e8 f2 01 00 00       	call   8019c0 <vcprintf>
  8017ce:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017d1:	e8 7d ff ff ff       	call   801753 <exit>

	// should not return here
	while (1) ;
  8017d6:	eb fe                	jmp    8017d6 <_panic+0x75>

008017d8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017de:	a1 00 62 80 00       	mov    0x806200,%eax
  8017e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	39 c2                	cmp    %eax,%edx
  8017ee:	74 14                	je     801804 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 2c 49 80 00       	push   $0x80492c
  8017f8:	6a 26                	push   $0x26
  8017fa:	68 78 49 80 00       	push   $0x804978
  8017ff:	e8 5d ff ff ff       	call   801761 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80180b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801812:	e9 c5 00 00 00       	jmp    8018dc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	01 d0                	add    %edx,%eax
  801826:	8b 00                	mov    (%eax),%eax
  801828:	85 c0                	test   %eax,%eax
  80182a:	75 08                	jne    801834 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80182c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80182f:	e9 a5 00 00 00       	jmp    8018d9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801834:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80183b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801842:	eb 69                	jmp    8018ad <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801844:	a1 00 62 80 00       	mov    0x806200,%eax
  801849:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80184f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801852:	89 d0                	mov    %edx,%eax
  801854:	01 c0                	add    %eax,%eax
  801856:	01 d0                	add    %edx,%eax
  801858:	c1 e0 03             	shl    $0x3,%eax
  80185b:	01 c8                	add    %ecx,%eax
  80185d:	8a 40 04             	mov    0x4(%eax),%al
  801860:	84 c0                	test   %al,%al
  801862:	75 46                	jne    8018aa <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801864:	a1 00 62 80 00       	mov    0x806200,%eax
  801869:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80186f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801872:	89 d0                	mov    %edx,%eax
  801874:	01 c0                	add    %eax,%eax
  801876:	01 d0                	add    %edx,%eax
  801878:	c1 e0 03             	shl    $0x3,%eax
  80187b:	01 c8                	add    %ecx,%eax
  80187d:	8b 00                	mov    (%eax),%eax
  80187f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801882:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801885:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80188a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80188c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	01 c8                	add    %ecx,%eax
  80189b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80189d:	39 c2                	cmp    %eax,%edx
  80189f:	75 09                	jne    8018aa <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018a1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018a8:	eb 15                	jmp    8018bf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018aa:	ff 45 e8             	incl   -0x18(%ebp)
  8018ad:	a1 00 62 80 00       	mov    0x806200,%eax
  8018b2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018bb:	39 c2                	cmp    %eax,%edx
  8018bd:	77 85                	ja     801844 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018c3:	75 14                	jne    8018d9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	68 84 49 80 00       	push   $0x804984
  8018cd:	6a 3a                	push   $0x3a
  8018cf:	68 78 49 80 00       	push   $0x804978
  8018d4:	e8 88 fe ff ff       	call   801761 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018d9:	ff 45 f0             	incl   -0x10(%ebp)
  8018dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018e2:	0f 8c 2f ff ff ff    	jl     801817 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018f6:	eb 26                	jmp    80191e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8018f8:	a1 00 62 80 00       	mov    0x806200,%eax
  8018fd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801903:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801906:	89 d0                	mov    %edx,%eax
  801908:	01 c0                	add    %eax,%eax
  80190a:	01 d0                	add    %edx,%eax
  80190c:	c1 e0 03             	shl    $0x3,%eax
  80190f:	01 c8                	add    %ecx,%eax
  801911:	8a 40 04             	mov    0x4(%eax),%al
  801914:	3c 01                	cmp    $0x1,%al
  801916:	75 03                	jne    80191b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801918:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80191b:	ff 45 e0             	incl   -0x20(%ebp)
  80191e:	a1 00 62 80 00       	mov    0x806200,%eax
  801923:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192c:	39 c2                	cmp    %eax,%edx
  80192e:	77 c8                	ja     8018f8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801933:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801936:	74 14                	je     80194c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	68 d8 49 80 00       	push   $0x8049d8
  801940:	6a 44                	push   $0x44
  801942:	68 78 49 80 00       	push   $0x804978
  801947:	e8 15 fe ff ff       	call   801761 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80194c:	90                   	nop
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	53                   	push   %ebx
  801953:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801956:	8b 45 0c             	mov    0xc(%ebp),%eax
  801959:	8b 00                	mov    (%eax),%eax
  80195b:	8d 48 01             	lea    0x1(%eax),%ecx
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	89 0a                	mov    %ecx,(%edx)
  801963:	8b 55 08             	mov    0x8(%ebp),%edx
  801966:	88 d1                	mov    %dl,%cl
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	3d ff 00 00 00       	cmp    $0xff,%eax
  801979:	75 30                	jne    8019ab <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80197b:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  801981:	a0 24 62 80 00       	mov    0x806224,%al
  801986:	0f b6 c0             	movzbl %al,%eax
  801989:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80198c:	8b 09                	mov    (%ecx),%ecx
  80198e:	89 cb                	mov    %ecx,%ebx
  801990:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801993:	83 c1 08             	add    $0x8,%ecx
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	53                   	push   %ebx
  801999:	51                   	push   %ecx
  80199a:	e8 57 11 00 00       	call   802af6 <sys_cputs>
  80199f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8019a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8019ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ae:	8b 40 04             	mov    0x4(%eax),%eax
  8019b1:	8d 50 01             	lea    0x1(%eax),%edx
  8019b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8019ba:	90                   	nop
  8019bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8019c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019d0:	00 00 00 
	b.cnt = 0;
  8019d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8019da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8019e9:	50                   	push   %eax
  8019ea:	68 4f 19 80 00       	push   $0x80194f
  8019ef:	e8 5a 02 00 00       	call   801c4e <vprintfmt>
  8019f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8019f7:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  8019fd:	a0 24 62 80 00       	mov    0x806224,%al
  801a02:	0f b6 c0             	movzbl %al,%eax
  801a05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	51                   	push   %ecx
  801a0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a14:	83 c0 08             	add    $0x8,%eax
  801a17:	50                   	push   %eax
  801a18:	e8 d9 10 00 00       	call   802af6 <sys_cputs>
  801a1d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801a20:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
	return b.cnt;
  801a27:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801a35:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	va_start(ap, fmt);
  801a3c:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	83 ec 08             	sub    $0x8,%esp
  801a48:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4b:	50                   	push   %eax
  801a4c:	e8 6f ff ff ff       	call   8019c0 <vcprintf>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801a62:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	c1 e0 08             	shl    $0x8,%eax
  801a6f:	a3 fc e2 81 00       	mov    %eax,0x81e2fc
	va_start(ap, fmt);
  801a74:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a77:	83 c0 04             	add    $0x4,%eax
  801a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	ff 75 f4             	pushl  -0xc(%ebp)
  801a86:	50                   	push   %eax
  801a87:	e8 34 ff ff ff       	call   8019c0 <vcprintf>
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801a92:	c7 05 fc e2 81 00 00 	movl   $0x700,0x81e2fc
  801a99:	07 00 00 

	return cnt;
  801a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801aa7:	e8 8e 10 00 00       	call   802b3a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801aac:	8d 45 0c             	lea    0xc(%ebp),%eax
  801aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	83 ec 08             	sub    $0x8,%esp
  801ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  801abb:	50                   	push   %eax
  801abc:	e8 ff fe ff ff       	call   8019c0 <vcprintf>
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801ac7:	e8 88 10 00 00       	call   802b54 <sys_unlock_cons>
	return cnt;
  801acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	53                   	push   %ebx
  801ad5:	83 ec 14             	sub    $0x14,%esp
  801ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  801adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ade:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801ae4:	8b 45 18             	mov    0x18(%ebp),%eax
  801ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801aef:	77 55                	ja     801b46 <printnum+0x75>
  801af1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801af4:	72 05                	jb     801afb <printnum+0x2a>
  801af6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801af9:	77 4b                	ja     801b46 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801afb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801afe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801b01:	8b 45 18             	mov    0x18(%ebp),%eax
  801b04:	ba 00 00 00 00       	mov    $0x0,%edx
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b0e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b11:	e8 06 20 00 00       	call   803b1c <__udivdi3>
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	ff 75 20             	pushl  0x20(%ebp)
  801b1f:	53                   	push   %ebx
  801b20:	ff 75 18             	pushl  0x18(%ebp)
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	e8 a1 ff ff ff       	call   801ad1 <printnum>
  801b30:	83 c4 20             	add    $0x20,%esp
  801b33:	eb 1a                	jmp    801b4f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801b35:	83 ec 08             	sub    $0x8,%esp
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	ff 75 20             	pushl  0x20(%ebp)
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	ff d0                	call   *%eax
  801b43:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801b46:	ff 4d 1c             	decl   0x1c(%ebp)
  801b49:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801b4d:	7f e6                	jg     801b35 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b4f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b52:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5d:	53                   	push   %ebx
  801b5e:	51                   	push   %ecx
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	e8 c6 20 00 00       	call   803c2c <__umoddi3>
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	05 54 4c 80 00       	add    $0x804c54,%eax
  801b6e:	8a 00                	mov    (%eax),%al
  801b70:	0f be c0             	movsbl %al,%eax
  801b73:	83 ec 08             	sub    $0x8,%esp
  801b76:	ff 75 0c             	pushl  0xc(%ebp)
  801b79:	50                   	push   %eax
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	ff d0                	call   *%eax
  801b7f:	83 c4 10             	add    $0x10,%esp
}
  801b82:	90                   	nop
  801b83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b8f:	7e 1c                	jle    801bad <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8b 00                	mov    (%eax),%eax
  801b96:	8d 50 08             	lea    0x8(%eax),%edx
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	89 10                	mov    %edx,(%eax)
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	8b 00                	mov    (%eax),%eax
  801ba3:	83 e8 08             	sub    $0x8,%eax
  801ba6:	8b 50 04             	mov    0x4(%eax),%edx
  801ba9:	8b 00                	mov    (%eax),%eax
  801bab:	eb 40                	jmp    801bed <getuint+0x65>
	else if (lflag)
  801bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb1:	74 1e                	je     801bd1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	8b 00                	mov    (%eax),%eax
  801bb8:	8d 50 04             	lea    0x4(%eax),%edx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	89 10                	mov    %edx,(%eax)
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	8b 00                	mov    (%eax),%eax
  801bc5:	83 e8 04             	sub    $0x4,%eax
  801bc8:	8b 00                	mov    (%eax),%eax
  801bca:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcf:	eb 1c                	jmp    801bed <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	8b 00                	mov    (%eax),%eax
  801bd6:	8d 50 04             	lea    0x4(%eax),%edx
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	89 10                	mov    %edx,(%eax)
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	8b 00                	mov    (%eax),%eax
  801be3:	83 e8 04             	sub    $0x4,%eax
  801be6:	8b 00                	mov    (%eax),%eax
  801be8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    

00801bef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801bf2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bf6:	7e 1c                	jle    801c14 <getint+0x25>
		return va_arg(*ap, long long);
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8b 00                	mov    (%eax),%eax
  801bfd:	8d 50 08             	lea    0x8(%eax),%edx
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	89 10                	mov    %edx,(%eax)
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	8b 00                	mov    (%eax),%eax
  801c0a:	83 e8 08             	sub    $0x8,%eax
  801c0d:	8b 50 04             	mov    0x4(%eax),%edx
  801c10:	8b 00                	mov    (%eax),%eax
  801c12:	eb 38                	jmp    801c4c <getint+0x5d>
	else if (lflag)
  801c14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c18:	74 1a                	je     801c34 <getint+0x45>
		return va_arg(*ap, long);
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 50 04             	lea    0x4(%eax),%edx
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	89 10                	mov    %edx,(%eax)
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	8b 00                	mov    (%eax),%eax
  801c2c:	83 e8 04             	sub    $0x4,%eax
  801c2f:	8b 00                	mov    (%eax),%eax
  801c31:	99                   	cltd   
  801c32:	eb 18                	jmp    801c4c <getint+0x5d>
	else
		return va_arg(*ap, int);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	8b 00                	mov    (%eax),%eax
  801c39:	8d 50 04             	lea    0x4(%eax),%edx
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	89 10                	mov    %edx,(%eax)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	8b 00                	mov    (%eax),%eax
  801c46:	83 e8 04             	sub    $0x4,%eax
  801c49:	8b 00                	mov    (%eax),%eax
  801c4b:	99                   	cltd   
}
  801c4c:	5d                   	pop    %ebp
  801c4d:	c3                   	ret    

00801c4e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	56                   	push   %esi
  801c52:	53                   	push   %ebx
  801c53:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c56:	eb 17                	jmp    801c6f <vprintfmt+0x21>
			if (ch == '\0')
  801c58:	85 db                	test   %ebx,%ebx
  801c5a:	0f 84 c1 03 00 00    	je     802021 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801c60:	83 ec 08             	sub    $0x8,%esp
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	53                   	push   %ebx
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	ff d0                	call   *%eax
  801c6c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c72:	8d 50 01             	lea    0x1(%eax),%edx
  801c75:	89 55 10             	mov    %edx,0x10(%ebp)
  801c78:	8a 00                	mov    (%eax),%al
  801c7a:	0f b6 d8             	movzbl %al,%ebx
  801c7d:	83 fb 25             	cmp    $0x25,%ebx
  801c80:	75 d6                	jne    801c58 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801c82:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801c86:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801c8d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801c94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801c9b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca5:	8d 50 01             	lea    0x1(%eax),%edx
  801ca8:	89 55 10             	mov    %edx,0x10(%ebp)
  801cab:	8a 00                	mov    (%eax),%al
  801cad:	0f b6 d8             	movzbl %al,%ebx
  801cb0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801cb3:	83 f8 5b             	cmp    $0x5b,%eax
  801cb6:	0f 87 3d 03 00 00    	ja     801ff9 <vprintfmt+0x3ab>
  801cbc:	8b 04 85 78 4c 80 00 	mov    0x804c78(,%eax,4),%eax
  801cc3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801cc5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801cc9:	eb d7                	jmp    801ca2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ccb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801ccf:	eb d1                	jmp    801ca2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801cd1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801cd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cdb:	89 d0                	mov    %edx,%eax
  801cdd:	c1 e0 02             	shl    $0x2,%eax
  801ce0:	01 d0                	add    %edx,%eax
  801ce2:	01 c0                	add    %eax,%eax
  801ce4:	01 d8                	add    %ebx,%eax
  801ce6:	83 e8 30             	sub    $0x30,%eax
  801ce9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801cec:	8b 45 10             	mov    0x10(%ebp),%eax
  801cef:	8a 00                	mov    (%eax),%al
  801cf1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801cf4:	83 fb 2f             	cmp    $0x2f,%ebx
  801cf7:	7e 3e                	jle    801d37 <vprintfmt+0xe9>
  801cf9:	83 fb 39             	cmp    $0x39,%ebx
  801cfc:	7f 39                	jg     801d37 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801cfe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801d01:	eb d5                	jmp    801cd8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d03:	8b 45 14             	mov    0x14(%ebp),%eax
  801d06:	83 c0 04             	add    $0x4,%eax
  801d09:	89 45 14             	mov    %eax,0x14(%ebp)
  801d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0f:	83 e8 04             	sub    $0x4,%eax
  801d12:	8b 00                	mov    (%eax),%eax
  801d14:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801d17:	eb 1f                	jmp    801d38 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801d19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d1d:	79 83                	jns    801ca2 <vprintfmt+0x54>
				width = 0;
  801d1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801d26:	e9 77 ff ff ff       	jmp    801ca2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801d2b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801d32:	e9 6b ff ff ff       	jmp    801ca2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801d37:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801d38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d3c:	0f 89 60 ff ff ff    	jns    801ca2 <vprintfmt+0x54>
				width = precision, precision = -1;
  801d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d4f:	e9 4e ff ff ff       	jmp    801ca2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d54:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801d57:	e9 46 ff ff ff       	jmp    801ca2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5f:	83 c0 04             	add    $0x4,%eax
  801d62:	89 45 14             	mov    %eax,0x14(%ebp)
  801d65:	8b 45 14             	mov    0x14(%ebp),%eax
  801d68:	83 e8 04             	sub    $0x4,%eax
  801d6b:	8b 00                	mov    (%eax),%eax
  801d6d:	83 ec 08             	sub    $0x8,%esp
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	50                   	push   %eax
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	ff d0                	call   *%eax
  801d79:	83 c4 10             	add    $0x10,%esp
			break;
  801d7c:	e9 9b 02 00 00       	jmp    80201c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801d81:	8b 45 14             	mov    0x14(%ebp),%eax
  801d84:	83 c0 04             	add    $0x4,%eax
  801d87:	89 45 14             	mov    %eax,0x14(%ebp)
  801d8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8d:	83 e8 04             	sub    $0x4,%eax
  801d90:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801d92:	85 db                	test   %ebx,%ebx
  801d94:	79 02                	jns    801d98 <vprintfmt+0x14a>
				err = -err;
  801d96:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801d98:	83 fb 64             	cmp    $0x64,%ebx
  801d9b:	7f 0b                	jg     801da8 <vprintfmt+0x15a>
  801d9d:	8b 34 9d c0 4a 80 00 	mov    0x804ac0(,%ebx,4),%esi
  801da4:	85 f6                	test   %esi,%esi
  801da6:	75 19                	jne    801dc1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801da8:	53                   	push   %ebx
  801da9:	68 65 4c 80 00       	push   $0x804c65
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	e8 70 02 00 00       	call   802029 <printfmt>
  801db9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801dbc:	e9 5b 02 00 00       	jmp    80201c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801dc1:	56                   	push   %esi
  801dc2:	68 6e 4c 80 00       	push   $0x804c6e
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	e8 57 02 00 00       	call   802029 <printfmt>
  801dd2:	83 c4 10             	add    $0x10,%esp
			break;
  801dd5:	e9 42 02 00 00       	jmp    80201c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801dda:	8b 45 14             	mov    0x14(%ebp),%eax
  801ddd:	83 c0 04             	add    $0x4,%eax
  801de0:	89 45 14             	mov    %eax,0x14(%ebp)
  801de3:	8b 45 14             	mov    0x14(%ebp),%eax
  801de6:	83 e8 04             	sub    $0x4,%eax
  801de9:	8b 30                	mov    (%eax),%esi
  801deb:	85 f6                	test   %esi,%esi
  801ded:	75 05                	jne    801df4 <vprintfmt+0x1a6>
				p = "(null)";
  801def:	be 71 4c 80 00       	mov    $0x804c71,%esi
			if (width > 0 && padc != '-')
  801df4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801df8:	7e 6d                	jle    801e67 <vprintfmt+0x219>
  801dfa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801dfe:	74 67                	je     801e67 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e03:	83 ec 08             	sub    $0x8,%esp
  801e06:	50                   	push   %eax
  801e07:	56                   	push   %esi
  801e08:	e8 1e 03 00 00       	call   80212b <strnlen>
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801e13:	eb 16                	jmp    801e2b <vprintfmt+0x1dd>
					putch(padc, putdat);
  801e15:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801e19:	83 ec 08             	sub    $0x8,%esp
  801e1c:	ff 75 0c             	pushl  0xc(%ebp)
  801e1f:	50                   	push   %eax
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	ff d0                	call   *%eax
  801e25:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801e28:	ff 4d e4             	decl   -0x1c(%ebp)
  801e2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e2f:	7f e4                	jg     801e15 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e31:	eb 34                	jmp    801e67 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801e33:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e37:	74 1c                	je     801e55 <vprintfmt+0x207>
  801e39:	83 fb 1f             	cmp    $0x1f,%ebx
  801e3c:	7e 05                	jle    801e43 <vprintfmt+0x1f5>
  801e3e:	83 fb 7e             	cmp    $0x7e,%ebx
  801e41:	7e 12                	jle    801e55 <vprintfmt+0x207>
					putch('?', putdat);
  801e43:	83 ec 08             	sub    $0x8,%esp
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	6a 3f                	push   $0x3f
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	ff d0                	call   *%eax
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	eb 0f                	jmp    801e64 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801e55:	83 ec 08             	sub    $0x8,%esp
  801e58:	ff 75 0c             	pushl  0xc(%ebp)
  801e5b:	53                   	push   %ebx
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	ff d0                	call   *%eax
  801e61:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e64:	ff 4d e4             	decl   -0x1c(%ebp)
  801e67:	89 f0                	mov    %esi,%eax
  801e69:	8d 70 01             	lea    0x1(%eax),%esi
  801e6c:	8a 00                	mov    (%eax),%al
  801e6e:	0f be d8             	movsbl %al,%ebx
  801e71:	85 db                	test   %ebx,%ebx
  801e73:	74 24                	je     801e99 <vprintfmt+0x24b>
  801e75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e79:	78 b8                	js     801e33 <vprintfmt+0x1e5>
  801e7b:	ff 4d e0             	decl   -0x20(%ebp)
  801e7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e82:	79 af                	jns    801e33 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e84:	eb 13                	jmp    801e99 <vprintfmt+0x24b>
				putch(' ', putdat);
  801e86:	83 ec 08             	sub    $0x8,%esp
  801e89:	ff 75 0c             	pushl  0xc(%ebp)
  801e8c:	6a 20                	push   $0x20
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	ff d0                	call   *%eax
  801e93:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e96:	ff 4d e4             	decl   -0x1c(%ebp)
  801e99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e9d:	7f e7                	jg     801e86 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801e9f:	e9 78 01 00 00       	jmp    80201c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ea4:	83 ec 08             	sub    $0x8,%esp
  801ea7:	ff 75 e8             	pushl  -0x18(%ebp)
  801eaa:	8d 45 14             	lea    0x14(%ebp),%eax
  801ead:	50                   	push   %eax
  801eae:	e8 3c fd ff ff       	call   801bef <getint>
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec2:	85 d2                	test   %edx,%edx
  801ec4:	79 23                	jns    801ee9 <vprintfmt+0x29b>
				putch('-', putdat);
  801ec6:	83 ec 08             	sub    $0x8,%esp
  801ec9:	ff 75 0c             	pushl  0xc(%ebp)
  801ecc:	6a 2d                	push   $0x2d
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	ff d0                	call   *%eax
  801ed3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	f7 d8                	neg    %eax
  801ede:	83 d2 00             	adc    $0x0,%edx
  801ee1:	f7 da                	neg    %edx
  801ee3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ee6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801ee9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ef0:	e9 bc 00 00 00       	jmp    801fb1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801ef5:	83 ec 08             	sub    $0x8,%esp
  801ef8:	ff 75 e8             	pushl  -0x18(%ebp)
  801efb:	8d 45 14             	lea    0x14(%ebp),%eax
  801efe:	50                   	push   %eax
  801eff:	e8 84 fc ff ff       	call   801b88 <getuint>
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801f0d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f14:	e9 98 00 00 00       	jmp    801fb1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801f19:	83 ec 08             	sub    $0x8,%esp
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	6a 58                	push   $0x58
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	ff d0                	call   *%eax
  801f26:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f29:	83 ec 08             	sub    $0x8,%esp
  801f2c:	ff 75 0c             	pushl  0xc(%ebp)
  801f2f:	6a 58                	push   $0x58
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	ff d0                	call   *%eax
  801f36:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f39:	83 ec 08             	sub    $0x8,%esp
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	6a 58                	push   $0x58
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	ff d0                	call   *%eax
  801f46:	83 c4 10             	add    $0x10,%esp
			break;
  801f49:	e9 ce 00 00 00       	jmp    80201c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801f4e:	83 ec 08             	sub    $0x8,%esp
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	6a 30                	push   $0x30
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	ff d0                	call   *%eax
  801f5b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801f5e:	83 ec 08             	sub    $0x8,%esp
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	6a 78                	push   $0x78
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	ff d0                	call   *%eax
  801f6b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f71:	83 c0 04             	add    $0x4,%eax
  801f74:	89 45 14             	mov    %eax,0x14(%ebp)
  801f77:	8b 45 14             	mov    0x14(%ebp),%eax
  801f7a:	83 e8 04             	sub    $0x4,%eax
  801f7d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801f89:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801f90:	eb 1f                	jmp    801fb1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801f92:	83 ec 08             	sub    $0x8,%esp
  801f95:	ff 75 e8             	pushl  -0x18(%ebp)
  801f98:	8d 45 14             	lea    0x14(%ebp),%eax
  801f9b:	50                   	push   %eax
  801f9c:	e8 e7 fb ff ff       	call   801b88 <getuint>
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fa7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801faa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801fb1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	52                   	push   %edx
  801fbc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fbf:	50                   	push   %eax
  801fc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc3:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc6:	ff 75 0c             	pushl  0xc(%ebp)
  801fc9:	ff 75 08             	pushl  0x8(%ebp)
  801fcc:	e8 00 fb ff ff       	call   801ad1 <printnum>
  801fd1:	83 c4 20             	add    $0x20,%esp
			break;
  801fd4:	eb 46                	jmp    80201c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801fd6:	83 ec 08             	sub    $0x8,%esp
  801fd9:	ff 75 0c             	pushl  0xc(%ebp)
  801fdc:	53                   	push   %ebx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	ff d0                	call   *%eax
  801fe2:	83 c4 10             	add    $0x10,%esp
			break;
  801fe5:	eb 35                	jmp    80201c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801fe7:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
			break;
  801fee:	eb 2c                	jmp    80201c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801ff0:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
			break;
  801ff7:	eb 23                	jmp    80201c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ff9:	83 ec 08             	sub    $0x8,%esp
  801ffc:	ff 75 0c             	pushl  0xc(%ebp)
  801fff:	6a 25                	push   $0x25
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	ff d0                	call   *%eax
  802006:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802009:	ff 4d 10             	decl   0x10(%ebp)
  80200c:	eb 03                	jmp    802011 <vprintfmt+0x3c3>
  80200e:	ff 4d 10             	decl   0x10(%ebp)
  802011:	8b 45 10             	mov    0x10(%ebp),%eax
  802014:	48                   	dec    %eax
  802015:	8a 00                	mov    (%eax),%al
  802017:	3c 25                	cmp    $0x25,%al
  802019:	75 f3                	jne    80200e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80201b:	90                   	nop
		}
	}
  80201c:	e9 35 fc ff ff       	jmp    801c56 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802021:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802022:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802025:	5b                   	pop    %ebx
  802026:	5e                   	pop    %esi
  802027:	5d                   	pop    %ebp
  802028:	c3                   	ret    

00802029 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80202f:	8d 45 10             	lea    0x10(%ebp),%eax
  802032:	83 c0 04             	add    $0x4,%eax
  802035:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802038:	8b 45 10             	mov    0x10(%ebp),%eax
  80203b:	ff 75 f4             	pushl  -0xc(%ebp)
  80203e:	50                   	push   %eax
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	e8 04 fc ff ff       	call   801c4e <vprintfmt>
  80204a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80204d:	90                   	nop
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802053:	8b 45 0c             	mov    0xc(%ebp),%eax
  802056:	8b 40 08             	mov    0x8(%eax),%eax
  802059:	8d 50 01             	lea    0x1(%eax),%edx
  80205c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  802062:	8b 45 0c             	mov    0xc(%ebp),%eax
  802065:	8b 10                	mov    (%eax),%edx
  802067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206a:	8b 40 04             	mov    0x4(%eax),%eax
  80206d:	39 c2                	cmp    %eax,%edx
  80206f:	73 12                	jae    802083 <sprintputch+0x33>
		*b->buf++ = ch;
  802071:	8b 45 0c             	mov    0xc(%ebp),%eax
  802074:	8b 00                	mov    (%eax),%eax
  802076:	8d 48 01             	lea    0x1(%eax),%ecx
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	89 0a                	mov    %ecx,(%edx)
  80207e:	8b 55 08             	mov    0x8(%ebp),%edx
  802081:	88 10                	mov    %dl,(%eax)
}
  802083:	90                   	nop
  802084:	5d                   	pop    %ebp
  802085:	c3                   	ret    

00802086 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802092:	8b 45 0c             	mov    0xc(%ebp),%eax
  802095:	8d 50 ff             	lea    -0x1(%eax),%edx
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	01 d0                	add    %edx,%eax
  80209d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8020a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ab:	74 06                	je     8020b3 <vsnprintf+0x2d>
  8020ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020b1:	7f 07                	jg     8020ba <vsnprintf+0x34>
		return -E_INVAL;
  8020b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8020b8:	eb 20                	jmp    8020da <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8020ba:	ff 75 14             	pushl  0x14(%ebp)
  8020bd:	ff 75 10             	pushl  0x10(%ebp)
  8020c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8020c3:	50                   	push   %eax
  8020c4:	68 50 20 80 00       	push   $0x802050
  8020c9:	e8 80 fb ff ff       	call   801c4e <vprintfmt>
  8020ce:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8020d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8020e2:	8d 45 10             	lea    0x10(%ebp),%eax
  8020e5:	83 c0 04             	add    $0x4,%eax
  8020e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8020eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f1:	50                   	push   %eax
  8020f2:	ff 75 0c             	pushl  0xc(%ebp)
  8020f5:	ff 75 08             	pushl  0x8(%ebp)
  8020f8:	e8 89 ff ff ff       	call   802086 <vsnprintf>
  8020fd:	83 c4 10             	add    $0x10,%esp
  802100:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802103:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80210e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802115:	eb 06                	jmp    80211d <strlen+0x15>
		n++;
  802117:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80211a:	ff 45 08             	incl   0x8(%ebp)
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	8a 00                	mov    (%eax),%al
  802122:	84 c0                	test   %al,%al
  802124:	75 f1                	jne    802117 <strlen+0xf>
		n++;
	return n;
  802126:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802138:	eb 09                	jmp    802143 <strnlen+0x18>
		n++;
  80213a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80213d:	ff 45 08             	incl   0x8(%ebp)
  802140:	ff 4d 0c             	decl   0xc(%ebp)
  802143:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802147:	74 09                	je     802152 <strnlen+0x27>
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8a 00                	mov    (%eax),%al
  80214e:	84 c0                	test   %al,%al
  802150:	75 e8                	jne    80213a <strnlen+0xf>
		n++;
	return n;
  802152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802163:	90                   	nop
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	8d 50 01             	lea    0x1(%eax),%edx
  80216a:	89 55 08             	mov    %edx,0x8(%ebp)
  80216d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802170:	8d 4a 01             	lea    0x1(%edx),%ecx
  802173:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802176:	8a 12                	mov    (%edx),%dl
  802178:	88 10                	mov    %dl,(%eax)
  80217a:	8a 00                	mov    (%eax),%al
  80217c:	84 c0                	test   %al,%al
  80217e:	75 e4                	jne    802164 <strcpy+0xd>
		/* do nothing */;
	return ret;
  802180:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802191:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802198:	eb 1f                	jmp    8021b9 <strncpy+0x34>
		*dst++ = *src;
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8d 50 01             	lea    0x1(%eax),%edx
  8021a0:	89 55 08             	mov    %edx,0x8(%ebp)
  8021a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a6:	8a 12                	mov    (%edx),%dl
  8021a8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8021aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ad:	8a 00                	mov    (%eax),%al
  8021af:	84 c0                	test   %al,%al
  8021b1:	74 03                	je     8021b6 <strncpy+0x31>
			src++;
  8021b3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8021b6:	ff 45 fc             	incl   -0x4(%ebp)
  8021b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021bc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021bf:	72 d9                	jb     80219a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8021c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8021d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021d6:	74 30                	je     802208 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8021d8:	eb 16                	jmp    8021f0 <strlcpy+0x2a>
			*dst++ = *src++;
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	8d 50 01             	lea    0x1(%eax),%edx
  8021e0:	89 55 08             	mov    %edx,0x8(%ebp)
  8021e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8021ec:	8a 12                	mov    (%edx),%dl
  8021ee:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8021f0:	ff 4d 10             	decl   0x10(%ebp)
  8021f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021f7:	74 09                	je     802202 <strlcpy+0x3c>
  8021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fc:	8a 00                	mov    (%eax),%al
  8021fe:	84 c0                	test   %al,%al
  802200:	75 d8                	jne    8021da <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802208:	8b 55 08             	mov    0x8(%ebp),%edx
  80220b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220e:	29 c2                	sub    %eax,%edx
  802210:	89 d0                	mov    %edx,%eax
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802217:	eb 06                	jmp    80221f <strcmp+0xb>
		p++, q++;
  802219:	ff 45 08             	incl   0x8(%ebp)
  80221c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	8a 00                	mov    (%eax),%al
  802224:	84 c0                	test   %al,%al
  802226:	74 0e                	je     802236 <strcmp+0x22>
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8a 10                	mov    (%eax),%dl
  80222d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802230:	8a 00                	mov    (%eax),%al
  802232:	38 c2                	cmp    %al,%dl
  802234:	74 e3                	je     802219 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	8a 00                	mov    (%eax),%al
  80223b:	0f b6 d0             	movzbl %al,%edx
  80223e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802241:	8a 00                	mov    (%eax),%al
  802243:	0f b6 c0             	movzbl %al,%eax
  802246:	29 c2                	sub    %eax,%edx
  802248:	89 d0                	mov    %edx,%eax
}
  80224a:	5d                   	pop    %ebp
  80224b:	c3                   	ret    

0080224c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80224f:	eb 09                	jmp    80225a <strncmp+0xe>
		n--, p++, q++;
  802251:	ff 4d 10             	decl   0x10(%ebp)
  802254:	ff 45 08             	incl   0x8(%ebp)
  802257:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80225a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80225e:	74 17                	je     802277 <strncmp+0x2b>
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	8a 00                	mov    (%eax),%al
  802265:	84 c0                	test   %al,%al
  802267:	74 0e                	je     802277 <strncmp+0x2b>
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	8a 10                	mov    (%eax),%dl
  80226e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802271:	8a 00                	mov    (%eax),%al
  802273:	38 c2                	cmp    %al,%dl
  802275:	74 da                	je     802251 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802277:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80227b:	75 07                	jne    802284 <strncmp+0x38>
		return 0;
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
  802282:	eb 14                	jmp    802298 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	8a 00                	mov    (%eax),%al
  802289:	0f b6 d0             	movzbl %al,%edx
  80228c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228f:	8a 00                	mov    (%eax),%al
  802291:	0f b6 c0             	movzbl %al,%eax
  802294:	29 c2                	sub    %eax,%edx
  802296:	89 d0                	mov    %edx,%eax
}
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    

0080229a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 04             	sub    $0x4,%esp
  8022a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022a6:	eb 12                	jmp    8022ba <strchr+0x20>
		if (*s == c)
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	8a 00                	mov    (%eax),%al
  8022ad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022b0:	75 05                	jne    8022b7 <strchr+0x1d>
			return (char *) s;
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	eb 11                	jmp    8022c8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8022b7:	ff 45 08             	incl   0x8(%ebp)
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	8a 00                	mov    (%eax),%al
  8022bf:	84 c0                	test   %al,%al
  8022c1:	75 e5                	jne    8022a8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022d6:	eb 0d                	jmp    8022e5 <strfind+0x1b>
		if (*s == c)
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	8a 00                	mov    (%eax),%al
  8022dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022e0:	74 0e                	je     8022f0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8022e2:	ff 45 08             	incl   0x8(%ebp)
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8a 00                	mov    (%eax),%al
  8022ea:	84 c0                	test   %al,%al
  8022ec:	75 ea                	jne    8022d8 <strfind+0xe>
  8022ee:	eb 01                	jmp    8022f1 <strfind+0x27>
		if (*s == c)
			break;
  8022f0:	90                   	nop
	return (char *) s;
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802302:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802306:	76 63                	jbe    80236b <memset+0x75>
		uint64 data_block = c;
  802308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230b:	99                   	cltd   
  80230c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80230f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802315:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802318:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80231c:	c1 e0 08             	shl    $0x8,%eax
  80231f:	09 45 f0             	or     %eax,-0x10(%ebp)
  802322:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80232f:	c1 e0 10             	shl    $0x10,%eax
  802332:	09 45 f0             	or     %eax,-0x10(%ebp)
  802335:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233e:	89 c2                	mov    %eax,%edx
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	09 45 f0             	or     %eax,-0x10(%ebp)
  802348:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80234b:	eb 18                	jmp    802365 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80234d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802350:	8d 41 08             	lea    0x8(%ecx),%eax
  802353:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802359:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235c:	89 01                	mov    %eax,(%ecx)
  80235e:	89 51 04             	mov    %edx,0x4(%ecx)
  802361:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802365:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802369:	77 e2                	ja     80234d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80236b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80236f:	74 23                	je     802394 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802371:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802374:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802377:	eb 0e                	jmp    802387 <memset+0x91>
			*p8++ = (uint8)c;
  802379:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80237c:	8d 50 01             	lea    0x1(%eax),%edx
  80237f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802382:	8b 55 0c             	mov    0xc(%ebp),%edx
  802385:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  802387:	8b 45 10             	mov    0x10(%ebp),%eax
  80238a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80238d:	89 55 10             	mov    %edx,0x10(%ebp)
  802390:	85 c0                	test   %eax,%eax
  802392:	75 e5                	jne    802379 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80239f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8023ab:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023af:	76 24                	jbe    8023d5 <memcpy+0x3c>
		while(n >= 8){
  8023b1:	eb 1c                	jmp    8023cf <memcpy+0x36>
			*d64 = *s64;
  8023b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b6:	8b 50 04             	mov    0x4(%eax),%edx
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8023be:	89 01                	mov    %eax,(%ecx)
  8023c0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8023c3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8023c7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8023cb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8023cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023d3:	77 de                	ja     8023b3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8023d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d9:	74 31                	je     80240c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8023db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8023e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8023e7:	eb 16                	jmp    8023ff <memcpy+0x66>
			*d8++ = *s8++;
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	8d 50 01             	lea    0x1(%eax),%edx
  8023ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8023f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8023f8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8023fb:	8a 12                	mov    (%edx),%dl
  8023fd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8023ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802402:	8d 50 ff             	lea    -0x1(%eax),%edx
  802405:	89 55 10             	mov    %edx,0x10(%ebp)
  802408:	85 c0                	test   %eax,%eax
  80240a:	75 dd                	jne    8023e9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802426:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802429:	73 50                	jae    80247b <memmove+0x6a>
  80242b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80242e:	8b 45 10             	mov    0x10(%ebp),%eax
  802431:	01 d0                	add    %edx,%eax
  802433:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802436:	76 43                	jbe    80247b <memmove+0x6a>
		s += n;
  802438:	8b 45 10             	mov    0x10(%ebp),%eax
  80243b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80243e:	8b 45 10             	mov    0x10(%ebp),%eax
  802441:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802444:	eb 10                	jmp    802456 <memmove+0x45>
			*--d = *--s;
  802446:	ff 4d f8             	decl   -0x8(%ebp)
  802449:	ff 4d fc             	decl   -0x4(%ebp)
  80244c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80244f:	8a 10                	mov    (%eax),%dl
  802451:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802454:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802456:	8b 45 10             	mov    0x10(%ebp),%eax
  802459:	8d 50 ff             	lea    -0x1(%eax),%edx
  80245c:	89 55 10             	mov    %edx,0x10(%ebp)
  80245f:	85 c0                	test   %eax,%eax
  802461:	75 e3                	jne    802446 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802463:	eb 23                	jmp    802488 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802465:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802468:	8d 50 01             	lea    0x1(%eax),%edx
  80246b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80246e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802471:	8d 4a 01             	lea    0x1(%edx),%ecx
  802474:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802477:	8a 12                	mov    (%edx),%dl
  802479:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80247b:	8b 45 10             	mov    0x10(%ebp),%eax
  80247e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802481:	89 55 10             	mov    %edx,0x10(%ebp)
  802484:	85 c0                	test   %eax,%eax
  802486:	75 dd                	jne    802465 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80249f:	eb 2a                	jmp    8024cb <memcmp+0x3e>
		if (*s1 != *s2)
  8024a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024a4:	8a 10                	mov    (%eax),%dl
  8024a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a9:	8a 00                	mov    (%eax),%al
  8024ab:	38 c2                	cmp    %al,%dl
  8024ad:	74 16                	je     8024c5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8024af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024b2:	8a 00                	mov    (%eax),%al
  8024b4:	0f b6 d0             	movzbl %al,%edx
  8024b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024ba:	8a 00                	mov    (%eax),%al
  8024bc:	0f b6 c0             	movzbl %al,%eax
  8024bf:	29 c2                	sub    %eax,%edx
  8024c1:	89 d0                	mov    %edx,%eax
  8024c3:	eb 18                	jmp    8024dd <memcmp+0x50>
		s1++, s2++;
  8024c5:	ff 45 fc             	incl   -0x4(%ebp)
  8024c8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8024cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	75 c9                	jne    8024a1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8024e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024eb:	01 d0                	add    %edx,%eax
  8024ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8024f0:	eb 15                	jmp    802507 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	8a 00                	mov    (%eax),%al
  8024f7:	0f b6 d0             	movzbl %al,%edx
  8024fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fd:	0f b6 c0             	movzbl %al,%eax
  802500:	39 c2                	cmp    %eax,%edx
  802502:	74 0d                	je     802511 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802504:	ff 45 08             	incl   0x8(%ebp)
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80250d:	72 e3                	jb     8024f2 <memfind+0x13>
  80250f:	eb 01                	jmp    802512 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802511:	90                   	nop
	return (void *) s;
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80251d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802524:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80252b:	eb 03                	jmp    802530 <strtol+0x19>
		s++;
  80252d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	8a 00                	mov    (%eax),%al
  802535:	3c 20                	cmp    $0x20,%al
  802537:	74 f4                	je     80252d <strtol+0x16>
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	8a 00                	mov    (%eax),%al
  80253e:	3c 09                	cmp    $0x9,%al
  802540:	74 eb                	je     80252d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	8a 00                	mov    (%eax),%al
  802547:	3c 2b                	cmp    $0x2b,%al
  802549:	75 05                	jne    802550 <strtol+0x39>
		s++;
  80254b:	ff 45 08             	incl   0x8(%ebp)
  80254e:	eb 13                	jmp    802563 <strtol+0x4c>
	else if (*s == '-')
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	8a 00                	mov    (%eax),%al
  802555:	3c 2d                	cmp    $0x2d,%al
  802557:	75 0a                	jne    802563 <strtol+0x4c>
		s++, neg = 1;
  802559:	ff 45 08             	incl   0x8(%ebp)
  80255c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802563:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802567:	74 06                	je     80256f <strtol+0x58>
  802569:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80256d:	75 20                	jne    80258f <strtol+0x78>
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	8a 00                	mov    (%eax),%al
  802574:	3c 30                	cmp    $0x30,%al
  802576:	75 17                	jne    80258f <strtol+0x78>
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	40                   	inc    %eax
  80257c:	8a 00                	mov    (%eax),%al
  80257e:	3c 78                	cmp    $0x78,%al
  802580:	75 0d                	jne    80258f <strtol+0x78>
		s += 2, base = 16;
  802582:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802586:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80258d:	eb 28                	jmp    8025b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80258f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802593:	75 15                	jne    8025aa <strtol+0x93>
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8a 00                	mov    (%eax),%al
  80259a:	3c 30                	cmp    $0x30,%al
  80259c:	75 0c                	jne    8025aa <strtol+0x93>
		s++, base = 8;
  80259e:	ff 45 08             	incl   0x8(%ebp)
  8025a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8025a8:	eb 0d                	jmp    8025b7 <strtol+0xa0>
	else if (base == 0)
  8025aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025ae:	75 07                	jne    8025b7 <strtol+0xa0>
		base = 10;
  8025b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	8a 00                	mov    (%eax),%al
  8025bc:	3c 2f                	cmp    $0x2f,%al
  8025be:	7e 19                	jle    8025d9 <strtol+0xc2>
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	8a 00                	mov    (%eax),%al
  8025c5:	3c 39                	cmp    $0x39,%al
  8025c7:	7f 10                	jg     8025d9 <strtol+0xc2>
			dig = *s - '0';
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	8a 00                	mov    (%eax),%al
  8025ce:	0f be c0             	movsbl %al,%eax
  8025d1:	83 e8 30             	sub    $0x30,%eax
  8025d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d7:	eb 42                	jmp    80261b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8a 00                	mov    (%eax),%al
  8025de:	3c 60                	cmp    $0x60,%al
  8025e0:	7e 19                	jle    8025fb <strtol+0xe4>
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8a 00                	mov    (%eax),%al
  8025e7:	3c 7a                	cmp    $0x7a,%al
  8025e9:	7f 10                	jg     8025fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	8a 00                	mov    (%eax),%al
  8025f0:	0f be c0             	movsbl %al,%eax
  8025f3:	83 e8 57             	sub    $0x57,%eax
  8025f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f9:	eb 20                	jmp    80261b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	8a 00                	mov    (%eax),%al
  802600:	3c 40                	cmp    $0x40,%al
  802602:	7e 39                	jle    80263d <strtol+0x126>
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	8a 00                	mov    (%eax),%al
  802609:	3c 5a                	cmp    $0x5a,%al
  80260b:	7f 30                	jg     80263d <strtol+0x126>
			dig = *s - 'A' + 10;
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8a 00                	mov    (%eax),%al
  802612:	0f be c0             	movsbl %al,%eax
  802615:	83 e8 37             	sub    $0x37,%eax
  802618:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	3b 45 10             	cmp    0x10(%ebp),%eax
  802621:	7d 19                	jge    80263c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802623:	ff 45 08             	incl   0x8(%ebp)
  802626:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802629:	0f af 45 10          	imul   0x10(%ebp),%eax
  80262d:	89 c2                	mov    %eax,%edx
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	01 d0                	add    %edx,%eax
  802634:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802637:	e9 7b ff ff ff       	jmp    8025b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80263c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80263d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802641:	74 08                	je     80264b <strtol+0x134>
		*endptr = (char *) s;
  802643:	8b 45 0c             	mov    0xc(%ebp),%eax
  802646:	8b 55 08             	mov    0x8(%ebp),%edx
  802649:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80264b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80264f:	74 07                	je     802658 <strtol+0x141>
  802651:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802654:	f7 d8                	neg    %eax
  802656:	eb 03                	jmp    80265b <strtol+0x144>
  802658:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <ltostr>:

void
ltostr(long value, char *str)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
  802660:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802663:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80266a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802671:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802675:	79 13                	jns    80268a <ltostr+0x2d>
	{
		neg = 1;
  802677:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80267e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802681:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802684:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802687:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80268a:	8b 45 08             	mov    0x8(%ebp),%eax
  80268d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802692:	99                   	cltd   
  802693:	f7 f9                	idiv   %ecx
  802695:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80269b:	8d 50 01             	lea    0x1(%eax),%edx
  80269e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8026a1:	89 c2                	mov    %eax,%edx
  8026a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a6:	01 d0                	add    %edx,%eax
  8026a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ab:	83 c2 30             	add    $0x30,%edx
  8026ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8026b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8026b8:	f7 e9                	imul   %ecx
  8026ba:	c1 fa 02             	sar    $0x2,%edx
  8026bd:	89 c8                	mov    %ecx,%eax
  8026bf:	c1 f8 1f             	sar    $0x1f,%eax
  8026c2:	29 c2                	sub    %eax,%edx
  8026c4:	89 d0                	mov    %edx,%eax
  8026c6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8026c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026cd:	75 bb                	jne    80268a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8026cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8026d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026d9:	48                   	dec    %eax
  8026da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8026dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026e1:	74 3d                	je     802720 <ltostr+0xc3>
		start = 1 ;
  8026e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8026ea:	eb 34                	jmp    802720 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8026ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f2:	01 d0                	add    %edx,%eax
  8026f4:	8a 00                	mov    (%eax),%al
  8026f6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8026f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ff:	01 c2                	add    %eax,%edx
  802701:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802704:	8b 45 0c             	mov    0xc(%ebp),%eax
  802707:	01 c8                	add    %ecx,%eax
  802709:	8a 00                	mov    (%eax),%al
  80270b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80270d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802710:	8b 45 0c             	mov    0xc(%ebp),%eax
  802713:	01 c2                	add    %eax,%edx
  802715:	8a 45 eb             	mov    -0x15(%ebp),%al
  802718:	88 02                	mov    %al,(%edx)
		start++ ;
  80271a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80271d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802726:	7c c4                	jl     8026ec <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802728:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80272b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272e:	01 d0                	add    %edx,%eax
  802730:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802733:	90                   	nop
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80273c:	ff 75 08             	pushl  0x8(%ebp)
  80273f:	e8 c4 f9 ff ff       	call   802108 <strlen>
  802744:	83 c4 04             	add    $0x4,%esp
  802747:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80274a:	ff 75 0c             	pushl  0xc(%ebp)
  80274d:	e8 b6 f9 ff ff       	call   802108 <strlen>
  802752:	83 c4 04             	add    $0x4,%esp
  802755:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802758:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80275f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802766:	eb 17                	jmp    80277f <strcconcat+0x49>
		final[s] = str1[s] ;
  802768:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80276b:	8b 45 10             	mov    0x10(%ebp),%eax
  80276e:	01 c2                	add    %eax,%edx
  802770:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	01 c8                	add    %ecx,%eax
  802778:	8a 00                	mov    (%eax),%al
  80277a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80277c:	ff 45 fc             	incl   -0x4(%ebp)
  80277f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802782:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802785:	7c e1                	jl     802768 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802787:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80278e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802795:	eb 1f                	jmp    8027b6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802797:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80279a:	8d 50 01             	lea    0x1(%eax),%edx
  80279d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8027a0:	89 c2                	mov    %eax,%edx
  8027a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a5:	01 c2                	add    %eax,%edx
  8027a7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8027aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ad:	01 c8                	add    %ecx,%eax
  8027af:	8a 00                	mov    (%eax),%al
  8027b1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8027b3:	ff 45 f8             	incl   -0x8(%ebp)
  8027b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027bc:	7c d9                	jl     802797 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8027be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c4:	01 d0                	add    %edx,%eax
  8027c6:	c6 00 00             	movb   $0x0,(%eax)
}
  8027c9:	90                   	nop
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8027cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8027d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8027d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8027e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8027e7:	01 d0                	add    %edx,%eax
  8027e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8027ef:	eb 0c                	jmp    8027fd <strsplit+0x31>
			*string++ = 0;
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	8d 50 01             	lea    0x1(%eax),%edx
  8027f7:	89 55 08             	mov    %edx,0x8(%ebp)
  8027fa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	8a 00                	mov    (%eax),%al
  802802:	84 c0                	test   %al,%al
  802804:	74 18                	je     80281e <strsplit+0x52>
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	8a 00                	mov    (%eax),%al
  80280b:	0f be c0             	movsbl %al,%eax
  80280e:	50                   	push   %eax
  80280f:	ff 75 0c             	pushl  0xc(%ebp)
  802812:	e8 83 fa ff ff       	call   80229a <strchr>
  802817:	83 c4 08             	add    $0x8,%esp
  80281a:	85 c0                	test   %eax,%eax
  80281c:	75 d3                	jne    8027f1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	8a 00                	mov    (%eax),%al
  802823:	84 c0                	test   %al,%al
  802825:	74 5a                	je     802881 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802827:	8b 45 14             	mov    0x14(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	83 f8 0f             	cmp    $0xf,%eax
  80282f:	75 07                	jne    802838 <strsplit+0x6c>
		{
			return 0;
  802831:	b8 00 00 00 00       	mov    $0x0,%eax
  802836:	eb 66                	jmp    80289e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802838:	8b 45 14             	mov    0x14(%ebp),%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	8d 48 01             	lea    0x1(%eax),%ecx
  802840:	8b 55 14             	mov    0x14(%ebp),%edx
  802843:	89 0a                	mov    %ecx,(%edx)
  802845:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80284c:	8b 45 10             	mov    0x10(%ebp),%eax
  80284f:	01 c2                	add    %eax,%edx
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802856:	eb 03                	jmp    80285b <strsplit+0x8f>
			string++;
  802858:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	8a 00                	mov    (%eax),%al
  802860:	84 c0                	test   %al,%al
  802862:	74 8b                	je     8027ef <strsplit+0x23>
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	8a 00                	mov    (%eax),%al
  802869:	0f be c0             	movsbl %al,%eax
  80286c:	50                   	push   %eax
  80286d:	ff 75 0c             	pushl  0xc(%ebp)
  802870:	e8 25 fa ff ff       	call   80229a <strchr>
  802875:	83 c4 08             	add    $0x8,%esp
  802878:	85 c0                	test   %eax,%eax
  80287a:	74 dc                	je     802858 <strsplit+0x8c>
			string++;
	}
  80287c:	e9 6e ff ff ff       	jmp    8027ef <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802881:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802882:	8b 45 14             	mov    0x14(%ebp),%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80288e:	8b 45 10             	mov    0x10(%ebp),%eax
  802891:	01 d0                	add    %edx,%eax
  802893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802899:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80289e:	c9                   	leave  
  80289f:	c3                   	ret    

008028a0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8028ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8028b3:	eb 4a                	jmp    8028ff <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8028b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	01 c2                	add    %eax,%edx
  8028bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8028c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c3:	01 c8                	add    %ecx,%eax
  8028c5:	8a 00                	mov    (%eax),%al
  8028c7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8028c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028cf:	01 d0                	add    %edx,%eax
  8028d1:	8a 00                	mov    (%eax),%al
  8028d3:	3c 40                	cmp    $0x40,%al
  8028d5:	7e 25                	jle    8028fc <str2lower+0x5c>
  8028d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028dd:	01 d0                	add    %edx,%eax
  8028df:	8a 00                	mov    (%eax),%al
  8028e1:	3c 5a                	cmp    $0x5a,%al
  8028e3:	7f 17                	jg     8028fc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8028e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	01 d0                	add    %edx,%eax
  8028ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8028f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f3:	01 ca                	add    %ecx,%edx
  8028f5:	8a 12                	mov    (%edx),%dl
  8028f7:	83 c2 20             	add    $0x20,%edx
  8028fa:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8028fc:	ff 45 fc             	incl   -0x4(%ebp)
  8028ff:	ff 75 0c             	pushl  0xc(%ebp)
  802902:	e8 01 f8 ff ff       	call   802108 <strlen>
  802907:	83 c4 04             	add    $0x4,%esp
  80290a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80290d:	7f a6                	jg     8028b5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80290f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802912:	c9                   	leave  
  802913:	c3                   	ret    

00802914 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802914:	55                   	push   %ebp
  802915:	89 e5                	mov    %esp,%ebp
  802917:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80291a:	a1 08 60 80 00       	mov    0x806008,%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 42                	je     802965 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802923:	83 ec 08             	sub    $0x8,%esp
  802926:	68 00 00 00 82       	push   $0x82000000
  80292b:	68 00 00 00 80       	push   $0x80000000
  802930:	e8 00 08 00 00       	call   803135 <initialize_dynamic_allocator>
  802935:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802938:	e8 e7 05 00 00       	call   802f24 <sys_get_uheap_strategy>
  80293d:	a3 44 e2 81 00       	mov    %eax,0x81e244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802942:	a1 20 62 80 00       	mov    0x806220,%eax
  802947:	05 00 10 00 00       	add    $0x1000,%eax
  80294c:	a3 f0 e2 81 00       	mov    %eax,0x81e2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802951:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802956:	a3 50 e2 81 00       	mov    %eax,0x81e250

		__firstTimeFlag = 0;
  80295b:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802962:	00 00 00 
	}
}
  802965:	90                   	nop
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80297c:	83 ec 08             	sub    $0x8,%esp
  80297f:	68 06 04 00 00       	push   $0x406
  802984:	50                   	push   %eax
  802985:	e8 e4 01 00 00       	call   802b6e <__sys_allocate_page>
  80298a:	83 c4 10             	add    $0x10,%esp
  80298d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802990:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802994:	79 14                	jns    8029aa <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802996:	83 ec 04             	sub    $0x4,%esp
  802999:	68 e8 4d 80 00       	push   $0x804de8
  80299e:	6a 1f                	push   $0x1f
  8029a0:	68 24 4e 80 00       	push   $0x804e24
  8029a5:	e8 b7 ed ff ff       	call   801761 <_panic>
	return 0;
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
  8029b4:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029c5:	83 ec 0c             	sub    $0xc,%esp
  8029c8:	50                   	push   %eax
  8029c9:	e8 e7 01 00 00       	call   802bb5 <__sys_unmap_frame>
  8029ce:	83 c4 10             	add    $0x10,%esp
  8029d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8029d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d8:	79 14                	jns    8029ee <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8029da:	83 ec 04             	sub    $0x4,%esp
  8029dd:	68 30 4e 80 00       	push   $0x804e30
  8029e2:	6a 2a                	push   $0x2a
  8029e4:	68 24 4e 80 00       	push   $0x804e24
  8029e9:	e8 73 ed ff ff       	call   801761 <_panic>
}
  8029ee:	90                   	nop
  8029ef:	c9                   	leave  
  8029f0:	c3                   	ret    

008029f1 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
  8029f4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8029f7:	e8 18 ff ff ff       	call   802914 <uheap_init>
	if (size == 0) return NULL ;
  8029fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a00:	75 07                	jne    802a09 <malloc+0x18>
  802a02:	b8 00 00 00 00       	mov    $0x0,%eax
  802a07:	eb 14                	jmp    802a1d <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	68 70 4e 80 00       	push   $0x804e70
  802a11:	6a 3e                	push   $0x3e
  802a13:	68 24 4e 80 00       	push   $0x804e24
  802a18:	e8 44 ed ff ff       	call   801761 <_panic>
}
  802a1d:	c9                   	leave  
  802a1e:	c3                   	ret    

00802a1f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802a1f:	55                   	push   %ebp
  802a20:	89 e5                	mov    %esp,%ebp
  802a22:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802a25:	83 ec 04             	sub    $0x4,%esp
  802a28:	68 98 4e 80 00       	push   $0x804e98
  802a2d:	6a 49                	push   $0x49
  802a2f:	68 24 4e 80 00       	push   $0x804e24
  802a34:	e8 28 ed ff ff       	call   801761 <_panic>

00802a39 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
  802a3c:	83 ec 18             	sub    $0x18,%esp
  802a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  802a42:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a45:	e8 ca fe ff ff       	call   802914 <uheap_init>
	if (size == 0) return NULL ;
  802a4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a4e:	75 07                	jne    802a57 <smalloc+0x1e>
  802a50:	b8 00 00 00 00       	mov    $0x0,%eax
  802a55:	eb 14                	jmp    802a6b <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  802a57:	83 ec 04             	sub    $0x4,%esp
  802a5a:	68 bc 4e 80 00       	push   $0x804ebc
  802a5f:	6a 5a                	push   $0x5a
  802a61:	68 24 4e 80 00       	push   $0x804e24
  802a66:	e8 f6 ec ff ff       	call   801761 <_panic>
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a73:	e8 9c fe ff ff       	call   802914 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  802a78:	83 ec 04             	sub    $0x4,%esp
  802a7b:	68 e4 4e 80 00       	push   $0x804ee4
  802a80:	6a 6a                	push   $0x6a
  802a82:	68 24 4e 80 00       	push   $0x804e24
  802a87:	e8 d5 ec ff ff       	call   801761 <_panic>

00802a8c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a92:	e8 7d fe ff ff       	call   802914 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802a97:	83 ec 04             	sub    $0x4,%esp
  802a9a:	68 08 4f 80 00       	push   $0x804f08
  802a9f:	68 88 00 00 00       	push   $0x88
  802aa4:	68 24 4e 80 00       	push   $0x804e24
  802aa9:	e8 b3 ec ff ff       	call   801761 <_panic>

00802aae <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
  802ab1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802ab4:	83 ec 04             	sub    $0x4,%esp
  802ab7:	68 30 4f 80 00       	push   $0x804f30
  802abc:	68 9b 00 00 00       	push   $0x9b
  802ac1:	68 24 4e 80 00       	push   $0x804e24
  802ac6:	e8 96 ec ff ff       	call   801761 <_panic>

00802acb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
  802ace:	57                   	push   %edi
  802acf:	56                   	push   %esi
  802ad0:	53                   	push   %ebx
  802ad1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ada:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802add:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ae0:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ae3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ae6:	cd 30                	int    $0x30
  802ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802aee:	83 c4 10             	add    $0x10,%esp
  802af1:	5b                   	pop    %ebx
  802af2:	5e                   	pop    %esi
  802af3:	5f                   	pop    %edi
  802af4:	5d                   	pop    %ebp
  802af5:	c3                   	ret    

00802af6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802af6:	55                   	push   %ebp
  802af7:	89 e5                	mov    %esp,%ebp
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	8b 45 10             	mov    0x10(%ebp),%eax
  802aff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802b02:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b05:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	6a 00                	push   $0x0
  802b0e:	51                   	push   %ecx
  802b0f:	52                   	push   %edx
  802b10:	ff 75 0c             	pushl  0xc(%ebp)
  802b13:	50                   	push   %eax
  802b14:	6a 00                	push   $0x0
  802b16:	e8 b0 ff ff ff       	call   802acb <syscall>
  802b1b:	83 c4 18             	add    $0x18,%esp
}
  802b1e:	90                   	nop
  802b1f:	c9                   	leave  
  802b20:	c3                   	ret    

00802b21 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b21:	55                   	push   %ebp
  802b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	6a 00                	push   $0x0
  802b2c:	6a 00                	push   $0x0
  802b2e:	6a 02                	push   $0x2
  802b30:	e8 96 ff ff ff       	call   802acb <syscall>
  802b35:	83 c4 18             	add    $0x18,%esp
}
  802b38:	c9                   	leave  
  802b39:	c3                   	ret    

00802b3a <sys_lock_cons>:

void sys_lock_cons(void)
{
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 03                	push   $0x3
  802b49:	e8 7d ff ff ff       	call   802acb <syscall>
  802b4e:	83 c4 18             	add    $0x18,%esp
}
  802b51:	90                   	nop
  802b52:	c9                   	leave  
  802b53:	c3                   	ret    

00802b54 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802b54:	55                   	push   %ebp
  802b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802b57:	6a 00                	push   $0x0
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 04                	push   $0x4
  802b63:	e8 63 ff ff ff       	call   802acb <syscall>
  802b68:	83 c4 18             	add    $0x18,%esp
}
  802b6b:	90                   	nop
  802b6c:	c9                   	leave  
  802b6d:	c3                   	ret    

00802b6e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	6a 00                	push   $0x0
  802b79:	6a 00                	push   $0x0
  802b7b:	6a 00                	push   $0x0
  802b7d:	52                   	push   %edx
  802b7e:	50                   	push   %eax
  802b7f:	6a 08                	push   $0x8
  802b81:	e8 45 ff ff ff       	call   802acb <syscall>
  802b86:	83 c4 18             	add    $0x18,%esp
}
  802b89:	c9                   	leave  
  802b8a:	c3                   	ret    

00802b8b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802b8b:	55                   	push   %ebp
  802b8c:	89 e5                	mov    %esp,%ebp
  802b8e:	56                   	push   %esi
  802b8f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802b90:	8b 75 18             	mov    0x18(%ebp),%esi
  802b93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	56                   	push   %esi
  802ba0:	53                   	push   %ebx
  802ba1:	51                   	push   %ecx
  802ba2:	52                   	push   %edx
  802ba3:	50                   	push   %eax
  802ba4:	6a 09                	push   $0x9
  802ba6:	e8 20 ff ff ff       	call   802acb <syscall>
  802bab:	83 c4 18             	add    $0x18,%esp
}
  802bae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bb1:	5b                   	pop    %ebx
  802bb2:	5e                   	pop    %esi
  802bb3:	5d                   	pop    %ebp
  802bb4:	c3                   	ret    

00802bb5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802bb5:	55                   	push   %ebp
  802bb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 00                	push   $0x0
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 00                	push   $0x0
  802bc0:	ff 75 08             	pushl  0x8(%ebp)
  802bc3:	6a 0a                	push   $0xa
  802bc5:	e8 01 ff ff ff       	call   802acb <syscall>
  802bca:	83 c4 18             	add    $0x18,%esp
}
  802bcd:	c9                   	leave  
  802bce:	c3                   	ret    

00802bcf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802bcf:	55                   	push   %ebp
  802bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 00                	push   $0x0
  802bd6:	6a 00                	push   $0x0
  802bd8:	ff 75 0c             	pushl  0xc(%ebp)
  802bdb:	ff 75 08             	pushl  0x8(%ebp)
  802bde:	6a 0b                	push   $0xb
  802be0:	e8 e6 fe ff ff       	call   802acb <syscall>
  802be5:	83 c4 18             	add    $0x18,%esp
}
  802be8:	c9                   	leave  
  802be9:	c3                   	ret    

00802bea <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802bea:	55                   	push   %ebp
  802beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802bed:	6a 00                	push   $0x0
  802bef:	6a 00                	push   $0x0
  802bf1:	6a 00                	push   $0x0
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 0c                	push   $0xc
  802bf9:	e8 cd fe ff ff       	call   802acb <syscall>
  802bfe:	83 c4 18             	add    $0x18,%esp
}
  802c01:	c9                   	leave  
  802c02:	c3                   	ret    

00802c03 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c03:	55                   	push   %ebp
  802c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c06:	6a 00                	push   $0x0
  802c08:	6a 00                	push   $0x0
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 0d                	push   $0xd
  802c12:	e8 b4 fe ff ff       	call   802acb <syscall>
  802c17:	83 c4 18             	add    $0x18,%esp
}
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 00                	push   $0x0
  802c23:	6a 00                	push   $0x0
  802c25:	6a 00                	push   $0x0
  802c27:	6a 00                	push   $0x0
  802c29:	6a 0e                	push   $0xe
  802c2b:	e8 9b fe ff ff       	call   802acb <syscall>
  802c30:	83 c4 18             	add    $0x18,%esp
}
  802c33:	c9                   	leave  
  802c34:	c3                   	ret    

00802c35 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c35:	55                   	push   %ebp
  802c36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c38:	6a 00                	push   $0x0
  802c3a:	6a 00                	push   $0x0
  802c3c:	6a 00                	push   $0x0
  802c3e:	6a 00                	push   $0x0
  802c40:	6a 00                	push   $0x0
  802c42:	6a 0f                	push   $0xf
  802c44:	e8 82 fe ff ff       	call   802acb <syscall>
  802c49:	83 c4 18             	add    $0x18,%esp
}
  802c4c:	c9                   	leave  
  802c4d:	c3                   	ret    

00802c4e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802c4e:	55                   	push   %ebp
  802c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	6a 00                	push   $0x0
  802c59:	ff 75 08             	pushl  0x8(%ebp)
  802c5c:	6a 10                	push   $0x10
  802c5e:	e8 68 fe ff ff       	call   802acb <syscall>
  802c63:	83 c4 18             	add    $0x18,%esp
}
  802c66:	c9                   	leave  
  802c67:	c3                   	ret    

00802c68 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802c68:	55                   	push   %ebp
  802c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	6a 00                	push   $0x0
  802c71:	6a 00                	push   $0x0
  802c73:	6a 00                	push   $0x0
  802c75:	6a 11                	push   $0x11
  802c77:	e8 4f fe ff ff       	call   802acb <syscall>
  802c7c:	83 c4 18             	add    $0x18,%esp
}
  802c7f:	90                   	nop
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <sys_cputc>:

void
sys_cputc(const char c)
{
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
  802c85:	83 ec 04             	sub    $0x4,%esp
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802c8e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c92:	6a 00                	push   $0x0
  802c94:	6a 00                	push   $0x0
  802c96:	6a 00                	push   $0x0
  802c98:	6a 00                	push   $0x0
  802c9a:	50                   	push   %eax
  802c9b:	6a 01                	push   $0x1
  802c9d:	e8 29 fe ff ff       	call   802acb <syscall>
  802ca2:	83 c4 18             	add    $0x18,%esp
}
  802ca5:	90                   	nop
  802ca6:	c9                   	leave  
  802ca7:	c3                   	ret    

00802ca8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ca8:	55                   	push   %ebp
  802ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 14                	push   $0x14
  802cb7:	e8 0f fe ff ff       	call   802acb <syscall>
  802cbc:	83 c4 18             	add    $0x18,%esp
}
  802cbf:	90                   	nop
  802cc0:	c9                   	leave  
  802cc1:	c3                   	ret    

00802cc2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802cc2:	55                   	push   %ebp
  802cc3:	89 e5                	mov    %esp,%ebp
  802cc5:	83 ec 04             	sub    $0x4,%esp
  802cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  802ccb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802cce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802cd1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	6a 00                	push   $0x0
  802cda:	51                   	push   %ecx
  802cdb:	52                   	push   %edx
  802cdc:	ff 75 0c             	pushl  0xc(%ebp)
  802cdf:	50                   	push   %eax
  802ce0:	6a 15                	push   $0x15
  802ce2:	e8 e4 fd ff ff       	call   802acb <syscall>
  802ce7:	83 c4 18             	add    $0x18,%esp
}
  802cea:	c9                   	leave  
  802ceb:	c3                   	ret    

00802cec <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802cec:	55                   	push   %ebp
  802ced:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	6a 00                	push   $0x0
  802cfb:	52                   	push   %edx
  802cfc:	50                   	push   %eax
  802cfd:	6a 16                	push   $0x16
  802cff:	e8 c7 fd ff ff       	call   802acb <syscall>
  802d04:	83 c4 18             	add    $0x18,%esp
}
  802d07:	c9                   	leave  
  802d08:	c3                   	ret    

00802d09 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802d09:	55                   	push   %ebp
  802d0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	51                   	push   %ecx
  802d1a:	52                   	push   %edx
  802d1b:	50                   	push   %eax
  802d1c:	6a 17                	push   $0x17
  802d1e:	e8 a8 fd ff ff       	call   802acb <syscall>
  802d23:	83 c4 18             	add    $0x18,%esp
}
  802d26:	c9                   	leave  
  802d27:	c3                   	ret    

00802d28 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802d28:	55                   	push   %ebp
  802d29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	6a 00                	push   $0x0
  802d33:	6a 00                	push   $0x0
  802d35:	6a 00                	push   $0x0
  802d37:	52                   	push   %edx
  802d38:	50                   	push   %eax
  802d39:	6a 18                	push   $0x18
  802d3b:	e8 8b fd ff ff       	call   802acb <syscall>
  802d40:	83 c4 18             	add    $0x18,%esp
}
  802d43:	c9                   	leave  
  802d44:	c3                   	ret    

00802d45 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d45:	55                   	push   %ebp
  802d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	6a 00                	push   $0x0
  802d4d:	ff 75 14             	pushl  0x14(%ebp)
  802d50:	ff 75 10             	pushl  0x10(%ebp)
  802d53:	ff 75 0c             	pushl  0xc(%ebp)
  802d56:	50                   	push   %eax
  802d57:	6a 19                	push   $0x19
  802d59:	e8 6d fd ff ff       	call   802acb <syscall>
  802d5e:	83 c4 18             	add    $0x18,%esp
}
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 00                	push   $0x0
  802d71:	50                   	push   %eax
  802d72:	6a 1a                	push   $0x1a
  802d74:	e8 52 fd ff ff       	call   802acb <syscall>
  802d79:	83 c4 18             	add    $0x18,%esp
}
  802d7c:	90                   	nop
  802d7d:	c9                   	leave  
  802d7e:	c3                   	ret    

00802d7f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d7f:	55                   	push   %ebp
  802d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	6a 00                	push   $0x0
  802d87:	6a 00                	push   $0x0
  802d89:	6a 00                	push   $0x0
  802d8b:	6a 00                	push   $0x0
  802d8d:	50                   	push   %eax
  802d8e:	6a 1b                	push   $0x1b
  802d90:	e8 36 fd ff ff       	call   802acb <syscall>
  802d95:	83 c4 18             	add    $0x18,%esp
}
  802d98:	c9                   	leave  
  802d99:	c3                   	ret    

00802d9a <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d9a:	55                   	push   %ebp
  802d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	6a 00                	push   $0x0
  802da5:	6a 00                	push   $0x0
  802da7:	6a 05                	push   $0x5
  802da9:	e8 1d fd ff ff       	call   802acb <syscall>
  802dae:	83 c4 18             	add    $0x18,%esp
}
  802db1:	c9                   	leave  
  802db2:	c3                   	ret    

00802db3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802db3:	55                   	push   %ebp
  802db4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802db6:	6a 00                	push   $0x0
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 06                	push   $0x6
  802dc2:	e8 04 fd ff ff       	call   802acb <syscall>
  802dc7:	83 c4 18             	add    $0x18,%esp
}
  802dca:	c9                   	leave  
  802dcb:	c3                   	ret    

00802dcc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802dcc:	55                   	push   %ebp
  802dcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802dcf:	6a 00                	push   $0x0
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	6a 00                	push   $0x0
  802dd7:	6a 00                	push   $0x0
  802dd9:	6a 07                	push   $0x7
  802ddb:	e8 eb fc ff ff       	call   802acb <syscall>
  802de0:	83 c4 18             	add    $0x18,%esp
}
  802de3:	c9                   	leave  
  802de4:	c3                   	ret    

00802de5 <sys_exit_env>:


void sys_exit_env(void)
{
  802de5:	55                   	push   %ebp
  802de6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 00                	push   $0x0
  802df0:	6a 00                	push   $0x0
  802df2:	6a 1c                	push   $0x1c
  802df4:	e8 d2 fc ff ff       	call   802acb <syscall>
  802df9:	83 c4 18             	add    $0x18,%esp
}
  802dfc:	90                   	nop
  802dfd:	c9                   	leave  
  802dfe:	c3                   	ret    

00802dff <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802dff:	55                   	push   %ebp
  802e00:	89 e5                	mov    %esp,%ebp
  802e02:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e05:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e08:	8d 50 04             	lea    0x4(%eax),%edx
  802e0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e0e:	6a 00                	push   $0x0
  802e10:	6a 00                	push   $0x0
  802e12:	6a 00                	push   $0x0
  802e14:	52                   	push   %edx
  802e15:	50                   	push   %eax
  802e16:	6a 1d                	push   $0x1d
  802e18:	e8 ae fc ff ff       	call   802acb <syscall>
  802e1d:	83 c4 18             	add    $0x18,%esp
	return result;
  802e20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e26:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e29:	89 01                	mov    %eax,(%ecx)
  802e2b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	c9                   	leave  
  802e32:	c2 04 00             	ret    $0x4

00802e35 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e35:	55                   	push   %ebp
  802e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 00                	push   $0x0
  802e3c:	ff 75 10             	pushl  0x10(%ebp)
  802e3f:	ff 75 0c             	pushl  0xc(%ebp)
  802e42:	ff 75 08             	pushl  0x8(%ebp)
  802e45:	6a 13                	push   $0x13
  802e47:	e8 7f fc ff ff       	call   802acb <syscall>
  802e4c:	83 c4 18             	add    $0x18,%esp
	return ;
  802e4f:	90                   	nop
}
  802e50:	c9                   	leave  
  802e51:	c3                   	ret    

00802e52 <sys_rcr2>:
uint32 sys_rcr2()
{
  802e52:	55                   	push   %ebp
  802e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 1e                	push   $0x1e
  802e61:	e8 65 fc ff ff       	call   802acb <syscall>
  802e66:	83 c4 18             	add    $0x18,%esp
}
  802e69:	c9                   	leave  
  802e6a:	c3                   	ret    

00802e6b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
  802e6e:	83 ec 04             	sub    $0x4,%esp
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e77:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e7b:	6a 00                	push   $0x0
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	50                   	push   %eax
  802e84:	6a 1f                	push   $0x1f
  802e86:	e8 40 fc ff ff       	call   802acb <syscall>
  802e8b:	83 c4 18             	add    $0x18,%esp
	return ;
  802e8e:	90                   	nop
}
  802e8f:	c9                   	leave  
  802e90:	c3                   	ret    

00802e91 <rsttst>:
void rsttst()
{
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e94:	6a 00                	push   $0x0
  802e96:	6a 00                	push   $0x0
  802e98:	6a 00                	push   $0x0
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 21                	push   $0x21
  802ea0:	e8 26 fc ff ff       	call   802acb <syscall>
  802ea5:	83 c4 18             	add    $0x18,%esp
	return ;
  802ea8:	90                   	nop
}
  802ea9:	c9                   	leave  
  802eaa:	c3                   	ret    

00802eab <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802eab:	55                   	push   %ebp
  802eac:	89 e5                	mov    %esp,%ebp
  802eae:	83 ec 04             	sub    $0x4,%esp
  802eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  802eb4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802eb7:	8b 55 18             	mov    0x18(%ebp),%edx
  802eba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ebe:	52                   	push   %edx
  802ebf:	50                   	push   %eax
  802ec0:	ff 75 10             	pushl  0x10(%ebp)
  802ec3:	ff 75 0c             	pushl  0xc(%ebp)
  802ec6:	ff 75 08             	pushl  0x8(%ebp)
  802ec9:	6a 20                	push   $0x20
  802ecb:	e8 fb fb ff ff       	call   802acb <syscall>
  802ed0:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed3:	90                   	nop
}
  802ed4:	c9                   	leave  
  802ed5:	c3                   	ret    

00802ed6 <chktst>:
void chktst(uint32 n)
{
  802ed6:	55                   	push   %ebp
  802ed7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802ed9:	6a 00                	push   $0x0
  802edb:	6a 00                	push   $0x0
  802edd:	6a 00                	push   $0x0
  802edf:	6a 00                	push   $0x0
  802ee1:	ff 75 08             	pushl  0x8(%ebp)
  802ee4:	6a 22                	push   $0x22
  802ee6:	e8 e0 fb ff ff       	call   802acb <syscall>
  802eeb:	83 c4 18             	add    $0x18,%esp
	return ;
  802eee:	90                   	nop
}
  802eef:	c9                   	leave  
  802ef0:	c3                   	ret    

00802ef1 <inctst>:

void inctst()
{
  802ef1:	55                   	push   %ebp
  802ef2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 00                	push   $0x0
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 00                	push   $0x0
  802efc:	6a 00                	push   $0x0
  802efe:	6a 23                	push   $0x23
  802f00:	e8 c6 fb ff ff       	call   802acb <syscall>
  802f05:	83 c4 18             	add    $0x18,%esp
	return ;
  802f08:	90                   	nop
}
  802f09:	c9                   	leave  
  802f0a:	c3                   	ret    

00802f0b <gettst>:
uint32 gettst()
{
  802f0b:	55                   	push   %ebp
  802f0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 00                	push   $0x0
  802f18:	6a 24                	push   $0x24
  802f1a:	e8 ac fb ff ff       	call   802acb <syscall>
  802f1f:	83 c4 18             	add    $0x18,%esp
}
  802f22:	c9                   	leave  
  802f23:	c3                   	ret    

00802f24 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802f24:	55                   	push   %ebp
  802f25:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 25                	push   $0x25
  802f33:	e8 93 fb ff ff       	call   802acb <syscall>
  802f38:	83 c4 18             	add    $0x18,%esp
  802f3b:	a3 44 e2 81 00       	mov    %eax,0x81e244
	return uheapPlaceStrategy ;
  802f40:	a1 44 e2 81 00       	mov    0x81e244,%eax
}
  802f45:	c9                   	leave  
  802f46:	c3                   	ret    

00802f47 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f47:	55                   	push   %ebp
  802f48:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	a3 44 e2 81 00       	mov    %eax,0x81e244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f52:	6a 00                	push   $0x0
  802f54:	6a 00                	push   $0x0
  802f56:	6a 00                	push   $0x0
  802f58:	6a 00                	push   $0x0
  802f5a:	ff 75 08             	pushl  0x8(%ebp)
  802f5d:	6a 26                	push   $0x26
  802f5f:	e8 67 fb ff ff       	call   802acb <syscall>
  802f64:	83 c4 18             	add    $0x18,%esp
	return ;
  802f67:	90                   	nop
}
  802f68:	c9                   	leave  
  802f69:	c3                   	ret    

00802f6a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802f6a:	55                   	push   %ebp
  802f6b:	89 e5                	mov    %esp,%ebp
  802f6d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802f6e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f71:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f74:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	6a 00                	push   $0x0
  802f7c:	53                   	push   %ebx
  802f7d:	51                   	push   %ecx
  802f7e:	52                   	push   %edx
  802f7f:	50                   	push   %eax
  802f80:	6a 27                	push   $0x27
  802f82:	e8 44 fb ff ff       	call   802acb <syscall>
  802f87:	83 c4 18             	add    $0x18,%esp
}
  802f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f8d:	c9                   	leave  
  802f8e:	c3                   	ret    

00802f8f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802f8f:	55                   	push   %ebp
  802f90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802f92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	52                   	push   %edx
  802f9f:	50                   	push   %eax
  802fa0:	6a 28                	push   $0x28
  802fa2:	e8 24 fb ff ff       	call   802acb <syscall>
  802fa7:	83 c4 18             	add    $0x18,%esp
}
  802faa:	c9                   	leave  
  802fab:	c3                   	ret    

00802fac <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802fac:	55                   	push   %ebp
  802fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802faf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	6a 00                	push   $0x0
  802fba:	51                   	push   %ecx
  802fbb:	ff 75 10             	pushl  0x10(%ebp)
  802fbe:	52                   	push   %edx
  802fbf:	50                   	push   %eax
  802fc0:	6a 29                	push   $0x29
  802fc2:	e8 04 fb ff ff       	call   802acb <syscall>
  802fc7:	83 c4 18             	add    $0x18,%esp
}
  802fca:	c9                   	leave  
  802fcb:	c3                   	ret    

00802fcc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802fcc:	55                   	push   %ebp
  802fcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802fcf:	6a 00                	push   $0x0
  802fd1:	6a 00                	push   $0x0
  802fd3:	ff 75 10             	pushl  0x10(%ebp)
  802fd6:	ff 75 0c             	pushl  0xc(%ebp)
  802fd9:	ff 75 08             	pushl  0x8(%ebp)
  802fdc:	6a 12                	push   $0x12
  802fde:	e8 e8 fa ff ff       	call   802acb <syscall>
  802fe3:	83 c4 18             	add    $0x18,%esp
	return ;
  802fe6:	90                   	nop
}
  802fe7:	c9                   	leave  
  802fe8:	c3                   	ret    

00802fe9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802fe9:	55                   	push   %ebp
  802fea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802fec:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	6a 00                	push   $0x0
  802ff4:	6a 00                	push   $0x0
  802ff6:	6a 00                	push   $0x0
  802ff8:	52                   	push   %edx
  802ff9:	50                   	push   %eax
  802ffa:	6a 2a                	push   $0x2a
  802ffc:	e8 ca fa ff ff       	call   802acb <syscall>
  803001:	83 c4 18             	add    $0x18,%esp
	return;
  803004:	90                   	nop
}
  803005:	c9                   	leave  
  803006:	c3                   	ret    

00803007 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803007:	55                   	push   %ebp
  803008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80300a:	6a 00                	push   $0x0
  80300c:	6a 00                	push   $0x0
  80300e:	6a 00                	push   $0x0
  803010:	6a 00                	push   $0x0
  803012:	6a 00                	push   $0x0
  803014:	6a 2b                	push   $0x2b
  803016:	e8 b0 fa ff ff       	call   802acb <syscall>
  80301b:	83 c4 18             	add    $0x18,%esp
}
  80301e:	c9                   	leave  
  80301f:	c3                   	ret    

00803020 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803020:	55                   	push   %ebp
  803021:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	6a 00                	push   $0x0
  803029:	ff 75 0c             	pushl  0xc(%ebp)
  80302c:	ff 75 08             	pushl  0x8(%ebp)
  80302f:	6a 2d                	push   $0x2d
  803031:	e8 95 fa ff ff       	call   802acb <syscall>
  803036:	83 c4 18             	add    $0x18,%esp
	return;
  803039:	90                   	nop
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80303f:	6a 00                	push   $0x0
  803041:	6a 00                	push   $0x0
  803043:	6a 00                	push   $0x0
  803045:	ff 75 0c             	pushl  0xc(%ebp)
  803048:	ff 75 08             	pushl  0x8(%ebp)
  80304b:	6a 2c                	push   $0x2c
  80304d:	e8 79 fa ff ff       	call   802acb <syscall>
  803052:	83 c4 18             	add    $0x18,%esp
	return ;
  803055:	90                   	nop
}
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
  80305b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80305e:	83 ec 04             	sub    $0x4,%esp
  803061:	68 54 4f 80 00       	push   $0x804f54
  803066:	68 25 01 00 00       	push   $0x125
  80306b:	68 87 4f 80 00       	push   $0x804f87
  803070:	e8 ec e6 ff ff       	call   801761 <_panic>

00803075 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803075:	55                   	push   %ebp
  803076:	89 e5                	mov    %esp,%ebp
  803078:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80307b:	81 7d 08 40 62 80 00 	cmpl   $0x806240,0x8(%ebp)
  803082:	72 09                	jb     80308d <to_page_va+0x18>
  803084:	81 7d 08 40 e2 81 00 	cmpl   $0x81e240,0x8(%ebp)
  80308b:	72 14                	jb     8030a1 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	68 98 4f 80 00       	push   $0x804f98
  803095:	6a 15                	push   $0x15
  803097:	68 c3 4f 80 00       	push   $0x804fc3
  80309c:	e8 c0 e6 ff ff       	call   801761 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	ba 40 62 80 00       	mov    $0x806240,%edx
  8030a9:	29 d0                	sub    %edx,%eax
  8030ab:	c1 f8 02             	sar    $0x2,%eax
  8030ae:	89 c2                	mov    %eax,%edx
  8030b0:	89 d0                	mov    %edx,%eax
  8030b2:	c1 e0 02             	shl    $0x2,%eax
  8030b5:	01 d0                	add    %edx,%eax
  8030b7:	c1 e0 02             	shl    $0x2,%eax
  8030ba:	01 d0                	add    %edx,%eax
  8030bc:	c1 e0 02             	shl    $0x2,%eax
  8030bf:	01 d0                	add    %edx,%eax
  8030c1:	89 c1                	mov    %eax,%ecx
  8030c3:	c1 e1 08             	shl    $0x8,%ecx
  8030c6:	01 c8                	add    %ecx,%eax
  8030c8:	89 c1                	mov    %eax,%ecx
  8030ca:	c1 e1 10             	shl    $0x10,%ecx
  8030cd:	01 c8                	add    %ecx,%eax
  8030cf:	01 c0                	add    %eax,%eax
  8030d1:	01 d0                	add    %edx,%eax
  8030d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	c1 e0 0c             	shl    $0xc,%eax
  8030dc:	89 c2                	mov    %eax,%edx
  8030de:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8030e3:	01 d0                	add    %edx,%eax
}
  8030e5:	c9                   	leave  
  8030e6:	c3                   	ret    

008030e7 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
  8030ea:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8030ed:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8030f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f5:	29 c2                	sub    %eax,%edx
  8030f7:	89 d0                	mov    %edx,%eax
  8030f9:	c1 e8 0c             	shr    $0xc,%eax
  8030fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8030ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803103:	78 09                	js     80310e <to_page_info+0x27>
  803105:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80310c:	7e 14                	jle    803122 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	68 dc 4f 80 00       	push   $0x804fdc
  803116:	6a 22                	push   $0x22
  803118:	68 c3 4f 80 00       	push   $0x804fc3
  80311d:	e8 3f e6 ff ff       	call   801761 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803125:	89 d0                	mov    %edx,%eax
  803127:	01 c0                	add    %eax,%eax
  803129:	01 d0                	add    %edx,%eax
  80312b:	c1 e0 02             	shl    $0x2,%eax
  80312e:	05 40 62 80 00       	add    $0x806240,%eax
}
  803133:	c9                   	leave  
  803134:	c3                   	ret    

00803135 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803135:	55                   	push   %ebp
  803136:	89 e5                	mov    %esp,%ebp
  803138:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	05 00 00 00 02       	add    $0x2000000,%eax
  803143:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803146:	73 16                	jae    80315e <initialize_dynamic_allocator+0x29>
  803148:	68 00 50 80 00       	push   $0x805000
  80314d:	68 26 50 80 00       	push   $0x805026
  803152:	6a 34                	push   $0x34
  803154:	68 c3 4f 80 00       	push   $0x804fc3
  803159:	e8 03 e6 ff ff       	call   801761 <_panic>
		is_initialized = 1;
  80315e:	c7 05 04 62 80 00 01 	movl   $0x1,0x806204
  803165:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	a3 48 e2 81 00       	mov    %eax,0x81e248
	dynAllocEnd = daEnd;
  803170:	8b 45 0c             	mov    0xc(%ebp),%eax
  803173:	a3 20 62 80 00       	mov    %eax,0x806220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  803178:	c7 05 28 62 80 00 00 	movl   $0x0,0x806228
  80317f:	00 00 00 
  803182:	c7 05 2c 62 80 00 00 	movl   $0x0,0x80622c
  803189:	00 00 00 
  80318c:	c7 05 34 62 80 00 00 	movl   $0x0,0x806234
  803193:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  803196:	8b 45 0c             	mov    0xc(%ebp),%eax
  803199:	2b 45 08             	sub    0x8(%ebp),%eax
  80319c:	c1 e8 0c             	shr    $0xc,%eax
  80319f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8031a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031a9:	e9 c8 00 00 00       	jmp    803276 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  8031ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b1:	89 d0                	mov    %edx,%eax
  8031b3:	01 c0                	add    %eax,%eax
  8031b5:	01 d0                	add    %edx,%eax
  8031b7:	c1 e0 02             	shl    $0x2,%eax
  8031ba:	05 48 62 80 00       	add    $0x806248,%eax
  8031bf:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8031c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c7:	89 d0                	mov    %edx,%eax
  8031c9:	01 c0                	add    %eax,%eax
  8031cb:	01 d0                	add    %edx,%eax
  8031cd:	c1 e0 02             	shl    $0x2,%eax
  8031d0:	05 4a 62 80 00       	add    $0x80624a,%eax
  8031d5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8031da:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  8031e0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8031e3:	89 c8                	mov    %ecx,%eax
  8031e5:	01 c0                	add    %eax,%eax
  8031e7:	01 c8                	add    %ecx,%eax
  8031e9:	c1 e0 02             	shl    $0x2,%eax
  8031ec:	05 44 62 80 00       	add    $0x806244,%eax
  8031f1:	89 10                	mov    %edx,(%eax)
  8031f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f6:	89 d0                	mov    %edx,%eax
  8031f8:	01 c0                	add    %eax,%eax
  8031fa:	01 d0                	add    %edx,%eax
  8031fc:	c1 e0 02             	shl    $0x2,%eax
  8031ff:	05 44 62 80 00       	add    $0x806244,%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	85 c0                	test   %eax,%eax
  803208:	74 1b                	je     803225 <initialize_dynamic_allocator+0xf0>
  80320a:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803210:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803213:	89 c8                	mov    %ecx,%eax
  803215:	01 c0                	add    %eax,%eax
  803217:	01 c8                	add    %ecx,%eax
  803219:	c1 e0 02             	shl    $0x2,%eax
  80321c:	05 40 62 80 00       	add    $0x806240,%eax
  803221:	89 02                	mov    %eax,(%edx)
  803223:	eb 16                	jmp    80323b <initialize_dynamic_allocator+0x106>
  803225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803228:	89 d0                	mov    %edx,%eax
  80322a:	01 c0                	add    %eax,%eax
  80322c:	01 d0                	add    %edx,%eax
  80322e:	c1 e0 02             	shl    $0x2,%eax
  803231:	05 40 62 80 00       	add    $0x806240,%eax
  803236:	a3 28 62 80 00       	mov    %eax,0x806228
  80323b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323e:	89 d0                	mov    %edx,%eax
  803240:	01 c0                	add    %eax,%eax
  803242:	01 d0                	add    %edx,%eax
  803244:	c1 e0 02             	shl    $0x2,%eax
  803247:	05 40 62 80 00       	add    $0x806240,%eax
  80324c:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803254:	89 d0                	mov    %edx,%eax
  803256:	01 c0                	add    %eax,%eax
  803258:	01 d0                	add    %edx,%eax
  80325a:	c1 e0 02             	shl    $0x2,%eax
  80325d:	05 40 62 80 00       	add    $0x806240,%eax
  803262:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803268:	a1 34 62 80 00       	mov    0x806234,%eax
  80326d:	40                   	inc    %eax
  80326e:	a3 34 62 80 00       	mov    %eax,0x806234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  803273:	ff 45 f4             	incl   -0xc(%ebp)
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80327c:	0f 8c 2c ff ff ff    	jl     8031ae <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803282:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803289:	eb 36                	jmp    8032c1 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  80328b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328e:	c1 e0 04             	shl    $0x4,%eax
  803291:	05 60 e2 81 00       	add    $0x81e260,%eax
  803296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329f:	c1 e0 04             	shl    $0x4,%eax
  8032a2:	05 64 e2 81 00       	add    $0x81e264,%eax
  8032a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b0:	c1 e0 04             	shl    $0x4,%eax
  8032b3:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8032b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8032be:	ff 45 f0             	incl   -0x10(%ebp)
  8032c1:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8032c5:	7e c4                	jle    80328b <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8032c7:	90                   	nop
  8032c8:	c9                   	leave  
  8032c9:	c3                   	ret    

008032ca <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8032ca:	55                   	push   %ebp
  8032cb:	89 e5                	mov    %esp,%ebp
  8032cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	83 ec 0c             	sub    $0xc,%esp
  8032d6:	50                   	push   %eax
  8032d7:	e8 0b fe ff ff       	call   8030e7 <to_page_info>
  8032dc:	83 c4 10             	add    $0x10,%esp
  8032df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	8b 40 08             	mov    0x8(%eax),%eax
  8032e8:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8032eb:	c9                   	leave  
  8032ec:	c3                   	ret    

008032ed <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8032ed:	55                   	push   %ebp
  8032ee:	89 e5                	mov    %esp,%ebp
  8032f0:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  8032f3:	83 ec 0c             	sub    $0xc,%esp
  8032f6:	ff 75 0c             	pushl  0xc(%ebp)
  8032f9:	e8 77 fd ff ff       	call   803075 <to_page_va>
  8032fe:	83 c4 10             	add    $0x10,%esp
  803301:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  803304:	b8 00 10 00 00       	mov    $0x1000,%eax
  803309:	ba 00 00 00 00       	mov    $0x0,%edx
  80330e:	f7 75 08             	divl   0x8(%ebp)
  803311:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  803314:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803317:	83 ec 0c             	sub    $0xc,%esp
  80331a:	50                   	push   %eax
  80331b:	e8 48 f6 ff ff       	call   802968 <get_page>
  803320:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  803323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803326:	8b 55 0c             	mov    0xc(%ebp),%edx
  803329:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	8b 55 0c             	mov    0xc(%ebp),%edx
  803333:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  803337:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80333e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803345:	eb 19                	jmp    803360 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  803347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334a:	ba 01 00 00 00       	mov    $0x1,%edx
  80334f:	88 c1                	mov    %al,%cl
  803351:	d3 e2                	shl    %cl,%edx
  803353:	89 d0                	mov    %edx,%eax
  803355:	3b 45 08             	cmp    0x8(%ebp),%eax
  803358:	74 0e                	je     803368 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80335a:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80335d:	ff 45 f0             	incl   -0x10(%ebp)
  803360:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803364:	7e e1                	jle    803347 <split_page_to_blocks+0x5a>
  803366:	eb 01                	jmp    803369 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  803368:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  803369:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803370:	e9 a7 00 00 00       	jmp    80341c <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  803375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803378:	0f af 45 08          	imul   0x8(%ebp),%eax
  80337c:	89 c2                	mov    %eax,%edx
  80337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803381:	01 d0                	add    %edx,%eax
  803383:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  803386:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80338a:	75 14                	jne    8033a0 <split_page_to_blocks+0xb3>
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	68 3c 50 80 00       	push   $0x80503c
  803394:	6a 7c                	push   $0x7c
  803396:	68 c3 4f 80 00       	push   $0x804fc3
  80339b:	e8 c1 e3 ff ff       	call   801761 <_panic>
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	c1 e0 04             	shl    $0x4,%eax
  8033a6:	05 64 e2 81 00       	add    $0x81e264,%eax
  8033ab:	8b 10                	mov    (%eax),%edx
  8033ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b0:	89 50 04             	mov    %edx,0x4(%eax)
  8033b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b6:	8b 40 04             	mov    0x4(%eax),%eax
  8033b9:	85 c0                	test   %eax,%eax
  8033bb:	74 14                	je     8033d1 <split_page_to_blocks+0xe4>
  8033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c0:	c1 e0 04             	shl    $0x4,%eax
  8033c3:	05 64 e2 81 00       	add    $0x81e264,%eax
  8033c8:	8b 00                	mov    (%eax),%eax
  8033ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	eb 11                	jmp    8033e2 <split_page_to_blocks+0xf5>
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	c1 e0 04             	shl    $0x4,%eax
  8033d7:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  8033dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e0:	89 02                	mov    %eax,(%edx)
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	c1 e0 04             	shl    $0x4,%eax
  8033e8:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  8033ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033f1:	89 02                	mov    %eax,(%edx)
  8033f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ff:	c1 e0 04             	shl    $0x4,%eax
  803402:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	8d 50 01             	lea    0x1(%eax),%edx
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340f:	c1 e0 04             	shl    $0x4,%eax
  803412:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803417:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  803419:	ff 45 ec             	incl   -0x14(%ebp)
  80341c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  803422:	0f 82 4d ff ff ff    	jb     803375 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  803428:	90                   	nop
  803429:	c9                   	leave  
  80342a:	c3                   	ret    

0080342b <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80342b:	55                   	push   %ebp
  80342c:	89 e5                	mov    %esp,%ebp
  80342e:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803431:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803438:	76 19                	jbe    803453 <alloc_block+0x28>
  80343a:	68 60 50 80 00       	push   $0x805060
  80343f:	68 26 50 80 00       	push   $0x805026
  803444:	68 8a 00 00 00       	push   $0x8a
  803449:	68 c3 4f 80 00       	push   $0x804fc3
  80344e:	e8 0e e3 ff ff       	call   801761 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  803453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80345a:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803461:	eb 19                	jmp    80347c <alloc_block+0x51>
		if((1 << i) >= size) break;
  803463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803466:	ba 01 00 00 00       	mov    $0x1,%edx
  80346b:	88 c1                	mov    %al,%cl
  80346d:	d3 e2                	shl    %cl,%edx
  80346f:	89 d0                	mov    %edx,%eax
  803471:	3b 45 08             	cmp    0x8(%ebp),%eax
  803474:	73 0e                	jae    803484 <alloc_block+0x59>
		idx++;
  803476:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  803479:	ff 45 f0             	incl   -0x10(%ebp)
  80347c:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803480:	7e e1                	jle    803463 <alloc_block+0x38>
  803482:	eb 01                	jmp    803485 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  803484:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  803485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803488:	c1 e0 04             	shl    $0x4,%eax
  80348b:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	85 c0                	test   %eax,%eax
  803494:	0f 84 df 00 00 00    	je     803579 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80349a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349d:	c1 e0 04             	shl    $0x4,%eax
  8034a0:	05 60 e2 81 00       	add    $0x81e260,%eax
  8034a5:	8b 00                	mov    (%eax),%eax
  8034a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8034aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034ae:	75 17                	jne    8034c7 <alloc_block+0x9c>
  8034b0:	83 ec 04             	sub    $0x4,%esp
  8034b3:	68 81 50 80 00       	push   $0x805081
  8034b8:	68 9e 00 00 00       	push   $0x9e
  8034bd:	68 c3 4f 80 00       	push   $0x804fc3
  8034c2:	e8 9a e2 ff ff       	call   801761 <_panic>
  8034c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	85 c0                	test   %eax,%eax
  8034ce:	74 10                	je     8034e0 <alloc_block+0xb5>
  8034d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d3:	8b 00                	mov    (%eax),%eax
  8034d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034d8:	8b 52 04             	mov    0x4(%edx),%edx
  8034db:	89 50 04             	mov    %edx,0x4(%eax)
  8034de:	eb 14                	jmp    8034f4 <alloc_block+0xc9>
  8034e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e3:	8b 40 04             	mov    0x4(%eax),%eax
  8034e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e9:	c1 e2 04             	shl    $0x4,%edx
  8034ec:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8034f2:	89 02                	mov    %eax,(%edx)
  8034f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f7:	8b 40 04             	mov    0x4(%eax),%eax
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	74 0f                	je     80350d <alloc_block+0xe2>
  8034fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803501:	8b 40 04             	mov    0x4(%eax),%eax
  803504:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803507:	8b 12                	mov    (%edx),%edx
  803509:	89 10                	mov    %edx,(%eax)
  80350b:	eb 13                	jmp    803520 <alloc_block+0xf5>
  80350d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803510:	8b 00                	mov    (%eax),%eax
  803512:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803515:	c1 e2 04             	shl    $0x4,%edx
  803518:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  80351e:	89 02                	mov    %eax,(%edx)
  803520:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	c1 e0 04             	shl    $0x4,%eax
  803539:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80353e:	8b 00                	mov    (%eax),%eax
  803540:	8d 50 ff             	lea    -0x1(%eax),%edx
  803543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803546:	c1 e0 04             	shl    $0x4,%eax
  803549:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80354e:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803550:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803553:	83 ec 0c             	sub    $0xc,%esp
  803556:	50                   	push   %eax
  803557:	e8 8b fb ff ff       	call   8030e7 <to_page_info>
  80355c:	83 c4 10             	add    $0x10,%esp
  80355f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  803562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803565:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803569:	48                   	dec    %eax
  80356a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80356d:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  803571:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803574:	e9 bc 02 00 00       	jmp    803835 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  803579:	a1 34 62 80 00       	mov    0x806234,%eax
  80357e:	85 c0                	test   %eax,%eax
  803580:	0f 84 7d 02 00 00    	je     803803 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  803586:	a1 28 62 80 00       	mov    0x806228,%eax
  80358b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80358e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803592:	75 17                	jne    8035ab <alloc_block+0x180>
  803594:	83 ec 04             	sub    $0x4,%esp
  803597:	68 81 50 80 00       	push   $0x805081
  80359c:	68 a9 00 00 00       	push   $0xa9
  8035a1:	68 c3 4f 80 00       	push   $0x804fc3
  8035a6:	e8 b6 e1 ff ff       	call   801761 <_panic>
  8035ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ae:	8b 00                	mov    (%eax),%eax
  8035b0:	85 c0                	test   %eax,%eax
  8035b2:	74 10                	je     8035c4 <alloc_block+0x199>
  8035b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035bc:	8b 52 04             	mov    0x4(%edx),%edx
  8035bf:	89 50 04             	mov    %edx,0x4(%eax)
  8035c2:	eb 0b                	jmp    8035cf <alloc_block+0x1a4>
  8035c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ca:	a3 2c 62 80 00       	mov    %eax,0x80622c
  8035cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d2:	8b 40 04             	mov    0x4(%eax),%eax
  8035d5:	85 c0                	test   %eax,%eax
  8035d7:	74 0f                	je     8035e8 <alloc_block+0x1bd>
  8035d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035dc:	8b 40 04             	mov    0x4(%eax),%eax
  8035df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035e2:	8b 12                	mov    (%edx),%edx
  8035e4:	89 10                	mov    %edx,(%eax)
  8035e6:	eb 0a                	jmp    8035f2 <alloc_block+0x1c7>
  8035e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	a3 28 62 80 00       	mov    %eax,0x806228
  8035f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803605:	a1 34 62 80 00       	mov    0x806234,%eax
  80360a:	48                   	dec    %eax
  80360b:	a3 34 62 80 00       	mov    %eax,0x806234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	83 c0 03             	add    $0x3,%eax
  803616:	ba 01 00 00 00       	mov    $0x1,%edx
  80361b:	88 c1                	mov    %al,%cl
  80361d:	d3 e2                	shl    %cl,%edx
  80361f:	89 d0                	mov    %edx,%eax
  803621:	83 ec 08             	sub    $0x8,%esp
  803624:	ff 75 e4             	pushl  -0x1c(%ebp)
  803627:	50                   	push   %eax
  803628:	e8 c0 fc ff ff       	call   8032ed <split_page_to_blocks>
  80362d:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803633:	c1 e0 04             	shl    $0x4,%eax
  803636:	05 60 e2 81 00       	add    $0x81e260,%eax
  80363b:	8b 00                	mov    (%eax),%eax
  80363d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  803640:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803644:	75 17                	jne    80365d <alloc_block+0x232>
  803646:	83 ec 04             	sub    $0x4,%esp
  803649:	68 81 50 80 00       	push   $0x805081
  80364e:	68 b0 00 00 00       	push   $0xb0
  803653:	68 c3 4f 80 00       	push   $0x804fc3
  803658:	e8 04 e1 ff ff       	call   801761 <_panic>
  80365d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803660:	8b 00                	mov    (%eax),%eax
  803662:	85 c0                	test   %eax,%eax
  803664:	74 10                	je     803676 <alloc_block+0x24b>
  803666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803669:	8b 00                	mov    (%eax),%eax
  80366b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80366e:	8b 52 04             	mov    0x4(%edx),%edx
  803671:	89 50 04             	mov    %edx,0x4(%eax)
  803674:	eb 14                	jmp    80368a <alloc_block+0x25f>
  803676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803679:	8b 40 04             	mov    0x4(%eax),%eax
  80367c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80367f:	c1 e2 04             	shl    $0x4,%edx
  803682:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803688:	89 02                	mov    %eax,(%edx)
  80368a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80368d:	8b 40 04             	mov    0x4(%eax),%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	74 0f                	je     8036a3 <alloc_block+0x278>
  803694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803697:	8b 40 04             	mov    0x4(%eax),%eax
  80369a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80369d:	8b 12                	mov    (%edx),%edx
  80369f:	89 10                	mov    %edx,(%eax)
  8036a1:	eb 13                	jmp    8036b6 <alloc_block+0x28b>
  8036a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036a6:	8b 00                	mov    (%eax),%eax
  8036a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ab:	c1 e2 04             	shl    $0x4,%edx
  8036ae:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  8036b4:	89 02                	mov    %eax,(%edx)
  8036b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cc:	c1 e0 04             	shl    $0x4,%eax
  8036cf:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8036d4:	8b 00                	mov    (%eax),%eax
  8036d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8036d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dc:	c1 e0 04             	shl    $0x4,%eax
  8036df:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8036e4:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8036e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036e9:	83 ec 0c             	sub    $0xc,%esp
  8036ec:	50                   	push   %eax
  8036ed:	e8 f5 f9 ff ff       	call   8030e7 <to_page_info>
  8036f2:	83 c4 10             	add    $0x10,%esp
  8036f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8036f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8036ff:	48                   	dec    %eax
  803700:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803703:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80370a:	e9 26 01 00 00       	jmp    803835 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80370f:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	c1 e0 04             	shl    $0x4,%eax
  803718:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	0f 84 dc 00 00 00    	je     803803 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372a:	c1 e0 04             	shl    $0x4,%eax
  80372d:	05 60 e2 81 00       	add    $0x81e260,%eax
  803732:	8b 00                	mov    (%eax),%eax
  803734:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  803737:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80373b:	75 17                	jne    803754 <alloc_block+0x329>
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	68 81 50 80 00       	push   $0x805081
  803745:	68 be 00 00 00       	push   $0xbe
  80374a:	68 c3 4f 80 00       	push   $0x804fc3
  80374f:	e8 0d e0 ff ff       	call   801761 <_panic>
  803754:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	85 c0                	test   %eax,%eax
  80375b:	74 10                	je     80376d <alloc_block+0x342>
  80375d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803760:	8b 00                	mov    (%eax),%eax
  803762:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803765:	8b 52 04             	mov    0x4(%edx),%edx
  803768:	89 50 04             	mov    %edx,0x4(%eax)
  80376b:	eb 14                	jmp    803781 <alloc_block+0x356>
  80376d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803770:	8b 40 04             	mov    0x4(%eax),%eax
  803773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803776:	c1 e2 04             	shl    $0x4,%edx
  803779:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  80377f:	89 02                	mov    %eax,(%edx)
  803781:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803784:	8b 40 04             	mov    0x4(%eax),%eax
  803787:	85 c0                	test   %eax,%eax
  803789:	74 0f                	je     80379a <alloc_block+0x36f>
  80378b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80378e:	8b 40 04             	mov    0x4(%eax),%eax
  803791:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803794:	8b 12                	mov    (%edx),%edx
  803796:	89 10                	mov    %edx,(%eax)
  803798:	eb 13                	jmp    8037ad <alloc_block+0x382>
  80379a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80379d:	8b 00                	mov    (%eax),%eax
  80379f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a2:	c1 e2 04             	shl    $0x4,%edx
  8037a5:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  8037ab:	89 02                	mov    %eax,(%edx)
  8037ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	c1 e0 04             	shl    $0x4,%eax
  8037c6:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8037cb:	8b 00                	mov    (%eax),%eax
  8037cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8037d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d3:	c1 e0 04             	shl    $0x4,%eax
  8037d6:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8037db:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8037dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037e0:	83 ec 0c             	sub    $0xc,%esp
  8037e3:	50                   	push   %eax
  8037e4:	e8 fe f8 ff ff       	call   8030e7 <to_page_info>
  8037e9:	83 c4 10             	add    $0x10,%esp
  8037ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8037ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037f6:	48                   	dec    %eax
  8037f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037fa:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8037fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803801:	eb 32                	jmp    803835 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803803:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803807:	77 15                	ja     80381e <alloc_block+0x3f3>
  803809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380c:	c1 e0 04             	shl    $0x4,%eax
  80380f:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803814:	8b 00                	mov    (%eax),%eax
  803816:	85 c0                	test   %eax,%eax
  803818:	0f 84 f1 fe ff ff    	je     80370f <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	68 9f 50 80 00       	push   $0x80509f
  803826:	68 c8 00 00 00       	push   $0xc8
  80382b:	68 c3 4f 80 00       	push   $0x804fc3
  803830:	e8 2c df ff ff       	call   801761 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  803835:	c9                   	leave  
  803836:	c3                   	ret    

00803837 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803837:	55                   	push   %ebp
  803838:	89 e5                	mov    %esp,%ebp
  80383a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80383d:	8b 55 08             	mov    0x8(%ebp),%edx
  803840:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803845:	39 c2                	cmp    %eax,%edx
  803847:	72 0c                	jb     803855 <free_block+0x1e>
  803849:	8b 55 08             	mov    0x8(%ebp),%edx
  80384c:	a1 20 62 80 00       	mov    0x806220,%eax
  803851:	39 c2                	cmp    %eax,%edx
  803853:	72 19                	jb     80386e <free_block+0x37>
  803855:	68 b0 50 80 00       	push   $0x8050b0
  80385a:	68 26 50 80 00       	push   $0x805026
  80385f:	68 d7 00 00 00       	push   $0xd7
  803864:	68 c3 4f 80 00       	push   $0x804fc3
  803869:	e8 f3 de ff ff       	call   801761 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	83 ec 0c             	sub    $0xc,%esp
  80387a:	50                   	push   %eax
  80387b:	e8 67 f8 ff ff       	call   8030e7 <to_page_info>
  803880:	83 c4 10             	add    $0x10,%esp
  803883:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  803886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803889:	8b 40 08             	mov    0x8(%eax),%eax
  80388c:	0f b7 c0             	movzwl %ax,%eax
  80388f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803892:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803899:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8038a0:	eb 19                	jmp    8038bb <free_block+0x84>
	    if ((1 << i) == blk_size)
  8038a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a5:	ba 01 00 00 00       	mov    $0x1,%edx
  8038aa:	88 c1                	mov    %al,%cl
  8038ac:	d3 e2                	shl    %cl,%edx
  8038ae:	89 d0                	mov    %edx,%eax
  8038b0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038b3:	74 0e                	je     8038c3 <free_block+0x8c>
	        break;
	    idx++;
  8038b5:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8038b8:	ff 45 f0             	incl   -0x10(%ebp)
  8038bb:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8038bf:	7e e1                	jle    8038a2 <free_block+0x6b>
  8038c1:	eb 01                	jmp    8038c4 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8038c3:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8038c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8038cb:	40                   	inc    %eax
  8038cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038cf:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8038d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038d7:	75 17                	jne    8038f0 <free_block+0xb9>
  8038d9:	83 ec 04             	sub    $0x4,%esp
  8038dc:	68 3c 50 80 00       	push   $0x80503c
  8038e1:	68 ee 00 00 00       	push   $0xee
  8038e6:	68 c3 4f 80 00       	push   $0x804fc3
  8038eb:	e8 71 de ff ff       	call   801761 <_panic>
  8038f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f3:	c1 e0 04             	shl    $0x4,%eax
  8038f6:	05 64 e2 81 00       	add    $0x81e264,%eax
  8038fb:	8b 10                	mov    (%eax),%edx
  8038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803900:	89 50 04             	mov    %edx,0x4(%eax)
  803903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803906:	8b 40 04             	mov    0x4(%eax),%eax
  803909:	85 c0                	test   %eax,%eax
  80390b:	74 14                	je     803921 <free_block+0xea>
  80390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803910:	c1 e0 04             	shl    $0x4,%eax
  803913:	05 64 e2 81 00       	add    $0x81e264,%eax
  803918:	8b 00                	mov    (%eax),%eax
  80391a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80391d:	89 10                	mov    %edx,(%eax)
  80391f:	eb 11                	jmp    803932 <free_block+0xfb>
  803921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803924:	c1 e0 04             	shl    $0x4,%eax
  803927:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  80392d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803930:	89 02                	mov    %eax,(%edx)
  803932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803935:	c1 e0 04             	shl    $0x4,%eax
  803938:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  80393e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803941:	89 02                	mov    %eax,(%edx)
  803943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803946:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80394c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394f:	c1 e0 04             	shl    $0x4,%eax
  803952:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	8d 50 01             	lea    0x1(%eax),%edx
  80395c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395f:	c1 e0 04             	shl    $0x4,%eax
  803962:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803967:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  803969:	b8 00 10 00 00       	mov    $0x1000,%eax
  80396e:	ba 00 00 00 00       	mov    $0x0,%edx
  803973:	f7 75 e0             	divl   -0x20(%ebp)
  803976:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  803979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803980:	0f b7 c0             	movzwl %ax,%eax
  803983:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803986:	0f 85 70 01 00 00    	jne    803afc <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  80398c:	83 ec 0c             	sub    $0xc,%esp
  80398f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803992:	e8 de f6 ff ff       	call   803075 <to_page_va>
  803997:	83 c4 10             	add    $0x10,%esp
  80399a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80399d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8039a4:	e9 b7 00 00 00       	jmp    803a60 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8039a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039af:	01 d0                	add    %edx,%eax
  8039b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8039b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039b8:	75 17                	jne    8039d1 <free_block+0x19a>
  8039ba:	83 ec 04             	sub    $0x4,%esp
  8039bd:	68 81 50 80 00       	push   $0x805081
  8039c2:	68 f8 00 00 00       	push   $0xf8
  8039c7:	68 c3 4f 80 00       	push   $0x804fc3
  8039cc:	e8 90 dd ff ff       	call   801761 <_panic>
  8039d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d4:	8b 00                	mov    (%eax),%eax
  8039d6:	85 c0                	test   %eax,%eax
  8039d8:	74 10                	je     8039ea <free_block+0x1b3>
  8039da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039dd:	8b 00                	mov    (%eax),%eax
  8039df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039e2:	8b 52 04             	mov    0x4(%edx),%edx
  8039e5:	89 50 04             	mov    %edx,0x4(%eax)
  8039e8:	eb 14                	jmp    8039fe <free_block+0x1c7>
  8039ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ed:	8b 40 04             	mov    0x4(%eax),%eax
  8039f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039f3:	c1 e2 04             	shl    $0x4,%edx
  8039f6:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8039fc:	89 02                	mov    %eax,(%edx)
  8039fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a01:	8b 40 04             	mov    0x4(%eax),%eax
  803a04:	85 c0                	test   %eax,%eax
  803a06:	74 0f                	je     803a17 <free_block+0x1e0>
  803a08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0b:	8b 40 04             	mov    0x4(%eax),%eax
  803a0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a11:	8b 12                	mov    (%edx),%edx
  803a13:	89 10                	mov    %edx,(%eax)
  803a15:	eb 13                	jmp    803a2a <free_block+0x1f3>
  803a17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a1a:	8b 00                	mov    (%eax),%eax
  803a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a1f:	c1 e2 04             	shl    $0x4,%edx
  803a22:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803a28:	89 02                	mov    %eax,(%edx)
  803a2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a40:	c1 e0 04             	shl    $0x4,%eax
  803a43:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a50:	c1 e0 04             	shl    $0x4,%eax
  803a53:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803a58:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a5d:	01 45 ec             	add    %eax,-0x14(%ebp)
  803a60:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803a67:	0f 86 3c ff ff ff    	jbe    8039a9 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  803a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a70:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a79:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803a7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a83:	75 17                	jne    803a9c <free_block+0x265>
  803a85:	83 ec 04             	sub    $0x4,%esp
  803a88:	68 3c 50 80 00       	push   $0x80503c
  803a8d:	68 fe 00 00 00       	push   $0xfe
  803a92:	68 c3 4f 80 00       	push   $0x804fc3
  803a97:	e8 c5 dc ff ff       	call   801761 <_panic>
  803a9c:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa5:	89 50 04             	mov    %edx,0x4(%eax)
  803aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aab:	8b 40 04             	mov    0x4(%eax),%eax
  803aae:	85 c0                	test   %eax,%eax
  803ab0:	74 0c                	je     803abe <free_block+0x287>
  803ab2:	a1 2c 62 80 00       	mov    0x80622c,%eax
  803ab7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aba:	89 10                	mov    %edx,(%eax)
  803abc:	eb 08                	jmp    803ac6 <free_block+0x28f>
  803abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac1:	a3 28 62 80 00       	mov    %eax,0x806228
  803ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac9:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad7:	a1 34 62 80 00       	mov    0x806234,%eax
  803adc:	40                   	inc    %eax
  803add:	a3 34 62 80 00       	mov    %eax,0x806234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803ae2:	83 ec 0c             	sub    $0xc,%esp
  803ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ae8:	e8 88 f5 ff ff       	call   803075 <to_page_va>
  803aed:	83 c4 10             	add    $0x10,%esp
  803af0:	83 ec 0c             	sub    $0xc,%esp
  803af3:	50                   	push   %eax
  803af4:	e8 b8 ee ff ff       	call   8029b1 <return_page>
  803af9:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803afc:	90                   	nop
  803afd:	c9                   	leave  
  803afe:	c3                   	ret    

00803aff <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803aff:	55                   	push   %ebp
  803b00:	89 e5                	mov    %esp,%ebp
  803b02:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803b05:	83 ec 04             	sub    $0x4,%esp
  803b08:	68 e8 50 80 00       	push   $0x8050e8
  803b0d:	68 11 01 00 00       	push   $0x111
  803b12:	68 c3 4f 80 00       	push   $0x804fc3
  803b17:	e8 45 dc ff ff       	call   801761 <_panic>

00803b1c <__udivdi3>:
  803b1c:	55                   	push   %ebp
  803b1d:	57                   	push   %edi
  803b1e:	56                   	push   %esi
  803b1f:	53                   	push   %ebx
  803b20:	83 ec 1c             	sub    $0x1c,%esp
  803b23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b33:	89 ca                	mov    %ecx,%edx
  803b35:	89 f8                	mov    %edi,%eax
  803b37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b3b:	85 f6                	test   %esi,%esi
  803b3d:	75 2d                	jne    803b6c <__udivdi3+0x50>
  803b3f:	39 cf                	cmp    %ecx,%edi
  803b41:	77 65                	ja     803ba8 <__udivdi3+0x8c>
  803b43:	89 fd                	mov    %edi,%ebp
  803b45:	85 ff                	test   %edi,%edi
  803b47:	75 0b                	jne    803b54 <__udivdi3+0x38>
  803b49:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4e:	31 d2                	xor    %edx,%edx
  803b50:	f7 f7                	div    %edi
  803b52:	89 c5                	mov    %eax,%ebp
  803b54:	31 d2                	xor    %edx,%edx
  803b56:	89 c8                	mov    %ecx,%eax
  803b58:	f7 f5                	div    %ebp
  803b5a:	89 c1                	mov    %eax,%ecx
  803b5c:	89 d8                	mov    %ebx,%eax
  803b5e:	f7 f5                	div    %ebp
  803b60:	89 cf                	mov    %ecx,%edi
  803b62:	89 fa                	mov    %edi,%edx
  803b64:	83 c4 1c             	add    $0x1c,%esp
  803b67:	5b                   	pop    %ebx
  803b68:	5e                   	pop    %esi
  803b69:	5f                   	pop    %edi
  803b6a:	5d                   	pop    %ebp
  803b6b:	c3                   	ret    
  803b6c:	39 ce                	cmp    %ecx,%esi
  803b6e:	77 28                	ja     803b98 <__udivdi3+0x7c>
  803b70:	0f bd fe             	bsr    %esi,%edi
  803b73:	83 f7 1f             	xor    $0x1f,%edi
  803b76:	75 40                	jne    803bb8 <__udivdi3+0x9c>
  803b78:	39 ce                	cmp    %ecx,%esi
  803b7a:	72 0a                	jb     803b86 <__udivdi3+0x6a>
  803b7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b80:	0f 87 9e 00 00 00    	ja     803c24 <__udivdi3+0x108>
  803b86:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8b:	89 fa                	mov    %edi,%edx
  803b8d:	83 c4 1c             	add    $0x1c,%esp
  803b90:	5b                   	pop    %ebx
  803b91:	5e                   	pop    %esi
  803b92:	5f                   	pop    %edi
  803b93:	5d                   	pop    %ebp
  803b94:	c3                   	ret    
  803b95:	8d 76 00             	lea    0x0(%esi),%esi
  803b98:	31 ff                	xor    %edi,%edi
  803b9a:	31 c0                	xor    %eax,%eax
  803b9c:	89 fa                	mov    %edi,%edx
  803b9e:	83 c4 1c             	add    $0x1c,%esp
  803ba1:	5b                   	pop    %ebx
  803ba2:	5e                   	pop    %esi
  803ba3:	5f                   	pop    %edi
  803ba4:	5d                   	pop    %ebp
  803ba5:	c3                   	ret    
  803ba6:	66 90                	xchg   %ax,%ax
  803ba8:	89 d8                	mov    %ebx,%eax
  803baa:	f7 f7                	div    %edi
  803bac:	31 ff                	xor    %edi,%edi
  803bae:	89 fa                	mov    %edi,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bbd:	89 eb                	mov    %ebp,%ebx
  803bbf:	29 fb                	sub    %edi,%ebx
  803bc1:	89 f9                	mov    %edi,%ecx
  803bc3:	d3 e6                	shl    %cl,%esi
  803bc5:	89 c5                	mov    %eax,%ebp
  803bc7:	88 d9                	mov    %bl,%cl
  803bc9:	d3 ed                	shr    %cl,%ebp
  803bcb:	89 e9                	mov    %ebp,%ecx
  803bcd:	09 f1                	or     %esi,%ecx
  803bcf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bd3:	89 f9                	mov    %edi,%ecx
  803bd5:	d3 e0                	shl    %cl,%eax
  803bd7:	89 c5                	mov    %eax,%ebp
  803bd9:	89 d6                	mov    %edx,%esi
  803bdb:	88 d9                	mov    %bl,%cl
  803bdd:	d3 ee                	shr    %cl,%esi
  803bdf:	89 f9                	mov    %edi,%ecx
  803be1:	d3 e2                	shl    %cl,%edx
  803be3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be7:	88 d9                	mov    %bl,%cl
  803be9:	d3 e8                	shr    %cl,%eax
  803beb:	09 c2                	or     %eax,%edx
  803bed:	89 d0                	mov    %edx,%eax
  803bef:	89 f2                	mov    %esi,%edx
  803bf1:	f7 74 24 0c          	divl   0xc(%esp)
  803bf5:	89 d6                	mov    %edx,%esi
  803bf7:	89 c3                	mov    %eax,%ebx
  803bf9:	f7 e5                	mul    %ebp
  803bfb:	39 d6                	cmp    %edx,%esi
  803bfd:	72 19                	jb     803c18 <__udivdi3+0xfc>
  803bff:	74 0b                	je     803c0c <__udivdi3+0xf0>
  803c01:	89 d8                	mov    %ebx,%eax
  803c03:	31 ff                	xor    %edi,%edi
  803c05:	e9 58 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c10:	89 f9                	mov    %edi,%ecx
  803c12:	d3 e2                	shl    %cl,%edx
  803c14:	39 c2                	cmp    %eax,%edx
  803c16:	73 e9                	jae    803c01 <__udivdi3+0xe5>
  803c18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c1b:	31 ff                	xor    %edi,%edi
  803c1d:	e9 40 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	31 c0                	xor    %eax,%eax
  803c26:	e9 37 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c2b:	90                   	nop

00803c2c <__umoddi3>:
  803c2c:	55                   	push   %ebp
  803c2d:	57                   	push   %edi
  803c2e:	56                   	push   %esi
  803c2f:	53                   	push   %ebx
  803c30:	83 ec 1c             	sub    $0x1c,%esp
  803c33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c37:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c4b:	89 f3                	mov    %esi,%ebx
  803c4d:	89 fa                	mov    %edi,%edx
  803c4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c53:	89 34 24             	mov    %esi,(%esp)
  803c56:	85 c0                	test   %eax,%eax
  803c58:	75 1a                	jne    803c74 <__umoddi3+0x48>
  803c5a:	39 f7                	cmp    %esi,%edi
  803c5c:	0f 86 a2 00 00 00    	jbe    803d04 <__umoddi3+0xd8>
  803c62:	89 c8                	mov    %ecx,%eax
  803c64:	89 f2                	mov    %esi,%edx
  803c66:	f7 f7                	div    %edi
  803c68:	89 d0                	mov    %edx,%eax
  803c6a:	31 d2                	xor    %edx,%edx
  803c6c:	83 c4 1c             	add    $0x1c,%esp
  803c6f:	5b                   	pop    %ebx
  803c70:	5e                   	pop    %esi
  803c71:	5f                   	pop    %edi
  803c72:	5d                   	pop    %ebp
  803c73:	c3                   	ret    
  803c74:	39 f0                	cmp    %esi,%eax
  803c76:	0f 87 ac 00 00 00    	ja     803d28 <__umoddi3+0xfc>
  803c7c:	0f bd e8             	bsr    %eax,%ebp
  803c7f:	83 f5 1f             	xor    $0x1f,%ebp
  803c82:	0f 84 ac 00 00 00    	je     803d34 <__umoddi3+0x108>
  803c88:	bf 20 00 00 00       	mov    $0x20,%edi
  803c8d:	29 ef                	sub    %ebp,%edi
  803c8f:	89 fe                	mov    %edi,%esi
  803c91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c95:	89 e9                	mov    %ebp,%ecx
  803c97:	d3 e0                	shl    %cl,%eax
  803c99:	89 d7                	mov    %edx,%edi
  803c9b:	89 f1                	mov    %esi,%ecx
  803c9d:	d3 ef                	shr    %cl,%edi
  803c9f:	09 c7                	or     %eax,%edi
  803ca1:	89 e9                	mov    %ebp,%ecx
  803ca3:	d3 e2                	shl    %cl,%edx
  803ca5:	89 14 24             	mov    %edx,(%esp)
  803ca8:	89 d8                	mov    %ebx,%eax
  803caa:	d3 e0                	shl    %cl,%eax
  803cac:	89 c2                	mov    %eax,%edx
  803cae:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb2:	d3 e0                	shl    %cl,%eax
  803cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbc:	89 f1                	mov    %esi,%ecx
  803cbe:	d3 e8                	shr    %cl,%eax
  803cc0:	09 d0                	or     %edx,%eax
  803cc2:	d3 eb                	shr    %cl,%ebx
  803cc4:	89 da                	mov    %ebx,%edx
  803cc6:	f7 f7                	div    %edi
  803cc8:	89 d3                	mov    %edx,%ebx
  803cca:	f7 24 24             	mull   (%esp)
  803ccd:	89 c6                	mov    %eax,%esi
  803ccf:	89 d1                	mov    %edx,%ecx
  803cd1:	39 d3                	cmp    %edx,%ebx
  803cd3:	0f 82 87 00 00 00    	jb     803d60 <__umoddi3+0x134>
  803cd9:	0f 84 91 00 00 00    	je     803d70 <__umoddi3+0x144>
  803cdf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ce3:	29 f2                	sub    %esi,%edx
  803ce5:	19 cb                	sbb    %ecx,%ebx
  803ce7:	89 d8                	mov    %ebx,%eax
  803ce9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ced:	d3 e0                	shl    %cl,%eax
  803cef:	89 e9                	mov    %ebp,%ecx
  803cf1:	d3 ea                	shr    %cl,%edx
  803cf3:	09 d0                	or     %edx,%eax
  803cf5:	89 e9                	mov    %ebp,%ecx
  803cf7:	d3 eb                	shr    %cl,%ebx
  803cf9:	89 da                	mov    %ebx,%edx
  803cfb:	83 c4 1c             	add    $0x1c,%esp
  803cfe:	5b                   	pop    %ebx
  803cff:	5e                   	pop    %esi
  803d00:	5f                   	pop    %edi
  803d01:	5d                   	pop    %ebp
  803d02:	c3                   	ret    
  803d03:	90                   	nop
  803d04:	89 fd                	mov    %edi,%ebp
  803d06:	85 ff                	test   %edi,%edi
  803d08:	75 0b                	jne    803d15 <__umoddi3+0xe9>
  803d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d0f:	31 d2                	xor    %edx,%edx
  803d11:	f7 f7                	div    %edi
  803d13:	89 c5                	mov    %eax,%ebp
  803d15:	89 f0                	mov    %esi,%eax
  803d17:	31 d2                	xor    %edx,%edx
  803d19:	f7 f5                	div    %ebp
  803d1b:	89 c8                	mov    %ecx,%eax
  803d1d:	f7 f5                	div    %ebp
  803d1f:	89 d0                	mov    %edx,%eax
  803d21:	e9 44 ff ff ff       	jmp    803c6a <__umoddi3+0x3e>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	89 c8                	mov    %ecx,%eax
  803d2a:	89 f2                	mov    %esi,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	3b 04 24             	cmp    (%esp),%eax
  803d37:	72 06                	jb     803d3f <__umoddi3+0x113>
  803d39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d3d:	77 0f                	ja     803d4e <__umoddi3+0x122>
  803d3f:	89 f2                	mov    %esi,%edx
  803d41:	29 f9                	sub    %edi,%ecx
  803d43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d47:	89 14 24             	mov    %edx,(%esp)
  803d4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d52:	8b 14 24             	mov    (%esp),%edx
  803d55:	83 c4 1c             	add    $0x1c,%esp
  803d58:	5b                   	pop    %ebx
  803d59:	5e                   	pop    %esi
  803d5a:	5f                   	pop    %edi
  803d5b:	5d                   	pop    %ebp
  803d5c:	c3                   	ret    
  803d5d:	8d 76 00             	lea    0x0(%esi),%esi
  803d60:	2b 04 24             	sub    (%esp),%eax
  803d63:	19 fa                	sbb    %edi,%edx
  803d65:	89 d1                	mov    %edx,%ecx
  803d67:	89 c6                	mov    %eax,%esi
  803d69:	e9 71 ff ff ff       	jmp    803cdf <__umoddi3+0xb3>
  803d6e:	66 90                	xchg   %ax,%ax
  803d70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d74:	72 ea                	jb     803d60 <__umoddi3+0x134>
  803d76:	89 d9                	mov    %ebx,%ecx
  803d78:	e9 62 ff ff ff       	jmp    803cdf <__umoddi3+0xb3>
