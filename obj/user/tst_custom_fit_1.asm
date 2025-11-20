
obj/user/tst_custom_fit_1:     file format elf32-i386


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
  800031:	e8 ff 19 00 00       	call   801a35 <libmain>
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
  800067:	e8 02 30 00 00       	call   80306e <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 45 30 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 ae 2d 00 00       	call   802e75 <malloc>
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
  8000df:	e8 8a 2f 00 00       	call   80306e <sys_calculate_free_frames>
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
  800125:	68 20 42 80 00       	push   $0x804220
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 af 1d 00 00       	call   801ee0 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 80 2f 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 42 80 00       	push   $0x80429c
  800150:	6a 0c                	push   $0xc
  800152:	e8 89 1d 00 00       	call   801ee0 <cprintf_colored>
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
  800174:	e8 f5 2e 00 00       	call   80306e <sys_calculate_free_frames>
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
  8001b9:	e8 b0 2e 00 00       	call   80306e <sys_calculate_free_frames>
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
  8001f8:	68 14 43 80 00       	push   $0x804314
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 dc 1c 00 00       	call   801ee0 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 ad 2e 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 43 80 00       	push   $0x8043a0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 af 1c 00 00       	call   801ee0 <cprintf_colored>
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
  800270:	e8 bb 31 00 00       	call   803430 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 44 80 00       	push   $0x804418
  80028f:	6a 0c                	push   $0xc
  800291:	e8 4a 1c 00 00       	call   801ee0 <cprintf_colored>
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
  8002ae:	e8 bb 2d 00 00       	call   80306e <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 fe 2d 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 d2 2b 00 00       	call   802ea3 <free>
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
  8002fc:	e8 b8 2d 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 44 80 00       	push   $0x804450
  800318:	6a 0c                	push   $0xc
  80031a:	e8 c1 1b 00 00       	call   801ee0 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 47 2d 00 00       	call   80306e <sys_calculate_free_frames>
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
  800342:	68 9c 44 80 00       	push   $0x80449c
  800347:	6a 0c                	push   $0xc
  800349:	e8 92 1b 00 00       	call   801ee0 <cprintf_colored>
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
  8003a0:	e8 8b 30 00 00       	call   803430 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 f8 44 80 00       	push   $0x8044f8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 1a 1b 00 00       	call   801ee0 <cprintf_colored>
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
  800416:	68 30 45 80 00       	push   $0x804530
  80041b:	6a 03                	push   $0x3
  80041d:	e8 be 1a 00 00       	call   801ee0 <cprintf_colored>
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
  8004df:	68 60 45 80 00       	push   $0x804560
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 f5 19 00 00       	call   801ee0 <cprintf_colored>
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
  8005b9:	68 60 45 80 00       	push   $0x804560
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 1b 19 00 00       	call   801ee0 <cprintf_colored>
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
  800693:	68 60 45 80 00       	push   $0x804560
  800698:	6a 0c                	push   $0xc
  80069a:	e8 41 18 00 00       	call   801ee0 <cprintf_colored>
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
  80076d:	68 60 45 80 00       	push   $0x804560
  800772:	6a 0c                	push   $0xc
  800774:	e8 67 17 00 00       	call   801ee0 <cprintf_colored>
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
  800847:	68 60 45 80 00       	push   $0x804560
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 8d 16 00 00       	call   801ee0 <cprintf_colored>
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
  800921:	68 60 45 80 00       	push   $0x804560
  800926:	6a 0c                	push   $0xc
  800928:	e8 b3 15 00 00       	call   801ee0 <cprintf_colored>
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
  800a16:	68 60 45 80 00       	push   $0x804560
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 be 14 00 00       	call   801ee0 <cprintf_colored>
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
  800b14:	68 60 45 80 00       	push   $0x804560
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 c0 13 00 00       	call   801ee0 <cprintf_colored>
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
  800c12:	68 60 45 80 00       	push   $0x804560
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 c2 12 00 00       	call   801ee0 <cprintf_colored>
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
  800d10:	68 60 45 80 00       	push   $0x804560
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 c4 11 00 00       	call   801ee0 <cprintf_colored>
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
  800dfd:	68 60 45 80 00       	push   $0x804560
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 d7 10 00 00       	call   801ee0 <cprintf_colored>
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
  800eea:	68 60 45 80 00       	push   $0x804560
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 ea 0f 00 00       	call   801ee0 <cprintf_colored>
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
  800fd7:	68 60 45 80 00       	push   $0x804560
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 fd 0e 00 00       	call   801ee0 <cprintf_colored>
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
  800ffa:	68 b2 45 80 00       	push   $0x8045b2
  800fff:	6a 03                	push   $0x3
  801001:	e8 da 0e 00 00       	call   801ee0 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c e2 81 00 0d 	movl   $0xd,0x81e24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 4f 20 00 00       	call   80306e <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 8f 20 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 1b 1e 00 00       	call   802e75 <malloc>
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
  801084:	68 d0 45 80 00       	push   $0x8045d0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 50 0e 00 00       	call   801ee0 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 21 20 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 0c 46 80 00       	push   $0x80460c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 24 0e 00 00       	call   801ee0 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 aa 1f 00 00       	call   80306e <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 7c 46 80 00       	push   $0x80467c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 f8 0d 00 00       	call   801ee0 <cprintf_colored>
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
  801102:	57                   	push   %edi
  801103:	81 ec e4 00 00 00    	sub    $0xe4,%esp
#if USE_KHEAP

	sys_set_uheap_strategy(UHP_PLACE_CUSTOMFIT);
  801109:	83 ec 0c             	sub    $0xc,%esp
  80110c:	6a 05                	push   $0x5
  80110e:	e8 b8 22 00 00       	call   8033cb <sys_set_uheap_strategy>
  801113:	83 c4 10             	add    $0x10,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801116:	a1 00 62 80 00       	mov    0x806200,%eax
  80111b:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801121:	a1 00 62 80 00       	mov    0x806200,%eax
  801126:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80112c:	39 c2                	cmp    %eax,%edx
  80112e:	72 14                	jb     801144 <_main+0x45>
			panic("Please increase the WS size");
  801130:	83 ec 04             	sub    $0x4,%esp
  801133:	68 c4 46 80 00       	push   $0x8046c4
  801138:	6a 18                	push   $0x18
  80113a:	68 e0 46 80 00       	push   $0x8046e0
  80113f:	e8 a1 0a 00 00       	call   801be5 <_panic>
	}
	/*=================================================*/
	int correct = 1;
  801144:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int eval;
	int expectedNumOfTables;

	//1. Alloc some spaces in PAGE allocator
	cprintf_colored(TEXT_cyan,"%~\n1. Alloc some spaces in PAGE allocator\n");
  80114b:	83 ec 08             	sub    $0x8,%esp
  80114e:	68 f8 46 80 00       	push   $0x8046f8
  801153:	6a 03                	push   $0x3
  801155:	e8 86 0d 00 00       	call   801ee0 <cprintf_colored>
  80115a:	83 c4 10             	add    $0x10,%esp
	{
		eval = initial_page_allocations();
  80115d:	e8 6c f2 ff ff       	call   8003ce <initial_page_allocations>
  801162:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (eval != 100)
  801165:	83 7d f0 64          	cmpl   $0x64,-0x10(%ebp)
  801169:	74 17                	je     801182 <_main+0x83>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"initial allocations are not correct!\nplease make sure the the kmalloc test is correct before testing the kfree\n");
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	68 24 47 80 00       	push   $0x804724
  801173:	6a 0c                	push   $0xc
  801175:	e8 66 0d 00 00       	call   801ee0 <cprintf_colored>
  80117a:	83 c4 10             	add    $0x10,%esp
			return ;
  80117d:	e9 ae 08 00 00       	jmp    801a30 <_main+0x931>
		}
	}
	eval = 0;
  801182:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//2. Free some allocations to create initial holes
	cprintf_colored(TEXT_cyan,"%~\n2. Free some allocations to create initial holes [5%]\n");
  801189:	83 ec 08             	sub    $0x8,%esp
  80118c:	68 94 47 80 00       	push   $0x804794
  801191:	6a 03                	push   $0x3
  801193:	e8 48 0d 00 00       	call   801ee0 <cprintf_colored>
  801198:	83 c4 10             	add    $0x10,%esp
	correct = 1;
  80119b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	{
		//3 MB Hole
		correct = freeSpaceInPageAlloc(1, 1);
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	6a 01                	push   $0x1
  8011a7:	6a 01                	push   $0x1
  8011a9:	e8 f3 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//2nd 4 MB Hole
		correct = freeSpaceInPageAlloc(3, 1);
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	6a 01                	push   $0x1
  8011b9:	6a 03                	push   $0x3
  8011bb:	e8 e1 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011c0:	83 c4 10             	add    $0x10,%esp
  8011c3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//2nd 1 MB Hole
		correct = freeSpaceInPageAlloc(5, 1);
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	6a 01                	push   $0x1
  8011cb:	6a 05                	push   $0x5
  8011cd:	e8 cf f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//2nd 2 MB Hole
		correct = freeSpaceInPageAlloc(7, 1);
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	6a 01                	push   $0x1
  8011dd:	6a 07                	push   $0x7
  8011df:	e8 bd f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011e4:	83 c4 10             	add    $0x10,%esp
  8011e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if (correct) eval += 5;
  8011ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011ee:	74 04                	je     8011f4 <_main+0xf5>
  8011f0:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
	correct = 1;
  8011f4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//3. Check content of un-freed spaces
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
  8011fb:	8d 95 18 ff ff ff    	lea    -0xe8(%ebp),%edx
  801201:	b9 28 00 00 00       	mov    $0x28,%ecx
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
  80120b:	89 d7                	mov    %edx,%edi
  80120d:	f3 ab                	rep stos %eax,%es:(%edi)
	cprintf_colored(TEXT_cyan,"%~\n3. Check content of un-freed spaces [5%]\n");
  80120f:	83 ec 08             	sub    $0x8,%esp
  801212:	68 d0 47 80 00       	push   $0x8047d0
  801217:	6a 03                	push   $0x3
  801219:	e8 c2 0c 00 00       	call   801ee0 <cprintf_colored>
  80121e:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 0; i < allocIndex; ++i)
  801221:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801228:	e9 c2 00 00 00       	jmp    8012ef <_main+0x1f0>
		{
			//skip the freed spaces
			if (i == 1 || i == 3 || i == 5 || i == 7)
  80122d:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  801231:	0f 84 b4 00 00 00    	je     8012eb <_main+0x1ec>
  801237:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
  80123b:	0f 84 aa 00 00 00    	je     8012eb <_main+0x1ec>
  801241:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
  801245:	0f 84 a0 00 00 00    	je     8012eb <_main+0x1ec>
  80124b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80124f:	0f 84 96 00 00 00    	je     8012eb <_main+0x1ec>
				continue;
			char* ptr = (char*)ptr_allocations[i];
  801255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801258:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80125f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			sums[i] += ptr[0] ;
  801262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801265:	8b 94 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%edx
  80126c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	0f be c0             	movsbl %al,%eax
  801274:	01 c2                	add    %eax,%edx
  801276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801279:	89 94 85 18 ff ff ff 	mov    %edx,-0xe8(%ebp,%eax,4)
			sums[i] += ptr[lastIndices[i]] ;
  801280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801283:	8b 94 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%edx
  80128a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80128d:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
  801294:	89 c1                	mov    %eax,%ecx
  801296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801299:	01 c8                	add    %ecx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	0f be c0             	movsbl %al,%eax
  8012a0:	01 c2                	add    %eax,%edx
  8012a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a5:	89 94 85 18 ff ff ff 	mov    %edx,-0xe8(%ebp,%eax,4)
			if (sums[i] != (maxByte + maxByte))
  8012ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012af:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
  8012b6:	3d fe 00 00 00       	cmp    $0xfe,%eax
  8012bb:	74 2f                	je     8012ec <_main+0x1ed>
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in alloc#%d. Expected = %d, Actual = %d\n", i, 2*maxByte, sums[i]); }
  8012bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8012c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012c7:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	50                   	push   %eax
  8012d2:	68 fe 00 00 00       	push   $0xfe
  8012d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8012da:	68 00 48 80 00       	push   $0x804800
  8012df:	6a 0c                	push   $0xc
  8012e1:	e8 fa 0b 00 00       	call   801ee0 <cprintf_colored>
  8012e6:	83 c4 20             	add    $0x20,%esp
  8012e9:	eb 01                	jmp    8012ec <_main+0x1ed>
	{
		for (int i = 0; i < allocIndex; ++i)
		{
			//skip the freed spaces
			if (i == 1 || i == 3 || i == 5 || i == 7)
				continue;
  8012eb:	90                   	nop

	//3. Check content of un-freed spaces
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
	cprintf_colored(TEXT_cyan,"%~\n3. Check content of un-freed spaces [5%]\n");
	{
		for (int i = 0; i < allocIndex; ++i)
  8012ec:	ff 45 ec             	incl   -0x14(%ebp)
  8012ef:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8012f4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8012f7:	0f 8c 30 ff ff ff    	jl     80122d <_main+0x12e>
			sums[i] += ptr[lastIndices[i]] ;
			if (sums[i] != (maxByte + maxByte))
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in alloc#%d. Expected = %d, Actual = %d\n", i, 2*maxByte, sums[i]); }
		}
	}
	if (correct) eval += 5;
  8012fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801301:	74 04                	je     801307 <_main+0x208>
  801303:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
	correct = 1;
  801307:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//4. Check BREAK
	correct = 1;
  80130e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	uint32 expectedBreak = 0;
  801315:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n4. Check BREAK [5%]\n");
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	68 39 48 80 00       	push   $0x804839
  801324:	6a 03                	push   $0x3
  801326:	e8 b5 0b 00 00       	call   801ee0 <cprintf_colored>
  80132b:	83 c4 10             	add    $0x10,%esp
	{
		expectedBreak = ACTUAL_PAGE_ALLOC_START + totalRequestedSize;
  80132e:	a1 40 e2 81 00       	mov    0x81e240,%eax
  801333:	2d 00 f0 ff 7d       	sub    $0x7dfff000,%eax
  801338:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(uheapPageAllocBreak != expectedBreak)
  80133b:	a1 50 e2 81 00       	mov    0x81e250,%eax
  801340:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801343:	74 1f                	je     801364 <_main+0x265>
		{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedBreak, uheapPageAllocBreak);}
  801345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80134c:	a1 50 e2 81 00       	mov    0x81e250,%eax
  801351:	50                   	push   %eax
  801352:	ff 75 e0             	pushl  -0x20(%ebp)
  801355:	68 54 48 80 00       	push   $0x804854
  80135a:	6a 0c                	push   $0xc
  80135c:	e8 7f 0b 00 00       	call   801ee0 <cprintf_colored>
  801361:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval += 5;
  801364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801368:	74 04                	je     80136e <_main+0x26f>
  80136a:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
	correct = 1;
  80136e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//5. Allocate after kfree [Test CUSTOM FIT]
	uint32 allocIndex,expectedVA, size = 0;
  801375:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n5. Allocate after free [Test CUSTOM FIT] [30%]\n");
  80137c:	83 ec 08             	sub    $0x8,%esp
  80137f:	68 8c 48 80 00       	push   $0x80488c
  801384:	6a 03                	push   $0x3
  801386:	e8 55 0b 00 00       	call   801ee0 <cprintf_colored>
  80138b:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB [EXACT FIT in 1MB Hole (alloc#5)]
		allocIndex = 14;
  80138e:	c7 45 d8 0e 00 00 00 	movl   $0xe,-0x28(%ebp)
		size = 1*Mega - kilo;
  801395:	c7 45 dc 00 fc 0f 00 	movl   $0xffc00,-0x24(%ebp)
		expectedNumOfTables = 0;
  80139c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8013a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8013a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013a9:	52                   	push   %edx
  8013aa:	6a 01                	push   $0x1
  8013ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8013af:	50                   	push   %eax
  8013b0:	e8 a4 ec ff ff       	call   800059 <allocSpaceInPageAlloc>
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[5] ; //Address of 1MB Hole
  8013bb:	a1 34 60 80 00       	mov    0x806034,%eax
  8013c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8013c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013c6:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8013cd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8013d0:	74 2a                	je     8013fc <_main+0x2fd>
  8013d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013dc:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8013e3:	83 ec 0c             	sub    $0xc,%esp
  8013e6:	50                   	push   %eax
  8013e7:	ff 75 d0             	pushl  -0x30(%ebp)
  8013ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8013ed:	68 c0 48 80 00       	push   $0x8048c0
  8013f2:	6a 0c                	push   $0xc
  8013f4:	e8 e7 0a 00 00       	call   801ee0 <cprintf_colored>
  8013f9:	83 c4 20             	add    $0x20,%esp

		//1MB + 4KB [WORST FIT in 4MB Hole (alloc#3)]
		allocIndex = 15;
  8013fc:	c7 45 d8 0f 00 00 00 	movl   $0xf,-0x28(%ebp)
		size = 1*Mega + 4*kilo;
  801403:	c7 45 dc 00 10 10 00 	movl   $0x101000,-0x24(%ebp)
		expectedNumOfTables = 0;
  80140a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  801411:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801414:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801417:	52                   	push   %edx
  801418:	6a 01                	push   $0x1
  80141a:	ff 75 dc             	pushl  -0x24(%ebp)
  80141d:	50                   	push   %eax
  80141e:	e8 36 ec ff ff       	call   800059 <allocSpaceInPageAlloc>
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[3] ; //Address of 4MB Hole
  801429:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80142e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  801431:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801434:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80143b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80143e:	74 2a                	je     80146a <_main+0x36b>
  801440:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801447:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80144a:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	50                   	push   %eax
  801455:	ff 75 d0             	pushl  -0x30(%ebp)
  801458:	ff 75 d8             	pushl  -0x28(%ebp)
  80145b:	68 c0 48 80 00       	push   $0x8048c0
  801460:	6a 0c                	push   $0xc
  801462:	e8 79 0a 00 00       	call   801ee0 <cprintf_colored>
  801467:	83 c4 20             	add    $0x20,%esp

		//3MB - 4KB [EXACT FIT in remaining area of 4MB Hole (alloc#3)]
		allocIndex = 16;
  80146a:	c7 45 d8 10 00 00 00 	movl   $0x10,-0x28(%ebp)
		size = 3*Mega - 4*kilo;
  801471:	c7 45 dc 00 f0 2f 00 	movl   $0x2ff000,-0x24(%ebp)
		expectedNumOfTables = 0;
  801478:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80147f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801482:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801485:	52                   	push   %edx
  801486:	6a 01                	push   $0x1
  801488:	ff 75 dc             	pushl  -0x24(%ebp)
  80148b:	50                   	push   %eax
  80148c:	e8 c8 eb ff ff       	call   800059 <allocSpaceInPageAlloc>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[3] + 1*Mega + 4*kilo; //1MB.4KB after the Start Address of 4MB Hole
  801497:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80149c:	05 00 10 10 00       	add    $0x101000,%eax
  8014a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8014a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a7:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8014ae:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8014b1:	74 2a                	je     8014dd <_main+0x3de>
  8014b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8014ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014bd:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	50                   	push   %eax
  8014c8:	ff 75 d0             	pushl  -0x30(%ebp)
  8014cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8014ce:	68 c0 48 80 00       	push   $0x8048c0
  8014d3:	6a 0c                	push   $0xc
  8014d5:	e8 06 0a 00 00       	call   801ee0 <cprintf_colored>
  8014da:	83 c4 20             	add    $0x20,%esp

		//1.5 MB [WORST FIT in 3MB Hole (alloc#1)]
		allocIndex = 17;
  8014dd:	c7 45 d8 11 00 00 00 	movl   $0x11,-0x28(%ebp)
		size = 1*Mega + Mega/2;
  8014e4:	c7 45 dc 00 00 18 00 	movl   $0x180000,-0x24(%ebp)
		expectedNumOfTables = 0;
  8014eb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8014f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8014f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f8:	52                   	push   %edx
  8014f9:	6a 01                	push   $0x1
  8014fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8014fe:	50                   	push   %eax
  8014ff:	e8 55 eb ff ff       	call   800059 <allocSpaceInPageAlloc>
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[1] ; //Address of 3MB Hole
  80150a:	a1 24 60 80 00       	mov    0x806024,%eax
  80150f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  801512:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801515:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80151c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80151f:	74 2a                	je     80154b <_main+0x44c>
  801521:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801528:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80152b:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  801532:	83 ec 0c             	sub    $0xc,%esp
  801535:	50                   	push   %eax
  801536:	ff 75 d0             	pushl  -0x30(%ebp)
  801539:	ff 75 d8             	pushl  -0x28(%ebp)
  80153c:	68 c0 48 80 00       	push   $0x8048c0
  801541:	6a 0c                	push   $0xc
  801543:	e8 98 09 00 00       	call   801ee0 <cprintf_colored>
  801548:	83 c4 20             	add    $0x20,%esp

		//2.5 MB [EXTEND THE BREAK]
		allocIndex = 18;
  80154b:	c7 45 d8 12 00 00 00 	movl   $0x12,-0x28(%ebp)
		size = 2*Mega + Mega/2;
  801552:	c7 45 dc 00 00 28 00 	movl   $0x280000,-0x24(%ebp)
		expectedNumOfTables = 0;
  801559:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  801560:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801563:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801566:	52                   	push   %edx
  801567:	6a 01                	push   $0x1
  801569:	ff 75 dc             	pushl  -0x24(%ebp)
  80156c:	50                   	push   %eax
  80156d:	e8 e7 ea ff ff       	call   800059 <allocSpaceInPageAlloc>
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = expectedBreak ;
  801578:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		expectedBreak += ROUNDUP(size, PAGE_SIZE);
  80157e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801585:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801588:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80158b:	01 d0                	add    %edx,%eax
  80158d:	48                   	dec    %eax
  80158e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801591:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801594:	ba 00 00 00 00       	mov    $0x0,%edx
  801599:	f7 75 cc             	divl   -0x34(%ebp)
  80159c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80159f:	29 d0                	sub    %edx,%eax
  8015a1:	01 45 e0             	add    %eax,-0x20(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA))
  8015a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015a7:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8015ae:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8015b1:	74 2a                	je     8015dd <_main+0x4de>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8015b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015bd:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8015c4:	83 ec 0c             	sub    $0xc,%esp
  8015c7:	50                   	push   %eax
  8015c8:	ff 75 d0             	pushl  -0x30(%ebp)
  8015cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8015ce:	68 c0 48 80 00       	push   $0x8048c0
  8015d3:	6a 0c                	push   $0xc
  8015d5:	e8 06 09 00 00       	call   801ee0 <cprintf_colored>
  8015da:	83 c4 20             	add    $0x20,%esp
		if(uheapPageAllocBreak != expectedBreak)
  8015dd:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8015e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8015e5:	74 1f                	je     801606 <_main+0x507>
		{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedBreak, uheapPageAllocBreak);}
  8015e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015ee:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8015f3:	50                   	push   %eax
  8015f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8015f7:	68 54 48 80 00       	push   $0x804854
  8015fc:	6a 0c                	push   $0xc
  8015fe:	e8 dd 08 00 00       	call   801ee0 <cprintf_colored>
  801603:	83 c4 10             	add    $0x10,%esp

		//Insufficient space
		allocIndex = 19;
  801606:	c7 45 d8 13 00 00 00 	movl   $0x13,-0x28(%ebp)
		expectedVA = 0;
  80160d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		int freeFrames = (int)sys_calculate_free_frames() ;
  801614:	e8 55 1a 00 00       	call   80306e <sys_calculate_free_frames>
  801619:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int usedDiskFrames = (int)sys_pf_calculate_allocated_pages() ;
  80161c:	e8 98 1a 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
  801621:	89 45 c0             	mov    %eax,-0x40(%ebp)
		uint32 restOfUHeap = (USER_HEAP_MAX - ACTUAL_PAGE_ALLOC_START) - expectedBreak ;
  801624:	b8 00 f0 ff 1d       	mov    $0x1dfff000,%eax
  801629:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80162c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		ptr_allocations[allocIndex] = malloc(restOfUHeap+1);
  80162f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801632:	40                   	inc    %eax
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	50                   	push   %eax
  801637:	e8 39 18 00 00       	call   802e75 <malloc>
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	89 c2                	mov    %eax,%edx
  801641:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801644:	89 14 85 20 60 80 00 	mov    %edx,0x806020(,%eax,4)
		if (ptr_allocations[allocIndex] != NULL)
  80164b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80164e:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  801655:	85 c0                	test   %eax,%eax
  801657:	74 1c                	je     801675 <_main+0x576>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.1 Allocating insufficient space: should return NULL\n", allocIndex); }
  801659:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	ff 75 d8             	pushl  -0x28(%ebp)
  801666:	68 10 49 80 00       	push   $0x804910
  80166b:	6a 0c                	push   $0xc
  80166d:	e8 6e 08 00 00       	call   801ee0 <cprintf_colored>
  801672:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskFrames) != 0)
  801675:	e8 3f 1a 00 00       	call   8030b9 <sys_pf_calculate_allocated_pages>
  80167a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  80167d:	74 1c                	je     80169b <_main+0x59c>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  80167f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	ff 75 d8             	pushl  -0x28(%ebp)
  80168c:	68 48 49 80 00       	push   $0x804948
  801691:	6a 0c                	push   $0xc
  801693:	e8 48 08 00 00       	call   801ee0 <cprintf_colored>
  801698:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0)
  80169b:	e8 ce 19 00 00       	call   80306e <sys_calculate_free_frames>
  8016a0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8016a3:	74 1c                	je     8016c1 <_main+0x5c2>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8016a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	ff 75 d8             	pushl  -0x28(%ebp)
  8016b2:	68 b8 49 80 00       	push   $0x8049b8
  8016b7:	6a 0c                	push   $0xc
  8016b9:	e8 22 08 00 00       	call   801ee0 <cprintf_colored>
  8016be:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval+=30;
  8016c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c5:	74 04                	je     8016cb <_main+0x5cc>
  8016c7:	83 45 f0 1e          	addl   $0x1e,-0x10(%ebp)
	correct = 1;
  8016cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//6. Check content of newly allocated spaces
	cprintf_colored(TEXT_cyan,"%~\n6. Check content of newly allocated spaces [10%]\n");
  8016d2:	83 ec 08             	sub    $0x8,%esp
  8016d5:	68 00 4a 80 00       	push   $0x804a00
  8016da:	6a 03                	push   $0x3
  8016dc:	e8 ff 07 00 00       	call   801ee0 <cprintf_colored>
  8016e1:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 14; i < allocIndex; ++i)
  8016e4:	c7 45 e8 0e 00 00 00 	movl   $0xe,-0x18(%ebp)
  8016eb:	e9 97 00 00 00       	jmp    801787 <_main+0x688>
		{
			char* ptr = (char*)ptr_allocations[i];
  8016f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f3:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8016fa:	89 45 b8             	mov    %eax,-0x48(%ebp)
			sums[i] += ptr[0] ;
  8016fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801700:	8b 94 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%edx
  801707:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	0f be c0             	movsbl %al,%eax
  80170f:	01 c2                	add    %eax,%edx
  801711:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801714:	89 94 85 18 ff ff ff 	mov    %edx,-0xe8(%ebp,%eax,4)
			sums[i] += ptr[lastIndices[i]] ;
  80171b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80171e:	8b 94 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%edx
  801725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801728:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
  80172f:	89 c1                	mov    %eax,%ecx
  801731:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801734:	01 c8                	add    %ecx,%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	0f be c0             	movsbl %al,%eax
  80173b:	01 c2                	add    %eax,%edx
  80173d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801740:	89 94 85 18 ff ff ff 	mov    %edx,-0xe8(%ebp,%eax,4)
			if (sums[i] != (maxByte + maxByte))
  801747:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174a:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
  801751:	3d fe 00 00 00       	cmp    $0xfe,%eax
  801756:	74 2c                	je     801784 <_main+0x685>
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in alloc#%d. Expected = %d, Actual = %d\n", i, 2*maxByte, sums[i]); }
  801758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80175f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801762:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
  801769:	83 ec 0c             	sub    $0xc,%esp
  80176c:	50                   	push   %eax
  80176d:	68 fe 00 00 00       	push   $0xfe
  801772:	ff 75 e8             	pushl  -0x18(%ebp)
  801775:	68 00 48 80 00       	push   $0x804800
  80177a:	6a 0c                	push   $0xc
  80177c:	e8 5f 07 00 00       	call   801ee0 <cprintf_colored>
  801781:	83 c4 20             	add    $0x20,%esp
	correct = 1;

	//6. Check content of newly allocated spaces
	cprintf_colored(TEXT_cyan,"%~\n6. Check content of newly allocated spaces [10%]\n");
	{
		for (int i = 14; i < allocIndex; ++i)
  801784:	ff 45 e8             	incl   -0x18(%ebp)
  801787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80178d:	0f 82 5d ff ff ff    	jb     8016f0 <_main+0x5f1>
			sums[i] += ptr[lastIndices[i]] ;
			if (sums[i] != (maxByte + maxByte))
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in alloc#%d. Expected = %d, Actual = %d\n", i, 2*maxByte, sums[i]); }
		}
	}
	if (correct) eval += 10;
  801793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801797:	74 04                	je     80179d <_main+0x69e>
  801799:	83 45 f0 0a          	addl   $0xa,-0x10(%ebp)
	correct = 1;
  80179d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//7. Free some allocations to create MERGED holes
	correct = 1;
  8017a4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n7. Free some allocations to create MERGED holes [5%]\n");
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	68 38 4a 80 00       	push   $0x804a38
  8017b3:	6a 03                	push   $0x3
  8017b5:	e8 26 07 00 00       	call   801ee0 <cprintf_colored>
  8017ba:	83 c4 10             	add    $0x10,%esp
	{
		//Free new 3MB allocation inside the 4MB Hole
		correct = freeSpaceInPageAlloc(16,1);
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	6a 01                	push   $0x1
  8017c2:	6a 10                	push   $0x10
  8017c4:	e8 d8 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free new 1MB allocation at the beginning of the 4MB Hole (should be MERGED with next 3MB) => 4MB HOLE
		correct = freeSpaceInPageAlloc(15,1);
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	6a 01                	push   $0x1
  8017d4:	6a 0f                	push   $0xf
  8017d6:	e8 c6 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free new 1MB allocation at the beginning of the 3MB Hole (should be MERGED with next 1.5MB) => 3MB HOLE
		correct = freeSpaceInPageAlloc(17,1);
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	6a 01                	push   $0x1
  8017e6:	6a 11                	push   $0x11
  8017e8:	e8 b4 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free new 1MB allocation at the 1MB Hole (NO MERGED)
		correct = freeSpaceInPageAlloc(14,1);
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	6a 01                	push   $0x1
  8017f8:	6a 0e                	push   $0xe
  8017fa:	e8 a2 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free original 3rd 1MB allocation (should be MERGED with next 2MB hole and the prev 1MB hole) => 4MB HOLE
		correct = freeSpaceInPageAlloc(6,1);
  801805:	83 ec 08             	sub    $0x8,%esp
  801808:	6a 01                	push   $0x1
  80180a:	6a 06                	push   $0x6
  80180c:	e8 90 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free original last 2MB allocation (should be MERGED with the prev 4MB created hole) => 6MB HOLE
		correct = freeSpaceInPageAlloc(8,1);
  801817:	83 ec 08             	sub    $0x8,%esp
  80181a:	6a 01                	push   $0x1
  80181c:	6a 08                	push   $0x8
  80181e:	e8 7e ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if (correct) eval += 5;
  801829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80182d:	74 04                	je     801833 <_main+0x734>
  80182f:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
	correct = 1;
  801833:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//8. Allocate after kfree [Test CUSTOM FIT in MERGED FREE SPACES]
	cprintf_colored(TEXT_cyan,"%~\n8. Allocate after free [Test CUSTOM FIT in MERGED FREE SPACES] [40%]\n");
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	68 74 4a 80 00       	push   $0x804a74
  801842:	6a 03                	push   $0x3
  801844:	e8 97 06 00 00       	call   801ee0 <cprintf_colored>
  801849:	83 c4 10             	add    $0x10,%esp
	{
		//3 MB [EXACT FIT in 3MB Hole]
		allocIndex = 20;
  80184c:	c7 45 d8 14 00 00 00 	movl   $0x14,-0x28(%ebp)
		size = 3*Mega - kilo;
  801853:	c7 45 dc 00 fc 2f 00 	movl   $0x2ffc00,-0x24(%ebp)
		expectedNumOfTables = 0;
  80185a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  801861:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801864:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801867:	52                   	push   %edx
  801868:	6a 01                	push   $0x1
  80186a:	ff 75 dc             	pushl  -0x24(%ebp)
  80186d:	50                   	push   %eax
  80186e:	e8 e6 e7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[1] ; //Address of 3MB Hole
  801879:	a1 24 60 80 00       	mov    0x806024,%eax
  80187e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  801881:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801884:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80188b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80188e:	74 2a                	je     8018ba <_main+0x7bb>
  801890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801897:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80189a:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8018a1:	83 ec 0c             	sub    $0xc,%esp
  8018a4:	50                   	push   %eax
  8018a5:	ff 75 d0             	pushl  -0x30(%ebp)
  8018a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8018ab:	68 c0 48 80 00       	push   $0x8048c0
  8018b0:	6a 0c                	push   $0xc
  8018b2:	e8 29 06 00 00       	call   801ee0 <cprintf_colored>
  8018b7:	83 c4 20             	add    $0x20,%esp

		//3 MB [WORST FIT in 6MB Hole]
		allocIndex = 21;
  8018ba:	c7 45 d8 15 00 00 00 	movl   $0x15,-0x28(%ebp)
		size = 3*Mega - kilo;
  8018c1:	c7 45 dc 00 fc 2f 00 	movl   $0x2ffc00,-0x24(%ebp)
		expectedNumOfTables = 0;
  8018c8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8018cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8018d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018d5:	52                   	push   %edx
  8018d6:	6a 01                	push   $0x1
  8018d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8018db:	50                   	push   %eax
  8018dc:	e8 78 e7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[5] ; //Address of 6MB Hole
  8018e7:	a1 34 60 80 00       	mov    0x806034,%eax
  8018ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8018ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018f2:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8018f9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018fc:	74 2a                	je     801928 <_main+0x829>
  8018fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801905:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801908:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80190f:	83 ec 0c             	sub    $0xc,%esp
  801912:	50                   	push   %eax
  801913:	ff 75 d0             	pushl  -0x30(%ebp)
  801916:	ff 75 d8             	pushl  -0x28(%ebp)
  801919:	68 c0 48 80 00       	push   $0x8048c0
  80191e:	6a 0c                	push   $0xc
  801920:	e8 bb 05 00 00       	call   801ee0 <cprintf_colored>
  801925:	83 c4 20             	add    $0x20,%esp

		//3MB - 4KB [WORST FIT in 4MB Hole]
		allocIndex = 22;
  801928:	c7 45 d8 16 00 00 00 	movl   $0x16,-0x28(%ebp)
		size = 3*Mega - 4*kilo;
  80192f:	c7 45 dc 00 f0 2f 00 	movl   $0x2ff000,-0x24(%ebp)
		expectedNumOfTables = 0;
  801936:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80193d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801940:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801943:	52                   	push   %edx
  801944:	6a 01                	push   $0x1
  801946:	ff 75 dc             	pushl  -0x24(%ebp)
  801949:	50                   	push   %eax
  80194a:	e8 0a e7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[3] ; //Address of 4MB Hole
  801955:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80195a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80195d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801960:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  801967:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80196a:	74 2a                	je     801996 <_main+0x897>
  80196c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801973:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801976:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	50                   	push   %eax
  801981:	ff 75 d0             	pushl  -0x30(%ebp)
  801984:	ff 75 d8             	pushl  -0x28(%ebp)
  801987:	68 c0 48 80 00       	push   $0x8048c0
  80198c:	6a 0c                	push   $0xc
  80198e:	e8 4d 05 00 00       	call   801ee0 <cprintf_colored>
  801993:	83 c4 20             	add    $0x20,%esp

		//3 MB [EXACT FIT in remaining of 6MB Hole]
		allocIndex = 23;
  801996:	c7 45 d8 17 00 00 00 	movl   $0x17,-0x28(%ebp)
		size = 3*Mega;
  80199d:	c7 45 dc 00 00 30 00 	movl   $0x300000,-0x24(%ebp)
		expectedNumOfTables = 0;
  8019a4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8019ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8019ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019b1:	52                   	push   %edx
  8019b2:	6a 01                	push   $0x1
  8019b4:	ff 75 dc             	pushl  -0x24(%ebp)
  8019b7:	50                   	push   %eax
  8019b8:	e8 9c e6 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[5] + 3*Mega ; //3MB after the start address of 6MB Hole
  8019c3:	a1 34 60 80 00       	mov    0x806034,%eax
  8019c8:	05 00 00 30 00       	add    $0x300000,%eax
  8019cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8019d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019d3:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8019da:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8019dd:	74 2a                	je     801a09 <_main+0x90a>
  8019df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8019e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019e9:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8019f0:	83 ec 0c             	sub    $0xc,%esp
  8019f3:	50                   	push   %eax
  8019f4:	ff 75 d0             	pushl  -0x30(%ebp)
  8019f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8019fa:	68 c0 48 80 00       	push   $0x8048c0
  8019ff:	6a 0c                	push   $0xc
  801a01:	e8 da 04 00 00       	call   801ee0 <cprintf_colored>
  801a06:	83 c4 20             	add    $0x20,%esp
	}
	if (correct) eval += 40;
  801a09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0d:	74 04                	je     801a13 <_main+0x914>
  801a0f:	83 45 f0 28          	addl   $0x28,-0x10(%ebp)
	correct = 1;
  801a13:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)


	cprintf_colored(TEXT_light_green, "%~\ntest CUSTOM FIT (1) [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	ff 75 f0             	pushl  -0x10(%ebp)
  801a20:	68 c0 4a 80 00       	push   $0x804ac0
  801a25:	6a 0a                	push   $0xa
  801a27:	e8 b4 04 00 00       	call   801ee0 <cprintf_colored>
  801a2c:	83 c4 10             	add    $0x10,%esp

	return;
  801a2f:	90                   	nop
#endif
}
  801a30:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	57                   	push   %edi
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
  801a3b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801a3e:	e8 f4 17 00 00       	call   803237 <sys_getenvindex>
  801a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801a46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a49:	89 d0                	mov    %edx,%eax
  801a4b:	c1 e0 02             	shl    $0x2,%eax
  801a4e:	01 d0                	add    %edx,%eax
  801a50:	c1 e0 03             	shl    $0x3,%eax
  801a53:	01 d0                	add    %edx,%eax
  801a55:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  801a5c:	01 d0                	add    %edx,%eax
  801a5e:	c1 e0 02             	shl    $0x2,%eax
  801a61:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a66:	a3 00 62 80 00       	mov    %eax,0x806200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801a6b:	a1 00 62 80 00       	mov    0x806200,%eax
  801a70:	8a 40 20             	mov    0x20(%eax),%al
  801a73:	84 c0                	test   %al,%al
  801a75:	74 0d                	je     801a84 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801a77:	a1 00 62 80 00       	mov    0x806200,%eax
  801a7c:	83 c0 20             	add    $0x20,%eax
  801a7f:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801a84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a88:	7e 0a                	jle    801a94 <libmain+0x5f>
		binaryname = argv[0];
  801a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8d:	8b 00                	mov    (%eax),%eax
  801a8f:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	ff 75 0c             	pushl  0xc(%ebp)
  801a9a:	ff 75 08             	pushl  0x8(%ebp)
  801a9d:	e8 5d f6 ff ff       	call   8010ff <_main>
  801aa2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801aa5:	a1 00 60 80 00       	mov    0x806000,%eax
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	0f 84 01 01 00 00    	je     801bb3 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801ab2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801ab8:	bb f8 4b 80 00       	mov    $0x804bf8,%ebx
  801abd:	ba 0e 00 00 00       	mov    $0xe,%edx
  801ac2:	89 c7                	mov    %eax,%edi
  801ac4:	89 de                	mov    %ebx,%esi
  801ac6:	89 d1                	mov    %edx,%ecx
  801ac8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801aca:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801acd:	b9 56 00 00 00       	mov    $0x56,%ecx
  801ad2:	b0 00                	mov    $0x0,%al
  801ad4:	89 d7                	mov    %edx,%edi
  801ad6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801ad8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801adf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	50                   	push   %eax
  801ae6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801aec:	50                   	push   %eax
  801aed:	e8 7b 19 00 00       	call   80346d <sys_utilities>
  801af2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801af5:	e8 c4 14 00 00       	call   802fbe <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801afa:	83 ec 0c             	sub    $0xc,%esp
  801afd:	68 18 4b 80 00       	push   $0x804b18
  801b02:	e8 ac 03 00 00       	call   801eb3 <cprintf>
  801b07:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801b0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	74 18                	je     801b29 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801b11:	e8 75 19 00 00       	call   80348b <sys_get_optimal_num_faults>
  801b16:	83 ec 08             	sub    $0x8,%esp
  801b19:	50                   	push   %eax
  801b1a:	68 40 4b 80 00       	push   $0x804b40
  801b1f:	e8 8f 03 00 00       	call   801eb3 <cprintf>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	eb 59                	jmp    801b82 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801b29:	a1 00 62 80 00       	mov    0x806200,%eax
  801b2e:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  801b34:	a1 00 62 80 00       	mov    0x806200,%eax
  801b39:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  801b3f:	83 ec 04             	sub    $0x4,%esp
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	68 64 4b 80 00       	push   $0x804b64
  801b49:	e8 65 03 00 00       	call   801eb3 <cprintf>
  801b4e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801b51:	a1 00 62 80 00       	mov    0x806200,%eax
  801b56:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801b5c:	a1 00 62 80 00       	mov    0x806200,%eax
  801b61:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  801b67:	a1 00 62 80 00       	mov    0x806200,%eax
  801b6c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801b72:	51                   	push   %ecx
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	68 8c 4b 80 00       	push   $0x804b8c
  801b7a:	e8 34 03 00 00       	call   801eb3 <cprintf>
  801b7f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801b82:	a1 00 62 80 00       	mov    0x806200,%eax
  801b87:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  801b8d:	83 ec 08             	sub    $0x8,%esp
  801b90:	50                   	push   %eax
  801b91:	68 e4 4b 80 00       	push   $0x804be4
  801b96:	e8 18 03 00 00       	call   801eb3 <cprintf>
  801b9b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801b9e:	83 ec 0c             	sub    $0xc,%esp
  801ba1:	68 18 4b 80 00       	push   $0x804b18
  801ba6:	e8 08 03 00 00       	call   801eb3 <cprintf>
  801bab:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801bae:	e8 25 14 00 00       	call   802fd8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801bb3:	e8 1f 00 00 00       	call   801bd7 <exit>
}
  801bb8:	90                   	nop
  801bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5f                   	pop    %edi
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    

00801bc1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801bc7:	83 ec 0c             	sub    $0xc,%esp
  801bca:	6a 00                	push   $0x0
  801bcc:	e8 32 16 00 00       	call   803203 <sys_destroy_env>
  801bd1:	83 c4 10             	add    $0x10,%esp
}
  801bd4:	90                   	nop
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <exit>:

void
exit(void)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801bdd:	e8 87 16 00 00       	call   803269 <sys_exit_env>
}
  801be2:	90                   	nop
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801beb:	8d 45 10             	lea    0x10(%ebp),%eax
  801bee:	83 c0 04             	add    $0x4,%eax
  801bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801bf4:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	74 16                	je     801c13 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801bfd:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801c02:	83 ec 08             	sub    $0x8,%esp
  801c05:	50                   	push   %eax
  801c06:	68 5c 4c 80 00       	push   $0x804c5c
  801c0b:	e8 a3 02 00 00       	call   801eb3 <cprintf>
  801c10:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801c13:	a1 04 60 80 00       	mov    0x806004,%eax
  801c18:	83 ec 0c             	sub    $0xc,%esp
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	50                   	push   %eax
  801c22:	68 64 4c 80 00       	push   $0x804c64
  801c27:	6a 74                	push   $0x74
  801c29:	e8 b2 02 00 00       	call   801ee0 <cprintf_colored>
  801c2e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	83 ec 08             	sub    $0x8,%esp
  801c37:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3a:	50                   	push   %eax
  801c3b:	e8 04 02 00 00       	call   801e44 <vcprintf>
  801c40:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801c43:	83 ec 08             	sub    $0x8,%esp
  801c46:	6a 00                	push   $0x0
  801c48:	68 8c 4c 80 00       	push   $0x804c8c
  801c4d:	e8 f2 01 00 00       	call   801e44 <vcprintf>
  801c52:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801c55:	e8 7d ff ff ff       	call   801bd7 <exit>

	// should not return here
	while (1) ;
  801c5a:	eb fe                	jmp    801c5a <_panic+0x75>

00801c5c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801c62:	a1 00 62 80 00       	mov    0x806200,%eax
  801c67:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c70:	39 c2                	cmp    %eax,%edx
  801c72:	74 14                	je     801c88 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	68 90 4c 80 00       	push   $0x804c90
  801c7c:	6a 26                	push   $0x26
  801c7e:	68 dc 4c 80 00       	push   $0x804cdc
  801c83:	e8 5d ff ff ff       	call   801be5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801c88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801c8f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801c96:	e9 c5 00 00 00       	jmp    801d60 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	01 d0                	add    %edx,%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	85 c0                	test   %eax,%eax
  801cae:	75 08                	jne    801cb8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801cb0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801cb3:	e9 a5 00 00 00       	jmp    801d5d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801cb8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cbf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801cc6:	eb 69                	jmp    801d31 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801cc8:	a1 00 62 80 00       	mov    0x806200,%eax
  801ccd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cd6:	89 d0                	mov    %edx,%eax
  801cd8:	01 c0                	add    %eax,%eax
  801cda:	01 d0                	add    %edx,%eax
  801cdc:	c1 e0 03             	shl    $0x3,%eax
  801cdf:	01 c8                	add    %ecx,%eax
  801ce1:	8a 40 04             	mov    0x4(%eax),%al
  801ce4:	84 c0                	test   %al,%al
  801ce6:	75 46                	jne    801d2e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ce8:	a1 00 62 80 00       	mov    0x806200,%eax
  801ced:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801cf3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cf6:	89 d0                	mov    %edx,%eax
  801cf8:	01 c0                	add    %eax,%eax
  801cfa:	01 d0                	add    %edx,%eax
  801cfc:	c1 e0 03             	shl    $0x3,%eax
  801cff:	01 c8                	add    %ecx,%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d13:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	01 c8                	add    %ecx,%eax
  801d1f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d21:	39 c2                	cmp    %eax,%edx
  801d23:	75 09                	jne    801d2e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801d25:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801d2c:	eb 15                	jmp    801d43 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d2e:	ff 45 e8             	incl   -0x18(%ebp)
  801d31:	a1 00 62 80 00       	mov    0x806200,%eax
  801d36:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801d3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d3f:	39 c2                	cmp    %eax,%edx
  801d41:	77 85                	ja     801cc8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801d43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d47:	75 14                	jne    801d5d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	68 e8 4c 80 00       	push   $0x804ce8
  801d51:	6a 3a                	push   $0x3a
  801d53:	68 dc 4c 80 00       	push   $0x804cdc
  801d58:	e8 88 fe ff ff       	call   801be5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801d5d:	ff 45 f0             	incl   -0x10(%ebp)
  801d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d63:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d66:	0f 8c 2f ff ff ff    	jl     801c9b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801d6c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d7a:	eb 26                	jmp    801da2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801d7c:	a1 00 62 80 00       	mov    0x806200,%eax
  801d81:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801d87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d8a:	89 d0                	mov    %edx,%eax
  801d8c:	01 c0                	add    %eax,%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c1 e0 03             	shl    $0x3,%eax
  801d93:	01 c8                	add    %ecx,%eax
  801d95:	8a 40 04             	mov    0x4(%eax),%al
  801d98:	3c 01                	cmp    $0x1,%al
  801d9a:	75 03                	jne    801d9f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801d9c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d9f:	ff 45 e0             	incl   -0x20(%ebp)
  801da2:	a1 00 62 80 00       	mov    0x806200,%eax
  801da7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db0:	39 c2                	cmp    %eax,%edx
  801db2:	77 c8                	ja     801d7c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801dba:	74 14                	je     801dd0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	68 3c 4d 80 00       	push   $0x804d3c
  801dc4:	6a 44                	push   $0x44
  801dc6:	68 dc 4c 80 00       	push   $0x804cdc
  801dcb:	e8 15 fe ff ff       	call   801be5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	53                   	push   %ebx
  801dd7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddd:	8b 00                	mov    (%eax),%eax
  801ddf:	8d 48 01             	lea    0x1(%eax),%ecx
  801de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de5:	89 0a                	mov    %ecx,(%edx)
  801de7:	8b 55 08             	mov    0x8(%ebp),%edx
  801dea:	88 d1                	mov    %dl,%cl
  801dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801def:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df6:	8b 00                	mov    (%eax),%eax
  801df8:	3d ff 00 00 00       	cmp    $0xff,%eax
  801dfd:	75 30                	jne    801e2f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801dff:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  801e05:	a0 24 62 80 00       	mov    0x806224,%al
  801e0a:	0f b6 c0             	movzbl %al,%eax
  801e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e10:	8b 09                	mov    (%ecx),%ecx
  801e12:	89 cb                	mov    %ecx,%ebx
  801e14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e17:	83 c1 08             	add    $0x8,%ecx
  801e1a:	52                   	push   %edx
  801e1b:	50                   	push   %eax
  801e1c:	53                   	push   %ebx
  801e1d:	51                   	push   %ecx
  801e1e:	e8 57 11 00 00       	call   802f7a <sys_cputs>
  801e23:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e32:	8b 40 04             	mov    0x4(%eax),%eax
  801e35:	8d 50 01             	lea    0x1(%eax),%edx
  801e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3b:	89 50 04             	mov    %edx,0x4(%eax)
}
  801e3e:	90                   	nop
  801e3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801e4d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801e54:	00 00 00 
	b.cnt = 0;
  801e57:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801e5e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801e61:	ff 75 0c             	pushl  0xc(%ebp)
  801e64:	ff 75 08             	pushl  0x8(%ebp)
  801e67:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e6d:	50                   	push   %eax
  801e6e:	68 d3 1d 80 00       	push   $0x801dd3
  801e73:	e8 5a 02 00 00       	call   8020d2 <vprintfmt>
  801e78:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801e7b:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  801e81:	a0 24 62 80 00       	mov    0x806224,%al
  801e86:	0f b6 c0             	movzbl %al,%eax
  801e89:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801e8f:	52                   	push   %edx
  801e90:	50                   	push   %eax
  801e91:	51                   	push   %ecx
  801e92:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e98:	83 c0 08             	add    $0x8,%eax
  801e9b:	50                   	push   %eax
  801e9c:	e8 d9 10 00 00       	call   802f7a <sys_cputs>
  801ea1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801ea4:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
	return b.cnt;
  801eab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801eb9:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	va_start(ap, fmt);
  801ec0:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	83 ec 08             	sub    $0x8,%esp
  801ecc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ecf:	50                   	push   %eax
  801ed0:	e8 6f ff ff ff       	call   801e44 <vcprintf>
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801ee6:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	c1 e0 08             	shl    $0x8,%eax
  801ef3:	a3 fc e2 81 00       	mov    %eax,0x81e2fc
	va_start(ap, fmt);
  801ef8:	8d 45 0c             	lea    0xc(%ebp),%eax
  801efb:	83 c0 04             	add    $0x4,%eax
  801efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f04:	83 ec 08             	sub    $0x8,%esp
  801f07:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0a:	50                   	push   %eax
  801f0b:	e8 34 ff ff ff       	call   801e44 <vcprintf>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801f16:	c7 05 fc e2 81 00 00 	movl   $0x700,0x81e2fc
  801f1d:	07 00 00 

	return cnt;
  801f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801f2b:	e8 8e 10 00 00       	call   802fbe <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  801f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	83 ec 08             	sub    $0x8,%esp
  801f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3f:	50                   	push   %eax
  801f40:	e8 ff fe ff ff       	call   801e44 <vcprintf>
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801f4b:	e8 88 10 00 00       	call   802fd8 <sys_unlock_cons>
	return cnt;
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	53                   	push   %ebx
  801f59:	83 ec 14             	sub    $0x14,%esp
  801f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f62:	8b 45 14             	mov    0x14(%ebp),%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801f68:	8b 45 18             	mov    0x18(%ebp),%eax
  801f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801f73:	77 55                	ja     801fca <printnum+0x75>
  801f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801f78:	72 05                	jb     801f7f <printnum+0x2a>
  801f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f7d:	77 4b                	ja     801fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801f85:	8b 45 18             	mov    0x18(%ebp),%eax
  801f88:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8d:	52                   	push   %edx
  801f8e:	50                   	push   %eax
  801f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f92:	ff 75 f0             	pushl  -0x10(%ebp)
  801f95:	e8 06 20 00 00       	call   803fa0 <__udivdi3>
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	ff 75 20             	pushl  0x20(%ebp)
  801fa3:	53                   	push   %ebx
  801fa4:	ff 75 18             	pushl  0x18(%ebp)
  801fa7:	52                   	push   %edx
  801fa8:	50                   	push   %eax
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	ff 75 08             	pushl  0x8(%ebp)
  801faf:	e8 a1 ff ff ff       	call   801f55 <printnum>
  801fb4:	83 c4 20             	add    $0x20,%esp
  801fb7:	eb 1a                	jmp    801fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801fb9:	83 ec 08             	sub    $0x8,%esp
  801fbc:	ff 75 0c             	pushl  0xc(%ebp)
  801fbf:	ff 75 20             	pushl  0x20(%ebp)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	ff d0                	call   *%eax
  801fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801fca:	ff 4d 1c             	decl   0x1c(%ebp)
  801fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801fd1:	7f e6                	jg     801fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe1:	53                   	push   %ebx
  801fe2:	51                   	push   %ecx
  801fe3:	52                   	push   %edx
  801fe4:	50                   	push   %eax
  801fe5:	e8 c6 20 00 00       	call   8040b0 <__umoddi3>
  801fea:	83 c4 10             	add    $0x10,%esp
  801fed:	05 b4 4f 80 00       	add    $0x804fb4,%eax
  801ff2:	8a 00                	mov    (%eax),%al
  801ff4:	0f be c0             	movsbl %al,%eax
  801ff7:	83 ec 08             	sub    $0x8,%esp
  801ffa:	ff 75 0c             	pushl  0xc(%ebp)
  801ffd:	50                   	push   %eax
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	ff d0                	call   *%eax
  802003:	83 c4 10             	add    $0x10,%esp
}
  802006:	90                   	nop
  802007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80200f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  802013:	7e 1c                	jle    802031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	8b 00                	mov    (%eax),%eax
  80201a:	8d 50 08             	lea    0x8(%eax),%edx
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	89 10                	mov    %edx,(%eax)
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	83 e8 08             	sub    $0x8,%eax
  80202a:	8b 50 04             	mov    0x4(%eax),%edx
  80202d:	8b 00                	mov    (%eax),%eax
  80202f:	eb 40                	jmp    802071 <getuint+0x65>
	else if (lflag)
  802031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802035:	74 1e                	je     802055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	8b 00                	mov    (%eax),%eax
  80203c:	8d 50 04             	lea    0x4(%eax),%edx
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	89 10                	mov    %edx,(%eax)
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	8b 00                	mov    (%eax),%eax
  802049:	83 e8 04             	sub    $0x4,%eax
  80204c:	8b 00                	mov    (%eax),%eax
  80204e:	ba 00 00 00 00       	mov    $0x0,%edx
  802053:	eb 1c                	jmp    802071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	8b 00                	mov    (%eax),%eax
  80205a:	8d 50 04             	lea    0x4(%eax),%edx
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	89 10                	mov    %edx,(%eax)
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	8b 00                	mov    (%eax),%eax
  802067:	83 e8 04             	sub    $0x4,%eax
  80206a:	8b 00                	mov    (%eax),%eax
  80206c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  802071:	5d                   	pop    %ebp
  802072:	c3                   	ret    

00802073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  802076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80207a:	7e 1c                	jle    802098 <getint+0x25>
		return va_arg(*ap, long long);
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	8b 00                	mov    (%eax),%eax
  802081:	8d 50 08             	lea    0x8(%eax),%edx
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	89 10                	mov    %edx,(%eax)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	8b 00                	mov    (%eax),%eax
  80208e:	83 e8 08             	sub    $0x8,%eax
  802091:	8b 50 04             	mov    0x4(%eax),%edx
  802094:	8b 00                	mov    (%eax),%eax
  802096:	eb 38                	jmp    8020d0 <getint+0x5d>
	else if (lflag)
  802098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80209c:	74 1a                	je     8020b8 <getint+0x45>
		return va_arg(*ap, long);
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	8b 00                	mov    (%eax),%eax
  8020a3:	8d 50 04             	lea    0x4(%eax),%edx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	89 10                	mov    %edx,(%eax)
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	8b 00                	mov    (%eax),%eax
  8020b0:	83 e8 04             	sub    $0x4,%eax
  8020b3:	8b 00                	mov    (%eax),%eax
  8020b5:	99                   	cltd   
  8020b6:	eb 18                	jmp    8020d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	8b 00                	mov    (%eax),%eax
  8020bd:	8d 50 04             	lea    0x4(%eax),%edx
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	89 10                	mov    %edx,(%eax)
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8b 00                	mov    (%eax),%eax
  8020ca:	83 e8 04             	sub    $0x4,%eax
  8020cd:	8b 00                	mov    (%eax),%eax
  8020cf:	99                   	cltd   
}
  8020d0:	5d                   	pop    %ebp
  8020d1:	c3                   	ret    

008020d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	56                   	push   %esi
  8020d6:	53                   	push   %ebx
  8020d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8020da:	eb 17                	jmp    8020f3 <vprintfmt+0x21>
			if (ch == '\0')
  8020dc:	85 db                	test   %ebx,%ebx
  8020de:	0f 84 c1 03 00 00    	je     8024a5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8020e4:	83 ec 08             	sub    $0x8,%esp
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	53                   	push   %ebx
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	ff d0                	call   *%eax
  8020f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8020f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f6:	8d 50 01             	lea    0x1(%eax),%edx
  8020f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8020fc:	8a 00                	mov    (%eax),%al
  8020fe:	0f b6 d8             	movzbl %al,%ebx
  802101:	83 fb 25             	cmp    $0x25,%ebx
  802104:	75 d6                	jne    8020dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80210a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  802111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  802118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80211f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802126:	8b 45 10             	mov    0x10(%ebp),%eax
  802129:	8d 50 01             	lea    0x1(%eax),%edx
  80212c:	89 55 10             	mov    %edx,0x10(%ebp)
  80212f:	8a 00                	mov    (%eax),%al
  802131:	0f b6 d8             	movzbl %al,%ebx
  802134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  802137:	83 f8 5b             	cmp    $0x5b,%eax
  80213a:	0f 87 3d 03 00 00    	ja     80247d <vprintfmt+0x3ab>
  802140:	8b 04 85 d8 4f 80 00 	mov    0x804fd8(,%eax,4),%eax
  802147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  802149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80214d:	eb d7                	jmp    802126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80214f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  802153:	eb d1                	jmp    802126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80215c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80215f:	89 d0                	mov    %edx,%eax
  802161:	c1 e0 02             	shl    $0x2,%eax
  802164:	01 d0                	add    %edx,%eax
  802166:	01 c0                	add    %eax,%eax
  802168:	01 d8                	add    %ebx,%eax
  80216a:	83 e8 30             	sub    $0x30,%eax
  80216d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  802170:	8b 45 10             	mov    0x10(%ebp),%eax
  802173:	8a 00                	mov    (%eax),%al
  802175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802178:	83 fb 2f             	cmp    $0x2f,%ebx
  80217b:	7e 3e                	jle    8021bb <vprintfmt+0xe9>
  80217d:	83 fb 39             	cmp    $0x39,%ebx
  802180:	7f 39                	jg     8021bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802185:	eb d5                	jmp    80215c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  802187:	8b 45 14             	mov    0x14(%ebp),%eax
  80218a:	83 c0 04             	add    $0x4,%eax
  80218d:	89 45 14             	mov    %eax,0x14(%ebp)
  802190:	8b 45 14             	mov    0x14(%ebp),%eax
  802193:	83 e8 04             	sub    $0x4,%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80219b:	eb 1f                	jmp    8021bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80219d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021a1:	79 83                	jns    802126 <vprintfmt+0x54>
				width = 0;
  8021a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8021aa:	e9 77 ff ff ff       	jmp    802126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8021af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8021b6:	e9 6b ff ff ff       	jmp    802126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8021bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8021bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021c0:	0f 89 60 ff ff ff    	jns    802126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8021c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8021d3:	e9 4e ff ff ff       	jmp    802126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8021d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8021db:	e9 46 ff ff ff       	jmp    802126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8021e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e3:	83 c0 04             	add    $0x4,%eax
  8021e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8021e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ec:	83 e8 04             	sub    $0x4,%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	83 ec 08             	sub    $0x8,%esp
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	50                   	push   %eax
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	ff d0                	call   *%eax
  8021fd:	83 c4 10             	add    $0x10,%esp
			break;
  802200:	e9 9b 02 00 00       	jmp    8024a0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  802205:	8b 45 14             	mov    0x14(%ebp),%eax
  802208:	83 c0 04             	add    $0x4,%eax
  80220b:	89 45 14             	mov    %eax,0x14(%ebp)
  80220e:	8b 45 14             	mov    0x14(%ebp),%eax
  802211:	83 e8 04             	sub    $0x4,%eax
  802214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  802216:	85 db                	test   %ebx,%ebx
  802218:	79 02                	jns    80221c <vprintfmt+0x14a>
				err = -err;
  80221a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80221c:	83 fb 64             	cmp    $0x64,%ebx
  80221f:	7f 0b                	jg     80222c <vprintfmt+0x15a>
  802221:	8b 34 9d 20 4e 80 00 	mov    0x804e20(,%ebx,4),%esi
  802228:	85 f6                	test   %esi,%esi
  80222a:	75 19                	jne    802245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80222c:	53                   	push   %ebx
  80222d:	68 c5 4f 80 00       	push   $0x804fc5
  802232:	ff 75 0c             	pushl  0xc(%ebp)
  802235:	ff 75 08             	pushl  0x8(%ebp)
  802238:	e8 70 02 00 00       	call   8024ad <printfmt>
  80223d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802240:	e9 5b 02 00 00       	jmp    8024a0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802245:	56                   	push   %esi
  802246:	68 ce 4f 80 00       	push   $0x804fce
  80224b:	ff 75 0c             	pushl  0xc(%ebp)
  80224e:	ff 75 08             	pushl  0x8(%ebp)
  802251:	e8 57 02 00 00       	call   8024ad <printfmt>
  802256:	83 c4 10             	add    $0x10,%esp
			break;
  802259:	e9 42 02 00 00       	jmp    8024a0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80225e:	8b 45 14             	mov    0x14(%ebp),%eax
  802261:	83 c0 04             	add    $0x4,%eax
  802264:	89 45 14             	mov    %eax,0x14(%ebp)
  802267:	8b 45 14             	mov    0x14(%ebp),%eax
  80226a:	83 e8 04             	sub    $0x4,%eax
  80226d:	8b 30                	mov    (%eax),%esi
  80226f:	85 f6                	test   %esi,%esi
  802271:	75 05                	jne    802278 <vprintfmt+0x1a6>
				p = "(null)";
  802273:	be d1 4f 80 00       	mov    $0x804fd1,%esi
			if (width > 0 && padc != '-')
  802278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80227c:	7e 6d                	jle    8022eb <vprintfmt+0x219>
  80227e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  802282:	74 67                	je     8022eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  802284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802287:	83 ec 08             	sub    $0x8,%esp
  80228a:	50                   	push   %eax
  80228b:	56                   	push   %esi
  80228c:	e8 1e 03 00 00       	call   8025af <strnlen>
  802291:	83 c4 10             	add    $0x10,%esp
  802294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  802297:	eb 16                	jmp    8022af <vprintfmt+0x1dd>
					putch(padc, putdat);
  802299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80229d:	83 ec 08             	sub    $0x8,%esp
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	50                   	push   %eax
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	ff d0                	call   *%eax
  8022a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8022ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8022af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022b3:	7f e4                	jg     802299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8022b5:	eb 34                	jmp    8022eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8022b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8022bb:	74 1c                	je     8022d9 <vprintfmt+0x207>
  8022bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8022c0:	7e 05                	jle    8022c7 <vprintfmt+0x1f5>
  8022c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8022c5:	7e 12                	jle    8022d9 <vprintfmt+0x207>
					putch('?', putdat);
  8022c7:	83 ec 08             	sub    $0x8,%esp
  8022ca:	ff 75 0c             	pushl  0xc(%ebp)
  8022cd:	6a 3f                	push   $0x3f
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	ff d0                	call   *%eax
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	eb 0f                	jmp    8022e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8022d9:	83 ec 08             	sub    $0x8,%esp
  8022dc:	ff 75 0c             	pushl  0xc(%ebp)
  8022df:	53                   	push   %ebx
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	ff d0                	call   *%eax
  8022e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8022e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8022eb:	89 f0                	mov    %esi,%eax
  8022ed:	8d 70 01             	lea    0x1(%eax),%esi
  8022f0:	8a 00                	mov    (%eax),%al
  8022f2:	0f be d8             	movsbl %al,%ebx
  8022f5:	85 db                	test   %ebx,%ebx
  8022f7:	74 24                	je     80231d <vprintfmt+0x24b>
  8022f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022fd:	78 b8                	js     8022b7 <vprintfmt+0x1e5>
  8022ff:	ff 4d e0             	decl   -0x20(%ebp)
  802302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802306:	79 af                	jns    8022b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802308:	eb 13                	jmp    80231d <vprintfmt+0x24b>
				putch(' ', putdat);
  80230a:	83 ec 08             	sub    $0x8,%esp
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	6a 20                	push   $0x20
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	ff d0                	call   *%eax
  802317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80231a:	ff 4d e4             	decl   -0x1c(%ebp)
  80231d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802321:	7f e7                	jg     80230a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  802323:	e9 78 01 00 00       	jmp    8024a0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  802328:	83 ec 08             	sub    $0x8,%esp
  80232b:	ff 75 e8             	pushl  -0x18(%ebp)
  80232e:	8d 45 14             	lea    0x14(%ebp),%eax
  802331:	50                   	push   %eax
  802332:	e8 3c fd ff ff       	call   802073 <getint>
  802337:	83 c4 10             	add    $0x10,%esp
  80233a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80233d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802346:	85 d2                	test   %edx,%edx
  802348:	79 23                	jns    80236d <vprintfmt+0x29b>
				putch('-', putdat);
  80234a:	83 ec 08             	sub    $0x8,%esp
  80234d:	ff 75 0c             	pushl  0xc(%ebp)
  802350:	6a 2d                	push   $0x2d
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	ff d0                	call   *%eax
  802357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802360:	f7 d8                	neg    %eax
  802362:	83 d2 00             	adc    $0x0,%edx
  802365:	f7 da                	neg    %edx
  802367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80236a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80236d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802374:	e9 bc 00 00 00       	jmp    802435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802379:	83 ec 08             	sub    $0x8,%esp
  80237c:	ff 75 e8             	pushl  -0x18(%ebp)
  80237f:	8d 45 14             	lea    0x14(%ebp),%eax
  802382:	50                   	push   %eax
  802383:	e8 84 fc ff ff       	call   80200c <getuint>
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80238e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802398:	e9 98 00 00 00       	jmp    802435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80239d:	83 ec 08             	sub    $0x8,%esp
  8023a0:	ff 75 0c             	pushl  0xc(%ebp)
  8023a3:	6a 58                	push   $0x58
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	ff d0                	call   *%eax
  8023aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8023ad:	83 ec 08             	sub    $0x8,%esp
  8023b0:	ff 75 0c             	pushl  0xc(%ebp)
  8023b3:	6a 58                	push   $0x58
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	ff d0                	call   *%eax
  8023ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8023bd:	83 ec 08             	sub    $0x8,%esp
  8023c0:	ff 75 0c             	pushl  0xc(%ebp)
  8023c3:	6a 58                	push   $0x58
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	ff d0                	call   *%eax
  8023ca:	83 c4 10             	add    $0x10,%esp
			break;
  8023cd:	e9 ce 00 00 00       	jmp    8024a0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8023d2:	83 ec 08             	sub    $0x8,%esp
  8023d5:	ff 75 0c             	pushl  0xc(%ebp)
  8023d8:	6a 30                	push   $0x30
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	ff d0                	call   *%eax
  8023df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8023e2:	83 ec 08             	sub    $0x8,%esp
  8023e5:	ff 75 0c             	pushl  0xc(%ebp)
  8023e8:	6a 78                	push   $0x78
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	ff d0                	call   *%eax
  8023ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8023f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f5:	83 c0 04             	add    $0x4,%eax
  8023f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8023fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8023fe:	83 e8 04             	sub    $0x4,%eax
  802401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80240d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  802414:	eb 1f                	jmp    802435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802416:	83 ec 08             	sub    $0x8,%esp
  802419:	ff 75 e8             	pushl  -0x18(%ebp)
  80241c:	8d 45 14             	lea    0x14(%ebp),%eax
  80241f:	50                   	push   %eax
  802420:	e8 e7 fb ff ff       	call   80200c <getuint>
  802425:	83 c4 10             	add    $0x10,%esp
  802428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80242b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80242e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  802439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	52                   	push   %edx
  802440:	ff 75 e4             	pushl  -0x1c(%ebp)
  802443:	50                   	push   %eax
  802444:	ff 75 f4             	pushl  -0xc(%ebp)
  802447:	ff 75 f0             	pushl  -0x10(%ebp)
  80244a:	ff 75 0c             	pushl  0xc(%ebp)
  80244d:	ff 75 08             	pushl  0x8(%ebp)
  802450:	e8 00 fb ff ff       	call   801f55 <printnum>
  802455:	83 c4 20             	add    $0x20,%esp
			break;
  802458:	eb 46                	jmp    8024a0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80245a:	83 ec 08             	sub    $0x8,%esp
  80245d:	ff 75 0c             	pushl  0xc(%ebp)
  802460:	53                   	push   %ebx
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	ff d0                	call   *%eax
  802466:	83 c4 10             	add    $0x10,%esp
			break;
  802469:	eb 35                	jmp    8024a0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80246b:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
			break;
  802472:	eb 2c                	jmp    8024a0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  802474:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
			break;
  80247b:	eb 23                	jmp    8024a0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80247d:	83 ec 08             	sub    $0x8,%esp
  802480:	ff 75 0c             	pushl  0xc(%ebp)
  802483:	6a 25                	push   $0x25
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	ff d0                	call   *%eax
  80248a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80248d:	ff 4d 10             	decl   0x10(%ebp)
  802490:	eb 03                	jmp    802495 <vprintfmt+0x3c3>
  802492:	ff 4d 10             	decl   0x10(%ebp)
  802495:	8b 45 10             	mov    0x10(%ebp),%eax
  802498:	48                   	dec    %eax
  802499:	8a 00                	mov    (%eax),%al
  80249b:	3c 25                	cmp    $0x25,%al
  80249d:	75 f3                	jne    802492 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80249f:	90                   	nop
		}
	}
  8024a0:	e9 35 fc ff ff       	jmp    8020da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8024a5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8024a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024a9:	5b                   	pop    %ebx
  8024aa:	5e                   	pop    %esi
  8024ab:	5d                   	pop    %ebp
  8024ac:	c3                   	ret    

008024ad <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8024b3:	8d 45 10             	lea    0x10(%ebp),%eax
  8024b6:	83 c0 04             	add    $0x4,%eax
  8024b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8024bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c2:	50                   	push   %eax
  8024c3:	ff 75 0c             	pushl  0xc(%ebp)
  8024c6:	ff 75 08             	pushl  0x8(%ebp)
  8024c9:	e8 04 fc ff ff       	call   8020d2 <vprintfmt>
  8024ce:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8024d1:	90                   	nop
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	8b 40 08             	mov    0x8(%eax),%eax
  8024dd:	8d 50 01             	lea    0x1(%eax),%edx
  8024e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8024e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e9:	8b 10                	mov    (%eax),%edx
  8024eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	39 c2                	cmp    %eax,%edx
  8024f3:	73 12                	jae    802507 <sprintputch+0x33>
		*b->buf++ = ch;
  8024f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8024fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802500:	89 0a                	mov    %ecx,(%edx)
  802502:	8b 55 08             	mov    0x8(%ebp),%edx
  802505:	88 10                	mov    %dl,(%eax)
}
  802507:	90                   	nop
  802508:	5d                   	pop    %ebp
  802509:	c3                   	ret    

0080250a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802516:	8b 45 0c             	mov    0xc(%ebp),%eax
  802519:	8d 50 ff             	lea    -0x1(%eax),%edx
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	01 d0                	add    %edx,%eax
  802521:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80252b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80252f:	74 06                	je     802537 <vsnprintf+0x2d>
  802531:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802535:	7f 07                	jg     80253e <vsnprintf+0x34>
		return -E_INVAL;
  802537:	b8 03 00 00 00       	mov    $0x3,%eax
  80253c:	eb 20                	jmp    80255e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80253e:	ff 75 14             	pushl  0x14(%ebp)
  802541:	ff 75 10             	pushl  0x10(%ebp)
  802544:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802547:	50                   	push   %eax
  802548:	68 d4 24 80 00       	push   $0x8024d4
  80254d:	e8 80 fb ff ff       	call   8020d2 <vprintfmt>
  802552:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802558:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802566:	8d 45 10             	lea    0x10(%ebp),%eax
  802569:	83 c0 04             	add    $0x4,%eax
  80256c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80256f:	8b 45 10             	mov    0x10(%ebp),%eax
  802572:	ff 75 f4             	pushl  -0xc(%ebp)
  802575:	50                   	push   %eax
  802576:	ff 75 0c             	pushl  0xc(%ebp)
  802579:	ff 75 08             	pushl  0x8(%ebp)
  80257c:	e8 89 ff ff ff       	call   80250a <vsnprintf>
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802587:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802592:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802599:	eb 06                	jmp    8025a1 <strlen+0x15>
		n++;
  80259b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80259e:	ff 45 08             	incl   0x8(%ebp)
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	8a 00                	mov    (%eax),%al
  8025a6:	84 c0                	test   %al,%al
  8025a8:	75 f1                	jne    80259b <strlen+0xf>
		n++;
	return n;
  8025aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8025b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025bc:	eb 09                	jmp    8025c7 <strnlen+0x18>
		n++;
  8025be:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8025c1:	ff 45 08             	incl   0x8(%ebp)
  8025c4:	ff 4d 0c             	decl   0xc(%ebp)
  8025c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025cb:	74 09                	je     8025d6 <strnlen+0x27>
  8025cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d0:	8a 00                	mov    (%eax),%al
  8025d2:	84 c0                	test   %al,%al
  8025d4:	75 e8                	jne    8025be <strnlen+0xf>
		n++;
	return n;
  8025d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8025e7:	90                   	nop
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	8d 50 01             	lea    0x1(%eax),%edx
  8025ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8025f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8025f7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8025fa:	8a 12                	mov    (%edx),%dl
  8025fc:	88 10                	mov    %dl,(%eax)
  8025fe:	8a 00                	mov    (%eax),%al
  802600:	84 c0                	test   %al,%al
  802602:	75 e4                	jne    8025e8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  802604:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802615:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80261c:	eb 1f                	jmp    80263d <strncpy+0x34>
		*dst++ = *src;
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	8d 50 01             	lea    0x1(%eax),%edx
  802624:	89 55 08             	mov    %edx,0x8(%ebp)
  802627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262a:	8a 12                	mov    (%edx),%dl
  80262c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80262e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802631:	8a 00                	mov    (%eax),%al
  802633:	84 c0                	test   %al,%al
  802635:	74 03                	je     80263a <strncpy+0x31>
			src++;
  802637:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80263a:	ff 45 fc             	incl   -0x4(%ebp)
  80263d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802640:	3b 45 10             	cmp    0x10(%ebp),%eax
  802643:	72 d9                	jb     80261e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802645:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802656:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80265a:	74 30                	je     80268c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80265c:	eb 16                	jmp    802674 <strlcpy+0x2a>
			*dst++ = *src++;
  80265e:	8b 45 08             	mov    0x8(%ebp),%eax
  802661:	8d 50 01             	lea    0x1(%eax),%edx
  802664:	89 55 08             	mov    %edx,0x8(%ebp)
  802667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80266d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802670:	8a 12                	mov    (%edx),%dl
  802672:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802674:	ff 4d 10             	decl   0x10(%ebp)
  802677:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80267b:	74 09                	je     802686 <strlcpy+0x3c>
  80267d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802680:	8a 00                	mov    (%eax),%al
  802682:	84 c0                	test   %al,%al
  802684:	75 d8                	jne    80265e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80268c:	8b 55 08             	mov    0x8(%ebp),%edx
  80268f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802692:	29 c2                	sub    %eax,%edx
  802694:	89 d0                	mov    %edx,%eax
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80269b:	eb 06                	jmp    8026a3 <strcmp+0xb>
		p++, q++;
  80269d:	ff 45 08             	incl   0x8(%ebp)
  8026a0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	8a 00                	mov    (%eax),%al
  8026a8:	84 c0                	test   %al,%al
  8026aa:	74 0e                	je     8026ba <strcmp+0x22>
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	8a 10                	mov    (%eax),%dl
  8026b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b4:	8a 00                	mov    (%eax),%al
  8026b6:	38 c2                	cmp    %al,%dl
  8026b8:	74 e3                	je     80269d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	8a 00                	mov    (%eax),%al
  8026bf:	0f b6 d0             	movzbl %al,%edx
  8026c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c5:	8a 00                	mov    (%eax),%al
  8026c7:	0f b6 c0             	movzbl %al,%eax
  8026ca:	29 c2                	sub    %eax,%edx
  8026cc:	89 d0                	mov    %edx,%eax
}
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    

008026d0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8026d3:	eb 09                	jmp    8026de <strncmp+0xe>
		n--, p++, q++;
  8026d5:	ff 4d 10             	decl   0x10(%ebp)
  8026d8:	ff 45 08             	incl   0x8(%ebp)
  8026db:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8026de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026e2:	74 17                	je     8026fb <strncmp+0x2b>
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	8a 00                	mov    (%eax),%al
  8026e9:	84 c0                	test   %al,%al
  8026eb:	74 0e                	je     8026fb <strncmp+0x2b>
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	8a 10                	mov    (%eax),%dl
  8026f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f5:	8a 00                	mov    (%eax),%al
  8026f7:	38 c2                	cmp    %al,%dl
  8026f9:	74 da                	je     8026d5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8026fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026ff:	75 07                	jne    802708 <strncmp+0x38>
		return 0;
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
  802706:	eb 14                	jmp    80271c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	8a 00                	mov    (%eax),%al
  80270d:	0f b6 d0             	movzbl %al,%edx
  802710:	8b 45 0c             	mov    0xc(%ebp),%eax
  802713:	8a 00                	mov    (%eax),%al
  802715:	0f b6 c0             	movzbl %al,%eax
  802718:	29 c2                	sub    %eax,%edx
  80271a:	89 d0                	mov    %edx,%eax
}
  80271c:	5d                   	pop    %ebp
  80271d:	c3                   	ret    

0080271e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 04             	sub    $0x4,%esp
  802724:	8b 45 0c             	mov    0xc(%ebp),%eax
  802727:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80272a:	eb 12                	jmp    80273e <strchr+0x20>
		if (*s == c)
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	8a 00                	mov    (%eax),%al
  802731:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802734:	75 05                	jne    80273b <strchr+0x1d>
			return (char *) s;
  802736:	8b 45 08             	mov    0x8(%ebp),%eax
  802739:	eb 11                	jmp    80274c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80273b:	ff 45 08             	incl   0x8(%ebp)
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	8a 00                	mov    (%eax),%al
  802743:	84 c0                	test   %al,%al
  802745:	75 e5                	jne    80272c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802747:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	83 ec 04             	sub    $0x4,%esp
  802754:	8b 45 0c             	mov    0xc(%ebp),%eax
  802757:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80275a:	eb 0d                	jmp    802769 <strfind+0x1b>
		if (*s == c)
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	8a 00                	mov    (%eax),%al
  802761:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802764:	74 0e                	je     802774 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802766:	ff 45 08             	incl   0x8(%ebp)
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	8a 00                	mov    (%eax),%al
  80276e:	84 c0                	test   %al,%al
  802770:	75 ea                	jne    80275c <strfind+0xe>
  802772:	eb 01                	jmp    802775 <strfind+0x27>
		if (*s == c)
			break;
  802774:	90                   	nop
	return (char *) s;
  802775:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802786:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80278a:	76 63                	jbe    8027ef <memset+0x75>
		uint64 data_block = c;
  80278c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278f:	99                   	cltd   
  802790:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802793:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8027a0:	c1 e0 08             	shl    $0x8,%eax
  8027a3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8027a6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027af:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8027b3:	c1 e0 10             	shl    $0x10,%eax
  8027b6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8027b9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c2:	89 c2                	mov    %eax,%edx
  8027c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c9:	09 45 f0             	or     %eax,-0x10(%ebp)
  8027cc:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8027cf:	eb 18                	jmp    8027e9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8027d1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8027d4:	8d 41 08             	lea    0x8(%ecx),%eax
  8027d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e0:	89 01                	mov    %eax,(%ecx)
  8027e2:	89 51 04             	mov    %edx,0x4(%ecx)
  8027e5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8027e9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8027ed:	77 e2                	ja     8027d1 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8027ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027f3:	74 23                	je     802818 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8027f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8027fb:	eb 0e                	jmp    80280b <memset+0x91>
			*p8++ = (uint8)c;
  8027fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802800:	8d 50 01             	lea    0x1(%eax),%edx
  802803:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802806:	8b 55 0c             	mov    0xc(%ebp),%edx
  802809:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80280b:	8b 45 10             	mov    0x10(%ebp),%eax
  80280e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802811:	89 55 10             	mov    %edx,0x10(%ebp)
  802814:	85 c0                	test   %eax,%eax
  802816:	75 e5                	jne    8027fd <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802818:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802823:	8b 45 0c             	mov    0xc(%ebp),%eax
  802826:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80282f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802833:	76 24                	jbe    802859 <memcpy+0x3c>
		while(n >= 8){
  802835:	eb 1c                	jmp    802853 <memcpy+0x36>
			*d64 = *s64;
  802837:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80283a:	8b 50 04             	mov    0x4(%eax),%edx
  80283d:	8b 00                	mov    (%eax),%eax
  80283f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802842:	89 01                	mov    %eax,(%ecx)
  802844:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802847:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80284b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80284f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802853:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802857:	77 de                	ja     802837 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802859:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80285d:	74 31                	je     802890 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80285f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802862:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802865:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802868:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80286b:	eb 16                	jmp    802883 <memcpy+0x66>
			*d8++ = *s8++;
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	8d 50 01             	lea    0x1(%eax),%edx
  802873:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802879:	8d 4a 01             	lea    0x1(%edx),%ecx
  80287c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80287f:	8a 12                	mov    (%edx),%dl
  802881:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802883:	8b 45 10             	mov    0x10(%ebp),%eax
  802886:	8d 50 ff             	lea    -0x1(%eax),%edx
  802889:	89 55 10             	mov    %edx,0x10(%ebp)
  80288c:	85 c0                	test   %eax,%eax
  80288e:	75 dd                	jne    80286d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802893:	c9                   	leave  
  802894:	c3                   	ret    

00802895 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
  802898:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80289b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8028a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8028ad:	73 50                	jae    8028ff <memmove+0x6a>
  8028af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b5:	01 d0                	add    %edx,%eax
  8028b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8028ba:	76 43                	jbe    8028ff <memmove+0x6a>
		s += n;
  8028bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8028bf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8028c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8028c8:	eb 10                	jmp    8028da <memmove+0x45>
			*--d = *--s;
  8028ca:	ff 4d f8             	decl   -0x8(%ebp)
  8028cd:	ff 4d fc             	decl   -0x4(%ebp)
  8028d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028d3:	8a 10                	mov    (%eax),%dl
  8028d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028d8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8028da:	8b 45 10             	mov    0x10(%ebp),%eax
  8028dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8028e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	75 e3                	jne    8028ca <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8028e7:	eb 23                	jmp    80290c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8028e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028ec:	8d 50 01             	lea    0x1(%eax),%edx
  8028ef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8028f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8028f8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8028fb:	8a 12                	mov    (%edx),%dl
  8028fd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8028ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802902:	8d 50 ff             	lea    -0x1(%eax),%edx
  802905:	89 55 10             	mov    %edx,0x10(%ebp)
  802908:	85 c0                	test   %eax,%eax
  80290a:	75 dd                	jne    8028e9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80290f:	c9                   	leave  
  802910:	c3                   	ret    

00802911 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802911:	55                   	push   %ebp
  802912:	89 e5                	mov    %esp,%ebp
  802914:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80291d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802920:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802923:	eb 2a                	jmp    80294f <memcmp+0x3e>
		if (*s1 != *s2)
  802925:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802928:	8a 10                	mov    (%eax),%dl
  80292a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80292d:	8a 00                	mov    (%eax),%al
  80292f:	38 c2                	cmp    %al,%dl
  802931:	74 16                	je     802949 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802933:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802936:	8a 00                	mov    (%eax),%al
  802938:	0f b6 d0             	movzbl %al,%edx
  80293b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80293e:	8a 00                	mov    (%eax),%al
  802940:	0f b6 c0             	movzbl %al,%eax
  802943:	29 c2                	sub    %eax,%edx
  802945:	89 d0                	mov    %edx,%eax
  802947:	eb 18                	jmp    802961 <memcmp+0x50>
		s1++, s2++;
  802949:	ff 45 fc             	incl   -0x4(%ebp)
  80294c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80294f:	8b 45 10             	mov    0x10(%ebp),%eax
  802952:	8d 50 ff             	lea    -0x1(%eax),%edx
  802955:	89 55 10             	mov    %edx,0x10(%ebp)
  802958:	85 c0                	test   %eax,%eax
  80295a:	75 c9                	jne    802925 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80295c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802961:	c9                   	leave  
  802962:	c3                   	ret    

00802963 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802963:	55                   	push   %ebp
  802964:	89 e5                	mov    %esp,%ebp
  802966:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802969:	8b 55 08             	mov    0x8(%ebp),%edx
  80296c:	8b 45 10             	mov    0x10(%ebp),%eax
  80296f:	01 d0                	add    %edx,%eax
  802971:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802974:	eb 15                	jmp    80298b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8a 00                	mov    (%eax),%al
  80297b:	0f b6 d0             	movzbl %al,%edx
  80297e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802981:	0f b6 c0             	movzbl %al,%eax
  802984:	39 c2                	cmp    %eax,%edx
  802986:	74 0d                	je     802995 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802988:	ff 45 08             	incl   0x8(%ebp)
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802991:	72 e3                	jb     802976 <memfind+0x13>
  802993:	eb 01                	jmp    802996 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802995:	90                   	nop
	return (void *) s;
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802999:	c9                   	leave  
  80299a:	c3                   	ret    

0080299b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
  80299e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8029a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8029a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8029af:	eb 03                	jmp    8029b4 <strtol+0x19>
		s++;
  8029b1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	8a 00                	mov    (%eax),%al
  8029b9:	3c 20                	cmp    $0x20,%al
  8029bb:	74 f4                	je     8029b1 <strtol+0x16>
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	8a 00                	mov    (%eax),%al
  8029c2:	3c 09                	cmp    $0x9,%al
  8029c4:	74 eb                	je     8029b1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	8a 00                	mov    (%eax),%al
  8029cb:	3c 2b                	cmp    $0x2b,%al
  8029cd:	75 05                	jne    8029d4 <strtol+0x39>
		s++;
  8029cf:	ff 45 08             	incl   0x8(%ebp)
  8029d2:	eb 13                	jmp    8029e7 <strtol+0x4c>
	else if (*s == '-')
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	8a 00                	mov    (%eax),%al
  8029d9:	3c 2d                	cmp    $0x2d,%al
  8029db:	75 0a                	jne    8029e7 <strtol+0x4c>
		s++, neg = 1;
  8029dd:	ff 45 08             	incl   0x8(%ebp)
  8029e0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8029e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029eb:	74 06                	je     8029f3 <strtol+0x58>
  8029ed:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8029f1:	75 20                	jne    802a13 <strtol+0x78>
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8a 00                	mov    (%eax),%al
  8029f8:	3c 30                	cmp    $0x30,%al
  8029fa:	75 17                	jne    802a13 <strtol+0x78>
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	40                   	inc    %eax
  802a00:	8a 00                	mov    (%eax),%al
  802a02:	3c 78                	cmp    $0x78,%al
  802a04:	75 0d                	jne    802a13 <strtol+0x78>
		s += 2, base = 16;
  802a06:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802a0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802a11:	eb 28                	jmp    802a3b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802a13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a17:	75 15                	jne    802a2e <strtol+0x93>
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	8a 00                	mov    (%eax),%al
  802a1e:	3c 30                	cmp    $0x30,%al
  802a20:	75 0c                	jne    802a2e <strtol+0x93>
		s++, base = 8;
  802a22:	ff 45 08             	incl   0x8(%ebp)
  802a25:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802a2c:	eb 0d                	jmp    802a3b <strtol+0xa0>
	else if (base == 0)
  802a2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a32:	75 07                	jne    802a3b <strtol+0xa0>
		base = 10;
  802a34:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8a 00                	mov    (%eax),%al
  802a40:	3c 2f                	cmp    $0x2f,%al
  802a42:	7e 19                	jle    802a5d <strtol+0xc2>
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	8a 00                	mov    (%eax),%al
  802a49:	3c 39                	cmp    $0x39,%al
  802a4b:	7f 10                	jg     802a5d <strtol+0xc2>
			dig = *s - '0';
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	8a 00                	mov    (%eax),%al
  802a52:	0f be c0             	movsbl %al,%eax
  802a55:	83 e8 30             	sub    $0x30,%eax
  802a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5b:	eb 42                	jmp    802a9f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8a 00                	mov    (%eax),%al
  802a62:	3c 60                	cmp    $0x60,%al
  802a64:	7e 19                	jle    802a7f <strtol+0xe4>
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	8a 00                	mov    (%eax),%al
  802a6b:	3c 7a                	cmp    $0x7a,%al
  802a6d:	7f 10                	jg     802a7f <strtol+0xe4>
			dig = *s - 'a' + 10;
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	8a 00                	mov    (%eax),%al
  802a74:	0f be c0             	movsbl %al,%eax
  802a77:	83 e8 57             	sub    $0x57,%eax
  802a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7d:	eb 20                	jmp    802a9f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	8a 00                	mov    (%eax),%al
  802a84:	3c 40                	cmp    $0x40,%al
  802a86:	7e 39                	jle    802ac1 <strtol+0x126>
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8a 00                	mov    (%eax),%al
  802a8d:	3c 5a                	cmp    $0x5a,%al
  802a8f:	7f 30                	jg     802ac1 <strtol+0x126>
			dig = *s - 'A' + 10;
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	8a 00                	mov    (%eax),%al
  802a96:	0f be c0             	movsbl %al,%eax
  802a99:	83 e8 37             	sub    $0x37,%eax
  802a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	3b 45 10             	cmp    0x10(%ebp),%eax
  802aa5:	7d 19                	jge    802ac0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802aa7:	ff 45 08             	incl   0x8(%ebp)
  802aaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802aad:	0f af 45 10          	imul   0x10(%ebp),%eax
  802ab1:	89 c2                	mov    %eax,%edx
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	01 d0                	add    %edx,%eax
  802ab8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802abb:	e9 7b ff ff ff       	jmp    802a3b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802ac0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802ac1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ac5:	74 08                	je     802acf <strtol+0x134>
		*endptr = (char *) s;
  802ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aca:	8b 55 08             	mov    0x8(%ebp),%edx
  802acd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802acf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ad3:	74 07                	je     802adc <strtol+0x141>
  802ad5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802ad8:	f7 d8                	neg    %eax
  802ada:	eb 03                	jmp    802adf <strtol+0x144>
  802adc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802adf:	c9                   	leave  
  802ae0:	c3                   	ret    

00802ae1 <ltostr>:

void
ltostr(long value, char *str)
{
  802ae1:	55                   	push   %ebp
  802ae2:	89 e5                	mov    %esp,%ebp
  802ae4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802ae7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802aee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802af5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af9:	79 13                	jns    802b0e <ltostr+0x2d>
	{
		neg = 1;
  802afb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b05:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802b08:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802b0b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802b16:	99                   	cltd   
  802b17:	f7 f9                	idiv   %ecx
  802b19:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b1f:	8d 50 01             	lea    0x1(%eax),%edx
  802b22:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802b25:	89 c2                	mov    %eax,%edx
  802b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b2a:	01 d0                	add    %edx,%eax
  802b2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b2f:	83 c2 30             	add    $0x30,%edx
  802b32:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802b34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b37:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802b3c:	f7 e9                	imul   %ecx
  802b3e:	c1 fa 02             	sar    $0x2,%edx
  802b41:	89 c8                	mov    %ecx,%eax
  802b43:	c1 f8 1f             	sar    $0x1f,%eax
  802b46:	29 c2                	sub    %eax,%edx
  802b48:	89 d0                	mov    %edx,%eax
  802b4a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802b4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b51:	75 bb                	jne    802b0e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802b53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802b5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b5d:	48                   	dec    %eax
  802b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b65:	74 3d                	je     802ba4 <ltostr+0xc3>
		start = 1 ;
  802b67:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802b6e:	eb 34                	jmp    802ba4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b76:	01 d0                	add    %edx,%eax
  802b78:	8a 00                	mov    (%eax),%al
  802b7a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802b7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b83:	01 c2                	add    %eax,%edx
  802b85:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8b:	01 c8                	add    %ecx,%eax
  802b8d:	8a 00                	mov    (%eax),%al
  802b8f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802b91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b97:	01 c2                	add    %eax,%edx
  802b99:	8a 45 eb             	mov    -0x15(%ebp),%al
  802b9c:	88 02                	mov    %al,(%edx)
		start++ ;
  802b9e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802ba1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802baa:	7c c4                	jl     802b70 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802bac:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb2:	01 d0                	add    %edx,%eax
  802bb4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802bb7:	90                   	nop
  802bb8:	c9                   	leave  
  802bb9:	c3                   	ret    

00802bba <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
  802bbd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802bc0:	ff 75 08             	pushl  0x8(%ebp)
  802bc3:	e8 c4 f9 ff ff       	call   80258c <strlen>
  802bc8:	83 c4 04             	add    $0x4,%esp
  802bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802bce:	ff 75 0c             	pushl  0xc(%ebp)
  802bd1:	e8 b6 f9 ff ff       	call   80258c <strlen>
  802bd6:	83 c4 04             	add    $0x4,%esp
  802bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802bdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802be3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802bea:	eb 17                	jmp    802c03 <strcconcat+0x49>
		final[s] = str1[s] ;
  802bec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bef:	8b 45 10             	mov    0x10(%ebp),%eax
  802bf2:	01 c2                	add    %eax,%edx
  802bf4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	01 c8                	add    %ecx,%eax
  802bfc:	8a 00                	mov    (%eax),%al
  802bfe:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802c00:	ff 45 fc             	incl   -0x4(%ebp)
  802c03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c09:	7c e1                	jl     802bec <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802c12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802c19:	eb 1f                	jmp    802c3a <strcconcat+0x80>
		final[s++] = str2[i] ;
  802c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c1e:	8d 50 01             	lea    0x1(%eax),%edx
  802c21:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802c24:	89 c2                	mov    %eax,%edx
  802c26:	8b 45 10             	mov    0x10(%ebp),%eax
  802c29:	01 c2                	add    %eax,%edx
  802c2b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c31:	01 c8                	add    %ecx,%eax
  802c33:	8a 00                	mov    (%eax),%al
  802c35:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802c37:	ff 45 f8             	incl   -0x8(%ebp)
  802c3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c3d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c40:	7c d9                	jl     802c1b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802c42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c45:	8b 45 10             	mov    0x10(%ebp),%eax
  802c48:	01 d0                	add    %edx,%eax
  802c4a:	c6 00 00             	movb   $0x0,(%eax)
}
  802c4d:	90                   	nop
  802c4e:	c9                   	leave  
  802c4f:	c3                   	ret    

00802c50 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802c53:	8b 45 14             	mov    0x14(%ebp),%eax
  802c56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802c5c:	8b 45 14             	mov    0x14(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802c68:	8b 45 10             	mov    0x10(%ebp),%eax
  802c6b:	01 d0                	add    %edx,%eax
  802c6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802c73:	eb 0c                	jmp    802c81 <strsplit+0x31>
			*string++ = 0;
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	8d 50 01             	lea    0x1(%eax),%edx
  802c7b:	89 55 08             	mov    %edx,0x8(%ebp)
  802c7e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8a 00                	mov    (%eax),%al
  802c86:	84 c0                	test   %al,%al
  802c88:	74 18                	je     802ca2 <strsplit+0x52>
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	8a 00                	mov    (%eax),%al
  802c8f:	0f be c0             	movsbl %al,%eax
  802c92:	50                   	push   %eax
  802c93:	ff 75 0c             	pushl  0xc(%ebp)
  802c96:	e8 83 fa ff ff       	call   80271e <strchr>
  802c9b:	83 c4 08             	add    $0x8,%esp
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	75 d3                	jne    802c75 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8a 00                	mov    (%eax),%al
  802ca7:	84 c0                	test   %al,%al
  802ca9:	74 5a                	je     802d05 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802cab:	8b 45 14             	mov    0x14(%ebp),%eax
  802cae:	8b 00                	mov    (%eax),%eax
  802cb0:	83 f8 0f             	cmp    $0xf,%eax
  802cb3:	75 07                	jne    802cbc <strsplit+0x6c>
		{
			return 0;
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cba:	eb 66                	jmp    802d22 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	8d 48 01             	lea    0x1(%eax),%ecx
  802cc4:	8b 55 14             	mov    0x14(%ebp),%edx
  802cc7:	89 0a                	mov    %ecx,(%edx)
  802cc9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  802cd3:	01 c2                	add    %eax,%edx
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802cda:	eb 03                	jmp    802cdf <strsplit+0x8f>
			string++;
  802cdc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8a 00                	mov    (%eax),%al
  802ce4:	84 c0                	test   %al,%al
  802ce6:	74 8b                	je     802c73 <strsplit+0x23>
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8a 00                	mov    (%eax),%al
  802ced:	0f be c0             	movsbl %al,%eax
  802cf0:	50                   	push   %eax
  802cf1:	ff 75 0c             	pushl  0xc(%ebp)
  802cf4:	e8 25 fa ff ff       	call   80271e <strchr>
  802cf9:	83 c4 08             	add    $0x8,%esp
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 dc                	je     802cdc <strsplit+0x8c>
			string++;
	}
  802d00:	e9 6e ff ff ff       	jmp    802c73 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802d05:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802d06:	8b 45 14             	mov    0x14(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802d12:	8b 45 10             	mov    0x10(%ebp),%eax
  802d15:	01 d0                	add    %edx,%eax
  802d17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802d1d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802d22:	c9                   	leave  
  802d23:	c3                   	ret    

00802d24 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802d24:	55                   	push   %ebp
  802d25:	89 e5                	mov    %esp,%ebp
  802d27:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802d37:	eb 4a                	jmp    802d83 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802d39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	01 c2                	add    %eax,%edx
  802d41:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d47:	01 c8                	add    %ecx,%eax
  802d49:	8a 00                	mov    (%eax),%al
  802d4b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802d4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d53:	01 d0                	add    %edx,%eax
  802d55:	8a 00                	mov    (%eax),%al
  802d57:	3c 40                	cmp    $0x40,%al
  802d59:	7e 25                	jle    802d80 <str2lower+0x5c>
  802d5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d61:	01 d0                	add    %edx,%eax
  802d63:	8a 00                	mov    (%eax),%al
  802d65:	3c 5a                	cmp    $0x5a,%al
  802d67:	7f 17                	jg     802d80 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802d69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	01 d0                	add    %edx,%eax
  802d71:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802d74:	8b 55 08             	mov    0x8(%ebp),%edx
  802d77:	01 ca                	add    %ecx,%edx
  802d79:	8a 12                	mov    (%edx),%dl
  802d7b:	83 c2 20             	add    $0x20,%edx
  802d7e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802d80:	ff 45 fc             	incl   -0x4(%ebp)
  802d83:	ff 75 0c             	pushl  0xc(%ebp)
  802d86:	e8 01 f8 ff ff       	call   80258c <strlen>
  802d8b:	83 c4 04             	add    $0x4,%esp
  802d8e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802d91:	7f a6                	jg     802d39 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802d93:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802d96:	c9                   	leave  
  802d97:	c3                   	ret    

00802d98 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802d98:	55                   	push   %ebp
  802d99:	89 e5                	mov    %esp,%ebp
  802d9b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802d9e:	a1 08 60 80 00       	mov    0x806008,%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 42                	je     802de9 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802da7:	83 ec 08             	sub    $0x8,%esp
  802daa:	68 00 00 00 82       	push   $0x82000000
  802daf:	68 00 00 00 80       	push   $0x80000000
  802db4:	e8 00 08 00 00       	call   8035b9 <initialize_dynamic_allocator>
  802db9:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802dbc:	e8 e7 05 00 00       	call   8033a8 <sys_get_uheap_strategy>
  802dc1:	a3 44 e2 81 00       	mov    %eax,0x81e244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802dc6:	a1 20 62 80 00       	mov    0x806220,%eax
  802dcb:	05 00 10 00 00       	add    $0x1000,%eax
  802dd0:	a3 f0 e2 81 00       	mov    %eax,0x81e2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802dd5:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802dda:	a3 50 e2 81 00       	mov    %eax,0x81e250

		__firstTimeFlag = 0;
  802ddf:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802de6:	00 00 00 
	}
}
  802de9:	90                   	nop
  802dea:	c9                   	leave  
  802deb:	c3                   	ret    

00802dec <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802dec:	55                   	push   %ebp
  802ded:	89 e5                	mov    %esp,%ebp
  802def:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e00:	83 ec 08             	sub    $0x8,%esp
  802e03:	68 06 04 00 00       	push   $0x406
  802e08:	50                   	push   %eax
  802e09:	e8 e4 01 00 00       	call   802ff2 <__sys_allocate_page>
  802e0e:	83 c4 10             	add    $0x10,%esp
  802e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802e14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e18:	79 14                	jns    802e2e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802e1a:	83 ec 04             	sub    $0x4,%esp
  802e1d:	68 48 51 80 00       	push   $0x805148
  802e22:	6a 1f                	push   $0x1f
  802e24:	68 84 51 80 00       	push   $0x805184
  802e29:	e8 b7 ed ff ff       	call   801be5 <_panic>
	return 0;
  802e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e33:	c9                   	leave  
  802e34:	c3                   	ret    

00802e35 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802e35:	55                   	push   %ebp
  802e36:	89 e5                	mov    %esp,%ebp
  802e38:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e49:	83 ec 0c             	sub    $0xc,%esp
  802e4c:	50                   	push   %eax
  802e4d:	e8 e7 01 00 00       	call   803039 <__sys_unmap_frame>
  802e52:	83 c4 10             	add    $0x10,%esp
  802e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802e58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5c:	79 14                	jns    802e72 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	68 90 51 80 00       	push   $0x805190
  802e66:	6a 2a                	push   $0x2a
  802e68:	68 84 51 80 00       	push   $0x805184
  802e6d:	e8 73 ed ff ff       	call   801be5 <_panic>
}
  802e72:	90                   	nop
  802e73:	c9                   	leave  
  802e74:	c3                   	ret    

00802e75 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802e75:	55                   	push   %ebp
  802e76:	89 e5                	mov    %esp,%ebp
  802e78:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802e7b:	e8 18 ff ff ff       	call   802d98 <uheap_init>
	if (size == 0) return NULL ;
  802e80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e84:	75 07                	jne    802e8d <malloc+0x18>
  802e86:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8b:	eb 14                	jmp    802ea1 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802e8d:	83 ec 04             	sub    $0x4,%esp
  802e90:	68 d0 51 80 00       	push   $0x8051d0
  802e95:	6a 3e                	push   $0x3e
  802e97:	68 84 51 80 00       	push   $0x805184
  802e9c:	e8 44 ed ff ff       	call   801be5 <_panic>
}
  802ea1:	c9                   	leave  
  802ea2:	c3                   	ret    

00802ea3 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802ea3:	55                   	push   %ebp
  802ea4:	89 e5                	mov    %esp,%ebp
  802ea6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 f8 51 80 00       	push   $0x8051f8
  802eb1:	6a 49                	push   $0x49
  802eb3:	68 84 51 80 00       	push   $0x805184
  802eb8:	e8 28 ed ff ff       	call   801be5 <_panic>

00802ebd <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802ebd:	55                   	push   %ebp
  802ebe:	89 e5                	mov    %esp,%ebp
  802ec0:	83 ec 18             	sub    $0x18,%esp
  802ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  802ec6:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802ec9:	e8 ca fe ff ff       	call   802d98 <uheap_init>
	if (size == 0) return NULL ;
  802ece:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ed2:	75 07                	jne    802edb <smalloc+0x1e>
  802ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed9:	eb 14                	jmp    802eef <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  802edb:	83 ec 04             	sub    $0x4,%esp
  802ede:	68 1c 52 80 00       	push   $0x80521c
  802ee3:	6a 5a                	push   $0x5a
  802ee5:	68 84 51 80 00       	push   $0x805184
  802eea:	e8 f6 ec ff ff       	call   801be5 <_panic>
}
  802eef:	c9                   	leave  
  802ef0:	c3                   	ret    

00802ef1 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802ef1:	55                   	push   %ebp
  802ef2:	89 e5                	mov    %esp,%ebp
  802ef4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802ef7:	e8 9c fe ff ff       	call   802d98 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  802efc:	83 ec 04             	sub    $0x4,%esp
  802eff:	68 44 52 80 00       	push   $0x805244
  802f04:	6a 6a                	push   $0x6a
  802f06:	68 84 51 80 00       	push   $0x805184
  802f0b:	e8 d5 ec ff ff       	call   801be5 <_panic>

00802f10 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802f10:	55                   	push   %ebp
  802f11:	89 e5                	mov    %esp,%ebp
  802f13:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f16:	e8 7d fe ff ff       	call   802d98 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 68 52 80 00       	push   $0x805268
  802f23:	68 88 00 00 00       	push   $0x88
  802f28:	68 84 51 80 00       	push   $0x805184
  802f2d:	e8 b3 ec ff ff       	call   801be5 <_panic>

00802f32 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802f32:	55                   	push   %ebp
  802f33:	89 e5                	mov    %esp,%ebp
  802f35:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802f38:	83 ec 04             	sub    $0x4,%esp
  802f3b:	68 90 52 80 00       	push   $0x805290
  802f40:	68 9b 00 00 00       	push   $0x9b
  802f45:	68 84 51 80 00       	push   $0x805184
  802f4a:	e8 96 ec ff ff       	call   801be5 <_panic>

00802f4f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
  802f52:	57                   	push   %edi
  802f53:	56                   	push   %esi
  802f54:	53                   	push   %ebx
  802f55:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f64:	8b 7d 18             	mov    0x18(%ebp),%edi
  802f67:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802f6a:	cd 30                	int    $0x30
  802f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802f72:	83 c4 10             	add    $0x10,%esp
  802f75:	5b                   	pop    %ebx
  802f76:	5e                   	pop    %esi
  802f77:	5f                   	pop    %edi
  802f78:	5d                   	pop    %ebp
  802f79:	c3                   	ret    

00802f7a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	8b 45 10             	mov    0x10(%ebp),%eax
  802f83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802f86:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f89:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	6a 00                	push   $0x0
  802f92:	51                   	push   %ecx
  802f93:	52                   	push   %edx
  802f94:	ff 75 0c             	pushl  0xc(%ebp)
  802f97:	50                   	push   %eax
  802f98:	6a 00                	push   $0x0
  802f9a:	e8 b0 ff ff ff       	call   802f4f <syscall>
  802f9f:	83 c4 18             	add    $0x18,%esp
}
  802fa2:	90                   	nop
  802fa3:	c9                   	leave  
  802fa4:	c3                   	ret    

00802fa5 <sys_cgetc>:

int
sys_cgetc(void)
{
  802fa5:	55                   	push   %ebp
  802fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 00                	push   $0x0
  802fb2:	6a 02                	push   $0x2
  802fb4:	e8 96 ff ff ff       	call   802f4f <syscall>
  802fb9:	83 c4 18             	add    $0x18,%esp
}
  802fbc:	c9                   	leave  
  802fbd:	c3                   	ret    

00802fbe <sys_lock_cons>:

void sys_lock_cons(void)
{
  802fbe:	55                   	push   %ebp
  802fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 03                	push   $0x3
  802fcd:	e8 7d ff ff ff       	call   802f4f <syscall>
  802fd2:	83 c4 18             	add    $0x18,%esp
}
  802fd5:	90                   	nop
  802fd6:	c9                   	leave  
  802fd7:	c3                   	ret    

00802fd8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802fd8:	55                   	push   %ebp
  802fd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 04                	push   $0x4
  802fe7:	e8 63 ff ff ff       	call   802f4f <syscall>
  802fec:	83 c4 18             	add    $0x18,%esp
}
  802fef:	90                   	nop
  802ff0:	c9                   	leave  
  802ff1:	c3                   	ret    

00802ff2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802ff2:	55                   	push   %ebp
  802ff3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	6a 00                	push   $0x0
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	52                   	push   %edx
  803002:	50                   	push   %eax
  803003:	6a 08                	push   $0x8
  803005:	e8 45 ff ff ff       	call   802f4f <syscall>
  80300a:	83 c4 18             	add    $0x18,%esp
}
  80300d:	c9                   	leave  
  80300e:	c3                   	ret    

0080300f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80300f:	55                   	push   %ebp
  803010:	89 e5                	mov    %esp,%ebp
  803012:	56                   	push   %esi
  803013:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803014:	8b 75 18             	mov    0x18(%ebp),%esi
  803017:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80301a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80301d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	56                   	push   %esi
  803024:	53                   	push   %ebx
  803025:	51                   	push   %ecx
  803026:	52                   	push   %edx
  803027:	50                   	push   %eax
  803028:	6a 09                	push   $0x9
  80302a:	e8 20 ff ff ff       	call   802f4f <syscall>
  80302f:	83 c4 18             	add    $0x18,%esp
}
  803032:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803035:	5b                   	pop    %ebx
  803036:	5e                   	pop    %esi
  803037:	5d                   	pop    %ebp
  803038:	c3                   	ret    

00803039 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803039:	55                   	push   %ebp
  80303a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	6a 00                	push   $0x0
  803042:	6a 00                	push   $0x0
  803044:	ff 75 08             	pushl  0x8(%ebp)
  803047:	6a 0a                	push   $0xa
  803049:	e8 01 ff ff ff       	call   802f4f <syscall>
  80304e:	83 c4 18             	add    $0x18,%esp
}
  803051:	c9                   	leave  
  803052:	c3                   	ret    

00803053 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803053:	55                   	push   %ebp
  803054:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	ff 75 0c             	pushl  0xc(%ebp)
  80305f:	ff 75 08             	pushl  0x8(%ebp)
  803062:	6a 0b                	push   $0xb
  803064:	e8 e6 fe ff ff       	call   802f4f <syscall>
  803069:	83 c4 18             	add    $0x18,%esp
}
  80306c:	c9                   	leave  
  80306d:	c3                   	ret    

0080306e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80306e:	55                   	push   %ebp
  80306f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803071:	6a 00                	push   $0x0
  803073:	6a 00                	push   $0x0
  803075:	6a 00                	push   $0x0
  803077:	6a 00                	push   $0x0
  803079:	6a 00                	push   $0x0
  80307b:	6a 0c                	push   $0xc
  80307d:	e8 cd fe ff ff       	call   802f4f <syscall>
  803082:	83 c4 18             	add    $0x18,%esp
}
  803085:	c9                   	leave  
  803086:	c3                   	ret    

00803087 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803087:	55                   	push   %ebp
  803088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	6a 00                	push   $0x0
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	6a 0d                	push   $0xd
  803096:	e8 b4 fe ff ff       	call   802f4f <syscall>
  80309b:	83 c4 18             	add    $0x18,%esp
}
  80309e:	c9                   	leave  
  80309f:	c3                   	ret    

008030a0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8030a0:	55                   	push   %ebp
  8030a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	6a 00                	push   $0x0
  8030ab:	6a 00                	push   $0x0
  8030ad:	6a 0e                	push   $0xe
  8030af:	e8 9b fe ff ff       	call   802f4f <syscall>
  8030b4:	83 c4 18             	add    $0x18,%esp
}
  8030b7:	c9                   	leave  
  8030b8:	c3                   	ret    

008030b9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8030b9:	55                   	push   %ebp
  8030ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8030bc:	6a 00                	push   $0x0
  8030be:	6a 00                	push   $0x0
  8030c0:	6a 00                	push   $0x0
  8030c2:	6a 00                	push   $0x0
  8030c4:	6a 00                	push   $0x0
  8030c6:	6a 0f                	push   $0xf
  8030c8:	e8 82 fe ff ff       	call   802f4f <syscall>
  8030cd:	83 c4 18             	add    $0x18,%esp
}
  8030d0:	c9                   	leave  
  8030d1:	c3                   	ret    

008030d2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8030d2:	55                   	push   %ebp
  8030d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8030d5:	6a 00                	push   $0x0
  8030d7:	6a 00                	push   $0x0
  8030d9:	6a 00                	push   $0x0
  8030db:	6a 00                	push   $0x0
  8030dd:	ff 75 08             	pushl  0x8(%ebp)
  8030e0:	6a 10                	push   $0x10
  8030e2:	e8 68 fe ff ff       	call   802f4f <syscall>
  8030e7:	83 c4 18             	add    $0x18,%esp
}
  8030ea:	c9                   	leave  
  8030eb:	c3                   	ret    

008030ec <sys_scarce_memory>:

void sys_scarce_memory()
{
  8030ec:	55                   	push   %ebp
  8030ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8030ef:	6a 00                	push   $0x0
  8030f1:	6a 00                	push   $0x0
  8030f3:	6a 00                	push   $0x0
  8030f5:	6a 00                	push   $0x0
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 11                	push   $0x11
  8030fb:	e8 4f fe ff ff       	call   802f4f <syscall>
  803100:	83 c4 18             	add    $0x18,%esp
}
  803103:	90                   	nop
  803104:	c9                   	leave  
  803105:	c3                   	ret    

00803106 <sys_cputc>:

void
sys_cputc(const char c)
{
  803106:	55                   	push   %ebp
  803107:	89 e5                	mov    %esp,%ebp
  803109:	83 ec 04             	sub    $0x4,%esp
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803112:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803116:	6a 00                	push   $0x0
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	50                   	push   %eax
  80311f:	6a 01                	push   $0x1
  803121:	e8 29 fe ff ff       	call   802f4f <syscall>
  803126:	83 c4 18             	add    $0x18,%esp
}
  803129:	90                   	nop
  80312a:	c9                   	leave  
  80312b:	c3                   	ret    

0080312c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80312c:	55                   	push   %ebp
  80312d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80312f:	6a 00                	push   $0x0
  803131:	6a 00                	push   $0x0
  803133:	6a 00                	push   $0x0
  803135:	6a 00                	push   $0x0
  803137:	6a 00                	push   $0x0
  803139:	6a 14                	push   $0x14
  80313b:	e8 0f fe ff ff       	call   802f4f <syscall>
  803140:	83 c4 18             	add    $0x18,%esp
}
  803143:	90                   	nop
  803144:	c9                   	leave  
  803145:	c3                   	ret    

00803146 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803146:	55                   	push   %ebp
  803147:	89 e5                	mov    %esp,%ebp
  803149:	83 ec 04             	sub    $0x4,%esp
  80314c:	8b 45 10             	mov    0x10(%ebp),%eax
  80314f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803152:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803155:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	6a 00                	push   $0x0
  80315e:	51                   	push   %ecx
  80315f:	52                   	push   %edx
  803160:	ff 75 0c             	pushl  0xc(%ebp)
  803163:	50                   	push   %eax
  803164:	6a 15                	push   $0x15
  803166:	e8 e4 fd ff ff       	call   802f4f <syscall>
  80316b:	83 c4 18             	add    $0x18,%esp
}
  80316e:	c9                   	leave  
  80316f:	c3                   	ret    

00803170 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803170:	55                   	push   %ebp
  803171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803173:	8b 55 0c             	mov    0xc(%ebp),%edx
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	6a 00                	push   $0x0
  80317b:	6a 00                	push   $0x0
  80317d:	6a 00                	push   $0x0
  80317f:	52                   	push   %edx
  803180:	50                   	push   %eax
  803181:	6a 16                	push   $0x16
  803183:	e8 c7 fd ff ff       	call   802f4f <syscall>
  803188:	83 c4 18             	add    $0x18,%esp
}
  80318b:	c9                   	leave  
  80318c:	c3                   	ret    

0080318d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80318d:	55                   	push   %ebp
  80318e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803190:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803193:	8b 55 0c             	mov    0xc(%ebp),%edx
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	6a 00                	push   $0x0
  80319b:	6a 00                	push   $0x0
  80319d:	51                   	push   %ecx
  80319e:	52                   	push   %edx
  80319f:	50                   	push   %eax
  8031a0:	6a 17                	push   $0x17
  8031a2:	e8 a8 fd ff ff       	call   802f4f <syscall>
  8031a7:	83 c4 18             	add    $0x18,%esp
}
  8031aa:	c9                   	leave  
  8031ab:	c3                   	ret    

008031ac <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8031ac:	55                   	push   %ebp
  8031ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8031af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 00                	push   $0x0
  8031b9:	6a 00                	push   $0x0
  8031bb:	52                   	push   %edx
  8031bc:	50                   	push   %eax
  8031bd:	6a 18                	push   $0x18
  8031bf:	e8 8b fd ff ff       	call   802f4f <syscall>
  8031c4:	83 c4 18             	add    $0x18,%esp
}
  8031c7:	c9                   	leave  
  8031c8:	c3                   	ret    

008031c9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8031c9:	55                   	push   %ebp
  8031ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	6a 00                	push   $0x0
  8031d1:	ff 75 14             	pushl  0x14(%ebp)
  8031d4:	ff 75 10             	pushl  0x10(%ebp)
  8031d7:	ff 75 0c             	pushl  0xc(%ebp)
  8031da:	50                   	push   %eax
  8031db:	6a 19                	push   $0x19
  8031dd:	e8 6d fd ff ff       	call   802f4f <syscall>
  8031e2:	83 c4 18             	add    $0x18,%esp
}
  8031e5:	c9                   	leave  
  8031e6:	c3                   	ret    

008031e7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8031e7:	55                   	push   %ebp
  8031e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	50                   	push   %eax
  8031f6:	6a 1a                	push   $0x1a
  8031f8:	e8 52 fd ff ff       	call   802f4f <syscall>
  8031fd:	83 c4 18             	add    $0x18,%esp
}
  803200:	90                   	nop
  803201:	c9                   	leave  
  803202:	c3                   	ret    

00803203 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803203:	55                   	push   %ebp
  803204:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	6a 00                	push   $0x0
  80320b:	6a 00                	push   $0x0
  80320d:	6a 00                	push   $0x0
  80320f:	6a 00                	push   $0x0
  803211:	50                   	push   %eax
  803212:	6a 1b                	push   $0x1b
  803214:	e8 36 fd ff ff       	call   802f4f <syscall>
  803219:	83 c4 18             	add    $0x18,%esp
}
  80321c:	c9                   	leave  
  80321d:	c3                   	ret    

0080321e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80321e:	55                   	push   %ebp
  80321f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803221:	6a 00                	push   $0x0
  803223:	6a 00                	push   $0x0
  803225:	6a 00                	push   $0x0
  803227:	6a 00                	push   $0x0
  803229:	6a 00                	push   $0x0
  80322b:	6a 05                	push   $0x5
  80322d:	e8 1d fd ff ff       	call   802f4f <syscall>
  803232:	83 c4 18             	add    $0x18,%esp
}
  803235:	c9                   	leave  
  803236:	c3                   	ret    

00803237 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803237:	55                   	push   %ebp
  803238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	6a 00                	push   $0x0
  803242:	6a 00                	push   $0x0
  803244:	6a 06                	push   $0x6
  803246:	e8 04 fd ff ff       	call   802f4f <syscall>
  80324b:	83 c4 18             	add    $0x18,%esp
}
  80324e:	c9                   	leave  
  80324f:	c3                   	ret    

00803250 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803250:	55                   	push   %ebp
  803251:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803253:	6a 00                	push   $0x0
  803255:	6a 00                	push   $0x0
  803257:	6a 00                	push   $0x0
  803259:	6a 00                	push   $0x0
  80325b:	6a 00                	push   $0x0
  80325d:	6a 07                	push   $0x7
  80325f:	e8 eb fc ff ff       	call   802f4f <syscall>
  803264:	83 c4 18             	add    $0x18,%esp
}
  803267:	c9                   	leave  
  803268:	c3                   	ret    

00803269 <sys_exit_env>:


void sys_exit_env(void)
{
  803269:	55                   	push   %ebp
  80326a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80326c:	6a 00                	push   $0x0
  80326e:	6a 00                	push   $0x0
  803270:	6a 00                	push   $0x0
  803272:	6a 00                	push   $0x0
  803274:	6a 00                	push   $0x0
  803276:	6a 1c                	push   $0x1c
  803278:	e8 d2 fc ff ff       	call   802f4f <syscall>
  80327d:	83 c4 18             	add    $0x18,%esp
}
  803280:	90                   	nop
  803281:	c9                   	leave  
  803282:	c3                   	ret    

00803283 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803283:	55                   	push   %ebp
  803284:	89 e5                	mov    %esp,%ebp
  803286:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803289:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80328c:	8d 50 04             	lea    0x4(%eax),%edx
  80328f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803292:	6a 00                	push   $0x0
  803294:	6a 00                	push   $0x0
  803296:	6a 00                	push   $0x0
  803298:	52                   	push   %edx
  803299:	50                   	push   %eax
  80329a:	6a 1d                	push   $0x1d
  80329c:	e8 ae fc ff ff       	call   802f4f <syscall>
  8032a1:	83 c4 18             	add    $0x18,%esp
	return result;
  8032a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8032aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032ad:	89 01                	mov    %eax,(%ecx)
  8032af:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	c9                   	leave  
  8032b6:	c2 04 00             	ret    $0x4

008032b9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8032b9:	55                   	push   %ebp
  8032ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8032bc:	6a 00                	push   $0x0
  8032be:	6a 00                	push   $0x0
  8032c0:	ff 75 10             	pushl  0x10(%ebp)
  8032c3:	ff 75 0c             	pushl  0xc(%ebp)
  8032c6:	ff 75 08             	pushl  0x8(%ebp)
  8032c9:	6a 13                	push   $0x13
  8032cb:	e8 7f fc ff ff       	call   802f4f <syscall>
  8032d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032d3:	90                   	nop
}
  8032d4:	c9                   	leave  
  8032d5:	c3                   	ret    

008032d6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8032d6:	55                   	push   %ebp
  8032d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8032d9:	6a 00                	push   $0x0
  8032db:	6a 00                	push   $0x0
  8032dd:	6a 00                	push   $0x0
  8032df:	6a 00                	push   $0x0
  8032e1:	6a 00                	push   $0x0
  8032e3:	6a 1e                	push   $0x1e
  8032e5:	e8 65 fc ff ff       	call   802f4f <syscall>
  8032ea:	83 c4 18             	add    $0x18,%esp
}
  8032ed:	c9                   	leave  
  8032ee:	c3                   	ret    

008032ef <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8032ef:	55                   	push   %ebp
  8032f0:	89 e5                	mov    %esp,%ebp
  8032f2:	83 ec 04             	sub    $0x4,%esp
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8032fb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8032ff:	6a 00                	push   $0x0
  803301:	6a 00                	push   $0x0
  803303:	6a 00                	push   $0x0
  803305:	6a 00                	push   $0x0
  803307:	50                   	push   %eax
  803308:	6a 1f                	push   $0x1f
  80330a:	e8 40 fc ff ff       	call   802f4f <syscall>
  80330f:	83 c4 18             	add    $0x18,%esp
	return ;
  803312:	90                   	nop
}
  803313:	c9                   	leave  
  803314:	c3                   	ret    

00803315 <rsttst>:
void rsttst()
{
  803315:	55                   	push   %ebp
  803316:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803318:	6a 00                	push   $0x0
  80331a:	6a 00                	push   $0x0
  80331c:	6a 00                	push   $0x0
  80331e:	6a 00                	push   $0x0
  803320:	6a 00                	push   $0x0
  803322:	6a 21                	push   $0x21
  803324:	e8 26 fc ff ff       	call   802f4f <syscall>
  803329:	83 c4 18             	add    $0x18,%esp
	return ;
  80332c:	90                   	nop
}
  80332d:	c9                   	leave  
  80332e:	c3                   	ret    

0080332f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80332f:	55                   	push   %ebp
  803330:	89 e5                	mov    %esp,%ebp
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	8b 45 14             	mov    0x14(%ebp),%eax
  803338:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80333b:	8b 55 18             	mov    0x18(%ebp),%edx
  80333e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803342:	52                   	push   %edx
  803343:	50                   	push   %eax
  803344:	ff 75 10             	pushl  0x10(%ebp)
  803347:	ff 75 0c             	pushl  0xc(%ebp)
  80334a:	ff 75 08             	pushl  0x8(%ebp)
  80334d:	6a 20                	push   $0x20
  80334f:	e8 fb fb ff ff       	call   802f4f <syscall>
  803354:	83 c4 18             	add    $0x18,%esp
	return ;
  803357:	90                   	nop
}
  803358:	c9                   	leave  
  803359:	c3                   	ret    

0080335a <chktst>:
void chktst(uint32 n)
{
  80335a:	55                   	push   %ebp
  80335b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80335d:	6a 00                	push   $0x0
  80335f:	6a 00                	push   $0x0
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	ff 75 08             	pushl  0x8(%ebp)
  803368:	6a 22                	push   $0x22
  80336a:	e8 e0 fb ff ff       	call   802f4f <syscall>
  80336f:	83 c4 18             	add    $0x18,%esp
	return ;
  803372:	90                   	nop
}
  803373:	c9                   	leave  
  803374:	c3                   	ret    

00803375 <inctst>:

void inctst()
{
  803375:	55                   	push   %ebp
  803376:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803378:	6a 00                	push   $0x0
  80337a:	6a 00                	push   $0x0
  80337c:	6a 00                	push   $0x0
  80337e:	6a 00                	push   $0x0
  803380:	6a 00                	push   $0x0
  803382:	6a 23                	push   $0x23
  803384:	e8 c6 fb ff ff       	call   802f4f <syscall>
  803389:	83 c4 18             	add    $0x18,%esp
	return ;
  80338c:	90                   	nop
}
  80338d:	c9                   	leave  
  80338e:	c3                   	ret    

0080338f <gettst>:
uint32 gettst()
{
  80338f:	55                   	push   %ebp
  803390:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803392:	6a 00                	push   $0x0
  803394:	6a 00                	push   $0x0
  803396:	6a 00                	push   $0x0
  803398:	6a 00                	push   $0x0
  80339a:	6a 00                	push   $0x0
  80339c:	6a 24                	push   $0x24
  80339e:	e8 ac fb ff ff       	call   802f4f <syscall>
  8033a3:	83 c4 18             	add    $0x18,%esp
}
  8033a6:	c9                   	leave  
  8033a7:	c3                   	ret    

008033a8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8033a8:	55                   	push   %ebp
  8033a9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033ab:	6a 00                	push   $0x0
  8033ad:	6a 00                	push   $0x0
  8033af:	6a 00                	push   $0x0
  8033b1:	6a 00                	push   $0x0
  8033b3:	6a 00                	push   $0x0
  8033b5:	6a 25                	push   $0x25
  8033b7:	e8 93 fb ff ff       	call   802f4f <syscall>
  8033bc:	83 c4 18             	add    $0x18,%esp
  8033bf:	a3 44 e2 81 00       	mov    %eax,0x81e244
	return uheapPlaceStrategy ;
  8033c4:	a1 44 e2 81 00       	mov    0x81e244,%eax
}
  8033c9:	c9                   	leave  
  8033ca:	c3                   	ret    

008033cb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8033cb:	55                   	push   %ebp
  8033cc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	a3 44 e2 81 00       	mov    %eax,0x81e244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8033d6:	6a 00                	push   $0x0
  8033d8:	6a 00                	push   $0x0
  8033da:	6a 00                	push   $0x0
  8033dc:	6a 00                	push   $0x0
  8033de:	ff 75 08             	pushl  0x8(%ebp)
  8033e1:	6a 26                	push   $0x26
  8033e3:	e8 67 fb ff ff       	call   802f4f <syscall>
  8033e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8033eb:	90                   	nop
}
  8033ec:	c9                   	leave  
  8033ed:	c3                   	ret    

008033ee <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8033ee:	55                   	push   %ebp
  8033ef:	89 e5                	mov    %esp,%ebp
  8033f1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8033f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	6a 00                	push   $0x0
  803400:	53                   	push   %ebx
  803401:	51                   	push   %ecx
  803402:	52                   	push   %edx
  803403:	50                   	push   %eax
  803404:	6a 27                	push   $0x27
  803406:	e8 44 fb ff ff       	call   802f4f <syscall>
  80340b:	83 c4 18             	add    $0x18,%esp
}
  80340e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803411:	c9                   	leave  
  803412:	c3                   	ret    

00803413 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803413:	55                   	push   %ebp
  803414:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803416:	8b 55 0c             	mov    0xc(%ebp),%edx
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	6a 00                	push   $0x0
  80341e:	6a 00                	push   $0x0
  803420:	6a 00                	push   $0x0
  803422:	52                   	push   %edx
  803423:	50                   	push   %eax
  803424:	6a 28                	push   $0x28
  803426:	e8 24 fb ff ff       	call   802f4f <syscall>
  80342b:	83 c4 18             	add    $0x18,%esp
}
  80342e:	c9                   	leave  
  80342f:	c3                   	ret    

00803430 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803430:	55                   	push   %ebp
  803431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803433:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803436:	8b 55 0c             	mov    0xc(%ebp),%edx
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	6a 00                	push   $0x0
  80343e:	51                   	push   %ecx
  80343f:	ff 75 10             	pushl  0x10(%ebp)
  803442:	52                   	push   %edx
  803443:	50                   	push   %eax
  803444:	6a 29                	push   $0x29
  803446:	e8 04 fb ff ff       	call   802f4f <syscall>
  80344b:	83 c4 18             	add    $0x18,%esp
}
  80344e:	c9                   	leave  
  80344f:	c3                   	ret    

00803450 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803450:	55                   	push   %ebp
  803451:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803453:	6a 00                	push   $0x0
  803455:	6a 00                	push   $0x0
  803457:	ff 75 10             	pushl  0x10(%ebp)
  80345a:	ff 75 0c             	pushl  0xc(%ebp)
  80345d:	ff 75 08             	pushl  0x8(%ebp)
  803460:	6a 12                	push   $0x12
  803462:	e8 e8 fa ff ff       	call   802f4f <syscall>
  803467:	83 c4 18             	add    $0x18,%esp
	return ;
  80346a:	90                   	nop
}
  80346b:	c9                   	leave  
  80346c:	c3                   	ret    

0080346d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80346d:	55                   	push   %ebp
  80346e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803470:	8b 55 0c             	mov    0xc(%ebp),%edx
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	6a 00                	push   $0x0
  803478:	6a 00                	push   $0x0
  80347a:	6a 00                	push   $0x0
  80347c:	52                   	push   %edx
  80347d:	50                   	push   %eax
  80347e:	6a 2a                	push   $0x2a
  803480:	e8 ca fa ff ff       	call   802f4f <syscall>
  803485:	83 c4 18             	add    $0x18,%esp
	return;
  803488:	90                   	nop
}
  803489:	c9                   	leave  
  80348a:	c3                   	ret    

0080348b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80348b:	55                   	push   %ebp
  80348c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80348e:	6a 00                	push   $0x0
  803490:	6a 00                	push   $0x0
  803492:	6a 00                	push   $0x0
  803494:	6a 00                	push   $0x0
  803496:	6a 00                	push   $0x0
  803498:	6a 2b                	push   $0x2b
  80349a:	e8 b0 fa ff ff       	call   802f4f <syscall>
  80349f:	83 c4 18             	add    $0x18,%esp
}
  8034a2:	c9                   	leave  
  8034a3:	c3                   	ret    

008034a4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8034a4:	55                   	push   %ebp
  8034a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8034a7:	6a 00                	push   $0x0
  8034a9:	6a 00                	push   $0x0
  8034ab:	6a 00                	push   $0x0
  8034ad:	ff 75 0c             	pushl  0xc(%ebp)
  8034b0:	ff 75 08             	pushl  0x8(%ebp)
  8034b3:	6a 2d                	push   $0x2d
  8034b5:	e8 95 fa ff ff       	call   802f4f <syscall>
  8034ba:	83 c4 18             	add    $0x18,%esp
	return;
  8034bd:	90                   	nop
}
  8034be:	c9                   	leave  
  8034bf:	c3                   	ret    

008034c0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8034c0:	55                   	push   %ebp
  8034c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8034c3:	6a 00                	push   $0x0
  8034c5:	6a 00                	push   $0x0
  8034c7:	6a 00                	push   $0x0
  8034c9:	ff 75 0c             	pushl  0xc(%ebp)
  8034cc:	ff 75 08             	pushl  0x8(%ebp)
  8034cf:	6a 2c                	push   $0x2c
  8034d1:	e8 79 fa ff ff       	call   802f4f <syscall>
  8034d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8034d9:	90                   	nop
}
  8034da:	c9                   	leave  
  8034db:	c3                   	ret    

008034dc <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8034dc:	55                   	push   %ebp
  8034dd:	89 e5                	mov    %esp,%ebp
  8034df:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8034e2:	83 ec 04             	sub    $0x4,%esp
  8034e5:	68 b4 52 80 00       	push   $0x8052b4
  8034ea:	68 25 01 00 00       	push   $0x125
  8034ef:	68 e7 52 80 00       	push   $0x8052e7
  8034f4:	e8 ec e6 ff ff       	call   801be5 <_panic>

008034f9 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8034f9:	55                   	push   %ebp
  8034fa:	89 e5                	mov    %esp,%ebp
  8034fc:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8034ff:	81 7d 08 40 62 80 00 	cmpl   $0x806240,0x8(%ebp)
  803506:	72 09                	jb     803511 <to_page_va+0x18>
  803508:	81 7d 08 40 e2 81 00 	cmpl   $0x81e240,0x8(%ebp)
  80350f:	72 14                	jb     803525 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803511:	83 ec 04             	sub    $0x4,%esp
  803514:	68 f8 52 80 00       	push   $0x8052f8
  803519:	6a 15                	push   $0x15
  80351b:	68 23 53 80 00       	push   $0x805323
  803520:	e8 c0 e6 ff ff       	call   801be5 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803525:	8b 45 08             	mov    0x8(%ebp),%eax
  803528:	ba 40 62 80 00       	mov    $0x806240,%edx
  80352d:	29 d0                	sub    %edx,%eax
  80352f:	c1 f8 02             	sar    $0x2,%eax
  803532:	89 c2                	mov    %eax,%edx
  803534:	89 d0                	mov    %edx,%eax
  803536:	c1 e0 02             	shl    $0x2,%eax
  803539:	01 d0                	add    %edx,%eax
  80353b:	c1 e0 02             	shl    $0x2,%eax
  80353e:	01 d0                	add    %edx,%eax
  803540:	c1 e0 02             	shl    $0x2,%eax
  803543:	01 d0                	add    %edx,%eax
  803545:	89 c1                	mov    %eax,%ecx
  803547:	c1 e1 08             	shl    $0x8,%ecx
  80354a:	01 c8                	add    %ecx,%eax
  80354c:	89 c1                	mov    %eax,%ecx
  80354e:	c1 e1 10             	shl    $0x10,%ecx
  803551:	01 c8                	add    %ecx,%eax
  803553:	01 c0                	add    %eax,%eax
  803555:	01 d0                	add    %edx,%eax
  803557:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355d:	c1 e0 0c             	shl    $0xc,%eax
  803560:	89 c2                	mov    %eax,%edx
  803562:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803567:	01 d0                	add    %edx,%eax
}
  803569:	c9                   	leave  
  80356a:	c3                   	ret    

0080356b <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80356b:	55                   	push   %ebp
  80356c:	89 e5                	mov    %esp,%ebp
  80356e:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803571:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803576:	8b 55 08             	mov    0x8(%ebp),%edx
  803579:	29 c2                	sub    %eax,%edx
  80357b:	89 d0                	mov    %edx,%eax
  80357d:	c1 e8 0c             	shr    $0xc,%eax
  803580:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803587:	78 09                	js     803592 <to_page_info+0x27>
  803589:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803590:	7e 14                	jle    8035a6 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803592:	83 ec 04             	sub    $0x4,%esp
  803595:	68 3c 53 80 00       	push   $0x80533c
  80359a:	6a 22                	push   $0x22
  80359c:	68 23 53 80 00       	push   $0x805323
  8035a1:	e8 3f e6 ff ff       	call   801be5 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8035a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a9:	89 d0                	mov    %edx,%eax
  8035ab:	01 c0                	add    %eax,%eax
  8035ad:	01 d0                	add    %edx,%eax
  8035af:	c1 e0 02             	shl    $0x2,%eax
  8035b2:	05 40 62 80 00       	add    $0x806240,%eax
}
  8035b7:	c9                   	leave  
  8035b8:	c3                   	ret    

008035b9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8035b9:	55                   	push   %ebp
  8035ba:	89 e5                	mov    %esp,%ebp
  8035bc:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	05 00 00 00 02       	add    $0x2000000,%eax
  8035c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035ca:	73 16                	jae    8035e2 <initialize_dynamic_allocator+0x29>
  8035cc:	68 60 53 80 00       	push   $0x805360
  8035d1:	68 86 53 80 00       	push   $0x805386
  8035d6:	6a 34                	push   $0x34
  8035d8:	68 23 53 80 00       	push   $0x805323
  8035dd:	e8 03 e6 ff ff       	call   801be5 <_panic>
		is_initialized = 1;
  8035e2:	c7 05 04 62 80 00 01 	movl   $0x1,0x806204
  8035e9:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  8035ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ef:	a3 48 e2 81 00       	mov    %eax,0x81e248
	dynAllocEnd = daEnd;
  8035f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f7:	a3 20 62 80 00       	mov    %eax,0x806220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  8035fc:	c7 05 28 62 80 00 00 	movl   $0x0,0x806228
  803603:	00 00 00 
  803606:	c7 05 2c 62 80 00 00 	movl   $0x0,0x80622c
  80360d:	00 00 00 
  803610:	c7 05 34 62 80 00 00 	movl   $0x0,0x806234
  803617:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  80361a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361d:	2b 45 08             	sub    0x8(%ebp),%eax
  803620:	c1 e8 0c             	shr    $0xc,%eax
  803623:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  803626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80362d:	e9 c8 00 00 00       	jmp    8036fa <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  803632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803635:	89 d0                	mov    %edx,%eax
  803637:	01 c0                	add    %eax,%eax
  803639:	01 d0                	add    %edx,%eax
  80363b:	c1 e0 02             	shl    $0x2,%eax
  80363e:	05 48 62 80 00       	add    $0x806248,%eax
  803643:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803648:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80364b:	89 d0                	mov    %edx,%eax
  80364d:	01 c0                	add    %eax,%eax
  80364f:	01 d0                	add    %edx,%eax
  803651:	c1 e0 02             	shl    $0x2,%eax
  803654:	05 4a 62 80 00       	add    $0x80624a,%eax
  803659:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80365e:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803664:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803667:	89 c8                	mov    %ecx,%eax
  803669:	01 c0                	add    %eax,%eax
  80366b:	01 c8                	add    %ecx,%eax
  80366d:	c1 e0 02             	shl    $0x2,%eax
  803670:	05 44 62 80 00       	add    $0x806244,%eax
  803675:	89 10                	mov    %edx,(%eax)
  803677:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80367a:	89 d0                	mov    %edx,%eax
  80367c:	01 c0                	add    %eax,%eax
  80367e:	01 d0                	add    %edx,%eax
  803680:	c1 e0 02             	shl    $0x2,%eax
  803683:	05 44 62 80 00       	add    $0x806244,%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	85 c0                	test   %eax,%eax
  80368c:	74 1b                	je     8036a9 <initialize_dynamic_allocator+0xf0>
  80368e:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803694:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803697:	89 c8                	mov    %ecx,%eax
  803699:	01 c0                	add    %eax,%eax
  80369b:	01 c8                	add    %ecx,%eax
  80369d:	c1 e0 02             	shl    $0x2,%eax
  8036a0:	05 40 62 80 00       	add    $0x806240,%eax
  8036a5:	89 02                	mov    %eax,(%edx)
  8036a7:	eb 16                	jmp    8036bf <initialize_dynamic_allocator+0x106>
  8036a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ac:	89 d0                	mov    %edx,%eax
  8036ae:	01 c0                	add    %eax,%eax
  8036b0:	01 d0                	add    %edx,%eax
  8036b2:	c1 e0 02             	shl    $0x2,%eax
  8036b5:	05 40 62 80 00       	add    $0x806240,%eax
  8036ba:	a3 28 62 80 00       	mov    %eax,0x806228
  8036bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036c2:	89 d0                	mov    %edx,%eax
  8036c4:	01 c0                	add    %eax,%eax
  8036c6:	01 d0                	add    %edx,%eax
  8036c8:	c1 e0 02             	shl    $0x2,%eax
  8036cb:	05 40 62 80 00       	add    $0x806240,%eax
  8036d0:	a3 2c 62 80 00       	mov    %eax,0x80622c
  8036d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036d8:	89 d0                	mov    %edx,%eax
  8036da:	01 c0                	add    %eax,%eax
  8036dc:	01 d0                	add    %edx,%eax
  8036de:	c1 e0 02             	shl    $0x2,%eax
  8036e1:	05 40 62 80 00       	add    $0x806240,%eax
  8036e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ec:	a1 34 62 80 00       	mov    0x806234,%eax
  8036f1:	40                   	inc    %eax
  8036f2:	a3 34 62 80 00       	mov    %eax,0x806234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8036f7:	ff 45 f4             	incl   -0xc(%ebp)
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803700:	0f 8c 2c ff ff ff    	jl     803632 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803706:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80370d:	eb 36                	jmp    803745 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  80370f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803712:	c1 e0 04             	shl    $0x4,%eax
  803715:	05 60 e2 81 00       	add    $0x81e260,%eax
  80371a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803723:	c1 e0 04             	shl    $0x4,%eax
  803726:	05 64 e2 81 00       	add    $0x81e264,%eax
  80372b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803734:	c1 e0 04             	shl    $0x4,%eax
  803737:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80373c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  803742:	ff 45 f0             	incl   -0x10(%ebp)
  803745:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803749:	7e c4                	jle    80370f <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80374b:	90                   	nop
  80374c:	c9                   	leave  
  80374d:	c3                   	ret    

0080374e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80374e:	55                   	push   %ebp
  80374f:	89 e5                	mov    %esp,%ebp
  803751:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  803754:	8b 45 08             	mov    0x8(%ebp),%eax
  803757:	83 ec 0c             	sub    $0xc,%esp
  80375a:	50                   	push   %eax
  80375b:	e8 0b fe ff ff       	call   80356b <to_page_info>
  803760:	83 c4 10             	add    $0x10,%esp
  803763:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  803766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803769:	8b 40 08             	mov    0x8(%eax),%eax
  80376c:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80376f:	c9                   	leave  
  803770:	c3                   	ret    

00803771 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  803771:	55                   	push   %ebp
  803772:	89 e5                	mov    %esp,%ebp
  803774:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  803777:	83 ec 0c             	sub    $0xc,%esp
  80377a:	ff 75 0c             	pushl  0xc(%ebp)
  80377d:	e8 77 fd ff ff       	call   8034f9 <to_page_va>
  803782:	83 c4 10             	add    $0x10,%esp
  803785:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  803788:	b8 00 10 00 00       	mov    $0x1000,%eax
  80378d:	ba 00 00 00 00       	mov    $0x0,%edx
  803792:	f7 75 08             	divl   0x8(%ebp)
  803795:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  803798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379b:	83 ec 0c             	sub    $0xc,%esp
  80379e:	50                   	push   %eax
  80379f:	e8 48 f6 ff ff       	call   802dec <get_page>
  8037a4:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  8037a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037ad:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037b7:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8037bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8037c2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8037c9:	eb 19                	jmp    8037e4 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8037cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ce:	ba 01 00 00 00       	mov    $0x1,%edx
  8037d3:	88 c1                	mov    %al,%cl
  8037d5:	d3 e2                	shl    %cl,%edx
  8037d7:	89 d0                	mov    %edx,%eax
  8037d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037dc:	74 0e                	je     8037ec <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8037de:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8037e1:	ff 45 f0             	incl   -0x10(%ebp)
  8037e4:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8037e8:	7e e1                	jle    8037cb <split_page_to_blocks+0x5a>
  8037ea:	eb 01                	jmp    8037ed <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8037ec:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8037ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8037f4:	e9 a7 00 00 00       	jmp    8038a0 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8037f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fc:	0f af 45 08          	imul   0x8(%ebp),%eax
  803800:	89 c2                	mov    %eax,%edx
  803802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803805:	01 d0                	add    %edx,%eax
  803807:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80380a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80380e:	75 14                	jne    803824 <split_page_to_blocks+0xb3>
  803810:	83 ec 04             	sub    $0x4,%esp
  803813:	68 9c 53 80 00       	push   $0x80539c
  803818:	6a 7c                	push   $0x7c
  80381a:	68 23 53 80 00       	push   $0x805323
  80381f:	e8 c1 e3 ff ff       	call   801be5 <_panic>
  803824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803827:	c1 e0 04             	shl    $0x4,%eax
  80382a:	05 64 e2 81 00       	add    $0x81e264,%eax
  80382f:	8b 10                	mov    (%eax),%edx
  803831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803834:	89 50 04             	mov    %edx,0x4(%eax)
  803837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383a:	8b 40 04             	mov    0x4(%eax),%eax
  80383d:	85 c0                	test   %eax,%eax
  80383f:	74 14                	je     803855 <split_page_to_blocks+0xe4>
  803841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803844:	c1 e0 04             	shl    $0x4,%eax
  803847:	05 64 e2 81 00       	add    $0x81e264,%eax
  80384c:	8b 00                	mov    (%eax),%eax
  80384e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803851:	89 10                	mov    %edx,(%eax)
  803853:	eb 11                	jmp    803866 <split_page_to_blocks+0xf5>
  803855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803858:	c1 e0 04             	shl    $0x4,%eax
  80385b:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  803861:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803864:	89 02                	mov    %eax,(%edx)
  803866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803869:	c1 e0 04             	shl    $0x4,%eax
  80386c:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  803872:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803875:	89 02                	mov    %eax,(%edx)
  803877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80387a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803883:	c1 e0 04             	shl    $0x4,%eax
  803886:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80388b:	8b 00                	mov    (%eax),%eax
  80388d:	8d 50 01             	lea    0x1(%eax),%edx
  803890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803893:	c1 e0 04             	shl    $0x4,%eax
  803896:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80389b:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80389d:	ff 45 ec             	incl   -0x14(%ebp)
  8038a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8038a6:	0f 82 4d ff ff ff    	jb     8037f9 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8038ac:	90                   	nop
  8038ad:	c9                   	leave  
  8038ae:	c3                   	ret    

008038af <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8038af:	55                   	push   %ebp
  8038b0:	89 e5                	mov    %esp,%ebp
  8038b2:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8038b5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8038bc:	76 19                	jbe    8038d7 <alloc_block+0x28>
  8038be:	68 c0 53 80 00       	push   $0x8053c0
  8038c3:	68 86 53 80 00       	push   $0x805386
  8038c8:	68 8a 00 00 00       	push   $0x8a
  8038cd:	68 23 53 80 00       	push   $0x805323
  8038d2:	e8 0e e3 ff ff       	call   801be5 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8038d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8038de:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8038e5:	eb 19                	jmp    803900 <alloc_block+0x51>
		if((1 << i) >= size) break;
  8038e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ea:	ba 01 00 00 00       	mov    $0x1,%edx
  8038ef:	88 c1                	mov    %al,%cl
  8038f1:	d3 e2                	shl    %cl,%edx
  8038f3:	89 d0                	mov    %edx,%eax
  8038f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038f8:	73 0e                	jae    803908 <alloc_block+0x59>
		idx++;
  8038fa:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8038fd:	ff 45 f0             	incl   -0x10(%ebp)
  803900:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803904:	7e e1                	jle    8038e7 <alloc_block+0x38>
  803906:	eb 01                	jmp    803909 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  803908:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	c1 e0 04             	shl    $0x4,%eax
  80390f:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803914:	8b 00                	mov    (%eax),%eax
  803916:	85 c0                	test   %eax,%eax
  803918:	0f 84 df 00 00 00    	je     8039fd <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80391e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803921:	c1 e0 04             	shl    $0x4,%eax
  803924:	05 60 e2 81 00       	add    $0x81e260,%eax
  803929:	8b 00                	mov    (%eax),%eax
  80392b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80392e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803932:	75 17                	jne    80394b <alloc_block+0x9c>
  803934:	83 ec 04             	sub    $0x4,%esp
  803937:	68 e1 53 80 00       	push   $0x8053e1
  80393c:	68 9e 00 00 00       	push   $0x9e
  803941:	68 23 53 80 00       	push   $0x805323
  803946:	e8 9a e2 ff ff       	call   801be5 <_panic>
  80394b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80394e:	8b 00                	mov    (%eax),%eax
  803950:	85 c0                	test   %eax,%eax
  803952:	74 10                	je     803964 <alloc_block+0xb5>
  803954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80395c:	8b 52 04             	mov    0x4(%edx),%edx
  80395f:	89 50 04             	mov    %edx,0x4(%eax)
  803962:	eb 14                	jmp    803978 <alloc_block+0xc9>
  803964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803967:	8b 40 04             	mov    0x4(%eax),%eax
  80396a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80396d:	c1 e2 04             	shl    $0x4,%edx
  803970:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803976:	89 02                	mov    %eax,(%edx)
  803978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80397b:	8b 40 04             	mov    0x4(%eax),%eax
  80397e:	85 c0                	test   %eax,%eax
  803980:	74 0f                	je     803991 <alloc_block+0xe2>
  803982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803985:	8b 40 04             	mov    0x4(%eax),%eax
  803988:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80398b:	8b 12                	mov    (%edx),%edx
  80398d:	89 10                	mov    %edx,(%eax)
  80398f:	eb 13                	jmp    8039a4 <alloc_block+0xf5>
  803991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803994:	8b 00                	mov    (%eax),%eax
  803996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803999:	c1 e2 04             	shl    $0x4,%edx
  80399c:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  8039a2:	89 02                	mov    %eax,(%edx)
  8039a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ba:	c1 e0 04             	shl    $0x4,%eax
  8039bd:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8039c2:	8b 00                	mov    (%eax),%eax
  8039c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ca:	c1 e0 04             	shl    $0x4,%eax
  8039cd:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8039d2:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8039d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d7:	83 ec 0c             	sub    $0xc,%esp
  8039da:	50                   	push   %eax
  8039db:	e8 8b fb ff ff       	call   80356b <to_page_info>
  8039e0:	83 c4 10             	add    $0x10,%esp
  8039e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8039e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8039ed:	48                   	dec    %eax
  8039ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039f1:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8039f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f8:	e9 bc 02 00 00       	jmp    803cb9 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8039fd:	a1 34 62 80 00       	mov    0x806234,%eax
  803a02:	85 c0                	test   %eax,%eax
  803a04:	0f 84 7d 02 00 00    	je     803c87 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  803a0a:	a1 28 62 80 00       	mov    0x806228,%eax
  803a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  803a12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a16:	75 17                	jne    803a2f <alloc_block+0x180>
  803a18:	83 ec 04             	sub    $0x4,%esp
  803a1b:	68 e1 53 80 00       	push   $0x8053e1
  803a20:	68 a9 00 00 00       	push   $0xa9
  803a25:	68 23 53 80 00       	push   $0x805323
  803a2a:	e8 b6 e1 ff ff       	call   801be5 <_panic>
  803a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a32:	8b 00                	mov    (%eax),%eax
  803a34:	85 c0                	test   %eax,%eax
  803a36:	74 10                	je     803a48 <alloc_block+0x199>
  803a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3b:	8b 00                	mov    (%eax),%eax
  803a3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a40:	8b 52 04             	mov    0x4(%edx),%edx
  803a43:	89 50 04             	mov    %edx,0x4(%eax)
  803a46:	eb 0b                	jmp    803a53 <alloc_block+0x1a4>
  803a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4b:	8b 40 04             	mov    0x4(%eax),%eax
  803a4e:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a56:	8b 40 04             	mov    0x4(%eax),%eax
  803a59:	85 c0                	test   %eax,%eax
  803a5b:	74 0f                	je     803a6c <alloc_block+0x1bd>
  803a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a60:	8b 40 04             	mov    0x4(%eax),%eax
  803a63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a66:	8b 12                	mov    (%edx),%edx
  803a68:	89 10                	mov    %edx,(%eax)
  803a6a:	eb 0a                	jmp    803a76 <alloc_block+0x1c7>
  803a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6f:	8b 00                	mov    (%eax),%eax
  803a71:	a3 28 62 80 00       	mov    %eax,0x806228
  803a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a89:	a1 34 62 80 00       	mov    0x806234,%eax
  803a8e:	48                   	dec    %eax
  803a8f:	a3 34 62 80 00       	mov    %eax,0x806234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  803a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a97:	83 c0 03             	add    $0x3,%eax
  803a9a:	ba 01 00 00 00       	mov    $0x1,%edx
  803a9f:	88 c1                	mov    %al,%cl
  803aa1:	d3 e2                	shl    %cl,%edx
  803aa3:	89 d0                	mov    %edx,%eax
  803aa5:	83 ec 08             	sub    $0x8,%esp
  803aa8:	ff 75 e4             	pushl  -0x1c(%ebp)
  803aab:	50                   	push   %eax
  803aac:	e8 c0 fc ff ff       	call   803771 <split_page_to_blocks>
  803ab1:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab7:	c1 e0 04             	shl    $0x4,%eax
  803aba:	05 60 e2 81 00       	add    $0x81e260,%eax
  803abf:	8b 00                	mov    (%eax),%eax
  803ac1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  803ac4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ac8:	75 17                	jne    803ae1 <alloc_block+0x232>
  803aca:	83 ec 04             	sub    $0x4,%esp
  803acd:	68 e1 53 80 00       	push   $0x8053e1
  803ad2:	68 b0 00 00 00       	push   $0xb0
  803ad7:	68 23 53 80 00       	push   $0x805323
  803adc:	e8 04 e1 ff ff       	call   801be5 <_panic>
  803ae1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ae4:	8b 00                	mov    (%eax),%eax
  803ae6:	85 c0                	test   %eax,%eax
  803ae8:	74 10                	je     803afa <alloc_block+0x24b>
  803aea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803af2:	8b 52 04             	mov    0x4(%edx),%edx
  803af5:	89 50 04             	mov    %edx,0x4(%eax)
  803af8:	eb 14                	jmp    803b0e <alloc_block+0x25f>
  803afa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803afd:	8b 40 04             	mov    0x4(%eax),%eax
  803b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b03:	c1 e2 04             	shl    $0x4,%edx
  803b06:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803b0c:	89 02                	mov    %eax,(%edx)
  803b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b11:	8b 40 04             	mov    0x4(%eax),%eax
  803b14:	85 c0                	test   %eax,%eax
  803b16:	74 0f                	je     803b27 <alloc_block+0x278>
  803b18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b1b:	8b 40 04             	mov    0x4(%eax),%eax
  803b1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b21:	8b 12                	mov    (%edx),%edx
  803b23:	89 10                	mov    %edx,(%eax)
  803b25:	eb 13                	jmp    803b3a <alloc_block+0x28b>
  803b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b2a:	8b 00                	mov    (%eax),%eax
  803b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b2f:	c1 e2 04             	shl    $0x4,%edx
  803b32:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803b38:	89 02                	mov    %eax,(%edx)
  803b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b50:	c1 e0 04             	shl    $0x4,%eax
  803b53:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803b58:	8b 00                	mov    (%eax),%eax
  803b5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b60:	c1 e0 04             	shl    $0x4,%eax
  803b63:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803b68:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b6d:	83 ec 0c             	sub    $0xc,%esp
  803b70:	50                   	push   %eax
  803b71:	e8 f5 f9 ff ff       	call   80356b <to_page_info>
  803b76:	83 c4 10             	add    $0x10,%esp
  803b79:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  803b7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b7f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b83:	48                   	dec    %eax
  803b84:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b87:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b8e:	e9 26 01 00 00       	jmp    803cb9 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  803b93:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  803b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b99:	c1 e0 04             	shl    $0x4,%eax
  803b9c:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ba1:	8b 00                	mov    (%eax),%eax
  803ba3:	85 c0                	test   %eax,%eax
  803ba5:	0f 84 dc 00 00 00    	je     803c87 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bae:	c1 e0 04             	shl    $0x4,%eax
  803bb1:	05 60 e2 81 00       	add    $0x81e260,%eax
  803bb6:	8b 00                	mov    (%eax),%eax
  803bb8:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  803bbb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803bbf:	75 17                	jne    803bd8 <alloc_block+0x329>
  803bc1:	83 ec 04             	sub    $0x4,%esp
  803bc4:	68 e1 53 80 00       	push   $0x8053e1
  803bc9:	68 be 00 00 00       	push   $0xbe
  803bce:	68 23 53 80 00       	push   $0x805323
  803bd3:	e8 0d e0 ff ff       	call   801be5 <_panic>
  803bd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803bdb:	8b 00                	mov    (%eax),%eax
  803bdd:	85 c0                	test   %eax,%eax
  803bdf:	74 10                	je     803bf1 <alloc_block+0x342>
  803be1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803be4:	8b 00                	mov    (%eax),%eax
  803be6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803be9:	8b 52 04             	mov    0x4(%edx),%edx
  803bec:	89 50 04             	mov    %edx,0x4(%eax)
  803bef:	eb 14                	jmp    803c05 <alloc_block+0x356>
  803bf1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803bf4:	8b 40 04             	mov    0x4(%eax),%eax
  803bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bfa:	c1 e2 04             	shl    $0x4,%edx
  803bfd:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803c03:	89 02                	mov    %eax,(%edx)
  803c05:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c08:	8b 40 04             	mov    0x4(%eax),%eax
  803c0b:	85 c0                	test   %eax,%eax
  803c0d:	74 0f                	je     803c1e <alloc_block+0x36f>
  803c0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c12:	8b 40 04             	mov    0x4(%eax),%eax
  803c15:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803c18:	8b 12                	mov    (%edx),%edx
  803c1a:	89 10                	mov    %edx,(%eax)
  803c1c:	eb 13                	jmp    803c31 <alloc_block+0x382>
  803c1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c21:	8b 00                	mov    (%eax),%eax
  803c23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c26:	c1 e2 04             	shl    $0x4,%edx
  803c29:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803c2f:	89 02                	mov    %eax,(%edx)
  803c31:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c47:	c1 e0 04             	shl    $0x4,%eax
  803c4a:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803c4f:	8b 00                	mov    (%eax),%eax
  803c51:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	c1 e0 04             	shl    $0x4,%eax
  803c5a:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803c5f:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803c61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c64:	83 ec 0c             	sub    $0xc,%esp
  803c67:	50                   	push   %eax
  803c68:	e8 fe f8 ff ff       	call   80356b <to_page_info>
  803c6d:	83 c4 10             	add    $0x10,%esp
  803c70:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  803c73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c76:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c7a:	48                   	dec    %eax
  803c7b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c7e:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803c82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c85:	eb 32                	jmp    803cb9 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803c87:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803c8b:	77 15                	ja     803ca2 <alloc_block+0x3f3>
  803c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c90:	c1 e0 04             	shl    $0x4,%eax
  803c93:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803c98:	8b 00                	mov    (%eax),%eax
  803c9a:	85 c0                	test   %eax,%eax
  803c9c:	0f 84 f1 fe ff ff    	je     803b93 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  803ca2:	83 ec 04             	sub    $0x4,%esp
  803ca5:	68 ff 53 80 00       	push   $0x8053ff
  803caa:	68 c8 00 00 00       	push   $0xc8
  803caf:	68 23 53 80 00       	push   $0x805323
  803cb4:	e8 2c df ff ff       	call   801be5 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  803cb9:	c9                   	leave  
  803cba:	c3                   	ret    

00803cbb <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803cbb:	55                   	push   %ebp
  803cbc:	89 e5                	mov    %esp,%ebp
  803cbe:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc4:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803cc9:	39 c2                	cmp    %eax,%edx
  803ccb:	72 0c                	jb     803cd9 <free_block+0x1e>
  803ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  803cd0:	a1 20 62 80 00       	mov    0x806220,%eax
  803cd5:	39 c2                	cmp    %eax,%edx
  803cd7:	72 19                	jb     803cf2 <free_block+0x37>
  803cd9:	68 10 54 80 00       	push   $0x805410
  803cde:	68 86 53 80 00       	push   $0x805386
  803ce3:	68 d7 00 00 00       	push   $0xd7
  803ce8:	68 23 53 80 00       	push   $0x805323
  803ced:	e8 f3 de ff ff       	call   801be5 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  803cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfb:	83 ec 0c             	sub    $0xc,%esp
  803cfe:	50                   	push   %eax
  803cff:	e8 67 f8 ff ff       	call   80356b <to_page_info>
  803d04:	83 c4 10             	add    $0x10,%esp
  803d07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  803d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0d:	8b 40 08             	mov    0x8(%eax),%eax
  803d10:	0f b7 c0             	movzwl %ax,%eax
  803d13:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803d16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803d1d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803d24:	eb 19                	jmp    803d3f <free_block+0x84>
	    if ((1 << i) == blk_size)
  803d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d29:	ba 01 00 00 00       	mov    $0x1,%edx
  803d2e:	88 c1                	mov    %al,%cl
  803d30:	d3 e2                	shl    %cl,%edx
  803d32:	89 d0                	mov    %edx,%eax
  803d34:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d37:	74 0e                	je     803d47 <free_block+0x8c>
	        break;
	    idx++;
  803d39:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803d3c:	ff 45 f0             	incl   -0x10(%ebp)
  803d3f:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803d43:	7e e1                	jle    803d26 <free_block+0x6b>
  803d45:	eb 01                	jmp    803d48 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  803d47:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  803d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803d4f:	40                   	inc    %eax
  803d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d53:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803d57:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d5b:	75 17                	jne    803d74 <free_block+0xb9>
  803d5d:	83 ec 04             	sub    $0x4,%esp
  803d60:	68 9c 53 80 00       	push   $0x80539c
  803d65:	68 ee 00 00 00       	push   $0xee
  803d6a:	68 23 53 80 00       	push   $0x805323
  803d6f:	e8 71 de ff ff       	call   801be5 <_panic>
  803d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d77:	c1 e0 04             	shl    $0x4,%eax
  803d7a:	05 64 e2 81 00       	add    $0x81e264,%eax
  803d7f:	8b 10                	mov    (%eax),%edx
  803d81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d84:	89 50 04             	mov    %edx,0x4(%eax)
  803d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d8a:	8b 40 04             	mov    0x4(%eax),%eax
  803d8d:	85 c0                	test   %eax,%eax
  803d8f:	74 14                	je     803da5 <free_block+0xea>
  803d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d94:	c1 e0 04             	shl    $0x4,%eax
  803d97:	05 64 e2 81 00       	add    $0x81e264,%eax
  803d9c:	8b 00                	mov    (%eax),%eax
  803d9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803da1:	89 10                	mov    %edx,(%eax)
  803da3:	eb 11                	jmp    803db6 <free_block+0xfb>
  803da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da8:	c1 e0 04             	shl    $0x4,%eax
  803dab:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  803db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db4:	89 02                	mov    %eax,(%edx)
  803db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db9:	c1 e0 04             	shl    $0x4,%eax
  803dbc:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  803dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dc5:	89 02                	mov    %eax,(%edx)
  803dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd3:	c1 e0 04             	shl    $0x4,%eax
  803dd6:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ddb:	8b 00                	mov    (%eax),%eax
  803ddd:	8d 50 01             	lea    0x1(%eax),%edx
  803de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de3:	c1 e0 04             	shl    $0x4,%eax
  803de6:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803deb:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  803ded:	b8 00 10 00 00       	mov    $0x1000,%eax
  803df2:	ba 00 00 00 00       	mov    $0x0,%edx
  803df7:	f7 75 e0             	divl   -0x20(%ebp)
  803dfa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  803dfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e00:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e04:	0f b7 c0             	movzwl %ax,%eax
  803e07:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803e0a:	0f 85 70 01 00 00    	jne    803f80 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803e10:	83 ec 0c             	sub    $0xc,%esp
  803e13:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e16:	e8 de f6 ff ff       	call   8034f9 <to_page_va>
  803e1b:	83 c4 10             	add    $0x10,%esp
  803e1e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803e21:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803e28:	e9 b7 00 00 00       	jmp    803ee4 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  803e2d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e33:	01 d0                	add    %edx,%eax
  803e35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  803e38:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e3c:	75 17                	jne    803e55 <free_block+0x19a>
  803e3e:	83 ec 04             	sub    $0x4,%esp
  803e41:	68 e1 53 80 00       	push   $0x8053e1
  803e46:	68 f8 00 00 00       	push   $0xf8
  803e4b:	68 23 53 80 00       	push   $0x805323
  803e50:	e8 90 dd ff ff       	call   801be5 <_panic>
  803e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e58:	8b 00                	mov    (%eax),%eax
  803e5a:	85 c0                	test   %eax,%eax
  803e5c:	74 10                	je     803e6e <free_block+0x1b3>
  803e5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e61:	8b 00                	mov    (%eax),%eax
  803e63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e66:	8b 52 04             	mov    0x4(%edx),%edx
  803e69:	89 50 04             	mov    %edx,0x4(%eax)
  803e6c:	eb 14                	jmp    803e82 <free_block+0x1c7>
  803e6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e71:	8b 40 04             	mov    0x4(%eax),%eax
  803e74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e77:	c1 e2 04             	shl    $0x4,%edx
  803e7a:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803e80:	89 02                	mov    %eax,(%edx)
  803e82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e85:	8b 40 04             	mov    0x4(%eax),%eax
  803e88:	85 c0                	test   %eax,%eax
  803e8a:	74 0f                	je     803e9b <free_block+0x1e0>
  803e8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e8f:	8b 40 04             	mov    0x4(%eax),%eax
  803e92:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e95:	8b 12                	mov    (%edx),%edx
  803e97:	89 10                	mov    %edx,(%eax)
  803e99:	eb 13                	jmp    803eae <free_block+0x1f3>
  803e9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9e:	8b 00                	mov    (%eax),%eax
  803ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ea3:	c1 e2 04             	shl    $0x4,%edx
  803ea6:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803eac:	89 02                	mov    %eax,(%edx)
  803eae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec4:	c1 e0 04             	shl    $0x4,%eax
  803ec7:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ecc:	8b 00                	mov    (%eax),%eax
  803ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed4:	c1 e0 04             	shl    $0x4,%eax
  803ed7:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803edc:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ee1:	01 45 ec             	add    %eax,-0x14(%ebp)
  803ee4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803eeb:	0f 86 3c ff ff ff    	jbe    803e2d <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  803ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef4:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efd:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803f03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f07:	75 17                	jne    803f20 <free_block+0x265>
  803f09:	83 ec 04             	sub    $0x4,%esp
  803f0c:	68 9c 53 80 00       	push   $0x80539c
  803f11:	68 fe 00 00 00       	push   $0xfe
  803f16:	68 23 53 80 00       	push   $0x805323
  803f1b:	e8 c5 dc ff ff       	call   801be5 <_panic>
  803f20:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f29:	89 50 04             	mov    %edx,0x4(%eax)
  803f2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2f:	8b 40 04             	mov    0x4(%eax),%eax
  803f32:	85 c0                	test   %eax,%eax
  803f34:	74 0c                	je     803f42 <free_block+0x287>
  803f36:	a1 2c 62 80 00       	mov    0x80622c,%eax
  803f3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f3e:	89 10                	mov    %edx,(%eax)
  803f40:	eb 08                	jmp    803f4a <free_block+0x28f>
  803f42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f45:	a3 28 62 80 00       	mov    %eax,0x806228
  803f4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4d:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f5b:	a1 34 62 80 00       	mov    0x806234,%eax
  803f60:	40                   	inc    %eax
  803f61:	a3 34 62 80 00       	mov    %eax,0x806234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803f66:	83 ec 0c             	sub    $0xc,%esp
  803f69:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f6c:	e8 88 f5 ff ff       	call   8034f9 <to_page_va>
  803f71:	83 c4 10             	add    $0x10,%esp
  803f74:	83 ec 0c             	sub    $0xc,%esp
  803f77:	50                   	push   %eax
  803f78:	e8 b8 ee ff ff       	call   802e35 <return_page>
  803f7d:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803f80:	90                   	nop
  803f81:	c9                   	leave  
  803f82:	c3                   	ret    

00803f83 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803f83:	55                   	push   %ebp
  803f84:	89 e5                	mov    %esp,%ebp
  803f86:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803f89:	83 ec 04             	sub    $0x4,%esp
  803f8c:	68 48 54 80 00       	push   $0x805448
  803f91:	68 11 01 00 00       	push   $0x111
  803f96:	68 23 53 80 00       	push   $0x805323
  803f9b:	e8 45 dc ff ff       	call   801be5 <_panic>

00803fa0 <__udivdi3>:
  803fa0:	55                   	push   %ebp
  803fa1:	57                   	push   %edi
  803fa2:	56                   	push   %esi
  803fa3:	53                   	push   %ebx
  803fa4:	83 ec 1c             	sub    $0x1c,%esp
  803fa7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803faf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fb3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fb7:	89 ca                	mov    %ecx,%edx
  803fb9:	89 f8                	mov    %edi,%eax
  803fbb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fbf:	85 f6                	test   %esi,%esi
  803fc1:	75 2d                	jne    803ff0 <__udivdi3+0x50>
  803fc3:	39 cf                	cmp    %ecx,%edi
  803fc5:	77 65                	ja     80402c <__udivdi3+0x8c>
  803fc7:	89 fd                	mov    %edi,%ebp
  803fc9:	85 ff                	test   %edi,%edi
  803fcb:	75 0b                	jne    803fd8 <__udivdi3+0x38>
  803fcd:	b8 01 00 00 00       	mov    $0x1,%eax
  803fd2:	31 d2                	xor    %edx,%edx
  803fd4:	f7 f7                	div    %edi
  803fd6:	89 c5                	mov    %eax,%ebp
  803fd8:	31 d2                	xor    %edx,%edx
  803fda:	89 c8                	mov    %ecx,%eax
  803fdc:	f7 f5                	div    %ebp
  803fde:	89 c1                	mov    %eax,%ecx
  803fe0:	89 d8                	mov    %ebx,%eax
  803fe2:	f7 f5                	div    %ebp
  803fe4:	89 cf                	mov    %ecx,%edi
  803fe6:	89 fa                	mov    %edi,%edx
  803fe8:	83 c4 1c             	add    $0x1c,%esp
  803feb:	5b                   	pop    %ebx
  803fec:	5e                   	pop    %esi
  803fed:	5f                   	pop    %edi
  803fee:	5d                   	pop    %ebp
  803fef:	c3                   	ret    
  803ff0:	39 ce                	cmp    %ecx,%esi
  803ff2:	77 28                	ja     80401c <__udivdi3+0x7c>
  803ff4:	0f bd fe             	bsr    %esi,%edi
  803ff7:	83 f7 1f             	xor    $0x1f,%edi
  803ffa:	75 40                	jne    80403c <__udivdi3+0x9c>
  803ffc:	39 ce                	cmp    %ecx,%esi
  803ffe:	72 0a                	jb     80400a <__udivdi3+0x6a>
  804000:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804004:	0f 87 9e 00 00 00    	ja     8040a8 <__udivdi3+0x108>
  80400a:	b8 01 00 00 00       	mov    $0x1,%eax
  80400f:	89 fa                	mov    %edi,%edx
  804011:	83 c4 1c             	add    $0x1c,%esp
  804014:	5b                   	pop    %ebx
  804015:	5e                   	pop    %esi
  804016:	5f                   	pop    %edi
  804017:	5d                   	pop    %ebp
  804018:	c3                   	ret    
  804019:	8d 76 00             	lea    0x0(%esi),%esi
  80401c:	31 ff                	xor    %edi,%edi
  80401e:	31 c0                	xor    %eax,%eax
  804020:	89 fa                	mov    %edi,%edx
  804022:	83 c4 1c             	add    $0x1c,%esp
  804025:	5b                   	pop    %ebx
  804026:	5e                   	pop    %esi
  804027:	5f                   	pop    %edi
  804028:	5d                   	pop    %ebp
  804029:	c3                   	ret    
  80402a:	66 90                	xchg   %ax,%ax
  80402c:	89 d8                	mov    %ebx,%eax
  80402e:	f7 f7                	div    %edi
  804030:	31 ff                	xor    %edi,%edi
  804032:	89 fa                	mov    %edi,%edx
  804034:	83 c4 1c             	add    $0x1c,%esp
  804037:	5b                   	pop    %ebx
  804038:	5e                   	pop    %esi
  804039:	5f                   	pop    %edi
  80403a:	5d                   	pop    %ebp
  80403b:	c3                   	ret    
  80403c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804041:	89 eb                	mov    %ebp,%ebx
  804043:	29 fb                	sub    %edi,%ebx
  804045:	89 f9                	mov    %edi,%ecx
  804047:	d3 e6                	shl    %cl,%esi
  804049:	89 c5                	mov    %eax,%ebp
  80404b:	88 d9                	mov    %bl,%cl
  80404d:	d3 ed                	shr    %cl,%ebp
  80404f:	89 e9                	mov    %ebp,%ecx
  804051:	09 f1                	or     %esi,%ecx
  804053:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804057:	89 f9                	mov    %edi,%ecx
  804059:	d3 e0                	shl    %cl,%eax
  80405b:	89 c5                	mov    %eax,%ebp
  80405d:	89 d6                	mov    %edx,%esi
  80405f:	88 d9                	mov    %bl,%cl
  804061:	d3 ee                	shr    %cl,%esi
  804063:	89 f9                	mov    %edi,%ecx
  804065:	d3 e2                	shl    %cl,%edx
  804067:	8b 44 24 08          	mov    0x8(%esp),%eax
  80406b:	88 d9                	mov    %bl,%cl
  80406d:	d3 e8                	shr    %cl,%eax
  80406f:	09 c2                	or     %eax,%edx
  804071:	89 d0                	mov    %edx,%eax
  804073:	89 f2                	mov    %esi,%edx
  804075:	f7 74 24 0c          	divl   0xc(%esp)
  804079:	89 d6                	mov    %edx,%esi
  80407b:	89 c3                	mov    %eax,%ebx
  80407d:	f7 e5                	mul    %ebp
  80407f:	39 d6                	cmp    %edx,%esi
  804081:	72 19                	jb     80409c <__udivdi3+0xfc>
  804083:	74 0b                	je     804090 <__udivdi3+0xf0>
  804085:	89 d8                	mov    %ebx,%eax
  804087:	31 ff                	xor    %edi,%edi
  804089:	e9 58 ff ff ff       	jmp    803fe6 <__udivdi3+0x46>
  80408e:	66 90                	xchg   %ax,%ax
  804090:	8b 54 24 08          	mov    0x8(%esp),%edx
  804094:	89 f9                	mov    %edi,%ecx
  804096:	d3 e2                	shl    %cl,%edx
  804098:	39 c2                	cmp    %eax,%edx
  80409a:	73 e9                	jae    804085 <__udivdi3+0xe5>
  80409c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80409f:	31 ff                	xor    %edi,%edi
  8040a1:	e9 40 ff ff ff       	jmp    803fe6 <__udivdi3+0x46>
  8040a6:	66 90                	xchg   %ax,%ax
  8040a8:	31 c0                	xor    %eax,%eax
  8040aa:	e9 37 ff ff ff       	jmp    803fe6 <__udivdi3+0x46>
  8040af:	90                   	nop

008040b0 <__umoddi3>:
  8040b0:	55                   	push   %ebp
  8040b1:	57                   	push   %edi
  8040b2:	56                   	push   %esi
  8040b3:	53                   	push   %ebx
  8040b4:	83 ec 1c             	sub    $0x1c,%esp
  8040b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040cf:	89 f3                	mov    %esi,%ebx
  8040d1:	89 fa                	mov    %edi,%edx
  8040d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040d7:	89 34 24             	mov    %esi,(%esp)
  8040da:	85 c0                	test   %eax,%eax
  8040dc:	75 1a                	jne    8040f8 <__umoddi3+0x48>
  8040de:	39 f7                	cmp    %esi,%edi
  8040e0:	0f 86 a2 00 00 00    	jbe    804188 <__umoddi3+0xd8>
  8040e6:	89 c8                	mov    %ecx,%eax
  8040e8:	89 f2                	mov    %esi,%edx
  8040ea:	f7 f7                	div    %edi
  8040ec:	89 d0                	mov    %edx,%eax
  8040ee:	31 d2                	xor    %edx,%edx
  8040f0:	83 c4 1c             	add    $0x1c,%esp
  8040f3:	5b                   	pop    %ebx
  8040f4:	5e                   	pop    %esi
  8040f5:	5f                   	pop    %edi
  8040f6:	5d                   	pop    %ebp
  8040f7:	c3                   	ret    
  8040f8:	39 f0                	cmp    %esi,%eax
  8040fa:	0f 87 ac 00 00 00    	ja     8041ac <__umoddi3+0xfc>
  804100:	0f bd e8             	bsr    %eax,%ebp
  804103:	83 f5 1f             	xor    $0x1f,%ebp
  804106:	0f 84 ac 00 00 00    	je     8041b8 <__umoddi3+0x108>
  80410c:	bf 20 00 00 00       	mov    $0x20,%edi
  804111:	29 ef                	sub    %ebp,%edi
  804113:	89 fe                	mov    %edi,%esi
  804115:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804119:	89 e9                	mov    %ebp,%ecx
  80411b:	d3 e0                	shl    %cl,%eax
  80411d:	89 d7                	mov    %edx,%edi
  80411f:	89 f1                	mov    %esi,%ecx
  804121:	d3 ef                	shr    %cl,%edi
  804123:	09 c7                	or     %eax,%edi
  804125:	89 e9                	mov    %ebp,%ecx
  804127:	d3 e2                	shl    %cl,%edx
  804129:	89 14 24             	mov    %edx,(%esp)
  80412c:	89 d8                	mov    %ebx,%eax
  80412e:	d3 e0                	shl    %cl,%eax
  804130:	89 c2                	mov    %eax,%edx
  804132:	8b 44 24 08          	mov    0x8(%esp),%eax
  804136:	d3 e0                	shl    %cl,%eax
  804138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80413c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804140:	89 f1                	mov    %esi,%ecx
  804142:	d3 e8                	shr    %cl,%eax
  804144:	09 d0                	or     %edx,%eax
  804146:	d3 eb                	shr    %cl,%ebx
  804148:	89 da                	mov    %ebx,%edx
  80414a:	f7 f7                	div    %edi
  80414c:	89 d3                	mov    %edx,%ebx
  80414e:	f7 24 24             	mull   (%esp)
  804151:	89 c6                	mov    %eax,%esi
  804153:	89 d1                	mov    %edx,%ecx
  804155:	39 d3                	cmp    %edx,%ebx
  804157:	0f 82 87 00 00 00    	jb     8041e4 <__umoddi3+0x134>
  80415d:	0f 84 91 00 00 00    	je     8041f4 <__umoddi3+0x144>
  804163:	8b 54 24 04          	mov    0x4(%esp),%edx
  804167:	29 f2                	sub    %esi,%edx
  804169:	19 cb                	sbb    %ecx,%ebx
  80416b:	89 d8                	mov    %ebx,%eax
  80416d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804171:	d3 e0                	shl    %cl,%eax
  804173:	89 e9                	mov    %ebp,%ecx
  804175:	d3 ea                	shr    %cl,%edx
  804177:	09 d0                	or     %edx,%eax
  804179:	89 e9                	mov    %ebp,%ecx
  80417b:	d3 eb                	shr    %cl,%ebx
  80417d:	89 da                	mov    %ebx,%edx
  80417f:	83 c4 1c             	add    $0x1c,%esp
  804182:	5b                   	pop    %ebx
  804183:	5e                   	pop    %esi
  804184:	5f                   	pop    %edi
  804185:	5d                   	pop    %ebp
  804186:	c3                   	ret    
  804187:	90                   	nop
  804188:	89 fd                	mov    %edi,%ebp
  80418a:	85 ff                	test   %edi,%edi
  80418c:	75 0b                	jne    804199 <__umoddi3+0xe9>
  80418e:	b8 01 00 00 00       	mov    $0x1,%eax
  804193:	31 d2                	xor    %edx,%edx
  804195:	f7 f7                	div    %edi
  804197:	89 c5                	mov    %eax,%ebp
  804199:	89 f0                	mov    %esi,%eax
  80419b:	31 d2                	xor    %edx,%edx
  80419d:	f7 f5                	div    %ebp
  80419f:	89 c8                	mov    %ecx,%eax
  8041a1:	f7 f5                	div    %ebp
  8041a3:	89 d0                	mov    %edx,%eax
  8041a5:	e9 44 ff ff ff       	jmp    8040ee <__umoddi3+0x3e>
  8041aa:	66 90                	xchg   %ax,%ax
  8041ac:	89 c8                	mov    %ecx,%eax
  8041ae:	89 f2                	mov    %esi,%edx
  8041b0:	83 c4 1c             	add    $0x1c,%esp
  8041b3:	5b                   	pop    %ebx
  8041b4:	5e                   	pop    %esi
  8041b5:	5f                   	pop    %edi
  8041b6:	5d                   	pop    %ebp
  8041b7:	c3                   	ret    
  8041b8:	3b 04 24             	cmp    (%esp),%eax
  8041bb:	72 06                	jb     8041c3 <__umoddi3+0x113>
  8041bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041c1:	77 0f                	ja     8041d2 <__umoddi3+0x122>
  8041c3:	89 f2                	mov    %esi,%edx
  8041c5:	29 f9                	sub    %edi,%ecx
  8041c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041cb:	89 14 24             	mov    %edx,(%esp)
  8041ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041d6:	8b 14 24             	mov    (%esp),%edx
  8041d9:	83 c4 1c             	add    $0x1c,%esp
  8041dc:	5b                   	pop    %ebx
  8041dd:	5e                   	pop    %esi
  8041de:	5f                   	pop    %edi
  8041df:	5d                   	pop    %ebp
  8041e0:	c3                   	ret    
  8041e1:	8d 76 00             	lea    0x0(%esi),%esi
  8041e4:	2b 04 24             	sub    (%esp),%eax
  8041e7:	19 fa                	sbb    %edi,%edx
  8041e9:	89 d1                	mov    %edx,%ecx
  8041eb:	89 c6                	mov    %eax,%esi
  8041ed:	e9 71 ff ff ff       	jmp    804163 <__umoddi3+0xb3>
  8041f2:	66 90                	xchg   %ax,%ax
  8041f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041f8:	72 ea                	jb     8041e4 <__umoddi3+0x134>
  8041fa:	89 d9                	mov    %ebx,%ecx
  8041fc:	e9 62 ff ff ff       	jmp    804163 <__umoddi3+0xb3>
