
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 0f 14 00 00       	call   801445 <libmain>
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
  800067:	e8 12 2a 00 00       	call   802a7e <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 55 2a 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 be 27 00 00       	call   802885 <malloc>
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
  8000df:	e8 9a 29 00 00       	call   802a7e <sys_calculate_free_frames>
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
  800125:	68 20 3c 80 00       	push   $0x803c20
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 bf 17 00 00       	call   8018f0 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 90 29 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 3c 80 00       	push   $0x803c9c
  800150:	6a 0c                	push   $0xc
  800152:	e8 99 17 00 00       	call   8018f0 <cprintf_colored>
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
  800174:	e8 05 29 00 00       	call   802a7e <sys_calculate_free_frames>
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
  8001b9:	e8 c0 28 00 00       	call   802a7e <sys_calculate_free_frames>
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
  8001f8:	68 14 3d 80 00       	push   $0x803d14
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 ec 16 00 00       	call   8018f0 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 bd 28 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 3d 80 00       	push   $0x803da0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 bf 16 00 00       	call   8018f0 <cprintf_colored>
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
  800270:	e8 cb 2b 00 00       	call   802e40 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 3e 80 00       	push   $0x803e18
  80028f:	6a 0c                	push   $0xc
  800291:	e8 5a 16 00 00       	call   8018f0 <cprintf_colored>
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
  8002ae:	e8 cb 27 00 00       	call   802a7e <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 0e 28 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 e2 25 00 00       	call   8028b3 <free>
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
  8002fc:	e8 c8 27 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 3e 80 00       	push   $0x803e50
  800318:	6a 0c                	push   $0xc
  80031a:	e8 d1 15 00 00       	call   8018f0 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 57 27 00 00       	call   802a7e <sys_calculate_free_frames>
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
  800342:	68 9c 3e 80 00       	push   $0x803e9c
  800347:	6a 0c                	push   $0xc
  800349:	e8 a2 15 00 00       	call   8018f0 <cprintf_colored>
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
  8003a0:	e8 9b 2a 00 00       	call   802e40 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 f8 3e 80 00       	push   $0x803ef8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 2a 15 00 00       	call   8018f0 <cprintf_colored>
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
  800416:	68 30 3f 80 00       	push   $0x803f30
  80041b:	6a 03                	push   $0x3
  80041d:	e8 ce 14 00 00       	call   8018f0 <cprintf_colored>
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
  8004df:	68 60 3f 80 00       	push   $0x803f60
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 05 14 00 00       	call   8018f0 <cprintf_colored>
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
  8005b9:	68 60 3f 80 00       	push   $0x803f60
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 2b 13 00 00       	call   8018f0 <cprintf_colored>
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
  800693:	68 60 3f 80 00       	push   $0x803f60
  800698:	6a 0c                	push   $0xc
  80069a:	e8 51 12 00 00       	call   8018f0 <cprintf_colored>
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
  80076d:	68 60 3f 80 00       	push   $0x803f60
  800772:	6a 0c                	push   $0xc
  800774:	e8 77 11 00 00       	call   8018f0 <cprintf_colored>
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
  800847:	68 60 3f 80 00       	push   $0x803f60
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 9d 10 00 00       	call   8018f0 <cprintf_colored>
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
  800921:	68 60 3f 80 00       	push   $0x803f60
  800926:	6a 0c                	push   $0xc
  800928:	e8 c3 0f 00 00       	call   8018f0 <cprintf_colored>
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
  800a16:	68 60 3f 80 00       	push   $0x803f60
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 ce 0e 00 00       	call   8018f0 <cprintf_colored>
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
  800b14:	68 60 3f 80 00       	push   $0x803f60
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 d0 0d 00 00       	call   8018f0 <cprintf_colored>
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
  800c12:	68 60 3f 80 00       	push   $0x803f60
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 d2 0c 00 00       	call   8018f0 <cprintf_colored>
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
  800d10:	68 60 3f 80 00       	push   $0x803f60
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 d4 0b 00 00       	call   8018f0 <cprintf_colored>
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
  800dfd:	68 60 3f 80 00       	push   $0x803f60
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 e7 0a 00 00       	call   8018f0 <cprintf_colored>
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
  800eea:	68 60 3f 80 00       	push   $0x803f60
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 fa 09 00 00       	call   8018f0 <cprintf_colored>
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
  800fd7:	68 60 3f 80 00       	push   $0x803f60
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 0d 09 00 00       	call   8018f0 <cprintf_colored>
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
  800ffa:	68 b2 3f 80 00       	push   $0x803fb2
  800fff:	6a 03                	push   $0x3
  801001:	e8 ea 08 00 00       	call   8018f0 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 5f 1a 00 00       	call   802a7e <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 9f 1a 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 2b 18 00 00       	call   802885 <malloc>
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
  801084:	68 d0 3f 80 00       	push   $0x803fd0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 60 08 00 00       	call   8018f0 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 31 1a 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 0c 40 80 00       	push   $0x80400c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 34 08 00 00       	call   8018f0 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 ba 19 00 00       	call   802a7e <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 7c 40 80 00       	push   $0x80407c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 08 08 00 00       	call   8018f0 <cprintf_colored>
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
  801124:	68 c4 40 80 00       	push   $0x8040c4
  801129:	6a 0f                	push   $0xf
  80112b:	68 e0 40 80 00       	push   $0x8040e0
  801130:	e8 c0 04 00 00       	call   8015f5 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801135:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int diff, expected;
	int freeFrames, usedDiskPages ;
	int32 parentenvID = sys_getparentenvid();
  80113c:	e8 1f 1b 00 00       	call   802c60 <sys_getparentenvid>
  801141:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_lock_cons();
  801144:	e8 85 18 00 00       	call   8029ce <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  801149:	e8 30 19 00 00       	call   802a7e <sys_calculate_free_frames>
  80114e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801151:	e8 73 19 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  801156:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = sget(parentenvID,"z");
  801159:	83 ec 08             	sub    $0x8,%esp
  80115c:	68 fb 40 80 00       	push   $0x8040fb
  801161:	ff 75 f0             	pushl  -0x10(%ebp)
  801164:	e8 98 17 00 00       	call   802901 <sget>
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
  801186:	68 00 41 80 00       	push   $0x804100
  80118b:	6a 24                	push   $0x24
  80118d:	68 e0 40 80 00       	push   $0x8040e0
  801192:	e8 5e 04 00 00       	call   8015f5 <_panic>
		expected = 1 ; /*1 table in UH*/
  801197:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80119e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8011a1:	e8 d8 18 00 00       	call   802a7e <sys_calculate_free_frames>
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
  8011d2:	e8 a7 18 00 00       	call   802a7e <sys_calculate_free_frames>
  8011d7:	29 c6                	sub    %eax,%esi
  8011d9:	89 f0                	mov    %esi,%eax
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	53                   	push   %ebx
  8011df:	ff 75 dc             	pushl  -0x24(%ebp)
  8011e2:	50                   	push   %eax
  8011e3:	68 7c 41 80 00       	push   $0x80417c
  8011e8:	6a 28                	push   $0x28
  8011ea:	68 e0 40 80 00       	push   $0x8040e0
  8011ef:	e8 01 04 00 00       	call   8015f5 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8011f4:	e8 d0 18 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  8011f9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8011fc:	74 14                	je     801212 <_main+0x113>
		{panic("Wrong page file allocation: ");}
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	68 1a 42 80 00       	push   $0x80421a
  801206:	6a 2a                	push   $0x2a
  801208:	68 e0 40 80 00       	push   $0x8040e0
  80120d:	e8 e3 03 00 00       	call   8015f5 <_panic>
	}
	sys_unlock_cons();
  801212:	e8 d1 17 00 00       	call   8029e8 <sys_unlock_cons>

	sys_lock_cons();
  801217:	e8 b2 17 00 00       	call   8029ce <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  80121c:	e8 5d 18 00 00       	call   802a7e <sys_calculate_free_frames>
  801221:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801224:	e8 a0 18 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  801229:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = sget(parentenvID,"y");
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	68 37 42 80 00       	push   $0x804237
  801234:	ff 75 f0             	pushl  -0x10(%ebp)
  801237:	e8 c5 16 00 00       	call   802901 <sget>
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  801242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801245:	05 00 10 00 00       	add    $0x1000,%eax
  80124a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80124d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801250:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801253:	74 1a                	je     80126f <_main+0x170>
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80125b:	ff 75 e0             	pushl  -0x20(%ebp)
  80125e:	68 00 41 80 00       	push   $0x804100
  801263:	6a 34                	push   $0x34
  801265:	68 e0 40 80 00       	push   $0x8040e0
  80126a:	e8 86 03 00 00       	call   8015f5 <_panic>
		expected = 0 ;
  80126f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  801276:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  801279:	e8 00 18 00 00       	call   802a7e <sys_calculate_free_frames>
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
  8012a0:	e8 d9 17 00 00       	call   802a7e <sys_calculate_free_frames>
  8012a5:	29 c3                	sub    %eax,%ebx
  8012a7:	89 d8                	mov    %ebx,%eax
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8012af:	50                   	push   %eax
  8012b0:	68 3c 42 80 00       	push   $0x80423c
  8012b5:	6a 38                	push   $0x38
  8012b7:	68 e0 40 80 00       	push   $0x8040e0
  8012bc:	e8 34 03 00 00       	call   8015f5 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012c1:	e8 03 18 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  8012c6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012c9:	74 14                	je     8012df <_main+0x1e0>
		{panic("Wrong page file allocation: ");}
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	68 1a 42 80 00       	push   $0x80421a
  8012d3:	6a 3a                	push   $0x3a
  8012d5:	68 e0 40 80 00       	push   $0x8040e0
  8012da:	e8 16 03 00 00       	call   8015f5 <_panic>
	}
	sys_unlock_cons();
  8012df:	e8 04 17 00 00       	call   8029e8 <sys_unlock_cons>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8012e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	83 f8 14             	cmp    $0x14,%eax
  8012ec:	74 14                	je     801302 <_main+0x203>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 d4 42 80 00       	push   $0x8042d4
  8012f6:	6a 3e                	push   $0x3e
  8012f8:	68 e0 40 80 00       	push   $0x8040e0
  8012fd:	e8 f3 02 00 00       	call   8015f5 <_panic>

	sys_lock_cons();
  801302:	e8 c7 16 00 00       	call   8029ce <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  801307:	e8 72 17 00 00       	call   802a7e <sys_calculate_free_frames>
  80130c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80130f:	e8 b5 17 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  801314:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = sget(parentenvID,"x");
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	68 0b 43 80 00       	push   $0x80430b
  80131f:	ff 75 f0             	pushl  -0x10(%ebp)
  801322:	e8 da 15 00 00       	call   802901 <sget>
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  80132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801330:	05 00 20 00 00       	add    $0x2000,%eax
  801335:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  801338:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80133b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80133e:	74 1a                	je     80135a <_main+0x25b>
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	ff 75 d0             	pushl  -0x30(%ebp)
  801346:	ff 75 e0             	pushl  -0x20(%ebp)
  801349:	68 00 41 80 00       	push   $0x804100
  80134e:	6a 46                	push   $0x46
  801350:	68 e0 40 80 00       	push   $0x8040e0
  801355:	e8 9b 02 00 00       	call   8015f5 <_panic>
		expected = 0 ;
  80135a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  801361:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  801364:	e8 15 17 00 00       	call   802a7e <sys_calculate_free_frames>
  801369:	29 c3                	sub    %eax,%ebx
  80136b:	89 d8                	mov    %ebx,%eax
  80136d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	ff 75 dc             	pushl  -0x24(%ebp)
  801376:	ff 75 dc             	pushl  -0x24(%ebp)
  801379:	ff 75 d8             	pushl  -0x28(%ebp)
  80137c:	e8 b7 ec ff ff       	call   800038 <inRange>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	75 24                	jne    8013ac <_main+0x2ad>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  801388:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80138b:	e8 ee 16 00 00       	call   802a7e <sys_calculate_free_frames>
  801390:	29 c3                	sub    %eax,%ebx
  801392:	89 d8                	mov    %ebx,%eax
  801394:	83 ec 0c             	sub    $0xc,%esp
  801397:	ff 75 dc             	pushl  -0x24(%ebp)
  80139a:	50                   	push   %eax
  80139b:	68 3c 42 80 00       	push   $0x80423c
  8013a0:	6a 4a                	push   $0x4a
  8013a2:	68 e0 40 80 00       	push   $0x8040e0
  8013a7:	e8 49 02 00 00       	call   8015f5 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8013ac:	e8 18 17 00 00       	call   802ac9 <sys_pf_calculate_allocated_pages>
  8013b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8013b4:	74 14                	je     8013ca <_main+0x2cb>
		{panic("Wrong page file allocation: ");}
  8013b6:	83 ec 04             	sub    $0x4,%esp
  8013b9:	68 1a 42 80 00       	push   $0x80421a
  8013be:	6a 4c                	push   $0x4c
  8013c0:	68 e0 40 80 00       	push   $0x8040e0
  8013c5:	e8 2b 02 00 00       	call   8015f5 <_panic>
	}
	sys_unlock_cons();
  8013ca:	e8 19 16 00 00       	call   8029e8 <sys_unlock_cons>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8013cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 f8 0a             	cmp    $0xa,%eax
  8013d7:	74 14                	je     8013ed <_main+0x2ee>
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	68 d4 42 80 00       	push   $0x8042d4
  8013e1:	6a 50                	push   $0x50
  8013e3:	68 e0 40 80 00       	push   $0x8040e0
  8013e8:	e8 08 02 00 00       	call   8015f5 <_panic>

	*z = *x + *y ;
  8013ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013f0:	8b 10                	mov    (%eax),%edx
  8013f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013f5:	8b 00                	mov    (%eax),%eax
  8013f7:	01 c2                	add    %eax,%edx
  8013f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fc:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8013fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801401:	8b 00                	mov    (%eax),%eax
  801403:	83 f8 1e             	cmp    $0x1e,%eax
  801406:	74 14                	je     80141c <_main+0x31d>
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	68 d4 42 80 00       	push   $0x8042d4
  801410:	6a 53                	push   $0x53
  801412:	68 e0 40 80 00       	push   $0x8040e0
  801417:	e8 d9 01 00 00       	call   8015f5 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80141c:	e8 64 19 00 00       	call   802d85 <inctst>

	cprintf_colored(TEXT_green, "Slave1 completed.\n");
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	68 0d 43 80 00       	push   $0x80430d
  801429:	6a 02                	push   $0x2
  80142b:	e8 c0 04 00 00       	call   8018f0 <cprintf_colored>
  801430:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  801433:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  80143a:	00 00 00 
	return;
  80143d:	90                   	nop
}
  80143e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801441:	5b                   	pop    %ebx
  801442:	5e                   	pop    %esi
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	57                   	push   %edi
  801449:	56                   	push   %esi
  80144a:	53                   	push   %ebx
  80144b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80144e:	e8 f4 17 00 00       	call   802c47 <sys_getenvindex>
  801453:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801456:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801459:	89 d0                	mov    %edx,%eax
  80145b:	c1 e0 02             	shl    $0x2,%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	c1 e0 03             	shl    $0x3,%eax
  801463:	01 d0                	add    %edx,%eax
  801465:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c1 e0 02             	shl    $0x2,%eax
  801471:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801476:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80147b:	a1 00 52 80 00       	mov    0x805200,%eax
  801480:	8a 40 20             	mov    0x20(%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	74 0d                	je     801494 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801487:	a1 00 52 80 00       	mov    0x805200,%eax
  80148c:	83 c0 20             	add    $0x20,%eax
  80148f:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801494:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801498:	7e 0a                	jle    8014a4 <libmain+0x5f>
		binaryname = argv[0];
  80149a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149d:	8b 00                	mov    (%eax),%eax
  80149f:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	ff 75 08             	pushl  0x8(%ebp)
  8014ad:	e8 4d fc ff ff       	call   8010ff <_main>
  8014b2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8014b5:	a1 00 50 80 00       	mov    0x805000,%eax
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	0f 84 01 01 00 00    	je     8015c3 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8014c2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014c8:	bb 18 44 80 00       	mov    $0x804418,%ebx
  8014cd:	ba 0e 00 00 00       	mov    $0xe,%edx
  8014d2:	89 c7                	mov    %eax,%edi
  8014d4:	89 de                	mov    %ebx,%esi
  8014d6:	89 d1                	mov    %edx,%ecx
  8014d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8014da:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8014dd:	b9 56 00 00 00       	mov    $0x56,%ecx
  8014e2:	b0 00                	mov    $0x0,%al
  8014e4:	89 d7                	mov    %edx,%edi
  8014e6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8014e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8014ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	50                   	push   %eax
  8014f6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014fc:	50                   	push   %eax
  8014fd:	e8 7b 19 00 00       	call   802e7d <sys_utilities>
  801502:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801505:	e8 c4 14 00 00       	call   8029ce <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80150a:	83 ec 0c             	sub    $0xc,%esp
  80150d:	68 38 43 80 00       	push   $0x804338
  801512:	e8 ac 03 00 00       	call   8018c3 <cprintf>
  801517:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80151a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151d:	85 c0                	test   %eax,%eax
  80151f:	74 18                	je     801539 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801521:	e8 75 19 00 00       	call   802e9b <sys_get_optimal_num_faults>
  801526:	83 ec 08             	sub    $0x8,%esp
  801529:	50                   	push   %eax
  80152a:	68 60 43 80 00       	push   $0x804360
  80152f:	e8 8f 03 00 00       	call   8018c3 <cprintf>
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	eb 59                	jmp    801592 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801539:	a1 00 52 80 00       	mov    0x805200,%eax
  80153e:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  801544:	a1 00 52 80 00       	mov    0x805200,%eax
  801549:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	52                   	push   %edx
  801553:	50                   	push   %eax
  801554:	68 84 43 80 00       	push   $0x804384
  801559:	e8 65 03 00 00       	call   8018c3 <cprintf>
  80155e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801561:	a1 00 52 80 00       	mov    0x805200,%eax
  801566:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80156c:	a1 00 52 80 00       	mov    0x805200,%eax
  801571:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  801577:	a1 00 52 80 00       	mov    0x805200,%eax
  80157c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801582:	51                   	push   %ecx
  801583:	52                   	push   %edx
  801584:	50                   	push   %eax
  801585:	68 ac 43 80 00       	push   $0x8043ac
  80158a:	e8 34 03 00 00       	call   8018c3 <cprintf>
  80158f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801592:	a1 00 52 80 00       	mov    0x805200,%eax
  801597:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80159d:	83 ec 08             	sub    $0x8,%esp
  8015a0:	50                   	push   %eax
  8015a1:	68 04 44 80 00       	push   $0x804404
  8015a6:	e8 18 03 00 00       	call   8018c3 <cprintf>
  8015ab:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8015ae:	83 ec 0c             	sub    $0xc,%esp
  8015b1:	68 38 43 80 00       	push   $0x804338
  8015b6:	e8 08 03 00 00       	call   8018c3 <cprintf>
  8015bb:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8015be:	e8 25 14 00 00       	call   8029e8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8015c3:	e8 1f 00 00 00       	call   8015e7 <exit>
}
  8015c8:	90                   	nop
  8015c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cc:	5b                   	pop    %ebx
  8015cd:	5e                   	pop    %esi
  8015ce:	5f                   	pop    %edi
  8015cf:	5d                   	pop    %ebp
  8015d0:	c3                   	ret    

008015d1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8015d7:	83 ec 0c             	sub    $0xc,%esp
  8015da:	6a 00                	push   $0x0
  8015dc:	e8 32 16 00 00       	call   802c13 <sys_destroy_env>
  8015e1:	83 c4 10             	add    $0x10,%esp
}
  8015e4:	90                   	nop
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <exit>:

void
exit(void)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015ed:	e8 87 16 00 00       	call   802c79 <sys_exit_env>
}
  8015f2:	90                   	nop
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015fb:	8d 45 10             	lea    0x10(%ebp),%eax
  8015fe:	83 c0 04             	add    $0x4,%eax
  801601:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801604:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  801609:	85 c0                	test   %eax,%eax
  80160b:	74 16                	je     801623 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80160d:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  801612:	83 ec 08             	sub    $0x8,%esp
  801615:	50                   	push   %eax
  801616:	68 7c 44 80 00       	push   $0x80447c
  80161b:	e8 a3 02 00 00       	call   8018c3 <cprintf>
  801620:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801623:	a1 04 50 80 00       	mov    0x805004,%eax
  801628:	83 ec 0c             	sub    $0xc,%esp
  80162b:	ff 75 0c             	pushl  0xc(%ebp)
  80162e:	ff 75 08             	pushl  0x8(%ebp)
  801631:	50                   	push   %eax
  801632:	68 84 44 80 00       	push   $0x804484
  801637:	6a 74                	push   $0x74
  801639:	e8 b2 02 00 00       	call   8018f0 <cprintf_colored>
  80163e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	ff 75 f4             	pushl  -0xc(%ebp)
  80164a:	50                   	push   %eax
  80164b:	e8 04 02 00 00       	call   801854 <vcprintf>
  801650:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801653:	83 ec 08             	sub    $0x8,%esp
  801656:	6a 00                	push   $0x0
  801658:	68 ac 44 80 00       	push   $0x8044ac
  80165d:	e8 f2 01 00 00       	call   801854 <vcprintf>
  801662:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801665:	e8 7d ff ff ff       	call   8015e7 <exit>

	// should not return here
	while (1) ;
  80166a:	eb fe                	jmp    80166a <_panic+0x75>

0080166c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801672:	a1 00 52 80 00       	mov    0x805200,%eax
  801677:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	39 c2                	cmp    %eax,%edx
  801682:	74 14                	je     801698 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	68 b0 44 80 00       	push   $0x8044b0
  80168c:	6a 26                	push   $0x26
  80168e:	68 fc 44 80 00       	push   $0x8044fc
  801693:	e8 5d ff ff ff       	call   8015f5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801698:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80169f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016a6:	e9 c5 00 00 00       	jmp    801770 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8016ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	01 d0                	add    %edx,%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	75 08                	jne    8016c8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8016c0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016c3:	e9 a5 00 00 00       	jmp    80176d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8016c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016d6:	eb 69                	jmp    801741 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8016d8:	a1 00 52 80 00       	mov    0x805200,%eax
  8016dd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8016e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	01 c0                	add    %eax,%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	c1 e0 03             	shl    $0x3,%eax
  8016ef:	01 c8                	add    %ecx,%eax
  8016f1:	8a 40 04             	mov    0x4(%eax),%al
  8016f4:	84 c0                	test   %al,%al
  8016f6:	75 46                	jne    80173e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016f8:	a1 00 52 80 00       	mov    0x805200,%eax
  8016fd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801703:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801706:	89 d0                	mov    %edx,%eax
  801708:	01 c0                	add    %eax,%eax
  80170a:	01 d0                	add    %edx,%eax
  80170c:	c1 e0 03             	shl    $0x3,%eax
  80170f:	01 c8                	add    %ecx,%eax
  801711:	8b 00                	mov    (%eax),%eax
  801713:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801716:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801719:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80171e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801723:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	01 c8                	add    %ecx,%eax
  80172f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801731:	39 c2                	cmp    %eax,%edx
  801733:	75 09                	jne    80173e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801735:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80173c:	eb 15                	jmp    801753 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80173e:	ff 45 e8             	incl   -0x18(%ebp)
  801741:	a1 00 52 80 00       	mov    0x805200,%eax
  801746:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80174c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174f:	39 c2                	cmp    %eax,%edx
  801751:	77 85                	ja     8016d8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801753:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801757:	75 14                	jne    80176d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	68 08 45 80 00       	push   $0x804508
  801761:	6a 3a                	push   $0x3a
  801763:	68 fc 44 80 00       	push   $0x8044fc
  801768:	e8 88 fe ff ff       	call   8015f5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80176d:	ff 45 f0             	incl   -0x10(%ebp)
  801770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801773:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801776:	0f 8c 2f ff ff ff    	jl     8016ab <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80177c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801783:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80178a:	eb 26                	jmp    8017b2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80178c:	a1 00 52 80 00       	mov    0x805200,%eax
  801791:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80179a:	89 d0                	mov    %edx,%eax
  80179c:	01 c0                	add    %eax,%eax
  80179e:	01 d0                	add    %edx,%eax
  8017a0:	c1 e0 03             	shl    $0x3,%eax
  8017a3:	01 c8                	add    %ecx,%eax
  8017a5:	8a 40 04             	mov    0x4(%eax),%al
  8017a8:	3c 01                	cmp    $0x1,%al
  8017aa:	75 03                	jne    8017af <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8017ac:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017af:	ff 45 e0             	incl   -0x20(%ebp)
  8017b2:	a1 00 52 80 00       	mov    0x805200,%eax
  8017b7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c0:	39 c2                	cmp    %eax,%edx
  8017c2:	77 c8                	ja     80178c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017ca:	74 14                	je     8017e0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	68 5c 45 80 00       	push   $0x80455c
  8017d4:	6a 44                	push   $0x44
  8017d6:	68 fc 44 80 00       	push   $0x8044fc
  8017db:	e8 15 fe ff ff       	call   8015f5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017e0:	90                   	nop
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	53                   	push   %ebx
  8017e7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ed:	8b 00                	mov    (%eax),%eax
  8017ef:	8d 48 01             	lea    0x1(%eax),%ecx
  8017f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f5:	89 0a                	mov    %ecx,(%edx)
  8017f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fa:	88 d1                	mov    %dl,%cl
  8017fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ff:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	8b 00                	mov    (%eax),%eax
  801808:	3d ff 00 00 00       	cmp    $0xff,%eax
  80180d:	75 30                	jne    80183f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80180f:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801815:	a0 24 52 80 00       	mov    0x805224,%al
  80181a:	0f b6 c0             	movzbl %al,%eax
  80181d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801820:	8b 09                	mov    (%ecx),%ecx
  801822:	89 cb                	mov    %ecx,%ebx
  801824:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801827:	83 c1 08             	add    $0x8,%ecx
  80182a:	52                   	push   %edx
  80182b:	50                   	push   %eax
  80182c:	53                   	push   %ebx
  80182d:	51                   	push   %ecx
  80182e:	e8 57 11 00 00       	call   80298a <sys_cputs>
  801833:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80183f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801842:	8b 40 04             	mov    0x4(%eax),%eax
  801845:	8d 50 01             	lea    0x1(%eax),%edx
  801848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80184e:	90                   	nop
  80184f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80185d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801864:	00 00 00 
	b.cnt = 0;
  801867:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80186e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	ff 75 08             	pushl  0x8(%ebp)
  801877:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80187d:	50                   	push   %eax
  80187e:	68 e3 17 80 00       	push   $0x8017e3
  801883:	e8 5a 02 00 00       	call   801ae2 <vprintfmt>
  801888:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80188b:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801891:	a0 24 52 80 00       	mov    0x805224,%al
  801896:	0f b6 c0             	movzbl %al,%eax
  801899:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80189f:	52                   	push   %edx
  8018a0:	50                   	push   %eax
  8018a1:	51                   	push   %ecx
  8018a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8018a8:	83 c0 08             	add    $0x8,%eax
  8018ab:	50                   	push   %eax
  8018ac:	e8 d9 10 00 00       	call   80298a <sys_cputs>
  8018b1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8018b4:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  8018bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018c9:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  8018d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018df:	50                   	push   %eax
  8018e0:	e8 6f ff ff ff       	call   801854 <vcprintf>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8018eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018f6:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	c1 e0 08             	shl    $0x8,%eax
  801903:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  801908:	8d 45 0c             	lea    0xc(%ebp),%eax
  80190b:	83 c0 04             	add    $0x4,%eax
  80190e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801911:	8b 45 0c             	mov    0xc(%ebp),%eax
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	ff 75 f4             	pushl  -0xc(%ebp)
  80191a:	50                   	push   %eax
  80191b:	e8 34 ff ff ff       	call   801854 <vcprintf>
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801926:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  80192d:	07 00 00 

	return cnt;
  801930:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80193b:	e8 8e 10 00 00       	call   8029ce <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801940:	8d 45 0c             	lea    0xc(%ebp),%eax
  801943:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	83 ec 08             	sub    $0x8,%esp
  80194c:	ff 75 f4             	pushl  -0xc(%ebp)
  80194f:	50                   	push   %eax
  801950:	e8 ff fe ff ff       	call   801854 <vcprintf>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80195b:	e8 88 10 00 00       	call   8029e8 <sys_unlock_cons>
	return cnt;
  801960:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	53                   	push   %ebx
  801969:	83 ec 14             	sub    $0x14,%esp
  80196c:	8b 45 10             	mov    0x10(%ebp),%eax
  80196f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801972:	8b 45 14             	mov    0x14(%ebp),%eax
  801975:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801978:	8b 45 18             	mov    0x18(%ebp),%eax
  80197b:	ba 00 00 00 00       	mov    $0x0,%edx
  801980:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801983:	77 55                	ja     8019da <printnum+0x75>
  801985:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801988:	72 05                	jb     80198f <printnum+0x2a>
  80198a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80198d:	77 4b                	ja     8019da <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80198f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801992:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801995:	8b 45 18             	mov    0x18(%ebp),%eax
  801998:	ba 00 00 00 00       	mov    $0x0,%edx
  80199d:	52                   	push   %edx
  80199e:	50                   	push   %eax
  80199f:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a5:	e8 06 20 00 00       	call   8039b0 <__udivdi3>
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	ff 75 20             	pushl  0x20(%ebp)
  8019b3:	53                   	push   %ebx
  8019b4:	ff 75 18             	pushl  0x18(%ebp)
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	e8 a1 ff ff ff       	call   801965 <printnum>
  8019c4:	83 c4 20             	add    $0x20,%esp
  8019c7:	eb 1a                	jmp    8019e3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019c9:	83 ec 08             	sub    $0x8,%esp
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 20             	pushl  0x20(%ebp)
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	ff d0                	call   *%eax
  8019d7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019da:	ff 4d 1c             	decl   0x1c(%ebp)
  8019dd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8019e1:	7f e6                	jg     8019c9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019e3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f1:	53                   	push   %ebx
  8019f2:	51                   	push   %ecx
  8019f3:	52                   	push   %edx
  8019f4:	50                   	push   %eax
  8019f5:	e8 c6 20 00 00       	call   803ac0 <__umoddi3>
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	05 d4 47 80 00       	add    $0x8047d4,%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	0f be c0             	movsbl %al,%eax
  801a07:	83 ec 08             	sub    $0x8,%esp
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	50                   	push   %eax
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	ff d0                	call   *%eax
  801a13:	83 c4 10             	add    $0x10,%esp
}
  801a16:	90                   	nop
  801a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a1f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a23:	7e 1c                	jle    801a41 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	8b 00                	mov    (%eax),%eax
  801a2a:	8d 50 08             	lea    0x8(%eax),%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	89 10                	mov    %edx,(%eax)
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8b 00                	mov    (%eax),%eax
  801a37:	83 e8 08             	sub    $0x8,%eax
  801a3a:	8b 50 04             	mov    0x4(%eax),%edx
  801a3d:	8b 00                	mov    (%eax),%eax
  801a3f:	eb 40                	jmp    801a81 <getuint+0x65>
	else if (lflag)
  801a41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a45:	74 1e                	je     801a65 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	8d 50 04             	lea    0x4(%eax),%edx
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	89 10                	mov    %edx,(%eax)
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	8b 00                	mov    (%eax),%eax
  801a59:	83 e8 04             	sub    $0x4,%eax
  801a5c:	8b 00                	mov    (%eax),%eax
  801a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a63:	eb 1c                	jmp    801a81 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	8b 00                	mov    (%eax),%eax
  801a6a:	8d 50 04             	lea    0x4(%eax),%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	89 10                	mov    %edx,(%eax)
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	8b 00                	mov    (%eax),%eax
  801a77:	83 e8 04             	sub    $0x4,%eax
  801a7a:	8b 00                	mov    (%eax),%eax
  801a7c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a86:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a8a:	7e 1c                	jle    801aa8 <getint+0x25>
		return va_arg(*ap, long long);
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	8d 50 08             	lea    0x8(%eax),%edx
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	89 10                	mov    %edx,(%eax)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8b 00                	mov    (%eax),%eax
  801a9e:	83 e8 08             	sub    $0x8,%eax
  801aa1:	8b 50 04             	mov    0x4(%eax),%edx
  801aa4:	8b 00                	mov    (%eax),%eax
  801aa6:	eb 38                	jmp    801ae0 <getint+0x5d>
	else if (lflag)
  801aa8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801aac:	74 1a                	je     801ac8 <getint+0x45>
		return va_arg(*ap, long);
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8b 00                	mov    (%eax),%eax
  801ab3:	8d 50 04             	lea    0x4(%eax),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	89 10                	mov    %edx,(%eax)
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	8b 00                	mov    (%eax),%eax
  801ac0:	83 e8 04             	sub    $0x4,%eax
  801ac3:	8b 00                	mov    (%eax),%eax
  801ac5:	99                   	cltd   
  801ac6:	eb 18                	jmp    801ae0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	8b 00                	mov    (%eax),%eax
  801acd:	8d 50 04             	lea    0x4(%eax),%edx
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	89 10                	mov    %edx,(%eax)
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	83 e8 04             	sub    $0x4,%eax
  801add:	8b 00                	mov    (%eax),%eax
  801adf:	99                   	cltd   
}
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    

00801ae2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	56                   	push   %esi
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801aea:	eb 17                	jmp    801b03 <vprintfmt+0x21>
			if (ch == '\0')
  801aec:	85 db                	test   %ebx,%ebx
  801aee:	0f 84 c1 03 00 00    	je     801eb5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	53                   	push   %ebx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	ff d0                	call   *%eax
  801b00:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b03:	8b 45 10             	mov    0x10(%ebp),%eax
  801b06:	8d 50 01             	lea    0x1(%eax),%edx
  801b09:	89 55 10             	mov    %edx,0x10(%ebp)
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	0f b6 d8             	movzbl %al,%ebx
  801b11:	83 fb 25             	cmp    $0x25,%ebx
  801b14:	75 d6                	jne    801aec <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801b16:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801b1a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801b21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801b28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801b2f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b36:	8b 45 10             	mov    0x10(%ebp),%eax
  801b39:	8d 50 01             	lea    0x1(%eax),%edx
  801b3c:	89 55 10             	mov    %edx,0x10(%ebp)
  801b3f:	8a 00                	mov    (%eax),%al
  801b41:	0f b6 d8             	movzbl %al,%ebx
  801b44:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801b47:	83 f8 5b             	cmp    $0x5b,%eax
  801b4a:	0f 87 3d 03 00 00    	ja     801e8d <vprintfmt+0x3ab>
  801b50:	8b 04 85 f8 47 80 00 	mov    0x8047f8(,%eax,4),%eax
  801b57:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801b59:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b5d:	eb d7                	jmp    801b36 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b5f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b63:	eb d1                	jmp    801b36 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b6f:	89 d0                	mov    %edx,%eax
  801b71:	c1 e0 02             	shl    $0x2,%eax
  801b74:	01 d0                	add    %edx,%eax
  801b76:	01 c0                	add    %eax,%eax
  801b78:	01 d8                	add    %ebx,%eax
  801b7a:	83 e8 30             	sub    $0x30,%eax
  801b7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b80:	8b 45 10             	mov    0x10(%ebp),%eax
  801b83:	8a 00                	mov    (%eax),%al
  801b85:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b88:	83 fb 2f             	cmp    $0x2f,%ebx
  801b8b:	7e 3e                	jle    801bcb <vprintfmt+0xe9>
  801b8d:	83 fb 39             	cmp    $0x39,%ebx
  801b90:	7f 39                	jg     801bcb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b92:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b95:	eb d5                	jmp    801b6c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b97:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9a:	83 c0 04             	add    $0x4,%eax
  801b9d:	89 45 14             	mov    %eax,0x14(%ebp)
  801ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba3:	83 e8 04             	sub    $0x4,%eax
  801ba6:	8b 00                	mov    (%eax),%eax
  801ba8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801bab:	eb 1f                	jmp    801bcc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801bad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bb1:	79 83                	jns    801b36 <vprintfmt+0x54>
				width = 0;
  801bb3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801bba:	e9 77 ff ff ff       	jmp    801b36 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801bbf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801bc6:	e9 6b ff ff ff       	jmp    801b36 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801bcb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801bcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bd0:	0f 89 60 ff ff ff    	jns    801b36 <vprintfmt+0x54>
				width = precision, precision = -1;
  801bd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bdc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801be3:	e9 4e ff ff ff       	jmp    801b36 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801be8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801beb:	e9 46 ff ff ff       	jmp    801b36 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf3:	83 c0 04             	add    $0x4,%eax
  801bf6:	89 45 14             	mov    %eax,0x14(%ebp)
  801bf9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfc:	83 e8 04             	sub    $0x4,%eax
  801bff:	8b 00                	mov    (%eax),%eax
  801c01:	83 ec 08             	sub    $0x8,%esp
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	50                   	push   %eax
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	ff d0                	call   *%eax
  801c0d:	83 c4 10             	add    $0x10,%esp
			break;
  801c10:	e9 9b 02 00 00       	jmp    801eb0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801c15:	8b 45 14             	mov    0x14(%ebp),%eax
  801c18:	83 c0 04             	add    $0x4,%eax
  801c1b:	89 45 14             	mov    %eax,0x14(%ebp)
  801c1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c21:	83 e8 04             	sub    $0x4,%eax
  801c24:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801c26:	85 db                	test   %ebx,%ebx
  801c28:	79 02                	jns    801c2c <vprintfmt+0x14a>
				err = -err;
  801c2a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801c2c:	83 fb 64             	cmp    $0x64,%ebx
  801c2f:	7f 0b                	jg     801c3c <vprintfmt+0x15a>
  801c31:	8b 34 9d 40 46 80 00 	mov    0x804640(,%ebx,4),%esi
  801c38:	85 f6                	test   %esi,%esi
  801c3a:	75 19                	jne    801c55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801c3c:	53                   	push   %ebx
  801c3d:	68 e5 47 80 00       	push   $0x8047e5
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	ff 75 08             	pushl  0x8(%ebp)
  801c48:	e8 70 02 00 00       	call   801ebd <printfmt>
  801c4d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801c50:	e9 5b 02 00 00       	jmp    801eb0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801c55:	56                   	push   %esi
  801c56:	68 ee 47 80 00       	push   $0x8047ee
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	ff 75 08             	pushl  0x8(%ebp)
  801c61:	e8 57 02 00 00       	call   801ebd <printfmt>
  801c66:	83 c4 10             	add    $0x10,%esp
			break;
  801c69:	e9 42 02 00 00       	jmp    801eb0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c71:	83 c0 04             	add    $0x4,%eax
  801c74:	89 45 14             	mov    %eax,0x14(%ebp)
  801c77:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7a:	83 e8 04             	sub    $0x4,%eax
  801c7d:	8b 30                	mov    (%eax),%esi
  801c7f:	85 f6                	test   %esi,%esi
  801c81:	75 05                	jne    801c88 <vprintfmt+0x1a6>
				p = "(null)";
  801c83:	be f1 47 80 00       	mov    $0x8047f1,%esi
			if (width > 0 && padc != '-')
  801c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c8c:	7e 6d                	jle    801cfb <vprintfmt+0x219>
  801c8e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c92:	74 67                	je     801cfb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c97:	83 ec 08             	sub    $0x8,%esp
  801c9a:	50                   	push   %eax
  801c9b:	56                   	push   %esi
  801c9c:	e8 1e 03 00 00       	call   801fbf <strnlen>
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801ca7:	eb 16                	jmp    801cbf <vprintfmt+0x1dd>
					putch(padc, putdat);
  801ca9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801cad:	83 ec 08             	sub    $0x8,%esp
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	50                   	push   %eax
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	ff d0                	call   *%eax
  801cb9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801cbc:	ff 4d e4             	decl   -0x1c(%ebp)
  801cbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cc3:	7f e4                	jg     801ca9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cc5:	eb 34                	jmp    801cfb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801cc7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ccb:	74 1c                	je     801ce9 <vprintfmt+0x207>
  801ccd:	83 fb 1f             	cmp    $0x1f,%ebx
  801cd0:	7e 05                	jle    801cd7 <vprintfmt+0x1f5>
  801cd2:	83 fb 7e             	cmp    $0x7e,%ebx
  801cd5:	7e 12                	jle    801ce9 <vprintfmt+0x207>
					putch('?', putdat);
  801cd7:	83 ec 08             	sub    $0x8,%esp
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	6a 3f                	push   $0x3f
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	ff d0                	call   *%eax
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	eb 0f                	jmp    801cf8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801ce9:	83 ec 08             	sub    $0x8,%esp
  801cec:	ff 75 0c             	pushl  0xc(%ebp)
  801cef:	53                   	push   %ebx
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	ff d0                	call   *%eax
  801cf5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cf8:	ff 4d e4             	decl   -0x1c(%ebp)
  801cfb:	89 f0                	mov    %esi,%eax
  801cfd:	8d 70 01             	lea    0x1(%eax),%esi
  801d00:	8a 00                	mov    (%eax),%al
  801d02:	0f be d8             	movsbl %al,%ebx
  801d05:	85 db                	test   %ebx,%ebx
  801d07:	74 24                	je     801d2d <vprintfmt+0x24b>
  801d09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d0d:	78 b8                	js     801cc7 <vprintfmt+0x1e5>
  801d0f:	ff 4d e0             	decl   -0x20(%ebp)
  801d12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d16:	79 af                	jns    801cc7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d18:	eb 13                	jmp    801d2d <vprintfmt+0x24b>
				putch(' ', putdat);
  801d1a:	83 ec 08             	sub    $0x8,%esp
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	6a 20                	push   $0x20
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	ff d0                	call   *%eax
  801d27:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d2a:	ff 4d e4             	decl   -0x1c(%ebp)
  801d2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d31:	7f e7                	jg     801d1a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801d33:	e9 78 01 00 00       	jmp    801eb0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d38:	83 ec 08             	sub    $0x8,%esp
  801d3b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d3e:	8d 45 14             	lea    0x14(%ebp),%eax
  801d41:	50                   	push   %eax
  801d42:	e8 3c fd ff ff       	call   801a83 <getint>
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d56:	85 d2                	test   %edx,%edx
  801d58:	79 23                	jns    801d7d <vprintfmt+0x29b>
				putch('-', putdat);
  801d5a:	83 ec 08             	sub    $0x8,%esp
  801d5d:	ff 75 0c             	pushl  0xc(%ebp)
  801d60:	6a 2d                	push   $0x2d
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	ff d0                	call   *%eax
  801d67:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d70:	f7 d8                	neg    %eax
  801d72:	83 d2 00             	adc    $0x0,%edx
  801d75:	f7 da                	neg    %edx
  801d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d7d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d84:	e9 bc 00 00 00       	jmp    801e45 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	ff 75 e8             	pushl  -0x18(%ebp)
  801d8f:	8d 45 14             	lea    0x14(%ebp),%eax
  801d92:	50                   	push   %eax
  801d93:	e8 84 fc ff ff       	call   801a1c <getuint>
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801da1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801da8:	e9 98 00 00 00       	jmp    801e45 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801dad:	83 ec 08             	sub    $0x8,%esp
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	6a 58                	push   $0x58
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	ff d0                	call   *%eax
  801dba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801dbd:	83 ec 08             	sub    $0x8,%esp
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	6a 58                	push   $0x58
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	ff d0                	call   *%eax
  801dca:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801dcd:	83 ec 08             	sub    $0x8,%esp
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	6a 58                	push   $0x58
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	ff d0                	call   *%eax
  801dda:	83 c4 10             	add    $0x10,%esp
			break;
  801ddd:	e9 ce 00 00 00       	jmp    801eb0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801de2:	83 ec 08             	sub    $0x8,%esp
  801de5:	ff 75 0c             	pushl  0xc(%ebp)
  801de8:	6a 30                	push   $0x30
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	ff d0                	call   *%eax
  801def:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801df2:	83 ec 08             	sub    $0x8,%esp
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	6a 78                	push   $0x78
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	ff d0                	call   *%eax
  801dff:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801e02:	8b 45 14             	mov    0x14(%ebp),%eax
  801e05:	83 c0 04             	add    $0x4,%eax
  801e08:	89 45 14             	mov    %eax,0x14(%ebp)
  801e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0e:	83 e8 04             	sub    $0x4,%eax
  801e11:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801e1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801e24:	eb 1f                	jmp    801e45 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e26:	83 ec 08             	sub    $0x8,%esp
  801e29:	ff 75 e8             	pushl  -0x18(%ebp)
  801e2c:	8d 45 14             	lea    0x14(%ebp),%eax
  801e2f:	50                   	push   %eax
  801e30:	e8 e7 fb ff ff       	call   801a1c <getuint>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801e3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e45:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	52                   	push   %edx
  801e50:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e53:	50                   	push   %eax
  801e54:	ff 75 f4             	pushl  -0xc(%ebp)
  801e57:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5a:	ff 75 0c             	pushl  0xc(%ebp)
  801e5d:	ff 75 08             	pushl  0x8(%ebp)
  801e60:	e8 00 fb ff ff       	call   801965 <printnum>
  801e65:	83 c4 20             	add    $0x20,%esp
			break;
  801e68:	eb 46                	jmp    801eb0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e6a:	83 ec 08             	sub    $0x8,%esp
  801e6d:	ff 75 0c             	pushl  0xc(%ebp)
  801e70:	53                   	push   %ebx
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	ff d0                	call   *%eax
  801e76:	83 c4 10             	add    $0x10,%esp
			break;
  801e79:	eb 35                	jmp    801eb0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e7b:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801e82:	eb 2c                	jmp    801eb0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801e84:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801e8b:	eb 23                	jmp    801eb0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e8d:	83 ec 08             	sub    $0x8,%esp
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	6a 25                	push   $0x25
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	ff d0                	call   *%eax
  801e9a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e9d:	ff 4d 10             	decl   0x10(%ebp)
  801ea0:	eb 03                	jmp    801ea5 <vprintfmt+0x3c3>
  801ea2:	ff 4d 10             	decl   0x10(%ebp)
  801ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea8:	48                   	dec    %eax
  801ea9:	8a 00                	mov    (%eax),%al
  801eab:	3c 25                	cmp    $0x25,%al
  801ead:	75 f3                	jne    801ea2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801eaf:	90                   	nop
		}
	}
  801eb0:	e9 35 fc ff ff       	jmp    801aea <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801eb5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801eb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb9:	5b                   	pop    %ebx
  801eba:	5e                   	pop    %esi
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    

00801ebd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801ec3:	8d 45 10             	lea    0x10(%ebp),%eax
  801ec6:	83 c0 04             	add    $0x4,%eax
  801ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed2:	50                   	push   %eax
  801ed3:	ff 75 0c             	pushl  0xc(%ebp)
  801ed6:	ff 75 08             	pushl  0x8(%ebp)
  801ed9:	e8 04 fc ff ff       	call   801ae2 <vprintfmt>
  801ede:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ee1:	90                   	nop
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eea:	8b 40 08             	mov    0x8(%eax),%eax
  801eed:	8d 50 01             	lea    0x1(%eax),%edx
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef9:	8b 10                	mov    (%eax),%edx
  801efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efe:	8b 40 04             	mov    0x4(%eax),%eax
  801f01:	39 c2                	cmp    %eax,%edx
  801f03:	73 12                	jae    801f17 <sprintputch+0x33>
		*b->buf++ = ch;
  801f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f08:	8b 00                	mov    (%eax),%eax
  801f0a:	8d 48 01             	lea    0x1(%eax),%ecx
  801f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f10:	89 0a                	mov    %ecx,(%edx)
  801f12:	8b 55 08             	mov    0x8(%ebp),%edx
  801f15:	88 10                	mov    %dl,(%eax)
}
  801f17:	90                   	nop
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    

00801f1a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	01 d0                	add    %edx,%eax
  801f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f3f:	74 06                	je     801f47 <vsnprintf+0x2d>
  801f41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f45:	7f 07                	jg     801f4e <vsnprintf+0x34>
		return -E_INVAL;
  801f47:	b8 03 00 00 00       	mov    $0x3,%eax
  801f4c:	eb 20                	jmp    801f6e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f4e:	ff 75 14             	pushl  0x14(%ebp)
  801f51:	ff 75 10             	pushl  0x10(%ebp)
  801f54:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f57:	50                   	push   %eax
  801f58:	68 e4 1e 80 00       	push   $0x801ee4
  801f5d:	e8 80 fb ff ff       	call   801ae2 <vprintfmt>
  801f62:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f68:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f76:	8d 45 10             	lea    0x10(%ebp),%eax
  801f79:	83 c0 04             	add    $0x4,%eax
  801f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f82:	ff 75 f4             	pushl  -0xc(%ebp)
  801f85:	50                   	push   %eax
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	ff 75 08             	pushl  0x8(%ebp)
  801f8c:	e8 89 ff ff ff       	call   801f1a <vsnprintf>
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801fa2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fa9:	eb 06                	jmp    801fb1 <strlen+0x15>
		n++;
  801fab:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801fae:	ff 45 08             	incl   0x8(%ebp)
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	8a 00                	mov    (%eax),%al
  801fb6:	84 c0                	test   %al,%al
  801fb8:	75 f1                	jne    801fab <strlen+0xf>
		n++;
	return n;
  801fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fcc:	eb 09                	jmp    801fd7 <strnlen+0x18>
		n++;
  801fce:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fd1:	ff 45 08             	incl   0x8(%ebp)
  801fd4:	ff 4d 0c             	decl   0xc(%ebp)
  801fd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fdb:	74 09                	je     801fe6 <strnlen+0x27>
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	8a 00                	mov    (%eax),%al
  801fe2:	84 c0                	test   %al,%al
  801fe4:	75 e8                	jne    801fce <strnlen+0xf>
		n++;
	return n;
  801fe6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801ff7:	90                   	nop
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	8d 50 01             	lea    0x1(%eax),%edx
  801ffe:	89 55 08             	mov    %edx,0x8(%ebp)
  802001:	8b 55 0c             	mov    0xc(%ebp),%edx
  802004:	8d 4a 01             	lea    0x1(%edx),%ecx
  802007:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80200a:	8a 12                	mov    (%edx),%dl
  80200c:	88 10                	mov    %dl,(%eax)
  80200e:	8a 00                	mov    (%eax),%al
  802010:	84 c0                	test   %al,%al
  802012:	75 e4                	jne    801ff8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  802014:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802025:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80202c:	eb 1f                	jmp    80204d <strncpy+0x34>
		*dst++ = *src;
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	8d 50 01             	lea    0x1(%eax),%edx
  802034:	89 55 08             	mov    %edx,0x8(%ebp)
  802037:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203a:	8a 12                	mov    (%edx),%dl
  80203c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80203e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802041:	8a 00                	mov    (%eax),%al
  802043:	84 c0                	test   %al,%al
  802045:	74 03                	je     80204a <strncpy+0x31>
			src++;
  802047:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80204a:	ff 45 fc             	incl   -0x4(%ebp)
  80204d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802050:	3b 45 10             	cmp    0x10(%ebp),%eax
  802053:	72 d9                	jb     80202e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802055:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802066:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80206a:	74 30                	je     80209c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80206c:	eb 16                	jmp    802084 <strlcpy+0x2a>
			*dst++ = *src++;
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	8d 50 01             	lea    0x1(%eax),%edx
  802074:	89 55 08             	mov    %edx,0x8(%ebp)
  802077:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80207d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802080:	8a 12                	mov    (%edx),%dl
  802082:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802084:	ff 4d 10             	decl   0x10(%ebp)
  802087:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208b:	74 09                	je     802096 <strlcpy+0x3c>
  80208d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802090:	8a 00                	mov    (%eax),%al
  802092:	84 c0                	test   %al,%al
  802094:	75 d8                	jne    80206e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80209c:	8b 55 08             	mov    0x8(%ebp),%edx
  80209f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a2:	29 c2                	sub    %eax,%edx
  8020a4:	89 d0                	mov    %edx,%eax
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8020ab:	eb 06                	jmp    8020b3 <strcmp+0xb>
		p++, q++;
  8020ad:	ff 45 08             	incl   0x8(%ebp)
  8020b0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	8a 00                	mov    (%eax),%al
  8020b8:	84 c0                	test   %al,%al
  8020ba:	74 0e                	je     8020ca <strcmp+0x22>
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8a 10                	mov    (%eax),%dl
  8020c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c4:	8a 00                	mov    (%eax),%al
  8020c6:	38 c2                	cmp    %al,%dl
  8020c8:	74 e3                	je     8020ad <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	8a 00                	mov    (%eax),%al
  8020cf:	0f b6 d0             	movzbl %al,%edx
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	8a 00                	mov    (%eax),%al
  8020d7:	0f b6 c0             	movzbl %al,%eax
  8020da:	29 c2                	sub    %eax,%edx
  8020dc:	89 d0                	mov    %edx,%eax
}
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    

008020e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8020e3:	eb 09                	jmp    8020ee <strncmp+0xe>
		n--, p++, q++;
  8020e5:	ff 4d 10             	decl   0x10(%ebp)
  8020e8:	ff 45 08             	incl   0x8(%ebp)
  8020eb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8020ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f2:	74 17                	je     80210b <strncmp+0x2b>
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	8a 00                	mov    (%eax),%al
  8020f9:	84 c0                	test   %al,%al
  8020fb:	74 0e                	je     80210b <strncmp+0x2b>
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	8a 10                	mov    (%eax),%dl
  802102:	8b 45 0c             	mov    0xc(%ebp),%eax
  802105:	8a 00                	mov    (%eax),%al
  802107:	38 c2                	cmp    %al,%dl
  802109:	74 da                	je     8020e5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	75 07                	jne    802118 <strncmp+0x38>
		return 0;
  802111:	b8 00 00 00 00       	mov    $0x0,%eax
  802116:	eb 14                	jmp    80212c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	8a 00                	mov    (%eax),%al
  80211d:	0f b6 d0             	movzbl %al,%edx
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	8a 00                	mov    (%eax),%al
  802125:	0f b6 c0             	movzbl %al,%eax
  802128:	29 c2                	sub    %eax,%edx
  80212a:	89 d0                	mov    %edx,%eax
}
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 04             	sub    $0x4,%esp
  802134:	8b 45 0c             	mov    0xc(%ebp),%eax
  802137:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80213a:	eb 12                	jmp    80214e <strchr+0x20>
		if (*s == c)
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	8a 00                	mov    (%eax),%al
  802141:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802144:	75 05                	jne    80214b <strchr+0x1d>
			return (char *) s;
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	eb 11                	jmp    80215c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80214b:	ff 45 08             	incl   0x8(%ebp)
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	84 c0                	test   %al,%al
  802155:	75 e5                	jne    80213c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	8b 45 0c             	mov    0xc(%ebp),%eax
  802167:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80216a:	eb 0d                	jmp    802179 <strfind+0x1b>
		if (*s == c)
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8a 00                	mov    (%eax),%al
  802171:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802174:	74 0e                	je     802184 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802176:	ff 45 08             	incl   0x8(%ebp)
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	8a 00                	mov    (%eax),%al
  80217e:	84 c0                	test   %al,%al
  802180:	75 ea                	jne    80216c <strfind+0xe>
  802182:	eb 01                	jmp    802185 <strfind+0x27>
		if (*s == c)
			break;
  802184:	90                   	nop
	return (char *) s;
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802196:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80219a:	76 63                	jbe    8021ff <memset+0x75>
		uint64 data_block = c;
  80219c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219f:	99                   	cltd   
  8021a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8021a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ac:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8021b0:	c1 e0 08             	shl    $0x8,%eax
  8021b3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021b6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8021b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bf:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8021c3:	c1 e0 10             	shl    $0x10,%eax
  8021c6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021c9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d2:	89 c2                	mov    %eax,%edx
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021dc:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8021df:	eb 18                	jmp    8021f9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8021e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021e4:	8d 41 08             	lea    0x8(%ecx),%eax
  8021e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f0:	89 01                	mov    %eax,(%ecx)
  8021f2:	89 51 04             	mov    %edx,0x4(%ecx)
  8021f5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8021f9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021fd:	77 e2                	ja     8021e1 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8021ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802203:	74 23                	je     802228 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802205:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802208:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80220b:	eb 0e                	jmp    80221b <memset+0x91>
			*p8++ = (uint8)c;
  80220d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802210:	8d 50 01             	lea    0x1(%eax),%edx
  802213:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802216:	8b 55 0c             	mov    0xc(%ebp),%edx
  802219:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80221b:	8b 45 10             	mov    0x10(%ebp),%eax
  80221e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802221:	89 55 10             	mov    %edx,0x10(%ebp)
  802224:	85 c0                	test   %eax,%eax
  802226:	75 e5                	jne    80220d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802233:	8b 45 0c             	mov    0xc(%ebp),%eax
  802236:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80223f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802243:	76 24                	jbe    802269 <memcpy+0x3c>
		while(n >= 8){
  802245:	eb 1c                	jmp    802263 <memcpy+0x36>
			*d64 = *s64;
  802247:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224a:	8b 50 04             	mov    0x4(%eax),%edx
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802252:	89 01                	mov    %eax,(%ecx)
  802254:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802257:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80225b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80225f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802263:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802267:	77 de                	ja     802247 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80226d:	74 31                	je     8022a0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80226f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802272:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802275:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802278:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80227b:	eb 16                	jmp    802293 <memcpy+0x66>
			*d8++ = *s8++;
  80227d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802280:	8d 50 01             	lea    0x1(%eax),%edx
  802283:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80228c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80228f:	8a 12                	mov    (%edx),%dl
  802291:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802293:	8b 45 10             	mov    0x10(%ebp),%eax
  802296:	8d 50 ff             	lea    -0x1(%eax),%edx
  802299:	89 55 10             	mov    %edx,0x10(%ebp)
  80229c:	85 c0                	test   %eax,%eax
  80229e:	75 dd                	jne    80227d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8022ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8022b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022bd:	73 50                	jae    80230f <memmove+0x6a>
  8022bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c5:	01 d0                	add    %edx,%eax
  8022c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022ca:	76 43                	jbe    80230f <memmove+0x6a>
		s += n;
  8022cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8022d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8022d8:	eb 10                	jmp    8022ea <memmove+0x45>
			*--d = *--s;
  8022da:	ff 4d f8             	decl   -0x8(%ebp)
  8022dd:	ff 4d fc             	decl   -0x4(%ebp)
  8022e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e3:	8a 10                	mov    (%eax),%dl
  8022e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022e8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8022ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	75 e3                	jne    8022da <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8022f7:	eb 23                	jmp    80231c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8022f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022fc:	8d 50 01             	lea    0x1(%eax),%edx
  8022ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802305:	8d 4a 01             	lea    0x1(%edx),%ecx
  802308:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80230b:	8a 12                	mov    (%edx),%dl
  80230d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80230f:	8b 45 10             	mov    0x10(%ebp),%eax
  802312:	8d 50 ff             	lea    -0x1(%eax),%edx
  802315:	89 55 10             	mov    %edx,0x10(%ebp)
  802318:	85 c0                	test   %eax,%eax
  80231a:	75 dd                	jne    8022f9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802333:	eb 2a                	jmp    80235f <memcmp+0x3e>
		if (*s1 != *s2)
  802335:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802338:	8a 10                	mov    (%eax),%dl
  80233a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80233d:	8a 00                	mov    (%eax),%al
  80233f:	38 c2                	cmp    %al,%dl
  802341:	74 16                	je     802359 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802346:	8a 00                	mov    (%eax),%al
  802348:	0f b6 d0             	movzbl %al,%edx
  80234b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80234e:	8a 00                	mov    (%eax),%al
  802350:	0f b6 c0             	movzbl %al,%eax
  802353:	29 c2                	sub    %eax,%edx
  802355:	89 d0                	mov    %edx,%eax
  802357:	eb 18                	jmp    802371 <memcmp+0x50>
		s1++, s2++;
  802359:	ff 45 fc             	incl   -0x4(%ebp)
  80235c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80235f:	8b 45 10             	mov    0x10(%ebp),%eax
  802362:	8d 50 ff             	lea    -0x1(%eax),%edx
  802365:	89 55 10             	mov    %edx,0x10(%ebp)
  802368:	85 c0                	test   %eax,%eax
  80236a:	75 c9                	jne    802335 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802379:	8b 55 08             	mov    0x8(%ebp),%edx
  80237c:	8b 45 10             	mov    0x10(%ebp),%eax
  80237f:	01 d0                	add    %edx,%eax
  802381:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802384:	eb 15                	jmp    80239b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	8a 00                	mov    (%eax),%al
  80238b:	0f b6 d0             	movzbl %al,%edx
  80238e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802391:	0f b6 c0             	movzbl %al,%eax
  802394:	39 c2                	cmp    %eax,%edx
  802396:	74 0d                	je     8023a5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802398:	ff 45 08             	incl   0x8(%ebp)
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8023a1:	72 e3                	jb     802386 <memfind+0x13>
  8023a3:	eb 01                	jmp    8023a6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8023a5:	90                   	nop
	return (void *) s;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8023b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8023b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023bf:	eb 03                	jmp    8023c4 <strtol+0x19>
		s++;
  8023c1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	3c 20                	cmp    $0x20,%al
  8023cb:	74 f4                	je     8023c1 <strtol+0x16>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	3c 09                	cmp    $0x9,%al
  8023d4:	74 eb                	je     8023c1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	8a 00                	mov    (%eax),%al
  8023db:	3c 2b                	cmp    $0x2b,%al
  8023dd:	75 05                	jne    8023e4 <strtol+0x39>
		s++;
  8023df:	ff 45 08             	incl   0x8(%ebp)
  8023e2:	eb 13                	jmp    8023f7 <strtol+0x4c>
	else if (*s == '-')
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	8a 00                	mov    (%eax),%al
  8023e9:	3c 2d                	cmp    $0x2d,%al
  8023eb:	75 0a                	jne    8023f7 <strtol+0x4c>
		s++, neg = 1;
  8023ed:	ff 45 08             	incl   0x8(%ebp)
  8023f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023fb:	74 06                	je     802403 <strtol+0x58>
  8023fd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802401:	75 20                	jne    802423 <strtol+0x78>
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	8a 00                	mov    (%eax),%al
  802408:	3c 30                	cmp    $0x30,%al
  80240a:	75 17                	jne    802423 <strtol+0x78>
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	40                   	inc    %eax
  802410:	8a 00                	mov    (%eax),%al
  802412:	3c 78                	cmp    $0x78,%al
  802414:	75 0d                	jne    802423 <strtol+0x78>
		s += 2, base = 16;
  802416:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80241a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802421:	eb 28                	jmp    80244b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802423:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802427:	75 15                	jne    80243e <strtol+0x93>
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	8a 00                	mov    (%eax),%al
  80242e:	3c 30                	cmp    $0x30,%al
  802430:	75 0c                	jne    80243e <strtol+0x93>
		s++, base = 8;
  802432:	ff 45 08             	incl   0x8(%ebp)
  802435:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80243c:	eb 0d                	jmp    80244b <strtol+0xa0>
	else if (base == 0)
  80243e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802442:	75 07                	jne    80244b <strtol+0xa0>
		base = 10;
  802444:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	8a 00                	mov    (%eax),%al
  802450:	3c 2f                	cmp    $0x2f,%al
  802452:	7e 19                	jle    80246d <strtol+0xc2>
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	8a 00                	mov    (%eax),%al
  802459:	3c 39                	cmp    $0x39,%al
  80245b:	7f 10                	jg     80246d <strtol+0xc2>
			dig = *s - '0';
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	8a 00                	mov    (%eax),%al
  802462:	0f be c0             	movsbl %al,%eax
  802465:	83 e8 30             	sub    $0x30,%eax
  802468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246b:	eb 42                	jmp    8024af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	8a 00                	mov    (%eax),%al
  802472:	3c 60                	cmp    $0x60,%al
  802474:	7e 19                	jle    80248f <strtol+0xe4>
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	8a 00                	mov    (%eax),%al
  80247b:	3c 7a                	cmp    $0x7a,%al
  80247d:	7f 10                	jg     80248f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	8a 00                	mov    (%eax),%al
  802484:	0f be c0             	movsbl %al,%eax
  802487:	83 e8 57             	sub    $0x57,%eax
  80248a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248d:	eb 20                	jmp    8024af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	8a 00                	mov    (%eax),%al
  802494:	3c 40                	cmp    $0x40,%al
  802496:	7e 39                	jle    8024d1 <strtol+0x126>
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	8a 00                	mov    (%eax),%al
  80249d:	3c 5a                	cmp    $0x5a,%al
  80249f:	7f 30                	jg     8024d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	8a 00                	mov    (%eax),%al
  8024a6:	0f be c0             	movsbl %al,%eax
  8024a9:	83 e8 37             	sub    $0x37,%eax
  8024ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8024b5:	7d 19                	jge    8024d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8024b7:	ff 45 08             	incl   0x8(%ebp)
  8024ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8024c1:	89 c2                	mov    %eax,%edx
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	01 d0                	add    %edx,%eax
  8024c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8024cb:	e9 7b ff ff ff       	jmp    80244b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8024d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8024d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024d5:	74 08                	je     8024df <strtol+0x134>
		*endptr = (char *) s;
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	8b 55 08             	mov    0x8(%ebp),%edx
  8024dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8024df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024e3:	74 07                	je     8024ec <strtol+0x141>
  8024e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e8:	f7 d8                	neg    %eax
  8024ea:	eb 03                	jmp    8024ef <strtol+0x144>
  8024ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8024f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8024fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802509:	79 13                	jns    80251e <ltostr+0x2d>
	{
		neg = 1;
  80250b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802512:	8b 45 0c             	mov    0xc(%ebp),%eax
  802515:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802518:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80251b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802526:	99                   	cltd   
  802527:	f7 f9                	idiv   %ecx
  802529:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80252c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80252f:	8d 50 01             	lea    0x1(%eax),%edx
  802532:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802535:	89 c2                	mov    %eax,%edx
  802537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253a:	01 d0                	add    %edx,%eax
  80253c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80253f:	83 c2 30             	add    $0x30,%edx
  802542:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802544:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802547:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80254c:	f7 e9                	imul   %ecx
  80254e:	c1 fa 02             	sar    $0x2,%edx
  802551:	89 c8                	mov    %ecx,%eax
  802553:	c1 f8 1f             	sar    $0x1f,%eax
  802556:	29 c2                	sub    %eax,%edx
  802558:	89 d0                	mov    %edx,%eax
  80255a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80255d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802561:	75 bb                	jne    80251e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802563:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80256a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80256d:	48                   	dec    %eax
  80256e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802571:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802575:	74 3d                	je     8025b4 <ltostr+0xc3>
		start = 1 ;
  802577:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80257e:	eb 34                	jmp    8025b4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802580:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802583:	8b 45 0c             	mov    0xc(%ebp),%eax
  802586:	01 d0                	add    %edx,%eax
  802588:	8a 00                	mov    (%eax),%al
  80258a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80258d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802590:	8b 45 0c             	mov    0xc(%ebp),%eax
  802593:	01 c2                	add    %eax,%edx
  802595:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259b:	01 c8                	add    %ecx,%eax
  80259d:	8a 00                	mov    (%eax),%al
  80259f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8025a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a7:	01 c2                	add    %eax,%edx
  8025a9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8025ac:	88 02                	mov    %al,(%edx)
		start++ ;
  8025ae:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8025b1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025ba:	7c c4                	jl     802580 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8025bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8025bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c2:	01 d0                	add    %edx,%eax
  8025c4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8025c7:	90                   	nop
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8025d0:	ff 75 08             	pushl  0x8(%ebp)
  8025d3:	e8 c4 f9 ff ff       	call   801f9c <strlen>
  8025d8:	83 c4 04             	add    $0x4,%esp
  8025db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8025de:	ff 75 0c             	pushl  0xc(%ebp)
  8025e1:	e8 b6 f9 ff ff       	call   801f9c <strlen>
  8025e6:	83 c4 04             	add    $0x4,%esp
  8025e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8025ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8025f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025fa:	eb 17                	jmp    802613 <strcconcat+0x49>
		final[s] = str1[s] ;
  8025fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802602:	01 c2                	add    %eax,%edx
  802604:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	01 c8                	add    %ecx,%eax
  80260c:	8a 00                	mov    (%eax),%al
  80260e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802610:	ff 45 fc             	incl   -0x4(%ebp)
  802613:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802616:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802619:	7c e1                	jl     8025fc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80261b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802622:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802629:	eb 1f                	jmp    80264a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80262b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80262e:	8d 50 01             	lea    0x1(%eax),%edx
  802631:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802634:	89 c2                	mov    %eax,%edx
  802636:	8b 45 10             	mov    0x10(%ebp),%eax
  802639:	01 c2                	add    %eax,%edx
  80263b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80263e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802641:	01 c8                	add    %ecx,%eax
  802643:	8a 00                	mov    (%eax),%al
  802645:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802647:	ff 45 f8             	incl   -0x8(%ebp)
  80264a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80264d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802650:	7c d9                	jl     80262b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802652:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802655:	8b 45 10             	mov    0x10(%ebp),%eax
  802658:	01 d0                	add    %edx,%eax
  80265a:	c6 00 00             	movb   $0x0,(%eax)
}
  80265d:	90                   	nop
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802663:	8b 45 14             	mov    0x14(%ebp),%eax
  802666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80266c:	8b 45 14             	mov    0x14(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802678:	8b 45 10             	mov    0x10(%ebp),%eax
  80267b:	01 d0                	add    %edx,%eax
  80267d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802683:	eb 0c                	jmp    802691 <strsplit+0x31>
			*string++ = 0;
  802685:	8b 45 08             	mov    0x8(%ebp),%eax
  802688:	8d 50 01             	lea    0x1(%eax),%edx
  80268b:	89 55 08             	mov    %edx,0x8(%ebp)
  80268e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	8a 00                	mov    (%eax),%al
  802696:	84 c0                	test   %al,%al
  802698:	74 18                	je     8026b2 <strsplit+0x52>
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	8a 00                	mov    (%eax),%al
  80269f:	0f be c0             	movsbl %al,%eax
  8026a2:	50                   	push   %eax
  8026a3:	ff 75 0c             	pushl  0xc(%ebp)
  8026a6:	e8 83 fa ff ff       	call   80212e <strchr>
  8026ab:	83 c4 08             	add    $0x8,%esp
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	75 d3                	jne    802685 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8026b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b5:	8a 00                	mov    (%eax),%al
  8026b7:	84 c0                	test   %al,%al
  8026b9:	74 5a                	je     802715 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8026bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	83 f8 0f             	cmp    $0xf,%eax
  8026c3:	75 07                	jne    8026cc <strsplit+0x6c>
		{
			return 0;
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ca:	eb 66                	jmp    802732 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8026cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	8d 48 01             	lea    0x1(%eax),%ecx
  8026d4:	8b 55 14             	mov    0x14(%ebp),%edx
  8026d7:	89 0a                	mov    %ecx,(%edx)
  8026d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026e3:	01 c2                	add    %eax,%edx
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026ea:	eb 03                	jmp    8026ef <strsplit+0x8f>
			string++;
  8026ec:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	8a 00                	mov    (%eax),%al
  8026f4:	84 c0                	test   %al,%al
  8026f6:	74 8b                	je     802683 <strsplit+0x23>
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	8a 00                	mov    (%eax),%al
  8026fd:	0f be c0             	movsbl %al,%eax
  802700:	50                   	push   %eax
  802701:	ff 75 0c             	pushl  0xc(%ebp)
  802704:	e8 25 fa ff ff       	call   80212e <strchr>
  802709:	83 c4 08             	add    $0x8,%esp
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 dc                	je     8026ec <strsplit+0x8c>
			string++;
	}
  802710:	e9 6e ff ff ff       	jmp    802683 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802715:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802716:	8b 45 14             	mov    0x14(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802722:	8b 45 10             	mov    0x10(%ebp),%eax
  802725:	01 d0                	add    %edx,%eax
  802727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80272d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
  802737:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802740:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802747:	eb 4a                	jmp    802793 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802749:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	01 c2                	add    %eax,%edx
  802751:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802754:	8b 45 0c             	mov    0xc(%ebp),%eax
  802757:	01 c8                	add    %ecx,%eax
  802759:	8a 00                	mov    (%eax),%al
  80275b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80275d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802760:	8b 45 0c             	mov    0xc(%ebp),%eax
  802763:	01 d0                	add    %edx,%eax
  802765:	8a 00                	mov    (%eax),%al
  802767:	3c 40                	cmp    $0x40,%al
  802769:	7e 25                	jle    802790 <str2lower+0x5c>
  80276b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80276e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802771:	01 d0                	add    %edx,%eax
  802773:	8a 00                	mov    (%eax),%al
  802775:	3c 5a                	cmp    $0x5a,%al
  802777:	7f 17                	jg     802790 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802779:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	01 d0                	add    %edx,%eax
  802781:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802784:	8b 55 08             	mov    0x8(%ebp),%edx
  802787:	01 ca                	add    %ecx,%edx
  802789:	8a 12                	mov    (%edx),%dl
  80278b:	83 c2 20             	add    $0x20,%edx
  80278e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802790:	ff 45 fc             	incl   -0x4(%ebp)
  802793:	ff 75 0c             	pushl  0xc(%ebp)
  802796:	e8 01 f8 ff ff       	call   801f9c <strlen>
  80279b:	83 c4 04             	add    $0x4,%esp
  80279e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8027a1:	7f a6                	jg     802749 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8027a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
  8027ab:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8027ae:	a1 08 50 80 00       	mov    0x805008,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	74 42                	je     8027f9 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8027b7:	83 ec 08             	sub    $0x8,%esp
  8027ba:	68 00 00 00 82       	push   $0x82000000
  8027bf:	68 00 00 00 80       	push   $0x80000000
  8027c4:	e8 00 08 00 00       	call   802fc9 <initialize_dynamic_allocator>
  8027c9:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8027cc:	e8 e7 05 00 00       	call   802db8 <sys_get_uheap_strategy>
  8027d1:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8027d6:	a1 20 52 80 00       	mov    0x805220,%eax
  8027db:	05 00 10 00 00       	add    $0x1000,%eax
  8027e0:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8027e5:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  8027ea:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  8027ef:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8027f6:	00 00 00 
	}
}
  8027f9:	90                   	nop
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802810:	83 ec 08             	sub    $0x8,%esp
  802813:	68 06 04 00 00       	push   $0x406
  802818:	50                   	push   %eax
  802819:	e8 e4 01 00 00       	call   802a02 <__sys_allocate_page>
  80281e:	83 c4 10             	add    $0x10,%esp
  802821:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802828:	79 14                	jns    80283e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 68 49 80 00       	push   $0x804968
  802832:	6a 1f                	push   $0x1f
  802834:	68 a4 49 80 00       	push   $0x8049a4
  802839:	e8 b7 ed ff ff       	call   8015f5 <_panic>
	return 0;
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802843:	c9                   	leave  
  802844:	c3                   	ret    

00802845 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
  802848:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802859:	83 ec 0c             	sub    $0xc,%esp
  80285c:	50                   	push   %eax
  80285d:	e8 e7 01 00 00       	call   802a49 <__sys_unmap_frame>
  802862:	83 c4 10             	add    $0x10,%esp
  802865:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802868:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80286c:	79 14                	jns    802882 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80286e:	83 ec 04             	sub    $0x4,%esp
  802871:	68 b0 49 80 00       	push   $0x8049b0
  802876:	6a 2a                	push   $0x2a
  802878:	68 a4 49 80 00       	push   $0x8049a4
  80287d:	e8 73 ed ff ff       	call   8015f5 <_panic>
}
  802882:	90                   	nop
  802883:	c9                   	leave  
  802884:	c3                   	ret    

00802885 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
  802888:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80288b:	e8 18 ff ff ff       	call   8027a8 <uheap_init>
	if (size == 0) return NULL ;
  802890:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802894:	75 07                	jne    80289d <malloc+0x18>
  802896:	b8 00 00 00 00       	mov    $0x0,%eax
  80289b:	eb 14                	jmp    8028b1 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	68 f0 49 80 00       	push   $0x8049f0
  8028a5:	6a 3e                	push   $0x3e
  8028a7:	68 a4 49 80 00       	push   $0x8049a4
  8028ac:	e8 44 ed ff ff       	call   8015f5 <_panic>
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	68 18 4a 80 00       	push   $0x804a18
  8028c1:	6a 49                	push   $0x49
  8028c3:	68 a4 49 80 00       	push   $0x8049a4
  8028c8:	e8 28 ed ff ff       	call   8015f5 <_panic>

008028cd <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
  8028d0:	83 ec 18             	sub    $0x18,%esp
  8028d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d6:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028d9:	e8 ca fe ff ff       	call   8027a8 <uheap_init>
	if (size == 0) return NULL ;
  8028de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028e2:	75 07                	jne    8028eb <smalloc+0x1e>
  8028e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e9:	eb 14                	jmp    8028ff <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8028eb:	83 ec 04             	sub    $0x4,%esp
  8028ee:	68 3c 4a 80 00       	push   $0x804a3c
  8028f3:	6a 5a                	push   $0x5a
  8028f5:	68 a4 49 80 00       	push   $0x8049a4
  8028fa:	e8 f6 ec ff ff       	call   8015f5 <_panic>
}
  8028ff:	c9                   	leave  
  802900:	c3                   	ret    

00802901 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802901:	55                   	push   %ebp
  802902:	89 e5                	mov    %esp,%ebp
  802904:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802907:	e8 9c fe ff ff       	call   8027a8 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80290c:	83 ec 04             	sub    $0x4,%esp
  80290f:	68 64 4a 80 00       	push   $0x804a64
  802914:	6a 6a                	push   $0x6a
  802916:	68 a4 49 80 00       	push   $0x8049a4
  80291b:	e8 d5 ec ff ff       	call   8015f5 <_panic>

00802920 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802926:	e8 7d fe ff ff       	call   8027a8 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80292b:	83 ec 04             	sub    $0x4,%esp
  80292e:	68 88 4a 80 00       	push   $0x804a88
  802933:	68 88 00 00 00       	push   $0x88
  802938:	68 a4 49 80 00       	push   $0x8049a4
  80293d:	e8 b3 ec ff ff       	call   8015f5 <_panic>

00802942 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
  802945:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802948:	83 ec 04             	sub    $0x4,%esp
  80294b:	68 b0 4a 80 00       	push   $0x804ab0
  802950:	68 9b 00 00 00       	push   $0x9b
  802955:	68 a4 49 80 00       	push   $0x8049a4
  80295a:	e8 96 ec ff ff       	call   8015f5 <_panic>

0080295f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	57                   	push   %edi
  802963:	56                   	push   %esi
  802964:	53                   	push   %ebx
  802965:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80296e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802971:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802974:	8b 7d 18             	mov    0x18(%ebp),%edi
  802977:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80297a:	cd 30                	int    $0x30
  80297c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80297f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802982:	83 c4 10             	add    $0x10,%esp
  802985:	5b                   	pop    %ebx
  802986:	5e                   	pop    %esi
  802987:	5f                   	pop    %edi
  802988:	5d                   	pop    %ebp
  802989:	c3                   	ret    

0080298a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	83 ec 04             	sub    $0x4,%esp
  802990:	8b 45 10             	mov    0x10(%ebp),%eax
  802993:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802996:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802999:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80299d:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a0:	6a 00                	push   $0x0
  8029a2:	51                   	push   %ecx
  8029a3:	52                   	push   %edx
  8029a4:	ff 75 0c             	pushl  0xc(%ebp)
  8029a7:	50                   	push   %eax
  8029a8:	6a 00                	push   $0x0
  8029aa:	e8 b0 ff ff ff       	call   80295f <syscall>
  8029af:	83 c4 18             	add    $0x18,%esp
}
  8029b2:	90                   	nop
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 02                	push   $0x2
  8029c4:	e8 96 ff ff ff       	call   80295f <syscall>
  8029c9:	83 c4 18             	add    $0x18,%esp
}
  8029cc:	c9                   	leave  
  8029cd:	c3                   	ret    

008029ce <sys_lock_cons>:

void sys_lock_cons(void)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	6a 00                	push   $0x0
  8029db:	6a 03                	push   $0x3
  8029dd:	e8 7d ff ff ff       	call   80295f <syscall>
  8029e2:	83 c4 18             	add    $0x18,%esp
}
  8029e5:	90                   	nop
  8029e6:	c9                   	leave  
  8029e7:	c3                   	ret    

008029e8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8029e8:	55                   	push   %ebp
  8029e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 04                	push   $0x4
  8029f7:	e8 63 ff ff ff       	call   80295f <syscall>
  8029fc:	83 c4 18             	add    $0x18,%esp
}
  8029ff:	90                   	nop
  802a00:	c9                   	leave  
  802a01:	c3                   	ret    

00802a02 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a02:	55                   	push   %ebp
  802a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	6a 00                	push   $0x0
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	52                   	push   %edx
  802a12:	50                   	push   %eax
  802a13:	6a 08                	push   $0x8
  802a15:	e8 45 ff ff ff       	call   80295f <syscall>
  802a1a:	83 c4 18             	add    $0x18,%esp
}
  802a1d:	c9                   	leave  
  802a1e:	c3                   	ret    

00802a1f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a1f:	55                   	push   %ebp
  802a20:	89 e5                	mov    %esp,%ebp
  802a22:	56                   	push   %esi
  802a23:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a24:	8b 75 18             	mov    0x18(%ebp),%esi
  802a27:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	56                   	push   %esi
  802a34:	53                   	push   %ebx
  802a35:	51                   	push   %ecx
  802a36:	52                   	push   %edx
  802a37:	50                   	push   %eax
  802a38:	6a 09                	push   $0x9
  802a3a:	e8 20 ff ff ff       	call   80295f <syscall>
  802a3f:	83 c4 18             	add    $0x18,%esp
}
  802a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a45:	5b                   	pop    %ebx
  802a46:	5e                   	pop    %esi
  802a47:	5d                   	pop    %ebp
  802a48:	c3                   	ret    

00802a49 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802a49:	55                   	push   %ebp
  802a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 00                	push   $0x0
  802a52:	6a 00                	push   $0x0
  802a54:	ff 75 08             	pushl  0x8(%ebp)
  802a57:	6a 0a                	push   $0xa
  802a59:	e8 01 ff ff ff       	call   80295f <syscall>
  802a5e:	83 c4 18             	add    $0x18,%esp
}
  802a61:	c9                   	leave  
  802a62:	c3                   	ret    

00802a63 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a63:	55                   	push   %ebp
  802a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 00                	push   $0x0
  802a6c:	ff 75 0c             	pushl  0xc(%ebp)
  802a6f:	ff 75 08             	pushl  0x8(%ebp)
  802a72:	6a 0b                	push   $0xb
  802a74:	e8 e6 fe ff ff       	call   80295f <syscall>
  802a79:	83 c4 18             	add    $0x18,%esp
}
  802a7c:	c9                   	leave  
  802a7d:	c3                   	ret    

00802a7e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a7e:	55                   	push   %ebp
  802a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a81:	6a 00                	push   $0x0
  802a83:	6a 00                	push   $0x0
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	6a 00                	push   $0x0
  802a8b:	6a 0c                	push   $0xc
  802a8d:	e8 cd fe ff ff       	call   80295f <syscall>
  802a92:	83 c4 18             	add    $0x18,%esp
}
  802a95:	c9                   	leave  
  802a96:	c3                   	ret    

00802a97 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a97:	55                   	push   %ebp
  802a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	6a 00                	push   $0x0
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 0d                	push   $0xd
  802aa6:	e8 b4 fe ff ff       	call   80295f <syscall>
  802aab:	83 c4 18             	add    $0x18,%esp
}
  802aae:	c9                   	leave  
  802aaf:	c3                   	ret    

00802ab0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ab3:	6a 00                	push   $0x0
  802ab5:	6a 00                	push   $0x0
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 0e                	push   $0xe
  802abf:	e8 9b fe ff ff       	call   80295f <syscall>
  802ac4:	83 c4 18             	add    $0x18,%esp
}
  802ac7:	c9                   	leave  
  802ac8:	c3                   	ret    

00802ac9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ac9:	55                   	push   %ebp
  802aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802acc:	6a 00                	push   $0x0
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 0f                	push   $0xf
  802ad8:	e8 82 fe ff ff       	call   80295f <syscall>
  802add:	83 c4 18             	add    $0x18,%esp
}
  802ae0:	c9                   	leave  
  802ae1:	c3                   	ret    

00802ae2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 00                	push   $0x0
  802aeb:	6a 00                	push   $0x0
  802aed:	ff 75 08             	pushl  0x8(%ebp)
  802af0:	6a 10                	push   $0x10
  802af2:	e8 68 fe ff ff       	call   80295f <syscall>
  802af7:	83 c4 18             	add    $0x18,%esp
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_scarce_memory>:

void sys_scarce_memory()
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	6a 11                	push   $0x11
  802b0b:	e8 4f fe ff ff       	call   80295f <syscall>
  802b10:	83 c4 18             	add    $0x18,%esp
}
  802b13:	90                   	nop
  802b14:	c9                   	leave  
  802b15:	c3                   	ret    

00802b16 <sys_cputc>:

void
sys_cputc(const char c)
{
  802b16:	55                   	push   %ebp
  802b17:	89 e5                	mov    %esp,%ebp
  802b19:	83 ec 04             	sub    $0x4,%esp
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802b22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	6a 00                	push   $0x0
  802b2c:	6a 00                	push   $0x0
  802b2e:	50                   	push   %eax
  802b2f:	6a 01                	push   $0x1
  802b31:	e8 29 fe ff ff       	call   80295f <syscall>
  802b36:	83 c4 18             	add    $0x18,%esp
}
  802b39:	90                   	nop
  802b3a:	c9                   	leave  
  802b3b:	c3                   	ret    

00802b3c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 14                	push   $0x14
  802b4b:	e8 0f fe ff ff       	call   80295f <syscall>
  802b50:	83 c4 18             	add    $0x18,%esp
}
  802b53:	90                   	nop
  802b54:	c9                   	leave  
  802b55:	c3                   	ret    

00802b56 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  802b5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802b62:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b65:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	6a 00                	push   $0x0
  802b6e:	51                   	push   %ecx
  802b6f:	52                   	push   %edx
  802b70:	ff 75 0c             	pushl  0xc(%ebp)
  802b73:	50                   	push   %eax
  802b74:	6a 15                	push   $0x15
  802b76:	e8 e4 fd ff ff       	call   80295f <syscall>
  802b7b:	83 c4 18             	add    $0x18,%esp
}
  802b7e:	c9                   	leave  
  802b7f:	c3                   	ret    

00802b80 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802b80:	55                   	push   %ebp
  802b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 00                	push   $0x0
  802b8f:	52                   	push   %edx
  802b90:	50                   	push   %eax
  802b91:	6a 16                	push   $0x16
  802b93:	e8 c7 fd ff ff       	call   80295f <syscall>
  802b98:	83 c4 18             	add    $0x18,%esp
}
  802b9b:	c9                   	leave  
  802b9c:	c3                   	ret    

00802b9d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802ba0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	6a 00                	push   $0x0
  802bab:	6a 00                	push   $0x0
  802bad:	51                   	push   %ecx
  802bae:	52                   	push   %edx
  802baf:	50                   	push   %eax
  802bb0:	6a 17                	push   $0x17
  802bb2:	e8 a8 fd ff ff       	call   80295f <syscall>
  802bb7:	83 c4 18             	add    $0x18,%esp
}
  802bba:	c9                   	leave  
  802bbb:	c3                   	ret    

00802bbc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802bbc:	55                   	push   %ebp
  802bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 00                	push   $0x0
  802bcb:	52                   	push   %edx
  802bcc:	50                   	push   %eax
  802bcd:	6a 18                	push   $0x18
  802bcf:	e8 8b fd ff ff       	call   80295f <syscall>
  802bd4:	83 c4 18             	add    $0x18,%esp
}
  802bd7:	c9                   	leave  
  802bd8:	c3                   	ret    

00802bd9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802bd9:	55                   	push   %ebp
  802bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	6a 00                	push   $0x0
  802be1:	ff 75 14             	pushl  0x14(%ebp)
  802be4:	ff 75 10             	pushl  0x10(%ebp)
  802be7:	ff 75 0c             	pushl  0xc(%ebp)
  802bea:	50                   	push   %eax
  802beb:	6a 19                	push   $0x19
  802bed:	e8 6d fd ff ff       	call   80295f <syscall>
  802bf2:	83 c4 18             	add    $0x18,%esp
}
  802bf5:	c9                   	leave  
  802bf6:	c3                   	ret    

00802bf7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 00                	push   $0x0
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	50                   	push   %eax
  802c06:	6a 1a                	push   $0x1a
  802c08:	e8 52 fd ff ff       	call   80295f <syscall>
  802c0d:	83 c4 18             	add    $0x18,%esp
}
  802c10:	90                   	nop
  802c11:	c9                   	leave  
  802c12:	c3                   	ret    

00802c13 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802c13:	55                   	push   %ebp
  802c14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	6a 00                	push   $0x0
  802c1b:	6a 00                	push   $0x0
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	50                   	push   %eax
  802c22:	6a 1b                	push   $0x1b
  802c24:	e8 36 fd ff ff       	call   80295f <syscall>
  802c29:	83 c4 18             	add    $0x18,%esp
}
  802c2c:	c9                   	leave  
  802c2d:	c3                   	ret    

00802c2e <sys_getenvid>:

int32 sys_getenvid(void)
{
  802c2e:	55                   	push   %ebp
  802c2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802c31:	6a 00                	push   $0x0
  802c33:	6a 00                	push   $0x0
  802c35:	6a 00                	push   $0x0
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 05                	push   $0x5
  802c3d:	e8 1d fd ff ff       	call   80295f <syscall>
  802c42:	83 c4 18             	add    $0x18,%esp
}
  802c45:	c9                   	leave  
  802c46:	c3                   	ret    

00802c47 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802c47:	55                   	push   %ebp
  802c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802c4a:	6a 00                	push   $0x0
  802c4c:	6a 00                	push   $0x0
  802c4e:	6a 00                	push   $0x0
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 06                	push   $0x6
  802c56:	e8 04 fd ff ff       	call   80295f <syscall>
  802c5b:	83 c4 18             	add    $0x18,%esp
}
  802c5e:	c9                   	leave  
  802c5f:	c3                   	ret    

00802c60 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802c60:	55                   	push   %ebp
  802c61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802c63:	6a 00                	push   $0x0
  802c65:	6a 00                	push   $0x0
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 07                	push   $0x7
  802c6f:	e8 eb fc ff ff       	call   80295f <syscall>
  802c74:	83 c4 18             	add    $0x18,%esp
}
  802c77:	c9                   	leave  
  802c78:	c3                   	ret    

00802c79 <sys_exit_env>:


void sys_exit_env(void)
{
  802c79:	55                   	push   %ebp
  802c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 1c                	push   $0x1c
  802c88:	e8 d2 fc ff ff       	call   80295f <syscall>
  802c8d:	83 c4 18             	add    $0x18,%esp
}
  802c90:	90                   	nop
  802c91:	c9                   	leave  
  802c92:	c3                   	ret    

00802c93 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
  802c96:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c99:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c9c:	8d 50 04             	lea    0x4(%eax),%edx
  802c9f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ca2:	6a 00                	push   $0x0
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	52                   	push   %edx
  802ca9:	50                   	push   %eax
  802caa:	6a 1d                	push   $0x1d
  802cac:	e8 ae fc ff ff       	call   80295f <syscall>
  802cb1:	83 c4 18             	add    $0x18,%esp
	return result;
  802cb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802cba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802cbd:	89 01                	mov    %eax,(%ecx)
  802cbf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	c9                   	leave  
  802cc6:	c2 04 00             	ret    $0x4

00802cc9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802ccc:	6a 00                	push   $0x0
  802cce:	6a 00                	push   $0x0
  802cd0:	ff 75 10             	pushl  0x10(%ebp)
  802cd3:	ff 75 0c             	pushl  0xc(%ebp)
  802cd6:	ff 75 08             	pushl  0x8(%ebp)
  802cd9:	6a 13                	push   $0x13
  802cdb:	e8 7f fc ff ff       	call   80295f <syscall>
  802ce0:	83 c4 18             	add    $0x18,%esp
	return ;
  802ce3:	90                   	nop
}
  802ce4:	c9                   	leave  
  802ce5:	c3                   	ret    

00802ce6 <sys_rcr2>:
uint32 sys_rcr2()
{
  802ce6:	55                   	push   %ebp
  802ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 1e                	push   $0x1e
  802cf5:	e8 65 fc ff ff       	call   80295f <syscall>
  802cfa:	83 c4 18             	add    $0x18,%esp
}
  802cfd:	c9                   	leave  
  802cfe:	c3                   	ret    

00802cff <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802cff:	55                   	push   %ebp
  802d00:	89 e5                	mov    %esp,%ebp
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802d0b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 00                	push   $0x0
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	50                   	push   %eax
  802d18:	6a 1f                	push   $0x1f
  802d1a:	e8 40 fc ff ff       	call   80295f <syscall>
  802d1f:	83 c4 18             	add    $0x18,%esp
	return ;
  802d22:	90                   	nop
}
  802d23:	c9                   	leave  
  802d24:	c3                   	ret    

00802d25 <rsttst>:
void rsttst()
{
  802d25:	55                   	push   %ebp
  802d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802d28:	6a 00                	push   $0x0
  802d2a:	6a 00                	push   $0x0
  802d2c:	6a 00                	push   $0x0
  802d2e:	6a 00                	push   $0x0
  802d30:	6a 00                	push   $0x0
  802d32:	6a 21                	push   $0x21
  802d34:	e8 26 fc ff ff       	call   80295f <syscall>
  802d39:	83 c4 18             	add    $0x18,%esp
	return ;
  802d3c:	90                   	nop
}
  802d3d:	c9                   	leave  
  802d3e:	c3                   	ret    

00802d3f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802d3f:	55                   	push   %ebp
  802d40:	89 e5                	mov    %esp,%ebp
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	8b 45 14             	mov    0x14(%ebp),%eax
  802d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802d4b:	8b 55 18             	mov    0x18(%ebp),%edx
  802d4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d52:	52                   	push   %edx
  802d53:	50                   	push   %eax
  802d54:	ff 75 10             	pushl  0x10(%ebp)
  802d57:	ff 75 0c             	pushl  0xc(%ebp)
  802d5a:	ff 75 08             	pushl  0x8(%ebp)
  802d5d:	6a 20                	push   $0x20
  802d5f:	e8 fb fb ff ff       	call   80295f <syscall>
  802d64:	83 c4 18             	add    $0x18,%esp
	return ;
  802d67:	90                   	nop
}
  802d68:	c9                   	leave  
  802d69:	c3                   	ret    

00802d6a <chktst>:
void chktst(uint32 n)
{
  802d6a:	55                   	push   %ebp
  802d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 00                	push   $0x0
  802d71:	6a 00                	push   $0x0
  802d73:	6a 00                	push   $0x0
  802d75:	ff 75 08             	pushl  0x8(%ebp)
  802d78:	6a 22                	push   $0x22
  802d7a:	e8 e0 fb ff ff       	call   80295f <syscall>
  802d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  802d82:	90                   	nop
}
  802d83:	c9                   	leave  
  802d84:	c3                   	ret    

00802d85 <inctst>:

void inctst()
{
  802d85:	55                   	push   %ebp
  802d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 00                	push   $0x0
  802d8e:	6a 00                	push   $0x0
  802d90:	6a 00                	push   $0x0
  802d92:	6a 23                	push   $0x23
  802d94:	e8 c6 fb ff ff       	call   80295f <syscall>
  802d99:	83 c4 18             	add    $0x18,%esp
	return ;
  802d9c:	90                   	nop
}
  802d9d:	c9                   	leave  
  802d9e:	c3                   	ret    

00802d9f <gettst>:
uint32 gettst()
{
  802d9f:	55                   	push   %ebp
  802da0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802da2:	6a 00                	push   $0x0
  802da4:	6a 00                	push   $0x0
  802da6:	6a 00                	push   $0x0
  802da8:	6a 00                	push   $0x0
  802daa:	6a 00                	push   $0x0
  802dac:	6a 24                	push   $0x24
  802dae:	e8 ac fb ff ff       	call   80295f <syscall>
  802db3:	83 c4 18             	add    $0x18,%esp
}
  802db6:	c9                   	leave  
  802db7:	c3                   	ret    

00802db8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 00                	push   $0x0
  802dbf:	6a 00                	push   $0x0
  802dc1:	6a 00                	push   $0x0
  802dc3:	6a 00                	push   $0x0
  802dc5:	6a 25                	push   $0x25
  802dc7:	e8 93 fb ff ff       	call   80295f <syscall>
  802dcc:	83 c4 18             	add    $0x18,%esp
  802dcf:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802dd4:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802dd9:	c9                   	leave  
  802dda:	c3                   	ret    

00802ddb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ddb:	55                   	push   %ebp
  802ddc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	ff 75 08             	pushl  0x8(%ebp)
  802df1:	6a 26                	push   $0x26
  802df3:	e8 67 fb ff ff       	call   80295f <syscall>
  802df8:	83 c4 18             	add    $0x18,%esp
	return ;
  802dfb:	90                   	nop
}
  802dfc:	c9                   	leave  
  802dfd:	c3                   	ret    

00802dfe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802dfe:	55                   	push   %ebp
  802dff:	89 e5                	mov    %esp,%ebp
  802e01:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802e02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	6a 00                	push   $0x0
  802e10:	53                   	push   %ebx
  802e11:	51                   	push   %ecx
  802e12:	52                   	push   %edx
  802e13:	50                   	push   %eax
  802e14:	6a 27                	push   $0x27
  802e16:	e8 44 fb ff ff       	call   80295f <syscall>
  802e1b:	83 c4 18             	add    $0x18,%esp
}
  802e1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e21:	c9                   	leave  
  802e22:	c3                   	ret    

00802e23 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e23:	55                   	push   %ebp
  802e24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	52                   	push   %edx
  802e33:	50                   	push   %eax
  802e34:	6a 28                	push   $0x28
  802e36:	e8 24 fb ff ff       	call   80295f <syscall>
  802e3b:	83 c4 18             	add    $0x18,%esp
}
  802e3e:	c9                   	leave  
  802e3f:	c3                   	ret    

00802e40 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802e40:	55                   	push   %ebp
  802e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802e43:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	6a 00                	push   $0x0
  802e4e:	51                   	push   %ecx
  802e4f:	ff 75 10             	pushl  0x10(%ebp)
  802e52:	52                   	push   %edx
  802e53:	50                   	push   %eax
  802e54:	6a 29                	push   $0x29
  802e56:	e8 04 fb ff ff       	call   80295f <syscall>
  802e5b:	83 c4 18             	add    $0x18,%esp
}
  802e5e:	c9                   	leave  
  802e5f:	c3                   	ret    

00802e60 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802e60:	55                   	push   %ebp
  802e61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	ff 75 10             	pushl  0x10(%ebp)
  802e6a:	ff 75 0c             	pushl  0xc(%ebp)
  802e6d:	ff 75 08             	pushl  0x8(%ebp)
  802e70:	6a 12                	push   $0x12
  802e72:	e8 e8 fa ff ff       	call   80295f <syscall>
  802e77:	83 c4 18             	add    $0x18,%esp
	return ;
  802e7a:	90                   	nop
}
  802e7b:	c9                   	leave  
  802e7c:	c3                   	ret    

00802e7d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802e7d:	55                   	push   %ebp
  802e7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	6a 00                	push   $0x0
  802e88:	6a 00                	push   $0x0
  802e8a:	6a 00                	push   $0x0
  802e8c:	52                   	push   %edx
  802e8d:	50                   	push   %eax
  802e8e:	6a 2a                	push   $0x2a
  802e90:	e8 ca fa ff ff       	call   80295f <syscall>
  802e95:	83 c4 18             	add    $0x18,%esp
	return;
  802e98:	90                   	nop
}
  802e99:	c9                   	leave  
  802e9a:	c3                   	ret    

00802e9b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802e9b:	55                   	push   %ebp
  802e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 00                	push   $0x0
  802ea6:	6a 00                	push   $0x0
  802ea8:	6a 2b                	push   $0x2b
  802eaa:	e8 b0 fa ff ff       	call   80295f <syscall>
  802eaf:	83 c4 18             	add    $0x18,%esp
}
  802eb2:	c9                   	leave  
  802eb3:	c3                   	ret    

00802eb4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802eb4:	55                   	push   %ebp
  802eb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 00                	push   $0x0
  802ebd:	ff 75 0c             	pushl  0xc(%ebp)
  802ec0:	ff 75 08             	pushl  0x8(%ebp)
  802ec3:	6a 2d                	push   $0x2d
  802ec5:	e8 95 fa ff ff       	call   80295f <syscall>
  802eca:	83 c4 18             	add    $0x18,%esp
	return;
  802ecd:	90                   	nop
}
  802ece:	c9                   	leave  
  802ecf:	c3                   	ret    

00802ed0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ed0:	55                   	push   %ebp
  802ed1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802ed3:	6a 00                	push   $0x0
  802ed5:	6a 00                	push   $0x0
  802ed7:	6a 00                	push   $0x0
  802ed9:	ff 75 0c             	pushl  0xc(%ebp)
  802edc:	ff 75 08             	pushl  0x8(%ebp)
  802edf:	6a 2c                	push   $0x2c
  802ee1:	e8 79 fa ff ff       	call   80295f <syscall>
  802ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  802ee9:	90                   	nop
}
  802eea:	c9                   	leave  
  802eeb:	c3                   	ret    

00802eec <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	68 d4 4a 80 00       	push   $0x804ad4
  802efa:	68 25 01 00 00       	push   $0x125
  802eff:	68 07 4b 80 00       	push   $0x804b07
  802f04:	e8 ec e6 ff ff       	call   8015f5 <_panic>

00802f09 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802f09:	55                   	push   %ebp
  802f0a:	89 e5                	mov    %esp,%ebp
  802f0c:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802f0f:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802f16:	72 09                	jb     802f21 <to_page_va+0x18>
  802f18:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802f1f:	72 14                	jb     802f35 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802f21:	83 ec 04             	sub    $0x4,%esp
  802f24:	68 18 4b 80 00       	push   $0x804b18
  802f29:	6a 15                	push   $0x15
  802f2b:	68 43 4b 80 00       	push   $0x804b43
  802f30:	e8 c0 e6 ff ff       	call   8015f5 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	ba 40 52 80 00       	mov    $0x805240,%edx
  802f3d:	29 d0                	sub    %edx,%eax
  802f3f:	c1 f8 02             	sar    $0x2,%eax
  802f42:	89 c2                	mov    %eax,%edx
  802f44:	89 d0                	mov    %edx,%eax
  802f46:	c1 e0 02             	shl    $0x2,%eax
  802f49:	01 d0                	add    %edx,%eax
  802f4b:	c1 e0 02             	shl    $0x2,%eax
  802f4e:	01 d0                	add    %edx,%eax
  802f50:	c1 e0 02             	shl    $0x2,%eax
  802f53:	01 d0                	add    %edx,%eax
  802f55:	89 c1                	mov    %eax,%ecx
  802f57:	c1 e1 08             	shl    $0x8,%ecx
  802f5a:	01 c8                	add    %ecx,%eax
  802f5c:	89 c1                	mov    %eax,%ecx
  802f5e:	c1 e1 10             	shl    $0x10,%ecx
  802f61:	01 c8                	add    %ecx,%eax
  802f63:	01 c0                	add    %eax,%eax
  802f65:	01 d0                	add    %edx,%eax
  802f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	c1 e0 0c             	shl    $0xc,%eax
  802f70:	89 c2                	mov    %eax,%edx
  802f72:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802f77:	01 d0                	add    %edx,%eax
}
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
  802f7e:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802f81:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802f86:	8b 55 08             	mov    0x8(%ebp),%edx
  802f89:	29 c2                	sub    %eax,%edx
  802f8b:	89 d0                	mov    %edx,%eax
  802f8d:	c1 e8 0c             	shr    $0xc,%eax
  802f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f97:	78 09                	js     802fa2 <to_page_info+0x27>
  802f99:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802fa0:	7e 14                	jle    802fb6 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802fa2:	83 ec 04             	sub    $0x4,%esp
  802fa5:	68 5c 4b 80 00       	push   $0x804b5c
  802faa:	6a 22                	push   $0x22
  802fac:	68 43 4b 80 00       	push   $0x804b43
  802fb1:	e8 3f e6 ff ff       	call   8015f5 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb9:	89 d0                	mov    %edx,%eax
  802fbb:	01 c0                	add    %eax,%eax
  802fbd:	01 d0                	add    %edx,%eax
  802fbf:	c1 e0 02             	shl    $0x2,%eax
  802fc2:	05 40 52 80 00       	add    $0x805240,%eax
}
  802fc7:	c9                   	leave  
  802fc8:	c3                   	ret    

00802fc9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802fc9:	55                   	push   %ebp
  802fca:	89 e5                	mov    %esp,%ebp
  802fcc:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	05 00 00 00 02       	add    $0x2000000,%eax
  802fd7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fda:	73 16                	jae    802ff2 <initialize_dynamic_allocator+0x29>
  802fdc:	68 80 4b 80 00       	push   $0x804b80
  802fe1:	68 a6 4b 80 00       	push   $0x804ba6
  802fe6:	6a 34                	push   $0x34
  802fe8:	68 43 4b 80 00       	push   $0x804b43
  802fed:	e8 03 e6 ff ff       	call   8015f5 <_panic>
		is_initialized = 1;
  802ff2:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802ff9:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  803004:	8b 45 0c             	mov    0xc(%ebp),%eax
  803007:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  80300c:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  803013:	00 00 00 
  803016:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  80301d:	00 00 00 
  803020:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  803027:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  80302a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302d:	2b 45 08             	sub    0x8(%ebp),%eax
  803030:	c1 e8 0c             	shr    $0xc,%eax
  803033:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  803036:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80303d:	e9 c8 00 00 00       	jmp    80310a <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  803042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803045:	89 d0                	mov    %edx,%eax
  803047:	01 c0                	add    %eax,%eax
  803049:	01 d0                	add    %edx,%eax
  80304b:	c1 e0 02             	shl    $0x2,%eax
  80304e:	05 48 52 80 00       	add    $0x805248,%eax
  803053:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803058:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305b:	89 d0                	mov    %edx,%eax
  80305d:	01 c0                	add    %eax,%eax
  80305f:	01 d0                	add    %edx,%eax
  803061:	c1 e0 02             	shl    $0x2,%eax
  803064:	05 4a 52 80 00       	add    $0x80524a,%eax
  803069:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80306e:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803074:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803077:	89 c8                	mov    %ecx,%eax
  803079:	01 c0                	add    %eax,%eax
  80307b:	01 c8                	add    %ecx,%eax
  80307d:	c1 e0 02             	shl    $0x2,%eax
  803080:	05 44 52 80 00       	add    $0x805244,%eax
  803085:	89 10                	mov    %edx,(%eax)
  803087:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80308a:	89 d0                	mov    %edx,%eax
  80308c:	01 c0                	add    %eax,%eax
  80308e:	01 d0                	add    %edx,%eax
  803090:	c1 e0 02             	shl    $0x2,%eax
  803093:	05 44 52 80 00       	add    $0x805244,%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	74 1b                	je     8030b9 <initialize_dynamic_allocator+0xf0>
  80309e:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  8030a4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8030a7:	89 c8                	mov    %ecx,%eax
  8030a9:	01 c0                	add    %eax,%eax
  8030ab:	01 c8                	add    %ecx,%eax
  8030ad:	c1 e0 02             	shl    $0x2,%eax
  8030b0:	05 40 52 80 00       	add    $0x805240,%eax
  8030b5:	89 02                	mov    %eax,(%edx)
  8030b7:	eb 16                	jmp    8030cf <initialize_dynamic_allocator+0x106>
  8030b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030bc:	89 d0                	mov    %edx,%eax
  8030be:	01 c0                	add    %eax,%eax
  8030c0:	01 d0                	add    %edx,%eax
  8030c2:	c1 e0 02             	shl    $0x2,%eax
  8030c5:	05 40 52 80 00       	add    $0x805240,%eax
  8030ca:	a3 28 52 80 00       	mov    %eax,0x805228
  8030cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d2:	89 d0                	mov    %edx,%eax
  8030d4:	01 c0                	add    %eax,%eax
  8030d6:	01 d0                	add    %edx,%eax
  8030d8:	c1 e0 02             	shl    $0x2,%eax
  8030db:	05 40 52 80 00       	add    $0x805240,%eax
  8030e0:	a3 2c 52 80 00       	mov    %eax,0x80522c
  8030e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e8:	89 d0                	mov    %edx,%eax
  8030ea:	01 c0                	add    %eax,%eax
  8030ec:	01 d0                	add    %edx,%eax
  8030ee:	c1 e0 02             	shl    $0x2,%eax
  8030f1:	05 40 52 80 00       	add    $0x805240,%eax
  8030f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fc:	a1 34 52 80 00       	mov    0x805234,%eax
  803101:	40                   	inc    %eax
  803102:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  803107:	ff 45 f4             	incl   -0xc(%ebp)
  80310a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803110:	0f 8c 2c ff ff ff    	jl     803042 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803116:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80311d:	eb 36                	jmp    803155 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  80311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803122:	c1 e0 04             	shl    $0x4,%eax
  803125:	05 60 d2 81 00       	add    $0x81d260,%eax
  80312a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803133:	c1 e0 04             	shl    $0x4,%eax
  803136:	05 64 d2 81 00       	add    $0x81d264,%eax
  80313b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803144:	c1 e0 04             	shl    $0x4,%eax
  803147:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80314c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803152:	ff 45 f0             	incl   -0x10(%ebp)
  803155:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803159:	7e c4                	jle    80311f <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80315b:	90                   	nop
  80315c:	c9                   	leave  
  80315d:	c3                   	ret    

0080315e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80315e:	55                   	push   %ebp
  80315f:	89 e5                	mov    %esp,%ebp
  803161:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	83 ec 0c             	sub    $0xc,%esp
  80316a:	50                   	push   %eax
  80316b:	e8 0b fe ff ff       	call   802f7b <to_page_info>
  803170:	83 c4 10             	add    $0x10,%esp
  803173:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 40 08             	mov    0x8(%eax),%eax
  80317c:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80317f:	c9                   	leave  
  803180:	c3                   	ret    

00803181 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  803181:	55                   	push   %ebp
  803182:	89 e5                	mov    %esp,%ebp
  803184:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  803187:	83 ec 0c             	sub    $0xc,%esp
  80318a:	ff 75 0c             	pushl  0xc(%ebp)
  80318d:	e8 77 fd ff ff       	call   802f09 <to_page_va>
  803192:	83 c4 10             	add    $0x10,%esp
  803195:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  803198:	b8 00 10 00 00       	mov    $0x1000,%eax
  80319d:	ba 00 00 00 00       	mov    $0x0,%edx
  8031a2:	f7 75 08             	divl   0x8(%ebp)
  8031a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	83 ec 0c             	sub    $0xc,%esp
  8031ae:	50                   	push   %eax
  8031af:	e8 48 f6 ff ff       	call   8027fc <get_page>
  8031b4:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  8031b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031bd:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031c7:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8031cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8031d2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8031d9:	eb 19                	jmp    8031f4 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8031db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031de:	ba 01 00 00 00       	mov    $0x1,%edx
  8031e3:	88 c1                	mov    %al,%cl
  8031e5:	d3 e2                	shl    %cl,%edx
  8031e7:	89 d0                	mov    %edx,%eax
  8031e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ec:	74 0e                	je     8031fc <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8031ee:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8031f1:	ff 45 f0             	incl   -0x10(%ebp)
  8031f4:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8031f8:	7e e1                	jle    8031db <split_page_to_blocks+0x5a>
  8031fa:	eb 01                	jmp    8031fd <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8031fc:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8031fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803204:	e9 a7 00 00 00       	jmp    8032b0 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  803209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320c:	0f af 45 08          	imul   0x8(%ebp),%eax
  803210:	89 c2                	mov    %eax,%edx
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	01 d0                	add    %edx,%eax
  803217:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80321a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80321e:	75 14                	jne    803234 <split_page_to_blocks+0xb3>
  803220:	83 ec 04             	sub    $0x4,%esp
  803223:	68 bc 4b 80 00       	push   $0x804bbc
  803228:	6a 7c                	push   $0x7c
  80322a:	68 43 4b 80 00       	push   $0x804b43
  80322f:	e8 c1 e3 ff ff       	call   8015f5 <_panic>
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	c1 e0 04             	shl    $0x4,%eax
  80323a:	05 64 d2 81 00       	add    $0x81d264,%eax
  80323f:	8b 10                	mov    (%eax),%edx
  803241:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803244:	89 50 04             	mov    %edx,0x4(%eax)
  803247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324a:	8b 40 04             	mov    0x4(%eax),%eax
  80324d:	85 c0                	test   %eax,%eax
  80324f:	74 14                	je     803265 <split_page_to_blocks+0xe4>
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	c1 e0 04             	shl    $0x4,%eax
  803257:	05 64 d2 81 00       	add    $0x81d264,%eax
  80325c:	8b 00                	mov    (%eax),%eax
  80325e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803261:	89 10                	mov    %edx,(%eax)
  803263:	eb 11                	jmp    803276 <split_page_to_blocks+0xf5>
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	c1 e0 04             	shl    $0x4,%eax
  80326b:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  803271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803274:	89 02                	mov    %eax,(%edx)
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	c1 e0 04             	shl    $0x4,%eax
  80327c:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  803282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803285:	89 02                	mov    %eax,(%edx)
  803287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80328a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	c1 e0 04             	shl    $0x4,%eax
  803296:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80329b:	8b 00                	mov    (%eax),%eax
  80329d:	8d 50 01             	lea    0x1(%eax),%edx
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	c1 e0 04             	shl    $0x4,%eax
  8032a6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8032ab:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8032ad:	ff 45 ec             	incl   -0x14(%ebp)
  8032b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8032b6:	0f 82 4d ff ff ff    	jb     803209 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8032bc:	90                   	nop
  8032bd:	c9                   	leave  
  8032be:	c3                   	ret    

008032bf <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8032bf:	55                   	push   %ebp
  8032c0:	89 e5                	mov    %esp,%ebp
  8032c2:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8032c5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8032cc:	76 19                	jbe    8032e7 <alloc_block+0x28>
  8032ce:	68 e0 4b 80 00       	push   $0x804be0
  8032d3:	68 a6 4b 80 00       	push   $0x804ba6
  8032d8:	68 8a 00 00 00       	push   $0x8a
  8032dd:	68 43 4b 80 00       	push   $0x804b43
  8032e2:	e8 0e e3 ff ff       	call   8015f5 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8032e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8032ee:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8032f5:	eb 19                	jmp    803310 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fa:	ba 01 00 00 00       	mov    $0x1,%edx
  8032ff:	88 c1                	mov    %al,%cl
  803301:	d3 e2                	shl    %cl,%edx
  803303:	89 d0                	mov    %edx,%eax
  803305:	3b 45 08             	cmp    0x8(%ebp),%eax
  803308:	73 0e                	jae    803318 <alloc_block+0x59>
		idx++;
  80330a:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80330d:	ff 45 f0             	incl   -0x10(%ebp)
  803310:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803314:	7e e1                	jle    8032f7 <alloc_block+0x38>
  803316:	eb 01                	jmp    803319 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  803318:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  803319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331c:	c1 e0 04             	shl    $0x4,%eax
  80331f:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	85 c0                	test   %eax,%eax
  803328:	0f 84 df 00 00 00    	je     80340d <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	c1 e0 04             	shl    $0x4,%eax
  803334:	05 60 d2 81 00       	add    $0x81d260,%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80333e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803342:	75 17                	jne    80335b <alloc_block+0x9c>
  803344:	83 ec 04             	sub    $0x4,%esp
  803347:	68 01 4c 80 00       	push   $0x804c01
  80334c:	68 9e 00 00 00       	push   $0x9e
  803351:	68 43 4b 80 00       	push   $0x804b43
  803356:	e8 9a e2 ff ff       	call   8015f5 <_panic>
  80335b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	85 c0                	test   %eax,%eax
  803362:	74 10                	je     803374 <alloc_block+0xb5>
  803364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80336c:	8b 52 04             	mov    0x4(%edx),%edx
  80336f:	89 50 04             	mov    %edx,0x4(%eax)
  803372:	eb 14                	jmp    803388 <alloc_block+0xc9>
  803374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803377:	8b 40 04             	mov    0x4(%eax),%eax
  80337a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80337d:	c1 e2 04             	shl    $0x4,%edx
  803380:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803386:	89 02                	mov    %eax,(%edx)
  803388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338b:	8b 40 04             	mov    0x4(%eax),%eax
  80338e:	85 c0                	test   %eax,%eax
  803390:	74 0f                	je     8033a1 <alloc_block+0xe2>
  803392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803395:	8b 40 04             	mov    0x4(%eax),%eax
  803398:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80339b:	8b 12                	mov    (%edx),%edx
  80339d:	89 10                	mov    %edx,(%eax)
  80339f:	eb 13                	jmp    8033b4 <alloc_block+0xf5>
  8033a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a9:	c1 e2 04             	shl    $0x4,%edx
  8033ac:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8033b2:	89 02                	mov    %eax,(%edx)
  8033b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	c1 e0 04             	shl    $0x4,%eax
  8033cd:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	c1 e0 04             	shl    $0x4,%eax
  8033dd:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8033e2:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	50                   	push   %eax
  8033eb:	e8 8b fb ff ff       	call   802f7b <to_page_info>
  8033f0:	83 c4 10             	add    $0x10,%esp
  8033f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8033f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8033fd:	48                   	dec    %eax
  8033fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803401:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  803405:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803408:	e9 bc 02 00 00       	jmp    8036c9 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80340d:	a1 34 52 80 00       	mov    0x805234,%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	0f 84 7d 02 00 00    	je     803697 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80341a:	a1 28 52 80 00       	mov    0x805228,%eax
  80341f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  803422:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803426:	75 17                	jne    80343f <alloc_block+0x180>
  803428:	83 ec 04             	sub    $0x4,%esp
  80342b:	68 01 4c 80 00       	push   $0x804c01
  803430:	68 a9 00 00 00       	push   $0xa9
  803435:	68 43 4b 80 00       	push   $0x804b43
  80343a:	e8 b6 e1 ff ff       	call   8015f5 <_panic>
  80343f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	85 c0                	test   %eax,%eax
  803446:	74 10                	je     803458 <alloc_block+0x199>
  803448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803450:	8b 52 04             	mov    0x4(%edx),%edx
  803453:	89 50 04             	mov    %edx,0x4(%eax)
  803456:	eb 0b                	jmp    803463 <alloc_block+0x1a4>
  803458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345b:	8b 40 04             	mov    0x4(%eax),%eax
  80345e:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803466:	8b 40 04             	mov    0x4(%eax),%eax
  803469:	85 c0                	test   %eax,%eax
  80346b:	74 0f                	je     80347c <alloc_block+0x1bd>
  80346d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803470:	8b 40 04             	mov    0x4(%eax),%eax
  803473:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803476:	8b 12                	mov    (%edx),%edx
  803478:	89 10                	mov    %edx,(%eax)
  80347a:	eb 0a                	jmp    803486 <alloc_block+0x1c7>
  80347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	a3 28 52 80 00       	mov    %eax,0x805228
  803486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803492:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803499:	a1 34 52 80 00       	mov    0x805234,%eax
  80349e:	48                   	dec    %eax
  80349f:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	83 c0 03             	add    $0x3,%eax
  8034aa:	ba 01 00 00 00       	mov    $0x1,%edx
  8034af:	88 c1                	mov    %al,%cl
  8034b1:	d3 e2                	shl    %cl,%edx
  8034b3:	89 d0                	mov    %edx,%eax
  8034b5:	83 ec 08             	sub    $0x8,%esp
  8034b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034bb:	50                   	push   %eax
  8034bc:	e8 c0 fc ff ff       	call   803181 <split_page_to_blocks>
  8034c1:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8034c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c7:	c1 e0 04             	shl    $0x4,%eax
  8034ca:	05 60 d2 81 00       	add    $0x81d260,%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8034d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034d8:	75 17                	jne    8034f1 <alloc_block+0x232>
  8034da:	83 ec 04             	sub    $0x4,%esp
  8034dd:	68 01 4c 80 00       	push   $0x804c01
  8034e2:	68 b0 00 00 00       	push   $0xb0
  8034e7:	68 43 4b 80 00       	push   $0x804b43
  8034ec:	e8 04 e1 ff ff       	call   8015f5 <_panic>
  8034f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f4:	8b 00                	mov    (%eax),%eax
  8034f6:	85 c0                	test   %eax,%eax
  8034f8:	74 10                	je     80350a <alloc_block+0x24b>
  8034fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034fd:	8b 00                	mov    (%eax),%eax
  8034ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803502:	8b 52 04             	mov    0x4(%edx),%edx
  803505:	89 50 04             	mov    %edx,0x4(%eax)
  803508:	eb 14                	jmp    80351e <alloc_block+0x25f>
  80350a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80350d:	8b 40 04             	mov    0x4(%eax),%eax
  803510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803513:	c1 e2 04             	shl    $0x4,%edx
  803516:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80351c:	89 02                	mov    %eax,(%edx)
  80351e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803521:	8b 40 04             	mov    0x4(%eax),%eax
  803524:	85 c0                	test   %eax,%eax
  803526:	74 0f                	je     803537 <alloc_block+0x278>
  803528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80352b:	8b 40 04             	mov    0x4(%eax),%eax
  80352e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803531:	8b 12                	mov    (%edx),%edx
  803533:	89 10                	mov    %edx,(%eax)
  803535:	eb 13                	jmp    80354a <alloc_block+0x28b>
  803537:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80353f:	c1 e2 04             	shl    $0x4,%edx
  803542:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803548:	89 02                	mov    %eax,(%edx)
  80354a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803556:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803560:	c1 e0 04             	shl    $0x4,%eax
  803563:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803568:	8b 00                	mov    (%eax),%eax
  80356a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803570:	c1 e0 04             	shl    $0x4,%eax
  803573:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803578:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80357a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357d:	83 ec 0c             	sub    $0xc,%esp
  803580:	50                   	push   %eax
  803581:	e8 f5 f9 ff ff       	call   802f7b <to_page_info>
  803586:	83 c4 10             	add    $0x10,%esp
  803589:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80358c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80358f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803593:	48                   	dec    %eax
  803594:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803597:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80359b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80359e:	e9 26 01 00 00       	jmp    8036c9 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8035a3:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8035a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a9:	c1 e0 04             	shl    $0x4,%eax
  8035ac:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035b1:	8b 00                	mov    (%eax),%eax
  8035b3:	85 c0                	test   %eax,%eax
  8035b5:	0f 84 dc 00 00 00    	je     803697 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035be:	c1 e0 04             	shl    $0x4,%eax
  8035c1:	05 60 d2 81 00       	add    $0x81d260,%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8035cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8035cf:	75 17                	jne    8035e8 <alloc_block+0x329>
  8035d1:	83 ec 04             	sub    $0x4,%esp
  8035d4:	68 01 4c 80 00       	push   $0x804c01
  8035d9:	68 be 00 00 00       	push   $0xbe
  8035de:	68 43 4b 80 00       	push   $0x804b43
  8035e3:	e8 0d e0 ff ff       	call   8015f5 <_panic>
  8035e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	85 c0                	test   %eax,%eax
  8035ef:	74 10                	je     803601 <alloc_block+0x342>
  8035f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035f9:	8b 52 04             	mov    0x4(%edx),%edx
  8035fc:	89 50 04             	mov    %edx,0x4(%eax)
  8035ff:	eb 14                	jmp    803615 <alloc_block+0x356>
  803601:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803604:	8b 40 04             	mov    0x4(%eax),%eax
  803607:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80360a:	c1 e2 04             	shl    $0x4,%edx
  80360d:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803613:	89 02                	mov    %eax,(%edx)
  803615:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803618:	8b 40 04             	mov    0x4(%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	74 0f                	je     80362e <alloc_block+0x36f>
  80361f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803622:	8b 40 04             	mov    0x4(%eax),%eax
  803625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803628:	8b 12                	mov    (%edx),%edx
  80362a:	89 10                	mov    %edx,(%eax)
  80362c:	eb 13                	jmp    803641 <alloc_block+0x382>
  80362e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803631:	8b 00                	mov    (%eax),%eax
  803633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803636:	c1 e2 04             	shl    $0x4,%edx
  803639:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80363f:	89 02                	mov    %eax,(%edx)
  803641:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80364a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80364d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803657:	c1 e0 04             	shl    $0x4,%eax
  80365a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80365f:	8b 00                	mov    (%eax),%eax
  803661:	8d 50 ff             	lea    -0x1(%eax),%edx
  803664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803667:	c1 e0 04             	shl    $0x4,%eax
  80366a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80366f:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803671:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803674:	83 ec 0c             	sub    $0xc,%esp
  803677:	50                   	push   %eax
  803678:	e8 fe f8 ff ff       	call   802f7b <to_page_info>
  80367d:	83 c4 10             	add    $0x10,%esp
  803680:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  803683:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803686:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80368a:	48                   	dec    %eax
  80368b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80368e:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803692:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803695:	eb 32                	jmp    8036c9 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803697:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80369b:	77 15                	ja     8036b2 <alloc_block+0x3f3>
  80369d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a0:	c1 e0 04             	shl    $0x4,%eax
  8036a3:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	0f 84 f1 fe ff ff    	je     8035a3 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8036b2:	83 ec 04             	sub    $0x4,%esp
  8036b5:	68 1f 4c 80 00       	push   $0x804c1f
  8036ba:	68 c8 00 00 00       	push   $0xc8
  8036bf:	68 43 4b 80 00       	push   $0x804b43
  8036c4:	e8 2c df ff ff       	call   8015f5 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8036c9:	c9                   	leave  
  8036ca:	c3                   	ret    

008036cb <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8036cb:	55                   	push   %ebp
  8036cc:	89 e5                	mov    %esp,%ebp
  8036ce:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8036d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d4:	a1 48 d2 81 00       	mov    0x81d248,%eax
  8036d9:	39 c2                	cmp    %eax,%edx
  8036db:	72 0c                	jb     8036e9 <free_block+0x1e>
  8036dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e0:	a1 20 52 80 00       	mov    0x805220,%eax
  8036e5:	39 c2                	cmp    %eax,%edx
  8036e7:	72 19                	jb     803702 <free_block+0x37>
  8036e9:	68 30 4c 80 00       	push   $0x804c30
  8036ee:	68 a6 4b 80 00       	push   $0x804ba6
  8036f3:	68 d7 00 00 00       	push   $0xd7
  8036f8:	68 43 4b 80 00       	push   $0x804b43
  8036fd:	e8 f3 de ff ff       	call   8015f5 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	83 ec 0c             	sub    $0xc,%esp
  80370e:	50                   	push   %eax
  80370f:	e8 67 f8 ff ff       	call   802f7b <to_page_info>
  803714:	83 c4 10             	add    $0x10,%esp
  803717:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80371a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371d:	8b 40 08             	mov    0x8(%eax),%eax
  803720:	0f b7 c0             	movzwl %ax,%eax
  803723:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803726:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80372d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803734:	eb 19                	jmp    80374f <free_block+0x84>
	    if ((1 << i) == blk_size)
  803736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803739:	ba 01 00 00 00       	mov    $0x1,%edx
  80373e:	88 c1                	mov    %al,%cl
  803740:	d3 e2                	shl    %cl,%edx
  803742:	89 d0                	mov    %edx,%eax
  803744:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803747:	74 0e                	je     803757 <free_block+0x8c>
	        break;
	    idx++;
  803749:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80374c:	ff 45 f0             	incl   -0x10(%ebp)
  80374f:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803753:	7e e1                	jle    803736 <free_block+0x6b>
  803755:	eb 01                	jmp    803758 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  803757:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  803758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80375f:	40                   	inc    %eax
  803760:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803763:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803767:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80376b:	75 17                	jne    803784 <free_block+0xb9>
  80376d:	83 ec 04             	sub    $0x4,%esp
  803770:	68 bc 4b 80 00       	push   $0x804bbc
  803775:	68 ee 00 00 00       	push   $0xee
  80377a:	68 43 4b 80 00       	push   $0x804b43
  80377f:	e8 71 de ff ff       	call   8015f5 <_panic>
  803784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803787:	c1 e0 04             	shl    $0x4,%eax
  80378a:	05 64 d2 81 00       	add    $0x81d264,%eax
  80378f:	8b 10                	mov    (%eax),%edx
  803791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803794:	89 50 04             	mov    %edx,0x4(%eax)
  803797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379a:	8b 40 04             	mov    0x4(%eax),%eax
  80379d:	85 c0                	test   %eax,%eax
  80379f:	74 14                	je     8037b5 <free_block+0xea>
  8037a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a4:	c1 e0 04             	shl    $0x4,%eax
  8037a7:	05 64 d2 81 00       	add    $0x81d264,%eax
  8037ac:	8b 00                	mov    (%eax),%eax
  8037ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037b1:	89 10                	mov    %edx,(%eax)
  8037b3:	eb 11                	jmp    8037c6 <free_block+0xfb>
  8037b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b8:	c1 e0 04             	shl    $0x4,%eax
  8037bb:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8037c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c4:	89 02                	mov    %eax,(%edx)
  8037c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c9:	c1 e0 04             	shl    $0x4,%eax
  8037cc:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8037d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d5:	89 02                	mov    %eax,(%edx)
  8037d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e3:	c1 e0 04             	shl    $0x4,%eax
  8037e6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	8d 50 01             	lea    0x1(%eax),%edx
  8037f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f3:	c1 e0 04             	shl    $0x4,%eax
  8037f6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8037fb:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8037fd:	b8 00 10 00 00       	mov    $0x1000,%eax
  803802:	ba 00 00 00 00       	mov    $0x0,%edx
  803807:	f7 75 e0             	divl   -0x20(%ebp)
  80380a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80380d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803810:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803814:	0f b7 c0             	movzwl %ax,%eax
  803817:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80381a:	0f 85 70 01 00 00    	jne    803990 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803820:	83 ec 0c             	sub    $0xc,%esp
  803823:	ff 75 e4             	pushl  -0x1c(%ebp)
  803826:	e8 de f6 ff ff       	call   802f09 <to_page_va>
  80382b:	83 c4 10             	add    $0x10,%esp
  80382e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803831:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803838:	e9 b7 00 00 00       	jmp    8038f4 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80383d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803840:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803843:	01 d0                	add    %edx,%eax
  803845:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  803848:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80384c:	75 17                	jne    803865 <free_block+0x19a>
  80384e:	83 ec 04             	sub    $0x4,%esp
  803851:	68 01 4c 80 00       	push   $0x804c01
  803856:	68 f8 00 00 00       	push   $0xf8
  80385b:	68 43 4b 80 00       	push   $0x804b43
  803860:	e8 90 dd ff ff       	call   8015f5 <_panic>
  803865:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803868:	8b 00                	mov    (%eax),%eax
  80386a:	85 c0                	test   %eax,%eax
  80386c:	74 10                	je     80387e <free_block+0x1b3>
  80386e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803876:	8b 52 04             	mov    0x4(%edx),%edx
  803879:	89 50 04             	mov    %edx,0x4(%eax)
  80387c:	eb 14                	jmp    803892 <free_block+0x1c7>
  80387e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803881:	8b 40 04             	mov    0x4(%eax),%eax
  803884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803887:	c1 e2 04             	shl    $0x4,%edx
  80388a:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803890:	89 02                	mov    %eax,(%edx)
  803892:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	85 c0                	test   %eax,%eax
  80389a:	74 0f                	je     8038ab <free_block+0x1e0>
  80389c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80389f:	8b 40 04             	mov    0x4(%eax),%eax
  8038a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038a5:	8b 12                	mov    (%edx),%edx
  8038a7:	89 10                	mov    %edx,(%eax)
  8038a9:	eb 13                	jmp    8038be <free_block+0x1f3>
  8038ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038b3:	c1 e2 04             	shl    $0x4,%edx
  8038b6:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8038bc:	89 02                	mov    %eax,(%edx)
  8038be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d4:	c1 e0 04             	shl    $0x4,%eax
  8038d7:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8038dc:	8b 00                	mov    (%eax),%eax
  8038de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e4:	c1 e0 04             	shl    $0x4,%eax
  8038e7:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8038ec:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8038ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f1:	01 45 ec             	add    %eax,-0x14(%ebp)
  8038f4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8038fb:	0f 86 3c ff ff ff    	jbe    80383d <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80390a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803913:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803917:	75 17                	jne    803930 <free_block+0x265>
  803919:	83 ec 04             	sub    $0x4,%esp
  80391c:	68 bc 4b 80 00       	push   $0x804bbc
  803921:	68 fe 00 00 00       	push   $0xfe
  803926:	68 43 4b 80 00       	push   $0x804b43
  80392b:	e8 c5 dc ff ff       	call   8015f5 <_panic>
  803930:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803939:	89 50 04             	mov    %edx,0x4(%eax)
  80393c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393f:	8b 40 04             	mov    0x4(%eax),%eax
  803942:	85 c0                	test   %eax,%eax
  803944:	74 0c                	je     803952 <free_block+0x287>
  803946:	a1 2c 52 80 00       	mov    0x80522c,%eax
  80394b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394e:	89 10                	mov    %edx,(%eax)
  803950:	eb 08                	jmp    80395a <free_block+0x28f>
  803952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803955:	a3 28 52 80 00       	mov    %eax,0x805228
  80395a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395d:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803965:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396b:	a1 34 52 80 00       	mov    0x805234,%eax
  803970:	40                   	inc    %eax
  803971:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803976:	83 ec 0c             	sub    $0xc,%esp
  803979:	ff 75 e4             	pushl  -0x1c(%ebp)
  80397c:	e8 88 f5 ff ff       	call   802f09 <to_page_va>
  803981:	83 c4 10             	add    $0x10,%esp
  803984:	83 ec 0c             	sub    $0xc,%esp
  803987:	50                   	push   %eax
  803988:	e8 b8 ee ff ff       	call   802845 <return_page>
  80398d:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803990:	90                   	nop
  803991:	c9                   	leave  
  803992:	c3                   	ret    

00803993 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803993:	55                   	push   %ebp
  803994:	89 e5                	mov    %esp,%ebp
  803996:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 68 4c 80 00       	push   $0x804c68
  8039a1:	68 11 01 00 00       	push   $0x111
  8039a6:	68 43 4b 80 00       	push   $0x804b43
  8039ab:	e8 45 dc ff ff       	call   8015f5 <_panic>

008039b0 <__udivdi3>:
  8039b0:	55                   	push   %ebp
  8039b1:	57                   	push   %edi
  8039b2:	56                   	push   %esi
  8039b3:	53                   	push   %ebx
  8039b4:	83 ec 1c             	sub    $0x1c,%esp
  8039b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039c7:	89 ca                	mov    %ecx,%edx
  8039c9:	89 f8                	mov    %edi,%eax
  8039cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039cf:	85 f6                	test   %esi,%esi
  8039d1:	75 2d                	jne    803a00 <__udivdi3+0x50>
  8039d3:	39 cf                	cmp    %ecx,%edi
  8039d5:	77 65                	ja     803a3c <__udivdi3+0x8c>
  8039d7:	89 fd                	mov    %edi,%ebp
  8039d9:	85 ff                	test   %edi,%edi
  8039db:	75 0b                	jne    8039e8 <__udivdi3+0x38>
  8039dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8039e2:	31 d2                	xor    %edx,%edx
  8039e4:	f7 f7                	div    %edi
  8039e6:	89 c5                	mov    %eax,%ebp
  8039e8:	31 d2                	xor    %edx,%edx
  8039ea:	89 c8                	mov    %ecx,%eax
  8039ec:	f7 f5                	div    %ebp
  8039ee:	89 c1                	mov    %eax,%ecx
  8039f0:	89 d8                	mov    %ebx,%eax
  8039f2:	f7 f5                	div    %ebp
  8039f4:	89 cf                	mov    %ecx,%edi
  8039f6:	89 fa                	mov    %edi,%edx
  8039f8:	83 c4 1c             	add    $0x1c,%esp
  8039fb:	5b                   	pop    %ebx
  8039fc:	5e                   	pop    %esi
  8039fd:	5f                   	pop    %edi
  8039fe:	5d                   	pop    %ebp
  8039ff:	c3                   	ret    
  803a00:	39 ce                	cmp    %ecx,%esi
  803a02:	77 28                	ja     803a2c <__udivdi3+0x7c>
  803a04:	0f bd fe             	bsr    %esi,%edi
  803a07:	83 f7 1f             	xor    $0x1f,%edi
  803a0a:	75 40                	jne    803a4c <__udivdi3+0x9c>
  803a0c:	39 ce                	cmp    %ecx,%esi
  803a0e:	72 0a                	jb     803a1a <__udivdi3+0x6a>
  803a10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a14:	0f 87 9e 00 00 00    	ja     803ab8 <__udivdi3+0x108>
  803a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a1f:	89 fa                	mov    %edi,%edx
  803a21:	83 c4 1c             	add    $0x1c,%esp
  803a24:	5b                   	pop    %ebx
  803a25:	5e                   	pop    %esi
  803a26:	5f                   	pop    %edi
  803a27:	5d                   	pop    %ebp
  803a28:	c3                   	ret    
  803a29:	8d 76 00             	lea    0x0(%esi),%esi
  803a2c:	31 ff                	xor    %edi,%edi
  803a2e:	31 c0                	xor    %eax,%eax
  803a30:	89 fa                	mov    %edi,%edx
  803a32:	83 c4 1c             	add    $0x1c,%esp
  803a35:	5b                   	pop    %ebx
  803a36:	5e                   	pop    %esi
  803a37:	5f                   	pop    %edi
  803a38:	5d                   	pop    %ebp
  803a39:	c3                   	ret    
  803a3a:	66 90                	xchg   %ax,%ax
  803a3c:	89 d8                	mov    %ebx,%eax
  803a3e:	f7 f7                	div    %edi
  803a40:	31 ff                	xor    %edi,%edi
  803a42:	89 fa                	mov    %edi,%edx
  803a44:	83 c4 1c             	add    $0x1c,%esp
  803a47:	5b                   	pop    %ebx
  803a48:	5e                   	pop    %esi
  803a49:	5f                   	pop    %edi
  803a4a:	5d                   	pop    %ebp
  803a4b:	c3                   	ret    
  803a4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a51:	89 eb                	mov    %ebp,%ebx
  803a53:	29 fb                	sub    %edi,%ebx
  803a55:	89 f9                	mov    %edi,%ecx
  803a57:	d3 e6                	shl    %cl,%esi
  803a59:	89 c5                	mov    %eax,%ebp
  803a5b:	88 d9                	mov    %bl,%cl
  803a5d:	d3 ed                	shr    %cl,%ebp
  803a5f:	89 e9                	mov    %ebp,%ecx
  803a61:	09 f1                	or     %esi,%ecx
  803a63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a67:	89 f9                	mov    %edi,%ecx
  803a69:	d3 e0                	shl    %cl,%eax
  803a6b:	89 c5                	mov    %eax,%ebp
  803a6d:	89 d6                	mov    %edx,%esi
  803a6f:	88 d9                	mov    %bl,%cl
  803a71:	d3 ee                	shr    %cl,%esi
  803a73:	89 f9                	mov    %edi,%ecx
  803a75:	d3 e2                	shl    %cl,%edx
  803a77:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a7b:	88 d9                	mov    %bl,%cl
  803a7d:	d3 e8                	shr    %cl,%eax
  803a7f:	09 c2                	or     %eax,%edx
  803a81:	89 d0                	mov    %edx,%eax
  803a83:	89 f2                	mov    %esi,%edx
  803a85:	f7 74 24 0c          	divl   0xc(%esp)
  803a89:	89 d6                	mov    %edx,%esi
  803a8b:	89 c3                	mov    %eax,%ebx
  803a8d:	f7 e5                	mul    %ebp
  803a8f:	39 d6                	cmp    %edx,%esi
  803a91:	72 19                	jb     803aac <__udivdi3+0xfc>
  803a93:	74 0b                	je     803aa0 <__udivdi3+0xf0>
  803a95:	89 d8                	mov    %ebx,%eax
  803a97:	31 ff                	xor    %edi,%edi
  803a99:	e9 58 ff ff ff       	jmp    8039f6 <__udivdi3+0x46>
  803a9e:	66 90                	xchg   %ax,%ax
  803aa0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aa4:	89 f9                	mov    %edi,%ecx
  803aa6:	d3 e2                	shl    %cl,%edx
  803aa8:	39 c2                	cmp    %eax,%edx
  803aaa:	73 e9                	jae    803a95 <__udivdi3+0xe5>
  803aac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aaf:	31 ff                	xor    %edi,%edi
  803ab1:	e9 40 ff ff ff       	jmp    8039f6 <__udivdi3+0x46>
  803ab6:	66 90                	xchg   %ax,%ax
  803ab8:	31 c0                	xor    %eax,%eax
  803aba:	e9 37 ff ff ff       	jmp    8039f6 <__udivdi3+0x46>
  803abf:	90                   	nop

00803ac0 <__umoddi3>:
  803ac0:	55                   	push   %ebp
  803ac1:	57                   	push   %edi
  803ac2:	56                   	push   %esi
  803ac3:	53                   	push   %ebx
  803ac4:	83 ec 1c             	sub    $0x1c,%esp
  803ac7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803acb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803acf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ad3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ad7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803adb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803adf:	89 f3                	mov    %esi,%ebx
  803ae1:	89 fa                	mov    %edi,%edx
  803ae3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ae7:	89 34 24             	mov    %esi,(%esp)
  803aea:	85 c0                	test   %eax,%eax
  803aec:	75 1a                	jne    803b08 <__umoddi3+0x48>
  803aee:	39 f7                	cmp    %esi,%edi
  803af0:	0f 86 a2 00 00 00    	jbe    803b98 <__umoddi3+0xd8>
  803af6:	89 c8                	mov    %ecx,%eax
  803af8:	89 f2                	mov    %esi,%edx
  803afa:	f7 f7                	div    %edi
  803afc:	89 d0                	mov    %edx,%eax
  803afe:	31 d2                	xor    %edx,%edx
  803b00:	83 c4 1c             	add    $0x1c,%esp
  803b03:	5b                   	pop    %ebx
  803b04:	5e                   	pop    %esi
  803b05:	5f                   	pop    %edi
  803b06:	5d                   	pop    %ebp
  803b07:	c3                   	ret    
  803b08:	39 f0                	cmp    %esi,%eax
  803b0a:	0f 87 ac 00 00 00    	ja     803bbc <__umoddi3+0xfc>
  803b10:	0f bd e8             	bsr    %eax,%ebp
  803b13:	83 f5 1f             	xor    $0x1f,%ebp
  803b16:	0f 84 ac 00 00 00    	je     803bc8 <__umoddi3+0x108>
  803b1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b21:	29 ef                	sub    %ebp,%edi
  803b23:	89 fe                	mov    %edi,%esi
  803b25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b29:	89 e9                	mov    %ebp,%ecx
  803b2b:	d3 e0                	shl    %cl,%eax
  803b2d:	89 d7                	mov    %edx,%edi
  803b2f:	89 f1                	mov    %esi,%ecx
  803b31:	d3 ef                	shr    %cl,%edi
  803b33:	09 c7                	or     %eax,%edi
  803b35:	89 e9                	mov    %ebp,%ecx
  803b37:	d3 e2                	shl    %cl,%edx
  803b39:	89 14 24             	mov    %edx,(%esp)
  803b3c:	89 d8                	mov    %ebx,%eax
  803b3e:	d3 e0                	shl    %cl,%eax
  803b40:	89 c2                	mov    %eax,%edx
  803b42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b46:	d3 e0                	shl    %cl,%eax
  803b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b50:	89 f1                	mov    %esi,%ecx
  803b52:	d3 e8                	shr    %cl,%eax
  803b54:	09 d0                	or     %edx,%eax
  803b56:	d3 eb                	shr    %cl,%ebx
  803b58:	89 da                	mov    %ebx,%edx
  803b5a:	f7 f7                	div    %edi
  803b5c:	89 d3                	mov    %edx,%ebx
  803b5e:	f7 24 24             	mull   (%esp)
  803b61:	89 c6                	mov    %eax,%esi
  803b63:	89 d1                	mov    %edx,%ecx
  803b65:	39 d3                	cmp    %edx,%ebx
  803b67:	0f 82 87 00 00 00    	jb     803bf4 <__umoddi3+0x134>
  803b6d:	0f 84 91 00 00 00    	je     803c04 <__umoddi3+0x144>
  803b73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b77:	29 f2                	sub    %esi,%edx
  803b79:	19 cb                	sbb    %ecx,%ebx
  803b7b:	89 d8                	mov    %ebx,%eax
  803b7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b81:	d3 e0                	shl    %cl,%eax
  803b83:	89 e9                	mov    %ebp,%ecx
  803b85:	d3 ea                	shr    %cl,%edx
  803b87:	09 d0                	or     %edx,%eax
  803b89:	89 e9                	mov    %ebp,%ecx
  803b8b:	d3 eb                	shr    %cl,%ebx
  803b8d:	89 da                	mov    %ebx,%edx
  803b8f:	83 c4 1c             	add    $0x1c,%esp
  803b92:	5b                   	pop    %ebx
  803b93:	5e                   	pop    %esi
  803b94:	5f                   	pop    %edi
  803b95:	5d                   	pop    %ebp
  803b96:	c3                   	ret    
  803b97:	90                   	nop
  803b98:	89 fd                	mov    %edi,%ebp
  803b9a:	85 ff                	test   %edi,%edi
  803b9c:	75 0b                	jne    803ba9 <__umoddi3+0xe9>
  803b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803ba3:	31 d2                	xor    %edx,%edx
  803ba5:	f7 f7                	div    %edi
  803ba7:	89 c5                	mov    %eax,%ebp
  803ba9:	89 f0                	mov    %esi,%eax
  803bab:	31 d2                	xor    %edx,%edx
  803bad:	f7 f5                	div    %ebp
  803baf:	89 c8                	mov    %ecx,%eax
  803bb1:	f7 f5                	div    %ebp
  803bb3:	89 d0                	mov    %edx,%eax
  803bb5:	e9 44 ff ff ff       	jmp    803afe <__umoddi3+0x3e>
  803bba:	66 90                	xchg   %ax,%ax
  803bbc:	89 c8                	mov    %ecx,%eax
  803bbe:	89 f2                	mov    %esi,%edx
  803bc0:	83 c4 1c             	add    $0x1c,%esp
  803bc3:	5b                   	pop    %ebx
  803bc4:	5e                   	pop    %esi
  803bc5:	5f                   	pop    %edi
  803bc6:	5d                   	pop    %ebp
  803bc7:	c3                   	ret    
  803bc8:	3b 04 24             	cmp    (%esp),%eax
  803bcb:	72 06                	jb     803bd3 <__umoddi3+0x113>
  803bcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bd1:	77 0f                	ja     803be2 <__umoddi3+0x122>
  803bd3:	89 f2                	mov    %esi,%edx
  803bd5:	29 f9                	sub    %edi,%ecx
  803bd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bdb:	89 14 24             	mov    %edx,(%esp)
  803bde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803be2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803be6:	8b 14 24             	mov    (%esp),%edx
  803be9:	83 c4 1c             	add    $0x1c,%esp
  803bec:	5b                   	pop    %ebx
  803bed:	5e                   	pop    %esi
  803bee:	5f                   	pop    %edi
  803bef:	5d                   	pop    %ebp
  803bf0:	c3                   	ret    
  803bf1:	8d 76 00             	lea    0x0(%esi),%esi
  803bf4:	2b 04 24             	sub    (%esp),%eax
  803bf7:	19 fa                	sbb    %edi,%edx
  803bf9:	89 d1                	mov    %edx,%ecx
  803bfb:	89 c6                	mov    %eax,%esi
  803bfd:	e9 71 ff ff ff       	jmp    803b73 <__umoddi3+0xb3>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c08:	72 ea                	jb     803bf4 <__umoddi3+0x134>
  803c0a:	89 d9                	mov    %ebx,%ecx
  803c0c:	e9 62 ff ff ff       	jmp    803b73 <__umoddi3+0xb3>
