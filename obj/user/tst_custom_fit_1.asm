
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
  800031:	e8 cf 10 00 00       	call   801105 <libmain>
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
  800067:	e8 f9 24 00 00       	call   802565 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 3c 25 00 00       	call   8025b0 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 a5 22 00 00       	call   80236c <malloc>
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
  8000df:	e8 81 24 00 00       	call   802565 <sys_calculate_free_frames>
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
  80012c:	e8 a6 12 00 00       	call   8013d7 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 77 24 00 00       	call   8025b0 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 7c 39 80 00       	push   $0x80397c
  800150:	6a 0c                	push   $0xc
  800152:	e8 80 12 00 00       	call   8013d7 <cprintf_colored>
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
  800174:	e8 ec 23 00 00       	call   802565 <sys_calculate_free_frames>
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
  8001b9:	e8 a7 23 00 00       	call   802565 <sys_calculate_free_frames>
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
  8001ff:	e8 d3 11 00 00       	call   8013d7 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 a4 23 00 00       	call   8025b0 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 80 3a 80 00       	push   $0x803a80
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 a6 11 00 00       	call   8013d7 <cprintf_colored>
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
  800270:	e8 b2 26 00 00       	call   802927 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 f8 3a 80 00       	push   $0x803af8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 41 11 00 00       	call   8013d7 <cprintf_colored>
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
  8002ae:	e8 b2 22 00 00       	call   802565 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 f5 22 00 00       	call   8025b0 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 c9 20 00 00       	call   80239a <free>
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
  8002fc:	e8 af 22 00 00       	call   8025b0 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 30 3b 80 00       	push   $0x803b30
  800318:	6a 0c                	push   $0xc
  80031a:	e8 b8 10 00 00       	call   8013d7 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 3e 22 00 00       	call   802565 <sys_calculate_free_frames>
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
  800349:	e8 89 10 00 00       	call   8013d7 <cprintf_colored>
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
  8003a0:	e8 82 25 00 00       	call   802927 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 d8 3b 80 00       	push   $0x803bd8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 11 10 00 00       	call   8013d7 <cprintf_colored>
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
  80041d:	e8 b5 0f 00 00       	call   8013d7 <cprintf_colored>
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
  8004e6:	e8 ec 0e 00 00       	call   8013d7 <cprintf_colored>
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
  8005c0:	e8 12 0e 00 00       	call   8013d7 <cprintf_colored>
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
  80069a:	e8 38 0d 00 00       	call   8013d7 <cprintf_colored>
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
  800774:	e8 5e 0c 00 00       	call   8013d7 <cprintf_colored>
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
  80084e:	e8 84 0b 00 00       	call   8013d7 <cprintf_colored>
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
  800928:	e8 aa 0a 00 00       	call   8013d7 <cprintf_colored>
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
  800a1d:	e8 b5 09 00 00       	call   8013d7 <cprintf_colored>
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
  800b1b:	e8 b7 08 00 00       	call   8013d7 <cprintf_colored>
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
  800c19:	e8 b9 07 00 00       	call   8013d7 <cprintf_colored>
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
  800d17:	e8 bb 06 00 00       	call   8013d7 <cprintf_colored>
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
  800e04:	e8 ce 05 00 00       	call   8013d7 <cprintf_colored>
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
  800ef1:	e8 e1 04 00 00       	call   8013d7 <cprintf_colored>
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
  800fde:	e8 f4 03 00 00       	call   8013d7 <cprintf_colored>
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
  801001:	e8 d1 03 00 00       	call   8013d7 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 46 15 00 00       	call   802565 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 86 15 00 00       	call   8025b0 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 12 13 00 00       	call   80236c <malloc>
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
  80108b:	e8 47 03 00 00       	call   8013d7 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 18 15 00 00       	call   8025b0 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 ec 3c 80 00       	push   $0x803cec
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 1b 03 00 00       	call   8013d7 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 a1 14 00 00       	call   802565 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 5c 3d 80 00       	push   $0x803d5c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 ef 02 00 00       	call   8013d7 <cprintf_colored>
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

	cprintf_colored(TEXT_light_green, "%~\ntest CUSTOM FIT (1) [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);

	return;
#endif
}
  801102:	90                   	nop
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
  80110b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80110e:	e8 1b 16 00 00       	call   80272e <sys_getenvindex>
  801113:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801116:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 06             	shl    $0x6,%eax
  80111e:	29 d0                	sub    %edx,%eax
  801120:	c1 e0 02             	shl    $0x2,%eax
  801123:	01 d0                	add    %edx,%eax
  801125:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80112c:	01 c8                	add    %ecx,%eax
  80112e:	c1 e0 03             	shl    $0x3,%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80113a:	29 c2                	sub    %eax,%edx
  80113c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  801143:	89 c2                	mov    %eax,%edx
  801145:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80114b:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801150:	a1 00 52 80 00       	mov    0x805200,%eax
  801155:	8a 40 20             	mov    0x20(%eax),%al
  801158:	84 c0                	test   %al,%al
  80115a:	74 0d                	je     801169 <libmain+0x64>
		binaryname = myEnv->prog_name;
  80115c:	a1 00 52 80 00       	mov    0x805200,%eax
  801161:	83 c0 20             	add    $0x20,%eax
  801164:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801169:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116d:	7e 0a                	jle    801179 <libmain+0x74>
		binaryname = argv[0];
  80116f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801172:	8b 00                	mov    (%eax),%eax
  801174:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	ff 75 0c             	pushl  0xc(%ebp)
  80117f:	ff 75 08             	pushl  0x8(%ebp)
  801182:	e8 78 ff ff ff       	call   8010ff <_main>
  801187:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80118a:	a1 00 50 80 00       	mov    0x805000,%eax
  80118f:	85 c0                	test   %eax,%eax
  801191:	0f 84 01 01 00 00    	je     801298 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801197:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80119d:	bb 9c 3e 80 00       	mov    $0x803e9c,%ebx
  8011a2:	ba 0e 00 00 00       	mov    $0xe,%edx
  8011a7:	89 c7                	mov    %eax,%edi
  8011a9:	89 de                	mov    %ebx,%esi
  8011ab:	89 d1                	mov    %edx,%ecx
  8011ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8011af:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8011b2:	b9 56 00 00 00       	mov    $0x56,%ecx
  8011b7:	b0 00                	mov    $0x0,%al
  8011b9:	89 d7                	mov    %edx,%edi
  8011bb:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8011bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8011c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011c7:	83 ec 08             	sub    $0x8,%esp
  8011ca:	50                   	push   %eax
  8011cb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011d1:	50                   	push   %eax
  8011d2:	e8 8d 17 00 00       	call   802964 <sys_utilities>
  8011d7:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8011da:	e8 d6 12 00 00       	call   8024b5 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	68 bc 3d 80 00       	push   $0x803dbc
  8011e7:	e8 be 01 00 00       	call   8013aa <cprintf>
  8011ec:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8011ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	74 18                	je     80120e <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8011f6:	e8 87 17 00 00       	call   802982 <sys_get_optimal_num_faults>
  8011fb:	83 ec 08             	sub    $0x8,%esp
  8011fe:	50                   	push   %eax
  8011ff:	68 e4 3d 80 00       	push   $0x803de4
  801204:	e8 a1 01 00 00       	call   8013aa <cprintf>
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	eb 59                	jmp    801267 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80120e:	a1 00 52 80 00       	mov    0x805200,%eax
  801213:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  801219:	a1 00 52 80 00       	mov    0x805200,%eax
  80121e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	52                   	push   %edx
  801228:	50                   	push   %eax
  801229:	68 08 3e 80 00       	push   $0x803e08
  80122e:	e8 77 01 00 00       	call   8013aa <cprintf>
  801233:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801236:	a1 00 52 80 00       	mov    0x805200,%eax
  80123b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  801241:	a1 00 52 80 00       	mov    0x805200,%eax
  801246:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80124c:	a1 00 52 80 00       	mov    0x805200,%eax
  801251:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  801257:	51                   	push   %ecx
  801258:	52                   	push   %edx
  801259:	50                   	push   %eax
  80125a:	68 30 3e 80 00       	push   $0x803e30
  80125f:	e8 46 01 00 00       	call   8013aa <cprintf>
  801264:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801267:	a1 00 52 80 00       	mov    0x805200,%eax
  80126c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  801272:	83 ec 08             	sub    $0x8,%esp
  801275:	50                   	push   %eax
  801276:	68 88 3e 80 00       	push   $0x803e88
  80127b:	e8 2a 01 00 00       	call   8013aa <cprintf>
  801280:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801283:	83 ec 0c             	sub    $0xc,%esp
  801286:	68 bc 3d 80 00       	push   $0x803dbc
  80128b:	e8 1a 01 00 00       	call   8013aa <cprintf>
  801290:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801293:	e8 37 12 00 00       	call   8024cf <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801298:	e8 1f 00 00 00       	call   8012bc <exit>
}
  80129d:	90                   	nop
  80129e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    

008012a6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8012ac:	83 ec 0c             	sub    $0xc,%esp
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 44 14 00 00       	call   8026fa <sys_destroy_env>
  8012b6:	83 c4 10             	add    $0x10,%esp
}
  8012b9:	90                   	nop
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <exit>:

void
exit(void)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012c2:	e8 99 14 00 00       	call   802760 <sys_exit_env>
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	53                   	push   %ebx
  8012ce:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	8b 00                	mov    (%eax),%eax
  8012d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8012d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dc:	89 0a                	mov    %ecx,(%edx)
  8012de:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e1:	88 d1                	mov    %dl,%cl
  8012e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8012ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ed:	8b 00                	mov    (%eax),%eax
  8012ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8012f4:	75 30                	jne    801326 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8012f6:	8b 15 f8 d2 81 00    	mov    0x81d2f8,%edx
  8012fc:	a0 24 52 80 00       	mov    0x805224,%al
  801301:	0f b6 c0             	movzbl %al,%eax
  801304:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801307:	8b 09                	mov    (%ecx),%ecx
  801309:	89 cb                	mov    %ecx,%ebx
  80130b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130e:	83 c1 08             	add    $0x8,%ecx
  801311:	52                   	push   %edx
  801312:	50                   	push   %eax
  801313:	53                   	push   %ebx
  801314:	51                   	push   %ecx
  801315:	e8 57 11 00 00       	call   802471 <sys_cputs>
  80131a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	8b 40 04             	mov    0x4(%eax),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	89 50 04             	mov    %edx,0x4(%eax)
}
  801335:	90                   	nop
  801336:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801344:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80134b:	00 00 00 
	b.cnt = 0;
  80134e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801355:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801358:	ff 75 0c             	pushl  0xc(%ebp)
  80135b:	ff 75 08             	pushl  0x8(%ebp)
  80135e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801364:	50                   	push   %eax
  801365:	68 ca 12 80 00       	push   $0x8012ca
  80136a:	e8 5a 02 00 00       	call   8015c9 <vprintfmt>
  80136f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801372:	8b 15 f8 d2 81 00    	mov    0x81d2f8,%edx
  801378:	a0 24 52 80 00       	mov    0x805224,%al
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801386:	52                   	push   %edx
  801387:	50                   	push   %eax
  801388:	51                   	push   %ecx
  801389:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80138f:	83 c0 08             	add    $0x8,%eax
  801392:	50                   	push   %eax
  801393:	e8 d9 10 00 00       	call   802471 <sys_cputs>
  801398:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80139b:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  8013a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8013b0:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  8013b7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8013ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c6:	50                   	push   %eax
  8013c7:	e8 6f ff ff ff       	call   80133b <vcprintf>
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8013d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8013dd:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	c1 e0 08             	shl    $0x8,%eax
  8013ea:	a3 f8 d2 81 00       	mov    %eax,0x81d2f8
	va_start(ap, fmt);
  8013ef:	8d 45 0c             	lea    0xc(%ebp),%eax
  8013f2:	83 c0 04             	add    $0x4,%eax
  8013f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	83 ec 08             	sub    $0x8,%esp
  8013fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801401:	50                   	push   %eax
  801402:	e8 34 ff ff ff       	call   80133b <vcprintf>
  801407:	83 c4 10             	add    $0x10,%esp
  80140a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80140d:	c7 05 f8 d2 81 00 00 	movl   $0x700,0x81d2f8
  801414:	07 00 00 

	return cnt;
  801417:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801422:	e8 8e 10 00 00       	call   8024b5 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801427:	8d 45 0c             	lea    0xc(%ebp),%eax
  80142a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	83 ec 08             	sub    $0x8,%esp
  801433:	ff 75 f4             	pushl  -0xc(%ebp)
  801436:	50                   	push   %eax
  801437:	e8 ff fe ff ff       	call   80133b <vcprintf>
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801442:	e8 88 10 00 00       	call   8024cf <sys_unlock_cons>
	return cnt;
  801447:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	53                   	push   %ebx
  801450:	83 ec 14             	sub    $0x14,%esp
  801453:	8b 45 10             	mov    0x10(%ebp),%eax
  801456:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801459:	8b 45 14             	mov    0x14(%ebp),%eax
  80145c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80145f:	8b 45 18             	mov    0x18(%ebp),%eax
  801462:	ba 00 00 00 00       	mov    $0x0,%edx
  801467:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80146a:	77 55                	ja     8014c1 <printnum+0x75>
  80146c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80146f:	72 05                	jb     801476 <printnum+0x2a>
  801471:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801474:	77 4b                	ja     8014c1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801476:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801479:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80147c:	8b 45 18             	mov    0x18(%ebp),%eax
  80147f:	ba 00 00 00 00       	mov    $0x0,%edx
  801484:	52                   	push   %edx
  801485:	50                   	push   %eax
  801486:	ff 75 f4             	pushl  -0xc(%ebp)
  801489:	ff 75 f0             	pushl  -0x10(%ebp)
  80148c:	e8 f7 21 00 00       	call   803688 <__udivdi3>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	83 ec 04             	sub    $0x4,%esp
  801497:	ff 75 20             	pushl  0x20(%ebp)
  80149a:	53                   	push   %ebx
  80149b:	ff 75 18             	pushl  0x18(%ebp)
  80149e:	52                   	push   %edx
  80149f:	50                   	push   %eax
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	e8 a1 ff ff ff       	call   80144c <printnum>
  8014ab:	83 c4 20             	add    $0x20,%esp
  8014ae:	eb 1a                	jmp    8014ca <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8014b0:	83 ec 08             	sub    $0x8,%esp
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	ff 75 20             	pushl  0x20(%ebp)
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	ff d0                	call   *%eax
  8014be:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8014c1:	ff 4d 1c             	decl   0x1c(%ebp)
  8014c4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8014c8:	7f e6                	jg     8014b0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8014ca:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8014cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d8:	53                   	push   %ebx
  8014d9:	51                   	push   %ecx
  8014da:	52                   	push   %edx
  8014db:	50                   	push   %eax
  8014dc:	e8 b7 22 00 00       	call   803798 <__umoddi3>
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	05 14 41 80 00       	add    $0x804114,%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	0f be c0             	movsbl %al,%eax
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	ff 75 0c             	pushl  0xc(%ebp)
  8014f4:	50                   	push   %eax
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	ff d0                	call   *%eax
  8014fa:	83 c4 10             	add    $0x10,%esp
}
  8014fd:	90                   	nop
  8014fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801506:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80150a:	7e 1c                	jle    801528 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8b 00                	mov    (%eax),%eax
  801511:	8d 50 08             	lea    0x8(%eax),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	89 10                	mov    %edx,(%eax)
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	83 e8 08             	sub    $0x8,%eax
  801521:	8b 50 04             	mov    0x4(%eax),%edx
  801524:	8b 00                	mov    (%eax),%eax
  801526:	eb 40                	jmp    801568 <getuint+0x65>
	else if (lflag)
  801528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80152c:	74 1e                	je     80154c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8b 00                	mov    (%eax),%eax
  801533:	8d 50 04             	lea    0x4(%eax),%edx
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	89 10                	mov    %edx,(%eax)
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	83 e8 04             	sub    $0x4,%eax
  801543:	8b 00                	mov    (%eax),%eax
  801545:	ba 00 00 00 00       	mov    $0x0,%edx
  80154a:	eb 1c                	jmp    801568 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8b 00                	mov    (%eax),%eax
  801551:	8d 50 04             	lea    0x4(%eax),%edx
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	89 10                	mov    %edx,(%eax)
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	83 e8 04             	sub    $0x4,%eax
  801561:	8b 00                	mov    (%eax),%eax
  801563:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80156d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801571:	7e 1c                	jle    80158f <getint+0x25>
		return va_arg(*ap, long long);
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8b 00                	mov    (%eax),%eax
  801578:	8d 50 08             	lea    0x8(%eax),%edx
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	89 10                	mov    %edx,(%eax)
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	8b 00                	mov    (%eax),%eax
  801585:	83 e8 08             	sub    $0x8,%eax
  801588:	8b 50 04             	mov    0x4(%eax),%edx
  80158b:	8b 00                	mov    (%eax),%eax
  80158d:	eb 38                	jmp    8015c7 <getint+0x5d>
	else if (lflag)
  80158f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801593:	74 1a                	je     8015af <getint+0x45>
		return va_arg(*ap, long);
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8b 00                	mov    (%eax),%eax
  80159a:	8d 50 04             	lea    0x4(%eax),%edx
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	89 10                	mov    %edx,(%eax)
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8b 00                	mov    (%eax),%eax
  8015a7:	83 e8 04             	sub    $0x4,%eax
  8015aa:	8b 00                	mov    (%eax),%eax
  8015ac:	99                   	cltd   
  8015ad:	eb 18                	jmp    8015c7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	8b 00                	mov    (%eax),%eax
  8015b4:	8d 50 04             	lea    0x4(%eax),%edx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	89 10                	mov    %edx,(%eax)
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	8b 00                	mov    (%eax),%eax
  8015c1:	83 e8 04             	sub    $0x4,%eax
  8015c4:	8b 00                	mov    (%eax),%eax
  8015c6:	99                   	cltd   
}
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    

008015c9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015d1:	eb 17                	jmp    8015ea <vprintfmt+0x21>
			if (ch == '\0')
  8015d3:	85 db                	test   %ebx,%ebx
  8015d5:	0f 84 c1 03 00 00    	je     80199c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	53                   	push   %ebx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	ff d0                	call   *%eax
  8015e7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	8d 50 01             	lea    0x1(%eax),%edx
  8015f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	0f b6 d8             	movzbl %al,%ebx
  8015f8:	83 fb 25             	cmp    $0x25,%ebx
  8015fb:	75 d6                	jne    8015d3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8015fd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801601:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801608:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80160f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801616:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80161d:	8b 45 10             	mov    0x10(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 10             	mov    %edx,0x10(%ebp)
  801626:	8a 00                	mov    (%eax),%al
  801628:	0f b6 d8             	movzbl %al,%ebx
  80162b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80162e:	83 f8 5b             	cmp    $0x5b,%eax
  801631:	0f 87 3d 03 00 00    	ja     801974 <vprintfmt+0x3ab>
  801637:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
  80163e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801640:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801644:	eb d7                	jmp    80161d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801646:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80164a:	eb d1                	jmp    80161d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80164c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801653:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801656:	89 d0                	mov    %edx,%eax
  801658:	c1 e0 02             	shl    $0x2,%eax
  80165b:	01 d0                	add    %edx,%eax
  80165d:	01 c0                	add    %eax,%eax
  80165f:	01 d8                	add    %ebx,%eax
  801661:	83 e8 30             	sub    $0x30,%eax
  801664:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801667:	8b 45 10             	mov    0x10(%ebp),%eax
  80166a:	8a 00                	mov    (%eax),%al
  80166c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80166f:	83 fb 2f             	cmp    $0x2f,%ebx
  801672:	7e 3e                	jle    8016b2 <vprintfmt+0xe9>
  801674:	83 fb 39             	cmp    $0x39,%ebx
  801677:	7f 39                	jg     8016b2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801679:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80167c:	eb d5                	jmp    801653 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80167e:	8b 45 14             	mov    0x14(%ebp),%eax
  801681:	83 c0 04             	add    $0x4,%eax
  801684:	89 45 14             	mov    %eax,0x14(%ebp)
  801687:	8b 45 14             	mov    0x14(%ebp),%eax
  80168a:	83 e8 04             	sub    $0x4,%eax
  80168d:	8b 00                	mov    (%eax),%eax
  80168f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801692:	eb 1f                	jmp    8016b3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801694:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801698:	79 83                	jns    80161d <vprintfmt+0x54>
				width = 0;
  80169a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8016a1:	e9 77 ff ff ff       	jmp    80161d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8016a6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8016ad:	e9 6b ff ff ff       	jmp    80161d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8016b2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8016b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016b7:	0f 89 60 ff ff ff    	jns    80161d <vprintfmt+0x54>
				width = precision, precision = -1;
  8016bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8016ca:	e9 4e ff ff ff       	jmp    80161d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8016cf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8016d2:	e9 46 ff ff ff       	jmp    80161d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8016d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016da:	83 c0 04             	add    $0x4,%eax
  8016dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8016e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e3:	83 e8 04             	sub    $0x4,%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	50                   	push   %eax
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	ff d0                	call   *%eax
  8016f4:	83 c4 10             	add    $0x10,%esp
			break;
  8016f7:	e9 9b 02 00 00       	jmp    801997 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8016fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ff:	83 c0 04             	add    $0x4,%eax
  801702:	89 45 14             	mov    %eax,0x14(%ebp)
  801705:	8b 45 14             	mov    0x14(%ebp),%eax
  801708:	83 e8 04             	sub    $0x4,%eax
  80170b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80170d:	85 db                	test   %ebx,%ebx
  80170f:	79 02                	jns    801713 <vprintfmt+0x14a>
				err = -err;
  801711:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801713:	83 fb 64             	cmp    $0x64,%ebx
  801716:	7f 0b                	jg     801723 <vprintfmt+0x15a>
  801718:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  80171f:	85 f6                	test   %esi,%esi
  801721:	75 19                	jne    80173c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801723:	53                   	push   %ebx
  801724:	68 25 41 80 00       	push   $0x804125
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	ff 75 08             	pushl  0x8(%ebp)
  80172f:	e8 70 02 00 00       	call   8019a4 <printfmt>
  801734:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801737:	e9 5b 02 00 00       	jmp    801997 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80173c:	56                   	push   %esi
  80173d:	68 2e 41 80 00       	push   $0x80412e
  801742:	ff 75 0c             	pushl  0xc(%ebp)
  801745:	ff 75 08             	pushl  0x8(%ebp)
  801748:	e8 57 02 00 00       	call   8019a4 <printfmt>
  80174d:	83 c4 10             	add    $0x10,%esp
			break;
  801750:	e9 42 02 00 00       	jmp    801997 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801755:	8b 45 14             	mov    0x14(%ebp),%eax
  801758:	83 c0 04             	add    $0x4,%eax
  80175b:	89 45 14             	mov    %eax,0x14(%ebp)
  80175e:	8b 45 14             	mov    0x14(%ebp),%eax
  801761:	83 e8 04             	sub    $0x4,%eax
  801764:	8b 30                	mov    (%eax),%esi
  801766:	85 f6                	test   %esi,%esi
  801768:	75 05                	jne    80176f <vprintfmt+0x1a6>
				p = "(null)";
  80176a:	be 31 41 80 00       	mov    $0x804131,%esi
			if (width > 0 && padc != '-')
  80176f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801773:	7e 6d                	jle    8017e2 <vprintfmt+0x219>
  801775:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801779:	74 67                	je     8017e2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80177b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	50                   	push   %eax
  801782:	56                   	push   %esi
  801783:	e8 1e 03 00 00       	call   801aa6 <strnlen>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80178e:	eb 16                	jmp    8017a6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801790:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801794:	83 ec 08             	sub    $0x8,%esp
  801797:	ff 75 0c             	pushl  0xc(%ebp)
  80179a:	50                   	push   %eax
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	ff d0                	call   *%eax
  8017a0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8017a3:	ff 4d e4             	decl   -0x1c(%ebp)
  8017a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017aa:	7f e4                	jg     801790 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017ac:	eb 34                	jmp    8017e2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8017ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017b2:	74 1c                	je     8017d0 <vprintfmt+0x207>
  8017b4:	83 fb 1f             	cmp    $0x1f,%ebx
  8017b7:	7e 05                	jle    8017be <vprintfmt+0x1f5>
  8017b9:	83 fb 7e             	cmp    $0x7e,%ebx
  8017bc:	7e 12                	jle    8017d0 <vprintfmt+0x207>
					putch('?', putdat);
  8017be:	83 ec 08             	sub    $0x8,%esp
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	6a 3f                	push   $0x3f
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	ff d0                	call   *%eax
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	eb 0f                	jmp    8017df <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	53                   	push   %ebx
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	ff d0                	call   *%eax
  8017dc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017df:	ff 4d e4             	decl   -0x1c(%ebp)
  8017e2:	89 f0                	mov    %esi,%eax
  8017e4:	8d 70 01             	lea    0x1(%eax),%esi
  8017e7:	8a 00                	mov    (%eax),%al
  8017e9:	0f be d8             	movsbl %al,%ebx
  8017ec:	85 db                	test   %ebx,%ebx
  8017ee:	74 24                	je     801814 <vprintfmt+0x24b>
  8017f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017f4:	78 b8                	js     8017ae <vprintfmt+0x1e5>
  8017f6:	ff 4d e0             	decl   -0x20(%ebp)
  8017f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017fd:	79 af                	jns    8017ae <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8017ff:	eb 13                	jmp    801814 <vprintfmt+0x24b>
				putch(' ', putdat);
  801801:	83 ec 08             	sub    $0x8,%esp
  801804:	ff 75 0c             	pushl  0xc(%ebp)
  801807:	6a 20                	push   $0x20
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	ff d0                	call   *%eax
  80180e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801811:	ff 4d e4             	decl   -0x1c(%ebp)
  801814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801818:	7f e7                	jg     801801 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80181a:	e9 78 01 00 00       	jmp    801997 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80181f:	83 ec 08             	sub    $0x8,%esp
  801822:	ff 75 e8             	pushl  -0x18(%ebp)
  801825:	8d 45 14             	lea    0x14(%ebp),%eax
  801828:	50                   	push   %eax
  801829:	e8 3c fd ff ff       	call   80156a <getint>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801834:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183d:	85 d2                	test   %edx,%edx
  80183f:	79 23                	jns    801864 <vprintfmt+0x29b>
				putch('-', putdat);
  801841:	83 ec 08             	sub    $0x8,%esp
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	6a 2d                	push   $0x2d
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	ff d0                	call   *%eax
  80184e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801857:	f7 d8                	neg    %eax
  801859:	83 d2 00             	adc    $0x0,%edx
  80185c:	f7 da                	neg    %edx
  80185e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801861:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801864:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80186b:	e9 bc 00 00 00       	jmp    80192c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801870:	83 ec 08             	sub    $0x8,%esp
  801873:	ff 75 e8             	pushl  -0x18(%ebp)
  801876:	8d 45 14             	lea    0x14(%ebp),%eax
  801879:	50                   	push   %eax
  80187a:	e8 84 fc ff ff       	call   801503 <getuint>
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801885:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801888:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80188f:	e9 98 00 00 00       	jmp    80192c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801894:	83 ec 08             	sub    $0x8,%esp
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	6a 58                	push   $0x58
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	ff d0                	call   *%eax
  8018a1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8018a4:	83 ec 08             	sub    $0x8,%esp
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	6a 58                	push   $0x58
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	ff d0                	call   *%eax
  8018b1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8018b4:	83 ec 08             	sub    $0x8,%esp
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	6a 58                	push   $0x58
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	ff d0                	call   *%eax
  8018c1:	83 c4 10             	add    $0x10,%esp
			break;
  8018c4:	e9 ce 00 00 00       	jmp    801997 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	6a 30                	push   $0x30
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	ff d0                	call   *%eax
  8018d6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	6a 78                	push   $0x78
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	ff d0                	call   *%eax
  8018e6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8018e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ec:	83 c0 04             	add    $0x4,%eax
  8018ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8018f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f5:	83 e8 04             	sub    $0x4,%eax
  8018f8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8018fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801904:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80190b:	eb 1f                	jmp    80192c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	ff 75 e8             	pushl  -0x18(%ebp)
  801913:	8d 45 14             	lea    0x14(%ebp),%eax
  801916:	50                   	push   %eax
  801917:	e8 e7 fb ff ff       	call   801503 <getuint>
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801922:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801925:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80192c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801930:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	52                   	push   %edx
  801937:	ff 75 e4             	pushl  -0x1c(%ebp)
  80193a:	50                   	push   %eax
  80193b:	ff 75 f4             	pushl  -0xc(%ebp)
  80193e:	ff 75 f0             	pushl  -0x10(%ebp)
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	ff 75 08             	pushl  0x8(%ebp)
  801947:	e8 00 fb ff ff       	call   80144c <printnum>
  80194c:	83 c4 20             	add    $0x20,%esp
			break;
  80194f:	eb 46                	jmp    801997 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	53                   	push   %ebx
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	ff d0                	call   *%eax
  80195d:	83 c4 10             	add    $0x10,%esp
			break;
  801960:	eb 35                	jmp    801997 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801962:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801969:	eb 2c                	jmp    801997 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80196b:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801972:	eb 23                	jmp    801997 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	6a 25                	push   $0x25
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	ff d0                	call   *%eax
  801981:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801984:	ff 4d 10             	decl   0x10(%ebp)
  801987:	eb 03                	jmp    80198c <vprintfmt+0x3c3>
  801989:	ff 4d 10             	decl   0x10(%ebp)
  80198c:	8b 45 10             	mov    0x10(%ebp),%eax
  80198f:	48                   	dec    %eax
  801990:	8a 00                	mov    (%eax),%al
  801992:	3c 25                	cmp    $0x25,%al
  801994:	75 f3                	jne    801989 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801996:	90                   	nop
		}
	}
  801997:	e9 35 fc ff ff       	jmp    8015d1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80199c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80199d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a0:	5b                   	pop    %ebx
  8019a1:	5e                   	pop    %esi
  8019a2:	5d                   	pop    %ebp
  8019a3:	c3                   	ret    

008019a4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8019aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8019ad:	83 c0 04             	add    $0x4,%eax
  8019b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8019b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b9:	50                   	push   %eax
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	ff 75 08             	pushl  0x8(%ebp)
  8019c0:	e8 04 fc ff ff       	call   8015c9 <vprintfmt>
  8019c5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8019c8:	90                   	nop
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8019ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d1:	8b 40 08             	mov    0x8(%eax),%eax
  8019d4:	8d 50 01             	lea    0x1(%eax),%edx
  8019d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019da:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8019dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e0:	8b 10                	mov    (%eax),%edx
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	8b 40 04             	mov    0x4(%eax),%eax
  8019e8:	39 c2                	cmp    %eax,%edx
  8019ea:	73 12                	jae    8019fe <sprintputch+0x33>
		*b->buf++ = ch;
  8019ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8019f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f7:	89 0a                	mov    %ecx,(%edx)
  8019f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019fc:	88 10                	mov    %dl,(%eax)
}
  8019fe:	90                   	nop
  8019ff:	5d                   	pop    %ebp
  801a00:	c3                   	ret    

00801a01 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a10:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	01 d0                	add    %edx,%eax
  801a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801a22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a26:	74 06                	je     801a2e <vsnprintf+0x2d>
  801a28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a2c:	7f 07                	jg     801a35 <vsnprintf+0x34>
		return -E_INVAL;
  801a2e:	b8 03 00 00 00       	mov    $0x3,%eax
  801a33:	eb 20                	jmp    801a55 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801a35:	ff 75 14             	pushl  0x14(%ebp)
  801a38:	ff 75 10             	pushl  0x10(%ebp)
  801a3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a3e:	50                   	push   %eax
  801a3f:	68 cb 19 80 00       	push   $0x8019cb
  801a44:	e8 80 fb ff ff       	call   8015c9 <vprintfmt>
  801a49:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a4f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801a5d:	8d 45 10             	lea    0x10(%ebp),%eax
  801a60:	83 c0 04             	add    $0x4,%eax
  801a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	ff 75 f4             	pushl  -0xc(%ebp)
  801a6c:	50                   	push   %eax
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	e8 89 ff ff ff       	call   801a01 <vsnprintf>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801a89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a90:	eb 06                	jmp    801a98 <strlen+0x15>
		n++;
  801a92:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801a95:	ff 45 08             	incl   0x8(%ebp)
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	8a 00                	mov    (%eax),%al
  801a9d:	84 c0                	test   %al,%al
  801a9f:	75 f1                	jne    801a92 <strlen+0xf>
		n++;
	return n;
  801aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ab3:	eb 09                	jmp    801abe <strnlen+0x18>
		n++;
  801ab5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ab8:	ff 45 08             	incl   0x8(%ebp)
  801abb:	ff 4d 0c             	decl   0xc(%ebp)
  801abe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ac2:	74 09                	je     801acd <strnlen+0x27>
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	8a 00                	mov    (%eax),%al
  801ac9:	84 c0                	test   %al,%al
  801acb:	75 e8                	jne    801ab5 <strnlen+0xf>
		n++;
	return n;
  801acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801ade:	90                   	nop
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8d 50 01             	lea    0x1(%eax),%edx
  801ae5:	89 55 08             	mov    %edx,0x8(%ebp)
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aeb:	8d 4a 01             	lea    0x1(%edx),%ecx
  801aee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801af1:	8a 12                	mov    (%edx),%dl
  801af3:	88 10                	mov    %dl,(%eax)
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	84 c0                	test   %al,%al
  801af9:	75 e4                	jne    801adf <strcpy+0xd>
		/* do nothing */;
	return ret;
  801afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b13:	eb 1f                	jmp    801b34 <strncpy+0x34>
		*dst++ = *src;
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	8d 50 01             	lea    0x1(%eax),%edx
  801b1b:	89 55 08             	mov    %edx,0x8(%ebp)
  801b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b21:	8a 12                	mov    (%edx),%dl
  801b23:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	8a 00                	mov    (%eax),%al
  801b2a:	84 c0                	test   %al,%al
  801b2c:	74 03                	je     801b31 <strncpy+0x31>
			src++;
  801b2e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801b31:	ff 45 fc             	incl   -0x4(%ebp)
  801b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b37:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b3a:	72 d9                	jb     801b15 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801b3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801b4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b51:	74 30                	je     801b83 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801b53:	eb 16                	jmp    801b6b <strlcpy+0x2a>
			*dst++ = *src++;
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	8d 50 01             	lea    0x1(%eax),%edx
  801b5b:	89 55 08             	mov    %edx,0x8(%ebp)
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801b67:	8a 12                	mov    (%edx),%dl
  801b69:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801b6b:	ff 4d 10             	decl   0x10(%ebp)
  801b6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b72:	74 09                	je     801b7d <strlcpy+0x3c>
  801b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b77:	8a 00                	mov    (%eax),%al
  801b79:	84 c0                	test   %al,%al
  801b7b:	75 d8                	jne    801b55 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801b83:	8b 55 08             	mov    0x8(%ebp),%edx
  801b86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b89:	29 c2                	sub    %eax,%edx
  801b8b:	89 d0                	mov    %edx,%eax
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801b92:	eb 06                	jmp    801b9a <strcmp+0xb>
		p++, q++;
  801b94:	ff 45 08             	incl   0x8(%ebp)
  801b97:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	84 c0                	test   %al,%al
  801ba1:	74 0e                	je     801bb1 <strcmp+0x22>
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	8a 10                	mov    (%eax),%dl
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	8a 00                	mov    (%eax),%al
  801bad:	38 c2                	cmp    %al,%dl
  801baf:	74 e3                	je     801b94 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	8a 00                	mov    (%eax),%al
  801bb6:	0f b6 d0             	movzbl %al,%edx
  801bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbc:	8a 00                	mov    (%eax),%al
  801bbe:	0f b6 c0             	movzbl %al,%eax
  801bc1:	29 c2                	sub    %eax,%edx
  801bc3:	89 d0                	mov    %edx,%eax
}
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    

00801bc7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801bca:	eb 09                	jmp    801bd5 <strncmp+0xe>
		n--, p++, q++;
  801bcc:	ff 4d 10             	decl   0x10(%ebp)
  801bcf:	ff 45 08             	incl   0x8(%ebp)
  801bd2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801bd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd9:	74 17                	je     801bf2 <strncmp+0x2b>
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	8a 00                	mov    (%eax),%al
  801be0:	84 c0                	test   %al,%al
  801be2:	74 0e                	je     801bf2 <strncmp+0x2b>
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	8a 10                	mov    (%eax),%dl
  801be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bec:	8a 00                	mov    (%eax),%al
  801bee:	38 c2                	cmp    %al,%dl
  801bf0:	74 da                	je     801bcc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801bf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bf6:	75 07                	jne    801bff <strncmp+0x38>
		return 0;
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfd:	eb 14                	jmp    801c13 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	8a 00                	mov    (%eax),%al
  801c04:	0f b6 d0             	movzbl %al,%edx
  801c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0a:	8a 00                	mov    (%eax),%al
  801c0c:	0f b6 c0             	movzbl %al,%eax
  801c0f:	29 c2                	sub    %eax,%edx
  801c11:	89 d0                	mov    %edx,%eax
}
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    

00801c15 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 04             	sub    $0x4,%esp
  801c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c21:	eb 12                	jmp    801c35 <strchr+0x20>
		if (*s == c)
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801c2b:	75 05                	jne    801c32 <strchr+0x1d>
			return (char *) s;
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	eb 11                	jmp    801c43 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801c32:	ff 45 08             	incl   0x8(%ebp)
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	8a 00                	mov    (%eax),%al
  801c3a:	84 c0                	test   %al,%al
  801c3c:	75 e5                	jne    801c23 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c51:	eb 0d                	jmp    801c60 <strfind+0x1b>
		if (*s == c)
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	8a 00                	mov    (%eax),%al
  801c58:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801c5b:	74 0e                	je     801c6b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801c5d:	ff 45 08             	incl   0x8(%ebp)
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	84 c0                	test   %al,%al
  801c67:	75 ea                	jne    801c53 <strfind+0xe>
  801c69:	eb 01                	jmp    801c6c <strfind+0x27>
		if (*s == c)
			break;
  801c6b:	90                   	nop
	return (char *) s;
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801c7d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801c81:	76 63                	jbe    801ce6 <memset+0x75>
		uint64 data_block = c;
  801c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c86:	99                   	cltd   
  801c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c93:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801c97:	c1 e0 08             	shl    $0x8,%eax
  801c9a:	09 45 f0             	or     %eax,-0x10(%ebp)
  801c9d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca6:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801caa:	c1 e0 10             	shl    $0x10,%eax
  801cad:	09 45 f0             	or     %eax,-0x10(%ebp)
  801cb0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cb9:	89 c2                	mov    %eax,%edx
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc0:	09 45 f0             	or     %eax,-0x10(%ebp)
  801cc3:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801cc6:	eb 18                	jmp    801ce0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801cc8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ccb:	8d 41 08             	lea    0x8(%ecx),%eax
  801cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd7:	89 01                	mov    %eax,(%ecx)
  801cd9:	89 51 04             	mov    %edx,0x4(%ecx)
  801cdc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801ce0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ce4:	77 e2                	ja     801cc8 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801ce6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cea:	74 23                	je     801d0f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cef:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801cf2:	eb 0e                	jmp    801d02 <memset+0x91>
			*p8++ = (uint8)c;
  801cf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf7:	8d 50 01             	lea    0x1(%eax),%edx
  801cfa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d00:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801d02:	8b 45 10             	mov    0x10(%ebp),%eax
  801d05:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d08:	89 55 10             	mov    %edx,0x10(%ebp)
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	75 e5                	jne    801cf4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801d26:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801d2a:	76 24                	jbe    801d50 <memcpy+0x3c>
		while(n >= 8){
  801d2c:	eb 1c                	jmp    801d4a <memcpy+0x36>
			*d64 = *s64;
  801d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d31:	8b 50 04             	mov    0x4(%eax),%edx
  801d34:	8b 00                	mov    (%eax),%eax
  801d36:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d39:	89 01                	mov    %eax,(%ecx)
  801d3b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801d3e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801d42:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801d46:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801d4a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801d4e:	77 de                	ja     801d2e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d54:	74 31                	je     801d87 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801d5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801d62:	eb 16                	jmp    801d7a <memcpy+0x66>
			*d8++ = *s8++;
  801d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d67:	8d 50 01             	lea    0x1(%eax),%edx
  801d6a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d70:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d73:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801d76:	8a 12                	mov    (%edx),%dl
  801d78:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d80:	89 55 10             	mov    %edx,0x10(%ebp)
  801d83:	85 c0                	test   %eax,%eax
  801d85:	75 dd                	jne    801d64 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801da4:	73 50                	jae    801df6 <memmove+0x6a>
  801da6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801da9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dac:	01 d0                	add    %edx,%eax
  801dae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801db1:	76 43                	jbe    801df6 <memmove+0x6a>
		s += n;
  801db3:	8b 45 10             	mov    0x10(%ebp),%eax
  801db6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801db9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801dbf:	eb 10                	jmp    801dd1 <memmove+0x45>
			*--d = *--s;
  801dc1:	ff 4d f8             	decl   -0x8(%ebp)
  801dc4:	ff 4d fc             	decl   -0x4(%ebp)
  801dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dca:	8a 10                	mov    (%eax),%dl
  801dcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dcf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801dd7:	89 55 10             	mov    %edx,0x10(%ebp)
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	75 e3                	jne    801dc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801dde:	eb 23                	jmp    801e03 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801de0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801de3:	8d 50 01             	lea    0x1(%eax),%edx
  801de6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801de9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dec:	8d 4a 01             	lea    0x1(%edx),%ecx
  801def:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801df2:	8a 12                	mov    (%edx),%dl
  801df4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801df6:	8b 45 10             	mov    0x10(%ebp),%eax
  801df9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801dfc:	89 55 10             	mov    %edx,0x10(%ebp)
  801dff:	85 c0                	test   %eax,%eax
  801e01:	75 dd                	jne    801de0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e17:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801e1a:	eb 2a                	jmp    801e46 <memcmp+0x3e>
		if (*s1 != *s2)
  801e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e1f:	8a 10                	mov    (%eax),%dl
  801e21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e24:	8a 00                	mov    (%eax),%al
  801e26:	38 c2                	cmp    %al,%dl
  801e28:	74 16                	je     801e40 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e2d:	8a 00                	mov    (%eax),%al
  801e2f:	0f b6 d0             	movzbl %al,%edx
  801e32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e35:	8a 00                	mov    (%eax),%al
  801e37:	0f b6 c0             	movzbl %al,%eax
  801e3a:	29 c2                	sub    %eax,%edx
  801e3c:	89 d0                	mov    %edx,%eax
  801e3e:	eb 18                	jmp    801e58 <memcmp+0x50>
		s1++, s2++;
  801e40:	ff 45 fc             	incl   -0x4(%ebp)
  801e43:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801e46:	8b 45 10             	mov    0x10(%ebp),%eax
  801e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	75 c9                	jne    801e1c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801e60:	8b 55 08             	mov    0x8(%ebp),%edx
  801e63:	8b 45 10             	mov    0x10(%ebp),%eax
  801e66:	01 d0                	add    %edx,%eax
  801e68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801e6b:	eb 15                	jmp    801e82 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	8a 00                	mov    (%eax),%al
  801e72:	0f b6 d0             	movzbl %al,%edx
  801e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e78:	0f b6 c0             	movzbl %al,%eax
  801e7b:	39 c2                	cmp    %eax,%edx
  801e7d:	74 0d                	je     801e8c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e7f:	ff 45 08             	incl   0x8(%ebp)
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e88:	72 e3                	jb     801e6d <memfind+0x13>
  801e8a:	eb 01                	jmp    801e8d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801e8c:	90                   	nop
	return (void *) s;
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801e98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801e9f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ea6:	eb 03                	jmp    801eab <strtol+0x19>
		s++;
  801ea8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	8a 00                	mov    (%eax),%al
  801eb0:	3c 20                	cmp    $0x20,%al
  801eb2:	74 f4                	je     801ea8 <strtol+0x16>
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	8a 00                	mov    (%eax),%al
  801eb9:	3c 09                	cmp    $0x9,%al
  801ebb:	74 eb                	je     801ea8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	8a 00                	mov    (%eax),%al
  801ec2:	3c 2b                	cmp    $0x2b,%al
  801ec4:	75 05                	jne    801ecb <strtol+0x39>
		s++;
  801ec6:	ff 45 08             	incl   0x8(%ebp)
  801ec9:	eb 13                	jmp    801ede <strtol+0x4c>
	else if (*s == '-')
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	8a 00                	mov    (%eax),%al
  801ed0:	3c 2d                	cmp    $0x2d,%al
  801ed2:	75 0a                	jne    801ede <strtol+0x4c>
		s++, neg = 1;
  801ed4:	ff 45 08             	incl   0x8(%ebp)
  801ed7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ee2:	74 06                	je     801eea <strtol+0x58>
  801ee4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801ee8:	75 20                	jne    801f0a <strtol+0x78>
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	8a 00                	mov    (%eax),%al
  801eef:	3c 30                	cmp    $0x30,%al
  801ef1:	75 17                	jne    801f0a <strtol+0x78>
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	40                   	inc    %eax
  801ef7:	8a 00                	mov    (%eax),%al
  801ef9:	3c 78                	cmp    $0x78,%al
  801efb:	75 0d                	jne    801f0a <strtol+0x78>
		s += 2, base = 16;
  801efd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801f01:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801f08:	eb 28                	jmp    801f32 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f0e:	75 15                	jne    801f25 <strtol+0x93>
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	8a 00                	mov    (%eax),%al
  801f15:	3c 30                	cmp    $0x30,%al
  801f17:	75 0c                	jne    801f25 <strtol+0x93>
		s++, base = 8;
  801f19:	ff 45 08             	incl   0x8(%ebp)
  801f1c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801f23:	eb 0d                	jmp    801f32 <strtol+0xa0>
	else if (base == 0)
  801f25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f29:	75 07                	jne    801f32 <strtol+0xa0>
		base = 10;
  801f2b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	8a 00                	mov    (%eax),%al
  801f37:	3c 2f                	cmp    $0x2f,%al
  801f39:	7e 19                	jle    801f54 <strtol+0xc2>
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	8a 00                	mov    (%eax),%al
  801f40:	3c 39                	cmp    $0x39,%al
  801f42:	7f 10                	jg     801f54 <strtol+0xc2>
			dig = *s - '0';
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	8a 00                	mov    (%eax),%al
  801f49:	0f be c0             	movsbl %al,%eax
  801f4c:	83 e8 30             	sub    $0x30,%eax
  801f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f52:	eb 42                	jmp    801f96 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	8a 00                	mov    (%eax),%al
  801f59:	3c 60                	cmp    $0x60,%al
  801f5b:	7e 19                	jle    801f76 <strtol+0xe4>
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	8a 00                	mov    (%eax),%al
  801f62:	3c 7a                	cmp    $0x7a,%al
  801f64:	7f 10                	jg     801f76 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	8a 00                	mov    (%eax),%al
  801f6b:	0f be c0             	movsbl %al,%eax
  801f6e:	83 e8 57             	sub    $0x57,%eax
  801f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f74:	eb 20                	jmp    801f96 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	8a 00                	mov    (%eax),%al
  801f7b:	3c 40                	cmp    $0x40,%al
  801f7d:	7e 39                	jle    801fb8 <strtol+0x126>
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	8a 00                	mov    (%eax),%al
  801f84:	3c 5a                	cmp    $0x5a,%al
  801f86:	7f 30                	jg     801fb8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	8a 00                	mov    (%eax),%al
  801f8d:	0f be c0             	movsbl %al,%eax
  801f90:	83 e8 37             	sub    $0x37,%eax
  801f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f9c:	7d 19                	jge    801fb7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801f9e:	ff 45 08             	incl   0x8(%ebp)
  801fa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fa4:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fa8:	89 c2                	mov    %eax,%edx
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	01 d0                	add    %edx,%eax
  801faf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801fb2:	e9 7b ff ff ff       	jmp    801f32 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801fb7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801fb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fbc:	74 08                	je     801fc6 <strtol+0x134>
		*endptr = (char *) s;
  801fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801fc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fca:	74 07                	je     801fd3 <strtol+0x141>
  801fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fcf:	f7 d8                	neg    %eax
  801fd1:	eb 03                	jmp    801fd6 <strtol+0x144>
  801fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <ltostr>:

void
ltostr(long value, char *str)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801fde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801fe5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801fec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff0:	79 13                	jns    802005 <ltostr+0x2d>
	{
		neg = 1;
  801ff2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801fff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802002:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80200d:	99                   	cltd   
  80200e:	f7 f9                	idiv   %ecx
  802010:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802013:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802016:	8d 50 01             	lea    0x1(%eax),%edx
  802019:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80201c:	89 c2                	mov    %eax,%edx
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	01 d0                	add    %edx,%eax
  802023:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802026:	83 c2 30             	add    $0x30,%edx
  802029:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80202b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80202e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802033:	f7 e9                	imul   %ecx
  802035:	c1 fa 02             	sar    $0x2,%edx
  802038:	89 c8                	mov    %ecx,%eax
  80203a:	c1 f8 1f             	sar    $0x1f,%eax
  80203d:	29 c2                	sub    %eax,%edx
  80203f:	89 d0                	mov    %edx,%eax
  802041:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802044:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802048:	75 bb                	jne    802005 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80204a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802051:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802054:	48                   	dec    %eax
  802055:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802058:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80205c:	74 3d                	je     80209b <ltostr+0xc3>
		start = 1 ;
  80205e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802065:	eb 34                	jmp    80209b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802067:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206d:	01 d0                	add    %edx,%eax
  80206f:	8a 00                	mov    (%eax),%al
  802071:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207a:	01 c2                	add    %eax,%edx
  80207c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80207f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802082:	01 c8                	add    %ecx,%eax
  802084:	8a 00                	mov    (%eax),%al
  802086:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802088:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80208b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208e:	01 c2                	add    %eax,%edx
  802090:	8a 45 eb             	mov    -0x15(%ebp),%al
  802093:	88 02                	mov    %al,(%edx)
		start++ ;
  802095:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802098:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020a1:	7c c4                	jl     802067 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8020a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8020ae:	90                   	nop
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8020b7:	ff 75 08             	pushl  0x8(%ebp)
  8020ba:	e8 c4 f9 ff ff       	call   801a83 <strlen>
  8020bf:	83 c4 04             	add    $0x4,%esp
  8020c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8020c5:	ff 75 0c             	pushl  0xc(%ebp)
  8020c8:	e8 b6 f9 ff ff       	call   801a83 <strlen>
  8020cd:	83 c4 04             	add    $0x4,%esp
  8020d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8020d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8020da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8020e1:	eb 17                	jmp    8020fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8020e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e9:	01 c2                	add    %eax,%edx
  8020eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	01 c8                	add    %ecx,%eax
  8020f3:	8a 00                	mov    (%eax),%al
  8020f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8020f7:	ff 45 fc             	incl   -0x4(%ebp)
  8020fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802100:	7c e1                	jl     8020e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802102:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802109:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802110:	eb 1f                	jmp    802131 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802115:	8d 50 01             	lea    0x1(%eax),%edx
  802118:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80211b:	89 c2                	mov    %eax,%edx
  80211d:	8b 45 10             	mov    0x10(%ebp),%eax
  802120:	01 c2                	add    %eax,%edx
  802122:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	01 c8                	add    %ecx,%eax
  80212a:	8a 00                	mov    (%eax),%al
  80212c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80212e:	ff 45 f8             	incl   -0x8(%ebp)
  802131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802134:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802137:	7c d9                	jl     802112 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802139:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	01 d0                	add    %edx,%eax
  802141:	c6 00 00             	movb   $0x0,(%eax)
}
  802144:	90                   	nop
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80214a:	8b 45 14             	mov    0x14(%ebp),%eax
  80214d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802153:	8b 45 14             	mov    0x14(%ebp),%eax
  802156:	8b 00                	mov    (%eax),%eax
  802158:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80215f:	8b 45 10             	mov    0x10(%ebp),%eax
  802162:	01 d0                	add    %edx,%eax
  802164:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80216a:	eb 0c                	jmp    802178 <strsplit+0x31>
			*string++ = 0;
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8d 50 01             	lea    0x1(%eax),%edx
  802172:	89 55 08             	mov    %edx,0x8(%ebp)
  802175:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	8a 00                	mov    (%eax),%al
  80217d:	84 c0                	test   %al,%al
  80217f:	74 18                	je     802199 <strsplit+0x52>
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	0f be c0             	movsbl %al,%eax
  802189:	50                   	push   %eax
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	e8 83 fa ff ff       	call   801c15 <strchr>
  802192:	83 c4 08             	add    $0x8,%esp
  802195:	85 c0                	test   %eax,%eax
  802197:	75 d3                	jne    80216c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	8a 00                	mov    (%eax),%al
  80219e:	84 c0                	test   %al,%al
  8021a0:	74 5a                	je     8021fc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8021a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	83 f8 0f             	cmp    $0xf,%eax
  8021aa:	75 07                	jne    8021b3 <strsplit+0x6c>
		{
			return 0;
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b1:	eb 66                	jmp    802219 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8021b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b6:	8b 00                	mov    (%eax),%eax
  8021b8:	8d 48 01             	lea    0x1(%eax),%ecx
  8021bb:	8b 55 14             	mov    0x14(%ebp),%edx
  8021be:	89 0a                	mov    %ecx,(%edx)
  8021c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ca:	01 c2                	add    %eax,%edx
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8021d1:	eb 03                	jmp    8021d6 <strsplit+0x8f>
			string++;
  8021d3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	8a 00                	mov    (%eax),%al
  8021db:	84 c0                	test   %al,%al
  8021dd:	74 8b                	je     80216a <strsplit+0x23>
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	8a 00                	mov    (%eax),%al
  8021e4:	0f be c0             	movsbl %al,%eax
  8021e7:	50                   	push   %eax
  8021e8:	ff 75 0c             	pushl  0xc(%ebp)
  8021eb:	e8 25 fa ff ff       	call   801c15 <strchr>
  8021f0:	83 c4 08             	add    $0x8,%esp
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	74 dc                	je     8021d3 <strsplit+0x8c>
			string++;
	}
  8021f7:	e9 6e ff ff ff       	jmp    80216a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8021fc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8021fd:	8b 45 14             	mov    0x14(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802214:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802227:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80222e:	eb 4a                	jmp    80227a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802230:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	01 c2                	add    %eax,%edx
  802238:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80223b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223e:	01 c8                	add    %ecx,%eax
  802240:	8a 00                	mov    (%eax),%al
  802242:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802244:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224a:	01 d0                	add    %edx,%eax
  80224c:	8a 00                	mov    (%eax),%al
  80224e:	3c 40                	cmp    $0x40,%al
  802250:	7e 25                	jle    802277 <str2lower+0x5c>
  802252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802255:	8b 45 0c             	mov    0xc(%ebp),%eax
  802258:	01 d0                	add    %edx,%eax
  80225a:	8a 00                	mov    (%eax),%al
  80225c:	3c 5a                	cmp    $0x5a,%al
  80225e:	7f 17                	jg     802277 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802260:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	01 d0                	add    %edx,%eax
  802268:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80226b:	8b 55 08             	mov    0x8(%ebp),%edx
  80226e:	01 ca                	add    %ecx,%edx
  802270:	8a 12                	mov    (%edx),%dl
  802272:	83 c2 20             	add    $0x20,%edx
  802275:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802277:	ff 45 fc             	incl   -0x4(%ebp)
  80227a:	ff 75 0c             	pushl  0xc(%ebp)
  80227d:	e8 01 f8 ff ff       	call   801a83 <strlen>
  802282:	83 c4 04             	add    $0x4,%esp
  802285:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802288:	7f a6                	jg     802230 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80228a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802295:	a1 08 50 80 00       	mov    0x805008,%eax
  80229a:	85 c0                	test   %eax,%eax
  80229c:	74 42                	je     8022e0 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80229e:	83 ec 08             	sub    $0x8,%esp
  8022a1:	68 00 00 00 82       	push   $0x82000000
  8022a6:	68 00 00 00 80       	push   $0x80000000
  8022ab:	e8 00 08 00 00       	call   802ab0 <initialize_dynamic_allocator>
  8022b0:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8022b3:	e8 e7 05 00 00       	call   80289f <sys_get_uheap_strategy>
  8022b8:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8022bd:	a1 20 52 80 00       	mov    0x805220,%eax
  8022c2:	05 00 10 00 00       	add    $0x1000,%eax
  8022c7:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8022cc:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  8022d1:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  8022d6:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8022dd:	00 00 00 
	}
}
  8022e0:	90                   	nop
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022f7:	83 ec 08             	sub    $0x8,%esp
  8022fa:	68 06 04 00 00       	push   $0x406
  8022ff:	50                   	push   %eax
  802300:	e8 e4 01 00 00       	call   8024e9 <__sys_allocate_page>
  802305:	83 c4 10             	add    $0x10,%esp
  802308:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80230b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80230f:	79 14                	jns    802325 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	68 a8 42 80 00       	push   $0x8042a8
  802319:	6a 1f                	push   $0x1f
  80231b:	68 e4 42 80 00       	push   $0x8042e4
  802320:	e8 72 11 00 00       	call   803497 <_panic>
	return 0;
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802340:	83 ec 0c             	sub    $0xc,%esp
  802343:	50                   	push   %eax
  802344:	e8 e7 01 00 00       	call   802530 <__sys_unmap_frame>
  802349:	83 c4 10             	add    $0x10,%esp
  80234c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80234f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802353:	79 14                	jns    802369 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	68 f0 42 80 00       	push   $0x8042f0
  80235d:	6a 2a                	push   $0x2a
  80235f:	68 e4 42 80 00       	push   $0x8042e4
  802364:	e8 2e 11 00 00       	call   803497 <_panic>
}
  802369:	90                   	nop
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802372:	e8 18 ff ff ff       	call   80228f <uheap_init>
	if (size == 0) return NULL ;
  802377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237b:	75 07                	jne    802384 <malloc+0x18>
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
  802382:	eb 14                	jmp    802398 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	68 30 43 80 00       	push   $0x804330
  80238c:	6a 3e                	push   $0x3e
  80238e:	68 e4 42 80 00       	push   $0x8042e4
  802393:	e8 ff 10 00 00       	call   803497 <_panic>
}
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	68 58 43 80 00       	push   $0x804358
  8023a8:	6a 49                	push   $0x49
  8023aa:	68 e4 42 80 00       	push   $0x8042e4
  8023af:	e8 e3 10 00 00       	call   803497 <_panic>

008023b4 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 18             	sub    $0x18,%esp
  8023ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8023bd:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023c0:	e8 ca fe ff ff       	call   80228f <uheap_init>
	if (size == 0) return NULL ;
  8023c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023c9:	75 07                	jne    8023d2 <smalloc+0x1e>
  8023cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d0:	eb 14                	jmp    8023e6 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	68 7c 43 80 00       	push   $0x80437c
  8023da:	6a 5a                	push   $0x5a
  8023dc:	68 e4 42 80 00       	push   $0x8042e4
  8023e1:	e8 b1 10 00 00       	call   803497 <_panic>
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023ee:	e8 9c fe ff ff       	call   80228f <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8023f3:	83 ec 04             	sub    $0x4,%esp
  8023f6:	68 a4 43 80 00       	push   $0x8043a4
  8023fb:	6a 6a                	push   $0x6a
  8023fd:	68 e4 42 80 00       	push   $0x8042e4
  802402:	e8 90 10 00 00       	call   803497 <_panic>

00802407 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80240d:	e8 7d fe ff ff       	call   80228f <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	68 c8 43 80 00       	push   $0x8043c8
  80241a:	68 88 00 00 00       	push   $0x88
  80241f:	68 e4 42 80 00       	push   $0x8042e4
  802424:	e8 6e 10 00 00       	call   803497 <_panic>

00802429 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80242f:	83 ec 04             	sub    $0x4,%esp
  802432:	68 f0 43 80 00       	push   $0x8043f0
  802437:	68 9b 00 00 00       	push   $0x9b
  80243c:	68 e4 42 80 00       	push   $0x8042e4
  802441:	e8 51 10 00 00       	call   803497 <_panic>

00802446 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
  802449:	57                   	push   %edi
  80244a:	56                   	push   %esi
  80244b:	53                   	push   %ebx
  80244c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	8b 55 0c             	mov    0xc(%ebp),%edx
  802455:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802458:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80245b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80245e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802461:	cd 30                	int    $0x30
  802463:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802469:	83 c4 10             	add    $0x10,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    

00802471 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	83 ec 04             	sub    $0x4,%esp
  802477:	8b 45 10             	mov    0x10(%ebp),%eax
  80247a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80247d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802480:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	6a 00                	push   $0x0
  802489:	51                   	push   %ecx
  80248a:	52                   	push   %edx
  80248b:	ff 75 0c             	pushl  0xc(%ebp)
  80248e:	50                   	push   %eax
  80248f:	6a 00                	push   $0x0
  802491:	e8 b0 ff ff ff       	call   802446 <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
}
  802499:	90                   	nop
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_cgetc>:

int
sys_cgetc(void)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 02                	push   $0x2
  8024ab:	e8 96 ff ff ff       	call   802446 <syscall>
  8024b0:	83 c4 18             	add    $0x18,%esp
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 03                	push   $0x3
  8024c4:	e8 7d ff ff ff       	call   802446 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
}
  8024cc:	90                   	nop
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 04                	push   $0x4
  8024de:	e8 63 ff ff ff       	call   802446 <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
}
  8024e6:	90                   	nop
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	52                   	push   %edx
  8024f9:	50                   	push   %eax
  8024fa:	6a 08                	push   $0x8
  8024fc:	e8 45 ff ff ff       	call   802446 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	56                   	push   %esi
  80250a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80250b:	8b 75 18             	mov    0x18(%ebp),%esi
  80250e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802511:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802514:	8b 55 0c             	mov    0xc(%ebp),%edx
  802517:	8b 45 08             	mov    0x8(%ebp),%eax
  80251a:	56                   	push   %esi
  80251b:	53                   	push   %ebx
  80251c:	51                   	push   %ecx
  80251d:	52                   	push   %edx
  80251e:	50                   	push   %eax
  80251f:	6a 09                	push   $0x9
  802521:	e8 20 ff ff ff       	call   802446 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
}
  802529:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80252c:	5b                   	pop    %ebx
  80252d:	5e                   	pop    %esi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    

00802530 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	ff 75 08             	pushl  0x8(%ebp)
  80253e:	6a 0a                	push   $0xa
  802540:	e8 01 ff ff ff       	call   802446 <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	ff 75 0c             	pushl  0xc(%ebp)
  802556:	ff 75 08             	pushl  0x8(%ebp)
  802559:	6a 0b                	push   $0xb
  80255b:	e8 e6 fe ff ff       	call   802446 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 0c                	push   $0xc
  802574:	e8 cd fe ff ff       	call   802446 <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 0d                	push   $0xd
  80258d:	e8 b4 fe ff ff       	call   802446 <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 0e                	push   $0xe
  8025a6:	e8 9b fe ff ff       	call   802446 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 0f                	push   $0xf
  8025bf:	e8 82 fe ff ff       	call   802446 <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	ff 75 08             	pushl  0x8(%ebp)
  8025d7:	6a 10                	push   $0x10
  8025d9:	e8 68 fe ff ff       	call   802446 <syscall>
  8025de:	83 c4 18             	add    $0x18,%esp
}
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 11                	push   $0x11
  8025f2:	e8 4f fe ff ff       	call   802446 <syscall>
  8025f7:	83 c4 18             	add    $0x18,%esp
}
  8025fa:	90                   	nop
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <sys_cputc>:

void
sys_cputc(const char c)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	83 ec 04             	sub    $0x4,%esp
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802609:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	50                   	push   %eax
  802616:	6a 01                	push   $0x1
  802618:	e8 29 fe ff ff       	call   802446 <syscall>
  80261d:	83 c4 18             	add    $0x18,%esp
}
  802620:	90                   	nop
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 14                	push   $0x14
  802632:	e8 0f fe ff ff       	call   802446 <syscall>
  802637:	83 c4 18             	add    $0x18,%esp
}
  80263a:	90                   	nop
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 04             	sub    $0x4,%esp
  802643:	8b 45 10             	mov    0x10(%ebp),%eax
  802646:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802649:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80264c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	6a 00                	push   $0x0
  802655:	51                   	push   %ecx
  802656:	52                   	push   %edx
  802657:	ff 75 0c             	pushl  0xc(%ebp)
  80265a:	50                   	push   %eax
  80265b:	6a 15                	push   $0x15
  80265d:	e8 e4 fd ff ff       	call   802446 <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
}
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80266a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	52                   	push   %edx
  802677:	50                   	push   %eax
  802678:	6a 16                	push   $0x16
  80267a:	e8 c7 fd ff ff       	call   802446 <syscall>
  80267f:	83 c4 18             	add    $0x18,%esp
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802687:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80268a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	51                   	push   %ecx
  802695:	52                   	push   %edx
  802696:	50                   	push   %eax
  802697:	6a 17                	push   $0x17
  802699:	e8 a8 fd ff ff       	call   802446 <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8026a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	52                   	push   %edx
  8026b3:	50                   	push   %eax
  8026b4:	6a 18                	push   $0x18
  8026b6:	e8 8b fd ff ff       	call   802446 <syscall>
  8026bb:	83 c4 18             	add    $0x18,%esp
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	6a 00                	push   $0x0
  8026c8:	ff 75 14             	pushl  0x14(%ebp)
  8026cb:	ff 75 10             	pushl  0x10(%ebp)
  8026ce:	ff 75 0c             	pushl  0xc(%ebp)
  8026d1:	50                   	push   %eax
  8026d2:	6a 19                	push   $0x19
  8026d4:	e8 6d fd ff ff       	call   802446 <syscall>
  8026d9:	83 c4 18             	add    $0x18,%esp
}
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <sys_run_env>:

void sys_run_env(int32 envId)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	50                   	push   %eax
  8026ed:	6a 1a                	push   $0x1a
  8026ef:	e8 52 fd ff ff       	call   802446 <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
}
  8026f7:	90                   	nop
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	50                   	push   %eax
  802709:	6a 1b                	push   $0x1b
  80270b:	e8 36 fd ff ff       	call   802446 <syscall>
  802710:	83 c4 18             	add    $0x18,%esp
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 05                	push   $0x5
  802724:	e8 1d fd ff ff       	call   802446 <syscall>
  802729:	83 c4 18             	add    $0x18,%esp
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 06                	push   $0x6
  80273d:	e8 04 fd ff ff       	call   802446 <syscall>
  802742:	83 c4 18             	add    $0x18,%esp
}
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 07                	push   $0x7
  802756:	e8 eb fc ff ff       	call   802446 <syscall>
  80275b:	83 c4 18             	add    $0x18,%esp
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <sys_exit_env>:


void sys_exit_env(void)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 1c                	push   $0x1c
  80276f:	e8 d2 fc ff ff       	call   802446 <syscall>
  802774:	83 c4 18             	add    $0x18,%esp
}
  802777:	90                   	nop
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802780:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802783:	8d 50 04             	lea    0x4(%eax),%edx
  802786:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	52                   	push   %edx
  802790:	50                   	push   %eax
  802791:	6a 1d                	push   $0x1d
  802793:	e8 ae fc ff ff       	call   802446 <syscall>
  802798:	83 c4 18             	add    $0x18,%esp
	return result;
  80279b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80279e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027a4:	89 01                	mov    %eax,(%ecx)
  8027a6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	c9                   	leave  
  8027ad:	c2 04 00             	ret    $0x4

008027b0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	ff 75 10             	pushl  0x10(%ebp)
  8027ba:	ff 75 0c             	pushl  0xc(%ebp)
  8027bd:	ff 75 08             	pushl  0x8(%ebp)
  8027c0:	6a 13                	push   $0x13
  8027c2:	e8 7f fc ff ff       	call   802446 <syscall>
  8027c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ca:	90                   	nop
}
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    

008027cd <sys_rcr2>:
uint32 sys_rcr2()
{
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 1e                	push   $0x1e
  8027dc:	e8 65 fc ff ff       	call   802446 <syscall>
  8027e1:	83 c4 18             	add    $0x18,%esp
}
  8027e4:	c9                   	leave  
  8027e5:	c3                   	ret    

008027e6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8027e6:	55                   	push   %ebp
  8027e7:	89 e5                	mov    %esp,%ebp
  8027e9:	83 ec 04             	sub    $0x4,%esp
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027f2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	50                   	push   %eax
  8027ff:	6a 1f                	push   $0x1f
  802801:	e8 40 fc ff ff       	call   802446 <syscall>
  802806:	83 c4 18             	add    $0x18,%esp
	return ;
  802809:	90                   	nop
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <rsttst>:
void rsttst()
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 21                	push   $0x21
  80281b:	e8 26 fc ff ff       	call   802446 <syscall>
  802820:	83 c4 18             	add    $0x18,%esp
	return ;
  802823:	90                   	nop
}
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	83 ec 04             	sub    $0x4,%esp
  80282c:	8b 45 14             	mov    0x14(%ebp),%eax
  80282f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802832:	8b 55 18             	mov    0x18(%ebp),%edx
  802835:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802839:	52                   	push   %edx
  80283a:	50                   	push   %eax
  80283b:	ff 75 10             	pushl  0x10(%ebp)
  80283e:	ff 75 0c             	pushl  0xc(%ebp)
  802841:	ff 75 08             	pushl  0x8(%ebp)
  802844:	6a 20                	push   $0x20
  802846:	e8 fb fb ff ff       	call   802446 <syscall>
  80284b:	83 c4 18             	add    $0x18,%esp
	return ;
  80284e:	90                   	nop
}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <chktst>:
void chktst(uint32 n)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	ff 75 08             	pushl  0x8(%ebp)
  80285f:	6a 22                	push   $0x22
  802861:	e8 e0 fb ff ff       	call   802446 <syscall>
  802866:	83 c4 18             	add    $0x18,%esp
	return ;
  802869:	90                   	nop
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <inctst>:

void inctst()
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	6a 23                	push   $0x23
  80287b:	e8 c6 fb ff ff       	call   802446 <syscall>
  802880:	83 c4 18             	add    $0x18,%esp
	return ;
  802883:	90                   	nop
}
  802884:	c9                   	leave  
  802885:	c3                   	ret    

00802886 <gettst>:
uint32 gettst()
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 24                	push   $0x24
  802895:	e8 ac fb ff ff       	call   802446 <syscall>
  80289a:	83 c4 18             	add    $0x18,%esp
}
  80289d:	c9                   	leave  
  80289e:	c3                   	ret    

0080289f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 25                	push   $0x25
  8028ae:	e8 93 fb ff ff       	call   802446 <syscall>
  8028b3:	83 c4 18             	add    $0x18,%esp
  8028b6:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  8028bb:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  8028c0:	c9                   	leave  
  8028c1:	c3                   	ret    

008028c2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	ff 75 08             	pushl  0x8(%ebp)
  8028d8:	6a 26                	push   $0x26
  8028da:	e8 67 fb ff ff       	call   802446 <syscall>
  8028df:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e2:	90                   	nop
}
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
  8028e8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	6a 00                	push   $0x0
  8028f7:	53                   	push   %ebx
  8028f8:	51                   	push   %ecx
  8028f9:	52                   	push   %edx
  8028fa:	50                   	push   %eax
  8028fb:	6a 27                	push   $0x27
  8028fd:	e8 44 fb ff ff       	call   802446 <syscall>
  802902:	83 c4 18             	add    $0x18,%esp
}
  802905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80290d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	52                   	push   %edx
  80291a:	50                   	push   %eax
  80291b:	6a 28                	push   $0x28
  80291d:	e8 24 fb ff ff       	call   802446 <syscall>
  802922:	83 c4 18             	add    $0x18,%esp
}
  802925:	c9                   	leave  
  802926:	c3                   	ret    

00802927 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802927:	55                   	push   %ebp
  802928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80292a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80292d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	6a 00                	push   $0x0
  802935:	51                   	push   %ecx
  802936:	ff 75 10             	pushl  0x10(%ebp)
  802939:	52                   	push   %edx
  80293a:	50                   	push   %eax
  80293b:	6a 29                	push   $0x29
  80293d:	e8 04 fb ff ff       	call   802446 <syscall>
  802942:	83 c4 18             	add    $0x18,%esp
}
  802945:	c9                   	leave  
  802946:	c3                   	ret    

00802947 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802947:	55                   	push   %ebp
  802948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80294a:	6a 00                	push   $0x0
  80294c:	6a 00                	push   $0x0
  80294e:	ff 75 10             	pushl  0x10(%ebp)
  802951:	ff 75 0c             	pushl  0xc(%ebp)
  802954:	ff 75 08             	pushl  0x8(%ebp)
  802957:	6a 12                	push   $0x12
  802959:	e8 e8 fa ff ff       	call   802446 <syscall>
  80295e:	83 c4 18             	add    $0x18,%esp
	return ;
  802961:	90                   	nop
}
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	52                   	push   %edx
  802974:	50                   	push   %eax
  802975:	6a 2a                	push   $0x2a
  802977:	e8 ca fa ff ff       	call   802446 <syscall>
  80297c:	83 c4 18             	add    $0x18,%esp
	return;
  80297f:	90                   	nop
}
  802980:	c9                   	leave  
  802981:	c3                   	ret    

00802982 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802982:	55                   	push   %ebp
  802983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802985:	6a 00                	push   $0x0
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	6a 00                	push   $0x0
  80298f:	6a 2b                	push   $0x2b
  802991:	e8 b0 fa ff ff       	call   802446 <syscall>
  802996:	83 c4 18             	add    $0x18,%esp
}
  802999:	c9                   	leave  
  80299a:	c3                   	ret    

0080299b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	ff 75 0c             	pushl  0xc(%ebp)
  8029a7:	ff 75 08             	pushl  0x8(%ebp)
  8029aa:	6a 2d                	push   $0x2d
  8029ac:	e8 95 fa ff ff       	call   802446 <syscall>
  8029b1:	83 c4 18             	add    $0x18,%esp
	return;
  8029b4:	90                   	nop
}
  8029b5:	c9                   	leave  
  8029b6:	c3                   	ret    

008029b7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8029b7:	55                   	push   %ebp
  8029b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	ff 75 0c             	pushl  0xc(%ebp)
  8029c3:	ff 75 08             	pushl  0x8(%ebp)
  8029c6:	6a 2c                	push   $0x2c
  8029c8:	e8 79 fa ff ff       	call   802446 <syscall>
  8029cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d0:	90                   	nop
}
  8029d1:	c9                   	leave  
  8029d2:	c3                   	ret    

008029d3 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8029d3:	55                   	push   %ebp
  8029d4:	89 e5                	mov    %esp,%ebp
  8029d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	68 14 44 80 00       	push   $0x804414
  8029e1:	68 25 01 00 00       	push   $0x125
  8029e6:	68 47 44 80 00       	push   $0x804447
  8029eb:	e8 a7 0a 00 00       	call   803497 <_panic>

008029f0 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
  8029f3:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8029f6:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  8029fd:	72 09                	jb     802a08 <to_page_va+0x18>
  8029ff:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802a06:	72 14                	jb     802a1c <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802a08:	83 ec 04             	sub    $0x4,%esp
  802a0b:	68 58 44 80 00       	push   $0x804458
  802a10:	6a 15                	push   $0x15
  802a12:	68 83 44 80 00       	push   $0x804483
  802a17:	e8 7b 0a 00 00       	call   803497 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	ba 40 52 80 00       	mov    $0x805240,%edx
  802a24:	29 d0                	sub    %edx,%eax
  802a26:	c1 f8 02             	sar    $0x2,%eax
  802a29:	89 c2                	mov    %eax,%edx
  802a2b:	89 d0                	mov    %edx,%eax
  802a2d:	c1 e0 02             	shl    $0x2,%eax
  802a30:	01 d0                	add    %edx,%eax
  802a32:	c1 e0 02             	shl    $0x2,%eax
  802a35:	01 d0                	add    %edx,%eax
  802a37:	c1 e0 02             	shl    $0x2,%eax
  802a3a:	01 d0                	add    %edx,%eax
  802a3c:	89 c1                	mov    %eax,%ecx
  802a3e:	c1 e1 08             	shl    $0x8,%ecx
  802a41:	01 c8                	add    %ecx,%eax
  802a43:	89 c1                	mov    %eax,%ecx
  802a45:	c1 e1 10             	shl    $0x10,%ecx
  802a48:	01 c8                	add    %ecx,%eax
  802a4a:	01 c0                	add    %eax,%eax
  802a4c:	01 d0                	add    %edx,%eax
  802a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	c1 e0 0c             	shl    $0xc,%eax
  802a57:	89 c2                	mov    %eax,%edx
  802a59:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802a5e:	01 d0                	add    %edx,%eax
}
  802a60:	c9                   	leave  
  802a61:	c3                   	ret    

00802a62 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802a62:	55                   	push   %ebp
  802a63:	89 e5                	mov    %esp,%ebp
  802a65:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802a68:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802a6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a70:	29 c2                	sub    %eax,%edx
  802a72:	89 d0                	mov    %edx,%eax
  802a74:	c1 e8 0c             	shr    $0xc,%eax
  802a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	78 09                	js     802a89 <to_page_info+0x27>
  802a80:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802a87:	7e 14                	jle    802a9d <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802a89:	83 ec 04             	sub    $0x4,%esp
  802a8c:	68 9c 44 80 00       	push   $0x80449c
  802a91:	6a 22                	push   $0x22
  802a93:	68 83 44 80 00       	push   $0x804483
  802a98:	e8 fa 09 00 00       	call   803497 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa0:	89 d0                	mov    %edx,%eax
  802aa2:	01 c0                	add    %eax,%eax
  802aa4:	01 d0                	add    %edx,%eax
  802aa6:	c1 e0 02             	shl    $0x2,%eax
  802aa9:	05 40 52 80 00       	add    $0x805240,%eax
}
  802aae:	c9                   	leave  
  802aaf:	c3                   	ret    

00802ab0 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	05 00 00 00 02       	add    $0x2000000,%eax
  802abe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ac1:	73 16                	jae    802ad9 <initialize_dynamic_allocator+0x29>
  802ac3:	68 c0 44 80 00       	push   $0x8044c0
  802ac8:	68 e6 44 80 00       	push   $0x8044e6
  802acd:	6a 34                	push   $0x34
  802acf:	68 83 44 80 00       	push   $0x804483
  802ad4:	e8 be 09 00 00       	call   803497 <_panic>
		is_initialized = 1;
  802ad9:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802ae0:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aee:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802af3:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802afa:	00 00 00 
  802afd:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802b04:	00 00 00 
  802b07:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  802b0e:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b14:	2b 45 08             	sub    0x8(%ebp),%eax
  802b17:	c1 e8 0c             	shr    $0xc,%eax
  802b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802b1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b24:	e9 c8 00 00 00       	jmp    802bf1 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802b29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2c:	89 d0                	mov    %edx,%eax
  802b2e:	01 c0                	add    %eax,%eax
  802b30:	01 d0                	add    %edx,%eax
  802b32:	c1 e0 02             	shl    $0x2,%eax
  802b35:	05 48 52 80 00       	add    $0x805248,%eax
  802b3a:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b42:	89 d0                	mov    %edx,%eax
  802b44:	01 c0                	add    %eax,%eax
  802b46:	01 d0                	add    %edx,%eax
  802b48:	c1 e0 02             	shl    $0x2,%eax
  802b4b:	05 4a 52 80 00       	add    $0x80524a,%eax
  802b50:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802b55:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802b5b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b5e:	89 c8                	mov    %ecx,%eax
  802b60:	01 c0                	add    %eax,%eax
  802b62:	01 c8                	add    %ecx,%eax
  802b64:	c1 e0 02             	shl    $0x2,%eax
  802b67:	05 44 52 80 00       	add    $0x805244,%eax
  802b6c:	89 10                	mov    %edx,(%eax)
  802b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b71:	89 d0                	mov    %edx,%eax
  802b73:	01 c0                	add    %eax,%eax
  802b75:	01 d0                	add    %edx,%eax
  802b77:	c1 e0 02             	shl    $0x2,%eax
  802b7a:	05 44 52 80 00       	add    $0x805244,%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 1b                	je     802ba0 <initialize_dynamic_allocator+0xf0>
  802b85:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802b8b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b8e:	89 c8                	mov    %ecx,%eax
  802b90:	01 c0                	add    %eax,%eax
  802b92:	01 c8                	add    %ecx,%eax
  802b94:	c1 e0 02             	shl    $0x2,%eax
  802b97:	05 40 52 80 00       	add    $0x805240,%eax
  802b9c:	89 02                	mov    %eax,(%edx)
  802b9e:	eb 16                	jmp    802bb6 <initialize_dynamic_allocator+0x106>
  802ba0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba3:	89 d0                	mov    %edx,%eax
  802ba5:	01 c0                	add    %eax,%eax
  802ba7:	01 d0                	add    %edx,%eax
  802ba9:	c1 e0 02             	shl    $0x2,%eax
  802bac:	05 40 52 80 00       	add    $0x805240,%eax
  802bb1:	a3 28 52 80 00       	mov    %eax,0x805228
  802bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb9:	89 d0                	mov    %edx,%eax
  802bbb:	01 c0                	add    %eax,%eax
  802bbd:	01 d0                	add    %edx,%eax
  802bbf:	c1 e0 02             	shl    $0x2,%eax
  802bc2:	05 40 52 80 00       	add    $0x805240,%eax
  802bc7:	a3 2c 52 80 00       	mov    %eax,0x80522c
  802bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcf:	89 d0                	mov    %edx,%eax
  802bd1:	01 c0                	add    %eax,%eax
  802bd3:	01 d0                	add    %edx,%eax
  802bd5:	c1 e0 02             	shl    $0x2,%eax
  802bd8:	05 40 52 80 00       	add    $0x805240,%eax
  802bdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be3:	a1 34 52 80 00       	mov    0x805234,%eax
  802be8:	40                   	inc    %eax
  802be9:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802bee:	ff 45 f4             	incl   -0xc(%ebp)
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bf7:	0f 8c 2c ff ff ff    	jl     802b29 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802bfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802c04:	eb 36                	jmp    802c3c <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	c1 e0 04             	shl    $0x4,%eax
  802c0c:	05 60 d2 81 00       	add    $0x81d260,%eax
  802c11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	c1 e0 04             	shl    $0x4,%eax
  802c1d:	05 64 d2 81 00       	add    $0x81d264,%eax
  802c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2b:	c1 e0 04             	shl    $0x4,%eax
  802c2e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802c33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802c39:	ff 45 f0             	incl   -0x10(%ebp)
  802c3c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802c40:	7e c4                	jle    802c06 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802c42:	90                   	nop
  802c43:	c9                   	leave  
  802c44:	c3                   	ret    

00802c45 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802c45:	55                   	push   %ebp
  802c46:	89 e5                	mov    %esp,%ebp
  802c48:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	83 ec 0c             	sub    $0xc,%esp
  802c51:	50                   	push   %eax
  802c52:	e8 0b fe ff ff       	call   802a62 <to_page_info>
  802c57:	83 c4 10             	add    $0x10,%esp
  802c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 08             	mov    0x8(%eax),%eax
  802c63:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802c66:	c9                   	leave  
  802c67:	c3                   	ret    

00802c68 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802c68:	55                   	push   %ebp
  802c69:	89 e5                	mov    %esp,%ebp
  802c6b:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802c6e:	83 ec 0c             	sub    $0xc,%esp
  802c71:	ff 75 0c             	pushl  0xc(%ebp)
  802c74:	e8 77 fd ff ff       	call   8029f0 <to_page_va>
  802c79:	83 c4 10             	add    $0x10,%esp
  802c7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802c7f:	b8 00 10 00 00       	mov    $0x1000,%eax
  802c84:	ba 00 00 00 00       	mov    $0x0,%edx
  802c89:	f7 75 08             	divl   0x8(%ebp)
  802c8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c92:	83 ec 0c             	sub    $0xc,%esp
  802c95:	50                   	push   %eax
  802c96:	e8 48 f6 ff ff       	call   8022e3 <get_page>
  802c9b:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca4:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cae:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802cb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802cb9:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802cc0:	eb 19                	jmp    802cdb <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc5:	ba 01 00 00 00       	mov    $0x1,%edx
  802cca:	88 c1                	mov    %al,%cl
  802ccc:	d3 e2                	shl    %cl,%edx
  802cce:	89 d0                	mov    %edx,%eax
  802cd0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd3:	74 0e                	je     802ce3 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802cd5:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802cd8:	ff 45 f0             	incl   -0x10(%ebp)
  802cdb:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802cdf:	7e e1                	jle    802cc2 <split_page_to_blocks+0x5a>
  802ce1:	eb 01                	jmp    802ce4 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802ce3:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802ce4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802ceb:	e9 a7 00 00 00       	jmp    802d97 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf3:	0f af 45 08          	imul   0x8(%ebp),%eax
  802cf7:	89 c2                	mov    %eax,%edx
  802cf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfc:	01 d0                	add    %edx,%eax
  802cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802d01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d05:	75 14                	jne    802d1b <split_page_to_blocks+0xb3>
  802d07:	83 ec 04             	sub    $0x4,%esp
  802d0a:	68 fc 44 80 00       	push   $0x8044fc
  802d0f:	6a 7c                	push   $0x7c
  802d11:	68 83 44 80 00       	push   $0x804483
  802d16:	e8 7c 07 00 00       	call   803497 <_panic>
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	c1 e0 04             	shl    $0x4,%eax
  802d21:	05 64 d2 81 00       	add    $0x81d264,%eax
  802d26:	8b 10                	mov    (%eax),%edx
  802d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2b:	89 50 04             	mov    %edx,0x4(%eax)
  802d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d31:	8b 40 04             	mov    0x4(%eax),%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	74 14                	je     802d4c <split_page_to_blocks+0xe4>
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	c1 e0 04             	shl    $0x4,%eax
  802d3e:	05 64 d2 81 00       	add    $0x81d264,%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d48:	89 10                	mov    %edx,(%eax)
  802d4a:	eb 11                	jmp    802d5d <split_page_to_blocks+0xf5>
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	c1 e0 04             	shl    $0x4,%eax
  802d52:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  802d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5b:	89 02                	mov    %eax,(%edx)
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	c1 e0 04             	shl    $0x4,%eax
  802d63:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  802d69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d6c:	89 02                	mov    %eax,(%edx)
  802d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	c1 e0 04             	shl    $0x4,%eax
  802d7d:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	8d 50 01             	lea    0x1(%eax),%edx
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	c1 e0 04             	shl    $0x4,%eax
  802d8d:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802d92:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802d94:	ff 45 ec             	incl   -0x14(%ebp)
  802d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802d9d:	0f 82 4d ff ff ff    	jb     802cf0 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802da3:	90                   	nop
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
  802da9:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802dac:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802db3:	76 19                	jbe    802dce <alloc_block+0x28>
  802db5:	68 20 45 80 00       	push   $0x804520
  802dba:	68 e6 44 80 00       	push   $0x8044e6
  802dbf:	68 8a 00 00 00       	push   $0x8a
  802dc4:	68 83 44 80 00       	push   $0x804483
  802dc9:	e8 c9 06 00 00       	call   803497 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802dce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802dd5:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802ddc:	eb 19                	jmp    802df7 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	ba 01 00 00 00       	mov    $0x1,%edx
  802de6:	88 c1                	mov    %al,%cl
  802de8:	d3 e2                	shl    %cl,%edx
  802dea:	89 d0                	mov    %edx,%eax
  802dec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802def:	73 0e                	jae    802dff <alloc_block+0x59>
		idx++;
  802df1:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802df4:	ff 45 f0             	incl   -0x10(%ebp)
  802df7:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802dfb:	7e e1                	jle    802dde <alloc_block+0x38>
  802dfd:	eb 01                	jmp    802e00 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802dff:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	c1 e0 04             	shl    $0x4,%eax
  802e06:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	85 c0                	test   %eax,%eax
  802e0f:	0f 84 df 00 00 00    	je     802ef4 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	c1 e0 04             	shl    $0x4,%eax
  802e1b:	05 60 d2 81 00       	add    $0x81d260,%eax
  802e20:	8b 00                	mov    (%eax),%eax
  802e22:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802e25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e29:	75 17                	jne    802e42 <alloc_block+0x9c>
  802e2b:	83 ec 04             	sub    $0x4,%esp
  802e2e:	68 41 45 80 00       	push   $0x804541
  802e33:	68 9e 00 00 00       	push   $0x9e
  802e38:	68 83 44 80 00       	push   $0x804483
  802e3d:	e8 55 06 00 00       	call   803497 <_panic>
  802e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 10                	je     802e5b <alloc_block+0xb5>
  802e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e53:	8b 52 04             	mov    0x4(%edx),%edx
  802e56:	89 50 04             	mov    %edx,0x4(%eax)
  802e59:	eb 14                	jmp    802e6f <alloc_block+0xc9>
  802e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5e:	8b 40 04             	mov    0x4(%eax),%eax
  802e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e64:	c1 e2 04             	shl    $0x4,%edx
  802e67:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  802e6d:	89 02                	mov    %eax,(%edx)
  802e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 0f                	je     802e88 <alloc_block+0xe2>
  802e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7c:	8b 40 04             	mov    0x4(%eax),%eax
  802e7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e82:	8b 12                	mov    (%edx),%edx
  802e84:	89 10                	mov    %edx,(%eax)
  802e86:	eb 13                	jmp    802e9b <alloc_block+0xf5>
  802e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e90:	c1 e2 04             	shl    $0x4,%edx
  802e93:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  802e99:	89 02                	mov    %eax,(%edx)
  802e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	c1 e0 04             	shl    $0x4,%eax
  802eb4:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	8d 50 ff             	lea    -0x1(%eax),%edx
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	c1 e0 04             	shl    $0x4,%eax
  802ec4:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802ec9:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ece:	83 ec 0c             	sub    $0xc,%esp
  802ed1:	50                   	push   %eax
  802ed2:	e8 8b fb ff ff       	call   802a62 <to_page_info>
  802ed7:	83 c4 10             	add    $0x10,%esp
  802eda:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802edd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802ee4:	48                   	dec    %eax
  802ee5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ee8:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eef:	e9 bc 02 00 00       	jmp    8031b0 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802ef4:	a1 34 52 80 00       	mov    0x805234,%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	0f 84 7d 02 00 00    	je     80317e <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802f01:	a1 28 52 80 00       	mov    0x805228,%eax
  802f06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802f09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f0d:	75 17                	jne    802f26 <alloc_block+0x180>
  802f0f:	83 ec 04             	sub    $0x4,%esp
  802f12:	68 41 45 80 00       	push   $0x804541
  802f17:	68 a9 00 00 00       	push   $0xa9
  802f1c:	68 83 44 80 00       	push   $0x804483
  802f21:	e8 71 05 00 00       	call   803497 <_panic>
  802f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	85 c0                	test   %eax,%eax
  802f2d:	74 10                	je     802f3f <alloc_block+0x199>
  802f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f32:	8b 00                	mov    (%eax),%eax
  802f34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f37:	8b 52 04             	mov    0x4(%edx),%edx
  802f3a:	89 50 04             	mov    %edx,0x4(%eax)
  802f3d:	eb 0b                	jmp    802f4a <alloc_block+0x1a4>
  802f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f42:	8b 40 04             	mov    0x4(%eax),%eax
  802f45:	a3 2c 52 80 00       	mov    %eax,0x80522c
  802f4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 0f                	je     802f63 <alloc_block+0x1bd>
  802f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f57:	8b 40 04             	mov    0x4(%eax),%eax
  802f5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f5d:	8b 12                	mov    (%edx),%edx
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	eb 0a                	jmp    802f6d <alloc_block+0x1c7>
  802f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f66:	8b 00                	mov    (%eax),%eax
  802f68:	a3 28 52 80 00       	mov    %eax,0x805228
  802f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f80:	a1 34 52 80 00       	mov    0x805234,%eax
  802f85:	48                   	dec    %eax
  802f86:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	83 c0 03             	add    $0x3,%eax
  802f91:	ba 01 00 00 00       	mov    $0x1,%edx
  802f96:	88 c1                	mov    %al,%cl
  802f98:	d3 e2                	shl    %cl,%edx
  802f9a:	89 d0                	mov    %edx,%eax
  802f9c:	83 ec 08             	sub    $0x8,%esp
  802f9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fa2:	50                   	push   %eax
  802fa3:	e8 c0 fc ff ff       	call   802c68 <split_page_to_blocks>
  802fa8:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	c1 e0 04             	shl    $0x4,%eax
  802fb1:	05 60 d2 81 00       	add    $0x81d260,%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802fbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fbf:	75 17                	jne    802fd8 <alloc_block+0x232>
  802fc1:	83 ec 04             	sub    $0x4,%esp
  802fc4:	68 41 45 80 00       	push   $0x804541
  802fc9:	68 b0 00 00 00       	push   $0xb0
  802fce:	68 83 44 80 00       	push   $0x804483
  802fd3:	e8 bf 04 00 00       	call   803497 <_panic>
  802fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 10                	je     802ff1 <alloc_block+0x24b>
  802fe1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fe9:	8b 52 04             	mov    0x4(%edx),%edx
  802fec:	89 50 04             	mov    %edx,0x4(%eax)
  802fef:	eb 14                	jmp    803005 <alloc_block+0x25f>
  802ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff4:	8b 40 04             	mov    0x4(%eax),%eax
  802ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffa:	c1 e2 04             	shl    $0x4,%edx
  802ffd:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803003:	89 02                	mov    %eax,(%edx)
  803005:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 0f                	je     80301e <alloc_block+0x278>
  80300f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803012:	8b 40 04             	mov    0x4(%eax),%eax
  803015:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803018:	8b 12                	mov    (%edx),%edx
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	eb 13                	jmp    803031 <alloc_block+0x28b>
  80301e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803026:	c1 e2 04             	shl    $0x4,%edx
  803029:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80302f:	89 02                	mov    %eax,(%edx)
  803031:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	c1 e0 04             	shl    $0x4,%eax
  80304a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	8d 50 ff             	lea    -0x1(%eax),%edx
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	c1 e0 04             	shl    $0x4,%eax
  80305a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80305f:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803061:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803064:	83 ec 0c             	sub    $0xc,%esp
  803067:	50                   	push   %eax
  803068:	e8 f5 f9 ff ff       	call   802a62 <to_page_info>
  80306d:	83 c4 10             	add    $0x10,%esp
  803070:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  803073:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803076:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80307a:	48                   	dec    %eax
  80307b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80307e:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803082:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803085:	e9 26 01 00 00       	jmp    8031b0 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80308a:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	c1 e0 04             	shl    $0x4,%eax
  803093:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	0f 84 dc 00 00 00    	je     80317e <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	c1 e0 04             	shl    $0x4,%eax
  8030a8:	05 60 d2 81 00       	add    $0x81d260,%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8030b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8030b6:	75 17                	jne    8030cf <alloc_block+0x329>
  8030b8:	83 ec 04             	sub    $0x4,%esp
  8030bb:	68 41 45 80 00       	push   $0x804541
  8030c0:	68 be 00 00 00       	push   $0xbe
  8030c5:	68 83 44 80 00       	push   $0x804483
  8030ca:	e8 c8 03 00 00       	call   803497 <_panic>
  8030cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 10                	je     8030e8 <alloc_block+0x342>
  8030d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030e0:	8b 52 04             	mov    0x4(%edx),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%eax)
  8030e6:	eb 14                	jmp    8030fc <alloc_block+0x356>
  8030e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030eb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f1:	c1 e2 04             	shl    $0x4,%edx
  8030f4:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8030fa:	89 02                	mov    %eax,(%edx)
  8030fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	85 c0                	test   %eax,%eax
  803104:	74 0f                	je     803115 <alloc_block+0x36f>
  803106:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803109:	8b 40 04             	mov    0x4(%eax),%eax
  80310c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80310f:	8b 12                	mov    (%edx),%edx
  803111:	89 10                	mov    %edx,(%eax)
  803113:	eb 13                	jmp    803128 <alloc_block+0x382>
  803115:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803118:	8b 00                	mov    (%eax),%eax
  80311a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80311d:	c1 e2 04             	shl    $0x4,%edx
  803120:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803126:	89 02                	mov    %eax,(%edx)
  803128:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80312b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803131:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803134:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	c1 e0 04             	shl    $0x4,%eax
  803141:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	8d 50 ff             	lea    -0x1(%eax),%edx
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	c1 e0 04             	shl    $0x4,%eax
  803151:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803156:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803158:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80315b:	83 ec 0c             	sub    $0xc,%esp
  80315e:	50                   	push   %eax
  80315f:	e8 fe f8 ff ff       	call   802a62 <to_page_info>
  803164:	83 c4 10             	add    $0x10,%esp
  803167:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80316a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80316d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803171:	48                   	dec    %eax
  803172:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803175:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803179:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80317c:	eb 32                	jmp    8031b0 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80317e:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803182:	77 15                	ja     803199 <alloc_block+0x3f3>
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	c1 e0 04             	shl    $0x4,%eax
  80318a:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	0f 84 f1 fe ff ff    	je     80308a <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  803199:	83 ec 04             	sub    $0x4,%esp
  80319c:	68 5f 45 80 00       	push   $0x80455f
  8031a1:	68 c8 00 00 00       	push   $0xc8
  8031a6:	68 83 44 80 00       	push   $0x804483
  8031ab:	e8 e7 02 00 00       	call   803497 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8031b0:	c9                   	leave  
  8031b1:	c3                   	ret    

008031b2 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8031b2:	55                   	push   %ebp
  8031b3:	89 e5                	mov    %esp,%ebp
  8031b5:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8031b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bb:	a1 48 d2 81 00       	mov    0x81d248,%eax
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	72 0c                	jb     8031d0 <free_block+0x1e>
  8031c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c7:	a1 20 52 80 00       	mov    0x805220,%eax
  8031cc:	39 c2                	cmp    %eax,%edx
  8031ce:	72 19                	jb     8031e9 <free_block+0x37>
  8031d0:	68 70 45 80 00       	push   $0x804570
  8031d5:	68 e6 44 80 00       	push   $0x8044e6
  8031da:	68 d7 00 00 00       	push   $0xd7
  8031df:	68 83 44 80 00       	push   $0x804483
  8031e4:	e8 ae 02 00 00       	call   803497 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	83 ec 0c             	sub    $0xc,%esp
  8031f5:	50                   	push   %eax
  8031f6:	e8 67 f8 ff ff       	call   802a62 <to_page_info>
  8031fb:	83 c4 10             	add    $0x10,%esp
  8031fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  803201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803204:	8b 40 08             	mov    0x8(%eax),%eax
  803207:	0f b7 c0             	movzwl %ax,%eax
  80320a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80320d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803214:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80321b:	eb 19                	jmp    803236 <free_block+0x84>
	    if ((1 << i) == blk_size)
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	ba 01 00 00 00       	mov    $0x1,%edx
  803225:	88 c1                	mov    %al,%cl
  803227:	d3 e2                	shl    %cl,%edx
  803229:	89 d0                	mov    %edx,%eax
  80322b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80322e:	74 0e                	je     80323e <free_block+0x8c>
	        break;
	    idx++;
  803230:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803233:	ff 45 f0             	incl   -0x10(%ebp)
  803236:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80323a:	7e e1                	jle    80321d <free_block+0x6b>
  80323c:	eb 01                	jmp    80323f <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  80323e:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  80323f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803242:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803246:	40                   	inc    %eax
  803247:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80324a:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  80324e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803252:	75 17                	jne    80326b <free_block+0xb9>
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	68 fc 44 80 00       	push   $0x8044fc
  80325c:	68 ee 00 00 00       	push   $0xee
  803261:	68 83 44 80 00       	push   $0x804483
  803266:	e8 2c 02 00 00       	call   803497 <_panic>
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	c1 e0 04             	shl    $0x4,%eax
  803271:	05 64 d2 81 00       	add    $0x81d264,%eax
  803276:	8b 10                	mov    (%eax),%edx
  803278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327b:	89 50 04             	mov    %edx,0x4(%eax)
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	8b 40 04             	mov    0x4(%eax),%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 14                	je     80329c <free_block+0xea>
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	c1 e0 04             	shl    $0x4,%eax
  80328e:	05 64 d2 81 00       	add    $0x81d264,%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	eb 11                	jmp    8032ad <free_block+0xfb>
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	c1 e0 04             	shl    $0x4,%eax
  8032a2:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8032a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ab:	89 02                	mov    %eax,(%edx)
  8032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b0:	c1 e0 04             	shl    $0x4,%eax
  8032b3:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8032b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bc:	89 02                	mov    %eax,(%edx)
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	c1 e0 04             	shl    $0x4,%eax
  8032cd:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	8d 50 01             	lea    0x1(%eax),%edx
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	c1 e0 04             	shl    $0x4,%eax
  8032dd:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8032e2:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8032e4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ee:	f7 75 e0             	divl   -0x20(%ebp)
  8032f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8032f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032fb:	0f b7 c0             	movzwl %ax,%eax
  8032fe:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803301:	0f 85 70 01 00 00    	jne    803477 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803307:	83 ec 0c             	sub    $0xc,%esp
  80330a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80330d:	e8 de f6 ff ff       	call   8029f0 <to_page_va>
  803312:	83 c4 10             	add    $0x10,%esp
  803315:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803318:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80331f:	e9 b7 00 00 00       	jmp    8033db <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  803324:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332a:	01 d0                	add    %edx,%eax
  80332c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  80332f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803333:	75 17                	jne    80334c <free_block+0x19a>
  803335:	83 ec 04             	sub    $0x4,%esp
  803338:	68 41 45 80 00       	push   $0x804541
  80333d:	68 f8 00 00 00       	push   $0xf8
  803342:	68 83 44 80 00       	push   $0x804483
  803347:	e8 4b 01 00 00       	call   803497 <_panic>
  80334c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334f:	8b 00                	mov    (%eax),%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 10                	je     803365 <free_block+0x1b3>
  803355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80335d:	8b 52 04             	mov    0x4(%edx),%edx
  803360:	89 50 04             	mov    %edx,0x4(%eax)
  803363:	eb 14                	jmp    803379 <free_block+0x1c7>
  803365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803368:	8b 40 04             	mov    0x4(%eax),%eax
  80336b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80336e:	c1 e2 04             	shl    $0x4,%edx
  803371:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803377:	89 02                	mov    %eax,(%edx)
  803379:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0f                	je     803392 <free_block+0x1e0>
  803383:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80338c:	8b 12                	mov    (%edx),%edx
  80338e:	89 10                	mov    %edx,(%eax)
  803390:	eb 13                	jmp    8033a5 <free_block+0x1f3>
  803392:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80339a:	c1 e2 04             	shl    $0x4,%edx
  80339d:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8033a3:	89 02                	mov    %eax,(%edx)
  8033a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	c1 e0 04             	shl    $0x4,%eax
  8033be:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cb:	c1 e0 04             	shl    $0x4,%eax
  8033ce:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8033d3:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8033d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d8:	01 45 ec             	add    %eax,-0x14(%ebp)
  8033db:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8033e2:	0f 86 3c ff ff ff    	jbe    803324 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8033e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033eb:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8033f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f4:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8033fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033fe:	75 17                	jne    803417 <free_block+0x265>
  803400:	83 ec 04             	sub    $0x4,%esp
  803403:	68 fc 44 80 00       	push   $0x8044fc
  803408:	68 fe 00 00 00       	push   $0xfe
  80340d:	68 83 44 80 00       	push   $0x804483
  803412:	e8 80 00 00 00       	call   803497 <_panic>
  803417:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  80341d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803420:	89 50 04             	mov    %edx,0x4(%eax)
  803423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803426:	8b 40 04             	mov    0x4(%eax),%eax
  803429:	85 c0                	test   %eax,%eax
  80342b:	74 0c                	je     803439 <free_block+0x287>
  80342d:	a1 2c 52 80 00       	mov    0x80522c,%eax
  803432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803435:	89 10                	mov    %edx,(%eax)
  803437:	eb 08                	jmp    803441 <free_block+0x28f>
  803439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343c:	a3 28 52 80 00       	mov    %eax,0x805228
  803441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803444:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803452:	a1 34 52 80 00       	mov    0x805234,%eax
  803457:	40                   	inc    %eax
  803458:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80345d:	83 ec 0c             	sub    $0xc,%esp
  803460:	ff 75 e4             	pushl  -0x1c(%ebp)
  803463:	e8 88 f5 ff ff       	call   8029f0 <to_page_va>
  803468:	83 c4 10             	add    $0x10,%esp
  80346b:	83 ec 0c             	sub    $0xc,%esp
  80346e:	50                   	push   %eax
  80346f:	e8 b8 ee ff ff       	call   80232c <return_page>
  803474:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803477:	90                   	nop
  803478:	c9                   	leave  
  803479:	c3                   	ret    

0080347a <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80347a:	55                   	push   %ebp
  80347b:	89 e5                	mov    %esp,%ebp
  80347d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	68 a8 45 80 00       	push   $0x8045a8
  803488:	68 11 01 00 00       	push   $0x111
  80348d:	68 83 44 80 00       	push   $0x804483
  803492:	e8 00 00 00 00       	call   803497 <_panic>

00803497 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803497:	55                   	push   %ebp
  803498:	89 e5                	mov    %esp,%ebp
  80349a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80349d:	8d 45 10             	lea    0x10(%ebp),%eax
  8034a0:	83 c0 04             	add    $0x4,%eax
  8034a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8034a6:	a1 fc d2 81 00       	mov    0x81d2fc,%eax
  8034ab:	85 c0                	test   %eax,%eax
  8034ad:	74 16                	je     8034c5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8034af:	a1 fc d2 81 00       	mov    0x81d2fc,%eax
  8034b4:	83 ec 08             	sub    $0x8,%esp
  8034b7:	50                   	push   %eax
  8034b8:	68 cc 45 80 00       	push   $0x8045cc
  8034bd:	e8 e8 de ff ff       	call   8013aa <cprintf>
  8034c2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8034c5:	a1 04 50 80 00       	mov    0x805004,%eax
  8034ca:	83 ec 0c             	sub    $0xc,%esp
  8034cd:	ff 75 0c             	pushl  0xc(%ebp)
  8034d0:	ff 75 08             	pushl  0x8(%ebp)
  8034d3:	50                   	push   %eax
  8034d4:	68 d4 45 80 00       	push   $0x8045d4
  8034d9:	6a 74                	push   $0x74
  8034db:	e8 f7 de ff ff       	call   8013d7 <cprintf_colored>
  8034e0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8034e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8034e6:	83 ec 08             	sub    $0x8,%esp
  8034e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8034ec:	50                   	push   %eax
  8034ed:	e8 49 de ff ff       	call   80133b <vcprintf>
  8034f2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8034f5:	83 ec 08             	sub    $0x8,%esp
  8034f8:	6a 00                	push   $0x0
  8034fa:	68 fc 45 80 00       	push   $0x8045fc
  8034ff:	e8 37 de ff ff       	call   80133b <vcprintf>
  803504:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803507:	e8 b0 dd ff ff       	call   8012bc <exit>

	// should not return here
	while (1) ;
  80350c:	eb fe                	jmp    80350c <_panic+0x75>

0080350e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80350e:	55                   	push   %ebp
  80350f:	89 e5                	mov    %esp,%ebp
  803511:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803514:	a1 00 52 80 00       	mov    0x805200,%eax
  803519:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80351f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803522:	39 c2                	cmp    %eax,%edx
  803524:	74 14                	je     80353a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803526:	83 ec 04             	sub    $0x4,%esp
  803529:	68 00 46 80 00       	push   $0x804600
  80352e:	6a 26                	push   $0x26
  803530:	68 4c 46 80 00       	push   $0x80464c
  803535:	e8 5d ff ff ff       	call   803497 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80353a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803541:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803548:	e9 c5 00 00 00       	jmp    803612 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803550:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803557:	8b 45 08             	mov    0x8(%ebp),%eax
  80355a:	01 d0                	add    %edx,%eax
  80355c:	8b 00                	mov    (%eax),%eax
  80355e:	85 c0                	test   %eax,%eax
  803560:	75 08                	jne    80356a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803562:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803565:	e9 a5 00 00 00       	jmp    80360f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80356a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803571:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803578:	eb 69                	jmp    8035e3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80357a:	a1 00 52 80 00       	mov    0x805200,%eax
  80357f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  803585:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803588:	89 d0                	mov    %edx,%eax
  80358a:	01 c0                	add    %eax,%eax
  80358c:	01 d0                	add    %edx,%eax
  80358e:	c1 e0 03             	shl    $0x3,%eax
  803591:	01 c8                	add    %ecx,%eax
  803593:	8a 40 04             	mov    0x4(%eax),%al
  803596:	84 c0                	test   %al,%al
  803598:	75 46                	jne    8035e0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80359a:	a1 00 52 80 00       	mov    0x805200,%eax
  80359f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8035a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035a8:	89 d0                	mov    %edx,%eax
  8035aa:	01 c0                	add    %eax,%eax
  8035ac:	01 d0                	add    %edx,%eax
  8035ae:	c1 e0 03             	shl    $0x3,%eax
  8035b1:	01 c8                	add    %ecx,%eax
  8035b3:	8b 00                	mov    (%eax),%eax
  8035b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8035b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8035c0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8035c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	01 c8                	add    %ecx,%eax
  8035d1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8035d3:	39 c2                	cmp    %eax,%edx
  8035d5:	75 09                	jne    8035e0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8035d7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8035de:	eb 15                	jmp    8035f5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035e0:	ff 45 e8             	incl   -0x18(%ebp)
  8035e3:	a1 00 52 80 00       	mov    0x805200,%eax
  8035e8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8035ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f1:	39 c2                	cmp    %eax,%edx
  8035f3:	77 85                	ja     80357a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8035f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035f9:	75 14                	jne    80360f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8035fb:	83 ec 04             	sub    $0x4,%esp
  8035fe:	68 58 46 80 00       	push   $0x804658
  803603:	6a 3a                	push   $0x3a
  803605:	68 4c 46 80 00       	push   $0x80464c
  80360a:	e8 88 fe ff ff       	call   803497 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80360f:	ff 45 f0             	incl   -0x10(%ebp)
  803612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803615:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803618:	0f 8c 2f ff ff ff    	jl     80354d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80361e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803625:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80362c:	eb 26                	jmp    803654 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80362e:	a1 00 52 80 00       	mov    0x805200,%eax
  803633:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  803639:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80363c:	89 d0                	mov    %edx,%eax
  80363e:	01 c0                	add    %eax,%eax
  803640:	01 d0                	add    %edx,%eax
  803642:	c1 e0 03             	shl    $0x3,%eax
  803645:	01 c8                	add    %ecx,%eax
  803647:	8a 40 04             	mov    0x4(%eax),%al
  80364a:	3c 01                	cmp    $0x1,%al
  80364c:	75 03                	jne    803651 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80364e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803651:	ff 45 e0             	incl   -0x20(%ebp)
  803654:	a1 00 52 80 00       	mov    0x805200,%eax
  803659:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80365f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803662:	39 c2                	cmp    %eax,%edx
  803664:	77 c8                	ja     80362e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803669:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80366c:	74 14                	je     803682 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80366e:	83 ec 04             	sub    $0x4,%esp
  803671:	68 ac 46 80 00       	push   $0x8046ac
  803676:	6a 44                	push   $0x44
  803678:	68 4c 46 80 00       	push   $0x80464c
  80367d:	e8 15 fe ff ff       	call   803497 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803682:	90                   	nop
  803683:	c9                   	leave  
  803684:	c3                   	ret    
  803685:	66 90                	xchg   %ax,%ax
  803687:	90                   	nop

00803688 <__udivdi3>:
  803688:	55                   	push   %ebp
  803689:	57                   	push   %edi
  80368a:	56                   	push   %esi
  80368b:	53                   	push   %ebx
  80368c:	83 ec 1c             	sub    $0x1c,%esp
  80368f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803693:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803697:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80369b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80369f:	89 ca                	mov    %ecx,%edx
  8036a1:	89 f8                	mov    %edi,%eax
  8036a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036a7:	85 f6                	test   %esi,%esi
  8036a9:	75 2d                	jne    8036d8 <__udivdi3+0x50>
  8036ab:	39 cf                	cmp    %ecx,%edi
  8036ad:	77 65                	ja     803714 <__udivdi3+0x8c>
  8036af:	89 fd                	mov    %edi,%ebp
  8036b1:	85 ff                	test   %edi,%edi
  8036b3:	75 0b                	jne    8036c0 <__udivdi3+0x38>
  8036b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ba:	31 d2                	xor    %edx,%edx
  8036bc:	f7 f7                	div    %edi
  8036be:	89 c5                	mov    %eax,%ebp
  8036c0:	31 d2                	xor    %edx,%edx
  8036c2:	89 c8                	mov    %ecx,%eax
  8036c4:	f7 f5                	div    %ebp
  8036c6:	89 c1                	mov    %eax,%ecx
  8036c8:	89 d8                	mov    %ebx,%eax
  8036ca:	f7 f5                	div    %ebp
  8036cc:	89 cf                	mov    %ecx,%edi
  8036ce:	89 fa                	mov    %edi,%edx
  8036d0:	83 c4 1c             	add    $0x1c,%esp
  8036d3:	5b                   	pop    %ebx
  8036d4:	5e                   	pop    %esi
  8036d5:	5f                   	pop    %edi
  8036d6:	5d                   	pop    %ebp
  8036d7:	c3                   	ret    
  8036d8:	39 ce                	cmp    %ecx,%esi
  8036da:	77 28                	ja     803704 <__udivdi3+0x7c>
  8036dc:	0f bd fe             	bsr    %esi,%edi
  8036df:	83 f7 1f             	xor    $0x1f,%edi
  8036e2:	75 40                	jne    803724 <__udivdi3+0x9c>
  8036e4:	39 ce                	cmp    %ecx,%esi
  8036e6:	72 0a                	jb     8036f2 <__udivdi3+0x6a>
  8036e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036ec:	0f 87 9e 00 00 00    	ja     803790 <__udivdi3+0x108>
  8036f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f7:	89 fa                	mov    %edi,%edx
  8036f9:	83 c4 1c             	add    $0x1c,%esp
  8036fc:	5b                   	pop    %ebx
  8036fd:	5e                   	pop    %esi
  8036fe:	5f                   	pop    %edi
  8036ff:	5d                   	pop    %ebp
  803700:	c3                   	ret    
  803701:	8d 76 00             	lea    0x0(%esi),%esi
  803704:	31 ff                	xor    %edi,%edi
  803706:	31 c0                	xor    %eax,%eax
  803708:	89 fa                	mov    %edi,%edx
  80370a:	83 c4 1c             	add    $0x1c,%esp
  80370d:	5b                   	pop    %ebx
  80370e:	5e                   	pop    %esi
  80370f:	5f                   	pop    %edi
  803710:	5d                   	pop    %ebp
  803711:	c3                   	ret    
  803712:	66 90                	xchg   %ax,%ax
  803714:	89 d8                	mov    %ebx,%eax
  803716:	f7 f7                	div    %edi
  803718:	31 ff                	xor    %edi,%edi
  80371a:	89 fa                	mov    %edi,%edx
  80371c:	83 c4 1c             	add    $0x1c,%esp
  80371f:	5b                   	pop    %ebx
  803720:	5e                   	pop    %esi
  803721:	5f                   	pop    %edi
  803722:	5d                   	pop    %ebp
  803723:	c3                   	ret    
  803724:	bd 20 00 00 00       	mov    $0x20,%ebp
  803729:	89 eb                	mov    %ebp,%ebx
  80372b:	29 fb                	sub    %edi,%ebx
  80372d:	89 f9                	mov    %edi,%ecx
  80372f:	d3 e6                	shl    %cl,%esi
  803731:	89 c5                	mov    %eax,%ebp
  803733:	88 d9                	mov    %bl,%cl
  803735:	d3 ed                	shr    %cl,%ebp
  803737:	89 e9                	mov    %ebp,%ecx
  803739:	09 f1                	or     %esi,%ecx
  80373b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80373f:	89 f9                	mov    %edi,%ecx
  803741:	d3 e0                	shl    %cl,%eax
  803743:	89 c5                	mov    %eax,%ebp
  803745:	89 d6                	mov    %edx,%esi
  803747:	88 d9                	mov    %bl,%cl
  803749:	d3 ee                	shr    %cl,%esi
  80374b:	89 f9                	mov    %edi,%ecx
  80374d:	d3 e2                	shl    %cl,%edx
  80374f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803753:	88 d9                	mov    %bl,%cl
  803755:	d3 e8                	shr    %cl,%eax
  803757:	09 c2                	or     %eax,%edx
  803759:	89 d0                	mov    %edx,%eax
  80375b:	89 f2                	mov    %esi,%edx
  80375d:	f7 74 24 0c          	divl   0xc(%esp)
  803761:	89 d6                	mov    %edx,%esi
  803763:	89 c3                	mov    %eax,%ebx
  803765:	f7 e5                	mul    %ebp
  803767:	39 d6                	cmp    %edx,%esi
  803769:	72 19                	jb     803784 <__udivdi3+0xfc>
  80376b:	74 0b                	je     803778 <__udivdi3+0xf0>
  80376d:	89 d8                	mov    %ebx,%eax
  80376f:	31 ff                	xor    %edi,%edi
  803771:	e9 58 ff ff ff       	jmp    8036ce <__udivdi3+0x46>
  803776:	66 90                	xchg   %ax,%ax
  803778:	8b 54 24 08          	mov    0x8(%esp),%edx
  80377c:	89 f9                	mov    %edi,%ecx
  80377e:	d3 e2                	shl    %cl,%edx
  803780:	39 c2                	cmp    %eax,%edx
  803782:	73 e9                	jae    80376d <__udivdi3+0xe5>
  803784:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803787:	31 ff                	xor    %edi,%edi
  803789:	e9 40 ff ff ff       	jmp    8036ce <__udivdi3+0x46>
  80378e:	66 90                	xchg   %ax,%ax
  803790:	31 c0                	xor    %eax,%eax
  803792:	e9 37 ff ff ff       	jmp    8036ce <__udivdi3+0x46>
  803797:	90                   	nop

00803798 <__umoddi3>:
  803798:	55                   	push   %ebp
  803799:	57                   	push   %edi
  80379a:	56                   	push   %esi
  80379b:	53                   	push   %ebx
  80379c:	83 ec 1c             	sub    $0x1c,%esp
  80379f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037b7:	89 f3                	mov    %esi,%ebx
  8037b9:	89 fa                	mov    %edi,%edx
  8037bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037bf:	89 34 24             	mov    %esi,(%esp)
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	75 1a                	jne    8037e0 <__umoddi3+0x48>
  8037c6:	39 f7                	cmp    %esi,%edi
  8037c8:	0f 86 a2 00 00 00    	jbe    803870 <__umoddi3+0xd8>
  8037ce:	89 c8                	mov    %ecx,%eax
  8037d0:	89 f2                	mov    %esi,%edx
  8037d2:	f7 f7                	div    %edi
  8037d4:	89 d0                	mov    %edx,%eax
  8037d6:	31 d2                	xor    %edx,%edx
  8037d8:	83 c4 1c             	add    $0x1c,%esp
  8037db:	5b                   	pop    %ebx
  8037dc:	5e                   	pop    %esi
  8037dd:	5f                   	pop    %edi
  8037de:	5d                   	pop    %ebp
  8037df:	c3                   	ret    
  8037e0:	39 f0                	cmp    %esi,%eax
  8037e2:	0f 87 ac 00 00 00    	ja     803894 <__umoddi3+0xfc>
  8037e8:	0f bd e8             	bsr    %eax,%ebp
  8037eb:	83 f5 1f             	xor    $0x1f,%ebp
  8037ee:	0f 84 ac 00 00 00    	je     8038a0 <__umoddi3+0x108>
  8037f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8037f9:	29 ef                	sub    %ebp,%edi
  8037fb:	89 fe                	mov    %edi,%esi
  8037fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803801:	89 e9                	mov    %ebp,%ecx
  803803:	d3 e0                	shl    %cl,%eax
  803805:	89 d7                	mov    %edx,%edi
  803807:	89 f1                	mov    %esi,%ecx
  803809:	d3 ef                	shr    %cl,%edi
  80380b:	09 c7                	or     %eax,%edi
  80380d:	89 e9                	mov    %ebp,%ecx
  80380f:	d3 e2                	shl    %cl,%edx
  803811:	89 14 24             	mov    %edx,(%esp)
  803814:	89 d8                	mov    %ebx,%eax
  803816:	d3 e0                	shl    %cl,%eax
  803818:	89 c2                	mov    %eax,%edx
  80381a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80381e:	d3 e0                	shl    %cl,%eax
  803820:	89 44 24 04          	mov    %eax,0x4(%esp)
  803824:	8b 44 24 08          	mov    0x8(%esp),%eax
  803828:	89 f1                	mov    %esi,%ecx
  80382a:	d3 e8                	shr    %cl,%eax
  80382c:	09 d0                	or     %edx,%eax
  80382e:	d3 eb                	shr    %cl,%ebx
  803830:	89 da                	mov    %ebx,%edx
  803832:	f7 f7                	div    %edi
  803834:	89 d3                	mov    %edx,%ebx
  803836:	f7 24 24             	mull   (%esp)
  803839:	89 c6                	mov    %eax,%esi
  80383b:	89 d1                	mov    %edx,%ecx
  80383d:	39 d3                	cmp    %edx,%ebx
  80383f:	0f 82 87 00 00 00    	jb     8038cc <__umoddi3+0x134>
  803845:	0f 84 91 00 00 00    	je     8038dc <__umoddi3+0x144>
  80384b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80384f:	29 f2                	sub    %esi,%edx
  803851:	19 cb                	sbb    %ecx,%ebx
  803853:	89 d8                	mov    %ebx,%eax
  803855:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803859:	d3 e0                	shl    %cl,%eax
  80385b:	89 e9                	mov    %ebp,%ecx
  80385d:	d3 ea                	shr    %cl,%edx
  80385f:	09 d0                	or     %edx,%eax
  803861:	89 e9                	mov    %ebp,%ecx
  803863:	d3 eb                	shr    %cl,%ebx
  803865:	89 da                	mov    %ebx,%edx
  803867:	83 c4 1c             	add    $0x1c,%esp
  80386a:	5b                   	pop    %ebx
  80386b:	5e                   	pop    %esi
  80386c:	5f                   	pop    %edi
  80386d:	5d                   	pop    %ebp
  80386e:	c3                   	ret    
  80386f:	90                   	nop
  803870:	89 fd                	mov    %edi,%ebp
  803872:	85 ff                	test   %edi,%edi
  803874:	75 0b                	jne    803881 <__umoddi3+0xe9>
  803876:	b8 01 00 00 00       	mov    $0x1,%eax
  80387b:	31 d2                	xor    %edx,%edx
  80387d:	f7 f7                	div    %edi
  80387f:	89 c5                	mov    %eax,%ebp
  803881:	89 f0                	mov    %esi,%eax
  803883:	31 d2                	xor    %edx,%edx
  803885:	f7 f5                	div    %ebp
  803887:	89 c8                	mov    %ecx,%eax
  803889:	f7 f5                	div    %ebp
  80388b:	89 d0                	mov    %edx,%eax
  80388d:	e9 44 ff ff ff       	jmp    8037d6 <__umoddi3+0x3e>
  803892:	66 90                	xchg   %ax,%ax
  803894:	89 c8                	mov    %ecx,%eax
  803896:	89 f2                	mov    %esi,%edx
  803898:	83 c4 1c             	add    $0x1c,%esp
  80389b:	5b                   	pop    %ebx
  80389c:	5e                   	pop    %esi
  80389d:	5f                   	pop    %edi
  80389e:	5d                   	pop    %ebp
  80389f:	c3                   	ret    
  8038a0:	3b 04 24             	cmp    (%esp),%eax
  8038a3:	72 06                	jb     8038ab <__umoddi3+0x113>
  8038a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038a9:	77 0f                	ja     8038ba <__umoddi3+0x122>
  8038ab:	89 f2                	mov    %esi,%edx
  8038ad:	29 f9                	sub    %edi,%ecx
  8038af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038b3:	89 14 24             	mov    %edx,(%esp)
  8038b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038be:	8b 14 24             	mov    (%esp),%edx
  8038c1:	83 c4 1c             	add    $0x1c,%esp
  8038c4:	5b                   	pop    %ebx
  8038c5:	5e                   	pop    %esi
  8038c6:	5f                   	pop    %edi
  8038c7:	5d                   	pop    %ebp
  8038c8:	c3                   	ret    
  8038c9:	8d 76 00             	lea    0x0(%esi),%esi
  8038cc:	2b 04 24             	sub    (%esp),%eax
  8038cf:	19 fa                	sbb    %edi,%edx
  8038d1:	89 d1                	mov    %edx,%ecx
  8038d3:	89 c6                	mov    %eax,%esi
  8038d5:	e9 71 ff ff ff       	jmp    80384b <__umoddi3+0xb3>
  8038da:	66 90                	xchg   %ax,%ax
  8038dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038e0:	72 ea                	jb     8038cc <__umoddi3+0x134>
  8038e2:	89 d9                	mov    %ebx,%ecx
  8038e4:	e9 62 ff ff ff       	jmp    80384b <__umoddi3+0xb3>
